unit InputUnit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ipl2,iplfunc2;

type
  TInputForm1 = class(TForm)
    ScrollBar1: TScrollBar;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InputForm1: TInputForm1;
  //preview : boolean;

implementation

uses Main;

{$R *.DFM}

procedure TInputForm1.FormShow(Sender: TObject);
begin
preview := true;
ScrollBar1.Position := 1;
Label3.Caption := IntToStr(ScrollBar1.Position);
amnt := ScrollBar1.Position;
bm.DoSpreadImage1Click(self);
//BM.Process(Threshold);
end;

procedure TInputForm1.ScrollBar1Change(Sender: TObject);
begin
Label3.Caption := IntToStr(ScrollBar1.Position);
amnt := ScrollBar1.Position;
bm.DoSpreadImage1Click(self);
//BM.Process(Threshold);
end;

procedure TInputForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
preview := false;
end;

end.
