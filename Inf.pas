unit Inf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Registry, ExtCtrls, Gauges;

type
  TInfo = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    //Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    G1: TGauge;
    Label45: TLabel;
    Label47: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Info: TInfo;

implementation
uses Globs, Main;
{$R *.DFM}

procedure TInfo.FormCreate(Sender: TObject);
var
f: TRegIniFile;
begin
f := TRegIniFile.Create(REGPLACE);
//Info.Visible := f.ReadBool('Information Window','On',False);
Infovis := f.ReadBool(INFOWINDOW,'On',False);
Left := f.ReadInteger(INFOWINDOW,'Left',0);
Top := f.ReadInteger(INFOWINDOW,'Top',100);
f.Free;

Label11.Caption  := IntToStr(k);
Label12.Caption  := IntToStr(kstart);
Label13.Caption  := IntToStr(kend);
Label14.Caption  := IntToStr(kstep);
Label15.Caption := Format(F1817,[r]);
Label16.Caption := Format(F1817,[recen]);
Label17.Caption := Format(F1817,[imcen]);
Label18.Caption := Format(F1817,[stepx]);
Label19.Caption := Format(F1817,[stepy]);
Label22.Caption := IntToStr(Iters);
Label24.Caption := IntToStr(Hours)+':'+IntToStr(Mins)+':'
                        +IntToStr(Secs)+':'+IntToStr(Msecs);
Label26.Caption := Format(F1817,[XMax]);
Label30.Caption := Format(F1817,[XMin]);
Label32.Caption := Format(F1817,[YMax]);
Label34.Caption := Format(F1817,[YMin]);
Label36.Caption := FractalName;
Label38.Caption := PaletteName;
//if ((Visible) and (BM.Visible)) then BM.SetFocus;
//Update;
end;

procedure TInfo.FormShow(Sender: TObject);
begin
BM.StUpdate;
end;

end.
