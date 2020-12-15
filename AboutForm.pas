///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                         Zonerings About box - Cool !                      //
//                             ©John Biddiscombe                             //
//                           J.Biddiscombe@rl.ac.uk                          //
//                                  Freeware                                 //
//                                                                           //
//  Derived from the ZRing project by seb (sleon@magic.fr)                   //
//  Optimisations :                                                          //
//                                                                           //
//    For Math Functions & variables :                                       //
//      All Double variables are now Singles                                 //
//      The color table has been extracted from the flakearray record.       //
//    These 2 modif. decrease the flakearray size : 294 Ko now (786 before)  //
//    The Sinus & Cosinus table cost 8 Ko now (128 Ko before)                //
//                                                                           //
//    For the 3 banner :                                                     //
//    I create them completely on the fly.                                   //
//    The structures string3D_1 & the use of the binary file vanished        //
//    It saves 55 Ko for string3D_1, 27 Ko for the binary file & loading time//
//                                                                           //
//  I have include a slightly derived RXTimer from the very nice RX VCL      //
//  to remplace the Application.OnIdle call.                                 //
//                                                                           //
//  The scrolling text is my code, you can use it in terms of my licence.    //
//                                                                           //
//  All theses modifications leave the animation (close) similar !           //
//  J. Biddiscombe keep full copyrights on HIS code (70 % of this unit)      //
//  THIS IS NOT MY CODE, USE IT with John's restrictions                     //
//                                                                           //
//                                           SEB - (Part of DRYSIM Project)  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

unit AboutForm;

interface

uses
  { Borland }
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls,
  {Seb's unit}
  //DIBUltra, DIBType,
  {RXTimer for best accurency}
  TimerRX; // The real RXTimer has been very slightly modified to call (just) standard Delphi units

{/$DEFINE BANNER_CONCEPTION} // Give some informations about banners (Nb points used)

const
  MsgColorForeGround = ClAqua;
  MsgColorBackGround = ClGray;
  SpeedAnim          = 15;         // Millisecondes
  maxpoints          = 2047;       // Nb of points of the animation
  inter_frame        = 300;        // time paused before morphing again
  morph_sp           = 100;        // time spent morphing
  steps              = 1+morph_sp; // time spent morphing
  zo                 = 1.8;        // Perspective !
  viewdist           = zo*100;
  cycle_pal          = 4;          // Speed of the "palette" cycling
  pal_colours        = 236;        // Real number of cycling colors in the palette
  pal_coloursm1      = 235;
  sqr3maxpoint       = 11;         // placed : 0..11 : 12 points
  sqr3maxpointp1     = sqr3maxpoint+1;
  sqr3maxpoint3      = 12*12*12;
  MsgSize            = 21;
  maxframes          = 5;          // 6 total

type
  pflakestruc = ^flakestruc;
  flakestruc  = record
    x,y,z    : Single;
    dx,dy,dz : Single;
  end;

type
  TAboutForm1 = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    // Allocation of 294 Kilo-octets for this array !
    flakearray : array[0..maxframes,0..maxpoints] of flakestruc;
    flakeCol   : array[0..maxpoints] of byte; // 2 Kilos for this one
    { screen variables }
    xmid,ymid  : integer;
    { animation control }
    bigloop    : integer;
    framepause : integer;
    frameloop  : integer;
    framenum   : integer;
    xrotspeed  : integer;
    yrotspeed  : integer;
    zrotspeed  : integer;
    xrotoff    : integer;
    yrotoff    : integer;
    zrotoff    : integer;
    xr,yr,zr   : integer;
    xo,yo      : Single;
    MsgCur     : Integer;
    MsgFrac    : Integer;
    MsgWidth   : Integer;
    MsgDpl     : Integer;
    ToRect     : TRect;
    DIBRect    : TRect;
    Move       : TRxTimer;
    DIB        : TDIBUltra;
    procedure Setup_graphics;
    procedure compute_and_draw_DIB(frame,stepnum:integer; framechange,skip:boolean);
    procedure Stabilize;
    procedure Animation(Sender:TObject);
  public
    { Public declarations }
  end;

var
  AboutForm1: TAboutForm1;

implementation

uses Msgs;

//############################################################
//########## MATH FUNCTIONS ##################################
//############################################################
const
  tablesize   = 1023;
  tablesizep1 = tablesize+1;

var
  cosine   : array[0..tablesize] of single;
  sine     : array[0..tablesize] of single;
  { geometry }
  rotyxz0_0, rotyxz0_1, rotyxz0_2,
  rotyxz1_0, rotyxz1_1, rotyxz1_2,
  rotyxz2_1, rotyxz2_2, rotyxz2_3  : single;

procedure setup_tables;
var
  lp1 : integer;
  n   : Single;
begin
  for lp1:=0 to tablesize do begin
    n           := (2*pi*lp1/tablesizep1);
    cosine[lp1] := cos(n);
    sine[lp1]   := sin(n);
  end;
end;
{ ------------------------------------------------------------------------ }
procedure yxz_rotation(x,y,z:integer); { unrolled matrix multiply }
var t1,t2,t3,t4,t5,t6,m1,m2,m3 : single;
begin
  t1:=cosine[x];
  t2:=cosine[y];
  t3:=cosine[z];
  t4:=  sine[x];
  t5:=  sine[y];
  t6:=  sine[z];
  m1 := (t2*t3);
  m2 := (t4*t5);
  m3 := (t2*t6);
  rotyxz0_0 := m1         - ((m2*t6));
  rotyxz0_1 :=-((t1*t6));
  rotyxz0_2 := ((t3*t5))  + ((m3*t4));
  rotyxz1_0 := m3         + ((t3*m2));
  rotyxz1_1 := ((t1*t3));
  rotyxz1_2 := ((t5*t6))  - ((m1*t4));
  rotyxz2_1 :=-((t1*t5));
  rotyxz2_2 := t4;
  rotyxz2_3 := ((t1*t2));
end;
{ ------------------------------------------------------------------------ }

//############################################################
//########## END OF MATH FUNCTIONS ###########################
//############################################################

{$R *.DFM}

procedure TAboutForm1.FormCreate(Sender: TObject);
begin
  Move    := TRxTimer.Create(nil);
  Move.Enabled  := False;
  DIB      := TDIBUltra.Create(ClientWidth,ClientHeight-30, DUpf8, @PaletteToAnimate8Bits);
  ToRect   := Rect(0,30,DIB.Width,DIB.Height+30);
  DIBRect  := Rect(0,0,DIB.Width,DIB.Height);
  xmid     := DIB.Width div 2;
  ymid     := DIB.Height div 2;
  MsgDpl   := 3;
  MsgCur   := 1; // Premier message
  DIB.Canvas.Font.Name   := MsgFonte;
  DIB.Canvas.Font.Height := -MsgSize;
  DIB.BrushColor := ClBlack;
  MsgFrac  := -DIB.Width;
  MsgWidth := DIB.Canvas.TextWidth(AboutMsg[MsgCur]);
  setup_tables;   // Initialise Math values
  setup_graphics; // Initialise 3D Objects
  Stabilize;      // Initialise Animation values
end;

procedure TAboutForm1.FormShow(Sender: TObject);
begin
  // MAJ du RXTimer : OK We are Ready for the animation
  Move.Interval := SpeedAnim;
  Move.Enabled  := True;
  Move.OnTimer  := Animation;
End;

procedure TAboutForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Move.Free;
  DIB.Free;
  Action := caFree;
end;

procedure TAboutForm1.FormClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TAboutForm1.compute_and_draw_DIB(frame,stepnum:integer; framechange,skip:boolean);
var x1,y1,lp1 : word;
    xt,yt,zt  : Single;
    tx,ty,tz  : Single;
begin
  Inc(MsgFrac, MsgDpl);
  If (MsgFrac>=MsgWidth) Then
  Begin
    Inc(MsgCur); If (MsgCur>AboutMessages) Then MsgCur:=1;
    MsgFrac  := -DIB.Width;
    MsgWidth := DIB.Canvas.TextWidth(AboutMsg[MsgCur]);
  End;

  DIB.Canvas.Font.Color  := MsgColorForeGround;
  DIB.Canvas.Brush.Style := bsSolid;
  DIB.Canvas.TextOut(-MsgFrac,05,AboutMsg[MsgCur]);

  for lp1:=0 to maxpoints do begin
    with flakearray[frame,lp1] do begin
      tx:=x+(dx*stepnum); ty:=y+(dy*stepnum); tz:=z+(dz*stepnum);
      xt := ((rotyxz0_0*tx)) +
            ((rotyxz0_1*ty)) +
            ((rotyxz0_2*tz)) + xo;
      yt := ((rotyxz1_0*tx)) +
            ((rotyxz1_1*ty)) +
            ((rotyxz1_2*tz)) + yo;
      zt := ((rotyxz2_1*tx)) +
            ((rotyxz2_2*ty)) +
            ((rotyxz2_3*tz)) + zo;
      x1 := Round((xt*viewdist)/ zt)+xmid;
      y1 := Round((yt*viewdist)/ zt)+ymid;
      DIB.DirectPlot(x1,y1,flakeCol[lp1]);  // col 10-246
    end;
  end;

  Canvas.CopyRect(ToRect, DIB.Canvas, DIBRect);
end;

procedure TAboutForm1.Stabilize;
var lp1,lp2 : integer;
    f1,f2   : integer;
begin
  bigloop     := 48;
  xrotspeed   := 0;
  yrotspeed   := 5;
  zrotspeed   := 0;
  framepause  := 0;   // counter
  frameloop   := 0;   // counter
  framenum    := 0;   // counter
  for lp1:= 0 to maxframes do begin
    f1 := lp1; f2 := (lp1+1) mod (maxframes+1);
    for lp2:=0 to maxpoints do begin
      with flakearray[f1,lp2] do begin
        dx := (flakearray[f2,lp2].x - x)/ steps;
        dy := (flakearray[f2,lp2].y - y)/ steps;
        dz := (flakearray[f2,lp2].z - z)/ steps;
      end;
    end;
  end;
end;
// These var Time 1 & 2 are useful for monitoring
//var Time1, Time2 : LongInt;
procedure TAboutForm1.Animation(Sender:TObject);
var
  framechange : boolean;
  Color       : pointer;
begin
//  Time1 := GetTickCount;
  Inc(bigloop,1);
  BigLoop := BigLoop AND TableSize;
  framechange:=false;
  if framepause>=0 then inc(framepause)
  else inc(frameloop);
  if framepause>=inter_frame then begin
    framepause :=-1;
    frameloop  := 1;
  end;
  if frameloop>=morph_sp then begin
    frameloop  := 0;
    framepause := 0;
    inc(framenum); framechange:=true;
    if framenum>maxframes then framenum:=0;
  end;
  xo := 0;
  yo := 0;
  xr := (32 + 4*xrotoff + xrotspeed*bigloop) and tablesize;
  yr := (32 + 4*yrotoff + yrotspeed*bigloop) and tablesize;
  zr := (0  + 4*zrotoff + zrotspeed*bigloop) and tablesize;
  yxz_rotation(xr,yr,zr);
  // Colors modification, even if the resolution is not 8 bpp (I don't use AnimatePalette later)
  Color := @flakeCol;
  asm // Colors rolling, by Seb
    MOV EDX, Color;
    MOV ECX, (MaxPoints-1)
    @DO:
      MOVZX EAX, BYTE PTR [EDX + ECX]
      ADD   EAX, Cycle_Pal
      CMP   EAX, (10+pal_colours)
      JB @COLOROK
      MOV   EAX, 10
      @COLOROK:
      MOV [EDX + ECX], AL
    LOOP @DO
  End; // Idem : For n := maxpoints-1 downto 0 Do Begin inc(flakeCol[n], cycle_pal); if (flakeCol[n]>=(10+pal_colours)) Then flakeCol[n] := 10; End;
  DIB.ClearAll;
  compute_and_draw_DIB(framenum,frameloop,framechange,false);
  // Palette Realisation (We could do : )
  //  If (Screen.Resolution=pf8Bit) Then Begin
  SelectPalette(Canvas.Handle,DIB.Hpalette,false);
  RealizePalette(Canvas.Handle);
  // End; // But it is not really useful 'cause RealizePalette return 0 if the screen resolution is <> 8 bits.
// Speed :
//  Time2 := GetTickCount;
//  Caption := IntToStr(Time2 - Time1);
end;

procedure TAboutForm1.Setup_graphics;
var lp0,lp1,lp2   : integer;
    a,r           : Single;
    r1,r2,cp,sp   : Single;
    i,j,n,m       : integer;
    points_here   : integer;
    pp_seg,seg    : integer;
    phi,theta     : Single;
    paper         : TDIBUltra;
begin // frames 0..5 generated in a seconde
  for lp1:=0 to (MaxPoints-1) do flakeCol[lp1] := 10+((lp1 div 8) mod pal_colours);
  flakeCol[MaxPoints] := 0; // LastPoint invisible

  Paper := TDIBUltra.Create(450,30,DUpf1,NilPalette); // I should be suffisant, however, you can build a
  for lp0:=0 to 2 do begin                            // larger Temp DIB ; i.e. : 600x40
    points_here := 0;
    // Get Font attributs & write it on the paper :
    Paper.Canvas.Font.Height := Banner[lp0].FSize;
    Paper.Canvas.Font.Style  := Banner[lp0].FStyle;
    Paper.Canvas.Font.Name   := Banner[lp0].FName;
    Paper.Canvas.Brush.Color := ClBlack;
    Paper.Canvas.Brush.Style := bsSolid;
    Paper.Canvas.Font.Color  := ClWhite;
    Paper.Canvas.FillRect(Rect(0,0,Paper.Width, Paper.Height+1));
    n := Paper.Canvas.TextWidth(Banner[lp0].Text);
    m := Banner[lp0].FSize;
    Paper.Canvas.TextOut(0,0,Banner[lp0].Text);
    a := 2 * pi / 360;
    r := 2 * pi / (n * 1); // 1 => The formed circle is 100 % the TextWidth
    i := lp0 * 2;
    for lp1:=0 to (n-1) do begin // So you have to left some spaces at the end of your banner
      for lp2:=0 to (m-1) do begin
        if Boolean(Paper.Pixels[(n-lp1),lp2]) then begin
          with flakearray[i,points_here] do begin
            r1:= a*(lp2-m/2);
            r2:= r*(n-lp1);
            x := cos(r2)*cos(r1);
            z := sin(r2)*cos(r1);
            y := sin(r1);
          end;
          inc(points_here);
        end;
      end;
    end; // put the spare points on a tiny sphere
//{$IFDEF BANNER_CONCEPTION}
  //ShowMessage('Your message :'#13'"'+Banner[lp0].Text+'"'#13
    //         +'use '+IntToStr(points_here)+' pixels !'#13
      //       +'You can still use '+IntToStr(maxpoints-points_here)+' pixels.');
//{$ENDIF}
  // place the last points (not used in this frame) under the last point (wich is black) :
  For n := points_here To (MaxPoints-1) Do flakearray[i,n] := flakearray[i,MaxPoints];
  end;
  Paper.Free;
  // cube ; by Seb
  phi   := 1.2 / (sqr3maxpoint);
  for lp0 := 0 to sqr3maxpoint Do
    for lp1 := 0 to sqr3maxpoint Do Begin m:= sqr3maxpointp1 * (sqr3maxpointp1 * lp0 + lp1);
      for lp2 := 0 to sqr3maxpoint Do
        With flakearray[5,m+lp2] Do Begin
          x := 0.6 - Phi * lp0;
          z := 0.6 - Phi * lp1;
          y := 0.6 - Phi * lp2;
      End;
    End;
  // place the last points (not used in this frame) under the last point (wich is black) :
  For n := sqr3maxpoint3 To (MaxPoints-1) Do flakearray[5,n] := flakearray[5,MaxPoints];
//  System.Move(flakearray[5,0],flakearray[5,sqr3maxpoint3],SizeOf(flakestruc)*(maxpoints-sqr3maxpoint3+1));
  { // Old cube figure ; by John
  // frame 5 - random cube
  for lp1:=0 to maxpoints do begin
    with flakearray[5,lp1] do begin
      x := (0.57*2)*random(256)/255 - 0.57;
      z := (0.57*2)*random(256)/255 - 0.57;
      y := (0.57*2)*random(256)/255 - 0.57;
      c := 10+pal_colours*(sqrt(x*x + y*y + z*z)/sqrt(sqr(0.57)*3));
    end;
  end;
  }
  // frame 3 - two spheres
  // Seb Modif : I separate the spheres computing to have a nice rolling color effect
  points_here := 0;
  seg         := 32;
  pp_seg      := (maxpoints+1) div (seg*2);
  n := 0;
  for lp2:=0 to pp_seg-1 do begin
    theta := 2*pi*(n+0.5)/pp_seg;
    m := 0;
    for lp1:=0 to seg-1 do begin
      phi := pi*(m+0.5)/seg;
      with flakearray[1,points_here] do begin
        x     := cos(theta)*sin(phi);
        y     := sin(theta)*sin(phi);
        z     := cos(phi);
        inc(points_here);
      end;
      m := m + 1;
    end;
    n := n + 1;
  end;
  m := 0;
  for lp1:=0 to seg-1 do begin
    phi := pi*(m+0.5)/seg;
    n   := 0;
    for lp2:=0 to pp_seg-1 do begin
      theta := 2*pi*(n+0.5)/pp_seg;
      with flakearray[1,points_here] do begin
        x     := 0.5*cos(theta)*sin(phi);
        z     := 0.5*sin(theta)*sin(phi);
        y     := 0.5*cos(phi);
        inc(points_here);
      end;
      n := n + 1;
    end;
    m := m + 1;
  End;
  // place the last points (not used in this frame) under the last point (wich is black) :
  For n := points_here To (MaxPoints-1) Do flakearray[1,n] := flakearray[1,MaxPoints];
  // frame 5 - torus * 2
  r1 := 0.75;
  r2 := 0.25;
  n := 64;
  m := (maxpoints+1) div (n*2);
  points_here := 0;
  for i:=0 to n-1 do begin
    cp := cos(2*pi*i/n);
    sp := sin(2*pi*i/n);
    for j:=0 to m-1 do begin
      with flakearray[3,points_here] do begin
        x := cp*(r1+r2*cos(2*pi*j/m));
        y := sp*(r1+r2*cos(2*pi*j/m));
        z := r2*Sin(2*Pi*j/m);
        inc(points_here);
      end;
      with flakearray[3,points_here] do begin
        x := cp*(r1+r2*cos(2*pi*j/m));
        z := sp*(r1+r2*cos(2*pi*j/m));
        y := r2*Sin(2*Pi*j/m);
        inc(points_here);
      end;
    end;
  end;
  // place the last points (not used in this frame) under the last point (wich is black) :
  For n := points_here To (MaxPoints-1) Do flakearray[3,n] := flakearray[3,MaxPoints];
end;

procedure Check( v : integer);
Begin
  If (V=0) Then ; // Put a debug stop here...
End;

procedure TAboutForm1.FormPaint(Sender: TObject);
var n : integer;
    S : String;
begin
  S := ' EliFrac 2.0 ';
  Canvas.Font.Name   := Times;
  Canvas.Font.Height := 26;
  Canvas.Brush.Style := bsClear;
  n := (Width - Canvas.TextWidth(S)) div 2;
  Canvas.Font.Color := ClWhite;
  Canvas.TextOut(n+1,4,S);
  Canvas.Font.Color := ClRed;
  Canvas.TextOut(n,3,S);
  Canvas.CopyRect(ToRect, DIB.Canvas, DIBRect);
end;

end.
