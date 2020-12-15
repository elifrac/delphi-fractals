unit RGBUnit;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TRGBForm = class(TForm)
    Sred: TScrollBar;
    Sgreen: TScrollBar;
    Sblue: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure SredScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   procedure ToRGBApply(ra,ga,ba: integer);
  end;

var
  RGBForm: TRGBForm;

implementation

uses Main;

{$R *.DFM}

procedure TRGBForm.SredScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  ToRGBApply(sRed.Position,sGreen.Position,sBlue.Position);
end;

procedure TRGBForm.FormShow(Sender: TObject);
begin
sred.Position:=0;
sgreen.Position:=0;
sblue.position:=0;
end;

procedure TRGBForm.ToRGBApply(ra,ga,ba: integer);
var
x,y: Integer;
RowRGB : pRGBArray;
Table: array[0..255]of TFColor;
i: byte;
temp1: TBitmap;
begin
temp1 := TBitmap.Create;
temp1.Width := BM.original.width;
temp1.Height := BM.original.height;
temp1.Assign(bm.original);
temp1.Canvas.Pixels[0,0] := BM.original.Canvas.pixels[0,0];
for i:=0 to 255 do
    begin
      Table[i].b:=IntToByte(i+ba);
      Table[i].g:=IntToByte(i+ga);
      Table[i].r:=IntToByte(i+ra);
    end;
   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := Table[RowRGB[x].rgbtRed].r;
        RowRGB[x].rgbtGreen := Table[RowRGB[x].rgbtGreen].g;
        RowRGB[x].rgbtBlue  := Table[RowRGB[x].rgbtBlue].b;
       end;
    end;
BM.temp.Assign(temp1);
BM.Repaint;
temp1.free;
end;

end.
