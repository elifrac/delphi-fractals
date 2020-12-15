unit LBS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TLBSizeFrm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LBSizeFrm: TLBSizeFrm;

implementation

uses Main;

{$R *.DFM}

procedure TLBSizeFrm.FormShow(Sender: TObject);
begin
Edit1.Text := IntToStr(LargeBitmapX);
Edit2.Text := IntToStr(LargeBitmapY);
end;

procedure TLBSizeFrm.Button1Click(Sender: TObject);
begin
LargeBitmapX := StrToInt(Edit1.Text);
LargeBitmapY := StrToInt(Edit2.Text);
end;

procedure TLBSizeFrm.FormCreate(Sender: TObject);
begin
  LargeBitmapX := 2048;
  LargeBitmapY := 2048;
end;

end.
