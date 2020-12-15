unit CustFil;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
TElFilter = array[0..2,0..2] of shortint;

 // {$INCLUDE FiltConst}     // Include File FiltConst.pas
type
  TCusFilForm = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
   procedure PreviewFilter(d : Integer ; filter : TElFilter );
   procedure getem;
    { Public declarations }
  end;

//const
//customfilter2  : TElFilter = ((1,0,-1),(0,0,0),(1,0,1));    // custom filter

var
  CusFilForm: TCusFilForm;
  temp1 : TBitmap;
  customfilter2 : TElFilter = ((1,0,-1),(0,0,0),(1,0,1));
  //showing1 : boolean;
implementation
uses {Globs,} Main;
{$R *.DFM}


procedure TCusFilForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
getem;
end;

procedure TCusFilForm.FormShow(Sender: TObject);
begin
//showing1 := true;
temp1 := TBitmap.Create;
temp1.PixelFormat := pf24bit;
temp1.Width := bm.original.width;
temp1.Height := bm.original.height;

Edit10.Text := IntToStr(customdenom);
Edit1.Text := IntToStr(customfilter2[0,0]);
Edit4.Text := IntToStr(customfilter2[0,1]);
Edit7.Text := IntToStr(customfilter2[0,2]);
Edit2.Text := IntToStr(customfilter2[1,0]);
Edit5.Text := IntToStr(customfilter2[1,1]);
Edit8.Text := IntToStr(customfilter2[1,2]);
Edit3.Text := IntToStr(customfilter2[2,0]);
Edit6.Text := IntToStr(customfilter2[2,1]);
Edit9.Text := IntToStr(customfilter2[2,2]);
//showing1 := false;
end;

procedure TCusFilForm.PreviewFilter(d : Integer ; filter : TElFilter );
var
a,b,i,j: Integer;
sumR,sumG,sumB : Integer;
//temp1 : TBitmap;
RowRGB   :  pRGBArray;
//label bailout;
begin
if d = 0 then exit;
//temp1 := TBitmap.Create;
//temp1.PixelFormat := pf24bit;
//temp1.Height := ClientHeight;
//temp1.Width := ClientWidth;
temp1.Assign(BM.original);
temp1.Canvas.Pixels[0,0] := BM.original.Canvas.Pixels[0,0];
//temp1.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
Brush.Style := bsSolid;

 for j:=1 to temp1.Height-1 do
  begin
   RowRGB  := temp1.ScanLine[j];
  for i:=1 to temp1.width-1 do
   begin
    sumR := 0; sumG := 0; sumB := 0;
     for a:=-1 to 1 do
      for b:=-1 to 1 do
       begin
        case filter[a+1,b+1] of
          0 : ;
          1 : begin
               sumR := sumR + RowRGB[i+a+b].rgbtRed;
               sumG := sumG + RowRGB[i+a+b].rgbtGreen;
               sumB := sumB + RowRGB[i+a+b].rgbtBlue;
              end;
         -1 : begin
               sumR := sumR - RowRGB[i+a+b].rgbtRed;
               sumG := sumG - RowRGB[i+a+b].rgbtGreen;
               sumB := sumB - RowRGB[i+a+b].rgbtBlue;
              end;
         else  begin
                sumR := sumR + RowRGB[i+a+b].rgbtRed * filter[a+1,b+1];
                sumG := sumG + RowRGB[i+a+b].rgbtGreen * filter[a+1,b+1];
                sumB := sumB + RowRGB[i+a+b].rgbtBlue * filter[a+1,b+1];
               end;
          end; // case
       end;  // for a, b loop
     if ((d <> 0) or (d <> 1)) then
       begin
          sumR := sumR div d;
          sumG := sumG div d;
          sumB := sumB div d;
        end;
     //if sumR < 0 then sumR := 0 else if sumR > $ff then sumR := $ff;
     //if sumG < 0 then sumG := 0 else if sumG > $ff then sumG := $ff;
     //if sumB < 0 then sumB := 0 else if sumB > $ff then sumB := $ff;
     if i>=2  then begin
     RowRGB[i-2].rgbtRed  := sumR;
     RowRGB[i-2].rgbtGreen := sumG;
     RowRGB[i-2].rgbtBlue  := sumB;
     end;
    // if (i >= (temp1.Width-2)) or (j >= (temp1.height-2)) then break;
       {begin
        RowRGB[i].rgbtRed  := $ff;
        RowRGB[i].rgbtGreen := $ff;
        RowRGB[i].rgbtBlue  := $ff;
       end;  }
   end; // j loop.
  end; // i loop.

BM.temp.Assign(temp1);
//BM.original.Assign(temp1);
//temp1.free;
Application.ProcessMessages;
BM.Repaint;
end;

procedure TCusFilForm.getem;
begin
customfilter2[0,0] := round(StrToFloat(Edit1.Text));
customfilter2[0,1] := round(StrToFloat(Edit4.Text));
customfilter2[0,2] := round(StrToFloat(Edit7.Text));
customfilter2[1,0] := round(StrToFloat(Edit2.Text));
customfilter2[1,1] := round(StrToFloat(Edit5.Text));
customfilter2[1,2] := round(StrToFloat(Edit8.Text));
customfilter2[2,0] := round(StrToFloat(Edit3.Text));
customfilter2[2,1] := round(StrToFloat(Edit6.Text));
customfilter2[2,2] := round(StrToFloat(Edit9.Text));
customdenom := round(StrToFloat(Edit10.Text));
if (customdenom = 0) then customdenom := 1;
end;

procedure TCusFilForm.Edit1Change(Sender: TObject);
begin
If ((Sender as TEdit).Text = '') or ((Sender as TEdit).Text = '-') then exit;
getem;
PreviewFilter(customdenom,TElFilter(customfilter2));
end;

procedure TCusFilForm.FormHide(Sender: TObject);
begin
temp1.free;
end;

procedure TCusFilForm.Button3Click(Sender: TObject);
begin
Edit10.Text := '1';
Edit1.Text := '1';
Edit4.Text := '0';
Edit7.Text := '0';
Edit2.Text := '0';
Edit5.Text := '0';
Edit8.Text := '0';
Edit3.Text := '0';
Edit6.Text := '0';
Edit9.Text := '0';
getem;
end;

end.
