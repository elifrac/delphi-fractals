unit Browse;
//******************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-1998
//
// Modifications :
//  14-2-98 Added PopUp Menu and JPEG Options Dialog.
//  15-2-98 Added FIF File Support.
//          Changed The Form Class To TGradientForm. (It is Slower now.)
//  16-2-98 Added GIF File Support.
//          Added ScrollBox for the Images
//  16-2-98 Changed the form back to TForm.
//******************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, {fif,} ExtCtrls, ComCtrls, FileCtrl,Registry,
  Menus, Grids, Outline, DirOutln, OleCtrls;

type
  TBrowsFrm = class(TForm)
    Panel1: TPanel;
    FileListBox1: TFileListBox;
    PopupMenu1: TPopupMenu;
    Stretch1: TMenuItem;
    N1: TMenuItem;
    DeleteFile1: TMenuItem;
    CopyFile1: TMenuItem;
    RenameFile1: TMenuItem;
    MoveFile1: TMenuItem;
    N2: TMenuItem;
    Panel2: TPanel;
    Panel3: TPanel;
    DriveComboBox1: TDriveComboBox;
    N3: TMenuItem;
    JPEGOptions1: TMenuItem;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Colors1: TMenuItem;
    N8BitColor1: TMenuItem;
    N15BitColor1: TMenuItem;
    N24BitColor1: TMenuItem;
    N8BitGrayScale1: TMenuItem;
    DirectoryOutline1: TDirectoryOutline;
    procedure SetJPEGOptions(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ProgressUpdate(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Stretch1Click(Sender: TObject);
    procedure JPEGOptions1Click(Sender: TObject);
    procedure DeleteFile1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Colors1Click(Sender: TObject);
    procedure ChangeColorFormat(Sender: TObject);
    procedure DirectoryOutline1Change(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
    procedure FileChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  protected
    Filename: string;
    Zoom: Integer;
  public
  procedure UpdateProgressBar(Sender: TObject; Action: TProgressAction;
      PercentComplete: Longint);
  procedure FitToWindow;
  procedure Rescale;
  procedure UpdateCaption;
  procedure ConfirmChange(const ACaption, FromFile, ToFile: string);
    { Public declarations }
  end;

var
  BrowsFrm: TBrowsFrm;

implementation

uses Globs, Main, JpOpt, FmxUtils, FChngDlg;

{$R *.DFM}

procedure TBrowsFrm.SetJPEGOptions(Sender: TObject);
var
  Temp: Boolean;
begin
  Temp := Image1.Picture.Graphic is TJPEGImage;
  if Temp then
    with TJPEGImage(Image1.Picture.Graphic) do
    begin
      Image1.Autosize := True;
      PixelFormat := jpgPxlFrm;
      ProgressiveDisplay := PrDisplay;
      Performance := jpgPerf;
      Scale := jpgSize;
      Grayscale := GraySc;
      Smoothing := SmoothDisplay;
    end
//  else if Image1.Picture.Graphic is TFIFImage then
//      begin
//        Image1.Autosize := True;
//        TFIFImage(Image1.Picture.Graphic).OnLoading := UpdateProgressBar;
//        Filename := FileListBox1.Filename;
//        FitToWindow;
//        UpdateCaption;
//      end;
  // Cursor := crZoomCursor;
end;

procedure TBrowsFrm.FormCreate(Sender: TObject);
var
f : TRegIniFile;
S : String;
begin
f := TRegIniFile.Create(REGPLACE);
Left   :=  f.ReadInteger(BROWSEWIN,'Left',0);
Top    :=  f.ReadInteger(BROWSEWIN,'Top',0);
Height :=  f.ReadInteger(BROWSEWIN,'Height',Screen.Height);
Width  :=  f.ReadInteger(BROWSEWIN,'Width',Screen.Width);
 S := f.ReadString(BROWSEWIN,'Directory',GraphicsDirectory);
 if not Fileexists(S) then DirectoryOutline1.Directory := GraphicsDirectory
 else DirectoryOutline1.Directory := S;
f.free;
  FileListbox1.Mask := '*.jpg;*.bmp;*.rle;*.dib;*.fif;*.gif;*.wmf;*.emf;*.ico;*.png';
  Image1.OnProgress := ProgressUpdate;
  Image1.Stretch := Stretch1.Checked;
 // if not LoadFIFDecodeLibrary(FIFDecodeDLLName, False) then
  //  Application.MessageBox('Can''t find '+FIFDecodeDLLName+
  //    '.   You will not be able to view FIF images until the'+ #10#13+
  //    'Iterated Systems FIF decoder DLL is installed.  ',
  //    'FIF Not Installed', mb_OK);
end;

procedure TBrowsFrm.ProgressUpdate(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
begin
  if Stage = psRunning then
    Caption := Format('%d%%',[PercentDone])
  else
    Caption := 'Browse';
end;

procedure TBrowsFrm.FormClose(Sender: TObject; var Action: TCloseAction);
var
f: TRegIniFile;
begin
 f := TRegIniFile.Create(REGPLACE);
 f.WriteInteger(BROWSEWIN,'Left',Left);
 f.WriteInteger(BROWSEWIN,'Top',Top);
 f.WriteInteger(BROWSEWIN,'Height',Height);
 f.WriteInteger(BROWSEWIN,'Width',Width);
 f.WriteString(BROWSEWIN ,'Directory',DirectoryOutline1.Directory);
 f.free;

Action := caFree;
end;

procedure TBrowsFrm.Stretch1Click(Sender: TObject);
begin
Stretch1.Checked := not Stretch1.Checked;
Image1.Stretch := Stretch1.Checked;
end;

procedure TBrowsFrm.JPEGOptions1Click(Sender: TObject);
begin
Application.CreateForm(TJpegOptionsForm, JpegOptionsForm);
 JpegOptionsForm.ShowModal;
end;

procedure TBrowsFrm.DeleteFile1Click(Sender: TObject);
begin
   with FileListBox1 do
    if MessageDlg('Delete ' + FileName + '?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
      if HasAttr(FileName, faReadOnly) then  { if it's read-only... }
          raise EFCantDelete.Create(Format(SFCantDelete, [FileName]))
      else if DeleteFile(FileName) then Update;
end;

procedure TBrowsFrm.UpdateProgressBar(Sender: TObject; Action: TProgressAction;
      PercentComplete: Longint);
begin
  case Action of
    paStart   :   Screen.Cursor := crHourGlass;
    paRunning : Caption := Format('Decompressing: %d%% complete.', [PercentComplete]);
    paEnd     : begin
                 Screen.Cursor := crDefault;
                 Caption := 'Browse';
                end;
  end;
end;

procedure TBrowsFrm.FitToWindow;
begin
  Zoom := 0;
  Scrollbox1.Visible := False;
  try
    Rescale;
    if Image1.Width > Scrollbox1.Width then
    begin
      Zoom := -Trunc((Image1.Width / Scrollbox1.Width) + 0.5);
      Rescale;
    end;
    if Image1.Height > Scrollbox1.Height then
    begin
      Zoom := Zoom - Trunc((Image1.Height / ScrollBox1.Height) + 0.5);
      Rescale;
    end;
  finally
    Scrollbox1.Visible := True;
  end;
end;

procedure TBrowsFrm.Rescale;
var
  Multiplier: Double;
begin
  if Zoom > 0 then
    Multiplier := Zoom + 1
  else if Zoom < 0 then
    Multiplier := 1 / (Abs(Zoom) + 1)
  else
    Multiplier := 1;
  with Image1.Picture do
    if Graphic is TFIFImage then
    begin
      Image1.Autosize := True;
      Image1.Stretch := False;
      Graphic.Width := Trunc(TFIFImage(Graphic).OriginalWidth * Multiplier);
      Graphic.Height := Trunc(TFIFImage(Graphic).OriginalHeight * Multiplier);
    end
    else
    begin
      Image1.AutoSize := Zoom = 0;
      Image1.Stretch := Zoom <> 0;
      if Zoom <> 0 then
      begin
        Image1.Width := Trunc(Graphic.Width * Multiplier);
        Image1.Height := Trunc(Graphic.Height * Multiplier);
      end;
    end;
end;

procedure TBrowsFrm.UpdateCaption;
var
  ZoomTop, ZoomBottom: Integer;
begin
  if Length(Filename) = 0 then
    Caption := 'Browse'
  else
  begin
    ZoomTop := 1;
    ZoomBottom := 1;
    if Zoom < 0 then
      ZoomBottom := Abs(Zoom)+1
    else if Zoom > 0 then
      ZoomTop := Zoom+1;
    Caption := Format('Browse - %s (%d:%d)',[Filename, ZoomTop,ZoomBottom]);
  end;
end;

procedure TBrowsFrm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Image1.Picture.Graphic is TFIFImage then
begin
 case Button of
    mbLeft:   Inc(Zoom);
    mbRight:  Dec(Zoom);
  end;
  Rescale;
  UpdateCaption;
end;
end;

procedure TBrowsFrm.ChangeColorFormat(Sender: TObject);
begin
  (Image1.Picture.Graphic as TFIFImage).ColorFormat :=
    TColorFormat((Sender as TComponent).Tag);
end;

procedure TBrowsFrm.Colors1Click(Sender: TObject);
begin
 with Image1.Picture.Graphic as TFIFImage do
  case ColorFormat of
    RGB8 : begin
           N8bitcolor1.Checked := True;
           N15bitcolor1.Checked := False;
           N24bitcolor1.Checked := False;
           N8bitgrayscale1.Checked := False;
           end;
    RGB15: begin
           N8bitcolor1.Checked := False;
           N15bitcolor1.Checked := True;
           N24bitcolor1.Checked := False;
           N8bitgrayscale1.Checked := False;
           end;
    RGB24: begin
           N8bitcolor1.Checked := False;
           N15bitcolor1.Checked := False;
           N24bitcolor1.Checked := True;
           N8bitgrayscale1.Checked := False;
           end;

    GRAYSCALE8: begin
                N8bitcolor1.Checked := False;
                N15bitcolor1.Checked := False;
                N24bitcolor1.Checked := False;
                N8bitgrayscale1.Checked := True;
                end;
  end;
end;

procedure TBrowsFrm.DirectoryOutline1Change(Sender: TObject);
begin
 FileListBox1.Directory := DirectoryOutline1.Directory;
end;

procedure TBrowsFrm.DriveComboBox1Change(Sender: TObject);
begin
  DirectoryOutline1.Drive := DriveComboBox1.Drive;
  FileListBox1.Directory := DirectoryOutline1.Directory;
end;

procedure TBrowsFrm.ConfirmChange(const ACaption, FromFile, ToFile: string);
begin
  if MessageDlg(Format('%s %s to %s?', [ACaption, FromFile, ToFile]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if ACaption = 'Move' then
      MoveFile(FromFile, ToFile)
    else if ACaption = 'Copy' then
      CopyFile2(FromFile, ToFile)
    else if ACaption = 'Rename' then
      RenameFile(FromFile, ToFile);
    FileListBox1.Update;
  end;
end;

procedure TBrowsFrm.FileChange(Sender: TObject);
begin
  with ChangeDlg do
  begin
    if Sender = MoveFile1 then Caption := 'Move'
    else if Sender = CopyFile1 then Caption := 'Copy'
    else if Sender = RenameFile1 then Caption := 'Rename'
    else Exit;
    CurrentDir.Caption := DirectoryOutline1.Directory;
    FromFileName.Text := FileListBox1.FileName;
    ToFileName.Text := '';
    if (ShowModal <> mrCancel) and (ToFileName.Text <> '') then
      ConfirmChange(Caption, FromFileName.Text, ToFileName.Text);
  end;
end;

procedure TBrowsFrm.FormResize(Sender: TObject);
begin
 If Height < 533 then Height := 533;
 If Width  < 685 then Width  := 685;
end;

procedure TBrowsFrm.FileListBox1Click(Sender: TObject);
begin
 try
    Image1.Picture.LoadFromFile(FileListbox1.Filename);
   except
    on EInvalidGraphic do Image1.Picture.Graphic := nil;
   end;
  Colors1.Enabled := Image1.Picture.Graphic is TFIFImage;
  ScrollBox1.HorzScrollBar.Range := Image1.Picture.Graphic.Width;
  ScrollBox1.VertScrollBar.Range := Image1.Picture.Graphic.Height;
  SetJPEGOptions(self);
end;

procedure TBrowsFrm.FileListBox1DblClick(Sender: TObject);
begin
  s9 := FileListbox1.Filename;
  passes := 1;
  BM.Revert1.Enabled := True;
   ComingFromBrowse := True;
  BM.Revert1.Click;
end;

end.
