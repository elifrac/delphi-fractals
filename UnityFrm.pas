unit UnityFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TUnityForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UnityForm: TUnityForm;

implementation

uses types;
{$R *.DFM}

procedure TUnityForm.FormCreate(Sender: TObject);
begin
 UnityForm.Edit1.Text := Format('%3.2f',[UnityBailOut]);
end;

procedure TUnityForm.Button1Click(Sender: TObject);
begin
  UnityBailOut := StrToFloat(UnityForm.Edit1.Text);
  Close;
end;

end.
