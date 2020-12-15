unit Types;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is a part of the EliFrac Project
//  Pixel and Line Suffling Algorithms Adopted  from an article In «Computer Language»
//  Magazine (Febr. 1993) by Peter G. Anderson.
//
//  Some Ideas Taken From The Ultimate Fractal Program «FRACTINT», but no code was copied.
//
// Modifications :
//  7-3-99       : In Function DoLsys commented out the "pen.width:=1" line
//                 so we can change pen width from the tools bar.
//  13-3-99      : Added Bifurcation with full zoom function.
//  16-3-99      : Changed the "if C2Dabs(z2) > bailoutvalue " check to
//                 "if (sqr(z.real)+sqr(z.img)) > bailoutvalue"  for all fractals.
//                 Now all fractals are faster.
// 18-3-99       : Made above change to apply only for normal coloring mode.
//                 For Biomorphs and Decomposition the old check applies.
// 9-4-99        : Major Change in code. Changed all clasic fractal procedures To One
//                 Single proc. "AllFractals". This change eliminates code repetition.
//                 Saved almost 2.500 lines in this Unit. No change in Speed noticed.
// 10-4-99       : Changed IFS fractals to use the palette colors and not a single paint color
// 12-4-99       : Now Using Pointers to Fractal Functions to call them with one single call
//                 from "AllFractals". Killed a lot of case statements.
//                 Because of this the split screen function got a little faster.
// 12-4-99       : Walking The Fractals is now a fact.
// 13-4-99       : New Fractal Type: Circle Patterns [My Invention]
// 19-4-99       : New Fractal Type: Lambda.
// 26-12-99      : Modified to use scanlines for normal drawing method of AllFractals.
// 13-7-2000     : Save Unfinished Fractal State for Normal,Oposite half,Curtain and Helix
//                 Drawing Modes.
// 18-7-2000     : Added 2 New Drawing Methods: FatLine Suffling and FatPixel Suffling
//                 Made them work with scanlines (Faster and better viewing result)
//****************************************************************************************
interface

uses
SysUtils,Windows, System.UITypes, Classes,Controls,Forms,IniFiles,Graphics,Dialogs;

const
PROG1 = 584441; //740644;   {G1_800x600 * G1_800x600}
INCR  = 595;
PLASM = 348948;
P300 = 155309;
P320 = 191149;
P400 = 342109;
P500 = 436189;
P640 = 744109;
P800 = 1202429;
PLN  = 988;
//************** 3D Mountains ******************
YADD  = 38;
WATERCOLOR = clblue;
LANDCOLOR  = clGreen;

var
G1 : Integer = 1278;
G2 : Integer = 1873;
F1,F2 : Integer;                    // Fibonacci Numbers ( 377, 610, 987, 1597, 2584, 4181, 6765, ... ).
                                    // F1 and F2 must be two consecutive Fibonacci numbers.
G3 : Integer;   //= G1_800x600*G2_800x600;
//G4 : Integer;  //= G3_1024*G4_1024;
xana : Integer;
UnityBailOut : Extended = 2;
One : Extended;
Wide,www: Integer;

// resume drawing fractals.
savedrow, savedCurtainCol, savedOpositeCol, savedHelixG : Integer;
//savedG3, savedcol2, savedrow2,
//savedF2, savedcol3 : Integer;

//***************** Martin ***********************
ma,mb,mc,md,me,ms : Extended;
xold : Extended;
tc : Integer;
mt : Integer = 0;
clr : Integer;
//************** 3D Mountains ******************
steep : Extended;
sealevel : Integer;
ybottom  : Integer;
DEEP : Integer;

procedure AllFractals;
procedure Julia;
procedure Orbits;
procedure sub500;
procedure SierpinskiFunc;
procedure DoIfs;
procedure step(type1,level :Integer; turtle_r :Extended);
procedure DoLsys;
procedure StrReverse(Src : array of char);
procedure Attractors(Kind: Integer);
procedure DoLoadIfs(Fnm: String);
procedure DoLoadLsys(Fnm: String);
procedure PlasmaProc;
procedure do3dland;
procedure DoMartin;
procedure SplitAll(x1,y1,x2,y2 : Integer);
procedure Bif;

procedure FractalInit;
procedure LoadedFractalInit;
procedure ComputeBarnsley3(col,row: integer);
procedure ComputeCosine(col,row: integer);
procedure ComputeExponent(col,row: integer);
procedure ComputeHyperCosine(col,row: integer);
procedure ComputeHyperSine(col,row: integer);
procedure ComputeFullJulia(col,row: integer);
procedure ComputeFilledMandelOrbits(col,row: integer);
procedure ComputeLegendrePoly(col,row: integer);
procedure ComputeMagnet1m(col,row: integer);
procedure ComputeMandel(col,row: integer);
procedure ComputeSine(col,row: integer);
procedure ComputeTchebyT3(col,row: integer);
procedure ComputeTchebyT5(col,row: integer);
procedure ComputeTchebyC6(col,row: integer);
procedure ComputeHalley(col,row: integer);
procedure ComputeUnity(col,row: integer);
procedure computeNewFractal(col,row: integer);
procedure ColorMode(g,col,row : Integer);
procedure CompleteFractalRight(x,y : Integer);
procedure CompleteFractalLeft(x,y : Integer);
procedure CompleteFractalUp(x,y : Integer);
procedure CompleteFractalDown(x,y : Integer);
procedure ComputeLambdaFractal(col,row : Integer);
procedure ComputeBioFractal(col,row :Integer);
procedure ComputeNewton(col,row: integer);
procedure computeSpider(col,row :Integer);
procedure computeMandelFlower(col,row :Integer);
procedure computeTestFunction(col,row :Integer);

type TFractalProc = procedure(col, row: Integer);

var  FractalProc : TFractalProc;

implementation

uses Math,Globs,Main,Inf,BParams,SPar,ifsfrm,lsys,AttrPar,SplitCnf,
     HalSel,MartPar,TrigPar,BifPar;


procedure endjob;
begin
Screen.Cursor := crDefault;
{Assign New size to temp and Copy BM.Canvas To temp.Canvas.
temp is now ready to be saved as .bmp and the window can be resized safely. }
with BM do
begin
temp.Width := ClientWidth;
temp.Height := ClientHeight;
temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
original.Width := ClientWidth;
original.Height := ClientHeight;
original.Canvas.CopyRect(ClientRect,Canvas,ClientRect);

if SndMenu.checked then MessageBeep(MB_ICONEXCLAMATION);
cross;
end;
with BM.Canvas do
begin
Brush.Style := bsClear;
Pen.Mode := pmNot;
Rectangle(A1,B1,C1,D1);
MoveTo(crossx,crossy-10 );
LineTo(crossx,crossy+10 );
MoveTo(crossx-10,crossy );
LineTo(crossx+10,crossy );
Brush.Style := bsSolid;
Pen.Mode := pmCopy;
 end;
Working := False;
if TimerOn then  BM.Timer1.Enabled := False;
end;

procedure DrawScanLine(g,clr,col: Integer);
begin
if g < Iters then
  begin
    RowRGB[col].rgbtRed   :=  dacbox[clr][0];
    RowRGB[col].rgbtGreen :=  dacbox[clr][1];
    RowRGB[col].rgbtBlue  :=  dacbox[clr][2];
  end
  else begin
    RowRGB[col].rgbtRed   :=  0; // }
    RowRGB[col].rgbtGreen :=  0; // }black
    RowRGB[col].rgbtBlue  :=  0; // }
  end;
end;

procedure ColorMode(g,col,row : Integer);
var clr: integer;
begin
 case  ColMode of
    0 : ;// Normal painting
    1 : begin  // Biomorphs #1.
       //bm.timer2.Enabled := false;
        if abs(z.real) > bailoutvalue then
             begin
              //if bm.timer2.Enabled then begin {clr:= BioColor;} DrawScanLine(g,BioColor,col); exit; end;
              tcan.Pixels[col,row] := BioColor;
              exit;
             end
        else if abs(z.img) > bailoutvalue then
              begin
              //if bm.timer2.Enabled then begin {clr:= BioColor2;} DrawScanLine(g,BioColor2,col); exit; end;
              tcan.Pixels[col,row] := BioColor2;
              exit;
              end;
        end;
    2 : begin  // Biomorphs #2.
        if ((abs(z.real) < bailoutvalue) or (abs(z.img) < bailoutvalue)) then
           begin
           tcan.Pixels[col,row] := BioColor;
           exit;
           end;
        end;
    3 : begin  // Biomorphs #3.
        if ((abs(z.real) < bailoutvalue) or (abs(z.img) > bailoutvalue)) then
           begin
           tcan.Pixels[col,row] := BioColor;
           exit;
           end;
        end;
    4 : begin  // Biomorph #4.
        if z.real < bailoutvalue then
          begin
          tcan.Pixels[col,row] := BioColor;
          exit;
          end
        else if z.img > bailoutvalue then
              begin
              tcan.Pixels[col,row] := BioColor2;
              exit;
              end;
        end;
     5 : begin  // Binary Decomposition
         if z.img >= 0 then
          begin
          tcan.Pixels[col,row] := BioColor;
          exit;
          end
          else if z.img < 0 then
              begin
              tcan.Pixels[col,row] := BioColor2;
              exit;
              end;
           exit;
         end;
      6 : begin  // Binary Decomposition 2
          if (z.real >= 0) and (z.img >= 0) then
          begin
          tcan.Pixels[col,row] := BioColor;
          exit;
          end
          else if (z.real < 0) and (z.img < 0)  then
              begin
              tcan.Pixels[col,row] := BioColor2;
              exit;
              end;
           exit;
         end;
    end;
  clr := (g div stepiter) mod 256;
  if ((DrMethod = 10) and (not WalkMode)) then   // If FatPixel Suffling (timer2)
    begin
     case wide of
      1,2 : begin
             www := 2*wide+1;
             with bm.temp.Canvas do
                 begin
                   if g < Iters then Brush.Color := Pal[clr]
                   else Brush.Color := 0;
                   FillRect(Rect(col-www,row-www,col+www,row+www));
                 end;
           end;
       0 : DrawScanLine(g,clr,col);
       end; // case
    end // if DrMethod
  else
  if ((DrMethod = 9) and (not WalkMode)) then   // If FatLine Suffling (timer2)
     begin
         if g < Iters then bm.temp.Canvas.Pen.Color:= Pal[clr]
         else bm.temp.Canvas.Pen.Color:= 0;
         with bm.temp.Canvas do
          begin
            MoveTo(col,row-wide);
            LineTo(col,row);
          end;
     end
  else
  if ((DrMethod=0) and (not WalkMode)) then  //work with scanlines and timer2  Normal Mode
     DrawScanLine(g,clr,col)
  else if g < Iters then
        SetPixelV(tcan.Handle,col,row,Pal[clr])
       else SetPixelV(tcan.Handle,col,row,0);
end;

procedure LargeBio(col,x: integer);
begin
Lrgb[col].rgbtred := GetRValue(x);
Lrgb[col].rgbtgreen := GetGValue(x);
Lrgb[col].rgbtblue := GetBValue(x);
end;

procedure ColorMode2(g,col{,row} : Integer);
begin
case  ColMode of
    0 : ;// Normal painting
    1 : begin  // Biomorphs #1.
        if abs(z.real) > bailoutvalue then
             begin
              LargeBio(col,biocolor);
              exit;
             end
        else if abs(z.img) > bailoutvalue then
              begin
              LargeBio(col,biocolor2);
              exit;
              end;
        end;
    2 : begin  // Biomorphs #2.
        if ((abs(z.real) < bailoutvalue) or (abs(z.img) < bailoutvalue)) then
           begin
           LargeBio(col,biocolor);
           exit;
           end;
        end;
    3 : begin  // Biomorphs #3.
        if ((abs(z.real) < bailoutvalue) or (abs(z.img) > bailoutvalue)) then
           begin
           LargeBio(col,biocolor);
           exit;
           end;
        end;
    4 : begin  // Biomorph #4.
        if z.real < bailoutvalue then
          begin
          LargeBio(col,biocolor);
          exit;
          end
        else if z.img > bailoutvalue then
              begin
              LargeBio(col,biocolor2);
              exit;
              end;
        end;
     5 : begin  // Binary Decomposition
         if z.img >= 0 then
          begin
          LargeBio(col,biocolor);
          exit;
          end
          else if z.img < 0 then
              begin
              LargeBio(col,biocolor2);
              exit;
              end;
           exit;
         end;
      6 : begin  // Binary Decomposition 2
          if (z.real >= 0) and (z.img >= 0) then
          begin
          LargeBio(col,biocolor);
          exit;
          end
          else if (z.real < 0) and (z.img < 0)  then
              begin
              LargeBio(col,biocolor2);
              exit;
              end;
           exit;
         end;
    end;
if g < Iters then
   begin
    LargeBio(col,Pal[(g div stepiter) mod 256]);
   end;
end;

procedure LoadedFractalInit;
begin
inc(passes);
BM.WalkMenu.Enabled := True;
WalkMode := false;
BM.WalkModeOFF1.Checked := true;
BM.WalkTheFractal1.Checked := false;
Screen.Cursor := crDefault;
 stepx := 2*r / maxx;
 stepy := 2*r / maxy;
 rec := stepx+recen;
 imc := imcen;
 XMax := recen + r;
 XMin := recen - r;
 YMax := imcen - r;
 YMin := imcen + r;
 if (kend > Iters) then
  begin
   Iters := kend;
   Info.Label22.Caption := IntToStr(Iters);
   end;
 x1 := 0; y1 := 0;
 x2 := maxx; y2 := maxy;
 deltaP := (XMax-XMin)/maxx;
 deltaQ := (YMax-YMin)/maxy;
 if FractalCompleted then savedrow:=0;

end;

procedure FractalInit;
begin
inc(passes);
escpressed := False;
Working := True;
WalkMode := false;
BM.WalkModeOFF1.Checked := true;
BM.WalkTheFractal1.Checked := false;
Screen.Cursor := crHourglass;
 stepx := 2*r / maxx;
 stepy := 2*r / maxy;
 rec := stepx+recen;
 imc := imcen;
 XMax := recen + r;
 XMin := recen - r;
 YMax := imcen - r;
 YMin := imcen + r;
 if (kend > Iters) then
  begin
   Iters := kend;
   Info.Label22.Caption := IntToStr(Iters);
   end;
 x1 := 0; y1 := 0;
 x2 := maxx; y2 := maxy;
A1:=x1; B1:=y1; C1:=x2; D1:=y2;
 with BM.Canvas do
 begin
   Pen.Mode := pmCopy;
   Pen.Width := 1;
   Brush.Style := bsclear;
   Brush.Color := BM.Color;
end;
 if TimerOn then begin   // Added 5-9-98
   BM.Timer1.Enabled :=True;
   StartTime := Time;
 end;
 deltaP := (XMax-XMin)/maxx;
 deltaQ := (YMax-YMin)/maxy;

// oldcoloriter := 0;

 if ProgressBarOn then begin
 info.G1.Progress := 0;
 info.G1.Visible := true;
 xana := 0;
 end;

end;

procedure LargeBitmapOutSideColor(g,col :Integer);
begin
 case ColMode of
   5,6: begin ColorMode2(g,col); exit; end;
 end;
 case OutsideColor of
    0: ColorMode2(g,col);                          //Iter
    1: ColorMode2(round(abs(z.real)),col);        // abs(Real)
    2: ColorMode2(round(abs(z.real)) or g,col);   // abs(Real) OR Iter
    3: ColorMode2(round(abs(z.real)) and g,col);  // abs(Real) AND Iter

    4: ColorMode2(round(abs(z.img)),col);          // abs(Imag)
    5: ColorMode2(round(abs(z.img)) or g,col);     // abs(Imag) OR Iter
    6: ColorMode2(round(abs(z.img)) and g,col);    // abs(Imag) AND Iter

    7: ColorMode2(round(abs(z.real + z.img)),col);                 //abs(Real + Imag)
    8: ColorMode2(round(abs(z.real * z.img)),col);                 //abs(Real * Imag)
    9: ColorMode2(round(abs(z.img)) or round(abs(z.real)) ,col);   //abs(Imag) OR abs(Real)
   10: ColorMode2(round(abs(z.img)) and round(abs(z.real)) ,col);  //abs(Imag) AND abs(Real)

   11: ColorMode2(round(abs(z.img)) + round(abs(z.real)) ,col);      //abs(Imag) + abs(Real)
   12: ColorMode2(abs(round(abs(z.img)) - round(abs(z.real))) ,col); //abs(abs(Imag) - abs(Real))
   13: ColorMode2(round(abs(z.img)) * round(abs(z.real)) ,col);      //abs(Img) * abs(Real)

   14: ColorMode2(abs(round(abs(z.img)) - round(abs(z.real))) or g ,col); //abs(abs(Imag) - abs(Real)) OR Iter

   15: ColorMode2(round(abs(z.real)) * g,col);   //abs(Real) * Iter
   16: Colormode2(round(c2dabs(z))+g+22,col);     // 3d look with gradient palettes
  end;
end;

procedure ChooseOutSideColor(g,col,row :Integer);
begin
 case ColMode of
   5,6: begin ColorMode(g,col,row); exit; end;
 end;
 case OutsideColor of
    0: ColorMode(g,col,row);                          //Iter
    1: ColorMode(round(abs(z.real)),col,row);        // abs(Real)
    2: ColorMode(round(abs(z.real)) or g,col,row);   // abs(Real) OR Iter
    3: ColorMode(round(abs(z.real)) and g,col,row);  // abs(Real) AND Iter

    4: ColorMode(round(abs(z.img)),col,row);          // abs(Imag)
    5: ColorMode(round(abs(z.img)) or g,col,row);     // abs(Imag) OR Iter
    6: ColorMode(round(abs(z.img)) and g,col,row);    // abs(Imag) AND Iter

    7: ColorMode(round(abs(z.real + z.img)),col,row);                 //abs(Real + Imag)
    8: ColorMode(round(abs(z.real * z.img)),col,row);                 //abs(Real * Imag)
    9: ColorMode(round(abs(z.img)) or round(abs(z.real)) ,col,row);   //abs(Imag) OR abs(Real)
   10: ColorMode(round(abs(z.img)) and round(abs(z.real)) ,col,row);  //abs(Imag) AND abs(Real)

   11: ColorMode(round(abs(z.img)) + round(abs(z.real)) ,col,row);      //abs(Imag) + abs(Real)
   12: ColorMode(abs(round(abs(z.img)) - round(abs(z.real))) ,col,row); //abs(abs(Imag) - abs(Real))
   13: ColorMode(round(abs(z.img)) * round(abs(z.real)) ,col,row);      //abs(Img) * abs(Real)

   14: ColorMode(abs(round(abs(z.img)) - round(abs(z.real))) or g ,col,row); //abs(abs(Imag) - abs(Real)) OR Iter

   15: ColorMode(round(abs(z.real)) * g ,col,row);   //abs(Real) * Iter
   16: Colormode(round(c2dabs(z))+g+22,col,row);     // 3d look with gradient palettes
       
  end;
end;

procedure computeNewFractal(col,row :Integer);  //Circle Patterns
var g : Integer;
begin
    c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
    z := Complexfunc(Xr,Xim);
    g := 0;
    if Params1.Invert.Checked then c := cintdiv_RC(1,c);
    while g <= Iters do
     begin
      case  ColMode of
       1..6 : if C2Dabs(z) > bailoutvalue then break;
        0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
       end;
        z := cadd(z,c);
        inc(g,stepiter);
     end;  // g
     if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeLambdaFractal(col,row : Integer);
var g: integer;
begin
z := Complexfunc(Xmin+col*deltaP,Ymax-row*deltaQ);
if Params1.Invert.Checked then z := cintdiv_RC(1,z);
  for g := 0 to Iters do
   begin
    z2 :=  cmul(z,csub(complexfunc(1,0),z));
    case  ColMode of
     1..6 : if C2Dabs(z) > bailoutvalue then break;
        0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
    end;
     z := Cmul(z2,complexfunc(LamdaR,LamdaIm));
   end;
   if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else  ChooseOutSideColor(g,col,row);
end;

procedure computeMandel(col,row :Integer);
var g : Integer;
begin
    c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
    z := Complexfunc(Xr,Xim);
    g := 0;
    if Params1.Invert.Checked then c := cintdiv_RC(1,c);

    while g <= Iters do
     begin
      case ColMode of
        0 : if sqr(z.real)+sqr(z.img)  > bailoutvalue then break;
        1..6 : if C2Dabs(z) > bailoutvalue then break;
       end;
       z:= Cadd(Cmul(z,z),c);
       inc(g,stepiter);
    end;  // g

    if LargeDiskImage then LargeBitmapOutSideColor(g,col)
    else ChooseOutSideColor(g,col,row);
 end;

procedure ComputeCosine(col,row : Integer);
var g : Integer;
begin
   c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
   z := Complexfunc(CosXr,CosXim);
   g:=0;
   if Params1.Invert.Checked then c := cintdiv_RC(1,c);
   while g <= Iters do
   begin
     case  ColMode of
       1..6 : if C2Dabs(z) > bailoutvalue then break;
          0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
       end;
     case TrigParams.TrigF.ItemIndex of
       0 :  z:= Cadd(Ccos(z),c);
       1 :  z:= Cadd(Ccos(Cmul(z,z)),c);
     end;
     inc(g,stepiter);
   end;
   if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeHyperCosine(col,row : Integer);
var g : Integer;
begin
 c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
 z := Complexfunc(0,0);
 g := 0;
 if Params1.Invert.Checked then c := cintdiv_RC(1,c);
 while g <= Iters do
   begin
     case  ColMode of
      1..6 : if C2Dabs(z) > bailoutvalue then break;
         0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
     end;
       case TrigParams.TrigF.ItemIndex of
           0 :  z:= Cadd(Ccosh(z),c);
           1 :  z:= Cadd(Ccosh(Cmul(z,z)),c);
       end;
       inc(g,stepiter);
 end;
 if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeHyperSine(col,row : Integer);
var g : Integer;
begin
 c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
 z := Complexfunc(0,0);
 g := 0;
 if Params1.Invert.Checked then c := cintdiv_RC(1,c);
 while g <= Iters do
   begin
     case  ColMode of
      1..6 : if C2Dabs(z) > bailoutvalue then break;
         0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
     end;
       case TrigParams.TrigF.ItemIndex of
           0 :  z:= Cadd(Csinh(z),c);
           1 :  z:= Cadd(Csinh(Cmul(z,z)),c);
       end;
       inc(g,stepiter);
 end;
 if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeSine(col,row :Integer);
var g : Integer;
begin
c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
z := Complexfunc(SinXr,SinXim);
g := 0;
if Params1.Invert.Checked then c := cintdiv_RC(1,c);
   while g <= Iters do
     begin
       case  ColMode of
         1..6 : if C2Dabs(z) > bailoutvalue then break;
            0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
        end;
         case TrigParams.TrigF.ItemIndex of
          0 :  z:= Cadd(Csin(z),c);
          1 :  z:= Cadd(Csin(Cmul(z,z)),c);
        end;
        inc(g,stepiter);
     end;
     if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else  ChooseOutSideColor(g,col,row);
end;

procedure ComputeFullJulia(col,row :Integer);
var g : Integer;
begin
  z := Complexfunc(Xmin+col*deltaP,Ymax-row*deltaQ);
 if Params1.Invert.Checked then z := cintdiv_RC(1,z);
  for g := 0 to Iters do
   begin
    z2 := Csqr(z);
    case  ColMode of
     1..6 : if C2Dabs(z) > bailoutvalue then break;
        0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
    end;
    z:= Cadd(z2,c);
   end;
   if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeBioFractal(col,row :Integer);
var g : Integer;
begin
  z := Complexfunc(Xmin+col*deltaP,Ymax-row*deltaQ);
  if Params1.Invert.Checked then z := cintdiv_RC(1,z);
  for g := 0 to Iters do
   begin
   // z2 := Csqr(z);
    case  ColMode of
     1..6 : if C2Dabs(z) > bailoutvalue then break;
        0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
    end;
    z:= Cadd(ComplexPower(z,complexfunc(1.5,0)),complexfunc(-0.2,0));
   end;
   if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeExponent(col,row : Integer);
var g : Integer;
begin
c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
z := Complexfunc(Xr,Xim);
g := 0;
if Params1.Invert.Checked then c := cintdiv_RC(1,c);
while g <= Iters do
  begin
   case  ColMode of
    1..6 : if C2Dabs(z) > bailoutvalue then break;
       0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
   end;
   z := Cmul(c,Cexp(z));
   inc(g,stepiter);
 end;
 if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeLegendrePoly(col,row : Integer);
var g : Integer;
begin
c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
z := Complexfunc(0,0);
g := 0;
if Params1.Invert.Checked then c := cintdiv_RC(1,c);
while g <= Iters do
  begin
   z2 := csqr(z);
   case  ColMode of
     1..6 : if C2Dabs(z) > bailoutvalue then break;
        0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
   end;
   z:= cadd (cmulf( csub (cmulf(cmul(z2,z2),35),
              cadd(cmulf(z2,30),c3)),0.125),c);
   inc(g,stepiter);
  end;
  if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else  ChooseOutSideColor(g,col,row);
end;

procedure DoHalleyMath;
begin
 exz := z;
case HallFunction of
{z^2}  0 :  begin
             z2 := cmul(z,z);
             z :=  cdiv( cadd(z2,complexfunc(1,0)) , cmulf(z,2)   );
            end;
{z^3}  1 :  begin
             z2 := cmul(z,z); z3 := cmul(z2,z);
             z :=  cdiv(cadd(cmul(z2,z2),cmulf(z,2)), cadd(cmulf(z3,2),Complexfunc(1,0)));
            end;
{z^4}  2 :  begin
             z2 := cmul(z,z); z3 := cmul(z2,z); z5 := cmul(z3,z2);
             z :=  cdiv(cadd(cmulf(z5,3),cmulf(z,5)), cadd(cmulf(cmul(z2,z2),5),Complexfunc(3,0)));
            end;
{z^5}  3 :  begin
             z2 := cmul(z,z); z3 := cmul(z2,z); z5 := cmul(z3,z2); z6 := cmul(z3,z3);
             z := cdiv(cadd(cmulf(z6,2),cmulf(z,3)), cadd(cmulf(z5,3),Complexfunc(2,0)));
            end;
{z^6}  4 :  begin
              z2 := cmul(z,z); z3 := cmul(z2,z); z6 := cmul(z3,z3); z7 := cmul(z6,z);
              z := cdiv(cadd(cmulf(z7,5),cmulf(z,7)), cadd(cmulf(z6,7),Complexfunc(5,0)));
            end;
{Z^7}  5 :  begin
              z2 := cmul(z,z); z3 := cmul(z2,z); z5 := cmul(z3,z2); z7 := cmul(z5,z2);
              z := cdiv(cadd(cmulf(cmul(z5,z3),3),cmulf(z,4)), cadd(cmulf(z7,4),Complexfunc(3,0)));
            end;
{z^8}  6 : begin
             z2 := cmul(z,z); z3 := cmul(z2,z); z5 := cmul(z3,z2); z6 := cmul(z3,z3);
             z := cdiv(cadd(cmulf(cmul(z6,z3),7),cmulf(z,9)), cadd(cmulf(cmul(z5,z3),9),Complexfunc(7,0)));
           end;
{z^9}  7 : begin
             z2 := cmul(z,z); z3 := cmul(z2,z); z5 := cmul(z3,z2); z6 := cmul(z3,z3);
             z := cdiv(cadd(cmulf(cmul(z5,z5),4),cmulf(z,5)), cadd(cmulf(cmul(z6,z3),5),Complexfunc(4,0)));
            end;
{z^10} 8 : begin
             z2 := cmul(z,z); z3 := cmul(z2,z); z5 := cmul(z3,z2); z6 := cmul(z3,z3);
             z := cdiv(cadd(cmulf(cmul(z6,z5),27),cmulf(z,23)), cadd(cmulf(cmul(z5,z5),32),Complexfunc(18,0)));
           end;
{z^7+z^2-1} 9 : begin
                z2 := cmul(z,z); z3 := cmul(z2,z); z5 := cmul(z3,z2); z6 := cmul(z3,z3); z7 := cmul(z5,z2);
                comptemp1 := csub(cadd(z7,z2),complexfunc(1,0));  {(x^7 + x^2 - 1)}
                comptemp2 := cadd(cmulf(z6,7), cmulf(z,2));       {(7x^6 + 2x)}
                z := csub(z, cdiv(comptemp1,csub(comptemp2,
                     cdiv( cmul(cmulf(z5,42),comptemp1),cmulf(comptemp2,2)))));
                end;
{mistake} 10 :  begin
                 z2 := cmul(z,z); z3 := cmul(z2,z);
                 z := cdiv(cadd(z3,z),csub(cmulf(z2,3),Complexfunc(1,0)));
                end;
{x^5+2x^4-x^3+1}
          11 :  begin
                 z2 := cmul(z,z); z3 := cmul(z2,z); z4 := cmul(z2,z2); z5 := cmul(z3,z2);
                 comptemp1 := csub(cadd(cmulf(z3,5),cmulf(z2,8)),cmulf(z,3));  {(5x^3 + 8x^2 - 3x)}
                 comptemp2 := cadd(csub(cadd(z5,cmulf(z4,2)),z3),complexfunc(1,0));  {(x^5 + 2x^4 - x^3 + 1)}

               z := csub(z, cdiv(cmul(comptemp1,comptemp2),
                    csub(cmul(csub(cadd(cmulf(z4,5),cmulf(z3,8)),cmulf(z2,3)),comptemp1),
                    cmul(csub(cadd(cmulf(z2,10),cmulf(z,12)),complexfunc(3,0)),comptemp2))       ));
                end;
{X^25}          12 :  begin
                  z2 := cmul(z,z); z3 := cmul(z2,z); z5 := cmul(z3,z2);
                  comptemp1 := cmul(cmul(cmul(cmul(z5,z5),z5),z5),z5);   {z^25}
                  z := cdiv(cadd(cmulf(cmul(comptemp1,z),12),cmulf(z,13)), cadd(cmulf(comptemp1,13),Complexfunc(12,0)));
                end;
      end; //case
end;

procedure ComputeHalley(col,row : Integer);
var g : integer;
begin
z := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
if Params1.Invert.Checked then z := cintdiv_RC(1,z);
for g:= 0 to Iters do
 begin
 DoHalleyMath;
 if abs((sqr(z.real)+sqr(z.img))-(sqr(exz.real)+sqr(exz.img))) < HalleyBailOut then
 begin
   if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else  ChooseOutSideColor(g,col,row);
   break;
 end;
end;
end;

procedure ComputeFilledMandelOrbits(col,row : Integer);
var g : integer;
    dis: extended;
begin
rec := stepx*(col-halfx)+recen;
imc := stepy*(row-halfy)+imcen;
re := rec; im := imc;

if Params1.Invert.Checked then
  begin
   dis := (re*re+im*im);
   if dis = 0 then begin re:=0; im:=0; end
   else begin
         re := re/dis;
         im := -im/dis;
        end;
   end;

for g :=0 to Iters do
 begin
  re2 := re*re; im2 := im*im;
  if( (re2+im2) > 256) then
   begin
     if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
     exit; //break;
   end;
   im := 2*re*im+imc;
   re := re2-im2+rec;
   z.real := re; // This is here to make it work with ColorMode and outsidecolor. 12-4-99
   z.img  := im; //
 end;
end;

procedure ComputeMagnet1m(col,row : Integer);
//  Z = ((Z**2 + C - 1)/(2Z + C - 2))^2
//  In "Beauty of Fractals"
var g : Integer;
top, bot, tmp: complex;
//den : extended;
begin
c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
z := Complexfunc(Xr,Xim);
g := 0;
if Params1.Invert.Checked then c := cintdiv_RC(1,c);
while g <= Iters do
 begin
  z2:= cmul(z,z);
  case  ColMode of
   1..6 : if C2Dabs(z) > bailoutvalue then break;
     0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
  end;
    top := csub(cadd(z2,c),complexfunc(1,0));
    bot := csub(cadd(cmulf(z,2),c),complexfunc(2,0));
    tmp := cdiv(top,bot);
    z:= cmul(tmp,tmp);
   inc(g,stepiter);
  end;
  if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeUnity(col,row : Integer);
var g : Integer;
begin
z := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
g := 0;
if Params1.Invert.Checked then z := cintdiv_RC(1,z);
while g <= Iters do
  begin
   One := sqr(z.real) + sqr(z.img);
   case  ColMode of
    1..6 : if C2Dabs(z) > bailoutvalue then break;
       0 : if One > Unitybailout  then break;
   end;
   z.img  := (2 - One) * z.real;
   z.real := (2 - One) * z.img;
   inc(g,stepiter);
  end;
  if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else  ChooseOutSideColor(g,col,row);
end;

procedure ComputeTchebyC6(col,row : Integer);
var g : integer;
begin
c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
z := Complexfunc(T5r,T5im);
g := 0;
if Params1.Invert.Checked then c := cintdiv_RC(1,c);
while g <= Iters do
  begin
  case  ColMode of
    1..6 : if C2Dabs(z) > bailoutvalue then break;
       0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
  end;
  z2 := cmul(z,z);
  z3 := cmul(z2,z);
  z := cmul(cadd(cadd(cadd(cmul(z3,z3),cmulf(cmul(z3,z),-6)),
       cmulf(z2,9)),complexfunc(-2,0)),c);
  inc(g,stepiter);
end;
if LargeDiskImage then LargeBitmapOutSideColor(g,col)
  else ChooseOutSideColor(g,col,row);
end;

procedure ComputeTchebyT3(col,row : integer);
var g : integer;
begin
c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
z := Complexfunc(T5r,T5im);
g := 0;
if Params1.Invert.Checked then c := cintdiv_RC(1,c);
while g <= Iters do
 begin
  case  ColMode of
   1..6 : if C2Dabs(z) > bailoutvalue then break;
      0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
  end;
  z3 := cmul(csqr(z),z);
  z := cmul(cadd( cmulf(z3,4) ,   cmulf(z,-3)),c);
  inc(g,stepiter);
 end;
 if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeTchebyT5(col,row : integer);
var g : integer;
begin
c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
z := Complexfunc(T5r,T5im);
g := 0;
if Params1.Invert.Checked then c := cintdiv_RC(1,c);
while g <= Iters do
 begin
  z2 := csqr(z);
  z3 := cmul(csqr(z),z);
  case  ColMode of
   1..6 : if C2Dabs(z) > bailoutvalue then break;
      0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
  end;
  z:= cmul(c,cadd(cadd( cmulf( cmul(z2,z3),16),cmulf(z3,-20)),cmulf(z,5)));
  inc(g,stepiter);
 end;
 if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
end;

procedure ComputeBarnsley3(col,row : integer);
var g : integer;
begin
z := Complexfunc(Xmin+col*deltaP,Ymax-row*deltaQ);
if Params1.Invert.Checked then z := cintdiv_RC(1,z);
for g := 0 to Iters do
    begin
      case  ColMode of
       1..6 : if C2Dabs(z) > bailoutvalue then break;
          0 : if sqr(z.real)+sqr(z.img) > bailoutvalue  then break;
      end;
      xsq := sqr(z.real);
      ysq := sqr(z.img);
      xy := z.real*z.img;
      if z.real >= 0 then
         z := complexfunc(xsq-ysq-1,2*xy)
        else
         z := complexfunc(xsq-ysq-1+Br*z.real,2*xy);
    end;
    if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else  ChooseOutSideColor(g,col,row);
end;

procedure CompleteFractalRight(x,y : Integer);
var
col,row : Integer;
begin
 for row := y to maxy do
  for col:=x to maxx do
   FractalProc(col,row);
end;

procedure CompleteFractalLeft(x,y : Integer);
var
col,row : Integer;
begin
 for row := y to maxy do
  for col := x downto 0 do
   FractalProc(col,row);
end;

procedure CompleteFractalUp(x,y : Integer);
var
col,row : Integer;
begin
 for col := x to maxx do
  for row := y downto 0 do
   FractalProc(col,row);
end;

procedure CompleteFractalDown(x,y : Integer);
var
col,row : Integer;
begin
 for col:= x to maxx do
  for row := y to maxy do
   FractalProc(col,row);
end;

procedure AllFractals;
var
XX,g,row,col,col2,row2 : Integer;
InterlacePass,Step,Intstart : Integer;
//cnt: Integer;
label
SufflingPixels,LineSufflingV,LineSufflingH,FatLine,FatPixel,bailout,
SplitScreen,Interlace,Curtain,Oposite,Helix;
begin
FractalInit;
  case   DrMethod of
  0 : ; // Normal Every Pixel One Pass.
  1 : goto SufflingPixels;
  2 : goto LineSufflingV;
  3 : goto LineSufflingH;
  4 : goto SplitScreen;
  5 : goto Interlace;
  6 : goto Curtain;
  7 : goto Oposite;
  8 : goto Helix;
  9 : goto FatLine;
 10 : goto FatPixel;
end;

bm.temp.Width := bm.ClientWidth;    // This is here to correct a resize problem
bm.temp.Height := bm.ClientHeight;  // with temp.scanline
if FractalCompleted then
  begin
  PatBlt(bm.temp.canvas.handle,0,0,bm.temp.width,bm.temp.height,BLACKNESS);
  savedrow := 0;
  end;
if ColMode = 0 then bm.timer2.enabled := true;   // draw on screen every 1 second

 for row := {0}savedrow to maxy-1 do
 begin
  Application.ProcessMessages;
  if escpressed then
    begin
      escpressed:= False;
      savedrow := row-1;
      FractalCompleted := false;
      break;
    end;
 RowRGB := bm.temp.ScanLine[row];
 for col:= 0 to maxx-1 do
        begin
         FractalProc(col,row);
        end;
  if ProgressBarOn then
   Info.G1.Progress := (100 * row) div maxy;
 end;
if row >= maxy-1 then FractalCompleted:= true;
bm.timer2.enabled := false;
if ColMode = 0 then  bm.Repaint;
goto bailout;

SufflingPixels:  //************ Use Suffling Pixels Algorithm *****************/
col :=0; row := 0;
G3 := G1*G2;

 FOR XX:= 0 TO  G3 DO
   BEGIN
     if ProgressBarOn then inc(xana);
     col := (col+INCR) mod G1;
     row := (row+INCR) mod G2;
     if((col<maxx) and (row<maxy) )  then
       begin
        FractalProc(col,row);
        Application.ProcessMessages;
        if escpressed then
          begin
            escpressed:= False;
            goto bailout; //break;
          end;
       end;
      if ProgressBarOn then
       Info.G1.Progress := 100*xana div PROG1;
    END;
goto bailout;

LineSufflingV:  //********** Use Line Suffling Algorithm. *********************/
col:=0;
if maxx < 850 then
   begin  F1 := 610;  F2:= 987; end
   else begin F1 := 987; F2 := 1597; end;

 FOR XX:= 0 TO F2 DO
   BEGIN
     if ProgressBarOn then inc(xana);
     col := (col+F1) mod F2;
     if(col < maxx) then
     begin
     Application.ProcessMessages;
      if escpressed then
        begin
          escpressed:= False;
          goto bailout; //break;
        end;
       for row := 0 to maxy do FractalProc(col,row);
     end;
      if ProgressBarOn then
       Info.G1.Progress := (100 * xana) div PLN;
    END;
 goto bailout;

LineSufflingH:  //********** Use Fat Line Suffling Algorithm. *********************/
if maxx < 850 then
   begin  F2 := 610;  F1:= 987; end
   else begin F2 := 987; F1 := 1597; end;
row:=0;
wide := F2;
//bm.temp.Width := bm.ClientWidth;    // This is here to correct a resize problem
//bm.temp.Height := bm.ClientHeight;  // with temp.scanline
//PatBlt(bm.temp.canvas.handle,0,0,bm.temp.width,bm.temp.height,BLACKNESS);

//if ColMode = 0 then bm.timer2.enabled := true; // Enable ScanLines only with Normal Coloring Mode.

 FOR XX:= 0  TO F2 DO
   BEGIN
     if ProgressBarOn then inc(xana);
     row := (row+F1) mod F2;
     if (row < wide) then wide := row;
     if (row < maxy) then
       begin
         Application.ProcessMessages;
         if escpressed then
           begin  escpressed:= False;  break; end;
        for col:=0 to maxx do
          begin
            FractalProc(col,row);
          end;
       end;
     if ProgressBarOn then
       Info.G1.Progress := (100 * xana) div PLN;
    END;

goto bailout;

FatLine:  //********** Use Fat Line Suffling Algorithm. *********************/
if maxx < 850 then
   begin  F2 := 610;  F1:= 987; end
   else begin F2 := 987; F1 := 1597; end;
row:=0;
wide := F2;
bm.temp.Width := bm.ClientWidth;    // This is here to correct a resize problem
bm.temp.Height := bm.ClientHeight;  // with temp.scanline
PatBlt(bm.temp.canvas.handle,0,0,bm.temp.width,bm.temp.height,BLACKNESS);

if ColMode = 0 then bm.timer2.enabled := true; // Enable ScanLines only with Normal Coloring Mode.

 FOR XX:= 0  TO F2 DO
   BEGIN
     if ProgressBarOn then inc(xana);
     row := (row+F1) mod F2;
     if (row < wide) then wide := row;
     if (row < maxy) then
       begin
         Application.ProcessMessages;
         if escpressed then
           begin  escpressed:= False;  break; end;
        for col:=0 to maxx do
          begin
            FractalProc(col,row);
          end;
       end;
     if ProgressBarOn then
       Info.G1.Progress := (100 * xana) div PLN;
    END;

 bm.timer2.enabled := false;
if colmode = 0 then bm.Repaint;

goto bailout;

FatPixel:  //********** Use Fat Pixel Suffling Algorithm. *********************/

col:=0;
row:=0;
wide := 2;
G3 := G1*G2;
bm.temp.Width := bm.ClientWidth;    // This is here to correct a resize problem
bm.temp.Height := bm.ClientHeight;  // with temp.scanline
PatBlt(bm.temp.canvas.handle,0,0,bm.temp.width,bm.temp.height,BLACKNESS);
if ColMode = 0 then bm.timer2.enabled := true;

 FOR XX:= 0  TO G3 DO
   BEGIN
     if (XX = 150692 {152692}) then wide := 1;
     if (XX = 263519 {265519}) then wide := 0;

     if ProgressBarOn then inc(xana);
     col := (col + INCR) mod G1;
     row := (row + INCR) mod G2;
     if ((row < maxy) and (col < maxx)) then
       begin
         Application.ProcessMessages;
         if escpressed then
           begin  escpressed:= False;  break; end;
         if (wide = 0 ) then RowRGB := bm.temp.ScanLine[row];
         FractalProc(col,row);
       end;
     if ProgressBarOn then
       Info.G1.Progress := (100 * xana) div PLN;
    END; // for XX
bm.timer2.enabled := false;
if ColMode = 0 then  bm.Repaint;
goto bailout;

SplitScreen: //************************Use  Split Screen Method *********************/
 Application.ProcessMessages;
 FractalProc(0,0);
 FractalProc(maxx,0);
 FractalProc(maxx,maxy);
 FractalProc(0,maxy);
 SplitAll(0,0,maxx,maxy);
 escpressed := False;
goto bailout;
Interlace:  //************************Use  Interlace Method *********************/
 //cnt := 0;
 xana := 0;
 InterlacePass := 1; Step := 8; Intstart := 0;
 col := Intstart;
 while col <= maxx do
 begin
  Application.ProcessMessages;
  if escpressed then begin escpressed:= False; break; end;
  for row := 0 to maxy do
    FractalProc(col,row);
  col := col + Step;
  //inc(cnt);
  inc(xana);
  if col > maxx then
     begin
       inc(InterlacePass);
       if InterlacePass = 5 then goto bailout;
       case InterlacePass of
        1 : begin Step := 8; Intstart := 0; end;
        2 : begin Step := 8; Intstart := 4; end;
        3 : begin Step := 4; Intstart := 2; end;
        4 : begin Step := 2; Intstart := 1; end;
       end; // case.
       col := Intstart;
     end; // if
  if ProgressBarOn then
    Info.G1.Progress := (100 * xana {cnt}) div maxx ;
 end; // while col loop.
 goto bailout;
//********************** Curtain *******************************************
Curtain:
if FractalCompleted then savedCurtainCol := 0;
for col := {0}savedCurtainCol to halfx do
 begin
  Application.ProcessMessages;
  if escpressed then
    begin
      escpressed:= False;
      savedCurtainCol:= col-2;
      FractalCompleted:= false;
      goto bailout;
    end;
  for row := 0 to maxy do FractalProc(col,row);
   col2 := maxx-col;
  for row := 0 to maxy do FractalProc(col2,row);
   if ProgressBarOn then begin
    Info.G1.Progress := (100 * col) div halfx;
  end;
end; // col
FractalCompleted:= true;
goto bailout;
//********************* Oposite Half ***************************************
Oposite:
if FractalCompleted then savedOpositeCol := 0;
for col := {0}savedOpositeCol to maxx do
 begin
  Application.ProcessMessages;
  if escpressed then
    begin
     savedOpositeCol := col-2;
     escpressed:= False;
     FractalCompleted := false;
     goto bailout;
    end;
  for row := 0 to halfy do FractalProc(col,row);
  for row2 := halfy-1 to maxy do FractalProc(maxx-col,row2);
  if ProgressBarOn then  Info.G1.Progress := (100 * col) div maxx;
end; // col
FractalCompleted:= true;
goto bailout;

//********************** Helix Coil *******************************************
Helix:
row:=0; //row2:=0;
if FractalCompleted then savedHelixG := 0;
for g:= {0} savedHelixG to max(maxx,maxy) do
begin
  Application.ProcessMessages;
  if escpressed then
    begin
      savedHelixG := g-4;
      escpressed:= False;
      FractalCompleted := false;
      goto bailout;
    end;
  for col  := g to maxx-g do FractalProc(col+1,row);
  for row  := g to maxy-g do FractalProc(col,row+1);
  for col2 := g to maxx-g do FractalProc(col2+1,g);
  for row2 := g to maxy-g do FractalProc(g+1,row2+1);

   if ProgressBarOn then
      Info.G1.Progress := (100 *2* g) div max(maxx,maxy);
end;
FractalCompleted := true;

bailout:
info.g1.Visible := false;
endjob;
BM.WalkMenu.Enabled := True;
end;

procedure Julia;
var
xn,yn,a,b : Extended;
i,sx,sy: Integer;
label
100,150,200,300,bailout;
begin
FractalInit;
FractalCompleted := true;
 //color1 := clBlue; //Random( 16777215);
 xn := recen; //0.25;
 yn := imcen; //0;
 sx := maxx div 3;
 sy := maxy div 3;
 rec := Julx; //stepx+recen;   // 17-5-98  Get Starting Parameters from mouse Position
 imc := July; //imcen;         // 17-5-98  On the Mandelbrot Set.
 for i := 1 to 30000 do
 begin
   a := xn-rec;
   b := yn-imc;
   // compute sqr with re>=0
   if a > 0 then goto 100;
   if a < 0 then goto 150;
   xn := sqrt(abs(b)/2);
   if xn > 0 then yn := b/(2*xn)
   else yn:=0;
   goto 200;
100: xn := sqrt((sqrt(a*a+b*b)+a)/2);
     yn:= b/(2*xn);
     goto 200;
150: yn := sqrt((sqrt(a*a+b*b)-a)/2);
     if b < 0 then yn := -yn;
     xn := b/(2*yn);
     // first step is computation of repelling fixed point.
200: if i=1 then xn := xn + 0.5;
     // choose one of the two symmetric roots at random

     if random < 0.5 then goto 300;   //<-----------------------
     xn := -xn;
     yn := -yn;
300: Application.ProcessMessages;
     if escpressed then begin escpressed:= False; goto bailout; end;
     BM.Canvas.Pixels[round(xn*sx)+halfx,round(yn*sy)+halfy] := pal[random(254)+1];//color1;
     if ProgressBarOn then
       Info.G1.Progress := (100 * i) div 30000;
end;
bailout:
Info.G1.Visible := false;
endjob;
end;

procedure Orbits;
var
i: Integer;
label sub200,bailout;
begin
FractalInit;
FractalCompleted := true;
k := kstart;
BM.StUpdate;
while (k <= kend) do
   begin
    color1 := Pal[(k mod 255)+1];
//************** Βρές Το Όριο της Τροχιάς *******************
    for i := 0 to 10000 do
     begin
      rec := stepx*i+recen;
      imc := imcen;
      sub500;
      if outside then break;
     end;
//************* Τοποθέτησε το τρίγωνο στο Όριο ************************
	 vin := 1; vout := 2; vnew := 3;
	 x[vin] := i-1; x[vout] := i;  x[vnew] := i;
	 y[vin] := 0; y[vout] := 0;  y[vnew] := 1;
	 xin := x[vin];  yin := y[vin];
	 xout := x[vout];   yout := y[vout];
         //BM.Canvas.MoveTo(x[vin]+halfx, y[vin]+halfy);
//************ Ψάξε το Όριο της Τροχιάς ************************
sub200: rec := stepx*x[vnew]+recen;
	 imc := stepy*y[vnew]+imcen;
         // ’σε τον χρήστη να διακόψη την επεξεργασία.
         Application.ProcessMessages;
         if escpressed then begin escpressed:= False; goto bailout; end;
	 sub500;
	 if outside then
           begin
	    vref := vout; vout := vnew; vnew := vref;
           end
	 else
           begin
          // BM.Canvas.LineTo(x[vnew]+halfx, y[vnew]+halfy);
          BM.Canvas.Pixels[x[vnew]+halfx, y[vnew]+halfy] := color1;
	   vref := vin; vin := vnew;  vnew := vref;
	   end;
	 x[vnew] := x[vin]+x[vout]-x[vref];
	 y[vnew] := y[vin]+y[vout]-y[vref];
	 if( (x[vin] <> xin) or (y[vin] <> yin) ) then goto sub200;
	 if( (x[vout] <> xout) or (y[vout] <> yout) ) then goto sub200;

     Info.Label11.Caption  := IntToStr(k);
     inc(k,kstep);
    if ProgressBarOn then
    Info.G1.Progress := (100 * k) div kend;
    end;
bailout:
Info.G1.Visible := false;
endjob;
end;

procedure sub500;
var
j : Integer;

begin
  outside := True;
  newx := -x[vnew]+halfx;
  newy := -y[vnew]+halfy;
  if( ( newx > maxx ) or ( newx < 0 ) ) then exit;
  if( ( newy > maxy ) or ( newy < 0 ) ) then exit;
  re := rec; im := imc;
  for j :=0 to k do
    begin
      re2 := re*re; im2 := im*im;
      if( (re2+im2) > 256 ) then exit;
      im := 2*re*im+imc;
      re := re2-im2+rec;
    end;
  outside := False;
end;

procedure SierpinskiFunc;
var
row,col : Integer;
begin
FractalCompleted := true;
inc(passes);
 with BM.Canvas do
 begin
   Pen.Mode := pmCopy;
   Pen.Width := 1;
   Brush.Style := bsSolid;
   Brush.Color := BM.Color; //BackgrndColor ;
end;
Screen.Cursor := crHourglass;
 for col := 0 to maxx do
 begin
  Application.ProcessMessages;
  if escpressed then begin escpressed:= False; break; end;
  for row := 0 to maxy do
  if (col and (row-col )) = 0 then BM.Canvas.Pixels[col,row ] := clBlue;
 end;
Screen.Cursor := crDefault;
BM.temp.Width := BM.ClientWidth;
BM.temp.Height := BM.ClientHeight;
BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
Working := False;
end;

procedure DoLoadIfs(Fnm: String);
var
Ini: TIniFile;
j : Integer;
i,k,px,py,times : Integer;
p_cum : array[0..127] of Extended;
tx1,ty1 : Extended;
label
here,bailout;
begin
 Ini := TIniFile.Create(Fnm);
 Ini.ReadString(s12,'NAME',Fnm);
 transforms := Ini.ReadInteger(s12,'TRANSFORMS',transforms);
 PaletteName := Ini.ReadString(s12,'Palette Name','');
 if PaletteName = '' then
   InitPalete
  else FastLoadPal;
 BM.StUpdate;
 j:=0;
 while j < transforms do
  begin
  a[j] := StrToFloat(Ini.ReadString(s12,'a['+IntToStr(j)+']',Format('%10.9f',[a[j]])));
  b[j] := StrToFloat(Ini.ReadString(s12,'b['+IntToStr(j)+']',Format('%10.9f',[b[j]])));
 cc[j] := StrToFloat(Ini.ReadString(s12,'cc['+IntToStr(j)+']',Format('%10.9f',[cc[j]])));
  d[j] := StrToFloat(Ini.ReadString(s12,'d['+IntToStr(j)+']',Format('%10.9f',[d[j]])));
  e[j] := StrToFloat(Ini.ReadString(s12,'e['+IntToStr(j)+']',Format('%10.9f',[e[j]])));
  f[j] := StrToFloat(Ini.ReadString(s12,'f['+IntToStr(j)+']',Format('%10.9f',[f[j]])));
  p[j] := StrToFloat(Ini.ReadString(s12,'p['+IntToStr(j)+']',Format('%10.9f',[p[j]])));
  inc(j);
  end;
  while j < transforms+3 do
  begin
    a[j] := 0.00000;
    b[j] := 0.00000;
   cc[j] := 0.00000;
    d[j] := 0.00000;
    e[j] := 0.00000;
    f[j] := 0.00000;
    p[j] := 0.00000;
    inc(j);
  end;
Ini.Free;
CopyUndoBmp;
BM.clrscr;
Randomize;
inc(passes);
escpressed := False;
Working := True;
Screen.Cursor := crHourglass;
with BM.Canvas do
 begin
   Pen.Mode := pmCopy;
   Pen.Width := 1;
   Brush.Style := bsSolid;
end;
ifsx:=0.0; ifsy:=0.0;
p_sum := 0; flag:=0;
xscale := 0.0; yscale := 0.0;
xoffset:=0; yoffset:=0;
xxmax:=0.000000; xxmin:=0.000000;
yymax:=0.000000; yymin:=0.000000;
if TimerOn then begin   // Added 5-9-98
   BM.Timer1.Enabled :=True;
   StartTime := Time;
 end;
i:=0;
while i < transforms do
 begin
  p_sum    := p_sum + p[i];
  p_cum[i] := p_sum * 65767;
  inc(i);
 end;
times := 0;
while times < Iters do
begin
//ForeColor := pal[times mod 255];   // 4-4-99 Paint with palette colors,
i:=0;
while i < 256 do
 begin
   tmp := random(65766)+1;
   k:=0;
   while k < transforms do
     begin
     if(tmp < p_cum[k]) then goto here;
     inc(k);
     end;
   dec(k);
here:
   newx1 := a[k] * ifsx + b[k] * ifsy + e[k];
   ifsy    := cc[k] * ifsx + d[k] * ifsy + f[k];
   ifsx    := newx1;
   if ((flag=0) and (i>15)) then
    begin
     xxmax := max(ifsx,xxmax);
     xxmin := min(ifsx,xxmin);
     yymax := max(ifsy,yymax);
     yymin := min(ifsy,yymin);
    end
    else
    begin
     px := round(ifsx * xscale + xoffset);
     py := round(ifsy * yscale + yoffset);
     if ((px >= 0) and (px < maxx) and (py >= 0) and (py < maxy)) then
        BM.Canvas.Pixels[px,maxy-py] := pal[times mod 255];   // 4-4-99 Paint with palette colors,//ForeColor;
    end;
  inc(i);
 end; // i loop.
 if flag = 0 then
  begin
   tx1 := xxmax - xxmin;
   ty1 := yymax - yymin;
   if tx1 > 0 then  xscale := maxx / tx1;
   if ty1 > 0 then  yscale := min(maxy / ty1,xscale/1.38);
   if (yscale < xscale/1.38) then xscale := 1.38 * yscale;
   xoffset := (halfx - round((xxmax + xxmin)*xscale/2));
   yoffset := (halfy - round((yymax + yymin)*yscale/2));
   flag := 1;
  end;
  inc(times);
  Application.ProcessMessages;
  if escpressed then begin escpressed:= False; break; end;
 end; // while loop.
bailout:  endjob;
end;

function sign: Integer;
var i : Extended;
begin
 i := random;
 if i > 0.6 then result := 1
 else if i > 0.1 then result :=  -1
 else result := 0;
end;

procedure DoIfs;
var
i,k,px,py,times : Integer;
p_cum : array[0..127] of Extended;
tx1,ty1 : Extended;
label
fern,SierpTr,Tree,KantorTree,Leaf,Circle1,here,Elifrac, //fractint,
Randoms,binary,coral,crystal,dragon,Custom,doit,bailout; //,bail2;
begin
ifsform.showmodal;
if ifsform.ModalResult = mrOk then
begin
Application.ProcessMessages;
CopyUndoBmp;
BM.clrscr;
Randomize;
inc(passes);
escpressed := False;
Working := True;
Screen.Cursor := crHourglass;
x1 := 0; y1 := 0;
x2 := maxx; y2 := maxy;
A1:=x1; B1:=y1; C1:=x2; D1:=y2;
with BM.Canvas do
 begin
   Pen.Mode := pmCopy;
   Pen.Width := 1;
   Brush.Style := bsSolid;
end;
ifsx:=0.0; ifsy:=0.0;
p_sum := 0; flag:=0;
xscale := 0.0; yscale := 0.0;
xoffset:=0; yoffset:=0;

case ifsform.RadioG1.itemindex of
 0: goto fern;
 1: goto SierpTr;
 2: goto Tree;
 3: goto KantorTree;
 4: goto Leaf;
 5: goto Circle1;
 6: goto binary;
 7: goto coral;
 8: goto crystal;
 9: goto dragon;
10: goto Randoms;
11: goto Custom;
12: goto Elifrac;
//13: goto fractint;
end; // case


end
else exit; //goto bail2;

fern:
xxmax:=0.000000; xxmin:=0.000000;
yymax:=0.300000; yymin:=0.000000;
transforms := 5;
a[0]:= 0.0;     a[1]:= 0.20000;  a[2]:= -0.1500;  a[3]:= 0.85000;
b[0]:= 0.0;     b[1]:= -0.2600;  b[2]:= 0.28000;  b[3]:= 0.04000;
cc[0]:= 0.0;    cc[1]:= 0.2300;  cc[2]:= 0.2600;  cc[3]:= -0.0400;
d[0]:= 0.1600;  d[1]:= 0.2200;   d[2]:= 0.2400;   d[3]:= 0.8500;
e[0]:= 0.0;     e[1]:= 0.0;      e[2]:= 0.0;      e[3]:= 0.0;
f[0]:= 0.0;     f[1]:= 0.2000;   f[2]:= 0.2000;   f[3]:= 0.2000;
p[0]:= 0.0100;  p[1]:= 0.0700;   p[2]:= 0.0700;   p[3]:= 0.8500;

goto doit;

SierpTr:
xxmax:=0.0000; xxmin:=0.0000;
yymax:=0.0000; yymin:=0.000;
transforms := 3;
a[0]:= 0.50000;     a[1]:= 0.50000;  a[2]:= 0.50000;
b[0]:= 0.0;         b[1]:= 0.0;      b[2]:= 0.0;
cc[0]:= 0.0;        cc[1]:= 0.0;     cc[2]:= 0.0;
d[0]:= 0.50000;     d[1]:= 0.50000;  d[2]:= 0.50000;
e[0]:= 0.0;         e[1]:= 1.0000;   e[2]:= 0.50000;
f[0]:= 0.0;         f[1]:= 0.0;      f[2]:= 0.5000;
p[0]:= 0.3333;      p[1]:= 0.3333;   p[2]:= 0.3333;
goto doit;

Tree:
xxmax:=0; xxmin:=0;
yymax:=0; yymin:=0;
transforms := 4;
a[0]:= 0.0;     a[1]:= 0.10000;  a[2]:= 0.42000;   a[3]:= 0.42000;
b[0]:= 0.0;     b[1]:= 0.0;      b[2]:= -0.42000;  b[3]:= 0.42000;
cc[0]:= 0.0;    cc[1]:= 0.0;     cc[2]:= 0.42000;  cc[3]:= -0.42000;
d[0]:= 0.5000;  d[1]:= 0.1000;   d[2]:= 0.4200;    d[3]:= 0.4200;
e[0]:= 0.0;     e[1]:= 0.0;      e[2]:= 0.0;       e[3]:= 0.0;
f[0]:= 0.0;     f[1]:= 0.2000;   f[2]:= 0.2000;    f[3]:= 0.2000;
p[0]:= 0.0500;  p[1]:= 0.1500;   p[2]:= 0.4000;    p[3]:= 0.4000;
goto doit;

KantorTree:
xxmax:=1; xxmin:=0;
yymax:=0; yymin:=0;
transforms := 3;
a[0]:= 0.33333;     a[1]:= 0.33333;  a[2]:= 0.66667;
b[0]:= 0.0;         b[1]:= 0.0;      b[2]:= 0.0;
cc[0]:= 0.0;        cc[1]:= 0.0;     cc[2]:= 0.0;
d[0]:= 0.3333;      d[1]:= 0.3333;   d[2]:= 0.6667;
e[0]:= 0.0;         e[1]:= 1.0000;   e[2]:= 0.50000;
f[0]:= 0.0;         f[1]:= 0.0;      f[2]:= 0.5000;
p[0]:= 0.3333;      p[1]:= 0.3333;   p[2]:= 0.3334;
goto doit;

Leaf:
xxmax := 1.0; xxmin := 0.0;
yymax := 0.0; yymin := 0.0;
transforms := 5;
a[0]:= 0.35173;     a[1]:= 0.35338;  a[2]:= 0.50000;   a[3]:= 0.50154;    a[4]:= 0.00364;
b[0]:= 0.35537;     b[1]:= -0.3537;  b[2]:= 0.0;       b[3]:= -0.0018;    b[4]:= 0.0;
cc[0]:= -0.35537;   cc[1]:= 0.35373; cc[2]:= 0.0;      cc[3]:= 0.00157;   cc[4]:= 0.0;
d[0]:= 0.35173;     d[1]:= 0.35338;  d[2]:= 0.50000;   d[3]:= 0.58795;    d[4]:= 0.57832;
e[0]:= 0.3545;      e[1]:= 0.2879;   e[2]:= 0.2500;    e[3]:= 0.2501;     e[4]:= 0.5016;
f[0]:= 0.50000;     f[1]:= 0.1528;   f[2]:= 0.4620;    f[3]:= 0.1054;     f[4]:= 0.0606;
p[0]:= 0.1773;      p[1]:= 0.3800;   p[2]:= 0.1773;    p[3]:= 0.2091;     p[4]:= 0.0562;
goto doit;

Circle1:
xxmax:=1; xxmin:=0;
yymax:=0; yymin:=0;
transforms := 6;
a[0]:= 0.15596;     a[1]:= 0.04428;  a[2]:= 0.05566;   a[3]:= 0.11540;    a[4]:= 0.27142;
b[0]:= 0.98776;     b[1]:= 0.0;      b[2]:= 0.5;       b[3]:= 0.0;        b[4]:= 0.0;
cc[0]:= -0.98776;   cc[1]:= 0.0;     cc[2]:= 0.0;      cc[3]:= 0.0;       cc[4]:= 0.0;
d[0]:= 0.15596;     d[1]:= 0.04116;  d[2]:= 0.04527;   d[3]:= 0.05094;    d[4]:= 0.04932;
e[0]:= -0.0779;     e[1]:= 0.0641;   e[2]:= 0.0998;    e[3]:= 0.1428;     e[4]:= 0.2380;
f[0]:= 0.9124;      f[1]:= 0.4829;   f[2]:= 0.4779;    f[3]:= 0.4761;     f[4]:= 0.4781;
p[0]:= 0.9866;      p[1]:= 0.0032;   p[2]:= 0.0029;    p[3]:= 0.0036;     p[4]:= 0.0036;
goto doit;

binary:
xxmax:=0.1; xxmin:=0;
yymax:=0; yymin:=0;
transforms := 5;
 a[0]:=0.5;  b[0]:=0.0;   cc[0]:=0.0;  d[0]:=0.5; e[0]:=-2.563477; f[0]:=-0.00003;  p[0]:=0.333333;
 a[1]:=0.5;  b[1]:=0.0;   cc[1]:=0.0;  d[1]:=0.5; e[1]:=2.436544;  f[1]:=-0.00003;  p[1]:=0.333333;
 a[2]:=0.0;  b[2]:=-0.5;  cc[2]:=0.5;  d[2]:=0.0; e[2]:=4.873085;  f[2]:=7.563492;  p[2]:=0.333333;

goto doit;

//goto doit;

coral:
xxmax:=0.1; xxmin:=0;
yymax:=0; yymin:=0;
transforms := 3;
 a[0]:= 0.307692; b[0]:=-0.531469; cc[0]:= -0.461538;  d[0]:=-0.293706; e[0]:= 5.401953; f[0]:= 8.655175; p[0]:=0.40;
 a[1]:= 0.307692; b[1]:=-0.076923; cc[1]:= 0.153846;   d[1]:=-0.447552; e[1]:=-1.295248; f[1]:= 4.152990; p[1]:=0.15;
 a[2]:= 0.000000; b[2]:= 0.545455; cc[2]:= 0.692308;   d[2]:=-0.195804; e[2]:=-4.893637; f[2]:= 7.269794; p[2]:=0.45;
goto doit;

crystal:
xxmax:=0.1; xxmin:=0;
yymax:=0; yymin:=0;
transforms := 2;
  a[0]:=0.696970;  b[0]:=-0.481061; cc[0]:=-0.393939; d[0]:=-0.662879; e[0]:=2.147003;  f[0]:=10.310288; p[0]:=0.747826;
  a[1]:=0.090909;  b[1]:=-0.443182; cc[1]:=0.515152;  d[1]:=-0.094697; e[1]:=4.286558;  f[1]:=2.925762;  p[1]:=0.252174;
goto doit;

dragon:
xxmax:=0.1; xxmin:=0;
yymax:=0; yymin:=0;
transforms := 2;
 a[0]:=0.824074; b[0]:=0.281482; cc[0]:=-0.212346;  d[0]:=0.864198;  e[0]:=-1.882290; f[0]:=-0.110607; p[0]:=0.787473;
 a[1]:=0.088272; b[1]:=0.520988; cc[1]:=-0.463889;  d[1]:=-0.377778; e[1]:=0.785360;  f[1]:=8.095795;  p[1]:=0.212527;
goto doit;

Randoms:
xxmax:=0.000000; xxmin:=0.000000;
yymax:=0.300000; yymin:=0.000000;
transforms := 5;
a[0]:= sign * Random;  a[1]:= sign * Random;   a[2]:= sign * Random;   a[3]:= sign * Random;
//a[4]:= sign * Random;  a[5]:= sign * Random;   a[6]:= sign * Random;   a[7]:= sign * Random;
b[0]:= sign * Random;  b[1]:= sign * Random;   b[2]:= sign * Random;   b[3]:= sign * Random;
//b[4]:= sign * Random;  b[5]:= sign * Random;   b[6]:= sign * Random;   b[7]:= sign * Random;
cc[0]:= sign * Random; cc[1]:= sign * Random;  cc[2]:= sign * Random;  cc[3]:= sign * Random;
//cc[4]:= sign * Random; cc[5]:= sign * Random;  cc[6]:= sign * Random;  cc[7]:= sign * Random;
d[0]:= sign * Random;  d[1]:= sign * Random;   d[2]:= sign * Random;   d[3]:= sign * Random;
//d[4]:= sign * Random;  d[5]:= sign * Random;   d[6]:= sign * Random;   d[7]:= sign * Random;
e[0]:= sign * Random;  e[1]:= sign * Random;   e[2]:= sign * Random;   e[3]:= sign * Random;
//e[4]:= sign * Random;  e[5]:= sign * Random;   e[6]:= sign * Random;   e[7]:= sign * Random;
f[0]:= sign * Random;  f[1]:= sign * Random;   f[2]:= sign * Random;   f[3]:= sign * Random;
//f[4]:= sign * Random;  f[5]:= sign * Random;   f[6]:= sign * Random;   f[7]:= sign * Random;
p[0]:= sign * Random;  p[1]:= sign * Random;   p[2]:= sign * Random;   p[3]:= sign * Random;
//p[4]:= sign * Random;  p[5]:= sign * Random;   p[6]:= sign * Random;   p[7]:= sign * Random;
goto doit;

Elifrac:
xxmax:=0.000000; xxmin:=0.000000;
yymax:=0.00000; yymin:=5.000000;
transforms := 21;
a[0]:= -0.000000;   b[0]:=  -0.105480;  cc[0]:=  0.268143;    d[0]:=  0.013185;    e[0]:=  -6.258407;  f[0]:=  5.186315;    p[0]:=  0.086358;
a[1]:= 0.066020;    b[1]:=  0.020000;   cc[1]:=  -0.002462;   d[1]:=  0.110000;    e[1]:=  -6.018518;  f[1]:=  6.167277;    p[1]:=  0.009446;
a[2]:= 0.060000;    b[2]:=  0.020000;   cc[2]:=  -0.000000;   d[2]:=  0.100000;    e[2]:=  -6.240711;  f[2]:=  4.638798;    p[2]:=  0.008536;
a[3]:= -0.000535;   b[3]:=  -0.097266;  cc[3]:=  0.262214;    d[3]:=  -0.000000;   e[3]:=  -4.366328;  f[3]:=  5.236551;    p[3]:=  0.084449;
a[4]:= -0.066394;   b[4]:=  0.013185;   cc[4]:=  0.003494;    d[4]:=  -0.105480;   e[4]:=  -4.281816;  f[4]:=  4.163312;    p[4]:=  0.008932;
a[5]:= -0.000000;   b[5]:=  -0.145899;  cc[5]:=  0.266380;    d[5]:=  0.016211;    e[5]:=  -2.430851;  f[5]:=  5.097676;    p[5]:=  0.085791;
a[6]:= -0.004296;   b[6]:=  -0.129688;  cc[6]:=  -0.270676;   d[6]:=  -0.000000;   e[6]:=  -1.428406;  f[6]:=  5.096772;    p[6]:=  0.087185;
a[7]:= 0.068743;    b[7]:=  0.016211;   cc[7]:=  -0.000000;   d[7]:=  0.081055;    e[7]:=  -1.417860;  f[7]:=  4.692876;    p[7]:=  0.006919;
a[8]:= -0.004296;   b[8]:=  0.145899;   cc[8]:=  -0.279269;   d[8]:=  -0.016211;   e[8]:=  -0.704205;  f[8]:=  5.149518;    p[8]:=  0.089952;
a[9]:= 0.098818;    b[9]:=  -0.016211;  cc[9]:=  -0.000000;   d[9]:=  0.113477;    e[9]:=  1.189226;   f[9]:=  4.525629;    p[9]:=  0.031826;
a[10]:= -0.085929;  b[10]:=  -0.000000; cc[10]:=  -0.000000;  d[10]:=  -0.081055;  e[10]:=  -1.117566; f[10]:=  7.245748;   p[10]:=  0.027674;
a[11]:= 0.093597;   b[11]:=  -0.000000; cc[11]:=  -0.000740;  d[11]:=  0.081055;   e[11]:=  1.224829;  f[11]:=  6.357027;   p[11]:=  0.030145;
a[12]:= 0.081632;   b[12]:=  0.016211;  cc[12]:=  -0.120300;  d[12]:=  0.081055;   e[12]:=  0.960222;  f[12]:=  3.573922;   p[12]:=  0.046822;
a[13]:= -0.068743;  b[13]:=  0.016211;  cc[13]:=  -0.000000;  d[13]:=  -0.145899;  e[13]:=  6.270723;  f[13]:=  7.523020;   p[13]:=  0.012453;
a[14]:= -0.000000;  b[14]:=  -0.097266; cc[14]:=  0.300751;   d[14]:=  0.016211;   e[14]:=  6.101741;  f[14]:=  4.935083;   p[14]:=  0.096860;
a[15]:= -0.051557;  b[15]:=  0.113477;  cc[15]:=  -0.270676;  d[15]:=  0.032422;   e[15]:=  2.397464;  f[15]:=  4.815084;   p[15]:=  0.088742;
a[16]:= 0.072853;   b[16]:=  0.081055;  cc[16]:=  -0.278495;  d[16]:=  0.032422;   e[16]:=  3.943490;  f[16]:=  4.750647;   p[16]:=  0.092711;
a[17]:= 0.077336;   b[17]:=  0.002594;  cc[17]:=  -0.000000;  d[17]:=  0.088080;   e[17]:=  -5.956240; f[17]:=  3.156488;   p[17]:=  0.024907;
a[18]:= -0.000000;  b[18]:=  -0.081055; cc[18]:=  -0.085929;  d[18]:=  0.016211;   e[18]:=  2.270124;  f[18]:=  5.805788;   p[18]:=  0.027674;
a[19]:= 0.081632;   b[19]:=  0.032422;  cc[19]:=  -0.000000;  d[19]:=  0.048633;   e[19]:=  3.537388;  f[19]:=  4.516795;   p[19]:=  0.026291;
a[20]:= 0.081632;   b[20]:=  -0.000000; cc[20]:=  0.004297;   d[20]:=  -0.129688;  e[20]:=  6.451256;  f[20]:=  3.835590;   p[20]:=  0.026327;
goto doit;

//fractint:
{xxmax:=0.000000; xxmin:=0.000000;
yymax:=0.00000; yymin:=5.000000;
transforms := 22;
a[0]:=  0.00; b[0]:=  -0.11; cc[0]:=  0.22; d[0]:=  0.00;  e[0]:= -6.25; f[0]:=  4.84; p[0]:=  0.06;
a[1]:=  0.11; b[1]:=   0.02; cc[1]:=  0.00; d[1]:=  0.11;  e[1]:= -6.30; f[1]:=  5.99; p[1]:=  0.03;
a[2]:=  0.06; b[2]:=   0.02; cc[2]:=  0.00; d[2]:=  0.10;  e[2]:= -6.25; f[2]:=  4.51; p[2]:=  0.02;
a[3]:=  0.00; b[3]:=  -0.11; cc[3]:=  0.22; d[3]:=  0.00;  e[3]:= -4.34; f[3]:=  4.84; p[3]:=  0.06;
a[4]:=  0.08; b[4]:=   0.00; cc[4]:=  0.00; d[4]:=  0.11;  e[4]:= -4.50; f[4]:=  5.99; p[4]:=  0.02;
a[5]:=  0.00; b[5]:=   0.11; cc[5]:= -0.08; d[5]:=  0.00;  e[5]:= -4.30; f[5]:=  6.15; p[5]:=  0.02;
a[6]:= -0.09; b[6]:=   0.00; cc[6]:= -0.01; d[6]:= -0.13;  e[6]:= -4.15; f[6]:=  5.94; p[6]:=  0.02;
a[7]:=  0.06; b[7]:=   0.11; cc[7]:= -0.13; d[7]:=  0.00;  e[7]:= -4.69; f[7]:=  4.15; p[7]:=  0.04;
a[8]:=  0.03; b[8]:=  -0.11; cc[8]:=  0.23; d[8]:=  0.11;  e[8]:= -2.26; f[8]:=  4.43; p[8]:=  0.07;
a[9]:=  0.03; b[9]:=   0.11; cc[9]:= -0.25; d[9]:=  0.00;  e[9]:= -2.57; f[9]:=  4.99; p[9]:=  0.07;
a[10]:= 0.06; b[10]:=  0.00; cc[10]:= 0.00; d[10]:= 0.11;  e[10]:=-2.40; f[10]:= 4.46; p[10]:= 0.02;
a[11]:= 0.00; b[11]:=  0.11; cc[11]:=-0.19; d[11]:= 0.00;  e[11]:=-1.62; f[11]:= 4.99; p[11]:= 0.06;
a[12]:= 0.09; b[12]:= -0.01; cc[12]:= 0.00; d[12]:= 0.10;  e[12]:=-0.58; f[12]:= 2.96; p[12]:= 0.03;
a[13]:=-0.09; b[13]:=  0.00; cc[13]:= 0.00; d[13]:=-0.11;  e[13]:=-0.65; f[13]:= 7.10; p[13]:= 0.03;
a[14]:= 0.12; b[14]:=  0.00; cc[14]:=-0.00; d[14]:= 0.11;  e[14]:= 1.24; f[14]:= 6.00; p[14]:= 0.03;
a[15]:= 0.00; b[15]:=  0.11; cc[15]:=-0.22; d[15]:= 0.00;  e[15]:= 0.68; f[15]:= 4.80; p[15]:= 0.06;
a[16]:=-0.12; b[16]:=  0.00; cc[16]:= 0.00; d[16]:=-0.13;  e[16]:= 6.17; f[16]:= 7.18; p[16]:= 0.03;
a[17]:= 0.00; b[17]:= -0.11; cc[17]:= 0.22; d[17]:= 0.00;  e[17]:= 6.78; f[17]:= 4.84; p[17]:= 0.06;
a[18]:= 0.00; b[18]:=  0.08; cc[18]:=-0.25; d[18]:= 0.02;  e[18]:= 2.21; f[18]:= 4.95; p[18]:= 0.07;
a[19]:= 0.00; b[19]:= -0.11; cc[19]:= 0.22; d[19]:= 0.00;  e[19]:= 4.10; f[19]:= 4.84; p[19]:= 0.06;
a[20]:= 0.00; b[20]:= -0.11; cc[20]:= 0.22; d[20]:= 0.00;  e[20]:= 5.25; f[20]:= 5.23; p[20]:= 0.06;
a[21]:= 0.08; b[21]:=  0.11; cc[21]:=-0.25; d[21]:= 0.00;  e[21]:= 3.57; f[21]:= 4.99; p[21]:= 0.08;
goto doit;
}

Custom:
xxmax:=0.000000; xxmin:=0.000000;
yymax:=0.000000; yymin:=0.000000;
transforms := 5;

{spiral
   .787879 -.424242 .242424 .859848  1.758647 1.408065 .895652
  -.121212  .257576 .151515 .053030 -6.721654 1.377236 .052174
   .181818 -.136364 .090909 .181818  6.086107 1.568035 .052174


swirl5
   .745455 -.459091  .406061  .887121 1.460279 0.691072 .912675
  -.424242 -.065152 -.175758 -.218182 3.809567 6.741476 .087325
}


doit:
if TimerOn then begin   // Added 5-9-98
   BM.Timer1.Enabled :=True;
   StartTime := Time;
 end;
i:=0;
while i < transforms do
 begin
  p_sum    := p_sum + p[i];
  p_cum[i] := p_sum * 65767;
  inc(i);
 end;
times := 0;
while times < Iters  do
begin
i:=0;
ForeColor := pal[times mod 255];   // 4-4-99 Paint with palette colors,
try
while i < 512 do
 begin
   tmp := random(65766)+1;
   k:=0;
   while k < transforms do
     begin
     if(tmp < p_cum[k]) then goto here;
     inc(k);
     end;
   dec(k);
here:
   newx1 := a[k] * ifsx + b[k] * ifsy + e[k];
   ifsy    := cc[k] * ifsx + d[k] * ifsy + f[k];
   ifsx    := newx1;
   if ((flag=0) and (i>15)) then
    begin
     xxmax := max(ifsx,xxmax);
     xxmin := min(ifsx,xxmin);
     yymax := max(ifsy,yymax);
     yymin := min(ifsy,yymin);
    end
    else
    begin
     px := round(ifsx * xscale + xoffset);
     py := round(ifsy * yscale + yoffset);
     if ((px >= 0) and (px < maxx) and (py >= 0) and (py < maxy)) then
       BM.Canvas.Pixels[px,maxy-py] := ForeColor;
    end;
  inc(i);
 end; // i loop.
 if flag = 0 then
  begin
   tx1 := xxmax - xxmin;
   ty1 := yymax - yymin;
   if tx1 > 0 then  xscale := maxx / tx1;
   if ty1 > 0 then  yscale := min(maxy / ty1,xscale/1.38);
   if (yscale < xscale/1.38) then xscale := 1.38 * yscale;
   xoffset := (halfx - round((xxmax + xxmin)*xscale/2));
   yoffset := (halfy - round((yymax + yymin)*yscale/2));
   flag := 1;
  end;
  inc(times);
  Application.ProcessMessages;
  if escpressed then begin escpressed:= False; break; end;
 except
  begin
   MessageDlg(' EliFrac Will Stop This Job Now Because of A Math Error',mtError, [mbOk], 0);
   endjob; exit;
  end;
 end;
 end; // while loop.
bailout:
Info.G1.Visible := false;
Screen.Cursor := crDefault;
Working := False;
if TimerOn then  BM.Timer1.Enabled := False;
endjob;

end;


procedure turn(angle: Extended);
begin
TurtleTheta := TurtleTheta + angle;
end;

procedure generate(type1:Integer;XX1,YY1,XX2,YY2,linedim:Extended;level:Integer);
var
j: Integer;
turtle_r : Extended;
begin
if type1=0 then turtletheta:=YY2;
turtle_r := linedim/divisor;
turtlex := XX1;
turtley := YY1;
level := level-1;
for j:=0 to lslength[type1] do
  begin
    case generator[type1][j] of
    'd' : step(1,level,turtle_r);
    'D' : step(2,level,turtle_r);
    'T' : step(7,level,turtle_r);
    'B' : step(8,level,turtle_r);
    't' : step(9,level,turtle_r);
    'b' : step(10,level,turtle_r);
    'L' : step(3,level,turtle_r);
    'H' : step(11,level,turtle_r);
    'R' : step(4,level,turtle_r);
    'X' : step(5,level,turtle_r);
    'Y' : step(6,level,turtle_r);
    '+' : turn(angle);
    '-' : turn(-angle);
    '[' : begin
           storex[index]:=turtlex;
           storey[index]:=turtley;
           storetheta[index]:=turtletheta;
           inc(index);
          end;
    ']' : begin
           dec(index);
           turtlex:=storex[index];
           turtley:=storey[index];
           turtletheta:=storetheta[index];
          end;
    '{' : turtle_r := turtle_r / div2;
    '}' : turtle_r := turtle_r * div2;
    '<' : turtle_r := turtle_r / div3;
    '>' : turtle_r := turtle_r * div3;
    end; // end case.

  end;  // end j loop.
end;

procedure step(type1,level :Integer; turtle_r :Extended);
var
x1,y1: Extended;
begin
x1:=turtlex;
y1:=turtley;
turtley := turtley + (turtle_r*cos(turtletheta*0.017453292));
turtlex := turtlex + (turtle_r*sin(turtletheta*0.017453292));
if((level<>0) and (type1<>11)) then
   generate(type1,x1,y1,turtlex,turtley,turtle_r,level)
else if type1<>1 then
      begin
       BM.Canvas.MoveTo(round(x1),round(y1));
       BM.Canvas.LineTo(round(turtlex),round(turtley));
      end;
end;

procedure DoLsys;
var
i : Integer;
begin
LsysFrm.ShowModal; // Edit L System Parameters.
if LsysFrm.ModalResult = mrCancel then exit;
BM.Repaint;
inc(passes);
escpressed := False;
Working := True;
Screen.Cursor := crHourglass;
BM.StUpdate;
BM.clrscr;
Application.ProcessMessages;
with BM.Canvas do
 begin
   Pen.Mode := pmCopy;
   Pen.Width := 1; // 7-3-99 commented out so we can change pen width from the tools bar.
                   // Reenable it 31-7-2000 Removed Tools Unit.
   Brush.Style := bsSolid;
   Pen.Color := lsysColor;
 end;
StrPCopy(generator[0],Lsysfrm.Initiator.text );
StrPCopy(generator[1],Lsysfrm.d1gen.text );
StrPCopy(generator[2],Lsysfrm.D2gen.text );
StrPCopy(generator[3],Lsysfrm.Lgen.text );
StrPCopy(generator[4],Lsysfrm.Rgen.text );
StrPCopy(generator[5],Lsysfrm.Xgen.text );
StrPCopy(generator[6],Lsysfrm.Ygen.text );
StrPCopy(generator[7],Lsysfrm.Tgen.text );
startx :=      StrToInt(Lsysfrm.StartX.Text);
starty :=      StrToInt(Lsysfrm.StartY.Text);
startangle :=  StrToInt(Lsysfrm.StartAngle.Text);
divisor :=     StrToFloat(Lsysfrm.Divisor.Text);
div2 :=        StrToFloat(Lsysfrm.Div2.Text);
div3 :=        StrToFloat(Lsysfrm.Div3.Text);
angle :=       StrToFloat(Lsysfrm.angle1.Text);
firstline :=   StrToFloat(Lsysfrm.LineLength.Text);
level :=       StrToInt(Lsysfrm.Lvl.Text);

i:=0;
while generator[7][i] <> #0 do
 begin
  case generator[7][i] of
    '+' : generator[8][i]:='-';
    '-' : generator[8][i]:='+';
    'T' : generator[8][i]:='B';
    'B' : generator[8][i]:='T';
    't' : generator[8][i]:='b';
    'b' : generator[8][i]:='t';
    else  generator[8][i]:= generator[7][i];
    end; // end case
 inc(i);
end; // end while.
generator[8][i]:= #0;
strcopy(generator[9],generator[7]);
StrReverse(generator[9]); // Reverse the String.
strcopy(generator[10],generator[8]);
StrReverse(generator[10]); // Reverse the String.

i:=0;
while generator[9][i] <> #0 do
 begin
  case generator[9][i] of
    '{' : generator[9][i] := '}';
    '}' : generator[9][i] := '{';
    '<' : generator[9][i] := '>';
    '>' : generator[9][i] := '<';
  end; //end case

   case generator[10][i] of
    '{' : generator[10][i] := '}';
    '}' : generator[10][i] := '{';
    '<' : generator[10][i] := '>';
    '>' : generator[10][i] := '<';
  end; //end case
 inc(i);
end; // end while loop.
 for i:=0 to 10 do
   lslength[i]:= strlen(generator[i]);
turtlex:=startx;
turtley:=starty;
linelength[level] := firstline;
generate(0,startx,starty,0,startangle,firstline*divisor,level);

Working := false;
Screen.Cursor := crDefault;
BM.temp.Width := BM.ClientWidth;
BM.temp.Height := BM.ClientHeight;
BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
end;

procedure DoLoadLsys(Fnm: String);
var
Ini: TIniFile;
i : Integer;
s1 : String;
begin
 Ini := TIniFile.Create(Fnm);
 s1 := 'L-System Parameter File';
 LSysFrm.LSName.Text := Ini.ReadString(s1,'FRACTAL NAME',LSysFrm.LSName.Text);
 StrPCopy(generator[0], Ini.ReadString(s1,'Initiator',''));
 StrPCopy(generator[1], Ini.ReadString(s1,'d Generator',''));
 StrPCopy(generator[2], Ini.ReadString(s1,'D Generator',''));
 StrPCopy(generator[3], Ini.ReadString(s1,'L Generator',''));
 StrPCopy(generator[4], Ini.ReadString(s1,'R Generator',''));
 StrPCopy(generator[5], Ini.ReadString(s1,'X Generator',''));
 StrPCopy(generator[6], Ini.ReadString(s1,'Y Generator',''));
 StrPCopy(generator[7], Ini.ReadString(s1,'T Generator',''));
 startx       :=     Ini.ReadInteger(s1,'Start X',Startx);
 starty       :=     Ini.ReadInteger(s1,'Start Y',Startx);
 startangle   :=     Ini.ReadInteger(s1,'Start Angle',startangle);
 divisor      :=     StrToFloat(Ini.ReadString(s1,'Divisor','3'));
 div2         :=     StrToFloat(Ini.ReadString(s1,'Second Divisor','0'));
 div3         :=     StrToFloat(Ini.ReadString(s1,'Third Divisor','0'));
 angle        :=     StrToFloat(Ini.ReadString(s1,'Angle','30'));
 firstline    :=     StrToFloat(Ini.ReadString(s1,'Line Length','300'));
 level        :=     Ini.ReadInteger(s1,'Level',4);

 LSysFrm.Initiator.text := Ini.ReadString(s1,'Initiator',LSysFrm.Initiator.text );
 LSysFrm.d1gen.text :=     Ini.ReadString(s1,'d Generator',LSysFrm.d1gen.text );
 LSysFrm.D2gen.text :=     Ini.ReadString(s1,'D Generator',LSysFrm.D2gen.text );
 LSysFrm.Lgen.text :=      Ini.ReadString(s1,'L Generator',LSysFrm.Lgen.text );
 LSysFrm.Rgen.text :=      Ini.ReadString(s1,'R Generator',LSysFrm.Rgen.text );
 LSysFrm.Xgen.text :=      Ini.ReadString(s1,'X Generator',LSysFrm.Xgen.text );
 LSysFrm.Ygen.text :=      Ini.ReadString(s1,'Y Generator',LSysFrm.Ygen.text );
 LSysFrm.Tgen.text :=      Ini.ReadString(s1,'T Generator',LSysFrm.Tgen.text );
 LSysFrm.StartX.Text :=    IntToStr(StartX);
 LSysFrm.StartY.Text :=    IntToStr(StartY);
 LSysFrm.StartAngle.Text:= IntToStr(Startangle);
 LSysFrm.Divisor.Text :=   floattoStr(divisor);
 LSysFrm.Div2.Text :=      floattoStr(div2);
 LSysFrm.Div3.Text :=      floattoStr(div3);
 LSysFrm.angle1.Text :=    floattoStr(angle);
 LSysFrm.LineLength.Text:= floattoStr(firstline);
 LSysFrm.Lvl.Text :=       IntToStr(level);

 Ini.Free;

inc(passes);
escpressed := False;
Working := True;
Screen.Cursor := crHourglass;
BM.Repaint;
BM.StUpdate;
BM.clrscr;
Application.ProcessMessages;
with BM.Canvas do
 begin
   Pen.Mode := pmCopy;
   //Pen.Width := 1;
   Brush.Style := bsSolid;
   Pen.Color := lsysColor;
 end;
i:=0;
while generator[7][i] <> #0 do
 begin
  case generator[7][i] of
    '+' : generator[8][i]:='-';
    '-' : generator[8][i]:='+';
    'T' : generator[8][i]:='B';
    'B' : generator[8][i]:='T';
    't' : generator[8][i]:='b';
    'b' : generator[8][i]:='t';
    else  generator[8][i]:= generator[7][i];
    end; // end case
 inc(i);
end; // end while.
generator[8][i]:= #0;
strcopy(generator[9],generator[7]);
StrReverse(generator[9]); // Reverse the String.
strcopy(generator[10],generator[8]);
StrReverse(generator[10]); // Reverse the String.

i:=0;
while generator[9][i] <> #0 do
 begin
  case generator[9][i] of
    '{' : generator[9][i] := '}';
    '}' : generator[9][i] := '{';
    '<' : generator[9][i] := '>';
    '>' : generator[9][i] := '<';
  end; //end case

   case generator[10][i] of
    '{' : generator[10][i] := '}';
    '}' : generator[10][i] := '{';
    '<' : generator[10][i] := '>';
    '>' : generator[10][i] := '<';
  end; //end case
 inc(i);
end; // end while loop.
 for i:=0 to 10 do
   lslength[i]:= strlen(generator[i]);
turtlex:=startx;
turtley:=starty;
linelength[level] := firstline;
generate(0,startx,starty,0,startangle,firstline*divisor,level);

Working := false;
Screen.Cursor := crDefault;
BM.temp.Width := BM.ClientWidth;
BM.temp.Height := BM.ClientHeight;
BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
end;

procedure StrReverse(Src : array of char);
var
i,z,k : Integer;
tmp : array[0..127] of char;
begin
  i:=0;
  while Src[i] <> #0 do inc(i);
  dec(i);  // now i is pointing to the last character of the string.
  z:=0;
  for k:=i downto 0 do
    begin
     tmp[z] := Src[k];
     inc(z);
    end;
  tmp[i+1] := #0;
  StrCopy(Src,tmp);
end;

procedure Attractors(Kind: Integer);
var
 dt2 : Extended;
 xfn,xfn0,yfn,yfn0,zfn,zfn0 : Extended;
 xn,xn0,yn,yn0,zn,zn0,xfac,yfac : Extended;
 i,qx : Integer;
label subif;

procedure Rossler;
 begin
   xfn := -yn-zn;
   yfn := xn+aaa*yn;
   zfn := bbb+xn*zn-ccc*zn;
 end;
procedure Lorenz;
 begin
   zfn := aaa*(yn-zn);
   yfn := ccc*zn-yn-zn*xn;
   xfn := -bbb*xn+zn*yn;
 end;

begin
 AttractorForm.ShowModal;
 if  AttractorForm.ModalResult = mrCancel then exit;
 case Kind of
 1 : begin            // Rossler Attractor.
     XMin := -20; XMax := 20;
     YMin := -20; YMax := 20;
     end;
 2 : begin          // Lorenz Attractor.
     XMin := -40;  XMax := 40;
     YMin := -40;  YMax := 40;
     end;
 end;
 dt2 := dt/2;
 //***************************
 x1 := 0; y1 := 0;
 x2 := maxx; y2 := maxy;
 A1:=x1; B1:=y1; C1:=x2; D1:=y2;
 //**************************
 xn := 0; yn := 1; zn := 0;
 xfac := (maxx-50) / (xmax-xmin);
 yfac := (maxy-50) / (ymax-ymin);
 qx := halfx div 2;
 inc(passes);
 escpressed := False;
 Working := True;
 Screen.Cursor := crHourglass;
 if TimerOn then begin   // Added 5-9-98
   BM.Timer1.Enabled :=True;
   StartTime := Time;
 end;
 with BM.Canvas do
  begin
    Pen.Color := Pal[16];
    MoveTo(halfx,halfy);
  end;
if ProgressBarOn then begin
info.G1.Progress := 0;
info.G1.Visible := true;
end;
 for i:=1 to loops do begin
   // Integration by Heun's Method.
   Application.ProcessMessages;
    if escpressed then begin escpressed:= False; break; end;
   case Kind of
     1 : Rossler;
     2 : Lorenz;
   end;
   xn0 := xn; yn0 := yn; zn0 := zn;
   xfn0 := xfn; yfn0 := yfn; zfn0 := zfn;
   xn := xn0+dt*xfn0;
   yn := yn0+dt*yfn0;
   zn := zn0+dt*zfn0;
    case Kind of
     1 : Rossler;
     2 : Lorenz;
   end;
   xn := xn0+dt2*(xfn+xfn0);
   yn := yn0+dt2*(yfn+yfn0);
   zn := zn0+dt2*(zfn+zfn0);
   if i < Ahide then goto subif;
   with BM.Canvas do
      begin
        if (i mod ColorEvery)=0 then Pen.Color := Pal[i mod 256];
        case Kind of
          1 : LineTo(trunc(xfac*(xn-xmin)),trunc(maxy-yfac*(yn+zn-ymin)));
          2 : LineTo(trunc(xfac*(xn-xmin)-qx ),trunc(maxy-yfac*(yn+zn-ymin)));
        end;
      end;
   if ProgressBarOn then
     Info.G1.Progress := 100*i div loops;
   continue;
subif:
       if xn > xmax then xmax := xn;
       if xn < xmin then xmin := xn;
       if yn+zn > ymax then ymax := yn+zn;
       if yn+zn < ymin then ymin := yn+zn;

 end;
Screen.Cursor := crDefault;
info.G1.Visible := false;
BM.temp.Width := BM.ClientWidth;
BM.temp.Height := BM.ClientHeight;
BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
Working := False;
if TimerOn then    // Added 5-9-98
   BM.Timer1.Enabled := false;
end;

procedure UpdateG1;
begin
case maxx of
 290..310 : info.g1.Progress := 100*xana div P300;
 311..389 : info.g1.Progress := 100*xana div P320;
 390..489 : info.g1.Progress := 100*xana div P400;
 490..540 : info.g1.Progress := 100*xana div P500;
 541..650 : info.g1.Progress := 100*xana div P640;
 651..1030 : info.g1.Progress := 100*xana div P800;
end;
end;

procedure FindClIndex(var x: Integer);
var i: Integer;
begin
 for i := 0 to 255 do
  begin
    if pal[i] = x then
      begin
       x := i;
       exit;
      end;
  end;
x := 0;
end;

procedure set_color(xa,ya,x,y,xb,yb : Integer);
var
color : Integer;
c1,c2: Integer;
begin
if {BM.ProgBarMenu.checked} ProgressBarOn then inc(xana);
color := abs(xa-xb)+abs(ya-yb);
color := random(color shl 1)- color;
 c1 := BM.Canvas.Pixels[xa,ya];
 c2 := BM.Canvas.Pixels[xb,yb];
findclindex(c1);
findclindex(c2);
color := color + ((c1+c2+1) shr 1);
if (color<1) then color := 1;
if (color>255) then color := 255;
if BM.Canvas.Pixels[x,y]  = pal[0]  then
    BM.Canvas.Pixels[x,y] := Pal[color];
if {BM.ProgBarMenu.checked}ProgressBarOn then
    info.g1.Progress := 100*xana div PLASM;
end;

procedure subdivide(x1,y1,x2,y2 : Integer);
var
x,y,color: Integer;
c1,c2,c3,c4: Integer;
begin
Application.ProcessMessages;
if escpressed then  exit;
if (((x2-x1)<2) and ((y2-y1)<2)) then exit;
x := (x1+x2) shr 1;
y := (y1+y2) shr 1;
set_color(x1,y1,x,y1,x2,y1);
set_color(x2,y1,x2,y,x2,y2);
set_color(x1,y2,x,y2,x2,y2);
set_color(x1,y1,x1,y,x1,y2);
with BM.Canvas do
 begin
c1 := Pixels[x1,y1];
c2 := Pixels[x2,y1];
c3 := Pixels[x2,y2];
c4 := Pixels[x1,y2];
findclindex(c1);
findclindex(c2);
findclindex(c3);
findclindex(c4);
color := ( c1 + c2 + c3 + c4 + 2 ) shr 2;
Pixels[x,y] := Pal[color];
end;
subdivide(x1,y1,x,y);
subdivide(x,y1,x2,y);
subdivide(x,y,x2,y2);
subdivide(x1,y,x,y2);
end;

procedure PlasmaProc;
begin
randomize;
FractalInit;
pal[0] := clBlack; // Make sure First color in Palette is Black.
 //InitPlasmaPalete;
subdivide(0,0,maxx,maxy);
escpressed:= False;
info.G1.Visible := false;
endjob;
end;

procedure SplitAll(x1,y1,x2,y2 : Integer);
var
x,y: Integer;
begin
Application.ProcessMessages;
if escpressed then  exit;
if (((x2-x1)<2) and ((y2-y1)<2)) then exit;
x := (x1+x2) shr 1;
y := (y1+y2) shr 1;

inc(xana); FractalProc(x,y1);
inc(xana); FractalProc(x2,y);
inc(xana); FractalProc(x,y2);
inc(xana); FractalProc(x1,y);
inc(xana); FractalProc(x,y);
if ProgressBarOn then UpdateG1;

case  SplitOrder of
   0 : begin
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y,x,y2); // 4
       end;
   1 : begin
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y,x2,y2); // 3
       end;
   2 : begin
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y,x,y2); // 4
       end;
   3 : begin
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y1,x2,y); // 2
       end;
   4 : begin
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x,y,x2,y2); // 3
       end;
   5 :  begin
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x,y1,x2,y); // 2
       end;
   6 : begin
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y,x,y2); // 4
       end;
   7 : begin
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y,x2,y2); // 3
       end;
   8 : begin
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x1,y,x,y2); // 4
       end;
   9 : begin
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x1,y1,x,y); // 1
       end;
  10 : begin
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y,x2,y2); // 3
       end;
  11 : begin
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y1,x,y); // 1
       end;
  12 : begin
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y,x,y2); // 4
       end;
  13 : begin
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y1,x2,y); // 2
       end;
  14 : begin
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x1,y,x,y2); // 4
       end;
  15 : begin
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x1,y1,x,y); // 1
       end;
  16 : begin
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y1,x2,y); // 2
       end;
  17 : begin
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y1,x,y); // 1
       end;
  18 :  begin
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x,y,x2,y2); // 3
       end;
  19 : begin
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x,y1,x2,y); // 2
       end;
  20 : begin
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y,x2,y2); // 3
       end;
  21 : begin
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y1,x,y); // 1
       end;
  22 : begin
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x1,y1,x,y); // 1
        SplitAll(x,y1,x2,y); // 2
       end;
  23 : begin
        SplitAll(x1,y,x,y2); // 4
        SplitAll(x,y,x2,y2); // 3
        SplitAll(x,y1,x2,y); // 2
        SplitAll(x1,y1,x,y); // 1
       end;
 end;
end;

procedure frac3d(depth, x0,y0,x2,y2,z0,z1,z2,z3 : Integer);
var
newz : Integer; // new center point
xmid,ymid,z01,z12,z23,z30 : Integer;
begin
  Application.ProcessMessages;
  if escpressed then exit;

  if (random < 0.5 ) then // 50% chance
    newz := (z0+z1+z2+z3) div 4 + round(random * ((y2-y0)* steep)*2)
  else
    newz := (z0+z1+z2+z3) div 4 - round(random * ((y2-y0)* steep)*2);
  xmid := (x0+x2) shr 1;
  ymid := (y0+y2) shr 1;
  z12  := (z1+z2) shr 1;
  z30  := (z3+z0) shr 1;
  z01  := (z0+z1) shr 1;
  z23  := (z2+z3) shr 1;
  dec(depth);

  if (depth >= 0 ) then
   begin
    frac3d(depth, x0,y0, xmid,ymid, z0,z01,newz,z30);
    frac3d(depth, xmid,y0, x2,ymid, z01,z1,z12,newz);
    frac3d(depth, x0,ymid, xmid,y2, z30,newz,z23,z3);
    frac3d(depth, xmid,ymid, x2,y2, newz,z12,z2,z23);
   end
  else
  begin
    if (newz >= sealevel ) then  //above sea level
      begin
        BM.Canvas.Pixels[x2, YADD+ymid+z12] := {pal[random(254)+1];} clwhite;
        BM.Canvas.Pixels[x2, YADD+ymid+z30] := pal[random(254)+1];
      end
      else BM.Canvas.Pixels[xmid, YADD + ymid + sealevel] := BM.Color;  //WATERCOLOR
  end;
  //if ProgressBarOn then inc(xana);
  if ProgressBarOn then begin
     inc(xana);
     if (maxx < 780) then Info.G1.Progress := (100 * xana) div 349525     // all windows up to 780 x ??? DEEP=9
     else Info.G1.Progress := (100 * xana) div 1398101;   // 800x600 and above DEEP=10
   end;
end;

procedure do3dland;
begin
if TimerOn then begin
   BM.Timer1.Enabled :=True;
   StartTime := Time;
end;
if ProgressBarOn then begin
info.G1.Progress := 0;
info.G1.Visible := true;
xana := 0;
end;
FractalCompleted := true;
escpressed := False;
Working := True;
Screen.Cursor := crHourglass;
steep := (random / 2.5) + 0.5;
sealevel := (round(17*random))- 8;
ybottom := maxy;
if (maxx >= 780) then DEEP := 10
else DEEP := 9;
frac3d(DEEP, 0,0,maxx,ybottom,0,0,0,0);
Screen.Cursor := crDefault;
BM.temp.Width := BM.ClientWidth;
BM.temp.Height := BM.ClientHeight;
BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
BM.original.Assign(BM.temp);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
escpressed:= False;
Working := False;
Info.G1.Visible := false;
if TimerOn then  BM.Timer1.Enabled := False;
end;

procedure MartinFrac;
var
i,sign : Integer;
x,y : Extended;
begin
 mt := 0;
 case MartinFunc of
  7 : ma := 3.14159;
  else ma := random(10) - 5;
 end;
 mb :=  random(10) - 5;
 mc :=  random(10) - 5;
 ms := (abs(ma) + abs(mb) + abs(mc)) / 3.0;
 ms := {5.0}(maxx div 100) - (abs(ms/10.0));
 tc := 0;
 x := 0.0;
 y := 0.0;
 clr := pal[random(255)+1];
  for i := 0 to MartinIterations do begin
  Application.ProcessMessages;
  if escpressed then break;
  if (mt > tMax) then
   begin
    inc(tc);
    mt := 0;
    clr := pal[(clr+1) mod 255];
    if ProgressBarOn then
    Info.G1.Progress := (100 * xana) div MartinIterations;
   end;
  BM.Canvas.Pixels[halfx-round(x*ms),halfy-round(y*ms)] := clr;
  if (x < 0) then sign := -1
  else sign := 1;
  xold := x;
  case  MartinFunc of
   1 : x := y - sign * sqrt(abs(arctan(mb*x-mc)));
   2 : x := y - sign * sqrt(abs(cos(mb*x-mc)));
   3 : x := y - sqrt(abs(sin(mb*x-mc)));
   4 : x := y - sqrt(abs(cos(mb*x-mc)*sin(mb*x-mc)));
   5 : x := y - sqrt(abs(arctan(mb*x-mc)*cos(mb*x-mc)));
   6 : x := y - sqrt(abs(arctan(mb*x-mc)*sin(mb*x-mc)));
   7 : x := y - sin(x);
   8 : x := y - sin(x) - cos(x);
   9 : x := y - sign * (abs(sin(x)*cos(mb) + mc - x*sin(ma+mb+mc)));
   else x := y - sign * sqrt(abs(mb*x-mc));
  end;
  y := ma - xold;
  inc(mt);
  if ProgressBarOn then inc(xana);
 end;  // for
 if ProgressBarOn then Info.G1.Progress := 100;
end;

procedure DoMartin;
begin
FractalInit;
FractalCompleted := true;
MartinFrac;
Screen.Cursor := crDefault;
BM.temp.Width := BM.ClientWidth;
BM.temp.Height := BM.ClientHeight;
BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
BM.original.Assign(BM.temp);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
escpressed:= False;
Working := False;
Info.G1.Visible := false;
if TimerOn then  BM.Timer1.Enabled := False;
end;

//***************Bifurcation*******************
var
bifxn,bifdw,bifdh,bifa: Extended;

procedure Bif;
var
i,j : Integer;
begin
FractalInit;
bifstepx := 2*bifxr / maxx;
bifstepy := 2*bifyr / maxy;
bifstart  := bifxcenter - bifxr;
bifend    := bifxcenter + bifxr;
bifbottom := bifycenter - bifyr;
biftop    := bifycenter + bifyr;
bifdw :=  maxx/(bifend - bifstart);
bifdh :=  maxy/(biftop - bifbottom);
//bifxn := 0.66;  // SEED
for i:=1 to  maxx do
  begin
  Application.ProcessMessages;
  if escpressed then begin escpressed:= False; break; end;
    bifa := bifstart+i/bifdw;
    bifxn := 0.66;   // SEED
    for j:=1 to bifiter do
     begin
       case BifParams.Radiogroup1.ItemIndex of
             //Population = Rate * Population * (1 - Population);
         0 : bifxn := bifa * bifxn *(1 - bifxn);
         1 : bifxn := (bifa * cos(bifxn) * cos(bifxn))-1;
         2 : bifxn := (bifa * sin(bifxn) * sin(bifxn))-1;
         3 : bifxn := (bifa * cos(bifxn) * sin(bifxn))-1;
         4 : bifxn := (bifa * cos(bifxn) * sin(bifxn));
        end;
      if (j < bifhide) then continue;
      BM.Canvas.Pixels[i,round((biftop-bifxn)*bifdh)] := Pal[j mod 256];
     end;
    if ProgressBarOn then
    Info.G1.Progress := (100 * i) div maxx;
  end;
Info.G1.Visible := false;
endjob;
end;

{**************************************************************************************
newton { ; Julia set of Newton's method applied to z^3 - 1 = 0
     z = pixel :
      n = z^3 - 1 , d = 3*z^2
      z = z - n/d
       |n| >= 0.000001
****************************************************************************************}
procedure computeNewton(col,row :Integer);
var g : Integer;
n,d : complex;
begin
    z := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
    z3 := Cmul(Cmul(z,z),z);
    n  := Csub(z3,Complexfunc(1,0));
    d  := Cmulf(Cmul(z,z),3);
    g := 0;
    if Params1.Invert.Checked then z := cintdiv_RC(1,z);
                                   //c:= cdiv(Complexfunc(1,0),c);
    while g <= Iters do
     begin
      //case ColMode of
        //0..6 :
       if c2dabs(n) <= 0.000001 then break;
       //end;
       z3 := Cmul(Cmul(z,z),z);
       n  := Csub(z3,Complexfunc(1,0));
       d  := Cmulf(Cmul(z,z),3);
     //  z = z - n/d
       z := csub(z,cdiv(n,d));
       inc(g,stepiter);
     end;  // g
     if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
 end;

//*****************************************************************************
{ SPIDER FRACTAL  c=z=pixel: z=z*z+c; c=c/2+z, |z|<=4 }
//*****************************************************************************
procedure computeSpider(col,row :Integer);
var g : Integer;
begin
    z := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
    c := z;
    g := 0;
    if Params1.Invert.Checked then c := cintdiv_RC(1,c);
    while g <= Iters do
     begin
      case ColMode of
        0 : if sqr(z.real)+sqr(z.img)  >  bailoutvalue then break;
        1..6 : if C2Dabs(z) >  bailoutvalue then break;
       end;
       z:= Cadd(Cmul(z,z),c);
       c := cadd(cdiv(c,complexfunc(2,0)),z);
       inc(g,stepiter);
     end;  // g
     if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
 end;

procedure computeMandelFlower(col,row :Integer);
var g : Integer;
begin
{ another function
z2 := cmul(z,z);
z := cadd( cdiv(z2 , cadd(z,complexfunc(1,0))) , c );      }
    c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
    z := Complexfunc(0,0);
    //z2 := cmul(z,z);
    g := 0;
    if Params1.Invert.Checked then c := cintdiv_RC(1,c);
    while g <= Iters do
     begin
      case ColMode of
        0 : if sqr(z.real)+sqr(z.img)  >  bailoutvalue then break;
        1..6 : if C2Dabs(z) >  bailoutvalue then break;
       end;
       z2 := cmul(z,z);
       z := cadd( cdiv(z2 , cadd(z,complexfunc(2,0))) , c );
       inc(g,stepiter);
     end;  // g
     if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
 end;

procedure computeTestFunction(col,row :Integer);
var g : Integer;
begin
{ another function
z2 := cmul(z,z);
z := cadd( cdiv(z2 , cadd(z,complexfunc(1,0))) , c );      }
    c := Complexfunc(XMin+col*deltaP,YMax-row*deltaQ);
    z :=  c; //Complexfunc(0,0);
    g := 0;
    if Params1.Invert.Checked then c := cintdiv_RC(1,c);

    while g <= Iters do
     begin
      case ColMode of
        0 : if sqr(z.real)+sqr(z.img)  >  bailoutvalue then break;
        1..6 : if C2Dabs(z) >  bailoutvalue then break;
       end;
       z2 := complexpower(z,z);
       //z3 := cmul(z2,z);
       //z := csub(cdiv(z,z3),c);
       z := cdiv( cadd(z2, complexfunc(1,0) ), z);
       //z := cadd( cdiv(cadd(z2,complexfunc(2,0)),z) , c );
       inc(g,stepiter);
     end;  // g
     if LargeDiskImage then LargeBitmapOutSideColor(g,col)
     else ChooseOutSideColor(g,col,row);
 end;

end.
