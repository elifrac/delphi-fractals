unit Globs;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//****************************************************************************************
interface
uses
  SysUtils,Windows,Jpeg; {fif; }
type
TFractalTypes = (barnsleyfractal3,cosineset,ExponentSet,hypercos,hypersin,ifssys,
                 juliaset,orbitsfunc,forbits,LegendreFractal,lsystems,magnet1m,mandel,
                 plasmaDisplay,sineset,Sierpinski,RosslerAttractor,LorenzAttractor,
                 TchebychevT5,TchebychevT3,TchebychevC6,juliasetmap,halleymap,land_3d,
                 martin,unityfr,bifurc,circlepattern,Lambda,Biojulia,newton,Spider,MandelFlower,Smiley);
Fracs = array[TFractalTypes] of String;
TAllFractals = set of TFractalTypes;

//TElFilter = array[0..2,0..2] of shortint;
TFileExtension = (feBMP,feDIB,feRLE,feJPG,{feGIF,feTGA,fePCX,feFIF,}feTEX,fePAL,
                  feMAP,feFPR,feLSM,feIFS,feWMF,feEMF); {+fePNG,feTIF,feTIFF);}
TFlExt = array[TFileExtension] of String;

const
Fractal : Fracs = ('BARNSLEY''S FRACTAL #3','COSINE SET','EXPONENT SET','HYPERBOLIC COSINE',
                   'HYPERBOLIC SINE','IFS SYSTEMS','JULIA SET','ORBITS','FILLED ORBITS',
                   'LEGENDRE FRACTAL','L - SYSTEMS','MAGNET1M','MANDELBROT','PLASMA DISPLAY',
                   'SINE SET','SIERPINSKI TRIANGLE','ROSSLER ATTRACTOR','LORENZ ATTRACTOR',
                   'TCHEBYCHEV T5','TCHEBYCHEV T3','TCHEBYCHEV C6','JULIA SET MAPPED','HALLEY MAP',
                   '3D MOUNTAINS','MARTIN FRACTAL','UNITY','BIFURCATION','CIRCLE PATTERNS','LAMBDA',
                   'BIOMORPH JULIA','NEWTON','SPIDER','MANDELFLOWER','SMILEY ( NOT A FRACTAL )');

FileX : TFlExt = ('.BMP','.DIB','.RLE','.JPG',{'.GIF','.TGA','.PCX','.FIF',}'.TEX',
                  '.PAL','.MAP','.FPR','.LSM','.IFS','.WMF','.EMF');{'.PNG','.TIF','.TIFF');}

VerNum = 2.2;
var
  k,maxx,maxy,kstart,kend,kstep,color1,passes,
  bailoutvalue, colorstep, lsyscolor : Integer;
  vin,vout,vnew,xin,yin,xout,yout,vref : Integer;
  crossx, crossy ,BackgrndColor : Integer;
  outside,escpressed,working {,endkeypressed} : Boolean;
  halfx,halfy,x1,x2,y1,y2 : Integer;
  A1,B1,C1,D1,Iters: Integer;
  r, stepx, stepy, newx, newy : Extended;
  rec, recen, imc, imcen, re,im,re2,im2 : Extended;
  XMin,XMax,YMin,YMax,deltaP,deltaQ,Pval,Qval: Extended;
  ZoomBox : Boolean;
  x : array[0..3] of Integer;
  y : array[0..3] of Integer;
  FractalName : String;
  s9 : String;
  FileExt : string;
  BackgroundBMP : String;
  LoadedBMP : String;
  CurrentDirectory: String;
  PaletteDirectory : String;
  GraphicsDirectory : String;
  ParamsDirectory : String;
  VideoDirectory : String;
  HelpDirectory : String;
  TexturesDirectory : String;
  AnimDirectory : String;
  ScannedDirectory : String;
  CanvasText : String = '';
  TxtSize : TSize;
  ForeColor,BioColor,BioColor2 : Integer;
  BackBMP,ComingFromZoom,BmpLoaded : Boolean;
  Hours,Mins,Secs,Msecs : Word;
  StartTime,EndTime,TotalTime: TDateTime;
  VersionNum : Real;
  Globundo,{RectUndo,}TooLarge : Boolean;
//******************************************************
aaa,bbb,ccc,dt : Extended;
Ahide,loops,ColorEvery : Integer;
Raaa,Rbbb,Rccc,Rdt : Extended;           // Strange Attractor Parameters. Rossler
Rhide,Rloops,RColorEvery : Integer;
Laaa,Lbbb,Lccc,Ldt : Extended;            // Strange Attractor Parameters. Lorenz
Lhide,Lloops,LColorEvery : Integer;
//******************************************************
//FIFColorFormat : TColorFormat;                // Fif Options
//***************************************************
PrDisplay, SmoothDisplay, jpgProgEncode,GraySc : Boolean;     // Jpeg Options
jpgPxlFrm : TJPEGPixelFormat;
jpgSize   : TJPEGScale;                                  //
jpgPerf   : TJPEGPerformance;                            //
jpgCmpQlt : TJPEGQualityRange;   // [1..100]
//**************************************************
transforms,flag : Integer;                      //  Global Parameters
xoffset,yoffset : Integer;                      //  For IFS Functions.
p_sum,ifsx,ifsy,newx1,xxmax,xxmin : Extended;   //
tmp,yymax,yymin,xscale,yscale : Extended;       //
a,b,cc,d,e,f,p : array[0..127] of Extended;
//***********************************************************
TurtleTheta,TurtleX,TurtleY,angle,                     //
divisor,firstline,div2,div3 : Extended;                //
linelength : array[0..127] of Extended;                //  Global Parameters
storex,storey,storetheta : array[0..32] of Extended;   //  For L-System Functions.
generator : array[0..10,0..127] of char;               //
index,level,{type1,}startx,starty,startangle:Integer;  //
lslength : array[0..11] of Integer;                      //
//***********************************************************
dacbox : array[0..255,0..2] of Byte;
//******************* Bifurcation *****************************
bifiter,bifhide : Integer;
biftop,bifstart,bifend,bifbottom,bifstepx,bifstepy : Extended;
bifxcenter,bifycenter,bifxr,bifyr : Extended;
//AllfractalSet,CommonFuncSet : TAllFractals;

procedure Init;

implementation

procedure Init;
begin
//AllFractalSet := [barnsleyfractal3..Spider{Biojulia}];
{CommonFuncSet := [barnsleyfractal3,cosineset,ExponentSet,hypercos,hypersin,
                 juliaset,forbits,LegendreFractal,magnet1m,mandel,
                 sineset,TchebychevT5,TchebychevT3,TchebychevC6,juliasetmap,halleymap,
                 unityfr,circlepattern,Lambda,Biojulia,newton,Spider];  }
FractalName := Fractal[mandel];
kstart  := 10;
k := kstart;
kend := 60;
kstep := 5;
//r := 1.248826;
r:= 4.000000000000;
recen := 0.0;  //-0.751174;
 imcen := 0.0;
 XMax := recen + r;
 XMin := recen - r;
 YMax := imcen - r;
 YMin := imcen + r;
escpressed := false;
//endkeypressed := false;
ComingFromZoom := false;
passes := 0;
BackBMP := False;
Working := False;
Iters := 150;
colorstep := 1;
Globundo := false;
//Rectundo := false;
TooLarge := False;
ZoomBox := True;
//***************** BIFURCATIONS *****************
bifiter := 400;
bifhide := 0;
bifxcenter := 2.5;
bifycenter := 0.5;
bifstart  := bifxcenter - bifxr; //1;
bifend    := bifxcenter + bifxr; //4;
bifbottom := bifycenter - bifyr; //0;
biftop    := bifycenter + bifyr; //1;
end;

end.
