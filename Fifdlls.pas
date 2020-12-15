{*******************************************************}
{                                                       }
{       Delphi Supplemental Components                  }
{       Fractal Image File (FIF) DLL binding            }
{       Copyright (c) 1997 Borland International        }
{                                                       }
{       Requires DECO_32.DLL by Iterated Systems        }
{                                                       }
{*******************************************************}

unit fifdlls;

interface

uses Windows, SysUtils;

type
  TISI_Callback = function (handle, PercentComplete: Longint): Longint; cdecl;

  (*
   *   Pixel Order Constants, used in SetOutputFormat
   *)

const
  RED8           =    1;
  GREEN8         =    2;
  BLUE8          =    3;
  NOT_USED       =    4;
  BLANK8         =    5;
  COLORMAP8      =   10;
  RED5           =   20;
  GREEN5         =   21;
  BLUE5          =   22;
  GRAY8          =  100;

  (*
   *   Row Order Constants, used in SetOutputFormat
   *)

const
  TOP_LEFT       =  0;
  BOTTOM_LEFT    =  1;

  (*
   *    Physical Unit Constants, used in GetPhysicalDimensions
   *)

const
  METER_UNITS      =      $6D;                 (* 'm' *)
  INCH_UNITS       =      $22;                 (* '"' *)
  UNKNOWN_UNITS    =      $75;                 (* 'u' *)

  (*
   *   Callback Constants, used in SetDecompressCallback
   *)

const
  CALLBACK_FREQ_NONE  = 0;
  CALLBACK_FREQ_LOW   = 1;
  CALLBACK_FREQ_HIGH  = 2;

  (*
   *   Colormap entryinfo, used in SetOutputColorTable
   *)

const
  CM_NOT_USED        =  0;
  CM_STATIC          =  1;
  CM_DYNAMIC         =  2;

  (*
   *   FIF version number information
   *)

const
  VERSION_PRIMARY     = 6;
  VERSION_SECONDARY   = 0;

  (*
   *   Progressive FIF buffer location (see SetProgressiveFIFBuffer)
   *)

const
  FIF_BEGIN          =  0;
  FIF_HEADER         =  1;
  FIF_DATA           =  2;
  FIF_COMPLETE       =  3;

  (*
   *   Progressive FIF steps (see SetProgressiveStep)
   *)

const
  DECO_STEP_LAST     = -1;
  DECO_STEP_FIRST    = -2;
  DECO_STEP_ALL      = -3;
  DECO_STEP_BEST     = -4;

  (*
   *   Progressive decompression frequency (see ProgressiveDecompress)
   *)

const
  FREQUENCY_HIGH      =  0;
  FREQUENCY_MEDIUM    =  1;
  FREQUENCY_LOW       =  2;
  FREQUENCY_NONE      =  3;


type
  TFIFOriginalImageInfo = record
    Width, Height, ColorDepth: Longint;
  end;

  TFIFDecodeSession = class
  private
    FHandle: Longint;
    function GetFIFFTTFileName: string;
    function GetFIFNumColors: Longint;
    function GetFIFNumSteps: Longint;
    function GetHandle: Longint;
    function GetOriginalImageInfo: TFIFOriginalImageInfo;
    function GetOutputDither: Boolean;
    function GetOutputFilter: Boolean;
    procedure SetOutputDither(Value: Boolean);
    procedure SetOutputFilter(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearFIFBuffer;
    procedure ClearFTTBuffer;
    procedure CloseDecompressor;
    procedure DecompressToBuffer( ImageBuffer: Pointer;
      CropPixelX, CropPixelY, CropPixelWidth, CropPixelHeight: Longint;
      BytesPerRow: Longint );
    procedure EndProgressiveDecompression;
    procedure GetColorTableFormat( var ColorPlane0, ColorPlane1,
      ColorPlane2, ColorPlane3: Longint);
    class function GetDecoVersion( var MajorVer, MinorVer: Longint): Boolean;
    procedure GetFastResolution( var PixelWidth, PixelHeight: Longint );
    function GetFIFColorTable( ColorTable: Pointer ): Boolean;
    procedure GetOutputColorTable( ColorTable: Pointer );
    procedure GetOutputFormat( var ColorPlane0, ColorPlane1, ColorPlane2,
      ColorPlane3, RowOrder: Longint );
    procedure GetOutputResolution( var PixelWidth, PixelHeight: Longint );
    procedure GetPhysicalDimensions( var PhysicalWidth, PhysicalHeight: Longint;
      var PhysicalUnits: Byte; var PhysicalUnitScaleFactor: Longint );
    procedure ProgressiveDecompress( Frequency: Longint;
      var OutputBufferX, OutputBufferY, OutputBufferWidth, OutputBufferHeight,
          BytesNeeded, PercentDone: Longint );
    procedure SetColorTableFormat( ColorPlane0, ColorPlane1, ColorPlane2,
      ColorPlane3: Longint );
    procedure SetDecompressCallback( CallbackFunc: TISI_Callback;
      CallbackFreq: Longint );
    procedure SetFIFBuffer( Buffer: Pointer; Size: Longint );
    procedure SetFTTBuffer( Buffer: Pointer; Size: Longint );
    procedure SetOutputColorTable( ColorTable: Pointer; EntryInfo: Pointer;
      NumColors: Longint );
    procedure SetOutputFormat( ColorPlane0, ColorPlane1, ColorPlane2,
      ColorPlane3, RowOrder: Longint );
    procedure SetOutputResolution( PixelWidth, PixelHeight: Longint );
    procedure SetProgressiveFIFBuffer( Buffer: Pointer;
      Size: Longint; var InputStatus, HeaderLength: Longint );
    procedure SetProgressiveStep( StepNumber: Longint );
    procedure StartProgressiveDecompression( ImageBuffer: Pointer;
      CropPixelX, CropPixelY, CropPixelWidth, CropPixelHeight,
      BytesPerRow, Expand: Longint );
    class function TestIfFIF( Buffer: Pointer; Length: Longint): Boolean;
    property Dither: Boolean read GetOutputDither write SetOutputDither;
    property Filter: Boolean read GetOutputFilter write SetOutputFilter;
    property FTTFileName: String read GetFIFFTTFilename;
    property Handle: Longint read GetHandle;
    property NumColors: Longint read GetFIFNumColors;
    property OriginalImage: TFIFOriginalImageInfo read GetOriginalImageInfo;
    property Steps: Longint read GetFIFNumSteps;
  end;

  EFIFError = class(Exception);

const
  FIFDecodeDLLName = 'deco_32.dll';

function LoadFIFDecodeLibrary(FilePath: string; RaiseExceptions: Boolean): Boolean;
procedure UnloadFIFDecodeLibrary;
procedure FIFCheck(Result: Longint);

{ Error codes }
const
  ISI_OK          = 0 ;  // Operation successful.
  ISI_CANCEL      = -2;  // User canceled operation.


// Memory Error Codes:
  ISI_GLOBAL_ALLOC_ERROR = -20;   // Could not allocate global memory.
  ISI_GLOBAL_FREE_ERROR  = -21;   // Could not free global memory.
  ISI_LOCAL_ALLOC_ERROR  = -30;   // Could not allocate local memory.
  ISI_LOCAL_FREE_ERROR   = -31;   // Could not free local memory.
  ISI_NULL_ERROR         = -40;   // Unexpected NULL pointer or handle.


// Decompressor Error Codes:
  DECO_NOT_INITIALIZED_ERROR        = -50;   // Decompressor not
                                             // initialized.
  DECO_BUSY_ERROR                   = -51;   // Decompressor busy,
                                             // can't initialize.
  DECO_ILLEGAL_HANDLE_ERROR         = -52;   // Decompressor instance
                                             // handle invalid.
  DECO_FIF_BUFFER_INCOMPLETE        = -53;   // FIF buffer length too
                                             // small.
  DECO_FTT_BUFFER_INCOMPLETE        = -54;   // FTT buffer length too
                                             // small.
  DECO_FIF_FORMAT_ERROR             = -55;   // Input in unknown file
                                             // format.
  DECO_CROP_RECT_ERROR              = -56;   // Error in cropping
                                             // rectangle.
  DECO_OUTPUT_FORMAT_ERROR          = -57;   // Output format invalid.
  DECO_RESOLUTION_SIZE_ERROR        = -58;   // Output resolution
                                             // invalid.
  DECO_FTT_FORMAT_ERROR             = -59;   // FTT file in unknown or
                                             // unsupported format.
  DECO_FTT_NOT_PROVIDED_ERROR       = -60;   // FTT file needed but
                                             // not provided.
  DECO_FTT_INCORRECT_ERROR          = -61;   // Wrong FTT file for
                                             // this FIF file.
  DECO_FIF_UNSUPPORTED_ERROR        = -62;   // Input in unsupported
                                             // file format.
  DECO_NO_COLORMAP_ERROR            = -63;   // No color table
                                             // provided for
                                             // colormapping.
  DECO_CALLBACK_ERROR               = -64;   // Callback function
                                             // failed.
  DECO_RESOLUTION_NOT_PROVIDED_ERROR= -65;   // No output resolution
                                             // provided.
  DECO_FIF_NOT_PROVIDED_ERROR       = -66;   // A call to SetFIFBuffer
                                             // is required.
  DECO_INVALID_STEP_ERROR           = -67;   // Invalid progressive
                                             // step number.
  DECO_NO_START_PROGRESSIVE_ERROR   = -68;   // Must call
                                             // StartProgressiveDecomp
                                             // ression first.
  DECO_FIF_FUTURE_VERSION_ERROR     = -69;   // Input FIF file
                                             // requires a newer
                                             // version of the
                                             // decompressor.

// Compressor Error Codes:
  COMP_BUSY_ERROR                      = -100; // Compressor is
                                               // already in use.
  COMP_NOT_INITIALIZED_ERROR           = -101; // Compressor not
                                               // initialized.
  COMP_ILLEGAL_HANDLE_ERROR            = -102; // Compressor instance
                                               // handle is invalid.
  COMP_ILLEGAL_IMAGE_FORMAT_ERROR      = -120; // Image format given
                                               // to SetInputFormat is
                                               // not valid/supported.
  COMP_IMAGE_SIZE_ERROR                = -121; // Image height or
                                               // width is 0, or
                                               // SetInputResolution
                                               // was not called
                                               // before attempting to
                                               // compress an image.
  COMP_IMAGE_ASPECT_RATIO_ERROR        = -122; // Physical aspect
                                               // ratio is different
                                               // from pixel aspect
                                               // ratio.
  COMP_MAX_COLORS_EXCEEDED_ERROR       = -123; // Color table has more
                                               // than 256 colors.
  COMP_RESET_ERROR                     = -132; // Compressor could not
                                               // be reset to its
                                               // default state.
  COMP_TYPE_ERROR                      = -140; // The Compressor type
                                               // passed to
                                               // OpenCompressor is
                                               // invalid.
  COMP_NOT_INCREMENTAL_ERROR           = -150; // Incremental
                                               // compression
                                               // function was called
                                               // without a previous
                                               // call to
                                               // StartIncrementalCom
                                               // pression.
  COMP_INCREMENTAL_COMPRESSION_COMPLETE= -151; // A call to
                                               // GetNextImageRect
                                               // was made when no
                                               // more panels remain
                                               // to be compressed.
  COMP_UNKNOWN_INCREMENT_ERROR         = -152; // A call to
                                               // GetNextImageRect is
                                               // required.
  COMP_SPEED_ERROR                     = -160; // Speed factor
                                               // invalid.  Speed
                                               // factor is an
                                               // integer from 1 to
                                               // 100.
  COMP_QUALITY_ERROR                   = -161; // Quality factor
                                               // invalid.  Quality
                                               // factor is an
                                               // integer from 1 to
                                               // 100.
  COMP_SEARCH_WIDTH_ERROR              = -170; // Search box width
                                               // too small (<80).
  COMP_SEARCH_HEIGHT_ERROR             = -171; // Search box height
                                               // too small (<64).
  COMP_NO_IMAGE_BUFFER_ERROR           = -190; // A call to
                                               // SetImageBuffer is
                                               // required.


implementation

var
  FIFDecodeLibraryHandle: THandle = 0;
  SessionCount: Integer = 0;

var
  _ClearFIFBuffer: function ( handle: Longint ): Longint cdecl;

  _ClearFTTBuffer: function ( handle: Longint ): Longint cdecl;

  _CloseDecompressor: function ( handle: Longint ): Longint cdecl;

  _DecompressToBuffer: function ( handle: Longint;
                                 ImageBuffer: Pointer;
                                 CropPixelX,
                                 CropPixelY,
                                 CropPixelWidth,
                                 CropPixelHeight: Longint;
                                 BytesPerRow: Longint ): Longint cdecl;

  _EndProgressiveDecompression: function ( handle: Longint ): Longint cdecl;

  _GetColorTableFormat: function ( handle: Longint;
                                  var ColorPlane0,
                                      ColorPlane1,
                                      ColorPlane2,
                                      ColorPlane3: Longint): Longint cdecl;

  _GetDecoVersion: function ( var MajorVer, MinorVe: Longint): Longint cdecl;

  _GetFastResolution: function ( handle: Longint;
                                var PixelWidth,
                                    PixelHeight: Longint ): Longint cdecl;

  _GetFIFColorTable: function ( handle: Longint;
                               ColorTable: Pointer ): Longint cdecl;

  _GetFIFFTTFileName: function ( handle: Longint;
                                FTTFileName: PChar ): Longint cdecl;

  _GetFIFNumColors: function ( handle: Longint;
                              var NumColors: Longint ): Longint cdecl;

  _GetFIFNumSteps: function ( handle: Longint;
                             var NumSteps: Longint ): Longint cdecl;

  _GetOriginalResolution: function ( handle: Longint;
                                    var PixelWidth,
                                        PixelHeight,
                                        ImageDepth: Longint ): Longint cdecl;

  _GetOutputColorTable: function ( handle: Longint;
                                  ColorTable: Pointer ): Longint cdecl;

  _GetOutputDither: function ( handle: Longint;
                              var DitherFlag: Byte ): Longint cdecl;

  _GetOutputFilter: function ( handle: Longint;
                              var FilterFlag: Byte ): Longint cdecl;

  _GetOutputFormat: function ( handle: Longint;
                              var ColorPlane0,
                                  ColorPlane1,
                                  ColorPlane2,
                                  ColorPlane3,
                                  RowOrder: Longint ): Longint cdecl;

  _GetOutputResolution: function ( handle: Longint;
                                  var PixelWidth,
                                      PixelHeight: Longint ): Longint cdecl;

  _GetPhysicalDimensions: function ( handle: Longint;
                                    var PhysicalWidth,
                                        PhysicalHeight: Longint;
                                    var PhysicalUnits: Byte;
                                    var PhysicalUnitScaleFactor: Longint ): Longint cdecl;

  _OpenDecompressor: function ( var Handle: Longint ): Longint cdecl;

  _ProgressiveDecompress: function ( handle: Longint;
                                    Frequency: Longint;
                                    var OutputBufferX,
                                        OutputBufferY,
                                        OutputBufferWidth,
                                        OutputBufferHeight,
                                        BytesNeeded,
                                        PercentDone: Longint ): Longint cdecl;

  _SetColorTableFormat: function ( handle: Longint;
                                  ColorPlane0,
                                  ColorPlane1,
                                  ColorPlane2,
                                  ColorPlane3: Longint ): Longint cdecl;

  _SetDecompressCallback: function ( handle: Longint;
                                    CallbackFunc: TISI_Callback;
                                    CallbackFreq: Longint ): Longint cdecl;

  _SetFIFBuffer: function ( handle: Longint;
                           FIFBuffer: Pointer;
                           FIFBufferSize: Longint ): Longint cdecl;

  _SetFTTBuffer: function ( handle: Longint;
                           FTTBuffer: Pointer;
                           FTTBufferSize: Longint ): Longint cdecl;

  _SetOutputColorTable: function ( handle: Longint;
                                  ColorTable: Pointer;
                                  EntryInfo: Pointer;
                                  NumColors: Longint ): Longint cdecl;

  _SetOutputDither: function ( handle: Longint;
                              DitherFlag: Boolean ): Longint cdecl;

  _SetOutputFilter: function ( handle: Longint;
                              FilterFlag: Boolean ): Longint cdecl;

  _SetOutputFormat: function ( handle: Longint;
                              ColorPlane0,
                              ColorPlane1,
                              ColorPlane2,
                              ColorPlane3,
                              RowOrder: Longint ): Longint cdecl;

  _SetOutputResolution: function ( handle: Longint;
                                  PixelWidth,
                                  PixelHeight: Longint ): Longint cdecl;

  _SetProgressiveFIFBuffer: function ( handle: Longint;
                                      FIFBuffer: Pointer;
                                      FIFBufferSize: Longint;
                                      var InputStatus: Longint;
                                      var HeaderLength: Longint ): Longint cdecl;

  _SetProgressiveStep: function ( handle: Longint;
                                 StepNumber: Longint ): Longint cdecl;

  _StartProgressiveDecompression: function ( handle: Longint;
                                            ImageBuffer: Pointer;
                                            CropPixelX,
                                            CropPixelY,
                                            CropPixelWidth,
                                            CropPixelHeight,
                                            BytesPerRow,
                                            Expand: Longint ): Longint cdecl;

  _TestIfFIF: function ( FileBuffer: Pointer;
                        BufferLength: Longint;
                        var IsFIF: Boolean ): Longint cdecl;



procedure FIFCheck(Result: Longint);
begin
  if Result <> 0 then
    EFIFError.CreateFmt('Invalid FIF operation: %d', [Result]);
end;

{  TFIFDecodeSession  }

constructor TFIFDecodeSession.Create;
begin
  inherited Create;
  Inc(SessionCount);
  LoadFIFDecodeLibrary('',True);
end;

destructor TFIFDecodeSession.Destroy;
begin
  Dec(SessionCount);
  CloseDecompressor;
  inherited Destroy;
end;

procedure TFIFDecodeSession.ClearFIFBuffer;
begin
  FIFCheck(_ClearFIFBuffer(Handle));
end;

procedure TFIFDecodeSession.ClearFTTBuffer;
begin
  FIFCheck(_ClearFTTBuffer(Handle));
end;

procedure TFIFDecodeSession.CloseDecompressor;
begin
  if FHandle <> 0 then
  begin
    _ClearFIFBuffer(FHandle);
    _ClearFTTBuffer(FHandle);
    FIFCheck(_CloseDecompressor(FHandle));
  end;
  FHandle := 0;
end;

procedure TFIFDecodeSession.DecompressToBuffer( ImageBuffer: Pointer;
  CropPixelX, CropPixelY, CropPixelWidth, CropPixelHeight: Longint;
  BytesPerRow: Longint );
begin
  FIFCheck(_DecompressToBuffer(Handle, ImageBuffer, CropPixelX, CropPixelY,
    CropPixelWidth, CropPixelHeight, BytesPerRow));
end;

procedure TFIFDecodeSession.EndProgressiveDecompression;
begin
  FIFCheck(_EndProgressiveDecompression(FHandle));
end;

procedure TFIFDecodeSession.GetColorTableFormat( var ColorPlane0, ColorPlane1,
  ColorPlane2, ColorPlane3: Longint);
begin
  FIFCheck(_GetColorTableFormat(FHandle, ColorPlane0, ColorPlane1, ColorPlane2,
    ColorPlane3));
end;

class function TFIFDecodeSession.GetDecoVersion( var MajorVer, MinorVer: Longint): Boolean;
begin
  Result := LoadFIFDecodeLibrary('',False);
  if Result then
    _GetDecoVersion(MajorVer, MinorVer);
end;

procedure TFIFDecodeSession.GetFastResolution( var PixelWidth, PixelHeight: Longint );
begin
  FIFCheck(_GetFastResolution(FHandle, PixelWidth, PixelHeight));
end;

function TFIFDecodeSession.GetFIFColorTable( ColorTable: Pointer ): Boolean;
var
  ResultCode: Longint;
begin
  Result := False;
  ResultCode := _GetFIFColorTable(FHandle, ColorTable);
  if ResultCode <> DECO_NO_COLORMAP_ERROR then
  begin
    FIFCheck(ResultCode);
    Result := True;
  end;
end;

function TFIFDecodeSession.GetFIFFTTFileName: string;
var
  Buf: array [Byte] of Char;
begin
  FIFCheck(_GetFIFFTTFileName(FHandle, Buf));
  Result := Buf;
end;

function TFIFDecodeSession.GetFIFNumColors: Longint;
begin
  FIFCheck(_GetFIFNumColors(FHandle, Result));
end;

function TFIFDecodeSession.GetFIFNumSteps: Longint;
begin
  FIFCheck(_GetFIFNumSteps(FHandle, Result));
end;

function TFIFDecodeSession.GetHandle: Longint;
begin
  if FHandle = 0 then
    FIFCheck(_OpenDecompressor(FHandle));
  Result := FHandle;
end;

function TFIFDecodeSession.GetOriginalImageInfo: TFIFOriginalImageInfo;
begin
  FIFCheck(_GetOriginalResolution(FHandle, Result.Width, Result.Height,
    Result.ColorDepth));
end;

procedure TFIFDecodeSession.GetOutputColorTable( ColorTable: Pointer );
begin
  FIFCheck(_GetOutputColorTable(FHandle, ColorTable));
end;

function TFIFDecodeSession.GetOutputDither: Boolean;
var
  Code: Byte;
begin
  FIFCheck(_GetOutputDither(FHandle, Code));
  Result := Code <> 0;
end;

function TFIFDecodeSession.GetOutputFilter: Boolean;
var
  Code: Byte;
begin
  FIFCheck(_GetOutputFilter(FHandle, Code));
  Result := Code <> 0;
end;

procedure TFIFDecodeSession.GetOutputFormat( var ColorPlane0, ColorPlane1, ColorPlane2,
  ColorPlane3, RowOrder: Longint );
begin
  FIFCheck(_GetOutputFormat(FHandle, ColorPlane0, ColorPlane1, ColorPlane2,
    ColorPlane3, RowOrder));
end;

procedure TFIFDecodeSession.GetOutputResolution( var PixelWidth, PixelHeight: Longint );
begin
  FIFCheck(_GetOutputResolution(FHandle, PixelWidth, PixelHeight));
end;

procedure TFIFDecodeSession.GetPhysicalDimensions( var PhysicalWidth, PhysicalHeight: Longint;
  var PhysicalUnits: Byte; var PhysicalUnitScaleFactor: Longint );
begin
  FIFCheck(_GetPhysicalDimensions(FHandle, PhysicalWidth, PhysicalHeight,
    PhysicalUnits, PhysicalUnitScaleFactor));
end;

procedure TFIFDecodeSession.ProgressiveDecompress( Frequency: Longint;
  var OutputBufferX, OutputBufferY, OutputBufferWidth, OutputBufferHeight,
      BytesNeeded, PercentDone: Longint );
begin
  FIFCheck(_ProgressiveDecompress( FHandle, Frequency, OutputBufferX,
    OutputBufferY, OutputBufferWidth, OutputBufferHeight, BytesNeeded,
    PercentDone));
end;

procedure TFIFDecodeSession.SetColorTableFormat( ColorPlane0, ColorPlane1, ColorPlane2,
  ColorPlane3: Longint );
begin
  FIFCheck(_SetColorTableFormat(Handle, ColorPlane0, ColorPlane1, ColorPlane2,
    ColorPlane3));
end;

procedure TFIFDecodeSession.SetDecompressCallback( CallbackFunc: TISI_Callback;
  CallbackFreq: Longint );
begin
  FIFCheck(_SetDecompressCallback(Handle, CallbackFunc, CallbackFreq));
end;

procedure TFIFDecodeSession.SetFIFBuffer( Buffer: Pointer; Size: Longint);
begin
  FIFCheck(_SetFIFBuffer(Handle, Buffer, Size));
end;

procedure TFIFDecodeSession.SetFTTBuffer( Buffer: Pointer; Size: Longint );
begin
  FIFCheck(_SetFTTBuffer(Handle, Buffer, Size));
end;

procedure TFIFDecodeSession.SetOutputColorTable( ColorTable: Pointer; EntryInfo: Pointer;
  NumColors: Longint );
begin
  FIFCheck(_SetOutputColorTable(FHandle, ColorTable, EntryInfo, NumColors));
end;

procedure TFIFDecodeSession.SetOutputDither(Value: Boolean);
begin
  FIFCheck(_SetOutputDither(FHandle, Value));
end;

procedure TFIFDecodeSession.SetOutputFilter(Value: Boolean);
begin
  FIFCheck(_SetOutputFilter(FHandle, Value));
end;

procedure TFIFDecodeSession.SetOutputFormat( ColorPlane0, ColorPlane1, ColorPlane2,
  ColorPlane3, RowOrder: Longint );
begin
  FIFCheck(_SetOutputFormat(Handle, ColorPlane0, ColorPlane1, ColorPlane2,
    ColorPlane3, RowOrder));
end;

procedure TFIFDecodeSession.SetOutputResolution( PixelWidth, PixelHeight: Longint );
begin
  FIFCheck(_SetOutputResolution(Handle, PixelWidth, PixelHeight));
end;

procedure TFIFDecodeSession.SetProgressiveFIFBuffer( Buffer: Pointer;
  Size: Longint; var InputStatus, HeaderLength: Longint );
begin
  FIFCheck(_SetProgressiveFIFBuffer(FHandle, Buffer, Size, InputStatus,
    HeaderLength));
end;

procedure TFIFDecodeSession.SetProgressiveStep( StepNumber: Longint );
begin
  FIFCheck(_SetProgressiveStep(FHandle, StepNumber));
end;

procedure TFIFDecodeSession.StartProgressiveDecompression( ImageBuffer: Pointer;
  CropPixelX, CropPixelY, CropPixelWidth, CropPixelHeight,
  BytesPerRow, Expand: Longint );
begin
  FIFCheck(_StartProgressiveDecompression(Handle, ImageBuffer, CropPixelX,
    CropPixelY, CropPixelWidth, CropPixelHeight, BytesPerRow, Expand));
end;

class function TFIFDecodeSession.TestIfFIF( Buffer: Pointer; Length: Longint): Boolean;
begin  // DECO_FIF_FUTURE_VERSION error will raise exception later in decoding
  Result := False;
  if LoadFIFDecodeLibrary('', False) then
    _TestIfFIF(Buffer, Length, Result);
end;



function LoadFIFDecodeLibrary(Filepath: string; RaiseExceptions: Boolean): Boolean;
  procedure Error;
  begin
    raise EFIFError.CreateFmt('Error loading %s: (%d)',[FilePath, GetLastError])
  end;
var
  Major, Minor: Longint;
begin
  Result := FIFDecodeLibraryHandle <> 0;
  if Result then Exit;
  Result := False;
  if Length(Filepath) = 0 then
    FilePath := FIFDecodeDLLName;
  FIFDecodeLibraryHandle := LoadLibrary(PChar(Filepath));

  if FIFDecodeLibraryHandle = 0 then
    if RaiseExceptions then Error else Exit;

  try
    _GetDecoVersion := GetProcAddress(FIFDecodeLibraryHandle, 'GetDecoVersion');
    if not Assigned(_GetDecoVersion) then
      if RaiseExceptions then Error else Exit;

    _GetDecoVersion(Major, Minor);
    if (Major < VERSION_PRIMARY) or
      ((Major = VERSION_PRIMARY) and (Minor < VERSION_SECONDARY)) then
      if RaiseExceptions then
        raise EFIFError.CreateFmt('Wrong DLL version: %s %d.%d.  This program '+
          'requires version %d.%d or later.',
          [FilePath, Major, Minor, VERSION_PRIMARY, VERSION_SECONDARY])
      else Exit;

    _ClearFIFBuffer := GetProcAddress(FIFDecodeLibraryHandle, 'ClearFIFBuffer');
    _ClearFTTBuffer  := GetProcAddress(FIFDecodeLibraryHandle, 'ClearFTTBuffer');
    _CloseDecompressor := GetProcAddress(FIFDecodeLibraryHandle, 'CloseDecompressor');
    _DecompressToBuffer := GetProcAddress(FIFDecodeLibraryHandle, 'DecompressToBuffer');
    _EndProgressiveDecompression := GetProcAddress(FIFDecodeLibraryHandle, 'EndProgressiveDecompression');
    _GetColorTableFormat := GetProcAddress(FIFDecodeLibraryHandle, 'GetColorTableFormat');
    _GetFastResolution := GetProcAddress(FIFDecodeLibraryHandle, 'GetFastResolution');
    _GetFIFColorTable := GetProcAddress(FIFDecodeLibraryHandle, 'GetFIFColorTable');
    _GetFIFFTTFileName := GetProcAddress(FIFDecodeLibraryHandle, 'GetFIFFTTFileName');
    _GetFIFNumColors := GetProcAddress(FIFDecodeLibraryHandle, 'GetFIFNumColors');
    _GetFIFNumSteps := GetProcAddress(FIFDecodeLibraryHandle, 'GetFIFNumSteps');
    _GetOriginalResolution := GetProcAddress(FIFDecodeLibraryHandle, 'GetOriginalResolution');
    _GetOutputColorTable := GetProcAddress(FIFDecodeLibraryHandle, 'GetOutputColorTable');
    _GetOutputDither := GetProcAddress(FIFDecodeLibraryHandle, 'GetOutputDither');
    _GetOutputFilter := GetProcAddress(FIFDecodeLibraryHandle, 'GetOutputFilter');
    _GetOutputFormat := GetProcAddress(FIFDecodeLibraryHandle, 'GetOutputFormat');
    _GetOutputResolution := GetProcAddress(FIFDecodeLibraryHandle, 'GetOutputResolution');
    _GetPhysicalDimensions := GetProcAddress(FIFDecodeLibraryHandle, 'GetPhysicalDimensions');
    _OpenDecompressor := GetProcAddress(FIFDecodeLibraryHandle, 'OpenDecompressor');
    _ProgressiveDecompress := GetProcAddress(FIFDecodeLibraryHandle, 'ProgressiveDecompress');
    _SetColorTableFormat := GetProcAddress(FIFDecodeLibraryHandle, 'SetColorTableFormat');
    _SetDecompressCallback := GetProcAddress(FIFDecodeLibraryHandle, 'SetDecompressCallback');
    _SetFIFBuffer := GetProcAddress(FIFDecodeLibraryHandle, 'SetFIFBuffer');
    _SetFTTBuffer := GetProcAddress(FIFDecodeLibraryHandle, 'SetFTTBuffer');
    _SetOutputColorTable := GetProcAddress(FIFDecodeLibraryHandle, 'SetOutputColorTable');
    _SetOutputDither := GetProcAddress(FIFDecodeLibraryHandle, 'SetOutputDither');
    _SetOutputFilter := GetProcAddress(FIFDecodeLibraryHandle, 'SetOutputFilter');
    _SetOutputFormat := GetProcAddress(FIFDecodeLibraryHandle, 'SetOutputFormat');
    _SetOutputResolution := GetProcAddress(FIFDecodeLibraryHandle, 'SetOutputResolution');
    _SetProgressiveFIFBuffer := GetProcAddress(FIFDecodeLibraryHandle, 'SetProgressiveFIFBuffer');
    _SetProgressiveStep := GetProcAddress(FIFDecodeLibraryHandle, 'SetProgressiveStep');
    _StartProgressiveDecompression := GetProcAddress(FIFDecodeLibraryHandle, 'StartProgressiveDecompression');
    _TestIfFIF := GetProcAddress(FIFDecodeLibraryHandle, 'TestIfFIF');
    Result := FIFDecodeLibraryHandle <> 0;
  finally
    if not Result and (FIFDecodeLibraryHandle <> 0) then
      UnloadFIFDecodeLibrary;
  end;
end;

procedure UnloadFIFDecodeLibrary;
begin
  if (FIFDecodeLibraryHandle <> 0) and (SessionCount = 0) then
    FreeLibrary(FIFDecodeLibraryHandle);
  FIFDecodeLibraryHandle := 0;
end;

initialization
finalization
  UnloadFIFDecodeLibrary;
end.


