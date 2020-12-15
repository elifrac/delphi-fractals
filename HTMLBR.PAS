unit HTMLBr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, Menus, StdCtrls, Button3D, ExtCtrls, isp3;

type
  THTMLForm1 = class(TForm)
    HTML1: THTML;
    Panel1: TPanel;
    Button3D1: TButton3D;
    Button3D2: TButton3D;
    procedure FormActivate(Sender: TObject);
    procedure Button3D1Click(Sender: TObject);
    procedure Button3D2Click(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  HTMLForm1: THTMLForm1;

implementation
uses  Globs;
{$R *.DFM}

procedure THTMLForm1.FormActivate(Sender: TObject);
var
fn : String;
begin
 fn := 'file://localhost/'+ HelpDirectory + '\Elifract.htm';
 HTML1.RequestDoc(fn);
 HTML1.RequestAllEmbedded;
end;

procedure THTMLForm1.Button3D1Click(Sender: TObject);
begin
HTML1.ViewSource := False;
end;

procedure THTMLForm1.Button3D2Click(Sender: TObject);
begin
HTML1.ViewSource := True;
end;

end.
