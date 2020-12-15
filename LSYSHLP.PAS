unit LsysHlp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TLsysHelp = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LsysHelp: TLsysHelp;

implementation

{$R *.DFM}

procedure TLsysHelp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

end.
