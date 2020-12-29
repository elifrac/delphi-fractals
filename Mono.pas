unit Mono;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is a part of the EliFrac Project
//
//  24-4-99 : Modified to directly update the main window using scanlines
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TMonoForm = class(TForm)
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
   procedure PreviewMono;
    { Public declarations }
  end;

var
  MonoForm: TMonoForm;
  inprogress : boolean;
implementation

uses Main;

{$R *.DFM}

procedure TMonoForm.FormShow(Sender: TObject);
begin
Trackbar1.Position := 0;
Label1.Caption := IntToStr(Trackbar1.Position);
case clfl of
     0 : begin
         Caption := 'Red Filter';  // Red
         Label4.Caption := 'Red';
         Label5.Caption := 'Cyan';
         end;
     1 : begin
         Caption := 'Green Filter';  // Green
         Label4.Caption := 'Green';
         Label5.Caption := 'Magenta';
         end;
     2 : begin
         Caption := 'Blue Filter';  // Blue;
         Label4.Caption := 'Blue';
         Label5.Caption := 'Yellow';
         end;
     3 : begin
         Caption := 'Cyan Filter';  //Cyan
         Label4.Caption := 'Cyan';
         Label5.Caption := 'Red';
         end;
     4 : begin
         Caption := 'Magenta Filter';;  // Magenta
         Label4.Caption := 'Magenta';
         Label5.Caption := 'Green';
         end;
     5 : begin
         Caption := 'Yellow Filter';  //yellow
         Label4.Caption := 'Yellow';
         Label5.Caption := 'Blue';
         end;
     6 : begin
         Caption := 'Grey Filter';  // Grey
         Label4.Caption := '';
         Label5.Caption := '';
         end;
    end;   // case
end;

procedure TMonoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ColorIntens := Trackbar1.Position;
end;

procedure TMonoForm.TrackBar1Change(Sender: TObject);
begin
if not inprogress then begin
inprogress := true;
Label1.Caption := IntToStr(Trackbar1.Position);
ColorIntens := Trackbar1.Position;
//update;
PreviewMono;
inprogress := false;
end;
end;

procedure TMonoForm.PreviewMono;  // Preview Monochromatic Filter
var
temp1: TBitmap;
i,j: Integer;
r: byte;
RowRGB   :  pRGBArray;
begin
temp1 := TBitmap.Create;
temp1.PixelFormat := pf24bit;
temp1.Height := BM.ClientHeight;
temp1.Width := BM.ClientWidth;
temp1.Assign(BM.original{temp});
temp1.Canvas.Pixels[0,0]:= BM.original.Canvas.Pixels[0,0];

for j:= 0 to temp1.Height-1 do
 begin
   RowRGB  := temp1.ScanLine[j];
   for i:= 0 to temp1.Width-1 do
    begin
    case clfl of
     0 : begin              // Red
          RowRGB[i].rgbtGreen := ColorIntens;
          RowRGB[i].rgbtBlue := ColorIntens;
         end;
     1 : begin               // Green
          RowRGB[i].rgbtRed := ColorIntens;
          RowRGB[i].rgbtBlue := ColorIntens;
         end;
     2 : begin               //Blue
          RowRGB[i].rgbtRed := ColorIntens;
          RowRGB[i].rgbtGreen := ColorIntens;
         end;
     3 : begin                //Cyan
          RowRGB[i].rgbtRed := ColorIntens;

         end;
     4 : begin              //Magenta
          RowRGB[i].rgbtGreen := ColorIntens;
         end;
     5 : begin              //Yellow
          RowRGB[i].rgbtBlue := ColorIntens;
         end;
     6 : begin              //Gray
          r := ((76*RowRGB[i].rgbtRed)+(150*RowRGB[i].rgbtGreen)+(29*RowRGB[i].rgbtBlue)) div 256;
          RowRGB[i].rgbtRed := r+ColorIntens;
          RowRGB[i].rgbtGreen := r+ColorIntens;
          RowRGB[i].rgbtBlue := r+ColorIntens;
         end;
    end; // case
   end;
  end;
BM.temp.Assign(temp1);
BM.original.Assign(temp1);
temp1.free;
Application.ProcessMessages;
BM.Repaint;
end;

procedure TMonoForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then ModalResult := mrOK;
end;


procedure TMonoForm.FormActivate(Sender: TObject);
begin
PreviewMono;
end;

end.
