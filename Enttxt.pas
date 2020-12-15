unit EntTxt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TEnterTxt = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EnterTxt: TEnterTxt;

implementation

uses Globs;

{$R *.DFM}

procedure TEnterTxt.FormShow(Sender: TObject);
begin
Edit1.Text := CanvasText;
end;

end.
