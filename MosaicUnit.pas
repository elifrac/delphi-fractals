unit MosaicUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TMosaicForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label5: TLabel;
    TrackBar2: TTrackBar;
    procedure TrackBar2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Mosaic(xAmount,yAmount:Integer);
  end;

var
  MosaicForm1: TMosaicForm1;
  amt: integer;
implementation

uses Main;

{$R *.DFM}

procedure TMosaicForm1.TrackBar2Change(Sender: TObject);
begin
amt:= trackbar2.position;
label5.caption := inttostr(amt);
Mosaic(amt,amt);
application.ProcessMessages;
end;

procedure TMosaicForm1.FormShow(Sender: TObject);
begin
trackbar2.position := 0;
amt:= 0;
label5.caption := inttostr(0);
//Mosaic(amt,amt);
end;

procedure TMosaicForm1.Mosaic(xAmount,yAmount:Integer);
var
tx,ty,
cx,cy,
ix,iy,
x,y,w,h:   Integer;
Color:   TRGBTriple;
RowRGB  :  pRGBArray;
AllScanLines: array[0..800] of pRGBArray;
temp1: TBitmap;
begin
temp1 := TBitmap.Create;
temp1.PixelFormat := pf24bit;
temp1.Width := bm.original.Width;
temp1.Height := bm.original.Height;
temp1.Assign(bm.original);
w:= temp1.Width;
h:= temp1.Height;

xAmount:= trimint(xamount,1,w-1);
yAmount:= trimint(yamount,1,h-1);

for x:=0 to h do
    AllScanLines[x] := temp1.scanline[x];

ix:=(xAmount shr 1)+(xAmount and 1);
iy:=(yAmount shr 1)+(yAmount and 1);
y:=0;
while y < h do
  begin
  x:=0;
  cy:=y+iy;
  if cy < h then
     RowRGB  := AllScanLines[cy]
     else RowRGB  := AllScanLines[h-1];
   if y+yAmount-1>=h then
      ty:=h-1-y
    else  ty:=yAmount;
    while x < w do
     begin
      cx:=x+ix;
        if cx < w then
          color := rowrgb[cx]
          else color := rowrgb[w-1];
          if x+xAmount-1>=w then
          tx:=w-1-x
          else   tx:=xAmount;
         for cy:=1 to ty do
          begin
            for cx:=1 to tx do
              begin
                AllScanLines[trimint(y+cy,0,h-1),trimint(x+cx,0,w-1)]  := color;
              end;
          end;
        Inc(x,xAmount);
     end;
    Inc(y,yAmount);
end;
bm.temp.assign(temp1);
bm.repaint;
temp1.free;
end;

end.
