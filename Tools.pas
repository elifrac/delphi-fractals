//**************************************************************************************
// This File is Part of the EliFrac Project.
// Created 7-3-98    Author: Kyriakopoulos Elias.
//
//**************************************************************************************
unit Tools;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls,Registry, Menus, ImgList;

type
  TFracTools = class(TForm)
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    LineButton: TToolButton;
    RectangleButton: TToolButton;
    EllipseButton: TToolButton;
    RoundRectButton: TToolButton;
    FreeButton: TToolButton;
    TextButton: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    BrushButton: TToolButton;
    BrushPopUp: TPopupMenu;
    SolidBrush: TMenuItem;
    ClearBrush: TMenuItem;
    HorizontalBrush: TMenuItem;
    VerticalBrush: TMenuItem;
    Diagonal1Brush: TMenuItem;
    Diagonal2Brush: TMenuItem;
    CrossBrush: TMenuItem;
    DiagCrossBrush: TMenuItem;
    PenPopup: TPopupMenu;
    SolidPen: TMenuItem;
    DashPen: TMenuItem;
    DotPen: TMenuItem;
    DashDotPen: TMenuItem;
    DashDotDotPen: TMenuItem;
    ClearPen: TMenuItem;
    N1: TMenuItem;
    PENSIZE1: TMenuItem;
    one: TMenuItem;
    two: TMenuItem;
    three: TMenuItem;
    four: TMenuItem;
    five: TMenuItem;
    six: TMenuItem;
    seven: TMenuItem;
    eight: TMenuItem;
    nine: TMenuItem;
    ten: TMenuItem;
    eleven: TMenuItem;
    twelve: TMenuItem;
    PenColorMenu: TMenuItem;
    N2: TMenuItem;
    BRUSHCOLOR1: TMenuItem;
    FontPopup: TPopupMenu;
    SelectFont1: TMenuItem;
    ToolButton1: TToolButton;
    FillButton: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure LineButtonClick(Sender: TObject);
    procedure RectangleButtonClick(Sender: TObject);
    procedure EllipseButtonClick(Sender: TObject);
    procedure RoundRectButtonClick(Sender: TObject);

    procedure SetBrushStyle(Sender: TObject);
    procedure SetPenStyle(Sender: TObject);
    procedure PenSizeChange(Sender: TObject);
    procedure PenColorMenuClick(Sender: TObject);
    procedure BRUSHCOLOR1Click(Sender: TObject);
    procedure FreeButtonClick(Sender: TObject);
    procedure TextButtonClick(Sender: TObject);
    procedure SelectFont1Click(Sender: TObject);
    procedure FillButtonClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FracTools: TFracTools;

implementation

uses Globs,Main, EntTxt;

{$R *.DFM}

procedure TFracTools.FormCreate(Sender: TObject);
var
f: TRegIniFile;
begin
  f := TRegIniFile.Create(REGPLACE);
  Visible := f.ReadBool(TOOLBAR,'On',False);
  Left := f.ReadInteger(TOOLBAR,'Left',140);
  Top  := f.ReadInteger(TOOLBAR,'Top',0);
  Width := f.ReadInteger(TOOLBAR,'Width',290);
  Height := f.ReadInteger(TOOLBAR,'Height',50);
  f.free;
end;

procedure TFracTools.LineButtonClick(Sender: TObject);
begin
 DrawingTool := dtLine;
 LineButton.Down := True;
 RectangleButton.Down := False;
 EllipseButton.Down  := False;
 RoundRectButton.Down  := False;
 FreeButton.Down  := False;
 TextButton.Down  := False;
 ZoomBox := false;
end;

procedure TFracTools.RectangleButtonClick(Sender: TObject);
begin
 DrawingTool := dtRectangle;
 LineButton.Down := False;
 RectangleButton.Down := True;
 EllipseButton.Down  := False;
 RoundRectButton.Down  := False;
 FreeButton.Down  := False;
 TextButton.Down  := False;
 ZoomBox := false;
end;

procedure TFracTools.EllipseButtonClick(Sender: TObject);
begin
 DrawingTool := dtEllipse;
 LineButton.Down := False;
 RectangleButton.Down := False;
 EllipseButton.Down  := True;
 RoundRectButton.Down  := False;
 FreeButton.Down  := False;
 TextButton.Down  := False;
 ZoomBox := false;
end;

procedure TFracTools.RoundRectButtonClick(Sender: TObject);
begin
DrawingTool := dtRoundRect;
LineButton.Down := False;
 RectangleButton.Down := False;
 EllipseButton.Down  := False;
 RoundRectButton.Down  := True;
 FreeButton.Down  := False;
 TextButton.Down  := False;
 ZoomBox := false;
end;

procedure TFracTools.SetBrushStyle(Sender: TObject);
begin
  with BM.Canvas.Brush do
  begin
    if Sender = SolidBrush then Style := bsSolid
    else if Sender = ClearBrush then Style := bsClear
    else if Sender = HorizontalBrush then Style := bsHorizontal
    else if Sender = VerticalBrush then Style := bsVertical
    else if Sender = Diagonal1Brush then Style := bsFDiagonal
    else if Sender = Diagonal2Brush then Style := bsBDiagonal
    else if Sender = CrossBrush then Style := bsCross
    else if Sender = DiagCrossBrush then Style := bsDiagCross;
  end;
  (Sender as TMenuItem).Checked := True;
end;

procedure TFracTools.SetPenStyle(Sender: TObject);
begin
  with BM.Canvas.Pen do
  begin
    if Sender = SolidPen then Style := psSolid
    else if Sender = DashPen then Style := psDash
    else if Sender = DotPen then Style := psDot
    else if Sender = DashDotPen then Style := psDashDot
    else if Sender = DashDotDotPen then Style := psDashDotDot
    else if Sender = ClearPen then Style := psClear;
  end;
  (Sender as TMenuItem).Checked := True;
end;

procedure TFracTools.PenSizeChange(Sender: TObject);
begin
  with BM.Canvas.Pen do
   begin
   if Sender = one then Width := 1
   else if Sender = two then Width := 2
   else if Sender = three then Width := 3
   else if Sender = four then Width := 4
   else if Sender = five then Width := 5
   else if Sender = six then Width := 6
   else if Sender = seven then Width := 7
   else if Sender = eight then Width := 8
   else if Sender = nine then Width := 9
   else if Sender = ten then Width := 10
   else if Sender = eleven then Width := 11
   else if Sender = twelve then Width := 12;
  end;
  (Sender as TMenuItem).Checked := True;
end;

procedure TFracTools.PenColorMenuClick(Sender: TObject);
begin
BM.ColorDialog1.Color := BM.Canvas.Pen.Color;
 if BM.ColorDialog1.Execute then
    BM.Canvas.Pen.Color := BM.ColorDialog1.Color;
end;

procedure TFracTools.BRUSHCOLOR1Click(Sender: TObject);
begin
 BM.ColorDialog1.Color := BM.Canvas.Brush.Color;
 if BM.ColorDialog1.Execute then
    BM.Canvas.Brush.Color := BM.ColorDialog1.Color;
end;

procedure TFracTools.FreeButtonClick(Sender: TObject);
begin
DrawingTool := dtFree;
LineButton.Down := False;
 RectangleButton.Down := False;
 EllipseButton.Down  := False;
 RoundRectButton.Down  := False;
 FreeButton.Down  := True;
 TextButton.Down  := False;
 ZoomBox := false;
end;

procedure TFracTools.TextButtonClick(Sender: TObject);
begin
 DrawingTool := dtText;
 LineButton.Down := False;
 RectangleButton.Down := False;
 EllipseButton.Down  := False;
 RoundRectButton.Down  := False;
 FreeButton.Down  := False;
 TextButton.Down  := True;
 ZoomBox := false;
 EnterTxt.ShowModal;
 If EnterTxt.ModalResult = mrOK then
    begin
    CanvasText := EnterTxt.Edit1.Text;
    TxtSize := BM.Canvas.TextExtent(CanvasText);
    Txtbmp.Width := TxtSize.cx;
    Txtbmp.Height := TxtSize.cy;
   end;
end;

procedure TFracTools.SelectFont1Click(Sender: TObject);
begin
 BM.FontDialog1.Font := BM.Canvas.Font;
 if BM.FontDialog1.Execute then
    begin
     BM.Canvas.Font.Assign(BM.FontDialog1.Font);
     CanvasText := EnterTxt.Edit1.Text;
     TxtSize := BM.Canvas.TextExtent(CanvasText);
     Txtbmp.Width := TxtSize.cx;
     Txtbmp.Height := TxtSize.cy;
     Txtbmp.Canvas.Font.Assign(BM.FontDialog1.Font);
    end;
end;

procedure TFracTools.FillButtonClick(Sender: TObject);
begin
DrawingTool := dtFill;
 LineButton.Down := False;
 RectangleButton.Down := False;
 EllipseButton.Down  := False;
 RoundRectButton.Down  := False;
 FreeButton.Down  := False;
 TextButton.Down  := False;
 FillButton.Down := True;
 ZoomBox := false;
end;

procedure TFracTools.FormHide(Sender: TObject);
begin
DrawingTool := dtNone;
ZoomBox := True;
end;

procedure TFracTools.FormClose(Sender: TObject; var Action: TCloseAction);
begin
DrawingTool := dtNone;
ZoomBox := True;
end;

end.
