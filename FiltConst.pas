//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-1999
//  This File is part of the EliFrac Project
//
//  Modifications :
//   12-12-99 :  Took out my filters, Now Using INTEL's Library (IPL.DLL)
//   10-8-2000:   Removed all filters using intels ipl library.
//               The library is too fuckin big.
//               I'm not using ipl library any more.
//               I'll do the filters my way.
//   9-12-2000:  Moved the const Filters to the EdgeDt and Main Units.
//****************************************************************************************

  
const
fcapt = 'EliFrac';
s1 = 'Open Image File';
s2 = 'Save Image File';
s3 = 'Save Fractal Parameters';
s4 = 'Open Fractal Parameter File';
s5 = 'Open BackGround Photo';
s6 = 'Load Palette';
s7 = 'Save Palette';
s8 = 'EliFrac Palette';
s10 = 'Open L-System File';
s11 = 'Save L-System File';
s12 = 'IFS Parameter File';
VK_PAGEUP   =  33;
VK_PAGEDOWN =  34;
//PALETTESIZE = 256;

REGPLACE         = 'SOFTWARE\Epsilon\EliFrac';
FILENOTSUPPORTED = 'Sorry, File Type Not Supported By Elifrac';
NOPALETTE        = 'This File Does Not Seem To Be A Palette File.';
NOFPR            = 'This File Does Not Seem To Be A Fractal Parameter File.';
NOGRAPHIC        = 'The File Type You Picked Is Not A Valid Graphic Type';
LOADERROR        = 'Error Loading The File:  ';
NO24BITMAP       = 'Bitmap Must Be 24Bit For this Function to Work';
//NOUNDO           = 'There is no Undo for this Operation. Are You Sure You Want To Revert ?';
NOSCANNER        = 'Scanner Support Not Installed on This Computer.'+ #10#13 +
                   'Please Install Imaging from your Windows CD. ';
ERASECLIP        = '   Erase Clipbord Contents?      ';
MAINW            = 'Main Window';
INFOWINDOW       = 'Information Window';
BROWSEWIN        = 'Browse Window';
GLOBAL           = 'Global';
TOOLBAR          =  'ToolBar';
STRANGEATTR      = 'Strange Attractors';
ROSSLER          = 'Rossler Attractor Parameters';
LORENZ           = 'Lorenz Attractor Parameters';
JPGOPT           = 'JPEG Options';
JPPROGDISP       = 'Progressive Display';
JPPROGENCODE     = 'Progressive Encoding';
JPPERFORMANCE    = 'Performance';
JPCOMPQUALITY    = 'Compression Quality';
PALETTEBSC       = 'Palette Building Start Color';
PALETTEBMC       = 'Palette Building Mid Color';
PALETTEBEC       = 'Palette Building End Color';
ZEROEX           = '0,0000000000';
FRACPARAMFILE    = 'Fractal Parameter File';
FRACPARAMFILE2   = '[Fractal Parameter File]';
DLGERROR         = 'Error';
FRACNAM          = 'FRACTAL NAME';
FITERS           = 'Iterations';
GIFOPTIONS       = 'GIF Options';
METAFILEOPTIONS  = 'MetaFile Options';
F74              =  '%7.4f';
F1210            = '%12.10f';
F1817            = '%18.17f';
F109             = '%10.9f';
BadDllLoad = 0;

{lpfilter6 : TElFilter = ((0,1,0),(4,1,0),(1,0,8));         // Blur Filter Divisor = 15  1
lpfilter9 : TElFilter = ((0,-1,0),(-1,5,-1),(0,-1,0));     // Sharpen  Divisor = 1      2
hpfilter2 : TElFilter = ((-1,-1,-1),(-1,9,-1),(-1,-1,-1)); // Sharpen More Divisor = 1  3
hpfilter4 : TElFilter = ((2,-2,-1),(1,2,-1),(2,-2,0));     // Relief / Ανάγλυφο         4
EdgeMask1 : TElFilter = ((-1,0,-1),(0,4,0),(-1,0,-1));     // Edge Detection Mask       5
//*****************************************************************************************

EdgeKirschMask0 : TElFilter = ((5,5,5),(-3,0,-3),(-3,-3,-3)); // Edge Detection Mask 6 East
EdgeKirschMask1 : TElFilter = ((-3,5,5),(-3,0,5),(-3,-3,-3)); // Edge Detection Mask 7 NE
EdgeKirschMask2 : TElFilter = ((-3,-3,5),(-3,0,5),(-3,-3,5)); // Edge Detection Mask 8 North
EdgeKirschMask3 : TElFilter = ((-3,-3,-3),(-3,0,5),(-3,5,5)); // Edge Detection Mask 9 NW
EdgeKirschMask4 : TElFilter = ((-3,-3,-3),(-3,0,-3),(5,5,5)); // Edge Detection Mask 10 West
EdgeKirschMask5 : TElFilter = ((-3,-3,-3),(5,0,-3),(5,5,-3)); // Edge Detection Mask 11 SW
EdgeKirschMask6 : TElFilter = ((5,-3,-3),(5,0,-3),(5,-3,-3)); // Edge Detection Mask 12 South
EdgeKirschMask7 : TElFilter = ((5,5,-3),(5,0,-3),(-3,-3,-3)); // Edge Detection Mask 13 SE
//****************************************************************************************
EdgePrewittMask0 : TElFilter = ((1,1,1),(1,-2,1),(-1,-1,-1)); // Edge Detection Mask 14 East
EdgePrewittMask1 : TElFilter = ((1,1,1),(1,-2,-1),(1,-1,-1)); // Edge Detection Mask 15  NE
EdgePrewittMask2 : TElFilter = ((1,1,-1),(1,-2,-1),(1,1,-1)); // Edge Detection Mask 16 North
EdgePrewittMask3 : TElFilter = ((1,-1,-1),(1,-2,-1),(1,1,1)); // Edge Detection Mask 17 NW
EdgePrewittMask4 : TElFilter = ((-1,-1,-1),(1,-2,1),(1,1,1)); // Edge Detection Mask 18 West
EdgePrewittMask5 : TElFilter = ((-1,-1,1),(-1,-2,1),(1,1,1)); // Edge Detection Mask 19 SW
EdgePrewittMask6 : TElFilter = ((-1,1,1),(-1,-2,1),(-1,1,1)); // Edge Detection Mask 20  South
EdgePrewittMask7 : TElFilter = ((1,1,1),(-1,-2,1),(-1,-1,1)); // Edge Detection Mask 21  SE
//*****************************************************************************************
EdgeSobelMask0 : TElFilter = ((1,2,1),(0,0,0),(-1,-2,-1));  // Edge Detection Mask 22 East
EdgeSobelMask1 : TElFilter = ((2,1,0),(1,0,-1),(0,-1,-2));  // Edge Detection Mask 23 NE
EdgeSobelMask2 : TElFilter = ((1,0,-1),(2,0,-2),(1,0,-1));  // Edge Detection Mask 24 North
EdgeSobelMask3 : TElFilter = ((0,-1,-2),(1,0,-1),(2,1,0));  // Edge Detection Mask 25 NW
EdgeSobelMask4 : TElFilter = ((-1,-2,-1),(0,0,0),(1,2,1));  // Edge Detection Mask 26 West
EdgeSobelMask5 : TElFilter = ((-2,-1,0),(-1,0,1),(0,1,2));  // Edge Detection Mask 27 SW
EdgeSobelMask6 : TElFilter = ((-1,0,1),(-2,0,2),(-1,0,1));  // Edge Detection Mask 28 South
EdgeSobelMask7 : TElFilter = ((0,1,2),(-1,0,1),(-2,-1,0));  // Edge Detection Mask 29 SE
TraceContour   : TElFilter = ((1,1,1),(1,-9,1),(1,1,1));    // Trace Contour. Invert Image after filter  30   }
//customfilter2   : TElFilter = ((1,0,-1),(0,0,0),(1,0,1));    // custom filter

