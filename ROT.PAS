unit rot;

interface


uses windows, Messages,SysUtils, Classes, Forms ,Graphics, Controls;

//procedure set_palette(var start, finish : array of Byte);
//procedure set_palette2(var start, finish : array of Byte);
//procedure set_palette3(var start, middle, finish : array of Byte);
procedure restoredac;
procedure spindac(direction,step : Integer);
procedure win_stop_cycling;
procedure win_savedac;
procedure rgb_dib_palette;
//procedure default_dib_palette;
procedure win_cycle;
procedure DelayMillisecond;
procedure MyPalToDacbox;
//var

implementation

uses Main,Globs;

{
procedure set_palette(var start, finish : array of Byte);
var i,j : Integer;
begin
   dacbox[0][0] := 0; dacbox[0][1] := 0; dacbox[0][2] := 0;
   for i:=1 to 255 do			// fill the palette
      for j := 0 to 2 do
	 dacbox[i][j] := Byte ((i*start[j] + (256-i)*finish[j]) div 255);
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
end;

procedure set_palette3(var start, middle, finish : array of Byte);
var i, j : Integer;
  begin
   dacbox[0][0] := 0; dacbox[0][1] := 0; dacbox[0][2] := 0;
   for i:=1 to 85 do
      for j := 0 to 2 do
        begin
	 dacbox[i][j]	  := Byte ((i*middle[j] + (86-i)*start[j] ) div 85);
	 dacbox[i+85][j]  := Byte ((i*finish[j] + (86-i)*middle[j]) div 85);
	 dacbox[i+170][j] := Byte ((i*start[j]  + (86-i)*finish[j]) div 85);
        end;
end;
}
procedure win_stop_cycling;
//var
//hhDC : hDC;                      // handle to device context
begin
//hhDC := GetDC(GetFocus);
SetSystemPaletteUse(BM.temp.Canvas.Handle,SYSPAL_STATIC);
SetSystemPaletteUse(BM.Canvas.Handle,SYSPAL_STATIC);

//ReleaseDC(GetFocus,hhDC);

time_to_cycle := False;
win_animate_flag := False;
restoredac;
win_systempaletteused := FALSE;
SetSysColors(COLOR_ENDCOLORS, win_syscolorindex, win_syscolorold);
end;

procedure win_savedac;
var i,j : Integer;
begin
  for i := 0 to 255 do
    for j := 0 to 2 do
     olddacbox[i][j] := dacbox[i][j];
 colorpreloaded := True;              // indicate it needs to be restored
end;


procedure rgb_dib_palette;
var
i : Integer;		// fill in the palette index values
begin
    for i := 0 to 255 do
       begin
        pDibInfo.bmiColors[i].rgbRed       := dacbox[i][0] shl 2;
        pDibInfo.bmiColors[i].rgbGreen     := dacbox[i][1] shl 2;
        pDibInfo.bmiColors[i].rgbBlue      := dacbox[i][2] shl 2;
        pDibInfo.bmiColors[i].rgbReserved  := 0;
       end;
end;
{
procedure default_dib_palette;
var
i, k : Integer;		// fill in the palette index values
palette_values : pointer;     // pointer to palette values
begin
    palette_values :=  @pDibInfo.bmiColors[0];
    k := 0;
    for i := 0 to 255 do
     begin
        palette_values[i] := k;
        inc(k);
        if (k >= iNumColors) then
           if (iNumColors > 0) then k := 0;
     end;
end;
}

      {	Color-cycling logic
	includes variable-delay capabilities   }

procedure win_cycle;
var
istep, jstep, fstep, step, oldstep, last, next, maxreg : Integer;
incr, fromred, fromblue, fromgreen, tored, toblue, togreen : Integer;
//hhDC : hDC;		      // handle to device context
begin
fstep := 1;				// randomization frequency
oldstep := 1;				// single-step
step := 256;				// single-step
incr := 999;				// ready to randomize
maxreg := 256;				// maximum register to rotate
last := maxreg-1;			// last box that was filled
next := 1;				// next box to be filled
fromred	:= 1;
fromgreen := 1;
fromblue  := 1;
tored  := 1;
togreen := 1;
toblue  := 1;

if (win_cycledir < 0) then
   begin
    last := 1;
    next := maxreg;
   end;
Randomize;
//srand((unsigned)time(NULL));		/* randomize things		*/
//hhDC := GetDC(GetFocus);
win_animate_flag := True;
SetPaletteEntries(hPal, 0, 256, palx^);
SelectPalette (BM.temp.Canvas.Handle, hPal, true);
SelectPalette (BM.Canvas.Handle, hPal, true);
while (time_to_cycle) do
    begin
    if (win_cyclerand > 0) then
      begin
	for istep := 0 to step-1 do
         begin
	    jstep := next + (istep * win_cycledir);
	    if (jstep <=  0) then jstep := jstep+maxreg-1;
	    if (jstep >= maxreg) then jstep := jstep-maxreg-1;
            inc(incr);
	    if (incr > fstep) then 	// time to randomize
               begin
		incr := 1;
		fstep := (win_fsteps[win_cyclefreq]*random(256))+1; // shr 8)) shr 6) + 1;
		fromred   := dacbox[last][0];
		fromgreen := dacbox[last][1];
		fromblue  := dacbox[last][2];
		tored	  := random(256);
		togreen   := random(256);
		toblue	  := random(256);
	       end;
	    dacbox[jstep][0] := fromred	 + (((tored   - fromred  )*incr) div fstep);
	    dacbox[jstep][1] := fromgreen + (((togreen - fromgreen)*incr) div fstep);
	    dacbox[jstep][2] := fromblue  + (((toblue  - fromblue )*incr) div fstep);
	   end;
	end;
    if (step >= 256) then step := oldstep;

    Application.ProcessMessages; //keypressed();
    if escpressed then
      begin
      working := False;
      escpressed := False;
      time_to_cycle := False;
      exit;
      end;

    spindac(win_cycledir,step);

    DelayCount := 50;

    DelayMillisecond;

    AnimatePalette(hPal, 0, 236, @palx.palPalEntry);
    RealizePalette(BM.temp.Canvas.Handle);
    RealizePalette(BM.Canvas.Handle);
    BM.Invalidate;


    if (win_cyclerand = 2) then
       begin
	win_cyclerand := 1;
	step := 256;
       end;
   end;

win_stop_cycling;
//win_animate_flag := False;
//ReleaseDC(GetFocus,hhDC);
end;


procedure spindac(direction,step : Integer);
var
i, j, k : Integer;
cycle_start, cycle_fin : Integer;
tempdacbox : Byte;
//hhDC : hDC;
begin
cycle_start := 0;
cycle_fin := 255;
if (time_to_cycle) then
  begin
   cycle_start := rotate_lo;
   cycle_fin := rotate_hi;
  end;

for k := 0 to  step-1 do
   begin
    if (direction > 0) then
       begin
	for j := 0 to 2 do
           begin
	    tempdacbox := dacbox[cycle_fin][j];
	    for i := cycle_fin downto cycle_start-1 do
		dacbox[i][j] := dacbox[i-1][j];
	    dacbox[cycle_start][j] := tempdacbox;
	   end;
       end;
    if (direction < 0) then
      begin
	for  j := 0 to 2 do
           begin
	    tempdacbox := dacbox[cycle_start][j];
	    for i := cycle_start to cycle_fin-1 do
		dacbox[i][j] := dacbox[i+1][j];
	    dacbox[cycle_fin][j] := tempdacbox;
	   end;
      end;
   end;

 // fill in intensities for all palette entry colors
    for i := 0 to 255 do
       begin
	palx.palPalEntry[i].peRed    := (Byte (dacbox[i][0])) shl 2;
	palx.palPalEntry[i].peGreen  := (Byte (dacbox[i][1])) shl 2;
	palx.palPalEntry[i].peBlue   := (Byte (dacbox[i][2])) shl 2;
	palx.palPalEntry[i].peFlags  := PC_RESERVED;
       end;
     Application.ProcessMessages; //keypressed();
    if escpressed then
      begin
      working := False;
      escpressed := False;
      time_to_cycle := False;
      exit;
      end;

    if (  win_animate_flag) then
     begin
        //hhDC := GetDC(GetFocus);
	SetPaletteEntries(hPal, 0, palx.palNumEntries, palx.palPalEntry);
        SelectPalette (BM.temp.Canvas.Handle, hPal, true);
	RealizePalette(BM.temp.Canvas.Handle);
	SelectPalette (BM.Canvas.Handle, hPal, true);
	RealizePalette(BM.Canvas.Handle);
        BM.Invalidate;
	//ReleaseDC(GetFocus,hhDC);
        // for non-palette-based adapters, redraw the image
       //	if ( not iRasterCaps) then
       //     InvalidateRect(BM.Handle, NULL, FALSE);
    end;
end;

procedure restoredac;
var
iLoop,j : Integer;
begin
   // fill in intensities for all palette entry colors
    for iLoop := 0 to PALETTESIZE-1 do
	for j := 0 to  2 do
	    dacbox[iLoop][j] := win_dacbox[iLoop][j];
    spindac(0,1);
end;

procedure DelayMillisecond;
var
i : DWORD;
begin
   i := 0;
   while(i <> DelayCount) do inc(i);
end;

procedure MyPalToDacbox;
var i : Integer;
begin
 for i := 0 to 255 do
   begin
    dacbox[i][0] := GetRvalue(ColorToRGB(pal[i]));
    dacbox[i][1] := GetGvalue(ColorToRGB(pal[i]));
    dacbox[i][0] := GetBvalue(ColorToRGB(pal[i]));
   end;
end;

end.
