unit SplitCnf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TSplitConForm = class(TForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplitConForm: TSplitConForm;

implementation

uses Main;

{$R *.DFM}

procedure TSplitConForm.Button1Click(Sender: TObject);
begin
SplitOrder := RadioGroup1.ItemIndex;
close;
end;

procedure TSplitConForm.FormCreate(Sender: TObject);
begin
 RadioGroup1.ItemIndex := SplitOrder;
end;

procedure TSplitConForm.RadioGroup1Click(Sender: TObject);
begin
 SplitOrder := RadioGroup1.ItemIndex;
end;

end.
