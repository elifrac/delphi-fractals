unit LightnessUnit;
//****************************************************************************************
//  This File is part of the EliFrac Project.
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  Modifications :  8-12-2000 :  changed to apply directly to the main form
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, ExtCtrls;

type
  TLightnessForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    TrackBar3: TTrackBar;
    procedure TrackBar3Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LightnessApply(Amount:Integer);
  end;

var
  LightnessForm: TLightnessForm;
  Table: array[0..255] of Byte;
implementation

uses Main;

{$R *.DFM}

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


procedure TLightnessForm.TrackBar3Change(Sender: TObject);
begin
label3.caption := inttostr(trackbar3.position);
LightnessApply(trackbar3.position);
end;

procedure TLightnessForm.FormShow(Sender: TObject);
begin
trackbar3.position := 0;
label3.caption := inttostr(0);
end;

procedure TLightnessForm.LightnessApply(Amount:Integer);
var
x,y:   Integer;
RowRgb: pRGBArray;
tempo1: TBitmap;
begin
tempo1 := TBitmap.Create;
tempo1.Assign(BM.original);
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
BM.temp.Assign(tempo1);
BM.Repaint;
tempo1.free;
end;

end.
