unit ChrmUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls; {Label3D;}

type
  TChromaForm = class(TForm)
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    //Label3D1: TLabel;
    //Label3D2: TLabel;
    //Label3D3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollBar2Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollBar3Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScrollBar1Exit(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    procedure PreviewChroma;
    { Public declarations }
  end;

var
  ChromaForm: TChromaForm;
  temp2 : TBitmap;
  inprogress : boolean;
implementation

uses Main;

{$R *.DFM}

procedure TChromaForm.FormShow(Sender: TObject);
begin
temp2 := TBitmap.Create;
temp2.PixelFormat := pf24bit;
temp2.Height := BM.ClientHeight;
temp2.Width := BM.ClientWidth;
temp2.Assign(BM.temp);
temp2.Canvas.Pixels[0,0]:= BM.temp.Canvas.Pixels[0,0];
scrollbar1.Position := 0;
scrollbar2.Position := 0;
scrollbar3.Position := 0;
Label7.Caption := IntToStr(scrollbar1.Position);
Label8.Caption := IntToStr(scrollbar2.Position);
Label9.Caption := IntToStr(scrollbar3.Position);
end;

procedure TChromaForm.PreviewChroma;  // Preview Chroma Filter
var
temp1: TBitmap;
i,j: Integer;
RowRGB   :  pRGBArray;
begin
temp1 := TBitmap.Create;
temp1.PixelFormat := pf24bit;
temp1.Height := BM.ClientHeight;
temp1.Width := BM.ClientWidth;
temp1.Assign(temp2);
temp1.Canvas.Pixels[0,0]:= temp2.Canvas.Pixels[0,0];  // force bitmap copy

for j:= 0 to temp1.Height-1 do
 begin
   RowRGB  := temp1.ScanLine[j];
   for i:= 0 to temp1.Width-1 do
    begin
    //if (RowRGB[i].rgbtBlue > 127) then
    RowRGB[i].rgbtBlue := RowRGB[i].rgbtBlue+IntB;
    //else RowRGB[i].rgbtBlue := RowRGB[i].rgbtBlue-IntB;
    //if (RowRGB[i].rgbtGreen > 127) then
    RowRGB[i].rgbtGreen := RowRGB[i].rgbtGreen+IntG;
    //else RowRGB[i].rgbtGreen := RowRGB[i].rgbtGreen-IntG;
    //if (RowRGB[i].rgbtRed >127) then
    RowRGB[i].rgbtRed := RowRGB[i].rgbtRed+IntR;
    //else RowRGB[i].rgbtRed := RowRGB[i].rgbtRed-IntR;
   end;
end;
Application.ProcessMessages;
BM.temp.Assign(temp1);
//BM.temp.Canvas.Pixels[0,0] := temp1.Canvas.Pixels[0,0];
BM.original.Assign(temp1);
//BM.original.Canvas.Pixels[0,0] := temp1.Canvas.Pixels[0,0];
BM.Repaint;
temp1.free;
end;

procedure TChromaForm.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
          var ScrollPos: Integer);
begin
if not inprogress then begin
inprogress := true;
Label7.Caption := IntToStr(ScrollPos);
IntR :=  ScrollPos;
inprogress := false;
end;
PreviewChroma;
end;

procedure TChromaForm.ScrollBar2Scroll(Sender: TObject; ScrollCode: TScrollCode;
          var ScrollPos: Integer);
begin
if not inprogress then begin
inprogress := true;
Label8.Caption := IntToStr(ScrollPos);
IntG :=  ScrollPos;
inprogress := false;
end;
PreviewChroma;
end;

procedure TChromaForm.ScrollBar3Scroll(Sender: TObject; ScrollCode: TScrollCode;
          var ScrollPos: Integer);
begin
if not inprogress then begin
inprogress := true;
Label9.Caption := IntToStr(ScrollPos);
IntB :=  ScrollPos;
inprogress := false;
end;
PreviewChroma;
end;

procedure TChromaForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then ModalResult := mrOK;
end;

procedure TChromaForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//IntR :=  scrollbar1.Position;
//IntG :=  scrollbar2.Position;
//IntB :=  scrollbar3.Position;
//temp2.free;
end;

procedure TChromaForm.ScrollBar1Exit(Sender: TObject);
begin
ActiveControl := Button1;
end;

procedure TChromaForm.FormHide(Sender: TObject);
begin
IntR :=  scrollbar1.Position;
IntG :=  scrollbar2.Position;
IntB :=  scrollbar3.Position;
temp2.free;
end;

end.
