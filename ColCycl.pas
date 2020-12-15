unit ColCycl;
//****************************************************************************************
//  Created 23-4-99.
//  This File is part of the EliFrac Project.
//  Author : Kyriakopoulos Elias  ©  1997-2000
//
//  Color Cycling routine by Earl F. Glynn, Copyright (C) 1998
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TColorCyclingForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    Panel3: TPanel;
    Button1: TButton;
    Panel4: TPanel;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    SpeedButton4: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private

   Moving : Boolean;
   Original_x , Original_y : Integer;
  public
  procedure DoCycle;
  end;
var
  ColorCyclingForm: TColorCyclingForm;
  Bitmap24 :  TBitmap;
  index,inccounter: integer;
  Delay9 : byte;
  SingleStep,CycleDirection,full : boolean;
implementation

uses Main,ClipBrd;

{$R *.DFM}

procedure TColorCyclingForm.Button1Click(Sender: TObject);
begin
if CyclingNow then Beep
else Close;
end;

procedure TColorCyclingForm.FormCreate(Sender: TObject);
begin
Image1.Picture.Bitmap.PixelFormat := pf24bit;
CycleStart := 1;
delay9 := 9;
Clipboard;
end;

procedure TColorCyclingForm.Button2Click(Sender: TObject);
begin
 if button2.Caption = 'START' then
   begin
    button2.Caption := 'STOP';
    CyclingNow := true;
    DoCycle;
   end
 else begin
       button2.Caption := 'START';
       CyclingNow := false;
      end;
end;

procedure TColorCyclingForm.DoCycle;
var
i,j: integer;
RowRGB,RowRGB24   :  pRGBArray;
begin
Image1.Picture.Bitmap.PixelFormat := pf24bit;
index:=0;
while CyclingNow do
 begin
   if DoTrueColor then
     begin
      case CycleDirection of
       true  : if (cyclestart > (TrueColorColorList.count-2)) then begin cyclestart := 0; inc(CycleStart,inccounter); end
               else begin inc(CycleStart,inccounter); end;
       false : if cyclestart < 1 then begin cyclestart := TrueColorColorList.count; dec(CycleStart,inccounter); end
               else dec(CycleStart,inccounter);
      end;
       for j := 0 to BM.original.height-1 do
        begin
         RowRGB  := BM.original.ScanLine[j];
         RowRGB24  := Bitmap24.ScanLine[j];
         for i := 0 to BM.original.width-1  do
          begin
          index := cyclestart + (RowRGB[i].rgbtred) +
                                (RowRGB[i].rgbtgreen) +
                                (RowRGB[i].rgbtblue);
         // if index > TrueColorColorList.Count-1 then index := index - TrueColorColorList.Count;
         if (index >= TrueColorColorList.Count-1) or (index < 0) then //continue;
           index := abs(index mod TrueColorColorList.Count);
         RowRGB24[i] := pRGBTriple(TrueColorColorList.Items[index])^;
      end; // for i
    end;   // for j
  end // if DotrueColor
  else
   begin
    case CycleDirection of
       true  : if (cyclestart > (ColorList.count-2)) then begin cyclestart := 0; inc(CycleStart,inccounter); end
               else begin inc(CycleStart,inccounter); end;
       false : if cyclestart < 1 then begin cyclestart := ColorList.count; dec(CycleStart,inccounter); end
               else dec(CycleStart,inccounter);
      end;
      for j := 0 to BM.original.height-1 do
      begin
      RowRGB  := BM.original.ScanLine[j];
      RowRGB24  := Bitmap24.ScanLine[j];
      for i := 0 to BM.original.width-1  do
      begin
       index := CycleStart + RowRGB[i].rgbtgreen ;
       if index > ColorList.Count-1 then index := index - ColorList.Count;
      if (index >= (ColorList.Count-1)) or (index < 0) then continue;
      RowRGB24[i] := pRGBTriple(ColorList.Items[index])^;
      end;
    end;
 end; // if else Dotrucolor

      case delay9 of
       0 : sleep(100);
       1 : sleep(80);
       2 : sleep(70);
       3 : sleep(60);
       4 : sleep(50);
       5 : sleep(40);
       6 : sleep(30);
       7 : sleep(20);
       8 : sleep(10);
       9 : ;
      end;
   Image1.Picture.Bitmap := Bitmap24;
if DoTrueColor then
begin
Label1.caption := 'Cycling '+ inttostr(index)+ ' Of '+
                   Inttostr(TrueColorColorList.count-1)+ ' Colors';
end
else  Label1.caption := 'Cycling '+ inttostr(index)+ ' Of ' +
                         Inttostr(ColorList.count-1)+ ' Colors';
Application.ProcessMessages;
  end; //while
end; {DoCycle}

procedure TColorCyclingForm.FormShow(Sender: TObject);
begin
Bitmap24 := TBitmap.Create;
Bitmap24.PixelFormat := pf24bit;
Bitmap24.Width  := Image1.ClientWidth;
Bitmap24.Height := Image1.ClientHeight;
Bitmap24.Assign(Image1.Picture.Bitmap);
CycleDirection:= true;
//full := false;
inccounter := 1;
index:= 0;
if DoTrueColor then
begin
Label1.caption := 'Cycling '+ inttostr(index)+ ' Of '+
Inttostr(TrueColorColorList.count-1)+ ' Colors';
end
else  Label1.caption := 'Cycling '+ inttostr(index)+ ' Of '+
 Inttostr(ColorList.count-1)+ ' Colors';
end;

procedure TColorCyclingForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
bitmap24.Free;
end;

procedure TColorCyclingForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    #27 : if CyclingNow then begin beep; exit; end
          else begin bitmap24.Free; close; end;
    #32 : if ActiveControl.Name = 'Panel2' then Button2.Click;
    '0' : delay9 := 0;
    '1' : delay9 := 1;
    '2' : delay9 := 2;
    '3' : delay9 := 3;
    '4' : delay9 := 4;
    '5' : delay9 := 5;
    '6' : delay9 := 6;
    '7' : delay9 := 7;
    '8' : delay9 := 8;
    '9' : delay9 := 9;
    '+' : CycleDirection := true;
    '-' : CycleDirection := false;
 'l','L': begin BM.LoadPalette.Click; DoTrueColor := false;
           Label1.caption := 'Cycling '+ inttostr(index)+ ' Of '+
           Inttostr(ColorList.count-1)+ ' Colors';
          end;
 'c','C': if CyclingNow then begin beep; exit; end
          else SpeedButton1.Click;
 'p','P': if CyclingNow then begin beep; exit; end
          else SpeedButton3.Click;
    '[' : if inccounter > 1 then dec(inccounter) else beep;
    ']' : inc(inccounter);

   end;

end;

procedure TColorCyclingForm.SpeedButton1Click(Sender: TObject);
begin
Clipboard.Assign(bitmap24);
end;

procedure TColorCyclingForm.SpeedButton2Click(Sender: TObject);
begin
BM.LoadPalette.Click;
end;

procedure TColorCyclingForm.Panel1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button = mbLeft then
   begin
    Moving:=True;
    Original_x:=X;
    Original_y:=Y;
   end;
end;

procedure TColorCyclingForm.Panel1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
if Moving then begin
  left:=left+(X-Original_x);
  top:=top+(Y-Original_Y);
end;
end;

procedure TColorCyclingForm.Panel1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Moving:=False;
end;

procedure TColorCyclingForm.SpeedButton3Click(Sender: TObject);
begin
Clipboard.Assign(bitmap24);
BM.Paste1.Enabled := true;
BM.BringToFront;
Application.ProcessMessages;
BM.Paste1.Click;
BM.SendToBack;
SetFocus;
Application.ProcessMessages;
end;

procedure TColorCyclingForm.SpeedButton4Click(Sender: TObject);
begin
if WindowState = wsMaximized then
begin
WindowState := wsNormal;
Image1.Stretch:= false;
SpeedButton4.Hint := 'Maximize Window ( Image Streched )'
end else begin
WindowState := wsMaximized;
Image1.Stretch:= true;
SpeedButton4.Hint := 'Normal Window';
 end;
end;

end.
