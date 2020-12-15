unit Angle;

interface           

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TAngleFrm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AngleFrm: TAngleFrm;

implementation

{$R *.DFM}

end.
