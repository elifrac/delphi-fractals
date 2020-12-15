{
	Special thanks to
	- Peter Schütt, Sahler GmbH, Bonn, schuett@sahler.de
  	  for Bug fixes, 16 - Bit - Version and the Stream functions
  	- Nick Spurrier (MoDESoft, UK), nick@mode.co.uk
  	  for 32-bit images
}

unit Bmp2Tiff;

interface

uses WinProcs, WinTypes, Classes, Graphics, ExtCtrls;

type
  PDirEntry = ^TDirEntry;
  TDirEntry = record
    _Tag    : Word;
    _Type   : Word;
    _Count  : LongInt;
    _Value  : LongInt;
  end;

  procedure WriteTiffToStream ( Stream : TStream; Bitmap : TBitmap );
  procedure WriteTiffToFile ( Filename : string; Bitmap : TBitmap );

{$IFDEF WINDOWS}
CONST
{$ELSE}
VAR
{$ENDIF}
    { TIFF File Header: }
	TifHeader : array[0..7] of Byte = (
            $49, $49,                 { Intel byte order }
            $2a, $00,                 { TIFF version (42) }
            $08, $00, $00, $00 );     { Pointer to the first directory }

  NoOfDirs : array[0..1] of Byte = ( $0F, $00 );	{ Number of tags within the directory }

	DirectoryCOL : array[0..14] of TDirEntry = (
 ( _Tag: $00FE; _Type: $0004; _Count: $00000001; _Value: $00000000 ),  { NewSubFile: Image with full solution (0) }
 ( _Tag: $0100; _Type: $0003; _Count: $00000001; _Value: $00000000 ),  { ImageWidth:      Value will be set later }
 ( _Tag: $0101; _Type: $0003; _Count: $00000001; _Value: $00000000 ),  { ImageLength:     Value will be set later }
 ( _Tag: $0102; _Type: $0003; _Count: $00000001; _Value: $00000008 ),  { BitsPerSample:   8                       }
 ( _Tag: $0103; _Type: $0003; _Count: $00000001; _Value: $00000001 ),  { Compression:     No compression          }
 ( _Tag: $0106; _Type: $0003; _Count: $00000001; _Value: $00000003 ),  { PhotometricInterpretation:               }
 ( _Tag: $0111; _Type: $0004; _Count: $00000001; _Value: $00000000 ),  { StripOffsets: Ptr to the adress of the image data }
 ( _Tag: $0115; _Type: $0003; _Count: $00000001; _Value: $00000001 ),  { SamplesPerPixels: 1                      }
 ( _Tag: $0116; _Type: $0004; _Count: $00000001; _Value: $00000000 ),  { RowsPerStrip: Value will be set later    }
 ( _Tag: $0117; _Type: $0004; _Count: $00000001; _Value: $00000000 ),  { StripByteCounts: xs*ys bytes pro strip   }
 ( _Tag: $011A; _Type: $0005; _Count: $00000001; _Value: $00000000 ),  { X-Resolution: Adresse                    }
 ( _Tag: $011B; _Type: $0005; _Count: $00000001; _Value: $00000000 ),  { Y-Resolution: (Adresse)                  }
 ( _Tag: $0128; _Type: $0003; _Count: $00000001; _Value: $00000002 ),  { Resolution Unit: (2)= Unit ZOLL          }
 ( _Tag: $0131; _Type: $0002; _Count: $0000000A; _Value: $00000000 ),  { Software:                                }
 ( _Tag: $0140; _Type: $0003; _Count: $00000300; _Value: $00000008 ) );{ ColorMap: Color table startadress        }

	DirectoryRGB : array[0..14] of TDirEntry = (
 ( _Tag: $00FE; _Type: $0004; _Count: $00000001; _Value: $00000000 ), 	{ NewSubFile:      Image with full solution (0) }
 ( _Tag: $0100; _Type: $0003; _Count: $00000001; _Value: $00000000 ), 	{ ImageWidth:      Value will be set later      }
 ( _Tag: $0101; _Type: $0003; _Count: $00000001; _Value: $00000000 ), 	{ ImageLength:     Value will be set later      }
 ( _Tag: $0102; _Type: $0003; _Count: $00000003; _Value: $00000008 ), 	{ BitsPerSample:   8                            }
 ( _Tag: $0103; _Type: $0003; _Count: $00000001; _Value: $00000001 ), 	{ Compression:     No compression               }
 ( _Tag: $0106; _Type: $0003; _Count: $00000001; _Value: $00000002 ), 	{ PhotometricInterpretation:
                                                                          0=black, 2 power BitsPerSample -1 =white }
 ( _Tag: $0111; _Type: $0004; _Count: $00000001; _Value: $00000000 ), 	{ StripOffsets: Ptr to the adress of the image data }
 ( _Tag: $0115; _Type: $0003; _Count: $00000001; _Value: $00000003 ), 	{ SamplesPerPixels: 3                         }
 ( _Tag: $0116; _Type: $0004; _Count: $00000001; _Value: $00000000 ), 	{ RowsPerStrip: Value will be set later         }
 ( _Tag: $0117; _Type: $0004; _Count: $00000001; _Value: $00000000 ),	{ StripByteCounts: xs*ys bytes pro strip        }
 ( _Tag: $011A; _Type: $0005; _Count: $00000001; _Value: $00000000 ),	{ X-Resolution: Adresse                         }
 ( _Tag: $011B; _Type: $0005; _Count: $00000001; _Value: $00000000 ),	{ Y-Resolution: (Adresse)                       }
 ( _Tag: $011C; _Type: $0003; _Count: $00000001; _Value: $00000001 ),	{ PlanarConfiguration:
                                                                          Pixel data will be stored continous         }
 ( _Tag: $0128; _Type: $0003; _Count: $00000001; _Value: $00000002 ),	{ Resolution Unit: (2)= Unit ZOLL               }
 ( _Tag: $0131; _Type: $0002; _Count: $0000000A; _Value: $00000000 ));	{ Software:                                   }

  NullString    : array[0..3] of Byte = ( $00, $00, $00, $00 );
  X_Res_Value   : array[0..7] of Byte = ( $6D,$03,$00,$00,  $0A,$00,$00,$00 );  { Value for X-Resolution:
                                                                                  87,7 Pixel/Zoll (SONY SCREEN) }
  Y_Res_Value   : array[0..7] of Byte = ( $6D,$03,$00,$00,  $0A,$00,$00,$00 );  { Value for Y-Resolution: 87,7 Pixel/Zoll }
  Software      : array[0..9] of Char = ( 'E', 'l', 'i', 'f', 'r', 'a', 'c', ' ', ' ', ' ');
  BitsPerSample : array[0..2] of Word = ( $0008, $0008, $0008 );


implementation

procedure WriteTiffToStream ( Stream : TStream ; Bitmap : TBitmap ) ;
var
  BM           : HBitmap;
  Header, Bits : PChar;
  BitsPtr      : PChar;
  TmpBitsPtr   : PChar;
  HeaderSize   : {$IFDEF WINDOWS} INTEGER {$ELSE} DWORD {$ENDIF} ;
  BitsSize     : {$IFDEF WINDOWS} LongInt {$ELSE} DWORD {$ENDIF} ;
  Width, Height: {$IFDEF WINDOWS} LongInt {$ELSE} Integer {$ENDIF} ;
  DataWidth    : {$IFDEF WINDOWS} LongInt {$ELSE} Integer {$ENDIF} ;
  BitCount     : {$IFDEF WINDOWS} LongInt {$ELSE} Integer {$ENDIF} ;
  ColorMapRed  : array[0..255,0..1] of Byte;
  ColorMapGreen: array[0..255,0..1] of Byte;
  ColorMapBlue : array[0..255,0..1] of Byte;
  ColTabSize   : Integer;
  I, K         : {$IFDEF WINDOWS} LongInt {$ELSE} Integer {$ENDIF} ;
  Red, Blue    : Char;
  {$IFDEF WINDOWS}
  RGBArr       : Packed Array[0..2] OF CHAR ;
  {$ENDIF}
  BmpWidth     : {$IFDEF WINDOWS} LongInt {$ELSE} Integer {$ENDIF} ;
  OffsetXRes     : LongInt;
  OffsetYRes     : LongInt;
  OffsetSoftware : LongInt;
  OffsetStrip    : LongInt;
  OffsetDir      : LongInt;
  OffsetBitsPerSample : LongInt;
  {$IFDEF WINDOWS}
  MemHandle : THandle ;
  MemStream : TMemoryStream ;
  ActPos, TmpPos : LongInt;
  {$ENDIF}
Begin
  BM := Bitmap.Handle;
  if BM = 0 then exit;

  GetDIBSizes(BM, HeaderSize, BitsSize);
  {$IFDEF WINDOWS}
	MemHandle := GlobalAlloc ( HeapAllocFlags, HeaderSize + BitsSize ) ;
  Header := GlobalLock ( MemHandle ) ;
  MemStream := TMemoryStream.Create ;
  {$ELSE}
  GetMem (Header, HeaderSize + BitsSize);
  {$ENDIF}
  try
    Bits := Header + HeaderSize;
    if GetDIB(BM, Bitmap.Palette, Header^, Bits^) then
    begin
      { Read Image description }
      Width     := PBITMAPINFO(Header)^.bmiHeader.biWidth;
      Height    := PBITMAPINFO(Header)^.bmiHeader.biHeight;
      BitCount  := PBITMAPINFO(Header)^.bmiHeader.biBitCount;
      DataWidth := Width;
      if BitCount = 1 then
      begin
        {$IFDEF WINDOWS}
        GlobalUnlock ( MemHandle ) ;
        GlobalFree ( MemHandle ) ;
        MemStream.Free ;
        {$ELSE}
        FreeMem(Header);
        {$ENDIF}
        exit;
      end;
      {$IFDEF WINDOWS}
      { Read Bits into MemoryStream for 16 - Bit - Version }
      MemStream.Write ( Bits^, BitsSize ) ;
      {$ENDIF}

      ColTabSize := (1 shl BitCount);
{     ColTabSize := 1;
      for I:=1 to BitCount do ColTabSize := ColTabSize * 2; }
      BmpWidth := Trunc(BitsSize / Height);

{
			// Image with Color Table
			//================================
}
      if BitCount in [2, 4, 8] then
      begin
       	DataWidth := Width;
     		if BitCount in [2, 4] then
      	begin
 	  { If we have only 2 or 4 bit per pixel, we have to
            truncate the size of the image to a byte boundary }
          Width := (Width div BitCount) * BitCount;
          if BitCount = 2 then DataWidth := Width div 4;
          if BitCount = 4 then DataWidth := Width div 2;
        end;

				DirectoryCOL[1]._Value := LongInt(Width);  	{ Image Width }
        DirectoryCOL[2]._Value := LongInt(abs(Height)); { Image Height }
        DirectoryCOL[3]._Value := LongInt(BitCount); 	{ BitsPerSample }
        DirectoryCOL[8]._Value := LongInt(Height); 	{ Image Height }
				DirectoryRGB[9]._Value := LongInt(BitsSize);  { Strip Byte Counts }

        for I:=0 to ColTabSize-1 do
        begin
          ColorMapRed  [I][1] := PBITMAPINFO(Header)^.bmiColors[I].rgbRed;
          ColorMapRed  [I][0] := 0;
          ColorMapGreen[I][1] := PBITMAPINFO(Header)^.bmiColors[I].rgbGreen;
          ColorMapGreen[I][0] := 0;
          ColorMapBlue [I][1] := PBITMAPINFO(Header)^.bmiColors[I].rgbBlue;
          ColorMapBlue [I][0] := 0;
        end;

        DirectoryCOL[14]._Count := LongInt(ColTabSize*3*2);
      end
      else
	{
    			// Image with RGB-Values
        	//======================
  }
      begin
				DirectoryRGB[1]._Value := LongInt(Width);     { Image Width }
  			DirectoryRGB[2]._Value := LongInt(Height);    { Image Height }
				DirectoryRGB[8]._Value := LongInt(Height);    { Image Height }
        DirectoryRGB[9]._Value := LongInt(3*Width*Height);  { Strip Byte Counts }
      end;
      { Write TIFF - File }

      { Write Image with Color Table
      ================================ }
      if BitCount in [1, 2, 4, 8] then
      begin
        Stream.Write ( TifHeader, sizeof(TifHeader));
        Stream.Write ( ColorMapRed, ColTabSize*2);
        Stream.Write ( ColorMapGreen, ColTabSize*2);
        Stream.Write ( ColorMapBlue, ColTabSize*2);

        OffsetXRes := Stream.Position ;
        Stream.Write ( X_Res_Value, sizeof(X_Res_Value));

        OffsetYRes := Stream.Position ;
        Stream.Write ( Y_Res_Value, sizeof(Y_Res_Value));

        OffsetSoftware := Stream.Position ;
        Stream.Write ( Software, sizeof(Software));

        OffsetStrip := Stream.Position ;
        if Height < 0 then
        begin
          for I:=0 to Height-1 do
          begin
            {$IFNDEF WINDOWS}
            BitsPtr := Bits + I*BmpWidth;
            Stream.Write ( BitsPtr^, DataWidth);
            {$ELSE}
            MemStream.Position := I*BmpWidth;
            Stream.CopyFrom ( MemStream, DataWidth ) ;
            {$ENDIF}
          end;
        end
        else
        begin
        	{ Flip Image }
          for I:=1 to Height do
          begin
            {$IFNDEF WINDOWS}
            BitsPtr := Bits + (Height-I)*BmpWidth;
            Stream.Write ( BitsPtr^, DataWidth);
            {$ELSE}
            MemStream.Position := (Height-I)*BmpWidth;
            Stream.CopyFrom ( MemStream, DataWidth ) ;
            {$ENDIF}
          end;
        end;

          { Set Adresses into Directory }
        DirectoryCOL[ 6]._Value := OffsetStrip; 	{ StripOffset }
        DirectoryCOL[10]._Value := OffsetXRes; 		{ X-Resolution }
        DirectoryCOL[11]._Value := OffsetYRes; 		{ Y-Resolution }
        DirectoryCOL[13]._Value := OffsetSoftware;	{ Software }

	{ Write Directory }
        OffsetDir := Stream.Position ;
        Stream.Write ( NoOfDirs, sizeof(NoOfDirs));
        Stream.Write ( DirectoryCOL, sizeof(DirectoryCOL));
        Stream.Write ( NullString, sizeof(NullString));

	{ Update Start of Directory }
        Stream.Seek ( 4, soFromBeginning ) ;
        Stream.Write ( OffsetDir, sizeof(OffsetDir));
      end
      else
      begin
	{ Write Image with RGB-Values
          =========================== }
        { Write Header }
        Stream.Write ( TifHeader, sizeof(TifHeader));

        OffsetXRes := Stream.Position ;
        Stream.Write ( X_Res_Value, sizeof(X_Res_Value));

        OffsetYRes := Stream.Position ;
        Stream.Write ( Y_Res_Value, sizeof(Y_Res_Value));

        OffsetBitsPerSample := Stream.Position ;
        Stream.Write ( BitsPerSample,  sizeof(BitsPerSample));

        OffsetSoftware := Stream.Position ;
        Stream.Write ( Software, sizeof(Software));

        OffsetStrip := Stream.Position ;

        { Exchange Red and Blue Color-Bits }
        for I:=0 to Height-1 do
        begin
          {$IFNDEF WINDOWS}
          BitsPtr := Bits + I*BmpWidth;
          {$ELSE}
          MemStream.Position := I*BmpWidth ;
          {$ENDIF}
          for K:=0 to Width-1 do
          begin
            {$IFNDEF WINDOWS}
            Blue := (BitsPtr)^ ;
      	    Red  := (BitsPtr+2)^;
    	    	(BitsPtr)^   := Red;
  	    		(BitsPtr+2)^ := Blue;
			      if BitCount = 24
            	then BitsPtr := BitsPtr + 3
              else BitsPtr := BitsPtr + 4;
            {$ELSE}
            MemStream.Read ( RGBArr, SizeOf(RGBArr) ) ;
            MemStream.Seek ( -SizeOf(RGBArr), soFromCurrent ) ;
            Blue := RGBArr[0];
            Red  := RGBArr[2];
            RGBArr[0] := Red;
            RGBArr[2] := Blue;
            MemStream.Write ( RGBArr, SizeOf(RGBArr) ) ;
			      if BitCount = 32 then
            	MemStream.Seek ( 1, soFromCurrent ) ;
            {$ENDIF}
          end;
        end;

        	// If we have 32-Bit Image: skip every 4-th pixel
        if BitCount = 32 then
        begin
	  			for I:=0 to Height-1 do
  	  		begin
           	{$IFNDEF WINDOWS}
           	BitsPtr := Bits + I*BmpWidth;
            TmpBitsPtr := BitsPtr;
          	{$ELSE}
            MemStream.Position := I*BmpWidth ;
            ActPos := MemStream.Position;
            TmpPos := ActPos;
          	{$ENDIF}
            for k:=0 to Width-1 do
            begin
           		{$IFNDEF WINDOWS}
    	    	  (TmpBitsPtr)^   := (BitsPtr)^;
    	    	  (TmpBitsPtr+1)^ := (BitsPtr+1)^;
    	    	  (TmpBitsPtr+2)^ := (BitsPtr+2)^;
              TmpBitsPtr := TmpBitsPtr + 3;
            	BitsPtr    := BitsPtr + 4;
      	    	{$ELSE}
            	MemStream.Seek ( ActPos, soFromBeginning ) ;
            	MemStream.Read ( RGBArr, SizeOf(RGBArr)  ) ;
            	MemStream.Seek ( TmpPos, soFromBeginning ) ;
            	MemStream.Write( RGBArr, SizeOf(RGBArr)  ) ;
              TmpPos := TmpPos + 3;
              ActPos := ActPos + 4;
  	        	{$ENDIF}
	      		end;
          end;
        end;

        if Height < 0 then
        begin
          BmpWidth := Trunc(BitsSize / Height);
	  			for I:=0 to Height-1 do
  	  		begin
            {$IFNDEF WINDOWS}
            BitsPtr := Bits + I*BmpWidth;
            Stream.Write ( BitsPtr^, Width*3 ) ;
            {$ELSE}
            MemStream.Position := I*BmpWidth ;
            Stream.CopyFrom ( MemStream, Width*3 ) ;
            {$ENDIF}
          end;
        end
        else
        begin
	  { Flip Image }
          BmpWidth := Trunc(BitsSize / Height);
          for I:=1 to Height do
          begin
            {$IFNDEF WINDOWS}
            BitsPtr := Bits + (Height-I)*BmpWidth;
						Stream.Write ( BitsPtr^, Width*3 );
            {$ELSE}
            MemStream.Position := (Height-I)*BmpWidth;
            Stream.CopyFrom ( MemStream, Width*3 ) ;
            {$ENDIF}
          end;
        end;

	{ Set Adresses into Directory }
        DirectoryRGB[ 3]._Value := OffsetBitsPerSample;	{ BitsPerSample }
        DirectoryRGB[ 6]._Value := OffsetStrip; 	{ StripOffset }
        DirectoryRGB[10]._Value := OffsetXRes; 		{ X-Resolution }
        DirectoryRGB[11]._Value := OffsetYRes; 		{ Y-Resolution }
        DirectoryRGB[14]._Value := OffsetSoftware; 	{ Software }

	{ Write Directory }
				OffsetDir := Stream.Position ;
				Stream.Write ( NoOfDirs, sizeof(NoOfDirs));
				Stream.Write ( DirectoryRGB, sizeof(DirectoryRGB));
				Stream.Write ( NullString, sizeof(NullString));

	{ Update Start of Directory }
        Stream.Seek ( 4, soFromBeginning ) ;
        Stream.Write ( OffsetDir, sizeof(OffsetDir));
      end;
    end;
  finally
    {$IFDEF WINDOWS}
    GlobalUnlock ( MemHandle ) ;
    GlobalFree ( MemHandle ) ;
    MemStream.Free ;
    {$ELSE}
    FreeMem(Header);
    {$ENDIF}
  end;
end;

procedure WriteTiffToFile ( Filename : string; Bitmap : TBitmap );
VAR Stream : TFileStream ;
BEGIN
  Stream := TFileStream.Create ( FileName, fmCreate ) ;
  TRY
    WriteTiffToStream ( Stream, Bitmap ) ;
  FINALLY
    Stream.Free ;
  END ;
END ;

end.
