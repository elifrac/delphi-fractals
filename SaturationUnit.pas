unit SaturationUnit;
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
  TSaturationForm = class(TForm)
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
    procedure SaturationApply(Amount:Integer);
  end;

var
  SaturationForm: TSaturationForm;
  Alpha:  array[0..255]of Word;
  Grays:  array[0..767]of Integer;
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

procedure TSaturationForm.TrackBar2Change(Sender: TObject);
begin
label5.caption := inttostr(trackbar2.position - 255);
SaturationApply(trackbar2.position);
end;

procedure TSaturationForm.FormShow(Sender: TObject);
begin
trackbar2.position := 255;
label5.caption := inttostr(trackbar2.position - 255);
end;

procedure TSaturationForm.SaturationApply(Amount:Integer);
var
Gray,x,y: Integer;
RowRgb: pRGBArray;
tempo1: TBitmap;
begin
tempo1 := TBitmap.Create;
tempo1.Assign(BM.original);
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
BM.temp.Assign(tempo1);
BM.Repaint;
tempo1.free;
end;

end.
