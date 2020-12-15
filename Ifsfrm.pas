unit ifsfrm;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-1999
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles,ExtCtrls;

type
  TIfsForm = class(TForm)
    Label1: TLabel;
    RadioG1: TRadioGroup;
    Button1: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RadioG1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IfsForm: TIfsForm;

implementation
uses globs,Types,CustIfs;
{$R *.DFM}

procedure TIfsForm.FormCreate(Sender: TObject);
begin
ForeColor := clGreen;
end;

procedure TIfsForm.RadioG1Click(Sender: TObject);
begin
if RadioG1.ItemIndex = 11 then  // If Custom.
  begin
  CustomIfsForm.ShowModal;      // Show Custom Form.
  If CustomIfsForm.ModalResult = mrOk then
   begin
     ModalResult := mrOk;
   end
  end;
end;

end.
