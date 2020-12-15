unit MartPar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TMartinParams = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    MartIters: TEdit;
    MartColStep: TEdit;
    Button1: TButton;
    Button2: TButton;
    RG1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MartinParams: TMartinParams;
  MartinFunc : Integer;
implementation

uses Main;

{$R *.DFM}


procedure TMartinParams.FormCreate(Sender: TObject);
begin
 MartinParams.MartIters.Text :=   IntToStr(MartinIterations);
 MartinParams.MartColStep.Text := IntToStr(tMax);
 MartinFunc := 0;
end;

procedure TMartinParams.Button1Click(Sender: TObject);
begin
   MartinIterations :=  StrToInt(MartinParams.MartIters.Text);
   tMax             :=  StrToInt(MartinParams.MartColStep.Text);
   MartinFunc := RG1.ItemIndex;
   Close;
end;

procedure TMartinParams.Button2Click(Sender: TObject);
begin
 MartinParams.MartIters.Text :=   IntToStr(MartinIterations);
 MartinParams.MartColStep.Text := IntToStr(tMax);
 Close;
end;

end.
