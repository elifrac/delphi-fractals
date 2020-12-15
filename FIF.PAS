{*******************************************************}
{                                                       }
{       Delphi Supplemental Components                  }
{       Fractal Image File (FIF) graphics class         }
{       Copyright (c) 1997 Borland International        }
{                                                       }
{       Requires DECO_32.DLL by Iterated Systems        }
{                                                       }
{*******************************************************}

unit fif;

{
Notes:
  This unit supports decoding and display of images
  compressed in Iterated Systems' FIF format,
  in all FIF color depths: 8 bits per pixel (bpp) color,
  15 bpp color, and 24 bpp color.

  For best results, FIF images should be viewed using
  a 24 bpp video driver.

  The TFIFImage class provides a read-only view of the
  compressed file.  You can save the original FIF
  compressed file to a stream, but you cannot modify the
  bitmap image or recompress the image.  To create new
  FIF files, use Iterated Systems' Fractal Imager
  application, or contact Iterated Systems for licensing
  information for the the FIF compression toolkit.

  TFIFImage does not support FTT files (required by
  some old-format FIF images) nor progressive decompression.

*******************************************************}

interface

uses Windows, Messages, FifDLLs, Classes, Controls, Graphics;

type
  TFIFData = class(TSharedImage)
  private
    FData: TCustomMemoryStream;
    FOriginal: TFIFOriginalImageInfo;
    FAttributesLoaded: Boolean;
  protected
    procedure AttributesNeeded;
    procedure FreeHandle; override;
  public
    destructor Destroy; override;
  end;

  TColorFormat = (RGB8, RGB15, RGB24, GRAYSCALE8);
  TProgressAction = (paStart, paRunning, paEnd);
  TProgressEvent = procedure (Sender: TObject; Action: TProgressAction;
    PercentComplete: Longint) of object;

  TFIFImage = class(TGraphic)
  private
    FImage: TFIFData;    // original compressed image data
    FBitmap: TBitmap;    // decompressed image
    FWidth: Integer;     // desired pixel width of decompressed image
    FHeight: Integer;    // desired pixel height of decompressed image
    FOnLoading: TProgressEvent;
    FSession: TFIFDecodeSession;
    FFastestSize: Boolean; // round size down to size that decompresses fastest
    FColorFormat: TColorFormat;
    function GetBitmap: TBitmap;
    function GetOriginalHeight: Longint;
    function GetOriginalWidth: Longint;
    procedure SetFastestSize(Value: Boolean);
    procedure SetColorFormat(Value: TColorFormat);
  protected
    procedure Changed(Sender: TObject); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    procedure  FIFCallback(Session: TFIFDecodeSession;
      Action: TProgressAction; PercentComplete: Longint); virtual;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetPalette: HPalette; override;
    function GetWidth: Integer; override;
    procedure NewBitmap;
    procedure NewImage;
    procedure ReadData(Stream: TStream); override;
    procedure ReadStream(Size: Longint; Stream: TStream);
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;
    procedure WriteData(Stream: TStream); override;
   // property Bitmap: TBitmap read GetBitmap; // volatile
  public
    constructor Create; override;
    destructor Destroy; override;
    //***************************************************
    property Bitmap: TBitmap read GetBitmap;  // Elias 21-2-98. Made it Public
                                              // so I could use it in my main Program.    
    //***************************************************
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
    property ColorFormat: TColorFormat read FColorFormat write SetColorFormat;
    property FastestSize: Boolean read FFastestSize write SetFastestSize;
    property OriginalWidth: Longint read GetOriginalWidth;
    property OriginalHeight: Longint read GetOriginalHeight;
    property OnLoading: TProgressEvent read FOnLoading write FOnLoading;
  end;

implementation

uses Forms;

procedure TFIFData.AttributesNeeded;
begin
  if FAttributesLoaded or (FData = nil) then Exit;
  with TFIFDecodeSession.Create do
  try
    SetFIFBuffer(FData.Memory, FData.Size);
    try
      FOriginal := OriginalImage;
    finally
      ClearFIFBuffer;
    end;
  finally
    Free;
  end;
  FAttributesLoaded := True;
end;

destructor TFIFData.Destroy;
begin
  FData.Free;
  inherited Destroy;
end;

procedure TFIFData.FreeHandle;
begin
end;

constructor TFIFImage.Create;
var
  DC: HDC;
begin
  inherited Create;
  FImage := TFIFData.Create;
  FImage.Reference;
  DC := GetDC(0);
  // FColorFormat defaults to RGB8
  if (GetDeviceCaps(DC, RASTERCAPS) and RC_PALETTE) = 0 then
    if (GetDeviceCaps(DC, BITSPIXEL) * GetDeviceCaps(DC, PLANES)) < 24 then
      FColorFormat := RGB15
    else
      FColorFormat := RGB24;
  ReleaseDC(0,DC);
end;

destructor TFIFImage.Destroy;
begin
  FImage.Release;
  FBitmap.Free;
  inherited Destroy;
end;

procedure TFIFImage.Assign(Source: TPersistent);
begin
  if (Source = nil) or (Source is TFIFImage) then
  begin
    if Source <> nil then
    begin
      FImage.Release;
      FImage := TFIFImage(Source).FImage;
      FImage.Reference;
      FWidth := TFIFImage(Source).FWidth;
      FHeight := TFIFImage(Source).FHeight;
      FFastestSize := TFIFImage(Source).FFastestSize;
      FBitmap.Free;
      FBitmap := nil;
      if TFIFImage(Source).FBitmap <> nil then
      begin
        FBitmap := TBitmap.Create;
        FBitmap.Assign(TFIFImage(Source).FBitmap);
      end;
    end
    else
      NewImage;
    inherited Changed(Self);
  end
  else if Source is TGraphic then
    raise EInvalidGraphicOperation.Create('Cannot assign to TFIFImage')
  else
    inherited Assign(Source);
end;

procedure TFIFImage.Changed(Sender: TObject);
begin
  FBitmap.Free;
  FBitmap := nil;
  inherited Changed(Sender);
end;

procedure TFIFImage.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  ACanvas.StretchDraw(Rect, Bitmap);
end;

threadvar
  Instance: TFIFImage;  // used by callback routine to prod current instance.

function _FIFCallback(handle, PercentComplete: Longint): Longint; cdecl;
begin
  Result := 0;
  if Instance = nil then Exit;
  Instance.FIFCallback(Instance.FSession, paRunning, PercentComplete);
end;

procedure TFIFImage.FIFCallback(Session: TFIFDecodeSession;
  Action: TProgressAction; PercentComplete: Longint);
begin
  if Assigned(FOnLoading) then
  begin
    FOnLoading(Self, Action, PercentComplete);
    GDIFlush;   // flush any GDI ops before touching DIB memory again
  end;
end;

type
  TMaxLogPalette = packed record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: array[Byte] of TPaletteEntry;
  end;

function TFIFImage.GetBitmap: TBitmap;
type
  TParams = record
    A, B, C: Integer;
    Bpp: TPixelFormat;
  end;

const
  ColorParams: array [TColorFormat] of TParams =
    ((A:COLORMAP8; B:NOT_USED; C:NOT_USED; Bpp: pf8bit),  //RGB8
     (A:RED5; B:GREEN5; C:BLUE5; Bpp: pf15bit),           //RGB15
     (A:BLUE8; B:GREEN8; C:RED8; Bpp: pf24bit),           //RGB24
     (A:GRAY8; B:NOT_USED; C:NOT_USED; Bpp: pf8bit));     //GRAYSCALE8

var
  W, H: Longint;
  I: Integer;
  RowStride: Longint;
  CallbackStarted: Boolean;
  RowOrder: Integer;
  DIB: TDIBSection;
  Pal: TMaxLogPalette;
begin
  Result := FBitmap;
  if FBitmap <> nil then Exit;

  FBitmap := TBitmap.Create;
  Result := FBitmap;
  FBitmap.PixelFormat := ColorParams[ColorFormat].Bpp;

  if FImage.FData <> nil then
  begin
    FSession := TFIFDecodeSession.Create;
    with FImage, FSession do
    try
      CallbackStarted := False;
      Instance := Self;
      if Assigned(FOnLoading) then
      begin
        SetDecompressCallback(@_FIFCallback, CALLBACK_FREQ_LOW);
        FIFCallback(FSession, paStart, 0);
        CallbackStarted := True;
      end;

      try
        SetFIFBuffer(FData.Memory, FData.Size);

        W := FWidth;
        H := FHeight;
        if (W or H) = 0 then
        begin
          AttributesNeeded;
          W := FOriginal.Width;
          H := FOriginal.Height;
        end;
        if (W or H) = 0 then
        begin
          W := 100;
          H := 100;
        end;
        if FFastestSize then
        begin
          SetOutputResolution(W, H);
          GetFastResolution(W, H);
        end;
        SetOutputResolution(W, H);

        FBitmap.Width := W;
        FBitmap.Height := H;

        RowStride := Integer(FBitmap.ScanLine[1]) - Integer(FBitmap.Scanline[0]);
        if RowStride > 0 then
          RowOrder := TOP_LEFT
        else
        begin
          RowOrder := BOTTOM_LEFT;
          RowStride := -RowStride;
        end;

        with ColorParams[ColorFormat] do
          SetOutputFormat(A, B, C, NOT_USED, RowOrder);

        if ColorFormat = RGB8 then
        begin
          SetColorTableFormat(RED8, GREEN8, BLUE8, BLANK8);  //TPaletteEntry format
            // palPalEntry here is just a scratch pad; real colors come later
          if (Pal.palNumEntries = 0) or (Pal.palNumEntries > 256) then
          begin
            Pal.palNumEntries := 256;
            FillChar(Pal.palPalEntry, 256, CM_DYNAMIC);
            SetOutputColorTable(nil, @Pal.palPalEntry, 256);
          end
          else
          begin
            GetFIFColorTable(@Pal.palPalEntry);
            SetOutputColorTable(@Pal.palPalEntry, nil, Pal.palNumEntries);
          end;
        end;

        GetObject(FBitmap.Handle, SizeOf(DIB), @DIB);
        DecompressToBuffer(DIB.dsbm.bmBits, 0,0,0,0, RowStride);

        if ColorFormat in [RGB8,GRAYSCALE8] then
        begin
          Pal.palVersion := $300;
          Pal.palNumEntries := 256;
          if ColorFormat = RGB8 then
            GetOutputColorTable(@Pal.palPalEntry)
          else
            for I := 0 to 255 do          // Build grayscale color palette
              with Pal.palPalEntry[I] do
              begin
                peRed := I;
                peGreen := I;
                peBlue := I;
                peFlags := 0;
              end;
          FBitmap.Palette := CreatePalette(PLogPalette(@Pal)^);
          PaletteModified := True;
        end;
      finally
        if CallbackStarted then FIFCallback(FSession, paEnd, 100);
      end;
    finally
      FSession.ClearFIFBuffer;
      FSession.Free;
      FSession := nil;
      Instance := nil;
    end;
  end
  else
  begin
    FBitmap.Width := FWidth;
    FBitmap.Height := FHeight;
  end;
  inherited Changed(Self);
end;

function TFIFImage.GetEmpty: Boolean;
begin
  Result := FImage.FData = nil;
end;

function TFIFImage.GetHeight: Integer;
begin
  if Assigned(FBitmap) then
    Result := FBitmap.Height
  else
    Result := FHeight;
end;

function TFIFImage.GetOriginalWidth: Longint;
begin
  Result := 0;
  with FImage do
  begin
    if FData = nil then Exit;
    AttributesNeeded;
    Result := FOriginal.Width;
  end;
end;

function TFIFImage.GetOriginalHeight: Longint;
begin
  Result := 0;
  with FImage do
  begin
    if FData = nil then Exit;
    AttributesNeeded;
    Result := FOriginal.Height;
  end;
end;

function TFIFImage.GetPalette: HPalette;
begin
  if Assigned(FBitmap) then
    Result := FBitmap.Palette
  else
    Result := 0;
end;

function TFIFImage.GetWidth: Integer;
begin
  if Assigned(FBitmap) then
    Result := FBitmap.Width
  else
    Result := FWidth;
end;

procedure TFIFImage.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
begin
  //!!
end;

procedure TFIFImage.LoadFromStream(Stream: TStream);
begin
  ReadStream(Stream.Size - Stream.Position, Stream);
end;

procedure TFIFImage.NewBitmap;
begin
  FBitmap.Free;
  FBitmap := TBitmap.Create;
end;

procedure TFIFImage.NewImage;
begin
  FImage.Release;
  FImage := TFIFData.Create;
  FImage.Reference;
  FBitmap.Free;
  FBitmap := nil;
end;

procedure TFIFImage.ReadData(Stream: TStream);
var
  Size: Longint;
begin
  Stream.Read(Size, SizeOf(Size));
  ReadStream(Size, Stream);
end;

procedure TFIFImage.ReadStream(Size: Longint; Stream: TStream);
begin
  NewImage;
  with FImage do
  begin
    FData := TMemoryStream.Create;
    TMemoryStream(FData).SetSize(Size);
    Stream.ReadBuffer(FData.Memory^, Size);
  end;
  Changed(Self);
end;

procedure TFIFImage.SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPALETTE);
begin
  Bitmap.SaveToClipboardFormat(AFormat, AData, APalette);
end;

procedure TFIFImage.SaveToStream(Stream: TStream);
begin
  if FImage.FData = nil then
    raise EInvalidGraphicOperation.Create('No FIF data to write');
  with FImage.FData do
    Stream.Write(Memory^, Size);
end;

procedure TFIFImage.SetFastestSize(Value: Boolean);
begin
  if Value <> FFastestSize then
  begin
    FFastestSize := Value;
    NewBitmap;
    Changed(Self);
  end;
end;

procedure TFIFImage.SetColorFormat(Value: TColorFormat);
begin
  if Value <> FColorFormat then
  begin
    FColorFormat := Value;
    Changed(Self);    // Force bitmap to be recreated in new color format
  end;
end;

procedure TFIFImage.SetHeight(Value: Integer);
begin
  if Value <> FHeight then
  begin
    FHeight := Value;
    Changed(Self);
  end;
end;

procedure TFIFImage.SetWidth(Value: Integer);
begin
  if Value <> FWidth then
  begin
    FWidth := Value;
    Changed(Self);
  end;
end;

procedure TFIFImage.WriteData(Stream: TStream);
var
  Size: Longint;
begin
  Size := 0;
  if Assigned(FImage.FData) then Size := FImage.FData.Size;
  Stream.Write(Size, Sizeof(Size));
  if Size > 0 then Stream.Write(FImage.FData.Memory^, Size);
end;

initialization
  if LoadFIFDecodeLibrary(FIFDecodeDLLName, False) then
    TPicture.RegisterFileFormat('fif', 'Fractal Image File', TFIFImage);
finalization
  TPicture.UnregisterGraphicClass(TFIFImage);
end.
