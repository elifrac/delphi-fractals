unit PngImage;
{
  PngImage.Pas - Copyright 1998 Edmund H. Hand
  For conditions of distribution and use, see the COPYRIGHT NOTICE below.

  This unit provides two classes.

  TPngGraphic - A TGraphic derived class.  It provides the ability for all
                Delphi components that use a TGraphic to open PNG files with
                the LoadFromFile method.  For example: with a TImage you
                can call TImage.Picture.LoadFromFile('somefile.PNG'); and
                the TImage will display the PNG file.  For optimal use of
                this class, this file should be installed into a package
                such as the Delphi User's Components (generally
                C:\Program Files\Borland\Delphi 3\Lib\dclusr30.dpk).  This
                can be done by starting Delphi and picking
                "Component | Install Component" from the Delphi menu bar.
                Enter this file as the unit file name and press OK.

  TPngImage   - This is the base PNG class.  It is used by TPngGraphic to
                handle the PNG images.  It can also be used on its own to
                load PNG files into memory for program manipulation.  If the
                loaded image contains an Alpha chanel, it is loaded as part
                of the data stream.  The draw method of this class provides
                full support for alpha blending of the image data onto the
                provided canvas.

                To allow for better performance and less memory usage
                TPngImage has a simple refrence counting system in place.
                Look at the Assign method of TPngGraphic for an example of
                its use.  It allows for assigning the image to multiple
                Graphic components and only one copy will remain in memory.
                When the reference count drops to zero the image will
                destroy itself.  If you manually create a TPngImage, you
                should free it by calling its Release method.  Calling the
                GetReference method will increase the reference count and
                return itself.

  COPYRIGHT NOTICE:

  The unit is supplied "AS IS".  The Author disclaims all warranties,
  expressed or implied, including, without limitation, the warranties of
  merchantability and of fitness for any purpose.  The Author assumes no
  liability for direct, indirect, incidental, special, exemplary, or
  consequential damages, which may result from the use of this unit, even
  if advised of the possibility of such damage.

  Permission is hereby granted to use, copy, modify, and distribute this
  source code, or portions hereof, for any purpose, without fee, subject
  to the following restrictions:
  1. The origin of this source code must not be misrepresented.
  2. Altered versions must be plainly marked as such and must not be
     misrepresented as being the original source.
  3. This Copyright notice may not be removed or altered from any source or
     altered source distribution.

  If you use this source code in a product, acknowledgment is not required
  but would be appreciated.  I would also like to know of any projects,
  especially commercial ones, that use this code.

  I can be reached at:
     edhand@worldnet.att.net

}
interface

uses Windows, SysUtils, Classes, Graphics, PngLib;

type TPngImage = class
  private
    FBitDepth:      Integer;
    FBytesPerPixel: Integer;
    FColorType:     Integer;
    FHeight:        Integer;
    FWidth:         Integer;

    Data:           PByte;
    RowPtrs:        PByte;
    RefCount:       Integer;

    procedure InitializeDemData;
  protected
  public
    bm2:      TBitmap;
    constructor Create;
    destructor  Destroy; override;

    procedure Draw(ACanvas: TCanvas; const Rect: TRect);
    function  GetReference: TPngImage;
    procedure LoadFromFile(const Filename: string);
    procedure Release;
    procedure SaveToFile(const Filename: string);
  published
    property BitDepth:      Integer read FBitDepth  write FBitDepth;
    property BytesPerPixel: Integer read FBytesPerPixel  write FBytesPerPixel;
    property ColorType:     Integer read FColorType      write FColorType;
    property Height:        Integer read FHeight write FHeight;
    property Width:         Integer read FWidth  write FWidth;
end;

type TPngGraphic = class(TGraphic)
  private
  protected
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function  GetEmpty: Boolean; override;
    function  GetHeight: Integer; override;
    function  GetWidth: Integer; override;
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;
  public
    Image: TPngImage;

    constructor Create; override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure LoadFromFile(const Filename: string); override;
    procedure SaveToFile(const Filename: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
              APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
              var APalette: HPALETTE); override;
  published
end;

implementation

//
// TPngImage
//
constructor TPngImage.Create;
begin
  Data     := nil;
  RowPtrs  := nil;
  FHeight  := 0;
  FWidth   := 0;
  RefCount := 1;
  bm2 := Tbitmap.Create;
  bm2.Height := FHeight;
  bm2.Width  := FWidth;
end;  // TPngImage.Create

destructor  TPngImage.Destroy;
begin
  if Data <> nil then
    FreeMem(Data);
  if RowPtrs <> nil then
    FreeMem(RowPtrs);
  bm2.free;
end;  // TPngImage.Destroy


procedure TPngImage.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  valuep:  PByte;
  x, y:    Integer;
  ndx:     Integer;
 // bm:      TBitmap;
  sl:      PByteArray;  // Scanline of bitmap
  slbpp:   Integer;     // Scanline bytes per pixel
  a, r, g, b: Byte;
begin
  // Create temporary bitmap
  //bm := TBitmap.Create;
  bm2.Height := FHeight;
  bm2.Width  := FWidth;
  case FBytesPerPixel of
    2: begin
      bm2.PixelFormat := pf16Bit;
      slbpp := 2;
    end;
    else begin
      bm2.PixelFormat := pf24Bit;
      slbpp := 3;
    end;
  end;
  // Copy canvas to temporary bitmap
  BitBlt(bm2.Canvas.Handle, 0, 0, FWidth, FHeight, ACanvas.Handle,
         Rect.Left, Rect.Top, SRCCOPY);

  // point to data
  valuep := Data;
  for y := 0 to FHeight - 1 do
  begin
    sl := bm2.Scanline[y];  // current scanline
    for x := 0 to FWidth - 1 do
    begin
      ndx := x * slbpp;    // index into current scanline
      if FBytesPerPixel = 2 then
      begin
        // handle 16bit grayscale images, this will display them
        // as a 16bit color image, kinda hokie but fits my needs
        // without altering the data.
        sl[ndx]     := valuep^;  Inc(valuep);
        sl[ndx + 1] := valuep^;  Inc(valuep);
      end
      else if FBytesPerPixel = 3 then
      begin
        // RGB - swap blue and red for windows format
        sl[ndx + 2] := valuep^;  Inc(valuep);
        sl[ndx + 1] := valuep^;  Inc(valuep);
        sl[ndx]     := valuep^;  Inc(valuep);
      end
      else  // 4 bytes per pixel of image data
      begin
        // Alpha chanel present and RGB
        // this is what PNG is all about
        r := valuep^;  Inc(valuep);
        g := valuep^;  Inc(valuep);
        b := valuep^;  Inc(valuep);
        a := valuep^;  Inc(valuep);
        if a = 0 then
        begin
          // alpha is zero so no blending, just image data
          sl[ndx]     := b;
          sl[ndx + 1] := g;
          sl[ndx + 2] := r;
        end
        else if a < 255 then
        begin
          // blend with data from ACanvas as background
          sl[ndx]     := ((sl[ndx] * a) + ((255 - a) * b)) div 255;
          sl[ndx + 1] := ((sl[ndx + 1] * a) + ((255 - a) * g)) div 255;
          sl[ndx + 2] := ((sl[ndx + 2] * a) + ((255 - a) * r)) div 255;
        end;
        // if a = 255 then do not place any color from the image at this
        // pixel, but leave the background intact instead.
      end;
    end;
  end;

  BitBlt(ACanvas.Handle, Rect.Left, Rect.Top, FWidth, FHeight,
         bm2.Canvas.Handle, 0, 0, SRCCOPY);
  //bm.Free;
end;  // TPngImage.Draw

function  TPngImage.GetReference: TPngImage;
begin
  Inc(RefCount);
  Result := Self;
end;  // TPngImage.GetReference

procedure TPngImage.InitializeDemData;
var
  cvaluep:  PCardinal;
  y:        Integer;
begin
  // Initialize Data and RowPtrs
  if Data <> nil then
    FreeMem(Data);
  Data := nil;
  if RowPtrs <> nil then
    FreeMem(RowPtrs);
  RowPtrs := nil;

  GetMem(Data, FHeight * FWidth * FBytesPerPixel);
  GetMem(RowPtrs, sizeof(Pointer) * FHeight);
  if (Data <> nil) and (RowPtrs <> nil) then
  begin
    cvaluep := Pointer(RowPtrs);
    for y := 0 to FHeight - 1 do
    begin
      cvaluep^ := Cardinal(Data) + (FWidth * FBytesPerPixel * y);
      Inc(cvaluep);
    end;
  end;  // if (Data <> nil) and (RowPtrs <> nil) then
end;  // TPngImage.InitializeDemData

procedure TPngImage.LoadFromFile(const Filename: string);
var
  png:      PPng_Struct;
  pnginfo:  PPng_Info;
  rowbytes: Cardinal;
  PngFile:  Pointer;
  tmp:      array[0..32] of char;
begin
  pngfile := png_open_file(@Filename[1], 'rb');
  if pngfile = nil then
    raise Exception.Create('Error Opening File ' + Filename + '!');

  try
    StrPCopy(tmp, PNG_LIBPNG_VER_STRING);
    try
      png := png_create_read_struct(tmp, nil, nil, nil);
      if png <> nil then
      begin
        try
          pnginfo := png_create_info_struct(png);
          png_init_io(png, pngfile);
          png_set_read_status_fn(png, nil);
          png_read_info(png, pnginfo);
          png_get_IHDR(png, pnginfo, @FWidth, @FHeight,
                       @FBitDepth, @FColorType, nil, nil, nil);
          png_set_invert_alpha(png);
          // if bit depth is less than 8 then expand...
          if (FColorType = PNG_COLOR_TYPE_PALETTE) and
             (FBitDepth <= 8) then
            png_set_expand(png);
          if (FColorType = PNG_COLOR_TYPE_GRAY) and
             (FBitDepth < 8) then
            png_set_expand(png);
          // Add alpha channel if pressent
          if png_get_valid(png, pnginfo, PNG_INFO_tRNS) = PNG_INFO_tRNS then
            png_set_expand(png);
          // expand images to 1 pixel per byte
          if FBitDepth < 8 then
            png_set_packing(png);
          // Swap 16 bit images to PC Format
          if FBitDepth = 16 then
            png_set_swap(png);
          // update the info structure
          png_read_update_info(png, pnginfo);
          png_get_IHDR(png, pnginfo, @FWidth, @FHeight,
                       @FBitDepth, @FColorType, nil, nil, nil);

          rowbytes := png_get_rowbytes(png, pnginfo);
          FBytesPerPixel := rowbytes div FWidth;
          InitializeDemData;
          if (Data <> nil) and (RowPtrs <> nil) then
            // Read the image
            png_read_image(png, PPByte(RowPtrs));
        finally
          png_destroy_read_struct(@png, @pnginfo, nil);
        end;  // try pnginfo create
      end;  // png <> nil
    except
      raise Exception.Create('Error Reading File!');
    end;  // try png create

  finally
    png_close_file(pngfile);
  end;
end;  // TPngImage.LoadFromFile

procedure TPngImage.Release;
begin
  Dec(RefCount);
  if RefCount <= 0 then
    Destroy;
end;  // TPngImage.Release

procedure TPngImage.SaveToFile(const Filename: string);
var
  png:      PPng_Struct;
  pnginfo:  PPng_Info;
  tmp:      array[0..32] of char;
  pngfile:  Pointer;
begin
  pngfile := png_open_file(@Filename[1], 'wb');
  if pngfile = nil then
  begin
    raise Exception.Create('Error Opening File ' + Filename + '!');
    exit;
  end;

  try
    StrPCopy(tmp, PNG_LIBPNG_VER_STRING);
    try
      png := png_create_write_struct(tmp, nil, nil, nil);
      if png <> nil then
      begin
        try
          // create info struct and init io functions
          pnginfo := png_create_info_struct(png);
          png_init_io(png, pngfile);
          png_set_write_status_fn(png, nil);
          // set image attributes, compression, etc...
          png_set_IHDR(png, pnginfo, FWidth, FHeight, FBitDepth, FColorType,
                       PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT,
                       PNG_FILTER_TYPE_DEFAULT);

          if (Data <> nil) and (RowPtrs <> nil) then
          begin
            // Swap 16 bit images from PC Format
            if FBitDepth = 16 then
              png_set_swap(png);
            // Write the image
            png_write_image(png, PPByte(RowPtrs));
            png_write_end(png, pnginfo);
          end;  // if buf <> nil
        finally
          png_destroy_write_struct(@png, @pnginfo);
        end;  // try pnginfo create
      end;  // png <> nil
    except
      raise Exception.Create('Error Writing File!');
    end;  // try png create

  finally
    png_close_file(pngfile);
  end;
end;  // TPngImage.SaveToFile

//
// TPngGraphic
//
constructor TPngGraphic.Create;
begin
  SetTransparent(True);
end;  // TPngGraphic.Create

destructor TPngGraphic.Destroy;
begin
  Image.Release;
end;  // TPngGraphic.Destroy

procedure TPngGraphic.Assign(Source: TPersistent);
begin
  if Source is TPngGraphic then
    begin
      if Assigned(Image) then
        Image.Release;
      Image := TPngGraphic(Source).Image.GetReference;
    end
  else
    inherited Assign(Source);
end;  // TPngGraphic.Assign

procedure TPngGraphic.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  if Assigned(Image) then
    Image.Draw(ACanvas, Rect);
end;  // TPngGraphic.Draw

function  TPngGraphic.GetEmpty: Boolean;
begin
  if Assigned(Image) then
    Result := False
  else
    Result := True;
end;  // TPngGraphic.GetEmpty

function TPngGraphic.GetHeight: Integer;
begin
  Result := Image.Height;
end;  // TPngGraphic.GetHeight

function TPngGraphic.GetWidth: Integer;
begin
  Result := Image.Width;
end;  // TPngGraphic.GetWidth

procedure TPngGraphic.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
          APalette: HPALETTE);
begin
  raise Exception.Create('Cannot load a TPngGraphic from the Clipboard');
end;  // TPngGraphic.LoadFromClipboardFormat

procedure TPngGraphic.LoadFromFile(const Filename: string);
begin
  if not Assigned(Image) then
    Image := TPngImage.Create;
  Image.LoadFromFile(Filename);
end;  // TPngGraphic.LoadFromFile

procedure TPngGraphic.LoadFromStream(Stream: TStream);
begin
  raise Exception.Create('Cannot load a TPngGraphic from a Stream');
end;  // TPngGraphic.LoadFromStream

procedure TPngGraphic.SaveToClipboardFormat(var AFormat: Word;
          var AData: THandle; var APalette: HPALETTE);
begin
  raise Exception.Create('Cannot save a TPngGraphic to the Clipboard');
end;  // TPngGraphic.SaveToClipboardFormat

procedure TPngGraphic.SaveToFile(const Filename: string);
begin
  if Assigned(Image) then
    Image.SaveToFile(Filename);
end;  // TPngGraphic.SaveToFile

procedure TPngGraphic.SaveToStream(Stream: TStream);
begin
  raise Exception.Create('Cannot save a TPngGraphic to a Stream');
end;  // TPngGraphic.SaveToStream

procedure TPngGraphic.SetHeight(Value: Integer);
begin
  raise Exception.Create('Cannot set height on a TPngGraphic');
end;  // TPngGraphic.SetHeight

procedure TPngGraphic.SetWidth(Value: Integer);
begin
  raise Exception.Create('Cannot set width on a TPngGraphic');
end;  // TPngGraphic.SetWidth

initialization
  TPicture.RegisterFileFormat('PNG', 'Portable Network Graphics', TPngGraphic);

end.
