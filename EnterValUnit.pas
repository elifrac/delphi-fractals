unit EnterValUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TEnterVal = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Value: TSpinEdit;
    Label2: TLabel;
    procedure ValueChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
     { Public declarations }
  end;

var
  EnterVal: TEnterVal;
implementation

uses Main;

{$R *.DFM}

procedure TEnterVal.ValueChange(Sender: TObject);
begin
if value.text <> '' then
   begin
    value2 := strtoint(value.text);
      case nfn of
        0 :    bm.XorApply;
        1 :    bm.OrApply;
        2 :    bm.AndApply;
        3 :    bm.AddApply;
        4 :    bm.SubtractValApply;
        5 :    bm.SubtractFromValApply;
      end;
   end;
end;

procedure TEnterVal.FormShow(Sender: TObject);
begin
if value.text <> '' then
   begin
    value2 := strtoint(value.text);
    case nfn of
        0 :    bm.XorApply;
        1 :    bm.OrApply;
        2 :    bm.AndApply;
        3 :    bm.AddApply;
        4 :    bm.SubtractValApply;
        5 :    bm.SubtractFromValApply;
    end;
   end;
end;

end.
