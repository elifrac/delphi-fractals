unit BParams;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TParams1 = class(TForm)
    Button4: TButton;
    Button5: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label16: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    UpDown1: TUpDown;
    Edit1: TEdit;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Edit3: TEdit;
    UpDown3: TUpDown;
    Edit4: TEdit;
    Button3: TButton;
    Edit11: TEdit;
    UpDown5: TUpDown;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    Label18: TLabel;
    ColoringMode: TRadioGroup;
    Button2: TButton;
    Button1: TButton;
    OutsideCombo: TComboBox;
    Invert: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label17: TLabel;
    Bevel1: TBevel;
    Edit5: TEdit;
    UpDown4: TUpDown;
    Edit6: TEdit;
    Edit12: TEdit;
    RadioGroup1: TRadioGroup;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OutsideComboClick(Sender: TObject);
    procedure ColoringModeClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Params1: TParams1;

implementation

uses Globs, Main, SplitCnf;

{$R *.DFM}


procedure TParams1.FormShow(Sender: TObject);
begin
Edit1.Text := IntToStr(kstart);
Edit2.Text := IntToStr(kend);
Edit3.Text := IntToStr(kstep);
Edit4.Text := FloatToStr(r);
Edit5.Text := IntToStr(Iters);
Edit6.Text := IntToStr(bailoutvalue);
Edit7.Text := FloatToStr(XMax);
Edit8.Text := FloatToStr(XMin);
Edit9.Text := FloatToStr(YMax);
Edit10.Text := FloatToStr(YMin);
if stepiter < 1 then stepiter := 1;
Edit11.Text := IntToStr(stepiter);
Edit12.Text := FloatToStr(HalleyBailOut);
end;

procedure TParams1.Edit4Change(Sender: TObject);
begin
   if Length(Edit4.Text) > 0 then
    begin
     r := StrToFloat(Edit4.Text);
     XMax := recen + r;
     XMin := recen - r;
     YMax := imcen - r;
     YMin := imcen + r;
     Edit7.Text := FloatToStr(XMax);
     Edit8.Text := FloatToStr(XMin);
     Edit9.Text := FloatToStr(YMax);
     Edit10.Text := FloatToStr(YMin);
    end;
   BM.StUpdate;
end;

procedure TParams1.Button2Click(Sender: TObject);
begin
BM.ColorDialog1.Color := BioColor;
If BM.ColorDialog1.Execute then
   begin
     BioColor := BM.ColorDialog1.Color;
     with PaintBox1.Canvas do
       begin
       Brush.Color := BioColor;
       Rectangle(0,0,Width,Height);
       end;
   end;
end;

procedure TParams1.FormPaint(Sender: TObject);
begin
with PaintBox1.Canvas do
  begin
   Brush.Color := BioColor;
   Rectangle(0,0,Width,Height);
  end;
with PaintBox2.Canvas do
  begin
   Brush.Color := BioColor2;
   Rectangle(0,0,Width,Height);
  end;
end;

procedure TParams1.Button1Click(Sender: TObject);
begin
BM.ColorDialog1.Color := BioColor2;
If BM.ColorDialog1.Execute then
   begin
     BioColor2 := BM.ColorDialog1.Color;
     with PaintBox2.Canvas do
       begin
       Brush.Color := BioColor2;
       Rectangle(0,0,Width,Height);
       end;
   end;
end;

procedure TParams1.Button3Click(Sender: TObject);
begin
 SplitConForm.ShowModal;
end;

procedure TParams1.FormCreate(Sender: TObject);
begin
RadioGroup1.ItemIndex := DrMethod;
ColoringMode.ItemIndex := ColMode;
OutsideCombo.ItemIndex := OutsideColor;
end;

procedure TParams1.OutsideComboClick(Sender: TObject);
begin
OutSideColor := OutsideCombo.ItemIndex;
end;

procedure TParams1.ColoringModeClick(Sender: TObject);
begin
ColMode := ColoringMode.ItemIndex;
end;

procedure TParams1.RadioGroup1Click(Sender: TObject);
begin
DrMethod := RadioGroup1.ItemIndex;
end;
                      
procedure TParams1.Button4Click(Sender: TObject);
begin
kstart := StrToInt(Edit1.Text);
kend := StrToInt(Edit2.Text);
kstep := StrToInt(Edit3.Text);
r := StrToFloat(Edit4.Text);
Iters := StrToInt(Edit5.Text);
bailoutvalue := StrToInt(Edit6.Text);
XMax := StrToFloat(Edit7.Text);
XMin := StrToFloat(Edit8.Text);
YMax := StrToFloat(Edit9.Text);
YMin := StrToFloat(Edit10.Text);
stepiter := StrToInt(Edit11.Text);
if stepiter < 1 then stepiter := 1;
HalleyBailOut := StrToFloat(Edit12.Text);
BM.StUpdate;
end;

end.
