unit HalSel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  THalFunc = class(TForm)
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HalFunc: THalFunc;

implementation
uses main;              
{$R *.DFM}

procedure THalFunc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
HallFunction := radiogroup1.ItemIndex;
end;

procedure THalFunc.FormShow(Sender: TObject);
begin
radiogroup1.ItemIndex := HallFunction;
end;

end.
