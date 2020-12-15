unit EdPal;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-1999
//  This File is a part of the EliFrac Project
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, System.UITypes, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Spin, ExtCtrls;

type
  palete = array[0..255] of LongInt;
  TEditPal = class(TForm)
    PalGrid: TDrawGrid;
    BitBtn1: TBitBtn;
    ColorDialog: TColorDialog;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    BitBtn2: TBitBtn;
    Red: TSpinEdit;
    Green: TSpinEdit;
    Blue: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PalRight: TSpeedButton;
    PalLeft: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    label14: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Label23: TLabel;
    Button6: TButton;
    Button7: TButton;
    procedure FormActivate(Sender: TObject);
    procedure PalGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PalGridDblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RGBChange(Sender: TObject);
    procedure PalGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RedClick(Sender: TObject);
    procedure PalRightClick(Sender: TObject);
    procedure PalLeftClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label20DblClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Label21Click(Sender: TObject);
    procedure Label22DblClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  EditPal: TEditPal;
  PalRect : TRect;
  Column,Row : Longint;
  PalIndex: Integer;
  Temppal : palete;    // A temp Palette.
  ChangeCellColor : Boolean;
  Startcolor,Midcolor,EndColor : array[0..2] of Byte;

procedure UpdateRGBSpins;
procedure set_palette(var start, finish : array of Byte);
procedure set_palette2(var start, finish : array of Byte);
procedure set_palette3(var start, middle, finish : array of Byte);
procedure UpdateColorList;

implementation
uses  Globs,Main;
{$R *.DFM}

procedure TEditPal.FormActivate(Sender: TObject);
begin
  PalGrid.Canvas.Brush.Style := bsSolid;
  ChangeCellColor := False;
  Label23.Caption := ExtractFileName(PaletteName);
end;

procedure TEditPal.PalGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
begin
  PalRect := PalGrid.CellRect(Col,Row);
  PalIndex := Col + Row + (Row * 15);
  PalGrid.Canvas.Brush.Color := Temppal[PalIndex];
  PalGrid.Canvas.FillRect(PalRect);
end;

procedure TEditPal.BitBtn1Click(Sender: TObject);
var
i: Integer;
begin
 for i :=0 to 255 do
   begin
     pal[i] := Temppal[i];
     dacbox[i][0] := getRValue(Temppal[i]);
     dacbox[i][1] := getGValue(Temppal[i]);
     dacbox[i][2] := getBValue(Temppal[i]);
   end;
UpdateColorList;
DoChangePalette := true;
Close;
end;

procedure TEditPal.Button1Click(Sender: TObject);
var
 I,Fin: TextFile;
 index : Integer;
 r1,dummy: String;
 r,g,b : Integer;
label getout;
begin
OpenDialog1.Title := s6;
OpenDialog1.FilterIndex := 1;
OpenDialog1.InitialDir := PaletteDirectory;
if OpenDialog1.Execute then
 begin
 FileExt := UpperCase(ExtractFileExt(OpenDialog1.Filename));
 if FileExt = FileX[fePAL] then
  begin
    PaletteName := OpenDialog1.Filename;
    AssignFile(I, OpenDialog1.Filename);
    Reset(I);
    Readln(I,r1);
    if r1 <> s8 then
    begin
     Application.MessageBox(NOPALETTE,'Error',MB_ICONERROR + MB_OK);
     goto getout;
    end;
      index:=0;
      while not Eof(I) do
       begin
        Readln(I,dummy);
        Temppal[index] := StrToInt(dummy);
        inc(index);
        if index > 255 then break;
       end;
     BM.StUpdate;
     Label23.Caption := ExtractFileName(PaletteName);
     PalGrid.Refresh;
     UpdateColorList;
 getout:
    CloseFile(I);
 end
 else if FileExt = FileX[feMAP] then
  begin
    PaletteName := OpenDialog1.Filename;
    AssignFile(Fin, OpenDialog1.Filename);
    Reset(Fin);
    index := 0;
     while not Eof(Fin) do
      begin
        Read(Fin, r, g, b);
        Readln(Fin);
        TempPal[index] := RGB(r,g,b);
        inc(index);
        if index > 255 then break;
      end;
    CloseFile(Fin);
    BM.StUpdate;
    Label23.Caption := ExtractFileName(PaletteName);
    PalGrid.Refresh;
    UpdateColorList;
  end
 else
  Application.MessageBox(NOPALETTE,'Error',MB_ICONERROR + MB_OK);
 end;
end;

procedure TEditPal.PalGridDblClick(Sender: TObject);
begin
PalRect := PalGrid.CellRect(Column,Row);
PalIndex := Column + Row + (Row * 15);
ColorDialog.Color := Temppal[PalIndex];
if ColorDialog.Execute then
  begin
  Temppal[PalIndex] := ColorDialog.Color;
  PalGrid.Canvas.Brush.Color := Temppal[PalIndex];
  PalGrid.Canvas.FillRect(PalRect);
  end;
end;

procedure TEditPal.Button2Click(Sender: TObject);
var
 I: Textfile;
 index : Integer;
begin
SaveDialog1.Title := s7;
SaveDialog1.FilterIndex := 1;
SaveDialog1.InitialDir := PaletteDirectory;

if SaveDialog1.Execute then
 begin
    AssignFile(I, SaveDialog1.Filename);
    Rewrite(I);
    Writeln(I,s8);
    for index:=0 to 255 do
      Writeln(I, IntToStr(Temppal[index]));
    CloseFile(I);
    PaletteName := SaveDialog1.Filename;
    BM.StUpdate;
    Label23.Caption := ExtractFileName(PaletteName);
 end;
end;

procedure TEditPal.Button3Click(Sender: TObject);
var
i,j : Integer;
begin
PalGrid.Canvas.Brush.Color := $ffffff; // White.
 PalIndex:=0;
 for j:= 0 to 15 do
   for i:= 0 to 15 do
     begin
     PalRect := PalGrid.CellRect(i,j);
     PalGrid.Canvas.FillRect(PalRect);
     Temppal[PalIndex] := $ffffff;
     inc(PalIndex);
     end;
end;

procedure TEditPal.Button4Click(Sender: TObject);
var
i,j : Integer;
begin
PalGrid.Canvas.Brush.Color := 0;
PalIndex:=0;
 for j:= 0 to 15 do
   for i:= 0 to 15 do
     begin
     PalRect := PalGrid.CellRect(i,j);
     PalGrid.Canvas.FillRect(PalRect);
     Temppal[PalIndex] := 0;
     inc(PalIndex);
     end;
end;

procedure TEditPal.Button5Click(Sender: TObject);
var
i,j : Integer;
begin
ColorDialog.Color := PalGrid.Canvas.Brush.Color;
 if ColorDialog.Execute then
    PalGrid.Canvas.Brush.Color := ColorDialog.Color;
 PalIndex:=0;
 for j:= 0 to 15 do
   for i:= 0 to 15 do
     begin
     PalRect := PalGrid.CellRect(i,j);
     PalGrid.Canvas.FillRect(PalRect);
     Temppal[PalIndex] := ColorDialog.Color;
     inc(PalIndex);
     end;
end;

procedure TEditPal.FormCreate(Sender: TObject);
var
i: Integer;
begin
Column := 0;
Row    := 0;
PalIndex := 0;

Label20.Color :=  PalStartColor;
Label21.Color :=  PalMidColor;
Label22.Color :=  PalEndColor;

StartColor[0] := GetRValue(Label20.Color);
StartColor[1] := GetGValue(Label20.Color);
StartColor[2] := GetBValue(Label20.Color);
MidColor[0] := GetRValue(Label21.Color);
MidColor[1] := GetGValue(Label21.Color);
MidColor[2] := GetBValue(Label21.Color);
EndColor[0] := GetRValue(Label22.Color);
EndColor[1] := GetGValue(Label22.Color);
EndColor[2] := GetBValue(Label22.Color);

ChangeCellColor:= False;
  for i:= 0 to 255 do
    Temppal[i] := pal[i];
end;

procedure TEditPal.RGBChange(Sender: TObject);
begin
if ChangeCellColor = False then  Exit;

PalIndex := Column + Row + (Row * 15);
Temppal[PalIndex]:= RGB(Red.Value,Green.Value,Blue.Value);
PalGrid.Canvas.Brush.Color := Temppal[PalIndex];
PalGrid.Canvas.FillRect(PalRect);
end;

procedure TEditPal.PalGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
If Button = mbLeft then
begin
 PalGrid.MouseToCell(X, Y, Column, Row);
 PalRect := PalGrid.CellRect(Column,Row);
 PalIndex := Column + Row + (Row * 15);
 ChangeCellColor := False;
 UpdateRGBSpins;
end;
end;

procedure UpdateRGBSpins;
begin
 With EditPal do
 begin
 Red.Value  := GetRValue(Temppal[PalIndex]);
 Red.Refresh;
 Green.Value := GetGValue(Temppal[PalIndex]);
 Green.Refresh;
 Blue.Value := GetBValue(Temppal[PalIndex]);
 Blue.Refresh;
 end;
end;

procedure TEditPal.RedClick(Sender: TObject);
begin
ChangeCellColor := True;
end;

procedure TEditPal.PalRightClick(Sender: TObject);
var
i : Integer;
begin
i := 0;
while i < 256 do
  begin
    if ((i+1) > 255) then
       TempPal[i] := TempPal[(i+1) mod 256]
   else  TempPal[i] := TempPal[i+1];
   inc(i);
  end;
UpdateColorList;
PalGrid.Invalidate;
end;

procedure TEditPal.PalLeftClick(Sender: TObject);
var
i : Integer;
begin
 i := 255;
while i > -1 do
  begin
    if ((i-1) < 0) then
       TempPal[i] := TempPal[255]
   else  TempPal[i] := TempPal[i-1];
   dec(i);
  end;
UpdateColorList;
PalGrid.Invalidate;
end;

procedure UpdateColorList;
var i: integer;
begin
ColorList.clear;
for i:=0 to 255 do begin
 NEW(Node);
 WITH Node^ DO
   BEGIN
    rgbtRed   := GetRValue(temppal[i]);
    rgbtGreen := GetGValue(temppal[i]);
    rgbtBlue  := GetBValue(temppal[i]);
   END;
ColorList.Add(Node);
end;
end;

procedure TEditPal.SpeedButton1Click(Sender: TObject);
var
col,row,i: Integer;
saverow : Array[0..15] of Integer;
begin
i:=0;
 for row := 0 to 14 do
   for col := 0 to 15 do
    begin
     PalIndex := col + row + (row * 15);
      if row = 0 then
        begin
          saverow[i] := TempPal[PalIndex];
          inc(i);
        end;
      TempPal[PalIndex] := TempPal[PalIndex+16];
    end;
  for i := 0 to 15 do
       TempPal[i+240] := saverow[i];
 UpdateColorList;
 PalGrid.Invalidate;
end;

procedure TEditPal.SpeedButton2Click(Sender: TObject);
var
col,row,i: Integer;
saverow : Array[0..15] of Integer;
begin
i:=15;
 for row := 15 downto 0 do
   for col := 15 downto 0 do
    begin
      PalIndex := col + row + (row * 15);
      if row = 15 then
        begin
          saverow[i] := TempPal[PalIndex];
          dec(i);
        end;
      TempPal[PalIndex] := TempPal[abs(PalIndex-16)];
    end;
 for i := 0 to 15 do
     TempPal[i] := saverow[i];
UpdateColorList;
 PalGrid.Invalidate;
end;

procedure TEditPal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
PalStartColor := Label20.Color;
PalMidColor   := Label21.Color;
PalEndColor   := Label22.Color;
end;

procedure set_palette(var start, finish : array of Byte);
var i,j : Integer;
begin
   dacbox[0][0] := 0; dacbox[0][1] := 0; dacbox[0][2] := 0;
   for i:=1 to 255 do			// fill the palette
      for j := 0 to 2 do
	 dacbox[i][j] := Byte ((i*start[j] + (256-i)*finish[j]) div 255);
   for i:= 0 to 255 do
     TempPal[i] := RGB(dacbox[i][0],dacbox[i][1],dacbox[i][2]);
UpdateColorList;
end;

procedure set_palette2(var start, finish : array of Byte);
var  i, j : Integer;
 begin
   dacbox[0][0] := 0; dacbox[0][1] := 0; dacbox[0][2] := 0;
   for i:=1 to 128 do
      for j := 0 to 2 do
        begin
	 dacbox[i][j]	  := Byte ((i*finish[j] + (128-i)*start[j] ) div 128);
	 dacbox[i+127][j] := Byte ((i*start[j]  + (128-i)*finish[j]) div 128);
        end;
  for i:= 0 to 255 do
     TempPal[i] := RGB(dacbox[i][0],dacbox[i][1],dacbox[i][2]);
UpdateColorList;
end;

procedure set_palette3(var start, middle, finish : array of Byte);
var i, j : Integer;
  begin
   dacbox[0][0] := 0; dacbox[0][1] := 0; dacbox[0][2] := 0;
   for i:= 1 to 85 do
      for j := 0 to 2 do
        begin
	 dacbox[i][j]	  := Byte ((i*middle[j] + (86-i)* start[j]) div 86);
	 dacbox[i+85][j]  := Byte ((i*finish[j] + (86-i)* middle[j]) div 86);
	 dacbox[i+170][j] := Byte  ((i*start[j]  + (86-i)* finish[j]) div 86);
        end;
  for i:= 0 to 255 do
     TempPal[i] := RGB(dacbox[i][0],dacbox[i][1],dacbox[i][2]);
UpdateColorList;
end;


procedure TEditPal.Label20DblClick(Sender: TObject);
begin
  ColorDialog.Color := Label20.Color;
  if ColorDialog.Execute then
    begin
   Label20.Color := ColorDialog.Color;
   StartColor[0] := GetRValue(Label20.Color);
   StartColor[1] := GetGValue(Label20.Color);
   StartColor[2] := GetBValue(Label20.Color);
    end;
end;

procedure TEditPal.BitBtn3Click(Sender: TObject);
begin
 set_palette(StartColor,EndColor);
 PalGrid.Refresh;
end;

procedure TEditPal.Label21Click(Sender: TObject);
begin
ColorDialog.Color := Label21.Color;
if ColorDialog.Execute then
   begin
   Label21.Color := ColorDialog.Color;
   MidColor[0] := GetRValue(Label21.Color);
   MidColor[1] := GetGValue(Label21.Color);
   MidColor[2] := GetBValue(Label21.Color);
   end;
end;

procedure TEditPal.Label22DblClick(Sender: TObject);
begin
ColorDialog.Color := Label22.Color;
if ColorDialog.Execute then
   begin
    Label22.Color := ColorDialog.Color;
    EndColor[0] := GetRValue(Label22.Color);
    EndColor[1] := GetGValue(Label22.Color);
    EndColor[2] := GetBValue(Label22.Color);
   end;
end;

procedure TEditPal.BitBtn4Click(Sender: TObject);
begin
 set_palette2(StartColor,EndColor);
 PalGrid.Refresh;
end;

procedure TEditPal.BitBtn5Click(Sender: TObject);
begin
 set_palette3(StartColor,MidColor,EndColor);
 PalGrid.Refresh;
end;

procedure TEditPal.BitBtn2Click(Sender: TObject);
var i : integer;
begin
ColorList.clear;
for i:=0 to 255 do begin
 NEW(Node);
 WITH Node^ DO
   BEGIN
    rgbtRed   := GetRValue(pal[i]);
    rgbtGreen := GetGValue(pal[i]);
    rgbtBlue  := GetBValue(pal[i]);
   END;
ColorList.Add(Node);
end;
DoChangePalette := false;
end;

procedure TEditPal.Button6Click(Sender: TObject);
begin
 BM.BringToFront;
 Application.ProcessMessages;
 CopyUndoBmp;
 ApplyNewPalette;
 BringToFront;
 SetFocus;
end;

procedure TEditPal.Button7Click(Sender: TObject);
begin
BM.Undo1.Click;
end;

end.
