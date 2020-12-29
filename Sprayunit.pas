unit Sprayunit;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//
//8-12-2000 :    Change the spay proc to work with scanlines. 1000% faster !!!
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TSprayForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   procedure Spray(Amount:Integer);
  end;

var
  SprayForm: TSprayForm;
  spr: integer;
implementation

uses Main;

{$R *.DFM}

procedure TSprayForm.TrackBar1Change(Sender: TObject);
begin
 spr:= trackbar1.position;
 edit1.text := inttostr(spr);
 spray(spr);
end;

procedure TSprayForm.Spray(Amount:Integer);
var
r,x,y,cl1,cl2: Integer;
RowRGB   :  pRGBArray;
AllScanLines : array[0..800] of pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := bm.original.width;
temp1.Height := bm.original.height;
temp1.Assign(bm.original);
for x:= 0 to temp1.Height do
    AllScanLines[x]:= temp1.ScanLine[x];

 for y:= 0 to temp1.Height-1 do
 begin
   RowRGB  := AllScanLines[y];
   for x:= 0 to temp1.Width-1 do
    begin
     r:=Random(Amount);
     cl1 := TrimInt(x+(r-Random(r*2)),0,temp1.Width-1);
     cl2 := TrimInt(y+(r-Random(r*2)),0,temp1.Height-1);

     AllScanLines[cl2,cl1].rgbtRed   := RowRGB[x].rgbtRed;
     AllScanLines[cl2,cl1].rgbtGreen := RowRGB[x].rgbtGreen;
     AllScanLines[cl2,cl1].rgbtBlue  := RowRGB[x].rgbtBlue;
    end;
  end;
bm.temp.Assign(temp1);
bm.Repaint;
temp1.free;
end;

procedure TSprayForm.FormShow(Sender: TObject);
begin
if edit1.text <> '' then
   trackbar1.position := strtoint(edit1.text);
   spr:= trackbar1.position;
   //spray(trackbar1.position);
end;

procedure TSprayForm.Edit1Change(Sender: TObject);
begin
  if edit1.text <> '' then
   begin

   trackbar1.position := strtoint(edit1.text);
  end;
spr:= trackbar1.position;
end;

end.
