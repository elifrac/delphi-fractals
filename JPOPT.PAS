unit JpOpt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, Jpeg, Registry;

type
  TJpegOptionsForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CompQuality: TSpinEdit;
    ProgrEncoding: TCheckBox;
    Bevel1: TBevel;
    Label6: TLabel;
    Label8: TLabel;
    Smooth: TCheckBox;
    ProgrDisplay: TCheckBox;
    PerformGroup: TRadioGroup;
    ScaleGroup: TRadioGroup;
    Bevel2: TBevel;
    Button1: TButton;
    Label5: TLabel;
    Gray: TCheckBox;
    PixelFormat1: TRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  JpegOptionsForm: TJpegOptionsForm;

implementation

uses Globs;

{$R *.DFM}

{$INCLUDE FiltConst}     // Include File FiltConst.pas

procedure TJpegOptionsForm.FormActivate(Sender: TObject);
begin
ProgrDisplay.Checked := PrDisplay;
Smooth.Checked := SmoothDisplay;
ProgrEncoding.Checked := jpgProgEncode;
ScaleGroup.ItemIndex := ord(jpgSize);
PerformGroup.ItemIndex := ord(jpgPerf);
CompQuality.Value := jpgCmpQlt;
Gray.Checked := GraySc;
PixelFormat1.ItemIndex := ord(jpgPxlFrm);
end;

procedure TJpegOptionsForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
f: TRegIniFile;
begin
PrDisplay := ProgrDisplay.Checked;
SmoothDisplay := Smooth.Checked;
jpgProgEncode := ProgrEncoding.Checked;

case  ScaleGroup.ItemIndex of
    0 : jpgSize := jsFullSize;
    1 : jpgSize := jsHalf;
    2 : jpgSize := jsQuarter;
    3 : jpgSize := jsEighth;
end;

case  PerformGroup.ItemIndex of
    0 : jpgPerf := jpBestQuality;
    1 :jpgPerf := jpBestSpeed;
end;
jpgCmpQlt := CompQuality.Value;
GraySc := Gray.Checked;
case   PixelFormat1.ItemIndex of
      0 : jpgPxlFrm := jf24Bit;
      1 : jpgPxlFrm := jf8Bit;
end;
//f := TIniFile.Create('EliFrac.ini');
f := TRegIniFile.Create(REGPLACE);
 f.WriteBool(JPGOPT,JPPROGDISP,PrDisplay);
 f.WriteBool(JPGOPT,JPPROGENCODE,jpgProgEncode);
 f.WriteBool(JPGOPT,'Smoothing',SmoothDisplay);
 f.WriteBool(JPGOPT,'Gray Scale',GraySc);
 f.WriteInteger(JPGOPT,'Scale',ord(jpgSize));
 f.WriteInteger(JPGOPT,JPPERFORMANCE,ord(jpgPerf));
 f.WriteInteger(JPGOPT,JPCOMPQUALITY,jpgCmpQlt);
 f.WriteInteger(JPGOPT,'Pixel Format',ord(jpgPxlFrm));
f.free;
Action := caFree;
end;

procedure TJpegOptionsForm.FormCreate(Sender: TObject);
var
f: TRegIniFile;
dummy :Integer;
begin
f := TRegIniFile.Create(REGPLACE);
 PrDisplay := f.ReadBool(JPGOPT,JPPROGDISP,False);
 jpgProgEncode := f.ReadBool(JPGOPT,JPPROGENCODE,False);
 SmoothDisplay := f.ReadBool(JPGOPT,'Smoothing',True);
 GraySc := f.ReadBool(JPGOPT,'Gray Scale',False);
 dummy:= f.ReadInteger(JPGOPT,'Scale',0);
  case dummy of
    0 : jpgSize := jsFullSize;
    1 : jpgSize := jsHalf;
    2 : jpgSize := jsQuarter;
    3 : jpgSize := jsEighth;
end;
  dummy := f.ReadInteger(JPGOPT,JPPERFORMANCE,0);
  case dummy of
    0 : jpgPerf := jpBestQuality;
    1 :jpgPerf := jpBestSpeed;
  end;
 jpgCmpQlt := f.ReadInteger(JPGOPT,JPCOMPQUALITY,75);
 dummy :=  f.ReadInteger(JPGOPT,'Pixel Format',0);
  case dummy of
    0 : jpgPxlFrm := jf24Bit;
    1 : jpgPxlFrm := jf8Bit;
  end;
f.free;
end;

end.
