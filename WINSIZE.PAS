unit WinSize;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TWinSize1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    CenterScreen: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WinSize1: TWinSize1;

implementation

{$R *.DFM}

procedure TWinSize1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

end.
