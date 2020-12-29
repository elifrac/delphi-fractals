unit ContrastUnit;
//****************************************************************************************
//  This File is part of the EliFrac Project.
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  Modifications :  8-12-2000 :  changed to apply directly to the main form
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TContrastForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ContrastApply(Amount:Integer);
  end;

var
  ContrastForm: TContrastForm;
  Table: array[0..255] of Byte;
implementation

uses Main;

{$R *.DFM}

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

procedure TContrastForm.TrackBar1Change(Sender: TObject);
begin
label2.caption := inttostr(trackbar1.position);
ContrastApply(trackbar1.position);
end;

procedure TContrastForm.FormShow(Sender: TObject);
begin
trackbar1.position := 0;
label2.caption := inttostr(0);
end;

procedure TContrastForm.ContrastApply(Amount:Integer);
var
x,y:   Integer;
RowRGB : pRGBArray;
tempo1: TBitmap;
begin
tempo1 := TBitmap.Create;
tempo1.Width := BM.original.width;
tempo1.Height := BM.original.height;
tempo1.Assign(BM.original);
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
BM.temp.Assign(tempo1);
BM.Repaint;
tempo1.free;
end;

end.
