unit AttrPar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TAttractorForm = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit5: TEdit;
    Edit6: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Edit7: TEdit;
    Label8: TLabel;
    Button3: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
ROSSLER = 'Rossler Attractor Parameters';
LORENZ  = 'Lorenz Attractor Parameters';
var
AttractorForm: TAttractorForm;

implementation

uses Globs;

{$R *.DFM}

procedure TAttractorForm.FormClose(Sender: TObject;  var Action: TCloseAction);
begin
   if FractalName = fractal[RosslerAttractor] then {'ROSSLER ATTRACTOR'}
   begin
   Raaa := StrToFloat(edit1.Text);
   Rbbb := StrToFloat(edit2.Text);
   Rccc := StrToFloat(edit3.Text);
   Rdt :=  StrToFloat(edit4.Text);
   RLoops := StrToInt(edit5.Text);
   RHide :=  StrToInt(edit6.Text);
   RColorEvery :=  StrToInt(edit7.Text);
   end
  else
  if FractalName = fractal[LorenzAttractor] then {'LORENZ ATTRACTOR'}
    begin
    Laaa := StrToFloat(edit1.Text);
    Lbbb := StrToFloat(edit2.Text);
    Lccc := StrToFloat(edit3.Text);
    Ldt :=  StrToFloat(edit4.Text);
    LLoops := StrToInt(edit5.Text);
    LHide :=  StrToInt(edit6.Text);
    LColorEvery :=  StrToInt(edit7.Text);
    end;
  aaa := StrToFloat(edit1.Text);
  bbb := StrToFloat(edit2.Text);
  ccc := StrToFloat(edit3.Text);
  dt :=  StrToFloat(edit4.Text);
  Loops := StrToInt(edit5.Text);
  AHide :=  StrToInt(edit6.Text);
  ColorEvery :=  StrToInt(edit7.Text);
end;

procedure TAttractorForm.FormShow(Sender: TObject);
begin
   if FractalName = fractal[RosslerAttractor] then {'ROSSLER ATTRACTOR'}
   begin
   Label1.Caption := ROSSLER;
   aaa := Raaa;
   bbb := Rbbb;
   ccc := Rccc;
   dt := Rdt;
   loops := RLoops;
   Ahide := RHide;
   ColorEvery := RColorEvery ;
   end
  else
  if FractalName = fractal[LorenzAttractor]  then  {'LORENZ ATTRACTOR'}
    begin
    Label1.Caption := LORENZ;
    aaa := Laaa;
    bbb := Lbbb;
    ccc := Lccc;
    dt := Ldt;
    loops := LLoops;
    Ahide := LHide;
    ColorEvery := LColorEvery ;
    end;
 edit1.Text := Format('%7.4f',[aaa]);
 edit2.Text := Format('%7.4f',[bbb]);
 edit3.Text := Format('%7.4f',[ccc]);
 edit4.Text := Format('%7.4f',[dt]);
 edit5.Text := Format('%d',[loops]);
 edit6.Text := Format('%d',[Ahide]);
 edit7.Text := Format('%d',[ColorEvery]);
end;

procedure TAttractorForm.Button3Click(Sender: TObject);
begin
   if FractalName = fractal[RosslerAttractor] then {'ROSSLER ATTRACTOR'}
   begin
   Raaa := 0.2;
   Rbbb := 0.2;
   Rccc := 5.7;
   Rdt :=  0.04;
   RLoops := 50000;
   RHide :=  2000;
   RColorEvery := 5000;
   edit1.Text := Format('%7.4f',[Raaa]);
   edit2.Text := Format('%7.4f',[Rbbb]);
   edit3.Text := Format('%7.4f',[Rccc]);
   edit4.Text := Format('%7.4f',[Rdt]);
   edit5.Text := Format('%d',[Rloops]);
   edit6.Text := Format('%d',[Rhide]);
   edit7.Text := Format('%d',[RColorEvery]);
   end
  else
  if FractalName = fractal[LorenzAttractor]  then   {'LORENZ ATTRACTOR'}
    begin
    Laaa := 10;
    Lbbb := 2.667;
    Lccc := 28;
    Ldt :=  0.02;
    LLoops := 50000;
    LHide :=  2000;
    LColorEvery := 5000;
    edit1.Text := Format('%7.4f',[Laaa]);
    edit2.Text := Format('%7.4f',[Lbbb]);
    edit3.Text := Format('%7.4f',[Lccc]);
    edit4.Text := Format('%7.4f',[Ldt]);
    edit5.Text := Format('%d',[Lloops]);
    edit6.Text := Format('%d',[Lhide]);
    edit7.Text := Format('%d',[LColorEvery]);
    end;
end;

end.
