unit ThresholdUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TThresholdForm = class(TForm)
    LowThreshold: TSpinEdit;
    HighThreshold: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure HighThresholdChange(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ThresholdApply;
  end;

var
  ThresholdForm: TThresholdForm;
  HT,LT,cmbindx : integer;
  RHT,RLT,GHT,GLT,BHT,BLT : integer;

implementation

uses Main;

{$R *.DFM}

procedure TThresholdForm.ThresholdApply;
var
temp1: TBitmap;
i,j: Integer;
RowRGB   :  pRGBArray;
begin
temp1 := TBitmap.Create;
temp1.PixelFormat := pf24bit;
temp1.Height := BM.ClientHeight;
temp1.Width := BM.ClientWidth;
temp1.Assign(BM.original);
temp1.Canvas.Pixels[0,0]:= BM.original.Canvas.Pixels[0,0];

for j:= 0 to temp1.Height-1 do
 begin
   RowRGB  := temp1.ScanLine[j];
   for i:= 0 to temp1.Width-1 do
    begin
     case cmbindx of
      0 : begin
           if (RowRGB[i].rgbtRed   > HT) then RowRGB[i].rgbtRed   := HT else
           if (RowRGB[i].rgbtRed   < LT) then RowRGB[i].rgbtRed   := LT;
           if (RowRGB[i].rgbtGreen > HT) then RowRGB[i].rgbtGreen := HT else
           if (RowRGB[i].rgbtGreen < LT) then RowRGB[i].rgbtGreen := LT;
           if (RowRGB[i].rgbtBlue  > HT) then RowRGB[i].rgbtBlue  := HT else
           if (RowRGB[i].rgbtBlue  < LT) then RowRGB[i].rgbtBlue  := LT;
          end;
      1 : begin
           if (RowRGB[i].rgbtRed   > RHT) then RowRGB[i].rgbtRed   := RHT else
           if (RowRGB[i].rgbtRed   < RLT) then RowRGB[i].rgbtRed   := RLT;
          end;
      2 : begin
           if (RowRGB[i].rgbtGreen > GHT) then RowRGB[i].rgbtGreen := GHT else
           if (RowRGB[i].rgbtGreen < GLT) then RowRGB[i].rgbtGreen := GLT;
          end;
      3 : begin
           if (RowRGB[i].rgbtBlue  > BHT) then RowRGB[i].rgbtBlue  := BHT else
           if (RowRGB[i].rgbtBlue  < BLT) then RowRGB[i].rgbtBlue  := BLT;
          end;
     end; // case
   end;  // i
  end;  // j
BM.temp.Assign(temp1);
temp1.free;
Application.ProcessMessages;
BM.Repaint;
end;

procedure TThresholdForm.FormShow(Sender: TObject);
begin
Combobox1.ItemIndex := 0;
cmbindx := Combobox1.ItemIndex;
Lowthreshold.Value := 0;
Highthreshold.Value := 255;
HT := HighThreshold.Value;
LT := LowThreshold.Value;
RHT := HT; GHT := HT; BHT := HT;
RLT := LT; GLT := LT; BLT := LT;
end;

procedure TThresholdForm.HighThresholdChange(Sender: TObject);
begin
case cmbindx of
 0 : begin
      HT := HighThreshold.Value;
      LT := LowThreshold.Value;
     end;
 1 : begin
      RHT := HighThreshold.Value;
      RLT := LowThreshold.Value;
     end;
 2 : begin
      GHT := HighThreshold.Value;
      GLT := LowThreshold.Value;
     end;
 3 : begin
      BHT := HighThreshold.Value;
      BLT := LowThreshold.Value;
     end;
end; // case

ThresholdApply;

end;

procedure TThresholdForm.ComboBox1Change(Sender: TObject);
begin
cmbindx := Combobox1.ItemIndex;
end;

end.
