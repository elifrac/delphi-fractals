unit ConSatLit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, ExtCtrls;

type
  TContSatForm = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Label5: TLabel;
    TrackBar2: TTrackBar;
    Label8: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TrackBar3: TTrackBar;
    Button3: TButton;
    Panel1: TPanel;
    Image1: TImage;
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
//    procedure TrackBar1Exit(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TrackBar1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Contrast(Amount:Integer);
    procedure Saturation(Amount:Integer);
    procedure Lightness(Amount:Integer);
  end;

var
  ContSatForm: TContSatForm;
  Table: array[0..255] of Byte;
  Alpha:  array[0..255]of Word;
  Grays:  array[0..767]of Integer;
  tempo1,orig2,work1: TBitmap;
implementation

uses Main;

{$R *.DFM}

procedure alfatable(tamount: integer);
var
i: byte;
Gray,x: integer;
begin
for i:=0 to 255 do
    Alpha[i]:=(i*tamount)shr 8;

    x:=0;
    for i:=0 to 255 do
    begin
      Gray:=i-Alpha[i];
      Grays[x]:=Gray; Inc(x);
      Grays[x]:=Gray; Inc(x);
      Grays[x]:=Gray; Inc(x);
    end;
end;

procedure ftable(tamount: integer);
var
i: byte;
y: Integer;
begin
for i:=0 to 126 do
  begin
    y:=(Abs(128-i)*tamount)div 256;
    Table[i]:=IntToByte(i-y);
  end;
  for i:=127 to 255 do
  begin
    y:=(Abs(128-i)*tamount)div 256;
    Table[i]:=IntToByte(i+y);
  end;
end;

procedure LightTable(tamount: integer);
var
i: byte;
begin
if tamount<0 then
  begin
    tamount:=-tamount;
    for i:=0 to 255 do Table[i]:=IntToByte(i-((tamount*i)shr 8));
  end else
    for i:=0 to 255 do Table[i]:=IntToByte(i+((tamount*(i xor 255))shr 8));
end;


procedure TContSatForm.Contrast(Amount:Integer);
var
x,y:   Integer;
RowRGB : pRGBArray;
begin
//tempo1.Assign(BM.original);
//tempo1.Canvas.Pixels[0,0] := BM.original.Canvas.pixels[0,0];
tempo1.Assign({orig2}work1);
tempo1.canvas.Pixels[0,0] := {orig2}work1.Canvas.Pixels[0,0];

  ftable(Amount);

  for y:= 0 to tempo1.Height-1 do
   begin
    RowRGB  := tempo1.ScanLine[y];
    for x:= 0 to tempo1.Width-1 do
     begin
        RowRGB[x].rgbtRed   :=  Table[RowRGB[x].rgbtRed];
        RowRGB[x].rgbtGreen :=  Table[RowRGB[x].rgbtGreen];
        RowRGB[x].rgbtBlue  :=  Table[RowRGB[x].rgbtBlue];
     end;
    end;
//work1.Assign(tempo1);
//work1.canvas.Pixels[0,0] := tempo1.Canvas.Pixels[0,0];
image1.picture.bitmap.assign(tempo1);
//BM.temp.Assign(tempo1);
//Application.ProcessMessages;
//BM.Repaint;
//Application.ProcessMessages;
end;

procedure TContSatForm.TrackBar1Change(Sender: TObject);
begin
label2.caption := inttostr(trackbar1.position);
//label5.caption := inttostr(trackbar2.position);
//label3.caption := inttostr(trackbar3.position);
Contrast(trackbar1.position);
//Saturation(trackbar2.position);
//Lightness(trackbar3.position);
application.ProcessMessages;
end;

procedure TContSatForm.TrackBar2Change(Sender: TObject);
begin
label5.caption := inttostr(trackbar2.position);
Saturation(trackbar2.position);
application.ProcessMessages;
end;

procedure TContSatForm.TrackBar3Change(Sender: TObject);
begin
label3.caption := inttostr(trackbar3.position);
Lightness(trackbar3.position);
application.ProcessMessages;
end;

procedure TContSatForm.Saturation(Amount:Integer);
var
Gray,x,y:    Integer;
RowRgb: pRGBArray;
begin
//tempo1.Assign(BM.original);
//tempo1.Canvas.Pixels[0,0] := BM.original.Canvas.pixels[0,0];
tempo1.Assign({orig2}work1);
tempo1.canvas.Pixels[0,0] := {orig2}work1.Canvas.Pixels[0,0];
alfatable(amount);
      for y:= 0 to tempo1.Height-1 do
      begin
       RowRGB  := tempo1.ScanLine[y];
       for x:= 0 to tempo1.Width-1 do
       begin
        Gray:=Grays[RowRGB[x].rgbtRed+RowRGB[x].rgbtGreen+RowRGB[x].rgbtBlue];
        RowRGB[x].rgbtRed   :=  IntToByte(Gray+Alpha[RowRGB[x].rgbtRed]);
        RowRGB[x].rgbtGreen :=  IntToByte(Gray+Alpha[RowRGB[x].rgbtGreen]);
        RowRGB[x].rgbtBlue  :=  IntToByte(Gray+Alpha[RowRGB[x].rgbtBlue]);
       end;
    end;
image1.picture.bitmap.assign(tempo1);
//BM.temp.Assign(tempo1);
//Application.ProcessMessages;
//BM.Repaint;
//Application.ProcessMessages;
end;

procedure TContSatForm.Lightness(Amount:Integer);
var
x,y:   Integer;
RowRgb: pRGBArray;
begin
//tempo1.Assign(BM.original);
//tempo1.Canvas.Pixels[0,0] := BM.original.Canvas.pixels[0,0];
tempo1.Assign({orig2}work1);
tempo1.canvas.Pixels[0,0] := {orig2}work1.Canvas.Pixels[0,0];
LightTable(amount);
  for y:= 0 to tempo1.Height-1 do
      begin
       RowRGB  := tempo1.ScanLine[y];
       for x:= 0 to tempo1.Width-1 do
       begin
        RowRGB[x].rgbtRed   :=  Table[RowRGB[x].rgbtRed];
        RowRGB[x].rgbtGreen :=  Table[RowRGB[x].rgbtGreen];
        RowRGB[x].rgbtBlue  :=  Table[RowRGB[x].rgbtBlue];
       end;
    end;
image1.picture.bitmap.assign(tempo1);
//BM.temp.Assign(tempo1);
//Application.ProcessMessages;
//BM.Repaint;
//Application.ProcessMessages;
end;

procedure TContSatForm.FormHide(Sender: TObject);
begin
tempo1.free;
orig2.Free;
work1.free;
end;

procedure TContSatForm.FormShow(Sender: TObject);
begin
tempo1 := TBitmap.Create;
tempo1.PixelFormat := pf24bit;
tempo1.Width := image1.Width; //BM.original.width;
tempo1.Height := image1.Height; //BM.original.height;

orig2 := TBitmap.Create;
orig2.PixelFormat := pf24bit;
orig2.Width := image1.Width;  //BM.original.width;
orig2.Height := image1.Height; //BM.original.height;

work1 := TBitmap.Create;
work1.PixelFormat := pf24bit;
work1.Width := image1.Width;
work1.Height := image1.Height;

//orig2.Assign(bm.original);
//orig2.Canvas.Pixels[0,0] := bm.original.Canvas.pixels[0,0];

Image1.Canvas.StretchDraw(image1.ClientRect,bm.original);
orig2.Canvas.Draw(0,0,image1.Picture.Bitmap);
work1.Canvas.Draw(0,0,image1.Picture.Bitmap);

trackbar1.position := 0;
label2.caption := inttostr(0);
trackbar3.position := 0;
label3.caption := inttostr(0);
trackbar2.position := 255;
label5.caption := inttostr(255);
end;

{procedure TContSatForm.TrackBar1Exit(Sender: TObject);
begin
bm.original.Assign(tempo1);
bm.original.Canvas.Pixels[0,0] := tempo1.Canvas.pixels[0,0];
end; }

procedure TContSatForm.Button3Click(Sender: TObject);
begin
trackbar1.position := 0;
label2.caption := inttostr(0);
trackbar3.position := 0;
label3.caption := inttostr(0);
trackbar2.position := 255;
label5.caption := inttostr(255);

Image1.Canvas.StretchDraw(image1.ClientRect,bm.original);
orig2.Canvas.Draw(0,0,image1.Picture.Bitmap);
work1.Canvas.Draw(0,0,image1.Picture.Bitmap);
//bm.original.assign(orig2);
//bm.original.Canvas.Pixels[0,0] := orig2.Canvas.pixels[0,0];
//bm.Canvas.StretchDraw(bm.ClientRect, bm.original);
end;

procedure TContSatForm.TrackBar1Exit(Sender: TObject);
begin
work1.Assign(tempo1);
work1.canvas.Pixels[0,0] := tempo1.Canvas.Pixels[0,0];
image1.picture.bitmap.assign(work1);
end;

end.
