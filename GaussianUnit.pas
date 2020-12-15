unit GaussianUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TGaussianForm = class(TForm)
    ScrollBar1: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
   procedure GaussianBlur(Amount:Integer);
  end;

var
  GaussianForm: TGaussianForm;
  procedure SplitBlur(Amount:Integer);
implementation

uses Main;

{$R *.DFM}

procedure SplitBlur(Amount:Integer);
var
Line1,
Line2:   pRGBArray;
cx,x,y,w,h: Integer;
Buf:    array[0..3]of TRGBTriple; //TFColor;
//AllScanLines: array[0..800] of pRGBArray;
Temp1: TBitmap;
begin

temp1 := TBitmap.Create;
temp1.Width := BM.original.width;
temp1.Height := BM.original.height;
temp1.Assign(bm.original);
w:= temp1.Width;
h:= temp1.Height;
//for x:= 0 to h do
  //  AllScanLines[x]:= temp1.ScanLine[x];

    for y:=0 to h do
    begin
      Line1:= temp1.Scanline[TrimInt(y+Amount,0,h-1)]; //AllScanlines[TrimInt(y+Amount,0,h-1)];
      Line2:= temp1.Scanline[TrimInt(y-Amount,0,h-1)]; //AllScanLines[TrimInt(y-Amount,0,h-1)];
      for x:=0 to w do
      begin
        cx:=TrimInt(x+Amount,0,w);
        Buf[0]:=Line1[cx];
        Buf[1]:=Line2[cx];
        cx:=TrimInt(x-Amount,0,w);
        Buf[2]:=Line1[cx];
        Buf[3]:=Line2[cx];
        Line1[x].rgbtBlue  := (Buf[0].rgbtBlue+Buf[1].rgbtBlue+Buf[2].rgbtBlue+Buf[3].rgbtBlue)shr 2;
        Line1[x].rgbtGreen := (Buf[0].rgbtGreen+Buf[1].rgbtGreen+Buf[2].rgbtGreen+Buf[3].rgbtGreen)shr 2;
        Line1[x].rgbtRed   := (Buf[0].rgbtRed+Buf[1].rgbtRed+Buf[2].rgbtRed+Buf[3].rgbtRed)shr 2;
      end;
    end;
bm.temp.assign(temp1);
//bm.repaint;
temp1.free;
end;

procedure TGaussianForm.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
t: integer;
begin
t:= scrollbar1.Position;
GaussianBlur(TrimInt(t,0,10));
end;

procedure TGaussianForm.GaussianBlur(Amount:Integer);
var
i: Integer;
begin
  for i:=1 to Amount do
  SplitBlur(i);
bm.repaint;  
end;

end.
