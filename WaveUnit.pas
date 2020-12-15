unit WaveUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TWaveForm = class(TForm)
    sXdiv: TScrollBar;
    sYdiv: TScrollBar;
    sRatio: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    procedure sRatioChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
  procedure Process;
    { Public declarations }
  end;

var
  WaveForm: TWaveForm;

implementation

uses Main,fastrgb,fastbmp;

{$R *.DFM}

var
Buf: TFastRGB;

procedure WaveWrap(Bmp,Dst:TFastRGB;XDIV,YDIV,RatioVal:Extended);
type
TArray=array[0..0] of Integer;
PArray=^TArray;
var
i,j,
XSrc,
YSrc:  Integer;
st:    PArray;
Pix:   PFColor;
Line1: PLine;
Max:   Integer;
PInt:  PInteger;
begin
  if(YDiv=0)or(XDiv=0)then
  begin
    CopyMemory(Dst.Bits,Bmp.Bits,Dst.Size);
    Exit;
  end;
  GetMem(st,4*Dst.Height);
  for j:=0 to Dst.Height-1 do
    st[j]:=Round(RatioVal*Sin(j/YDiv));

     Max:=Integer(Bmp.Pixels[Bmp.Height-1])+Bmp.RowInc;
    for i:=0 to Dst.Width-1 do
    begin
      YSrc:=Round(RatioVal*sin(i/XDiv));
      if YSrc<0 then
        YSrc:=Bmp.Height-1-(-YSrc mod Bmp.Height)
      else if YSrc>=Bmp.Height then
        YSrc:=YSrc mod(Bmp.Height-1);
      Pix:=Ptr(Integer(Dst.Bits)+i*3);
      Line1:=Bmp.Pixels[YSrc];
      PInt:=PInteger(st);
      for j:=Dst.Height-1 downto 0 do
      begin
        XSrc:=i+PInt^;
        Inc(PInt);
        if XSrc<0 then
          XSrc:=Bmp.Width-1-(-XSrc mod Bmp.Width)
        else if XSrc>=Bmp.Width then
          XSrc:=XSrc mod Bmp.Width;
        Pix^:=Line1[XSrc];
        Pix:=Ptr(Integer(Pix)+Dst.RowInc);
        Line1:=Ptr(Integer(Line1)+Bmp.RowInc);
        if Integer(Line1)>=Max then Line1:=Bmp.Bits;
      end;
    end;
    FreeMem(st);
end;

procedure TWaveForm.sRatioChange(Sender: TObject);
begin
Process;
end;

procedure TWaveForm.Process;
var
xDiv,yDiv,Ratio: Extended;
begin
  xDiv:=sxDiv.Position*0.5;
  yDiv:=syDiv.Position*0.5;
  Ratio:=sRatio.Position*0.5;

 //WaveWrap(xDiv,yDiv,Ratio);
 bm.refresh;
end;

procedure TWaveForm.FormShow(Sender: TObject);
begin
   Buf:=TFastBMP.Create;
   Buf.SetSize(Bm.original.Width,Bm.original.Height);
   
   //CopyMemory(Buf.Bits,Form2.FastIMG1.Bmp.Bits,Buf.Size);
end;

end.
