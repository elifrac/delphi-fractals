unit Denfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Spin;

type
TElFilter = array[0..2,0..2] of shortint;
  TDenomForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TSpinEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Prv2: TPaintBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Prv2DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PreviewFilter2(d : Integer ; filter : TElFilter );
    procedure SeeIt;
  end;

var
  DenomForm: TDenomForm;
  tmp4 : TBitmap;
  sh : boolean;
implementation

uses Globs,Main;

{$R *.DFM}

procedure TDenomForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then ModalResult := mrOK;
end;

procedure TDenomForm.PreviewFilter2(d : Integer ; filter : TElFilter );
var
btmp : TBitmap;
sumR,sumG,sumB : Integer;
a,b,i,j,pix : Integer;
begin
Screen.Cursor := crHourglass;
btmp := TBitmap.Create;
btmp.Width := tmp4.Width;
btmp.Height := tmp4.Height;
 for i:=1 to Prv2.ClientWidth-1 do
  begin
  for j:=1 to Prv2.Clientheight-1 do
   begin
    sumR := 0; sumG := 0; sumB := 0;
    for a:=-1 to 1 do
      for b:=-1 to 1 do
       begin
        pix := ColorToRGB(tmp4.Canvas.Pixels[i+a,j+b]);
        sumR := sumR + GetRValue(pix) * filter[a+1,b+1];
        sumG := sumG + GetGValue(pix) * filter[a+1,b+1];
        sumB := sumB + GetBValue(pix) * filter[a+1,b+1];
       end;
     sumR := sumR div d;
     sumG := sumG div d;
     sumB := sumB div d;
     if sumR < 0 then sumR := 0 else if sumR > $ff then sumR := $ff;
     if sumG < 0 then sumG := 0 else if sumG > $ff then sumG := $ff;
     if sumB < 0 then sumB := 0 else if sumB > $ff then sumB := $ff;
     btmp.Canvas.Pixels[i-1,j-1] := RGB(sumR,sumG,sumB);
   end; // j loop.
  end; // i loop.
DenomForm.Prv2.Canvas.Draw(0,0,btmp);
Screen.Cursor := crDefault;
btmp.free;
end;

procedure TDenomForm.Prv2DblClick(Sender: TObject);
begin
 Prv2.Canvas.StretchDraw(Prv2.ClientRect,tmp4);
end;

procedure TDenomForm.FormShow(Sender: TObject);
begin
tmp4 := TBitmap.Create;
tmp4.Width  := Prv2.ClientWidth;
tmp4.Height := Prv2.ClientHeight;
sh := true;
Update;
case whichfilter of
1 :  begin Edit1.Value := 15; Caption := 'Blur Filter'; end; //Blur
2 :  begin Edit1.Value := 1;  Caption := 'Sharpen Filter';  end;  // Sharpen
3 :  begin Edit1.Value := 1;  Caption := 'Sharpen More Filter';  end;  // Sharpen More
4 :  begin Edit1.Value := 1;  Caption := 'Relief Filter';  end;  // Relief Ανάγλυφο
end;
den := Edit1.Value;
tmp4.Canvas.StretchDraw(Prv2.ClientRect,BM.temp);
sh := false;
end;

procedure TDenomForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
tmp4.free;
den := Edit1.Value;
end;

procedure TDenomForm.SeeIt;
begin
case whichfilter of
1 : PreviewFilter2(den,(TElFilter(lpfilter6)));
2 : PreviewFilter2(den,(TElFilter(lpfilter9)));
3 : PreviewFilter2(den,(TElFilter(hpfilter2)));
4 : PreviewFilter2(den,(TElFilter(hpfilter4)));
end;
end;

procedure TDenomForm.Edit1Change(Sender: TObject);
begin
if sh then exit;
if (Edit1.Text = '0') or (Edit1.Text = '') or (Edit1.Text = '-')  then exit;
den := Edit1.Value;
if (den <-128) or (den>128) then MessageDlg('A Value Between -128 and 128 Must be Entered',mtError,[mbOK],0)
else SeeIt;
end;

procedure TDenomForm.FormActivate(Sender: TObject);
begin
Update;
SeeIt;
end;

end.
