unit Main;
//******************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//
//  Modifications :
//  6-2-98  : Completed Reading and Saving Jpeg Images.
//  8-2-98  : Adjust All Routines that used to work with BMP's to work with JPG's too.
//  12-2-98 : No more iniFile. Now Writing and Reading The Registry.
//  16-2-98 : Added GIF File Support [ Open,Revert ] Still have to do the rest of the
//            Routines that use BMP's. ....... DONE !!!
//  16-2-98 : Modified OpenFile and Revert To Change Size according to New Image's size.
//            If Image is Larger than Screen Width or Height The Window Gets the screen's
//            size and the Image is Painted Stretched.
//  22-2-98 : Added FIF File Support [ Open,Revert ].
//  7-3-98  : Save Strange Attractors In Parameter File.
//          : Created and Tested A ToolBar.
//  29-3-98 : ToolBar Works Just Fine now.
//          : Changed some Commands from the Options Menu to the View Menu.
//          : Removed Help Form.
//  1-6-98  : Open FPR,LSM,IFS Files As Command Line Parameters.
//            Auto Associate on Setup.
//            View Fractal.avi Function On View Menu.
//  5-9-98  : Added Menu Option to Toggle Timer ON/OFF
//  29-9-98 : Corrected a minor bug in window resizing that caused a revert when
//            it was not wanted.
//  10-10-98 : Started writing a Help File in HTML Format.
//             Added Internal HTML Reader.
//  15-10-98 : Fixed procedure "RotateImage". Now runs faster and does not leave holes
//             unpainted when angle is not 90,180,270 deg.
//  16-10-98 : Added Two New Drawing Modes : "Split Screen" and "Interlace"
//  16-10-98 : Added Configuration of Split Screen with 24 different drawing styles.
//             On a separate form.
//  16-10-98 : Load All Kinds of Parameter Files (FPR,LSM,IFS) From the main Menu.
//  17-10-98 : Added Haley Map Fractal with 12 preset Functions.
//             The Functions are of the type :  { X^n - 1 = 0 }
//  20-10-98 : Form ProgBar Removed from project. Progress Bar now showing in Info Window.
//  20-10-98 : Made All Fractals show progress on the Info window
//             Speeded Up the Pixel Suffling Algorithm for all Fractals.
//             Also a lot of minor Adjustments to the old Code.
//  21-10-98 : Added Text Editing For Parameter Files through NotePad from the Edit Menu.
//  21-10-98 : Finally Made the PLASMA to work correctly.
//             The algorithm was using palette indexes and I was using palette colors.
//  22-25/10/98 :  Deleted the old low pass and high pass filters, and added all the
//                 Filters now showing on the Filter Menu.
//                 Rewrote most of the code (Now is FASTER)
//  26-10-98 :  Added Drag and Drop Graphic and Parameter Files from the Explorer
//  27-10-98 :  Added TGA and PCX file support (reading only for now)
//  5-11-98  :  Deleted the HTML Help File and internal reader routine.
//  17-1-99  :  Added Internal Text Editor For Parameter Files.
//              Choose between Internal Editor and Notepad from the Options Menu.
//  4-3-99   :  Started writing a Help File.
// 12-4-99   :  Walking The Fractals is now a fact.
// 13-4-99   :  Added ZoomOut functionality by Alt+PgUp & AltPgDown.
// 18-4-99   :  Added Circle and Triangle Window Regions On the Window Menu.
//              The Main Window can take any Shape. I will try some when I have time.
// 23-4-99   :  Added Color Cycling in True color (24bit) with the current palette.
//              Color Cycling routine based on a routine by Earl F. Glynn, Copyright (C) 1998.
// 24-4-99   :  ReWrote All Filter Functions using Memory Bitmaps and ScanLines.
//              The Result of the filter is now Instant.
// 1-5-99    :  Changed my Gif Library. Now Using Anders Melander's TGifImage Library.
//           :  Can Save Gifs Now. The Library supports Gif Animation and I will try
//           :  to support animation in the Main Window. It Already Works in the Browse Window.
// 2-5-99    :  Took out Targa and PCX file support. Until I find a better Library
// 12-12-99  :  Start Using INTEL's IPL (Image Library)
//              Deleted my own filters and deformations.
// 18-12-99  :  Added PNG Support (reading only for now)
//              support it in every open picture function and the browser.
//              Now how do I save bitmap to a PNG file ?
// 21-05-2000:  After six months I'm back with programming.
//              Added PNG support in the "open background picture".
//              Fixed some filter dialogs where the scrollbars were screwing up.
// 13-7-2000:   Resume Drawing on an unfinished Fractal (Only for Normal Drawing Mode For Now)
//              Step 1. Save Unfinished Image with Parameters.
//              Step 2. Later On, Load Image and Just Press Enter To Continue from the point
//                      we stopped last time.
//              !!! All Needs To Be Done In the Normal Drawing Mode.
//              Also Done for Oposite Half, Curtain, HelixCoil, Drawing Methods. 13-7-2000
// 2-8-2000:     Can Save Png Files now. Using Jack Goman's PngUnit jack@SharePower.VirtualAve.net
//
// 10-8-2000:   Removed all filters using intels ipl library.
//              The library is too fuckin big.
//              I'm not using ipl library any more.
//              I'll do the filters my way.
// 7-12-2000:   Supporting TIF Images now. Open and Save. ( Uncompressed Only For now).
//******************************************************************************************
//                            TO DO
//  1. Corect the bug that doesn't let walking be done after a picture load.   Done 13-4-99
//  2. Test all the functions of the program for bugs after all the code changes
//     and additions. There could be interactions that I haven't thought of.
//     ... Found a bug that didn't allow zoom in after a picture load with params
//         Corrected 17-4-99    Haven't seen any more bugs.
//  3. Try to save unfinished fractal picture and params and continue from the point
//     that we stopped later on after a load. Done 13-7-2000
//  4. Support Scanners. Now that I have one. Done 21-5-2000
//*****************************************************************************************
interface

uses
  Windows, System.UITypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Jpeg, {fif, GIFImage,} ExtDlgs, {filedrag, PageSetup,} ExtCtrls, MPlayer,
  IniFiles, Registry, StdCtrls, Buttons, {ipl2, Iplfunc2,PngImage,PngUnit,} OleCtrls;
  {ScanLibCtl_TLB;}


//{$DEFINE Building}
type
TElFilter = array[0..2,0..2] of shortint;
Telem = array[0..8] of tagRGBTRIPLE;

const
MaxPixelCount = 65536;

lpfilter6 : TElFilter = ((0,1,0),(4,1,0),(1,0,8));         // Blur Filter Divisor = 15  1
lpfilter9 : TElFilter = ((0,-1,0),(-1,5,-1),(0,-1,0));     // Sharpen  Divisor = 1      2
hpfilter2 : TElFilter = ((-1,-1,-1),(-1,9,-1),(-1,-1,-1)); // Sharpen More Divisor = 1  3
hpfilter4 : TElFilter = ((2,-2,-1),(1,2,-1),(2,-2,0));     // Relief / Ανάγλυφο         4

type
// TReal       = Single;
    // use SysUtils.pByteArray for pf8bit Scanlines
    // For pf24bit Scanlines
 //pRGBTripleArray = ^TRGBTripleArray;
 //TRGBTripleArray = array[0..MaxPixelCount-1] of TRGBTriple;

    // for pf32bit Scanlines
// pRGBQuadArray = ^TRGBQuadArray;
// TRGBQuadArray = array[0..MaxPixelCount-1] of TRGBQuad;
// pSingleArray  = ^TSingleArray;
// TSingleArray  = array[0..MaxPixelCount-1] of TReal;

//type
 pRGBArray  =  ^TRGBArray;    // Use SysUtils.pByteArray for 8-bit color
 TRGBArray  =  array[0..MaxPixelCount-1] of TRGBTriple;

//type
 // TDrawingTool = (dtNone,dtLine,dtFree, dtRectangle, dtEllipse, dtRoundRect,dtText,dtFill);
  palete = array[0..255] of LongInt;
 // TElFilter = array[0..2,0..2] of shortint;
  Complex = record
   real : Extended;
   img  : Extended;
  end;

  TFColor  = record r,g,b:Byte end;
  PFColor  =^TFColor;
  TLine    = array[0..0]of TFColor;
  PLine    =^TLine;
  TPLines  = array[0..0]of PLine;
  PPLines  =^TPLines;

  TBM = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    TypesMenu1: TMenuItem;
    About1: TMenuItem;
    Reset1: TMenuItem;
    Parameters: TMenuItem;
    PSave: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    POpen: TMenuItem;
    SaveBMP: TMenuItem;
    ClearScreen1: TMenuItem;
    SndMenu: TMenuItem;
    OpenBMP: TMenuItem;
    About2: TMenuItem;
    ImageMenu: TMenuItem;
    InvertImage1: TMenuItem;
    LdCombImage: TMenuItem;
    Print1: TMenuItem;
    PrintDialog: TPrintDialog;
    clrback: TMenuItem;
    BackgrndBMP: TMenuItem;
    MirorImage1: TMenuItem;
    MirorImage2: TMenuItem;
    EditMenu: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    ClearClipboard1: TMenuItem;
    N6: TMenuItem;
    View1: TMenuItem;
    FullScreen1: TMenuItem;
    BackgrndColorMenu: TMenuItem;
    ColorDialog1: TColorDialog;
    N8: TMenuItem;
    N10: TMenuItem;
    CosSet1: TMenuItem;
    SineSet1: TMenuItem;
    MandelbrotSet1: TMenuItem;
    JuliaSet1: TMenuItem;
    Timer1: TTimer;
    MandelOrbits1: TMenuItem;
    FilledOrbits1: TMenuItem;
    Window1: TMenuItem;
    N300: TMenuItem;
    N400: TMenuItem;
    N500: TMenuItem;
    N640: TMenuItem;
    N320: TMenuItem;
    N800: TMenuItem;
    N1024: TMenuItem;
    OtherSize: TMenuItem;
    RotateByAngle1: TMenuItem;
    SierpMenu: TMenuItem;
    Revert1: TMenuItem;
    N2: TMenuItem;
    BackGroundDegrade1: TMenuItem;
    AddBMPFile1: TMenuItem;
    SubtractBMP1: TMenuItem;
    HyperCos1: TMenuItem;
    HyperSine1: TMenuItem;
    LSystems1: TMenuItem;
    IFS1: TMenuItem;
    ExponentSet1: TMenuItem;
    Filters1: TMenuItem;
    Puzzle1: TMenuItem;
    Puzzle2: TMenuItem;
    N14: TMenuItem;
    Undo1: TMenuItem;
    CenterWindow1: TMenuItem;
    N16: TMenuItem;
    EditPalette1: TMenuItem;
    FlipandMiror1: TMenuItem;
    N17: TMenuItem;
    MakeWallPaper1: TMenuItem;
    StrangeAttractors1: TMenuItem;
    Rossler1: TMenuItem;
    Lorenz1: TMenuItem;
    Magnets1: TMenuItem;
    BarnsleysFractal1: TMenuItem;
    LegendreFractal1: TMenuItem;
    Tchebychev1: TMenuItem;
    T51: TMenuItem;
    T31: TMenuItem;
    N19: TMenuItem;
    C61: TMenuItem;
    FontDialog1: TFontDialog;
    N3: TMenuItem;
    N5: TMenuItem;
    JuliaSet2: TMenuItem;
    VideoClip1: TMenuItem;
    Plasma: TMenuItem;
    TimerMenu: TMenuItem;
    N13: TMenuItem;
    Halley1: TMenuItem;
    SelectSplitScreenFunctionOrder1: TMenuItem;
    EditParam: TMenuItem;
    N21: TMenuItem;
    Texture1: TMenuItem;
    MonoRed1: TMenuItem;
    MonoGreen1: TMenuItem;
    MonoBlue1: TMenuItem;
    N22: TMenuItem;
    GreyFilter1: TMenuItem;
    MonoCyan1: TMenuItem;
    MonoMagenda1: TMenuItem;
    MonoYellow1: TMenuItem;
    ChromaFilter1: TMenuItem;
    Rainbow1: TMenuItem;
    Horizontal2: TMenuItem;
    VerticalRainbow1: TMenuItem;
    MakeItGray: TMenuItem;
    Land3d: TMenuItem;
    FileEditMenu: TMenuItem;
    MartinMenu: TMenuItem;
    UnityMenu: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    Video: TMediaPlayer;
    N9: TMenuItem;
    HelpContents1: TMenuItem;
    HelpOnHelp1: TMenuItem;
    HelpMain1: TMenuItem;
    BifMenu: TMenuItem;
    ProgBarMenu: TMenuItem;
    New1: TMenuItem;
    N11: TMenuItem;
    N4: TMenuItem;
    Circle1: TMenuItem;
    PopupMenu1: TPopupMenu;
    CircleWindow1: TMenuItem;
    NormalWindow1: TMenuItem;
    N23: TMenuItem;
    FractalType1: TMenuItem;
    PopupMenu2: TPopupMenu;
    BarnsleysFractal3: TMenuItem;
    CosineSet2: TMenuItem;
    ExponentSet3: TMenuItem;
    HyperbolicCosineSet2: TMenuItem;
    HyperbolicSineSet2: TMenuItem;
    IFSIteratedFunctionSystems2: TMenuItem;
    JuliaSet4: TMenuItem;
    OrbitsOfMandelbrotSet2: TMenuItem;
    FilledOrbitsOfMandelbrotSet2: TMenuItem;
    LegendreFractal3: TMenuItem;
    LSystems3: TMenuItem;
    Magnets3: TMenuItem;
    MandelbrotSet3: TMenuItem;
    SineSet3: TMenuItem;
    SierpinskiTriangle2: TMenuItem;
    StrangeAttractors3: TMenuItem;
    Lorenz3: TMenuItem;
    Rossler3: TMenuItem;
    Tchebychev3: TMenuItem;
    C63: TMenuItem;
    N25: TMenuItem;
    T53: TMenuItem;
    T33: TMenuItem;
    JuliaSetMappedOnTheMandelbrot2: TMenuItem;
    PlasmaDisplay2: TMenuItem;
    HalleyMap2: TMenuItem;
    N3DMountains2: TMenuItem;
    MartinFractal2: TMenuItem;
    UnityFractal2: TMenuItem;
    Bifurcation2: TMenuItem;
    FractalCirclePatternsUseWithOutsideColor2: TMenuItem;
    SpecialFractalParameters1: TMenuItem;
    GeneralParameters1: TMenuItem;
    ResetFractalParameters1: TMenuItem;
    Lamda1: TMenuItem;
    Lamda2: TMenuItem;
    N12: TMenuItem;
    GODrawSelectedFractal1: TMenuItem;
    N24: TMenuItem;
    ColorCycle1: TMenuItem;
    WalkMenu: TMenuItem;
    WalkTheFractal1: TMenuItem;
    WalkModeOFF1: TMenuItem;
    Color1: TMenuItem;
    CountColors1: TMenuItem;
    N27: TMenuItem;
    ColorCycling1: TMenuItem;
    ColorCycling2: TMenuItem;
    PaletteColorCycling1: TMenuItem;
    AllPalettes: TMenuItem;
    LoadAllPalettesAndCycle1: TMenuItem;
    CreateLargeDiskImage1: TMenuItem;
    N15: TMenuItem;
    BioMorphJulia1: TMenuItem;
    BioMorphJulia2: TMenuItem;
    LoadPalette: TMenuItem;
    SavePalette: TMenuItem;
    KeyboardShortcuts1: TMenuItem;
    //OpenGIFAnimation1: TMenuItem;
    Image: TImage;
    Newton1: TMenuItem;
    N26: TMenuItem;
    RGBToCMY1: TMenuItem;
    RGBToYIQ: TMenuItem;
    RGBTOYUV1: TMenuItem;
    RGBToYCrCb1: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    Contrast1: TMenuItem;
    AddColorNoise1: TMenuItem;
    RGBMenu1: TMenuItem;
    Newton2: TMenuItem;
    Saturation1: TMenuItem;
    Lightness1: TMenuItem;
    Timer2: TTimer;
    N30: TMenuItem;
    N31: TMenuItem;
    //SaveScannedImage1: TMenuItem;
    //DeleteScannedImagefromMemory1: TMenuItem;
    SetFractalFinished1: TMenuItem;
    Spider1: TMenuItem;
    Smiley1: TMenuItem;
    MandelFlower1: TMenuItem;
    Spider2: TMenuItem;
    MandelFlower2: TMenuItem;
    Smiley2: TMenuItem;
    Twist1: TMenuItem;
    N32: TMenuItem;
    Shift1: TMenuItem;
    ShiftRight1: TMenuItem;
    XorVal: TMenuItem;
    OrValue1: TMenuItem;
    AndValue1: TMenuItem;
    AddValue1: TMenuItem;
    SubtractValue1: TMenuItem;
    SubtractFromValue1: TMenuItem;
    Threshold1: TMenuItem;
    FishEye1: TMenuItem;
    AddMonoNoise1: TMenuItem;
    GaussianBlur1: TMenuItem;
    RGBToCMYK1: TMenuItem;

    //****************************************************************
    procedure FormResize(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure ParametersClick(Sender: TObject);
    procedure BMMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PSaveClick(Sender: TObject);
    procedure POpenClick(Sender: TObject);
    procedure clrscr;
    procedure cross;
    procedure clearchecked;
    procedure ClearScreen1Click(Sender: TObject);
    procedure BMPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SndMenuClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SaveBMPClick(Sender: TObject);
    procedure OpenBMPClick(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure InvertImage1Click(Sender: TObject);
    procedure LdCombImageClick(Sender: TObject);
    procedure BackgrndBMPClick(Sender: TObject);
    procedure clrbackClick(Sender: TObject);
    procedure Print1Click(Sender: TObject);
//    procedure PrinterSetUp1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadPaletteClick(Sender: TObject);
    procedure MirorImage1Click(Sender: TObject);
    procedure MirorImage2Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure ClearClipboard1Click(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure BackgrndColorMenuClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
    procedure CosSet1Click(Sender: TObject);
    procedure MandelbrotSet1Click(Sender: TObject);
    procedure SineSet1Click(Sender: TObject);
    procedure JuliaSet1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MandelOrbits1Click(Sender: TObject);
    procedure FilledOrbits1Click(Sender: TObject);
    procedure N300Click(Sender: TObject);
    procedure N400Click(Sender: TObject);
    procedure N500Click(Sender: TObject);
    procedure N1024Click(Sender: TObject);
    procedure N800Click(Sender: TObject);
    procedure N640Click(Sender: TObject);
    procedure N320Click(Sender: TObject);
    procedure OtherSizeClick(Sender: TObject);
    procedure SavePaletteClick(Sender: TObject);
    procedure RotateByAngle1Click(Sender: TObject);
    procedure SierpMenuClick(Sender: TObject);
    procedure Revert1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Vertical1Click(Sender: TObject);
    procedure BackGroundDegrade1Click(Sender: TObject);
    procedure AddBMPFile1Click(Sender: TObject);
    procedure SubtractBMP1Click(Sender: TObject);
    procedure HyperCos1Click(Sender: TObject);
    procedure HyperSine1Click(Sender: TObject);
    procedure IFS1Click(Sender: TObject);
    procedure LSystems1Click(Sender: TObject);
    procedure ExponentSet1Click(Sender: TObject);
//*****************************************************************************
//    procedure Blur1Click(Sender: TObject);
//    procedure Sharpen1Click(Sender: TObject);
//    procedure SharpenMore1Click(Sender: TObject);
//    procedure Relief1Click(Sender: TObject);
//    procedure MedianFilter1Click(Sender: TObject);
//******************************************************************************
    procedure Puzzle1Click(Sender: TObject);
    procedure Puzzle2Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Undo1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CenterWindow1Click(Sender: TObject);
    procedure EditPalette1Click(Sender: TObject);
    procedure FlipandMiror1Click(Sender: TObject);
//    procedure Browse1Click(Sender: TObject);
    procedure Center1Click(Sender: TObject);
    procedure JPEGOptions1Click(Sender: TObject);
//    procedure PageSetUp1Click(Sender: TObject);
//    procedure N8BitColor1Click(Sender: TObject);
//    procedure N8BitGrayScale1Click(Sender: TObject);
//    procedure N15BitColor1Click(Sender: TObject);
//    procedure N24BitColor1Click(Sender: TObject);
    procedure Rossler1Click(Sender: TObject);
    procedure Lorenz1Click(Sender: TObject);
    procedure Magnets1Click(Sender: TObject);
    procedure BarnsleysFractal1Click(Sender: TObject);
    procedure LegendreFractal1Click(Sender: TObject);
    procedure T51Click(Sender: TObject);
    procedure T31Click(Sender: TObject);
    procedure C61Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
//    procedure ShowTools1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure JuliaSet2Click(Sender: TObject);
    procedure VideoClip1Click(Sender: TObject);
    procedure VideoClick(Sender: TObject; Button: TMPBtnType; var DoDefault: Boolean);
    procedure PlasmaClick(Sender: TObject);
    procedure TimerMenuClick(Sender: TObject);
    procedure Halley1Click(Sender: TObject);
    procedure SelectSplitScreenFunctionOrder1Click(Sender: TObject);
    procedure EditParamClick(Sender: TObject);
    procedure Texture1Click(Sender: TObject);
    procedure MonoCyan1Click(Sender: TObject);
//    procedure EmbossMenuClick(Sender: TObject);
//    procedure SobelMenuClick(Sender: TObject);
//    procedure FileDrag1Drop(Sender: TObject);
    procedure Horizontal2Click(Sender: TObject);
    procedure VerticalRainbow1Click(Sender: TObject);
    procedure MakeItGrayClick(Sender: TObject);
//    procedure MetaStrechClick(Sender: TObject);
//    procedure ClearWind1Click(Sender: TObject);
    procedure Land3dClick(Sender: TObject);
    procedure FileEditMenuClick(Sender: TObject);
    procedure MartinMenuClick(Sender: TObject);
    procedure UnityMenuClick(Sender: TObject);
    procedure HelpContents1Click(Sender: TObject);
    procedure HelpOnHelp1Click(Sender: TObject);
    procedure HelpMain1Click(Sender: TObject);
    procedure BifMenuClick(Sender: TObject);
    procedure ProgBarMenuClick(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure WalkTheFractal1Click(Sender: TObject);
    procedure WalkModeOFF1Click(Sender: TObject);
    procedure Circle1Click(Sender: TObject);
   // procedure Triangle1Click(Sender: TObject);
    procedure NormalWindow1Click(Sender: TObject);
    procedure FractalType1Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure Lamda1Click(Sender: TObject);
    procedure GODrawSelectedFractal1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ColorCycling1Click(Sender: TObject);
    procedure CountColors1Click(Sender: TObject);
    procedure ColorCycling2Click(Sender: TObject);
    procedure AllPalettesClick(Sender: TObject);
    procedure CreateLargeDiskImage1Click(Sender: TObject);
    procedure BioMorphJulia1Click(Sender: TObject);
//    procedure RLE1Click(Sender: TObject);
//    procedure LZW1Click(Sender: TObject);
//    procedure NearestColor1Click(Sender: TObject);
//    procedure ErrorDifusion1Click(Sender: TObject);
//    procedure N256colors1Click(Sender: TObject);
//    procedure N128colors1Click(Sender: TObject);
//    procedure N64colors1Click(Sender: TObject);
//    procedure N32colors1Click(Sender: TObject);
//    procedure N16colors1Click(Sender: TObject);
//    procedure N8colors1Click(Sender: TObject);
//    procedure None1Click(Sender: TObject);
//    procedure WindowsSys20Click(Sender: TObject);
//    procedure WindowsHalftoneClick(Sender: TObject);
//    procedure WindowsGray4Click(Sender: TObject);
//    procedure BlackWhiteClick(Sender: TObject);
//    procedure Gray256Click(Sender: TObject);
//    procedure Netscape216Click(Sender: TObject);
//    procedure OptimizedWinClick(Sender: TObject);
//    procedure Optimized1Click(Sender: TObject);
    procedure KeyboardShortcuts1Click(Sender: TObject);
//    procedure MoreAboutEliFrac1Click(Sender: TObject);
//    procedure OpenGIFAnimation1Click(Sender: TObject);
//    procedure ImageClick(Sender: TObject);
//    procedure ImageDblClick(Sender: TObject);
//    procedure equalizeMenuClick(Sender: TObject);
//    procedure LaplasMenuClick(Sender: TObject);
   // procedure ThresholdMenuClick(Sender: TObject);
   // procedure LogarithmicMenuClick(Sender: TObject);
   // procedure ExponentFilterMenuClick(Sender: TObject);
//    procedure HyperFilterMenuClick(Sender: TObject);
   // procedure IntensifyMenuClick(Sender: TObject);
//    procedure ArithmeticMenuClick(Sender: TObject);
//    procedure MaxFilterMenuClick(Sender: TObject);
//    procedure MinFilterMenuClick(Sender: TObject);
//    procedure ErodeMenuClick(Sender: TObject);
//    procedure DialateMenuClick(Sender: TObject);
//    procedure OpenFilterMenuClick(Sender: TObject);
//    procedure CloseFilterMenuClick(Sender: TObject);
    procedure Newton1Click(Sender: TObject);
    procedure RGBToCMY1Click(Sender: TObject);
//    procedure RGBToHLS1Click(Sender: TObject);
    procedure RGBToYIQClick(Sender: TObject);
    procedure RGBTOYUV1Click(Sender: TObject);
    procedure RGBToYCrCb1Click(Sender: TObject);
//    procedure Spray1Click(Sender: TObject);
    procedure Contrast1Click(Sender: TObject);
    procedure AddColorNoise1Click(Sender: TObject);
    procedure RGBMenu1Click(Sender: TObject);
    procedure Saturation1Click(Sender: TObject);
    procedure Lightness1Click(Sender: TObject);
    procedure Twist1Click(Sender: TObject);
//    procedure RememberLastDir1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    //procedure SelectScanner1Click(Sender: TObject);
    //procedure AquireImage1Click(Sender: TObject);
    //procedure ScannerPreferences1Click(Sender: TObject);
    //procedure ShowScanOptions1Click(Sender: TObject);
    //procedure ScannedImage1Click(Sender: TObject);
    //procedure SaveScannedImage1Click(Sender: TObject);
    //procedure DeleteScannedImagefromMemory1Click(Sender: TObject);
    procedure SetFractalFinished1Click(Sender: TObject);
    procedure Spider1Click(Sender: TObject);
    procedure Smiley1Click(Sender: TObject);
    procedure MandelFlower1Click(Sender: TObject);
    procedure CustomFilterMenuClick(Sender: TObject);
//    procedure EdgeDetection1Click(Sender: TObject);
    procedure Shift1Click(Sender: TObject);
    procedure ShiftRight1Click(Sender: TObject);
    procedure XorValClick(Sender: TObject);
    procedure OrValue1Click(Sender: TObject);
    procedure AndValue1Click(Sender: TObject);
    procedure AddValue1Click(Sender: TObject);
    procedure SubtractValue1Click(Sender: TObject);
    procedure SubtractFromValue1Click(Sender: TObject);
    procedure Threshold1Click(Sender: TObject);
//    procedure ExChRGBClick(Sender: TObject);
//    procedure Mosaic1Click(Sender: TObject);
    procedure FishEye1Click(Sender: TObject);
//    procedure Emboss1Click(Sender: TObject);
    procedure Deform1Click(Sender: TObject);
    procedure AddMonoNoise1Click(Sender: TObject);
    procedure GaussianBlur1Click(Sender: TObject);
    procedure RGBToCMYK1Click(Sender: TObject);
//    procedure Median1Click(Sender: TObject);
//    procedure FormClick(Sender: TObject);

  private
      { Private declarations }
    OrginalRgn : HRGN;
    NormalRgn : Boolean;
    Moving : Boolean;
		Original_x, Original_y: Integer;
		FProperty1: Integer;
		procedure SetProperty1(val: Integer);
	public
     temp: TBitmap;
     original : TBitmap;
     procedure ProgUpdate(Sender: TObject; Stage: TProgressStage;
               PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
     {procedure UpdateProgressBar(Sender: TObject; Action: TProgressAction;
               PercentComplete: Longint); }
     procedure RotateImage(Angle2 : Extended);
    // procedure DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
     procedure OpenCommandLineParam(Fnm: String);
     procedure LoadTexture;
     procedure StUpdate;
     procedure Go;
     procedure show9times;
     procedure show4times;
     procedure XorApply;
     procedure OrApply;
     procedure AndApply;
     procedure AddApply;
     procedure SubtractValApply;
     procedure SubtractFromValApply;
     procedure DrawFace({bm : TBitmap;} pen_width : Integer);
     procedure ApplyFilter(d : Integer ; filter : TElFilter );
     procedure ApplyMedianFilter;
     procedure ApplyFishEye(Amount:Extended);
     procedure ApplyEmboss;
		procedure TwistApply(Amount: Integer);
		property Property1: Integer read Original_y write SetProperty1;
		//*************************** INTEL Image Prossesing Library *********************
    // procedure Process(fun : TProcessingFunction2);
    // procedure ProcessWithResizing(ProcFun : TProcessingFunction2; SizeFunc : TSizingFunction);
  end;

{$INCLUDE FiltConst}     // Include File FiltConst.pas

var
  BM: TBM;            // Main Window Form.
  un     : TBitmap;   // The Undo Bmp.
  //Txtbmp : TBitmap;   // The Text Bitmap.
  MF     : TMetaFile; // The Metafile.
  MFCanvas : TMetafileCanvas; // The Metafile Canvas.
  c,z    : Complex;   // complex variables to use with the fractals.
  z2,z3,z4,z5,z6,z7,exz,c3 : Complex;    // complex variables to use with LegendrePoly
  comptemp1,comptemp2 : Complex;
  xsq,ysq,xy : Extended;
  Xr,Xim,Yr,Yim,Br,BIm,    // Special Parameters for starting values of z or c .
  CosXr,CosXim,SinXr,SinXim,LamdaR,LamdaIm,
  T5r,T5im : Extended; // Special Parameters for starting values of z or c .
  pal    : palete;    // My Palette for my usage.
  RED1,GREEN1,BLUE1 : Byte;  // r,g,b, color variables.
  PalStartColor,PalMidColor,PalEndColor : TColor;  // Edit Palette Building colors.
  HalleyBailOut: Extended;
  MAngle : Extended;
  PaletteName : String;
  Initiating : boolean = True;
  Ifsflag  : boolean = True;
  Lsysflag : boolean = True;
  ComingFromBrowse : boolean = False;
  LoadwithBMPFlag : boolean = false;
  ContJul : boolean = false;
  Infovis : Boolean;  // Is Info Window visible?
  BrushStyle: TBrushStyle;
  PenStyle: TPenStyle;
  PenWide: Integer;
 // Drawing: Boolean;
  JustCenter : Boolean = False;
  Origin, MovePt: TPoint;
 // DrawingTool: TDrawingTool;
  Julx,July : Extended;
  DrMethod,SplitOrder,ColMode : Integer;
  ThisColor : Integer;
  colorindex,HallFunction,OutsideColor : Integer;
  ClFl,ColorIntens,IntR,IntG,IntB : ShortInt;
  whichfilter : Integer;
  customdenom,den : Integer;
  Droped,WalkMode,ProgressBarOn,TimerOn,
  SoundOn,HQ : Boolean;
  WhatFractal : Shortint;
  stepiter : Integer;
  tMax : Integer = 30000;
  MartinIterations : Integer = 300000;
  tcan: TCanvas;
//*************************************************************************************
WIDTH, HEIGHT : Integer;
WinMovable : boolean;
CyclingNow : boolean;
node:  pRGBTriple;
ColorList,TrueColorColorList :  TList;
CycleStart:  Integer;
DoChangePalette : boolean;
DoTrueColor : boolean;
LargeDiskImage : boolean;
LargeBitmap: TBitmap;
Lrgb   :  pRGBArray;
LargeBitmapX,LargeBitmapY: Integer;
AnimStopped : Boolean;
//preview : boolean; // for use with IPL filters
RowRGB : pRGBArray;
FractalCompleted : Boolean;
value2,nfn: integer; //Enter Value Unit Xor,Or Filters.
zero  : TRGBTRiple= (); // initialize to zeros.

//Global_KeepTrueFormat: Word = 2;  // For PCX Files.
//amnt: integer;

{$INCLUDE Complx.h}     // Include File Complx.h

Procedure InitPalete;
procedure CopyUndoBmp;
procedure FastLoadPal;
procedure FindColorIndex(x: Integer);
procedure PaintRainbow(Dc : hDc; {Canvas to paint to}
                       x : integer; {Start position X}
                       y : integer;  {Start position Y}
                   Width : integer; {Width of the rainbow}
                  Height : integer {Height of the rainbow};
               bVertical : bool; {Paint verticallty}
               WrapToRed : bool); {Wrap spectrum back to red}
//function RgbToGray(RGBColor : TColor) : TColor;
procedure CopyColorList2Palette;
procedure FillPalListArray;
procedure ApplyNewPalette;
procedure ReadParamFile(var Inx:Integer; FileName: String);
function CountColors(const Bitmap:  TBitmap; FillList: boolean): integer;
//procedure SetGifOptions(var GIF: TGifImage);
procedure FindColorIndex2(x: Integer);
function IntToColor(i:Integer):TFColor;
function IntToByte(i:Integer):Byte;
function TrimInt(i,Min,Max:Integer):Integer;
procedure ContinuesJulia;
function median_of(el: Telem; c: integer): tagRGBTRIPLE;
procedure SplitBlur(Amount:Integer);

implementation

uses ShellAPI,Globs,Types, Math, BParams, Inf, About, PSize,Fullscr,WinSize,EdPal,{Browse,}
 Angle, SPar,Gradient, GradDial,JpOpt,
 Printers, Clipbrd, AttrPar, SplitCnf, lsys, HalSel, Mono, ChrmUnit,
 EdTxt, MartPar, UnityFrm, TrigPar, BifPar, ColCycl, LBS,
 {AboutForm,} Sprayunit, CNoiseUnit, RGBUnit, {Targa,}
  ContrastUnit, SaturationUnit, LightnessUnit,
  CustFil, EdgeDt, EnterValUnit,{Bmp2tiff,Readtiff,} ThresholdUnit,
  ExChangeRGBUnit, MosaicUnit, Deform, MonoNoiseUnit;

{$R *.DFM}

{$INCLUDE Complx}     // Include File Complx.pas

procedure TBM.Exit1Click(Sender: TObject);
begin
Close;
end;

procedure TBM.FormCreate(Sender: TObject);
var
f: TRegIniFile;
dummy : Integer;
begin
NormalRgn:=True;
WinMovable := false;
CyclingNow := false;
AnimStopped := true;
FractalCompleted:= true;

CurrentDirectory := ExtractFileDir(Application.ExeName);
//FileDrag1.EnableDrop := True;
GraphicsDirectory := CurrentDirectory + '\Graphics';
PaletteDirectory :=  CurrentDirectory + '\Palette';
ParamsDirectory :=   CurrentDirectory + '\FracParm';
VideoDirectory :=    CurrentDirectory + '\Video';
HelpDirectory :=     CurrentDirectory + '\Help';
TexturesDirectory := CurrentDirectory + '\Texture';
AnimDirectory := CurrentDirectory + '\Anims';
ScannedDirectory := CurrentDirectory + '\Scanned Images';

f := TRegIniFile.Create(REGPLACE);
Left := f.ReadInteger(MAINW,'Left',291);
Top := f.ReadInteger(MAINW,'Top',14);
Height := f.ReadInteger(MAINW,'Height',546);
Width := f.ReadInteger(MAINW,'Width',508);
Color := f.ReadInteger(MAINW,'BackGround Color',clBlack);
//RememberLastDir1.checked := f.ReadBool(MAINW,'Remember Dirs',false);
VersionNum := StrToFloat(f.ReadString(MAINW,'Version','2,0'));
FileEditMenu.Checked := f.ReadBool(MAINW,'Internal Editor',true);
//ShowScanOptions1.Checked := f.ReadBool(MAINW,'Scanner Options',false);
ProgBarMenu.checked := f.ReadBool(GLOBAL,'Progress Bar',true);
ProgressBarOn := ProgBarMenu.checked;
TimerMenu.checked := f.ReadBool(GLOBAL,'Timer',true);
TimerOn := TimerMenu.checked;
SoundOn := True;
LoadedBMP := f.ReadString(MAINW,'Bitmap','');
PaletteName := f.ReadString(GLOBAL,'Palette Name',CurrentDirectory+'\Default.pal');
Application.HelpFile := f.ReadString(GLOBAL,'Help FileName',HelpDirectory+'\Elifrac.hlp');
FileExt := UpperCase(ExtractFileExt(LoadedBMP));
if ((FileExt = FileX[feBMP]) or (FileExt = FileX[feTEX]) or (FileExt = FileX[feJPG]) or
    //(FileExt = FileX[feGIF]) or (FileExt = FileX[feFIF]) or (FileExt = FileX[feTGA]) or
    {(FileExt = FileX[fePCX]) or (FileExt = FileX[feDIB]) or} (FileExt = FileX[feRLE]) or
    (FileExt = FileX[feWMF]) or (FileExt = FileX[feEMF]) {or (FileExt = FileX[fePNG]) or}
    {(FileExt = FileX[feTIF]) or (FileExt = FileX[feTIFF]) } ) then
    BMPLoaded := True;
BioColor := f.ReadInteger(GLOBAL,'BioMorph Color',clBlue);
BioColor2 := f.ReadInteger(GLOBAL,'BioMorph Color 2',clYellow);
Xr  := StrToFloat(f.ReadString(GLOBAL,'Xr',ZEROEX));
Xim := StrToFloat(f.ReadString(GLOBAL,'Xim',ZEROEX));
CosXr  := StrToFloat(f.ReadString(GLOBAL,'CosXr',ZEROEX));
CosXim := StrToFloat(f.ReadString(GLOBAL,'CosXim',ZEROEX));
SinXr  := StrToFloat(f.ReadString(GLOBAL,'SinXr',ZEROEX));
SinXim := StrToFloat(f.ReadString(GLOBAL,'SinXim',ZEROEX));
Yr  := StrToFloat(f.ReadString(GLOBAL,'Yr','0,383725'));
Yim := StrToFloat(f.ReadString(GLOBAL,'Yim','0,147851'));
LamdaR  := StrToFloat(f.ReadString(GLOBAL,'LamdaR','0,850000'));
LamdaIm := StrToFloat(f.ReadString(GLOBAL,'LamdaIm','0,600000'));
Br  := StrToFloat(f.ReadString(GLOBAL,'Br','1,0'));
T5r :=  StrToFloat(f.ReadString(GLOBAL,'T5r','1,0'));
T5im := StrToFloat(f.ReadString(GLOBAL,'T5im','0,0'));
PalStartColor := f.ReadInteger(GLOBAL,PALETTEBSC,clRed);
PalMidColor   := f.ReadInteger(GLOBAL,PALETTEBMC,clGreen);
PalEndColor   := f.ReadInteger(GLOBAL,PALETTEBEC,clBlue);
HallFunction := f.readInteger(GLOBAL,'Halley Function',5);
bailoutvalue := f.ReadInteger(GLOBAL,'BailOut Value',32);
stepiter := f.ReadInteger(GLOBAL,'Iteration Step',2);
HalleyBailOut := StrToFloat(f.ReadString(GLOBAL,'Halley BailOut Value','0,001'));
DrMethod := f.ReadInteger(GLOBAL,'Drawing Method',0);
ColMode  := f.ReadInteger(GLOBAL,'Coloring Mode',0);
OutsideColor := f.ReadInteger(GLOBAL,'OutSide Color',0);
SplitOrder := f.ReadInteger(GLOBAL,'Split Screen Order',0);
//clearwind1.checked  := f.ReadBool(METAFILEOPTIONS,'Clear Window',false);
//MetaStrech.checked := f.ReadBool(METAFILEOPTIONS,'Stretch',true);
 // Read and Set Gif Options
{dummy := f.ReadInteger(GIFOPTIONS,'Color Reduction',ord(rmQuantizeWindows));
Netscape216.Checked := false;
BlackWhite.Checked := false;
Gray256.Checked := false;
WindowsGray4.Checked := false;
WindowsSys20.Checked := false;
WindowsHalftone.Checked := false;
Optimized1.Checked := false;
OptimizedWin.Checked := false;
None1.Checked := false;
  case dummy of
   ord(rmNetscape)        : Netscape216.Checked := true;
   ord(rmMonochrome)      : BlackWhite.Checked := true;
   ord(rmGrayScale)       : Gray256.Checked := true;
   ord(rmWindowsGray)     : WindowsGray4.Checked := true;
   ord(rmWindows20)       : WindowsSys20.Checked := true;
   ord(rmWindows256)      : WindowsHalftone.Checked := true;
   ord(rmQuantize)        : Optimized1.Checked := true;
   ord(rmQuantizeWindows) : OptimizedWin.Checked := true;
   ord(rmNone)            : None1.Checked := true;
  end;

dummy := f.ReadInteger(GIFOPTIONS,'Dither Mode',ord(dmFloydSteinberg));
  ErrorDifusion1.Checked := false;
  NearestColor1.Checked := false;
  case dummy of
   ord(dmFloydSteinberg) : ErrorDifusion1.Checked := true;
   ord(dmNearest)        : NearestColor1.Checked := true;
  end;

dummy := f.ReadInteger(GIFOPTIONS,'Compression Method',ord(gcLZW));
 LZW1.Checked := false;
 RLE1.Checked := false;
  case dummy of
   ord(gcLZW) : LZW1.Checked := true;
   ord(gcRLE) : RLE1.Checked := true;
  end;     }

  // Read Jpeg Options

PrDisplay := f.ReadBool(JPGOPT,JPPROGDISP,False);
jpgProgEncode := f.ReadBool(JPGOPT,JPPROGENCODE,False);
SmoothDisplay := f.ReadBool(JPGOPT,'Smoothing',True);
GraySc := f.ReadBool(JPGOPT,'Gray Scale',False);
dummy:= f.ReadInteger(JPGOPT,'Scale',0);
  case dummy of
    0 : jpgSize := jsFullSize;
    1 : jpgSize := jsHalf;
    2 : jpgSize := jsQuarter;
    3 : jpgSize := jsEighth;
end;
dummy := f.ReadInteger(JPGOPT,JPPERFORMANCE,0);
  case dummy of
   0 : jpgPerf := jpBestQuality;
    1 :jpgPerf := jpBestSpeed;
  end;
jpgCmpQlt := f.ReadInteger(JPGOPT,JPCOMPQUALITY,75);
dummy :=  f.ReadInteger(JPGOPT,'Pixel Format',0);
  case dummy of
    0 : jpgPxlFrm := jf24Bit;
    1 : jpgPxlFrm := jf8Bit;
  end;

 {dummy := f.ReadInteger('FIF Options','Color Format',2);
  case dummy of
   0 : FIFColorFormat := RGB8;
   1 : FIFColorFormat := RGB15;
   2 : FIFColorFormat := RGB24;
   3 : FIFColorFormat := GRAYSCALE8;
  end; }
//********************************************************************
Raaa := StrToFloat(f.ReadString(STRANGEATTR,'Rossler a','0,2'));
Rbbb := StrToFloat(f.ReadString(STRANGEATTR,'Rossler b','0,2'));
Rccc := StrToFloat(f.ReadString(STRANGEATTR,'Rossler c','5,7'));
Rdt  := StrToFloat(f.ReadString(STRANGEATTR,'Rossler dt','0,04'));
RLoops := f.ReadInteger(STRANGEATTR,'Rossler Loops',50000);
RHide :=  f.ReadInteger(STRANGEATTR,'Rossler Hide',2000);
RColorEvery := f.ReadInteger(STRANGEATTR,'Rossler ColorStep',5000);

Laaa := StrToFloat(f.ReadString(STRANGEATTR,'Lorenz a','10'));
Lbbb := StrToFloat(f.ReadString(STRANGEATTR,'Lorenz b','2,667'));
Lccc := StrToFloat(f.ReadString(STRANGEATTR,'Lorenz c','28'));
Ldt  := StrToFloat(f.ReadString(STRANGEATTR,'Lorenz dt','0,02'));
LLoops := f.ReadInteger(STRANGEATTR,'Lorenz Loops',50000);
LHide :=  f.ReadInteger(STRANGEATTR,'Lorenz Hide',2000);
LColorEvery := f.ReadInteger(STRANGEATTR,'Lorenz ColorStep',5000);
//**********************************************************************
f.Free;

if not Fileexists(VideoDirectory+'\Fractals.avi') then VideoClip1.Enabled := False;

FractalProc := ComputeMandel;

temp := TBitmap.Create;
temp.PixelFormat := pf24bit;
temp.Width := ClientWidth;
temp.Height := ClientHeight;
PatBlt(temp.canvas.handle,0,0,temp.width,temp.height,BLACKNESS);

original := TBitmap.Create;
original.PixelFormat := pf24bit;
original.Width := ClientWidth;
original.Height := ClientHeight;
PatBlt(original.canvas.handle,0,0,original.width,original.height,BLACKNESS);

un := TBitmap.Create;
un.PixelFormat := pf24bit;
un.Width := ClientWidth;
un.Height := ClientHeight;
PatBlt(un.canvas.handle,0,0,un.width,un.height,BLACKNESS);

CycleStart := 0;
ColorList := TList.Create;
TrueColorColorList := TList.Create;
//AllMapsColorList := TList.Create;

Globs.Init;
maxx := BM.ClientWidth;
maxy := BM.ClientHeight;
stepx := 2*r / maxx;
stepy := 2*r / maxy;

x1 := 0; y1 := 0;
x2 := maxx; y2 := maxy;

A1:=x1;
B1:=y1;
C1:=x2;
D1:=y2;
customdenom := 1;

with BM.Canvas do
 begin
   Pen.Mode := pmCopy;
   Pen.Width := 1;
   Brush.Style := bsSolid;
   Brush.Color := BM.Color;
 end;
//--------------------------------------------------------------------------------------
  { N8BitColor1.Checked := False;                   //
   N15bitcolor1.Checked := False;                  //
   N24bitcolor1.Checked := False;                  //
   N8bitgrayscale1.Checked := False;               //
  case FIFColorFormat of                            // Initialize FIF Options Menu
  RGB8  : N8BitColor1.Checked := True;             //
  RGB15 : N15bitcolor1.Checked := True;            //
  RGB24 : N24bitcolor1.Checked := True;            //
  GRAYSCALE8 : N8bitgrayscale1.Checked := True;    //
 end;}                                              //
//-------------------------------------------------------------------------------------

FastLoadPal;
Invalidate;
Clipboard;
OpenPictureDialog1.Filter := OpenDialog1.Filter;
tcan := Canvas;
end;

//-----------------------------------------------------------------------------------
		function  getXPos(x : Extended) : Extended;
    begin
			Result := x/zoomFactor + topLeftX;
		end;
		//------------------------------------------------------------------------------------
		function  getYPos(y : Extended) : Extended;
    begin
			Result := y/zoomFactor - topLeftY;
		end;

    //-------------------------------------------------------------------------------
		procedure moveUp;
     var  curHeight : Extended;
     begin
			curHeight := maxy / zoomFactor;
			topLeftY := topLeftY + curHeight / moveStep;
			BM.Go;
		end;

		//-------------------------------------------------------------------------------
		procedure moveDown;
      var  curHeight : Extended;
     begin
			curHeight := maxy / zoomFactor;
			topLeftY := topLeftY - curHeight / moveStep;
			BM.Go;
		 end;

		//-------------------------------------------------------------------------------
		procedure moveLeft;
      var    curWidth : Extended;
     begin
			curWidth := maxx / zoomFactor;
			topLeftX := topLeftX - curWidth / moveStep;
			BM.Go;
		 end;

		//-------------------------------------------------------------------------------
		procedure moveRight;
      var    curWidth : Extended;
     begin

			curWidth := maxx / zoomFactor;
			topLeftX := topLeftX + curWidth / moveStep;
			BM.Go;
		 end;

		//-------------------------------------------------------------------------------------

		procedure adjustZoom( newX : Extended; newY : Extended; newZoomFactor: Integer);
     begin
			topLeftX := topLeftX + newX / zoomFactor;
			topLeftY := topLeftY - newY / zoomFactor;

			zoomFactor := newZoomFactor;

			topLeftX := topLeftX - ( BM.ClientWidth / 2) / zoomFactor;
			topLeftY := topLeftY + ( BM.ClientHeight / 2) / zoomFactor;

			BM.Go;
		end;

//============================================================================
{
 procedure mouseClicked(MouseEvent e);

 		 begin

				Extended mouseX = (Extended) e.getX();
				Extended mouseY = (Extended) e.getY();

				switch ( e.getButton())
         begin
				// Left mouse button clicked
				case MouseEvent.BUTTON1:
					adjustZoom(mouseX,mouseY, zoomFactor * 2);
					break;

				// Right mouse button clicked
				case MouseEvent.BUTTON3:  // Button2 is the mousewheel
					adjustZoom(mouseX,mouseY, zoomFactor / 2);
					break;
				end;
		end;
 }
			//-------------------------------------------------------------------------------

procedure TBM.clrscr;
begin
Hours := 0; Mins := 0; Secs := 0; Msecs := 0;
Info.Label24.Caption := IntToStr(Hours)+':'+IntToStr(Mins)+':'
                        +IntToStr(Secs)+':'+IntToStr(Msecs);
BmpLoaded := False;
if clrback.checked then
begin
 with Canvas do
  begin
   Brush.Color := BM.Color;
   Brush.Style := bsSolid;
   Pen.Mode := pmCopy;
   PatBlt(canvas.handle,0,0,width,height,PATCOPY);
  end;
end;
temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
original.Assign(temp);
Cut1.Enabled := False;
Copy1.Enabled := False;
end;

procedure TBM.Reset1Click(Sender: TObject);
begin
clrscr;
Caption := fcapt;
s9 := '';
OpenDialog1.Filename:= '';
Revert1.Enabled := false;
ComingFromZoom := false;
kstart := 5;
k := kstart;
kend := 55;
kstep := 5;
r := 4.0000000000000;  //r := 1.248826;
recen := 0.0; //-0.751174;
imcen := 0.0;
stepx := 2*r / maxx;
stepy := 2*r / maxy;
XMax := recen + r;
XMin := recen - r;
YMax := imcen - r;
YMin := imcen + r;
 x1 := 0;
 y1 := 0;
 x2 := maxx;
 y2 := maxy;
//********* BIFURCATIONS **************
bifiter := 300;
bifhide := 0;
bifxr := 1.5;
bifyr := 0.5;
bifxcenter := 2.5;
bifycenter := 0.5;
//*************************************
StUpdate;
Params1.Invert.Checked := false;
//Params1.RadioGroup1.ItemIndex := 0;
//Params1.ColoringMode.ItemIndex := 0;
//Params1.OutsideCombo.ItemIndex := 0;
FractalCompleted:=true;
end;

procedure TBM.ParametersClick(Sender: TObject);
//var I : Integer;
begin
if (kstep <> 0) then
begin
Params1.Edit1.Text := IntToStr(kstart);
Params1.Edit2.Text := IntToStr(kend);
Params1.Edit3.Text := IntToStr(kstep);
end;
Params1.ShowModal;
if Params1.ModalResult = mrOK then
//begin
   StUpdate;
  // for I := 0 to TypesMenu1.Count-1 do
  //     if TypesMenu1.Items[I].Checked then
  //        TypesMenu1.Items[I].Click;
//end;
end;

procedure TBM.PSaveClick(Sender: TObject);
label J20;
var
 I: TIniFile;
 j : Integer;
begin
 SaveDialog1.InitialDir := ParamsDirectory;

 if fractalname = fractal[ifssys] then     //'IFS SYSTEMS'
 begin
 SaveDialog1.Title := s3;
 SaveDialog1.FilterIndex := 5;

 if SaveDialog1.Execute then
 begin
 I := TIniFile.Create(SaveDialog1.Filename);
 I.WriteString(s12,'NAME',SaveDialog1.Filename);
 I.WriteString(s12,'Palette Name',PaletteName);
 I.WriteInteger(s12,'TRANSFORMS',transforms);
 j:=0;
 while j < transforms do
  begin
   I.WriteString(s12,'a['+IntToStr(j)+']',Format('%8.7f',[a[j]]));
   I.WriteString(s12,'b['+IntToStr(j)+']',Format('%8.7f',[b[j]]));
   I.WriteString(s12,'cc['+IntToStr(j)+']',Format('%8.7f',[cc[j]]));
   I.WriteString(s12,'d['+IntToStr(j)+']',Format('%8.7f',[d[j]]));
   I.WriteString(s12,'e['+IntToStr(j)+']',Format('%8.7f',[e[j]]));
   I.WriteString(s12,'f['+IntToStr(j)+']',Format('%8.7f',[f[j]]));
   I.WriteString(s12,'p['+IntToStr(j)+']',Format('%8.7f',[p[j]]));
   inc(j);
  end;
 I.Free;
 Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
 end;
 end
 else if fractalname = fractal[lsystems] {'L - SYSTEMS'} then
    LSysFrm.Button4.Click
 else begin
 SaveDialog1.Title := s3;
 SaveDialog1.FilterIndex := 1;
 if SaveDialog1.Execute then
 begin
  for j := 0 to TypesMenu1.Count-1 do
      if TypesMenu1.Items[j].Checked then break;

 I := TIniFile.Create(SaveDialog1.Filename);
 I.WriteString(FRACPARAMFILE,FRACNAM,FractalName);
 I.WriteInteger(FRACPARAMFILE,'Index',j);

 if j = 20 then goto J20;  // If 3D Mountains.
 if j = 23 then            // Bifurcation
   begin
    I.WriteInteger(FRACPARAMFILE,'ITERATIONS',bifiter);
    I.WriteInteger(FRACPARAMFILE,'HIDE',bifhide);
    I.WriteInteger(FRACPARAMFILE,'FUNCTION',BifParams.Radiogroup1.ItemIndex);
    I.WriteString(FRACPARAMFILE,'X RADIUS',FloatToStr(bifxr));
    I.WriteString(FRACPARAMFILE,'Y RADIUS',FloatToStr(bifyr));
    I.WriteString(FRACPARAMFILE,'X CENTER',FloatToStr(bifxcenter));
    I.WriteString(FRACPARAMFILE,'Y CENTER',FloatToStr(bifycenter));
    I.WriteString(FRACPARAMFILE,'START',FloatToStr(bifstart));
    I.WriteString(FRACPARAMFILE,'END',FloatToStr(bifend));
    I.WriteString(FRACPARAMFILE,'BOTTOM',FloatToStr(bifbottom));
    I.WriteString(FRACPARAMFILE,'TOP',FloatToStr(biftop));
    goto J20;
   end;
 I.WriteInteger(FRACPARAMFILE,'KSTART',kstart);
 I.WriteInteger(FRACPARAMFILE,'KEND',kend);
 I.WriteInteger(FRACPARAMFILE,'KSTEP',kstep);
 I.WriteString(FRACPARAMFILE,'RADIUS',FloatToStr(r));
 I.WriteString(FRACPARAMFILE,'REAL CENTER',FloatToStr(recen));
 I.WriteString(FRACPARAMFILE,'IMAGINARY CENTER',FloatToStr(imcen));
 I.WriteString(FRACPARAMFILE,'STEPX',FloatToStr(stepx));
 I.WriteString(FRACPARAMFILE,'STEPY',FloatToStr(stepy));
 I.WriteString(FRACPARAMFILE,'XMax',FloatToStr(XMax));
 I.WriteString(FRACPARAMFILE,'XMin',FloatToStr(XMin));
 I.WriteString(FRACPARAMFILE,'YMax',FloatToStr(YMax));
 I.WriteString(FRACPARAMFILE,'YMin',FloatToStr(YMin));
 I.WriteInteger(FRACPARAMFILE,FITERS,Iters);
 I.WriteInteger(FRACPARAMFILE,'ITERATION STEP',stepiter);
 I.WriteString(FRACPARAMFILE,'Xr',FloatToStr(Xr));
 I.WriteString(FRACPARAMFILE,'Xim',FloatToStr(Xim));
 I.WriteString(FRACPARAMFILE,'Yr',FloatToStr(Yr));
 I.WriteString(FRACPARAMFILE,'Yim',FloatToStr(Yim));
 I.WriteString(FRACPARAMFILE,'LamdaR',FloatToStr(LamdaR));
 I.WriteString(FRACPARAMFILE,'LamdaIm',FloatToStr(LamdaIm));
 I.WriteString(FRACPARAMFILE,'CosXr',FloatToStr(CosXr));
 I.WriteString(FRACPARAMFILE,'CosXim',FloatToStr(CosXim));
 I.WriteString(FRACPARAMFILE,'SinXr',FloatToStr(SinXr));
 I.WriteString(FRACPARAMFILE,'SinXim',FloatToStr(SinXim));
 I.WriteInteger(FRACPARAMFILE,'TrigFunc',TrigParams.TrigF.ItemIndex);
 I.WriteString(FRACPARAMFILE,'Halley BailOut Value',Format(F1210,[HalleyBailOut]));
 I.writeInteger(FRACPARAMFILE,'Halley Function', HallFunction);
 I.Writebool(FRACPARAMFILE,'Inverted',Params1.Invert.Checked);
 if j = 15 then
 if FractalName = fractal[RosslerAttractor]  then          //'ROSSLER ATTRACTOR'
 begin
  I.WriteString(FRACPARAMFILE,'Attractor a',FloatToStr(Raaa));
  I.WriteString(FRACPARAMFILE,'Attractor b',FloatToStr(Rbbb));
  I.WriteString(FRACPARAMFILE,'Attractor c',FloatToStr(Rccc));
  I.WriteString(FRACPARAMFILE,'Attractor dt',FloatToStr(Rdt));
  I.WriteInteger(FRACPARAMFILE,'Attractor Loops',Rloops);
  I.WriteInteger(FRACPARAMFILE,'Attractor Hide',Rhide);
  I.WriteInteger(FRACPARAMFILE,'Attractor Color Every',RColorEvery);
 end
 else if FractalName = fractal[LorenzAttractor]  then       //'LORENZ ATTRACTOR'
      begin
       I.WriteString(FRACPARAMFILE,'Attractor a',FloatToStr(Laaa));
       I.WriteString(FRACPARAMFILE,'Attractor b',FloatToStr(Lbbb));
       I.WriteString(FRACPARAMFILE,'Attractor c',FloatToStr(Lccc));
       I.WriteString(FRACPARAMFILE,'Attractor dt',FloatToStr(Ldt));
       I.WriteInteger(FRACPARAMFILE,'Attractor Loops',Lloops);
       I.WriteInteger(FRACPARAMFILE,'Attractor Hide',Lhide);
       I.WriteInteger(FRACPARAMFILE,'Attractor Color Every',LColorEvery);
      end;
 if j = 16 then
  begin
   I.WriteString(FRACPARAMFILE,'T5r',FloatToStr(T5r));       // 7-3-98  Save Tchebychev Fractals
   I.WriteString(FRACPARAMFILE,'T5im',FloatToStr(T5im));     // 7-3-98
  end;

 I.WriteInteger(FRACPARAMFILE,'Drawing Type',Params1.Radiogroup1.ItemIndex);
 I.WriteInteger(FRACPARAMFILE,'Coloring Mode',Params1.ColoringMode.ItemIndex);
 I.WriteInteger(FRACPARAMFILE,'OutSide Color',Params1.OutsideCombo.ItemIndex);
 I.WriteInteger(FRACPARAMFILE,'BioMorph Color',BioColor);
 I.WriteInteger(FRACPARAMFILE,'BioMorph Color 2',BioColor2);

J20 :
 I.WriteString(FRACPARAMFILE,'Palette Name',PaletteName);
 //*******************************************************

 if not FractalCompleted then
  begin
   I.WriteBool(FRACPARAMFILE,'Complete',FractalCompleted);
   I.WriteInteger(FRACPARAMFILE,'SavedRow',savedrow);

   //I.WriteInteger(FRACPARAMFILE,'SavedG3',savedG3);
   //I.WriteInteger(FRACPARAMFILE,'Savedcol2',savedcol2);
   //I.WriteInteger(FRACPARAMFILE,'Savedrow2',savedrow2);

   //I.WriteInteger(FRACPARAMFILE,'Savedcol3',savedcol3);
   //I.WriteInteger(FRACPARAMFILE,'SavedF2',savedF2);

   I.WriteInteger(FRACPARAMFILE,'CurtainCol',savedCurtainCol);
   I.WriteInteger(FRACPARAMFILE,'OpositeCol',savedOpositeCol);
   I.WriteInteger(FRACPARAMFILE,'HelixG',savedHelixG);
  end;
//***********************************************************
 I.Free;
 Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
 end;
 end; // else
end;

procedure ReadParamFile(var Inx:Integer; FileName: String);
var
I: TIniFile;
label J20;
begin
 I := TIniFile.Create(Filename);
  FractalName := I.ReadString(FRACPARAMFILE,FRACNAM,FractalName);
  Inx    := I.ReadInteger(FRACPARAMFILE,'Index',7);
  kstart := I.ReadInteger(FRACPARAMFILE,'KSTART',kstart);
  PaletteName := I.ReadString(FRACPARAMFILE,'Palette Name','');
  //*******************************************************
 FractalCompleted := I.ReadBool(FRACPARAMFILE,'Complete',true);
 if not FractalCompleted then
   begin
     SavedRow := I.ReadInteger(FRACPARAMFILE,'SavedRow',0);
    // SavedG3  := I.ReadInteger(FRACPARAMFILE,'SavedG3',0);
    // Savedcol2 := I.ReadInteger(FRACPARAMFILE,'Savedcol2',0);
    // Savedrow2 := I.ReadInteger(FRACPARAMFILE,'Savedrow2',0);

    // Savedcol3 := I.ReadInteger(FRACPARAMFILE,'Savedcol3',0);
    // SavedF2   := I.ReadInteger(FRACPARAMFILE,'SavedF2',0);

     savedCurtainCol := I.ReadInteger(FRACPARAMFILE,'CurtainCol',0);
     savedOpositeCol := I.ReadInteger(FRACPARAMFILE,'OpositeCol',0);
     savedHelixG := I.ReadInteger(FRACPARAMFILE,'HelixG',0);
   end;
//***********************************************************

  if inx = 23 then   // Bifurcation
   begin
     bifiter := I.ReadInteger(FRACPARAMFILE,'ITERATIONS',1000);
     bifhide := I.ReadInteger(FRACPARAMFILE,'HIDE',0);
     BifParams.Radiogroup1.ItemIndex := I.ReadInteger(FRACPARAMFILE,'FUNCTION',0);
     bifxr   := StrToFloat(I.ReadString(FRACPARAMFILE,'X RADIUS',FloatToStr(bifxr)));
     bifyr   := StrToFloat(I.ReadString(FRACPARAMFILE,'Y RADIUS',FloatToStr(bifyr)));
     bifxcenter := StrToFloat(I.ReadString(FRACPARAMFILE,'X CENTER',FloatToStr(bifxcenter)));
     bifycenter := StrToFloat(I.ReadString(FRACPARAMFILE,'Y CENTER',FloatToStr(bifycenter)));
     bifstart := StrToFloat(I.ReadString(FRACPARAMFILE,'START',FloatToStr(bifstart)));
     bifend := StrToFloat(I.ReadString(FRACPARAMFILE,'END',FloatToStr(bifend)));
     bifbottom := StrToFloat(I.ReadString(FRACPARAMFILE,'BOTTOM',FloatToStr(bifbottom)));
     biftop := StrToFloat(I.ReadString(FRACPARAMFILE,'TOP',FloatToStr(biftop)));
     goto J20;
   end;

  kend   := I.ReadInteger(FRACPARAMFILE,'KEND',kend);
  kstep  := I.ReadInteger(FRACPARAMFILE,'KSTEP',kstep);
  r      := StrToFloat(I.ReadString(FRACPARAMFILE,'RADIUS',FloatToStr(r)));
  recen  := StrToFloat(I.ReadString(FRACPARAMFILE,'REAL CENTER',FloatToStr(recen)));
  imcen  := StrToFloat(I.ReadString(FRACPARAMFILE,'IMAGINARY CENTER',FloatToStr(imcen)));
  stepx  := StrToFloat(I.ReadString(FRACPARAMFILE,'STEPX',FloatToStr(stepx)));
  stepy  := StrToFloat(I.ReadString(FRACPARAMFILE,'STEPY',FloatToStr(stepy)));

  XMax := StrToFloat(I.ReadString(FRACPARAMFILE,'XMax',FloatToStr(XMax)));
  XMin := StrToFloat(I.ReadString(FRACPARAMFILE,'XMin',FloatToStr(XMin)));
  YMax := StrToFloat(I.ReadString(FRACPARAMFILE,'YMax',FloatToStr(YMax)));
  YMin := StrToFloat(I.ReadString(FRACPARAMFILE,'YMin',FloatToStr(YMin)));
  Iters := I.ReadInteger(FRACPARAMFILE,FITERS,Iters);
  stepiter := I.ReadInteger(FRACPARAMFILE,'ITERATION STEP',1);
  Xr := StrToFloat(I.ReadString(FRACPARAMFILE,'Xr',FloatToStr(Xr)));
  Xim := StrToFloat(I.ReadString(FRACPARAMFILE,'Xim',FloatToStr(Xim)));
  Yr := StrToFloat(I.ReadString(FRACPARAMFILE,'Yr',FloatToStr(Yr)));
  Yim := StrToFloat(I.ReadString(FRACPARAMFILE,'Yim',FloatToStr(Yim)));
  LamdaR := StrToFloat(I.ReadString(FRACPARAMFILE,'LamdaR',FloatToStr(LamdaR)));
  LamdaIm := StrToFloat(I.ReadString(FRACPARAMFILE,'LamdaIm',FloatToStr(LamdaIm)));
  CosXr := StrToFloat(I.ReadString(FRACPARAMFILE,'CosXr',FloatToStr(CosXr)));
  CosXim := StrToFloat(I.ReadString(FRACPARAMFILE,'CosXim',FloatToStr(CosXim)));
  SinXr := StrToFloat(I.ReadString(FRACPARAMFILE,'SinXr',FloatToStr(SinXr)));
  SinXim := StrToFloat(I.ReadString(FRACPARAMFILE,'SinXim',FloatToStr(SinXim)));
  TrigParams.TrigF.ItemIndex := I.ReadInteger(FRACPARAMFILE,'TrigFunc',0);
  Julx := Yr;
  July := Yim;
  HalleyBailOut := StrToFloat(I.ReadString(FRACPARAMFILE,'Halley BailOut Value','0,001'));
  HallFunction := I.readInteger(FRACPARAMFILE,'Halley Function', 5);
  Params1.Radiogroup1.ItemIndex  := I.ReadInteger(FRACPARAMFILE,'Drawing Type',0);
  Params1.ColoringMode.ItemIndex := I.ReadInteger(FRACPARAMFILE,'Coloring Mode',0);
  Params1.OutsideCombo.ItemIndex := I.ReadInteger(FRACPARAMFILE,'OutSide Color',0);
  Params1.Invert.Checked := I.ReadBool(FRACPARAMFILE,'Inverted',false);
  ColMode := Params1.ColoringMode.ItemIndex;
  DrMethod := Params1.Radiogroup1.ItemIndex;
  OutSideColor := Params1.OutsideCombo.ItemIndex;

  BioColor := I.ReadInteger(FRACPARAMFILE,'BioMorph Color',clBlue);
  BioColor2 := I.ReadInteger(FRACPARAMFILE,'BioMorph Color 2',clYellow);

  if Inx = 15 then                                      // Added 7-3-98
  if FractalName = fractal[RosslerAttractor]  then {'ROSSLER ATTRACTOR'}
    begin
    Raaa := StrToFloat(I.ReadString(FRACPARAMFILE,'Attractor a',FloatToStr(aaa)));
    Rbbb := StrToFloat(I.ReadString(FRACPARAMFILE,'Attractor b',FloatToStr(bbb)));
    Rccc := StrToFloat(I.ReadString(FRACPARAMFILE,'Attractor c',FloatToStr(ccc)));
    Rdt  := StrToFloat(I.ReadString(FRACPARAMFILE,'Attractor dt',FloatToStr(dt)));
    Rloops := I.ReadInteger(FRACPARAMFILE,'Attractor Loops',loops);
    Rhide := I.ReadInteger(FRACPARAMFILE,'Attractor Hide',Ahide);
    RColorEvery := I.ReadInteger(FRACPARAMFILE,'Attractor Color Every',ColorEvery);
    end
    else if FractalName = fractal[LorenzAttractor] then {'LORENZ ATTRACTOR'}
    begin
     Laaa := StrToFloat(I.ReadString(FRACPARAMFILE,'Attractor a',FloatToStr(aaa)));
     Lbbb := StrToFloat(I.ReadString(FRACPARAMFILE,'Attractor b',FloatToStr(bbb)));
     Lccc := StrToFloat(I.ReadString(FRACPARAMFILE,'Attractor c',FloatToStr(ccc)));
     Ldt  := StrToFloat(I.ReadString(FRACPARAMFILE,'Attractor dt',FloatToStr(dt)));
     Lloops := I.ReadInteger(FRACPARAMFILE,'Attractor Loops',loops);
     Lhide := I.ReadInteger(FRACPARAMFILE,'Attractor Hide',Ahide);
     LColorEvery := I.ReadInteger(FRACPARAMFILE,'Attractor Color Every',ColorEvery);
     end;
 J20:
  I.Free;
end;

procedure TBM.POpenClick(Sender: TObject);
var
 Fin: TextFile;
 dummy : String;
 dummy2: String;
 Inx : Integer;
 Jpg1 : TJPEGImage;
begin
OpenDialog1.Title := s4;
OpenDialog1.FilterIndex := 10;
OpenDialog1.InitialDir := ParamsDirectory;

if OpenDialog1.Execute then
 begin
 FileExt := UpperCase(ExtractFileExt(OpenDialog1.Filename));
  if FileExt = FileX[feLSM] then
    begin
     CopyUndoBmp;
     clearchecked;
     lsystems1.Checked := True;
     Cut1.Enabled := True;
     Copy1.Enabled := True;
     FractalName := fractal[lsystems];
     //Params1.Auto1.Checked := False;
     StUpdate;
     DoLoadLsys(OpenDialog1.Filename);
     exit;
    end
  else if FileExt = FileX[feIFS] then
        begin
         CopyUndoBmp;
         clearchecked;
         ifs1.Checked := True;
         Cut1.Enabled := True;
         Copy1.Enabled := True;
         FractalName := Fractal[ifssys];
         //Params1.Auto1.Checked := False;
         StUpdate;
         DoLoadIfs(OpenDialog1.Filename);
         exit;
        end;
  passes := 1;
  AssignFile(Fin, OpenDialog1.Filename);
  Reset(Fin);
  Readln(Fin,dummy);
  CloseFile(Fin);
  if dummy <> FRACPARAMFILE2 then
   begin
    Application.MessageBox(NOFPR,DLGERROR, MB_ICONERROR + MB_OK);
    Exit;
   end;
    ReadParamFile(Inx, OpenDialog1.Filename);

  if FractalCompleted then  clrscr
  else  begin
          dummy := ChangeFileExt(extractfilename(OpenDialog1.Filename), '.JPG');
          dummy2:= GraphicsDirectory +'\'+dummy;
          if fileexists(dummy2) then
            begin
              LoadwithBMPFlag := True;
              Jpg1 := TJPEGImage.Create;
              Jpg1.LoadFromFile(dummy2);
              temp.Width := Jpg1.Width;
              temp.Height := Jpg1.Height;
              temp.Assign(Jpg1);
              temp.PixelFormat := pf24bit;
              Jpg1.Free;
              if (temp.Width >= Screen.Width) or (temp.Height >= Screen.Height) then
                 begin
                  Top := 0; Left := 0;
                  Width := Screen.Width; Height := Screen.Height;
                  TooLarge := True;
                 end
                 else
                 if (temp.Width > 500) or (temp.Height > 500) then
                   begin
                     Top := 0; Left := 0;
                     ClientWidth  := temp.Width;
                     ClientHeight := temp.Height ;
                     TooLarge := False;
                   end
                 else
                   begin
                     ClientWidth  := temp.Width;
                     ClientHeight := temp.Height ;
                     TooLarge := False;
                   end;
                Cut1.Enabled := True;
                Copy1.Enabled := True;
                Revert1.enabled := false;
                BM.Canvas.CopyMode := cmSrcCopy;
              if TooLarge then Canvas.StretchDraw(ClientRect,temp)
              else
                Canvas.CopyRect(ClientRect,temp.Canvas,ClientRect);

              original.Width := ClientWidth;
              original.Height := ClientHeight;
              original.assign(temp);
              original.Canvas.Pixels[0,0] := temp.Canvas.Pixels[0,0];
              original.PixelFormat := pf24bit;

              LoadedBMP := dummy2;
              Globundo := false;
              BmpLoaded := True;
            end;
        end;

  Caption := fcapt + ' [ ' + OpenDialog1.Filename + ' ]';
  if PaletteName = '' then
   InitPalete
  else FastLoadPal;
  StUpdate;
  if Inx = 16 then
    begin                                                // Added 7-3-98 to support
    if FractalName = fractal[TchebychevT3] then T31.Click      // Tchebychev Fractals.
    else if FractalName = fractal[TchebychevT5] then T51.Click
    else if FractalName = fractal[TchebychevC6]  then C61.Click;
    end
  else if Inx = 15 then
    begin
    if FractalName = fractal[RosslerAttractor] then Rossler1.Click
    else if FractalName = fractal[LorenzAttractor] then Lorenz1.Click;
    end
  else
  TypesMenu1.Items[Inx].Click;
 end;
end;

procedure TBM.ClearScreen1Click(Sender: TObject);
begin
clrscr;
end;

procedure TBM.BMPaint(Sender: TObject);  // On Paint Event.
begin
  // if passes >= 1 then
   Canvas.StretchDraw(ClientRect, temp);
end;

procedure TBM.FormResize(Sender: TObject); // On Resize Event.
begin
maxx := ClientWidth;
maxy := ClientHeight;
halfx := maxx div 2;
halfy := maxy div 2;
x1 := 0; y1 := 0; x2 := maxx; y2 := maxy;
A1:=x1; B1:=y1; C1:=x2; D1:=y2;
Paint;
end;

procedure TBM.FormKeyPress(Sender: TObject; var Key: Char);
//var I : Byte;
begin
{  if DrawingTool = dtText then
     begin
       if key <> #13 then  CanvasText := CanvasText+ string (key)
       else begin DrawingTool := dtNone; exit; end;
       DrawShape(Origin, MovePt, pmNotXor);
       exit;
     end;  }
  case key of
    #13  : begin
           if working or CyclingNow then begin   // Εάν Δουλεύει
             escpressed := True;   //  Σταμάτα το.
             exit;                 // επιστροφή.
             end;
           // Φτάσαμε εδώ άρα δεν Δουλεύει.
            // Ξεκίνα το επιλεγμένο Fractal.
           Go;
           end;
    #27  : begin
           WalkMode := false;
           if working or CyclingNow then begin   // Εάν Δουλεύει
             escpressed := True;   //  Σταμάτα το.
             exit;                 // επιστροφή.
             end;
           end;
    #32  : begin
           clrscr; julia;
           end;
    ','  :  begin dec(kstep);
                  Info.Label14.Caption  := IntToStr(kstep);
            end;
    '.'  :  begin inc(kstep);
                  Info.Label14.Caption  := IntToStr(kstep);
            end;
    '+'  :  begin
             //if color_cycleMode then
               //win_cycledir := 1
             //else begin
             inc(kstart,kstep);
             inc(kend,kstep);
             k := kstart;
             Info.Label11.Caption  := IntToStr(k);
             Info.Label12.Caption  := IntToStr(kstart);
             Info.Label13.Caption  := IntToStr(kend);
             //end;
	    end;
     '-' :   begin
             //if color_cycleMode then
               //win_cycledir := -1
             //else begin
                   dec(kstart,kstep);
                   dec(kend,kstep);
                   k := kstart;
                   Info.Label11.Caption  := IntToStr(k);
                   Info.Label12.Caption  := IntToStr(kstart);
                   Info.Label13.Caption  := IntToStr(kend);
               //   end;
            end;
     '<' :   begin
              r := r-stepx;
              stepx := 2*r/maxx;
              stepy := 2*r/maxy;
              Info.Label15.Caption := Format(F1817,[r]);
              Info.Label18.Caption := Format(F1817,[stepx]);
              Info.Label19.Caption := Format(F1817,[stepy]);
             end;
     '>' :   begin
              r := r+stepx;
              stepx := 2*r/maxx;
              stepy := 2*r/maxy;
              Info.Label15.Caption := Format(F1817,[r]);
              Info.Label18.Caption := Format(F1817,[stepx]);
              Info.Label19.Caption := Format(F1817,[stepy]);
             end;

   else exit;
   end;
 {else begin
        if key <> #13 then
        begin
         CanvasText := CanvasText+ string (key);
         Canvas.TextOut(Origin.x,Origin.y,CanvasText);
        end
        else
          begin
            temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
            DrawingTool := dtNone;
          end;
        end; }
end;


procedure TBM.SndMenuClick(Sender: TObject);
begin
  if  SndMenu.checked then
   begin
   SndMenu.checked := False;
   SndMenu.Caption := 'Sound =  OFF';
   SoundOn := false;
   end
   else begin
   SndMenu.checked := True;
   SndMenu.Caption := 'Sound =  ON';
   SoundOn := True;
   end;
end;

procedure walkright;
begin
with BM.Canvas do
  begin
   Brush.Color := BM.Color;
   Brush.Style := bsSolid;
   Pen.Mode := pmCopy;
   PatBlt(handle,0,0,BM.width,BM.height,PATCOPY);
   Draw(-20,0,BM.temp);
   BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
  end;
   recen := recen + 20*stepx;
   Info.Label16.Caption := Format(F1817,[recen]);
   XMax := recen + r;
   XMin := recen - r;
   YMax := imcen - r;
   YMin := imcen + r;
   Info.Label26.Caption := Format(F1817,[XMax]);
   Info.Label30.Caption := Format(F1817,[XMin]);
   Info.Label32.Caption := Format(F1817,[YMax]);
   Info.Label34.Caption := Format(F1817,[YMin]);
   CompleteFractalRight(maxx-20,0);
   BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
end;

procedure walkleft;
begin
with BM.Canvas do
  begin
   Brush.Color := BM.Color;
   Brush.Style := bsSolid;
   Pen.Mode := pmCopy;
   PatBlt(handle,0,0,BM.width,BM.height,PATCOPY);
   Draw(20,0,BM.temp);
   BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
  end;
   recen := recen - 20*stepx;
   Info.Label16.Caption := Format(F1817,[recen]);
   XMax := recen + r;
   XMin := recen - r;
   YMax := imcen - r;
   YMin := imcen + r;
   Info.Label26.Caption := Format(F1817,[XMax]);
   Info.Label30.Caption := Format(F1817,[XMin]);
   Info.Label32.Caption := Format(F1817,[YMax]);
   Info.Label34.Caption := Format(F1817,[YMin]);
   CompleteFractalLeft(20,0);
   BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
end;

procedure walkup;
begin
with BM.Canvas do
  begin
   Brush.Color := BM.Color;
   Brush.Style := bsSolid;
   Pen.Mode := pmCopy;
   PatBlt(handle,0,0,BM.width,BM.height,PATCOPY);
   Draw(0,20,BM.temp);
   BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
  end;
   imcen := imcen - 20*stepy;
   Info.Label17.Caption := Format(F1817,[imcen]);
   XMax := recen + r;
   XMin := recen - r;
   YMax := imcen - r;
   YMin := imcen + r;
   Info.Label26.Caption := Format(F1817,[XMax]);
   Info.Label30.Caption := Format(F1817,[XMin]);
   Info.Label32.Caption := Format(F1817,[YMax]);
   Info.Label34.Caption := Format(F1817,[YMin]);
   CompleteFractalUp(0,20);
   BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
end;

procedure walkdown;
begin
with BM.Canvas do
  begin
   Brush.Color := BM.Color;
   Brush.Style := bsSolid;
   Pen.Mode := pmCopy;
   PatBlt(handle,0,0,BM.width,BM.height,PATCOPY);
   Draw(0,-20,BM.temp);
   BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
  end;
   imcen := imcen + 20*stepy;
   Info.Label17.Caption := Format(F1817,[imcen]);
   XMax := recen + r;
   XMin := recen - r;
   YMax := imcen - r;
   YMin := imcen + r;
   Info.Label26.Caption := Format(F1817,[XMax]);
   Info.Label30.Caption := Format(F1817,[XMin]);
   Info.Label32.Caption := Format(F1817,[YMax]);
   Info.Label34.Caption := Format(F1817,[YMin]);
   CompleteFractalDown(0,maxy-20);
   BM.temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
end;

procedure TBM.cross;
begin
  crossx := (C1-A1) div 2 + A1;
  crossy := (D1-B1) div 2 + B1;
end;

procedure TBM.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
cross;
with BM.Canvas do
begin
Brush.Style := bsClear;
Pen.Mode := pmNot;
Rectangle(A1,B1,C1,D1);
MoveTo(crossx,crossy-10 );
LineTo(crossx,crossy+10 );
MoveTo(crossx-10,crossy );
LineTo(crossx+10,crossy );
Brush.Style := bsSolid;
Pen.Mode := pmCopy;
end;
case key of
    { VK_END      :  begin
                    WalkMode := false;
                    endkeypressed := True;
                    end;  }
     VK_PAGEDOWN :  begin
                     WalkMode := false;
                     escpressed := True;
                     FractalCompleted:= true;
                     dec(A1,5); inc(C1,5); dec(B1,5); inc(D1,5);
                     if (A1<0) or (C1>maxx) or (B1<0) or (D1>maxy) then
                     begin
                       inc(A1,5); dec(C1,5); inc(B1,5); dec(D1,5);
                     end
                     else begin
                          if Shift = [ssAlt] then begin   // Alt key pressed.
                           r := r-(5*stepx);
                           bifxr := bifxr-(5*bifstepx);
                           bifyr := bifyr-(5*bifstepy);
                          end
                          else
                          begin
                           r := r+(5*stepx);
                           bifxr := bifxr+(5*bifstepx);
                           bifyr := bifyr+(5*bifstepy);
                          end;
                          Info.Label15.Caption := Format(F1817,[r]);
                          end;
                      end;
   VK_PAGEUP : begin
                  WalkMode := false;
                  escpressed := True;
                  FractalCompleted:= true;
                  inc(A1,5); dec(C1,5); inc(B1,5); dec(D1,5);
                  if ((C1-A1)< 40) then
                  begin  dec(A1,5); inc(C1,5); dec(B1,5); inc(D1,5);
                  end
                  else begin
                        if Shift = [ssAlt] then begin   // Alt key pressed.
                         r := r+(5*stepx);
                         bifxr := bifxr+(5*bifstepx);
                         bifyr := bifyr+(5*bifstepy);
                        end
                        else
                        begin
                         r := r-(5*stepx);
                         bifxr := bifxr-(5*bifstepx);
                         bifyr := bifyr-(5*bifstepy);
                        end;
                        Info.Label15.Caption := Format(F1817,[r]);
                        end;
               end;

     VK_UP     :  begin
                   if WalkMode then
                     begin
                     walkup;
                     cross;
                     exit;
                     end;
                   if Shift = [ssAlt] then begin   // Alt key pressed.
                     dec(B1,10); dec(D1,10);  // 10 pixels πάνω.
                     // Προσοχή να μη βγούμε έξω από το Παράθυρο.
                     if B1 < 0 then
                       begin inc(B1,10); inc(D1,10); end
                       else begin
                             imcen := imcen - 10*stepy;
                             bifycenter := bifycenter +10* bifstepy;
                             Info.Label17.Caption := Format(F1817,[imcen]);
                            end;
                    end
                    else begin
                      dec(B1); dec(D1);  // 1 pixel πάνω.
                      // Προσοχή να μη βγούμε έξω από το Παράθυρο.
                      if B1 < 0 then
                        begin inc(B1); inc(D1); end
                        else begin
                              imcen  := imcen - stepy;
                              bifycenter := bifycenter + bifstepy;
                              Info.Label17.Caption := Format(F1817,[imcen]);
                             end;
                    end;
                 end;
     VK_DOWN   :  begin
                   if WalkMode then
                     begin
                     walkdown;
                     cross;
                     exit;
                     end;
                   if Shift = [ssAlt] then begin   // Alt key pressed.
                     inc(B1,10); inc(D1,10);  // 10 pixels κάτω.
                     // Προσοχή να μη βγούμε έξω από το Παράθυρο.
                     if D1>maxy then
                     begin dec(B1,10); dec(D1,10); end
                     else begin
                           imcen := imcen + 10*stepy;
                           bifycenter := bifycenter - 10* bifstepy;
                           Info.Label17.Caption := Format(F1817,[imcen]);
                          end;
                    end
                    else begin
                    inc(B1); inc(D1);   // 1 pixel κάτω.
                    // Προσοχή να μη βγούμε έξω από το Παράθυρο.
                    if D1>maxy then
                     begin dec(B1); dec(D1); end
                     else begin
                           imcen  := imcen + stepy;
                           bifycenter := bifycenter - bifstepy;
                           Info.Label17.Caption := Format(F1817,[imcen]);
                          end;
                    end;
                  end;
     VK_LEFT   :  begin
                   if WalkMode then
                     begin
                     walkleft;
                     cross;
                     exit;
                     end;
                    if Shift = [ssAlt] then begin   // Alt key pressed.
                      dec(A1,10); dec(C1,10);   // 10 pixels αριστερά.
                      // Προσοχή να μη βγούμε έξω από το Παράθυρο.
                      if A1<0 then
                       begin inc(A1,10); inc(C1,10); end
                       else begin
                             recen := recen - 10*stepx;
                             bifxcenter := bifxcenter - 10*bifstepx;
                             Info.Label16.Caption := Format(F1817,[recen]);
                            end;
                    end
                    else begin
                     dec(A1); dec(C1);  // 1 pixel αριστερά.
                     // Προσοχή να μη βγούμε έξω από το Παράθυρο.
                     if A1<0 then
                      begin inc(A1); inc(C1); end
                      else begin
                            recen := recen - stepx;
                            bifxcenter := bifxcenter - bifstepx;
                            Info.Label16.Caption := Format(F1817,[recen]);
                           end;
                    end;
                  end;
     VK_RIGHT  :  begin
                   if WalkMode then
                     begin
                     walkright;
                     cross;
                     exit;
                     end;
                   if Shift = [ssAlt] then begin   // Alt key pressed.
                      inc(A1,10); inc(C1,10);   // 10 pixels δεξιά.
                      // Προσοχή να μη βγούμε έξω από το Παράθυρο.
                      if C1>maxx then
                       begin dec(A1,10); dec(C1,10); end
                       else begin
                             recen := recen + 10*stepx;
                             bifxcenter := bifxcenter + 10*bifstepx;
                             Info.Label16.Caption := Format(F1817,[recen]);
                            end;
                    end
                   else begin
                   inc(A1); inc(C1); // 1 pixel δεξιά.
                   // Προσοχή να μη βγούμε έξω από το Παράθυρο.
                   if C1>maxx then
                    begin dec(A1); dec(C1); end
                    else begin
                           recen := recen + stepx;
                           bifxcenter := bifxcenter + bifstepx;
                           Info.Label16.Caption := Format(F1817,[recen]);
                         end;
                   end;
                  end;
    end;
    XMax := recen + r;
    XMin := recen - r;
    YMax := imcen - r;
    YMin := imcen + r;
    Info.Label26.Caption := Format(F1817,[XMax]);
    Info.Label30.Caption := Format(F1817,[XMin]);
    Info.Label32.Caption := Format(F1817,[YMax]);
    Info.Label34.Caption := Format(F1817,[YMin]);
     cross;
     with BM.Canvas do
     begin
       Brush.Style := bsClear;
       Pen.Mode := pmNot;
       Rectangle(A1,B1,C1,D1);
       MoveTo(crossx,crossy-10 );
       LineTo(crossx,crossy+10 );
       MoveTo(crossx-10,crossy );
       LineTo(crossx+10,crossy );
       Brush.Style := bsSolid;
       Pen.Mode := pmCopy;
     end;
end;

procedure TBM.SaveBMPClick(Sender: TObject);
var
Bitmap1 : TBitmap;
Jpg1 : TJPEGImage;
//Gifile1 : TGifImage;
//Png1 : TPngImage;
FileExtS,newname : String;
answer : Word;
label bailout;
begin
 SaveDialog1.Title := s2;
 SaveDialog1.FilterIndex := 6;
 SaveDialog1.InitialDir := GraphicsDirectory;

 Bitmap1 := TBitmap.Create;
 Bitmap1.PixelFormat := pf24bit;
 Bitmap1.Width := BM.ClientWidth;
 Bitmap1.Height := BM.ClientHeight;
 Bitmap1.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
 if SaveDialog1.Execute then
 begin
   FileExtS := UpperCase(ExtractFileExt(SaveDialog1.Filename));
   if FileExtS = FileX[feBMP] then
    begin
     Bitmap1.SaveTofile(SaveDialog1.Filename);
     Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
    end
    else if FileExtS = FileX[feJPG] then
      begin
      Jpg1 := TJPEGImage.Create;
      Jpg1.Assign(Bitmap1);
      Jpg1.ProgressiveEncoding := jpgProgEncode;
      Jpg1.CompressionQuality := jpgCmpQlt;
        try
        Jpg1.SaveToFile(SaveDialog1.Filename);
        finally
        jpg1.Free;
        end;
      Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
      end
  { else if (FileExtS = FileX[fePNG]) then
    begin
      WriteBitmapToPngFile(SaveDialog1.Filename, Bitmap1,clNone);
      Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
    end
   else if (FileExtS = FileX[feWMF]) or (FileExtS = FileX[feEMF])  then
   begin
    MF := TMetafile.Create;
    if FileExtS = FileX[feEMF] then MF.Enhanced := True
    else MF.Enhanced := false;
    MF.Width :=  BM.ClientWidth;
    MF.Height := BM.ClientHeight;

    MFCanvas := TMetafileCanvas.Create(MF,0 );

    with MFCanvas do
    try
     CopyRect(BM.clientRect,temp.Canvas,BM.clientrect);
    finally
     Free;
    end;
   Canvas.Draw(0,0,MF);
   MF.SaveToFile(SaveDialog1.Filename);
   MF.Free;
   end }
//*****************************************
    {  else if (FileExtS = FileX[feGIF]) then
      begin
        Gifile1 := TGifImage.Create;
        SetGifOptions(Gifile1);
        Gifile1.Assign(Bitmap1);
        Gifile1.SaveToFile(SaveDialog1.Filename);
        Gifile1.Free;
        Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
      end
    else if (FileExtS = FileX[feTGA]) then
      begin
        SaveToFileX(SaveDialog1.Filename, BitMap1,2); // save as 24bit - 16M colors
        Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
      end
    else if ((FileExtS = FileX[feTIF]) or (FileExtS = FileX[feTIFF])) then
      begin
       WriteTiffToFile (SaveDialog1.Filename, BitMap1);
       Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
      end   }
   { else if (FileExtS = FileX[fePCX]) then
      begin
        SaveToFilePCX(SaveDialog1.Filename, BitMap1,1); // save as 24bit - 16M colors
        Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
      end   }
    else begin
          beep;
          MessageDlg(NOGRAPHIC,mtError,[mbOk],0);
          goto bailout;
         end;
//**************************************
answer := MessageDlg('Save Fractal Parameter File with the same Name?'#13#10+
            'This will enable you to open a picture (fractal) file and'#13#10+
            'Load the assosiated Parameter File, so you can continue working on'#13#10+
            'the fractal. Zoom In, change colors and parameters and so on. ',mtConfirmation,[mbYes,mbNo],0);
 if (answer = mrYes) then
   begin
    newname := extractfilename(SaveDialog1.Filename);
    SaveDialog1.Filename := ChangeFileExt(newname, '.FPR');
    PSave.Click;
   end;
 end;
bailout:
 Bitmap1.Free;
end;

procedure TBM.ProgUpdate(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
begin
  if Stage = psRunning then
    info.G1.Progress := percentDone;
    info.G1.Update;
end;

{procedure TBM.UpdateProgressBar(Sender: TObject; Action: TProgressAction;
      PercentComplete: Longint);
begin
  case Action of
    paStart: begin
           Screen.Cursor := crHourGlass;
           info.G1.Visible := true;
           end;
    paRunning:
      begin
        info.G1.Progress := PercentComplete;
        info.G1.Update;
      end;
    paEnd:
      begin
        Screen.Cursor := crDefault;
        info.g1.Visible := false;
      end;
  end;
end;  }

procedure TBM.OpenBMPClick(Sender: TObject);
var
Bitmap1 : TBitmap;
Jpg1 : TJPEGImage;
//Gif1 : TGifImage;
//Fif1 : TFIFImage;
//Png1 : TPngImage;
newname : String;
begin
OpenPictureDialog1.Title := s1;
OpenPictureDialog1.FilterIndex := 7;
//if not RememberLastDir1.checked then
OpenPictureDialog1.InitialDir := GraphicsDirectory;
Bitmap1 := TBitmap.Create;
Bitmap1.PixelFormat := pf24bit;

if OpenPictureDialog1.Execute then
 begin
  info.G1.Progress := 0;
  info.g1.Visible := true;
  passes := 1;
  s9 := OpenPictureDialog1.FileName;

  FileExt := UpperCase(ExtractFileExt(OpenPictureDialog1.Filename));
   if (FileExt = FileX[feJPG]) then
    begin
     Jpg1 := TJPEGImage.Create;
     Jpg1.OnProgress := ProgUpdate;
     Jpg1.PixelFormat := jpgPxlFrm;
     Jpg1.Grayscale := GraySc;
     Jpg1.ProgressiveDisplay := PrDisplay;
     Jpg1.Performance := jpgPerf;
     Jpg1.Scale := jpgSize;
     Jpg1.Smoothing := SmoothDisplay;
     Jpg1.LoadFromFile(s9);
     info.G1.Progress := 100;
     Bitmap1.Assign(Jpg1);
     Jpg1.Free;
     LoadedBMP := s9; //OpenPictureDialog1.Filename;
    end

    {else if (FileExt = FileX[fePNG]) then
    begin
     ReadBitmapFromPngFile(OpenPictureDialog1.Filename, Bitmap1);
     LoadedBMP := s9; //OpenPictureDialog1.Filename;
    end }

    else if ((FileExt = FileX[feBMP]) or (FileExt = FileX[feTEX])or
             (FileExt = FileX[feRLE]) or (FileExt = FileX[feDIB])) then
      begin
        Bitmap1.LoadFromFile(s9);
        info.G1.Progress := 100;
        LoadedBMP := s9; //OpenPictureDialog1.Filename;
      end
        {else if (FileExt = FileX[feGIF]) then
      begin
             Gif1 := TGifImage.Create;
             Gif1.LoadFromFile(s9);
             info.G1.Progress := 100;
             Bitmap1.Assign(Gif1);
             Gif1.Free;
             LoadedBMP := s9; //OpenPictureDialog1.Filename;
      end
      else if (FileExt = FileX[feTGA]) then
      begin
        LoadFromFileX(s9, BitMap1);
        LoadedBMP := s9; //OpenPictureDialog1.Filename;
      end
      else if ((FileExt = FileX[feTIF]) or (FileExt = FileX[feTIFF])) then
        begin
         LoadTiffFromFile(s9, Bitmap1);
         LoadedBMP := s9;
        end   }
      {else if (FileExt = FileX[fePCX]) then
       begin
        LoadFromFilePCX(s9,BitMap1);
        LoadedBMP := s9;
       end }
      {  else if (FileExt = FileX[feFIF]) then
      begin
             Fif1 := TFIFImage.Create;
             Fif1.OnLoading := UpdateProgressBar;
             Fif1.ColorFormat := FIFColorFormat;
             Fif1.Height := ClientHeight;
             Fif1.Width  := ClientWidth;
             Fif1.LoadFromFile(s9);
             info.G1.Progress := 100;
             Bitmap1.Assign(Fif1.Bitmap);
             Fif1.Free;
             LoadedBMP := s9;
      end }
   { else if (FileExt = FileX[feWMF]) or (FileExt = FileX[feEMF]) then
    begin
     MF := TMetafile.Create;
     MF.MMWidth := ClientWidth;
     MF.MMHeight := ClientHeight;
     Bitmap1.Width := ClientWidth;
     Bitmap1.Height := ClientHeight;
     bitmap1.Canvas.Brush.Color := Color;
     PatBlt(bitmap1.canvas.handle,0,0,width,height,PATCOPY);
     MF.LoadFromFile(s9);
     if ClearWind1.Checked then
          begin
          MF.Transparent := false;
          PatBlt(bitmap1.canvas.handle,0,0,width,height,PATCOPY);
          end
     else  begin
            MF.Transparent := true;
            Bitmap1.Assign(temp);
           end;
     if MetaStrech.Checked then
        bitmap1.Canvas.StretchDraw(ClientRect,MF)
     else bitmap1.Canvas.Draw(0,0,MF);
     LoadedBMP := s9;
     MF.Free;
    end  }
   else begin
         MessageDlg(FILENOTSUPPORTED,mtError,[mbOK],0);
         info.g1.Visible := false;
         Bitmap1.Free;
         exit;
        end;
  info.g1.Visible := false;
  if (Bitmap1.Width >= Screen.Width) or (Bitmap1.Height >= Screen.Height) then
    begin
    Top := 0; Left := 0;
    Width := Screen.Width; Height := Screen.Height;
    TooLarge := True;
    end
  else
  if (Bitmap1.Width > 500) or (Bitmap1.Height > 500) then
   begin
    Top := 0; Left := 0;
    ClientWidth  := Bitmap1.Width;
    ClientHeight := Bitmap1.Height ;
    TooLarge := False;
   end
   else
     begin
      ClientWidth  := Bitmap1.Width;
      ClientHeight := Bitmap1.Height ;
      TooLarge := False;
     end;
  Cut1.Enabled := True;
  Copy1.Enabled := True;
  Revert1.enabled := True;
  BM.Canvas.CopyMode := cmSrcCopy;
  if TooLarge then  BM.Canvas.StretchDraw(BM.ClientRect,Bitmap1)
  else
    BM.Canvas.CopyRect(BM.ClientRect,Bitmap1.Canvas,BM.ClientRect);
  temp.Width :=  Bitmap1.Width;
  temp.Height := Bitmap1.Height;
  temp.Assign(Bitmap1);
  temp.PixelFormat := pf24bit;
  original.Width := ClientWidth;
  original.Height := ClientHeight;
  original.assign(bitmap1);
  original.Canvas.Pixels[0,0] := bitmap1.Canvas.Pixels[0,0];
  original.PixelFormat := pf24bit;

  Globundo := false;
  BmpLoaded := True;
  Bitmap1.Free;

  newname := ChangeFileExt(extractfilename(OpenPictureDialog1.Filename), '.FPR');
  if fileexists(ParamsDirectory +'\'+newname) then
   begin
   LoadwithBMPFlag := True;
   OpenCommandLineParam(ParamsDirectory +'\'+newname);
   end;
 Caption := fcapt + ' [ ' + OpenPictureDialog1.Filename + ' ]';
 end;
end;

procedure TBM.About2Click(Sender: TObject);
begin
Application.CreateForm(TaboutBox,AboutBox);
AboutBox.Showmodal;
end;

procedure TBM.InvertImage1Click(Sender: TObject);
begin
Canvas.CopyMode := cmNotSrcCopy;
Canvas.CopyRect(ClientRect, Canvas, ClientRect);
temp.Canvas.CopyMode := cmNotSrcCopy;
temp.Canvas.CopyRect(ClientRect, temp.Canvas, ClientRect);
Canvas.CopyMode := cmSrcCopy;
temp.Canvas.CopyMode := cmSrcCopy;
original.Assign(temp);
if SndMenu.checked then MessageBeep(MB_ICONEXCLAMATION);
end;

procedure TBM.LdCombImageClick(Sender: TObject);
var
Bitmap1,btm2 : TBitmap;
Jpg1 : TJPEGImage;
//Gif1 : TGifImage;
ss,FileExtC: String;
i,j : Integer;
begin
CopyUndoBmp;
OpenDialog1.Title := s1;
OpenDialog1.FilterIndex := 7;
OpenDialog1.InitialDir := GraphicsDirectory;
Bitmap1 := TBitmap.Create;
if OpenDialog1.Execute then
 begin
  passes := 1;
  ss := OpenDialog1.Filename;
  FileExtC := UpperCase(ExtractFileExt(OpenDialog1.Filename));
  if (FileExtC = FileX[feJPG]) then
    begin
     Jpg1 := TJPEGImage.Create;
     Jpg1.ProgressiveDisplay := PrDisplay;
     Jpg1.Performance := jpgPerf;
     Jpg1.Scale := jpgSize;
     Jpg1.Smoothing := SmoothDisplay;
     Jpg1.LoadFromFile(ss);
     Bitmap1.Assign(Jpg1);
     Jpg1.Free;
    end
    else
    if ((FileExtC = FileX[feBMP])or (FileExt = FileX[feDIB])or (FileExt = FileX[feRLE])) then
           begin
             Bitmap1.LoadFromFile(ss);
           end
     else if  (FileExtC = FileX[feTEX]) then
           begin
             Bitmap1.LoadFromFile(ss);
             btm2 := TBitmap.Create;
             btm2.Height := BM.ClientHeight;
             btm2.width := BM.ClientWidth;
             i:=0;
              while i < BM.ClientWidth do
               begin
                 j:=0;
                 while j< BM.ClientHeight  do
                   begin
                     btm2.Canvas.Draw(i,j,bitmap1);
                     inc(j,bitmap1.Height);
                   end;
                 inc(i,bitmap1.Width);
               end;
              BM.Canvas.CopyMode := cmmergepaint; //cmSrcInvert;
              BM.Canvas.copyrect(BM.ClientRect,btm2.Canvas,BM.ClientRect);
              BM.Canvas.CopyMode := cmSrcCopy;
              temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
              btm2.Free;
              exit;
           end
          {else if (FileExtC = FileX[feGIF]) then
            begin
             Gif1 := TGifImage.Create;
             Gif1.LoadFromFile(ss);
             Bitmap1.Height := Gif1.Height;
             Bitmap1.Width  := Gif1.Width;
             Bitmap1.Assign(Gif1);
             Gif1.Free;
           end      }
    {else if (FileExtC = FileX[fePNG]) then
    begin
     ReadBitmapFromPngFile(ss, Bitmap1);
    end
    else if (FileExtC = FileX[feTGA]) then
      begin
        LoadFromFileX(ss, BitMap1);
      end
    else if ((FileExtC = FileX[feTIF]) or (FileExtC = FileX[feTIFF])) then
        begin
         LoadTiffFromFile(ss, Bitmap1);
        end
    else if (FileExtC = FileX[feWMF]) or (FileExtC = FileX[feEMF]) then
    begin
     MF := TMetafile.Create;
     MF.MMWidth := ClientWidth;
     MF.MMHeight := ClientHeight;
     Bitmap1.Width := ClientWidth;
     Bitmap1.Height := ClientHeight;
     MF.LoadFromFile(ss);
     bitmap1.Canvas.StretchDraw(ClientRect,MF);
     MF.Free;
    end  }
   else begin
         MessageDlg(FILENOTSUPPORTED + #10#13 + '  for this operation',mtError,[mbOK],0);
         info.g1.Visible := false;
         Bitmap1.Free;
         exit;
        end;
  repaint;
  Canvas.CopyMode := cmSrcInvert;
  Canvas.StretchDraw(ClientRect, Bitmap1);
  temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
  original.Assign(temp);
 end;
 Bitmap1.Free;
 Canvas.CopyMode := cmSrcCopy;
end;

procedure TBM.BackgrndBMPClick(Sender: TObject);
var
Bitmap1 : TBitmap;
Jpg1 : TJPEGImage;
//Gif1 : TGifImage; //TGifBitmap;
//Png1 : TPngImage;
FileExtB : String;
begin
OpenPictureDialog1.Title := s5;
OpenPictureDialog1.FilterIndex := 7;
//if not RememberLastDir1.checked then
OpenPictureDialog1.InitialDir := GraphicsDirectory;
Bitmap1 := TBitmap.Create;
Bitmap1.PixelFormat := pf24bit;
if OpenPictureDialog1.Execute then
 begin
  passes := 1;
  BM.Canvas.CopyMode := cmSrcCopy;
  FileExtB := UpperCase(ExtractFileExt(OpenPictureDialog1.Filename));
  if (FileExtB = FileX[feJPG]) then
    begin
     Jpg1 := TJPEGImage.Create;
     Jpg1.ProgressiveDisplay := PrDisplay;
     Jpg1.Performance := jpgPerf;
     Jpg1.Scale := jpgSize;
     Jpg1.Smoothing := SmoothDisplay;
     Jpg1.LoadFromFile(OpenPictureDialog1.Filename);
     Bitmap1.Height := Jpg1.Height;
     Bitmap1.Width  := Jpg1.Width;
     Bitmap1.Canvas.Draw(0,0,Jpg1);
     Jpg1.Free;
     BackgroundBMP := OpenPictureDialog1.Filename;
    end
  {else if (FileExtB = FileX[fePNG]) then
    begin
     ReadBitmapFromPngFile(OpenPictureDialog1.Filename, Bitmap1);
     BackgroundBMP := OpenPictureDialog1.Filename;
     //LoadedBMP := OpenPictureDialog1.Filename;
    end
   else if (FileExt = FileX[feTGA]) then
      begin
        LoadFromFileX(OpenPictureDialog1.Filename, BitMap1);
        BackgroundBMP := OpenPictureDialog1.Filename;
      end
   else if ((FileExt = FileX[feTIF]) or (FileExt = FileX[feTIFF])) then
        begin
         LoadTiffFromFile(OpenPictureDialog1.Filename, Bitmap1);
         LoadedBMP := OpenPictureDialog1.Filename;
        end       }
  else if ((FileExtB = FileX[feBMP]) or (FileExtB = FileX[feTEX]) or
           (FileExtB = FileX[feRLE]) or (FileExtB = FileX[feDIB])  ) then
      begin
        Bitmap1.LoadFromFile(OpenPictureDialog1.Filename);
        BackgroundBMP := OpenPictureDialog1.Filename;
      end;
      { else if (FileExtB = FileX[feGIF]) then
            begin
             Gif1 := TGifImage.Create;
             Gif1.LoadFromFile(OpenPictureDialog1.Filename);
             Bitmap1.Height := Gif1.Height;
             Bitmap1.Width  := Gif1.Width;
             Bitmap1.Assign(Gif1);
             Gif1.Free;
             BackgroundBMP := OpenPictureDialog1.Filename;
           end; }
  temp.Width :=  BM.ClientWidth;
  temp.Height := BM.ClientHeight;
  BM.Canvas.StretchDraw(BM.ClientRect,Bitmap1);
  temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
  Caption := fcapt + ' [ ' + OpenPictureDialog1.Filename + ' ]';
  clrback.checked := False;
  Cut1.Enabled := True;
  Copy1.Enabled := True;
 end;
 Bitmap1.Free;
end;

procedure TBM.clrbackClick(Sender: TObject);
begin
 clrback.checked := not clrback.checked;
 clrscr;
end;

procedure TBM.Print1Click(Sender: TObject);
var
prbmp : TBitmap;
f: File;
d: Trect;
factor : Integer;
label
StartPrinting,bailout;
begin
passes := 1;
prbmp := TBitmap.Create;
  temp.SaveToFile('prntr.bmp');
  prbmp.LoadFromFile('prntr.bmp');
  Application.CreateForm(TPSizeForm,PSizeForm);
  PSizeForm.ShowModal;
case PSizeForm.RadioGroup1.ItemIndex  of
   0: factor := 250;
   1: factor := 500;
   2: factor := 1000;
   3: factor := 1500;
 else factor := 0;
 end;
if PrintDialog.Execute then
begin
  d.left   := 10;
  d.top    := 10;
  d.right  := d.left + factor;
  d.bottom := d.top + factor;
 if PsizeForm.FullPage.checked then
  begin
   d.left   := 10;
   d.top    := 10;
   d.right  := Printer.Pagewidth-10;
   d.bottom := Printer.Pageheight-10;
  end
 else
 If PSizeForm.Pcenter.checked then
  begin
  d.left   := (abs(Printer.Pagewidth - prbmp.width - factor) div 2);
  d.top    := (abs(Printer.Pageheight - prbmp.height - factor) div 2);
  d.right  := ((Printer.Pagewidth + prbmp.width + factor) div 2);
  d.bottom := ((Printer.Pageheight + prbmp.height + factor) div 2);
  end;
StartPrinting:
  Printer.BeginDoc;
  Printer.Canvas.Brush.Style := bsSolid;
  Printer.Canvas.Pen.Style := psSolid;
  Printer.Canvas.Pen.Mode := pmCopy;
  TRY
  Printer.Canvas.StretchDraw(d, prbmp);
  FINALLY
  Printer.EndDoc;
  END;
 end;
bailout:
 AssignFile(f,'prntr.bmp');
 erase(f);
 prbmp.free;
 end;

{procedure TBM.PrinterSetUp1Click(Sender: TObject);
begin
 Psetup.Execute;
end; }
{
procedure TBM.FormClick(Sender: TObject);
begin

				Extended mouseX := (Extended) Sender.getX;
				Extended mouseY := (Extended) e.getY;

				switch ( e.getButton)
        begin
				// Left mouse button clicked
			  	case MouseEvent.BUTTON1:
					adjustZoom(mouseX,mouseY, zoomFactor * 2);
					break;

				// Right mouse button clicked
				 case MouseEvent.BUTTON3:  // Button2 is the mousewheel
					adjustZoom(mouseX,mouseY, zoomFactor / 2);
					break;
				end;
end;
  }
procedure TBM.FormClose(Sender: TObject; var Action: TCloseAction);
var
f: TRegIniFile;
//gif1: TgifImage;
begin
//Gif1 := TGifImage.Create;
//SetGifOptions(Gif1);
   // Write the MainWindow Section Info
f := TRegIniFile.Create(REGPLACE);
f.WriteString('Program','Program Directory',CurrentDirectory);
f.WriteInteger(MAINW,'Left',BM.Left);
f.WriteInteger(MAINW,'Top',BM.Top);
f.WriteInteger(MAINW,'Height',BM.Height);
f.WriteInteger(MAINW,'Width',BM.Width);
f.WriteInteger(MAINW,'BackGround Color',BM.Color);
f.WriteString(MAINW,'Version',Format('%2.1f',[VerNum]));
//f.WriteBool(MAINW,'Remember Dirs',RememberLastDir1.checked);
f.WriteBool(MAINW,'Internal Editor',FileEditMenu.Checked);
//f.WriteBool(MAINW,'Scanner Options',ShowScanOptions1.Checked);
  {if BmpLoaded then
     f.WriteString(MAINW,'Bitmap',LoadedBMP)
  else
     f.WriteString(MAINW,'Bitmap',''); }
f.WriteBool(INFOWINDOW,'On',Info.Visible);
f.WriteInteger(INFOWINDOW,'Left',Info.Left);
f.WriteInteger(INFOWINDOW,'Top',Info.Top);
//f.WriteBool(TOOLBAR,'On',FracTools.Visible);
//f.WriteInteger(TOOLBAR,'Left',FracTools.Left);
//f.WriteInteger(TOOLBAR,'Top',FracTools.Top);
//f.WriteInteger(TOOLBAR,'Width',FracTools.Width);
//f.WriteInteger(TOOLBAR,'Height',FracTools.Height);
f.WriteInteger(GLOBAL,'BioMorph Color',BioColor);
f.WriteInteger(GLOBAL,'BioMorph Color 2',BioColor2);
f.WriteString(GLOBAL,'Palette Name',PaletteName);
f.WriteString(GLOBAL,'Help FileName',Application.HelpFile);
// Fractal Specific Parameters.
f.WriteString(GLOBAL,'Xr',Format(F1210,[Xr]));
f.WriteString(GLOBAL,'Xim',Format(F1210,[Xim]));
f.WriteString(GLOBAL,'CosXr',Format(F1210,[CosXr]));
f.WriteString(GLOBAL,'CosXim',Format(F1210,[CosXim]));
f.WriteString(GLOBAL,'SinXr',Format(F1210,[SinXr]));
f.WriteString(GLOBAL,'SinXim',Format(F1210,[SinXim]));
f.WriteString(GLOBAL,'Yr',Format(F1210,[Yr]));
f.WriteString(GLOBAL,'Yim',Format(F1210,[Yim]));
f.WriteString(GLOBAL,'LamdaR',Format(F1210,[LamdaR]));
f.WriteString(GLOBAL,'LamdaIm',Format(F1210,[LamdaIm]));
f.WriteString(GLOBAL,'Br',Format(F1210,[Br]));    // Barnsley3 Fractal Parameter
f.WriteString(GLOBAL,'T5r',Format(F1210,[T5r]));     // TChebychev T5
f.WriteString(GLOBAL,'T5im',Format(F1210,[T5im]));   // TChebychev T5
f.WriteString(GLOBAL,'Halley BailOut Value',Format(F1210,[HalleyBailOut]));
f.WriteInteger(GLOBAL,'BailOut Value',bailoutvalue);
f.WriteInteger(GLOBAL,'Drawing Method',Params1.RadioGroup1.ItemIndex);
f.WriteInteger(GLOBAL,'Coloring Mode',Params1.ColoringMode.ItemIndex);
f.WriteInteger(GLOBAL,'OutSide Color',Params1.OutsideCombo.ItemIndex);
f.WriteInteger(GLOBAL,'Split Screen Order',SplitConForm.RadioGroup1.ItemIndex);
f.writeInteger(GLOBAL,'Halley Function', HalFunc.Radiogroup1.ItemIndex);
f.WriteInteger(GLOBAL,'Iteration Step',stepiter);
f.WriteInteger(GLOBAL,PALETTEBSC,PalStartColor);
f.WriteInteger(GLOBAL,PALETTEBMC,PalMidColor);
f.WriteInteger(GLOBAL,PALETTEBEC,PalEndColor);
f.WriteBool(GLOBAL,'Progress Bar',ProgBarMenu.checked);
f.WriteBool(GLOBAL,'Timer',TimerMenu.Checked);
//f.WriteBool(METAFILEOPTIONS,'Clear Window',clearwind1.checked);
//f.WriteBool(METAFILEOPTIONS,'Stretch',MetaStrech.checked);
//f.WriteInteger('FIF Options','Color Format',ord(FIFColorFormat));

//f.WriteInteger(GIFOPTIONS,'Color Reduction',ord(GIF1.ColorReduction));
//f.WriteInteger(GIFOPTIONS,'Dither Mode',ord(GIF1.DitherMode));
//f.WriteInteger(GIFOPTIONS,'Compression Method',ord(GIF1.Compression));

//*******************************************************************************
  f.WriteString(STRANGEATTR,'Rossler a',Format(F74,[Raaa]));
  f.WriteString(STRANGEATTR,'Rossler b',Format(F74,[Rbbb]));
  f.WriteString(STRANGEATTR,'Rossler c',Format(F74,[Rccc]));
  f.WriteString(STRANGEATTR,'Rossler dt',Format(F74,[Rdt]));
  f.WriteInteger(STRANGEATTR,'Rossler Loops',RLoops);
  f.WriteInteger(STRANGEATTR,'Rossler Hide',RHide);
  f.WriteInteger(STRANGEATTR,'Rossler ColorStep',RColorEvery);
  f.WriteString(STRANGEATTR,'Lorenz a',Format(F74,[Laaa]));
  f.WriteString(STRANGEATTR,'Lorenz b',Format(F74,[Lbbb]));
  f.WriteString(STRANGEATTR,'Lorenz c',Format(F74,[Lccc]));
  f.WriteString(STRANGEATTR,'Lorenz dt',Format(F74,[Ldt]));
  f.WriteInteger(STRANGEATTR,'Lorenz Loops',LLoops);
  f.WriteInteger(STRANGEATTR,'Lorenz Hide',LHide);
  f.WriteInteger(STRANGEATTR,'Lorenz ColorStep',LColorEvery);
//**********************************************************************************
f.free;

//Gif1.Free;
Application.HelpCommand(HELP_QUIT,0);

if Clipboard.HasFormat(CF_BITMAP) then
if MessageDlg(ERASECLIP,mtConfirmation, [mbYes, mbNo], 0) = mrYes then Clipboard.Clear;
Action := caFree;
end;

Procedure InitPalete;
var
index : Byte;
begin
  RED1   := 0;
  GREEN1 := 0;
  BLUE1  := 255;
  pal[0] := RGB(0,0,0);
  index := 1;
  while index < 255 do
  begin
    pal[index] := RGB(RED1,GREEN1,BLUE1);
    inc(RED1,2);
    if RED1 > 253 then RED1 := RED1 - 253;
    inc(GREEN1,3);
    if GREEN1 > 252 then GREEN1 := GREEN1 - 252;
    dec(BLUE1,3);
    if BLUE1 < 3 then BLUE1 := BLUE1 + 253;
    inc(index);
  end;
  pal[index] := RGB(RED1,GREEN1,BLUE1);
end;

procedure TBM.LoadPaletteClick(Sender: TObject);
var
 I,Fin: TextFile;
 index : Integer;
 r,g,b : Integer;
 r1,dummy: String;
label getout;
begin
OpenDialog1.Title := s6;
OpenDialog1.FilterIndex := 3;
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
     Application.MessageBox(NOPALETTE,DLGERROR, MB_ICONERROR + MB_OK);
     goto getout;
    end;
      index:=0;
      while not Eof(I) do
       begin
        Readln(I,dummy);
        pal[index] := StrToInt(dummy);
        inc(index);
        if index > 255 then break;
       end;
     StUpdate;
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
        pal[index] := RGB(r,g,b);
        inc(index);
        if index > 255 then break;
      end;
    CloseFile(Fin);
    StUpdate;
  end
 else begin
  Application.MessageBox(NOPALETTE,DLGERROR, MB_ICONERROR + MB_OK);
  exit;
   end;
FillPalListArray;
//CopyUndoBmp;
//ApplyNewPalette;
end;
end;

procedure TBM.MirorImage1Click(Sender: TObject);
begin
CopyUndoBmp;
Canvas.StretchDraw(Rect(ClientWidth,0,0,ClientHeight), temp);
temp.Width := ClientWidth;
temp.Height := ClientHeight;
temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
original.Assign(temp);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
end;

procedure TBM.MirorImage2Click(Sender: TObject);
begin
CopyUndoBmp;
Canvas.StretchDraw(Rect(0,ClientHeight,ClientWidth,0), temp);
temp.Width := ClientWidth;
temp.Height := ClientHeight;
temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
original.Assign(temp);
if SndMenu.checked then MessageBeep(MB_ICONEXCLAMATION);
end;

procedure TBM.Cut1Click(Sender: TObject);
begin
 Clipboard.Assign(temp);
 clrback.checked := True;
 clrscr;
 Cut1.Enabled := False;
 Copy1.Enabled := False;
 Paste1.Enabled := True;
 ClearClipboard1.Enabled := True;
end;

procedure TBM.Copy1Click(Sender: TObject);
begin
Clipboard.Assign(temp);
ClearClipboard1.Enabled := True;
end;

procedure TBM.Paste1Click(Sender: TObject);
begin
if Clipboard.HasFormat(CF_BITMAP) then
 begin
   //BringTofront;
  // Application.ProcessMessages;
   copyundobmp;
   temp.Assign(Clipboard);
   Canvas.StretchDraw(BM.ClientRect, temp);
   original.Canvas.StretchDraw(ClientRect, temp);
   Copy1.Enabled := True;
   Cut1.Enabled := True;
 end;
end;

procedure TBM.ClearClipboard1Click(Sender: TObject);
begin
// Check If Clipboard Has Something In It Before Clearing.
if Clipboard.FormatCount > 0 then
   begin
   Clipboard.Clear;
   Paste1.Enabled := False;
   ClearClipboard1.Enabled := False;
   end;
end;

procedure TBM.FullScreen1Click(Sender: TObject);
begin
copyundobmp;
Application.CreateForm(TFullScreen,FullScreen);
FullScreen.ShowModal;
end;

procedure TBM.BackgrndColorMenuClick(Sender: TObject);
begin
ColorDialog1.Color := BM.Color; //BackgrndColor;
 if ColorDialog1.Execute then
    begin
    BM.Color := ColorDialog1.Color;
    clrback.checked := True;
    clrscr;
    end;
end;

procedure TBM.EditMenuClick(Sender: TObject);
begin
    Paste1.Enabled := ( Clipboard.HasFormat(CF_BITMAP) = True) ;
    ClearClipboard1.Enabled := ( Clipboard.HasFormat(CF_BITMAP) = True) ;
end;

procedure TBM.clearchecked;
var I : Byte;
begin
 for I := 0 to TypesMenu1.Count-1 do
      TypesMenu1.Items[I].Checked := False;
end;

procedure TBM.MandelbrotSet1Click(Sender: TObject);
begin
CopyUndoBmp;

if FractalCompleted then clrscr;

clearchecked;
WhatFractal := 12;
MandelbrotSet1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[mandel];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then SParams.ShowModal;
StUpdate;
FractalProc := ComputeMandel;
AllFractals;
end;

procedure TBM.CosSet1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 1;
CosSet1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[cosineset];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then TrigParams.ShowModal; //SParams.ShowModal;
StUpdate;
FractalProc := ComputeCosine;
AllFractals;
end;

procedure TBM.SineSet1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 13;
SineSet1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[sineset];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then TrigParams.ShowModal; //SParams.ShowModal;
StUpdate;
FractalProc := ComputeSine;
AllFractals;
end;

procedure TBM.JuliaSet1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 6;
JuliaSet1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[juliaset];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := true;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then SParams.ShowModal;
c := Complexfunc(Yr,Yim);
//c := Complexfunc(0.383725,0.147851);  // a nice julia
//Yr := 0.383725; Yim := 0.147851;
StUpdate;
FractalProc := ComputeFullJulia;
AllFractals;
end;

procedure TBM.JuliaSet2Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 20;
JuliaSet2.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
Globs.FractalName := Fractal[juliasetmap];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
//if not ComingFromZoom then SParams.ShowModal
//else
  //begin
   c.real := Julx;
   c.img := July;
  //end;
StUpdate;
//**********************************
contjul := true;
clrscr;
ContinuesJulia;
//************************************

//FractalProc := ComputeFullJulia;
//AllFractals;
end;

procedure TBM.Timer1Timer(Sender: TObject);
begin
if info.Visible then
begin
EndTime := Time;
TotalTime := EndTime - StartTime;
DecodeTime(TotalTime, Hours, Mins, Secs, Msecs);
Info.Label24.Caption := IntToStr(Hours)+':'+IntToStr(Mins)+':'
                        +IntToStr(Secs)+':'+IntToStr(Msecs);
end;
end;

procedure TBM.MandelOrbits1Click(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clrscr;
clearchecked;
WhatFractal := 7;
MandelOrbits1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[orbitsfunc];
//Params1.Auto1.Checked := True;
Params1.RadioGroup1.Enabled := false;
Params1.ColoringMode.Enabled := false;
Params1.OutsideCombo.Enabled := false;
StUpdate;
Orbits;
end;

procedure TBM.FilledOrbits1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 8;
FilledOrbits1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := False;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[forbits];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := true; //false;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := ComputeFilledMandelOrbits;
AllFractals;
end;

procedure TBM.N300Click(Sender: TObject);
begin
Top := 0;  Left := 292;
ClientWidth := 300;
ClientHeight := 300;
end;

procedure TBM.N400Click(Sender: TObject);
begin
Top := 0;  Left := 292;
ClientWidth := 400;
ClientHeight := 400;
end;

procedure TBM.N500Click(Sender: TObject);
begin
Top := 0;  Left := 292;
ClientWidth := 500;
ClientHeight := 500;
end;

procedure TBM.N1024Click(Sender: TObject);
begin
Top := 0;  BM.Left := 0;
ClientWidth := 1024;
ClientHeight := 768;
end;

procedure TBM.N800Click(Sender: TObject);
begin
Top := 0;  Left := 0;
ClientWidth := 800;
ClientHeight := 600;

end;

procedure TBM.N640Click(Sender: TObject);
begin
Top := 0;  Left := 0;
ClientWidth := 640;
ClientHeight := 480;
end;

procedure TBM.N320Click(Sender: TObject);
begin
ClientWidth := 320;
ClientHeight := 240;
end;

procedure TBM.OtherSizeClick(Sender: TObject);
begin
Application.CreateForm(TWinSize1,WinSize1);
With WinSize1 do
begin
Edit1.Text := IntToStr(BM.Width);
Edit2.Text := IntToStr(BM.Height);
ShowModal;
if ModalResult = mrOk then
  begin
    BM.ClientWidth := StrToInt(Edit1.Text);
    BM.ClientHeight := StrToInt(Edit2.Text);
    JustCenter := True;
    If CenterScreen.Checked then BM.Position := poScreenCenter
    else  begin BM.Top := 0;  BM.Left := 292; end;
    JustCenter := False;
  end;
end;
end;

procedure TBM.SavePaletteClick(Sender: TObject);
var
 I: Textfile;
 index : Integer;
begin
SaveDialog1.Title := s7;
SaveDialog1.FilterIndex := 3;
SaveDialog1.InitialDir := PaletteDirectory;
if SaveDialog1.Execute then
 begin
    AssignFile(I, SaveDialog1.Filename);
    Rewrite(I);
    Writeln(I,s8);
    for index:=0 to 255 do
      Writeln(I, IntToStr(pal[index]));
    CloseFile(I);
    PaletteName := SaveDialog1.Filename;
    StUpdate;
 end;
end;

procedure TBM.RotateByAngle1Click(Sender: TObject);
begin
AngleFrm.Edit1.Text := FloatToStr(MAngle);
AngleFrm.ShowModal;
if AngleFrm.ModalResult = mrOk then
  begin
    CopyUndoBmp;
    MAngle := StrToFloat(AngleFrm.Edit1.Text);
    RotateImage(MAngle);
  end;
end;

procedure TBM.RotateImage(Angle2 : Extended);
var
x,y,x1,y1    : Integer;
rads,cosa,sina : Extended;
hcosx,hsinx,hsiny,hcosy : Extended;
u,v : Extended;
temp1: TBitmap;
RowRGB :  pRGBArray;
AllScanLines : array[0..800] of pRGBArray;
begin
//**********************************
Screen.Cursor := crHourglass;
if TimerOn then
  begin
   Timer1.Enabled :=True;
   StartTime := Time;
  end;
if ProgressBarOn then
  begin
    info.G1.Progress := 0;
    info.G1.Visible := true;
  end;
temp1 := TBitmap.Create;
temp1.Height := ClientHeight;
temp1.Width := ClientWidth;
temp1.Assign(original);
for x:= 0 to temp1.Height do
    AllScanLines[x]:= temp1.ScanLine[x];
original.Width:= original.Width;
original.Height:= original.Height;
PatBlt(original.canvas.handle,0,0,original.width,original.height,BLACKNESS);
//***********************************
rads := Angle2/57.29577951308;
cosa := cos(rads);
sina := sin(rads);
hcosx := halfx*cosa;
hsinx := halfx*sina;
hsiny := halfy*sina;
hcosy := halfy*cosa;
u := - hcosx + halfx + hsiny;
v := - hsinx - hcosy + halfy;
//**********************************************************************************
for y:= 0 to maxy-1 do
 begin
   rowrgb   := original.ScanLine[y];
   Application.ProcessMessages;
   for x:=0 to maxx-1 do
     begin
       y1 := round(y*cosa + x*sina + v);
       x1 := round(x*cosa - y*sina + u);
       with canvas.ClipRect do
        begin
          if not ((x1 < top) or (y1<left) or (x1>right) or (y1>bottom)) then
           RowRGB[x] := AllScanLines[y1,x1];
        end;
     end;
   Info.G1.Progress := (100 * y) div maxy;
 end;
Info.G1.Progress := 100;
temp.Assign(original);
repaint;
temp1.free;
Screen.Cursor := crDefault;
info.g1.Visible := false;
if TimerOn then  Timer1.Enabled := False;
if SndMenu.checked then MessageBeep(MB_ICONEXCLAMATION);
end;

procedure TBM.SierpMenuClick(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clrscr;
clearchecked;
WhatFractal := 14;
SierpMenu.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
Globs.FractalName := Fractal[Sierpinski];
//Params1.Auto1.Checked := False;
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := false;
StUpdate;
SierpinskiFunc;
end;

procedure TBM.Revert1Click(Sender: TObject);
var
Bitmap1 : TBitmap;
Jpg1: TJPEGImage;
//Gif1 : TGifImage; //TGifBitmap;
//Fif1 : TFIFImage;
//png1 : TPngImage;
newname : String;
begin
  //if ((not Initiating) and (not ComingFromBrowse) and (not JustCenter) and (not Droped))  then
  //if MessageDlg(NOUNDO,mtWarning, [mbOk,mbCancel], 0) = mrCancel then exit;
  Initiating := False;
  ComingFromBrowse := False;
  Bitmap1 := TBitmap.Create;
  FileExt := UpperCase(ExtractFileExt(s9));
  if (FileExt = FileX[feJPG]) then
    begin
     Jpg1 := TJPEGImage.Create;
     Jpg1.PixelFormat := jpgPxlFrm;
     Jpg1.Grayscale := GraySc;
     Jpg1.ProgressiveDisplay := PrDisplay;
     Jpg1.Performance := jpgPerf;
     Jpg1.Scale := jpgSize;
     Jpg1.Smoothing := SmoothDisplay;
     Jpg1.LoadFromFile(s9);
     Bitmap1.Assign(Jpg1);
     Jpg1.Free;
     LoadedBMP := s9;
    end
    {else if (FileExt = FileX[fePNG]) then
    begin
     ReadBitmapFromPngFile(s9, Bitmap1);
     LoadedBMP := s9;
    end
    else if (FileExt = FileX[feTGA]) then
      begin
        LoadFromFileX(s9, BitMap1);
        LoadedBMP := s9; //OpenPictureDialog1.Filename;
      end
    else if ((FileExt = FileX[feTIF]) or (FileExt = FileX[feTIFF])) then
        begin
         LoadTiffFromFile(s9, Bitmap1);
         LoadedBMP := s9;
        end   }
    else if ((FileExt = FileX[feBMP]) or (FileExt = FileX[feTEX]) or
            (FileExt = FileX[feDIB]) or (FileExt = FileX[feRLE]))then
           begin
             Bitmap1.LoadFromFile(s9);
             LoadedBMP := s9;
           end
       {else if (FileExt = FileX[feGIF]) then
      begin
             Gif1 := TGifImage.Create;
             Gif1.LoadFromFile(s9);
             Bitmap1.Assign(Gif1);
             Gif1.Free;
             LoadedBMP := s9;
      end
        else if (FileExt = FileX[feFIF]) then
      begin
             Fif1 := TFIFImage.Create;
             Fif1.ColorFormat := FIFColorFormat;
             Fif1.Height := BM.ClientHeight;
             Fif1.Width  := BM.ClientWidth;
             Fif1.LoadFromFile(s9);
             Bitmap1.Assign(Fif1.Bitmap);
             Fif1.Free;
             LoadedBMP := s9;
      end }
     {else if (FileExt = FileX[feWMF]) or (FileExt = FileX[feEMF]) then
    begin
     MF := TMetafile.Create;
     MF.MMWidth := ClientWidth;
     MF.MMHeight := ClientHeight;
     Bitmap1.Width := ClientWidth;
     Bitmap1.Height := ClientHeight;
     bitmap1.Canvas.Brush.Color := Color;
     PatBlt(bitmap1.canvas.handle,0,0,width,height,PATCOPY);
     MF.LoadFromFile(s9);
     if ClearWind1.Checked then
        begin
          MF.Transparent := false;
          PatBlt(bitmap1.canvas.handle,0,0,width,height,PATCOPY);
        end
     else  begin
            MF.Transparent := true;
            Bitmap1.Assign(temp);
           end;
     if MetaStrech.Checked then
        bitmap1.Canvas.StretchDraw(ClientRect,MF)
     else bitmap1.Canvas.Draw(0,0,MF);
     LoadedBMP := s9;
     MF.Free;
    end    }
    else begin
         MessageDlg(FILENOTSUPPORTED,mtError,[mbOK],0);
         Bitmap1.Free;
         exit;
        end;
   if (Bitmap1.Width >= Screen.Width) or (Bitmap1.Height >= Screen.Height) then
    begin
    BM.Top := 0; BM.Left := 0;
    BM.Width := Screen.Width; BM.Height := Screen.Height;
    TooLarge := True;
    end
  else
  if (Bitmap1.Width > 500) or (Bitmap1.Height > 500) then
   begin
    BM.Top := 0; BM.Left := 0;
    BM.ClientWidth  := Bitmap1.Width;
    BM.ClientHeight := Bitmap1.Height ;
    TooLarge := False;
   end
   else
     begin
      BM.ClientWidth  := Bitmap1.Width;
      BM.ClientHeight := Bitmap1.Height ;
      TooLarge := False;
     end;
  Cut1.Enabled := True;
  Copy1.Enabled := True;
  Revert1.enabled := True;
  BM.Canvas.CopyMode := cmSrcCopy;
  if TooLarge then  BM.Canvas.StretchDraw(BM.ClientRect,Bitmap1)
  else
    BM.Canvas.CopyRect(BM.ClientRect,Bitmap1.Canvas,BM.ClientRect);
  temp.Width :=  Bitmap1.Width;
  temp.Height := Bitmap1.Height;
  temp.Assign(Bitmap1);
  temp.PixelFormat := pf24bit;
  original.Width := ClientWidth;
  original.Height := ClientHeight;
  original.assign(bitmap1);
  original.Canvas.Pixels[0,0] := bitmap1.Canvas.Pixels[0,0];
  original.PixelFormat := pf24bit;
  newname := ChangeFileExt(extractfilename(s9), '.FPR');
  if fileexists(ParamsDirectory +'\'+newname) then
   begin
   LoadwithBMPFlag := True;
   OpenCommandLineParam(ParamsDirectory +'\'+newname);
   end;
  Caption := fcapt + ' [ ' + s9 + ' ]';
  Bitmap1.free;
end;

procedure TBM.N2Click(Sender: TObject);
begin
if StrangeAttractors1.Checked then  AttractorForm.ShowModal
 else if Halley1.Checked      then  HalFunc.ShowModal
 else if MartinMenu.Checked   then  MartinParams.ShowModal
 else if UnityMenu.Checked    then  UnityForm.ShowModal
 else if ifs1.Checked         then  DoIfs
 else if lsystems1.Checked    then  DoLsys
 else if (CosSet1.Checked or SineSet1.Checked or HyperCos1.Checked or HyperSine1.Checked)
      then TrigParams.ShowModal
 else if BifMenu.Checked then BifParams.ShowModal
 else SParams.ShowModal;
end;

procedure TBM.Vertical1Click(Sender: TObject);
begin
clrscr;
Direction := fdTopToBottom;
BeginColor := clBlue;
EndColor := clBlack;
GradientFill;
temp.Width := BM.ClientWidth;
temp.Height := BM.ClientHeight;
temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
original.Assign(temp);
end;

procedure TBM.BackGroundDegrade1Click(Sender: TObject);
begin
Application.CreateForm(TgradformBack, gradformBack);
gradformBack.ShowModal;
if gradformBack.ModalResult = mrOK then
     begin
     passes:=1;
     CopyUndoBmp;
     GradientFill;
     temp.Width := BM.ClientWidth;
     temp.Height := BM.ClientHeight;
     temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
     original.Assign(temp);
     clrback.checked := false;
     end;
end;

procedure TBM.AddBMPFile1Click(Sender: TObject);
var
Bitmap1 : TBitmap;
Jpg1 : TJPEGImage;
//Gif1 : TGifImage;
ss,FileExtC: String;
x,y:Integer;
RowRGB,RowRGB1 : pRGBArray;
begin
CopyUndoBmp;
OpenDialog1.Title := s1;
OpenDialog1.FilterIndex := 7;
OpenDialog1.InitialDir := GraphicsDirectory;
Bitmap1 := TBitmap.Create;
if OpenDialog1.Execute then
 begin
  passes := 1;
  ss := OpenDialog1.Filename;

  FileExtC := UpperCase(ExtractFileExt(OpenDialog1.Filename));
  if (FileExtC = FileX[feJPG]) then
    begin
     Jpg1 := TJPEGImage.Create;
     Jpg1.ProgressiveDisplay := PrDisplay;
     Jpg1.Performance := jpgPerf;
     Jpg1.Scale := jpgSize;
     Jpg1.Smoothing := SmoothDisplay;
     Jpg1.LoadFromFile(ss);
     Bitmap1.Assign(Jpg1);
     //Bitmap1.Canvas.Draw(0,0,Jpg1);
     Jpg1.Free;
    end
//    else if (FileExtC = FileX[fePNG]) then
//    begin
//    ReadBitmapFromPngFile(ss, Bitmap1);
//    end
//    else if (FileExtC = FileX[feTGA]) then
//      begin
//        LoadFromFileX(ss, BitMap1);
//      end
//    else if ((FileExtC = FileX[feTIF]) or (FileExtC = FileX[feTIFF])) then
//        begin
//         LoadTiffFromFile(ss, Bitmap1);
//        end
    else if ((FileExtC = FileX[feBMP]) or (FileExtC = FileX[feTEX])
            or (FileExtC = FileX[feDIB]) or (FileExtC = FileX[feRLE]))  then
           begin
             Bitmap1.LoadFromFile(ss);
           end
//          else if (FileExtC = FileX[feGIF]) then
//            begin
//             Gif1 := TGifImage.Create;
//             Gif1.LoadFromFile(ss);
//             //Bitmap1.Height := Gif1.Height;
//             //Bitmap1.Width  := Gif1.Width;
//             Bitmap1.Assign(Gif1);
//             Gif1.Free;
//           end
//    else if (FileExtC = FileX[feWMF]) or (FileExtC = FileX[feEMF]) then
//    begin
//     MF := TMetafile.Create;
//     MF.MMWidth := ClientWidth;
//     MF.MMHeight := ClientHeight;
//     Bitmap1.Width := ClientWidth;
//     Bitmap1.Height := ClientHeight;
//     MF.LoadFromFile(ss);
//     bitmap1.Canvas.StretchDraw(ClientRect,MF);
//     MF.Free;
//    end
  else begin
         MessageDlg(FILENOTSUPPORTED + #10#13 + '  for this operation',mtError,[mbOK],0);
         info.g1.Visible := false;
         Bitmap1.Free;
         exit;
        end;

  repaint;
 // avoid access violation error if window resized before operation
 if ((bitmap1.Width <> clientwidth) or (temp.Width <> clientwidth) or
    (bitmap1.height <> clientheight) or (temp.height <> clientheight)) then
     begin
         MessageDlg(' This operation will not work because you either resized the window '+
         #10#13+' or pictures are different size' ,mtError,[mbOK],0);
         info.g1.Visible := false;
         Bitmap1.Free;
         exit;
        end;

  for y:= 0 to clientheight-1 do
   begin
    RowRGB1  := bitmap1.ScanLine[y];
    RowRGB   := temp.ScanLine[y];
    for x:= 0 to clientwidth-1 do
     begin
       RowRGB[x].rgbtRed   :=  (RowRGB[x].rgbtRed and RowRGB1[x].rgbtRed);
       RowRGB[x].rgbtGreen :=  (RowRGB[x].rgbtGreen and RowRGB1[x].rgbtGreen);
       RowRGB[x].rgbtBlue  :=  (RowRGB[x].rgbtBlue and RowRGB1[x].rgbtBlue);
     end;
   end;
 canvas.CopyRect(ClientRect,temp.Canvas,ClientRect);
 original.Assign(temp);
 end;
 Bitmap1.Free;
end;

procedure TBM.SubtractBMP1Click(Sender: TObject);
var
Bitmap1 : TBitmap;
Jpg1 : TJPEGImage;
//Gif1 : TGifImage;
ss,FileExtC: String;
x,y:Integer;
RowRGB,RowRGB1 : pRGBArray;
begin
CopyUndoBmp;
OpenDialog1.Title := s1;
OpenDialog1.FilterIndex := 7;
OpenDialog1.InitialDir := GraphicsDirectory;
Bitmap1 := TBitmap.Create;
if OpenDialog1.Execute then
 begin
  passes := 1;
  ss := OpenDialog1.Filename;
  FileExtC := UpperCase(ExtractFileExt(OpenDialog1.Filename));
   if (FileExtC = FileX[feJPG]) then
    begin
     Jpg1 := TJPEGImage.Create;
     Jpg1.ProgressiveDisplay := PrDisplay;
     Jpg1.Performance := jpgPerf;
     Jpg1.Scale := jpgSize;
     Jpg1.Smoothing := SmoothDisplay;
     Jpg1.LoadFromFile(ss);
     Bitmap1.Assign(Jpg1);
     Jpg1.Free;
    end
//    else if (FileExtC = FileX[fePNG]) then
//    begin
//     ReadBitmapFromPngFile(ss, Bitmap1);
//    end
//    else if (FileExtC = FileX[feTGA]) then
//      begin
//        LoadFromFileX(ss, BitMap1);
//      end
//    else if ((FileExtC = FileX[feTIF]) or (FileExtC = FileX[feTIFF])) then
//        begin
//         LoadTiffFromFile(ss, Bitmap1);
//        end
    else if ((FileExtC = FileX[feBMP]) or (FileExtC = FileX[feTEX])
             or (FileExtC = FileX[feDIB]) or (FileExtC = FileX[feRLE])) then
           begin
             Bitmap1.LoadFromFile(ss);
           end
//           else if (FileExtC = FileX[feGIF]) then
//            begin
//             Gif1 := TGifImage.Create;
//             Gif1.LoadFromFile(ss);
//             Bitmap1.Height := Gif1.Height;
//             Bitmap1.Width  := Gif1.Width;
//             Bitmap1.Assign(Gif1);
//             Gif1.Free;
//           end
//   else if (FileExtC = FileX[feWMF]) or (FileExtC = FileX[feEMF]) then
//    begin
//     MF := TMetafile.Create;
//     MF.MMWidth := ClientWidth;
//     MF.MMHeight := ClientHeight;
//     Bitmap1.Width := ClientWidth;
//     Bitmap1.Height := ClientHeight;
//     MF.LoadFromFile(ss);
//     bitmap1.Canvas.StretchDraw(ClientRect,MF);
//     MF.Free;
//    end
  else begin
         MessageDlg(FILENOTSUPPORTED + #10#13 + '  for this operation',mtError,[mbOK],0);
         info.g1.Visible := false;
         Bitmap1.Free;
         exit;
        end;
  repaint;
  // avoid access violation error if window resized before operation
 if ((bitmap1.Width <> clientwidth) or (temp.Width <> clientwidth) or
    (bitmap1.height <> clientheight) or (temp.height <> clientheight)) then
     begin
         MessageDlg(' This operation will not work because you either resized the window '+
         #10#13+' or pictures are different size' ,mtError,[mbOK],0);
         info.g1.Visible := false;
         Bitmap1.Free;
         exit;
        end;

   for y:= 0 to clientheight-1 do
   begin
    RowRGB1  := bitmap1.ScanLine[y];
    RowRGB   := temp.ScanLine[y];
    for x:= 0 to clientwidth-1 do
     begin
       RowRGB[x].rgbtRed   :=  RowRGB[x].rgbtRed - RowRGB1[x].rgbtRed;
       RowRGB[x].rgbtGreen :=  RowRGB[x].rgbtGreen - RowRGB1[x].rgbtGreen;
       RowRGB[x].rgbtBlue  :=  RowRGB[x].rgbtBlue - RowRGB1[x].rgbtBlue;
     end;
   end;
 canvas.CopyRect(ClientRect,temp.Canvas,ClientRect);
 original.Assign(temp);
 end;
 Bitmap1.Free;
end;

procedure TBM.HyperCos1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 3;
HyperCos1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := true;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[hypercos];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then TrigParams.ShowModal;
StUpdate;
FractalProc := ComputeHyperCosine;
AllFractals;
end;

procedure TBM.HyperSine1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 4;
HyperSine1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := true;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[hypersin];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then TrigParams.ShowModal;
StUpdate;
FractalProc := ComputeHyperSine;
AllFractals;
end;

procedure TBM.IFS1Click(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clearchecked;
WhatFractal := 5;
ifs1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := true;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[ifssys];
//Params1.Auto1.Checked := False;
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := false;
Params1.OutsideCombo.Enabled := false;
StUpdate;
if (ParamCount = 1) and (UpperCase(ExtractFileExt(ParamStr(1))) = FileX[feIFS]) and Ifsflag then
   begin
   DoLoadIfs(ParamStr(1));
   Ifsflag := false;
   end
else  DoIfs;
end;

procedure TBM.LSystems1Click(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clearchecked;
lsystems1.Checked := True;
WhatFractal := 10;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := true;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[lsystems];
//Params1.Auto1.Checked := False;
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := false;
Params1.OutsideCombo.Enabled := false;
StUpdate;
if (ParamCount = 1) and (UpperCase(ExtractFileExt(ParamStr(1))) = FileX[feLSM]) and Lsysflag  then
   begin
   DoLoadLsys(ParamStr(1));
   Lsysflag := false;
   end
else
DoLsys;
end;

procedure TBM.ExponentSet1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 2;
ExponentSet1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := true;//false;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[ExponentSet];
//Params1.Auto1.Checked := False;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := ComputeExponent;
AllFractals;
end;

procedure CopyUndoBmp;
begin
un.Width := BM.ClientWidth;
un.Height := BM.ClientHeight;
//un.Assign(BM.original);
un.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
Globundo := true;
BM.Undo1.enabled:= true;
end;

(*
  procedure TBM.Blur1Click(Sender: TObject);
  begin
  //whichfilter := 1;
  CopyUndoBmp;
  ApplyFilter(15,lpfilter6);
  original.Assign(temp);
  end;

  procedure TBM.Sharpen1Click(Sender: TObject);
  begin
  //whichfilter := 2;
  CopyUndoBmp;
  ApplyFilter(1,lpfilter9);
  original.Assign(temp);
  end;

  procedure TBM.SharpenMore1Click(Sender: TObject);
  begin
  //whichfilter := 3;
  CopyUndoBmp;
  ApplyFilter(1,hpfilter2);
  original.Assign(temp);
  end;

  procedure TBM.Relief1Click(Sender: TObject);
  begin
  //whichfilter := 4;
  CopyUndoBmp;
  ApplyFilter(2,hpfilter4);
  original.Assign(temp);
  end;
*)

//********************* Median Filter with scanlines 8-12-2000 *****************************
//type
//Telem = array[0..8] of tagRGBTRIPLE;

(*
  procedure TBM.Median1Click(Sender: TObject);
  begin

  end;

  procedure TBM.MedianFilter1Click(Sender: TObject);
  begin
  CopyUndoBmp;
  ApplyMedianFilter;
  original.Assign(temp);
  end;
*)

function median_of(el: Telem; c: integer): tagRGBTRIPLE;
var
i,j: integer;
t: tagRGBTRIPLE;
begin
  j:=c;
  while (j > 1) do
    begin
      for i:=0 to j do
       begin
         if ((el[i].rgbtRed+el[i].rgbtGreen+el[i].rgbtBlue) > (el[i+1].rgbtRed+el[i+1].rgbtGreen+el[i+1].rgbtBlue)) then
           begin
            t:= el[i];        //
            el[i]:= el[i+1];  // Swap the elements.
            el[i+1]:=t;       //
           end;
       end;
     dec(j);
    end;
median_of := el[c div 2];
end;

procedure TBM.ApplyMedianFilter;
var
x,i,j,count: Integer;
a,b : Integer;
elements: Telem;
AllScanLines : array[0..800] of pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
for x:= 0 to temp1.Height do
    AllScanLines[x]:= temp1.ScanLine[x];

   for j:= 1 to temp1.Height-1 do
      begin
       for i:= 1 to temp1.Width do
       begin
        count := 0;
        for a:=-1 to 1 do
         for b:=-1 to 1 do
          begin
            elements[count] := AllScanLines[j+b,i+a];
            inc(count);
          end;  // for b and a loops
           AllScanLines[j-1,i-1] := median_of(elements,count-1);
           //AllScanLines[j-1,i-1] := min_of(elements,count-1);
       end; // i loop
   end; // j loop
temp.Assign(temp1);
Repaint;
temp1.free;
end;

//***************************************************************************************
procedure TBM.ApplyFilter(d : Integer ; filter : TElFilter );
var
x,i,j,sumR,sumG,sumB: Integer;
a,b : Integer;
AllScanLines : array[0..1000] of pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
for x:= 0 to temp1.Height do
    AllScanLines[x]:= temp1.ScanLine[x];

   for j:= 1 to temp1.Height-1 do
      begin
       for i:= 1 to temp1.Width do
       begin
        sumR := 0; sumG := 0; sumB := 0;
        for a:=-1 to 1 do
         for b:=-1 to 1 do
          begin
            sumR := sumR + AllScanLines[j+b,i+a].rgbtRed   * filter[a+1,b+1] ;
            sumG := sumG + AllScanLines[j+b,i+a].rgbtGreen * filter[a+1,b+1] ;
            sumB := sumB + AllScanLines[j+b,i+a].rgbtBlue  * filter[a+1,b+1] ;
        end;  // for b and a loops
        if d <> 1 then
         begin
           sumR := sumR div d;
           sumG := sumG div d;
           sumB := sumB div d;
         end;
        if sumR < 0 then sumR := 0 else if sumR > $ff then sumR := $ff;
        if sumG < 0 then sumG := 0 else if sumG > $ff then sumG := $ff;
        if sumB < 0 then sumB := 0 else if sumB > $ff then sumB := $ff;

        AllScanLines[j-1,i-1].rgbtRed := sumR ;
        AllScanLines[j-1,i-1].rgbtGreen := sumG ;
        AllScanLines[j-1,i-1].rgbtBlue := sumB ;
       end; // i loop
    end; // j loop
temp.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.show9times;
var
sq : array[0..8] of TRect;
fx,fy : Integer;
begin
fx := maxx div 3;
fy := maxy div 3;

sq[0].left := 0;
sq[0].top := 0;
sq[0].right := fx;
sq[0].bottom := fy;

sq[1].left := sq[0].right; // +1 ;
sq[1].top := 0;
sq[1].right := sq[1].left + fx;
sq[1].bottom := fy;

sq[2].left := sq[1].right; // +1 ;
sq[2].top := 0;
sq[2].right := maxx;
sq[2].bottom := fy;

sq[3].left := 0;
sq[3].top := sq[0].bottom; //+1;
sq[3].right := fx;
sq[3].bottom := sq[3].top + fy;

sq[4].left := sq[3].right; // +1 ;
sq[4].top := sq[0].bottom; //+1;
sq[4].right := sq[1].right;
sq[4].bottom := sq[3].bottom;

sq[5].left := sq[2].left ;
sq[5].top := sq[0].bottom; //+1;
sq[5].right := maxx;
sq[5].bottom := sq[3].bottom;

sq[6].left := 0;
sq[6].top := sq[3].bottom; //+1;
sq[6].right := fx;
sq[6].bottom := maxy;

sq[7].left := sq[4].left ;
sq[7].top := sq[6].top;
sq[7].right := sq[4].right;
sq[7].bottom := maxy;

sq[8].left := sq[5].left ;
sq[8].top := sq[6].top;
sq[8].right := maxx;
sq[8].bottom := maxy;

with canvas do
begin
StretchDraw(sq[0],temp);
StretchDraw(sq[1],temp);
StretchDraw(sq[2],temp);
StretchDraw(sq[3],temp);
StretchDraw(sq[4],temp);
StretchDraw(sq[5],temp);
StretchDraw(sq[6],temp);
StretchDraw(sq[7],temp);
StretchDraw(sq[8],temp);
end;
temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
end;

procedure TBM.Puzzle1Click(Sender: TObject);
begin
CopyUndoBmp;
 with Canvas do
  begin
   Brush.Color := BM.Color;
   Brush.Style := bsSolid;
   Pen.Mode := pmCopy;
   PatBlt(canvas.handle,0,0,width,height,PATCOPY);
   //Rectangle(0,0,Width,Height);
  end;
show9times;
original.Assign(temp);
end;

procedure TBM.show4times;
var
sq : array[0..3] of TRect;
begin
sq[0].left := 0;
sq[0].top := 0;
sq[0].right := halfx;
sq[0].bottom := halfy;

sq[1].left := sq[0].right; // +1 ;
sq[1].top := 0;
sq[1].right := maxx;
sq[1].bottom := halfy;

sq[2].left := 0 ;
sq[2].top := halfy;// + 1;
sq[2].right := halfx;
sq[2].bottom := maxy;

sq[3].left := halfx ; //+ 1;
sq[3].top := halfy ; //+ 1;
sq[3].right := maxx;
sq[3].bottom := maxy;

with canvas do
begin
StretchDraw(sq[0],temp);
StretchDraw(sq[1],temp);
StretchDraw(sq[2],temp);
StretchDraw(sq[3],temp);
end;

temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
end;

procedure TBM.Puzzle2Click(Sender: TObject);
begin
CopyUndoBmp;
with Canvas do
  begin
   Brush.Color := BM.Color;
   Brush.Style := bsSolid;
   Pen.Mode := pmCopy;
   PatBlt(canvas.handle,0,0,width,height,PATCOPY);
  end;
show4times;
original.Assign(temp);
end;

procedure TBM.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if ContJul then contjul := false; //exit;
{if Button = mbRight then
 begin
   if Not(NormalRgn) then
     begin
      BorderStyle:=bsSizeable;
      SetWindowRgn(Handle,OrginalRgn,true);
      NormalRgn:=Not(NormalRgn);
     end;
 end }
if WinMovable then begin
  if Button = mbLeft then
   begin
    Moving:=True;
    Original_x:=X;
    Original_y:=Y;
   end;
 end;
{else if DrawingTool = dtNone then exit
else begin
  CopyUndoBmp;
  Drawing := True;
  BM.Canvas.MoveTo(X, Y);
  Origin := Point(X, Y);
  MovePt := Origin;
  exit;
  end;  }
end;

procedure TBM.BMMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
 if ContJul then begin ContinuesJulia;  end;

 Info.Label20.Caption := Format('(%d, %d)', [X, Y]);
 Julx := Xmin+(X*stepx);
 July := Ymin-(Y*stepy);
 Info.Label40.Caption := Format(F1817,[Xmin+(X*stepx)]);
 Info.Label41.Caption := Format(F1817,[Ymin-(Y*stepy)]);
 ThisColor := BM.Canvas.Pixels[X,Y];
 FindColorIndex(ThisColor);

 //if ContJul then exit;

if Shift = [ssLeft] then
begin
if Moving then begin
  left:=left+(X-Original_x);
  top:=top+(Y-Original_Y);
end;
//inc(passes);
{if Drawing then
  begin
    case DrawingTool of
    dtFree,
    dtFill : begin
             DrawShape(Origin, MovePt, pmCopy);
             Origin := Point(X,Y);
             MovePt := Origin;
             end
    else
    begin
    DrawShape(Origin, MovePt, pmNotXor);
    MovePt := Point(X, Y);
    DrawShape(Origin, MovePt, pmNotXor);
    end;
   end; // case
  end;  // Drawing  }
end;  // Shift
end;

procedure TBM.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Moving:=False;
{if Button = mbLeft then
if Drawing then
 begin
  DrawShape(Origin, Point(X, Y), pmCopy);
  Drawing := False;
  temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
 end;  }
{ else  begin   // Moved to MouseMove
      ThisColor := BM.Canvas.Pixels[X,Y];
      FindColorIndex(ThisColor);
      end; }

end;

procedure TBM.Undo1Click(Sender: TObject);
begin
if Globundo  then
begin
 BM.Canvas.CopyRect(BM.ClientRect,un.Canvas,BM.ClientRect);
 temp.Canvas.CopyRect(BM.ClientRect,un.Canvas,BM.ClientRect);
 original.Canvas.CopyRect(BM.ClientRect,un.Canvas,BM.ClientRect);
 Globundo := false;
end;
end;

procedure TBM.FormShow(Sender: TObject);
begin
s9 := LoadedBMP;
if ParamCount = 1 then
 begin
 FileExt := UpperCase(ExtractFileExt(ParamStr(1)));
 s9 := ParamStr(1);
 end;
 if (((FileExt = FileX[feBMP]) or (FileExt = FileX[feTEX]) or (FileExt = FileX[feJPG]) or
      {(FileExt = FileX[feGIF]) or (FileExt = FileX[feFIF]) or (FileExt = FileX[feTGA]) or }
      {(FileExt = FileX[fePCX]) or (FileExt = FileX[feDIB]) or } (FileExt = FileX[feRLE]) or
      (FileExt = FileX[feWMF]) or (FileExt = FileX[feEMF]) {or (FileExt = FileX[fePNG]) or}
      {(FileExt = FileX[feTIF]) or (FileExt = FileX[feTIFF])} )
      and (not JustCenter) ) then
 begin
  BMPLoaded := True;
  passes := 1;
  Revert1.Enabled := True;
  Revert1.Click;
 end;
   maxx := ClientWidth;
   maxy := ClientHeight;
   halfx := maxx div 2;
   halfy := maxy div 2;
   x1 := 0; y1 := 0; x2 := maxx; y2 := maxy;
   A1:=x1; B1:=y1; C1:=x2; D1:=y2;
end;

procedure TBM.CenterWindow1Click(Sender: TObject);
begin
 JustCenter := True;
 BM.Position := poScreenCenter;
 JustCenter := False;
end;

procedure FastLoadPal;
var
 I: TextFile;
 r,g,b,index : Integer;
 Fe,r1,dummy: String;

label getout;
begin
 if FileExists(PaletteName) = false then   // file or directory does not exist
 begin
  dummy := ExtractFileName(PaletteName);
  PaletteName := ExtractFileDir(Application.ExeName) + '\PALETTE\' + dummy;
  if FileExists(PaletteName) = false then
  begin
   MessageDlg('Could not Load Palette File. The Default Palette will be Used.',mtWarning, [mbOk], 0);
   PaletteName := 'Default.PAL';
   InitPalete;
   FillPalListArray;
   exit;
  end;
 end;

 Fe := UpperCase(ExtractFileExt(PaletteName));

 if Fe = FileX[fePAL] then
  begin
    AssignFile(I, PaletteName);
    Reset(I);
    Readln(I,r1);
    if r1 <> s8 then goto getout;
      index:=0;
      while not Eof(I) do
       begin
        Readln(I,dummy);
        pal[index] := StrToInt(dummy);
        inc(index);
        if index > 255 then break;
       end;
  end
else if Fe = FileX[feMAP] then
 begin
    AssignFile(I, PaletteName);
    Reset(I);
    index := 0;
     while not Eof(I) do
      begin
        Read(I, r, g, b);
        Readln(I);
        pal[index] := RGB(r,g,b);
        inc(index);
        if index > 255 then break;
      end;
 end;
FillPalListArray;
getout:
    CloseFile(I);
end;

procedure FillPalListArray;
var index: integer;
begin
ColorList.clear;
//ColorList.Capacity:=256;
 for index :=0 to 255 do
   begin
     dacbox[index][0] := getRValue(pal[index]);
     dacbox[index][1] := getGValue(pal[index]);
     dacbox[index][2] := getBValue(pal[index]);
   end;
for index:=0 to 255 do begin
 NEW(Node);
 WITH Node^ DO
   BEGIN
    rgbtRed   := GetRValue(pal[index]);
    rgbtGreen := GetGValue(pal[index]);
    rgbtBlue  := GetBValue(pal[index]);
   END;
ColorList.Add(Node);
end;
end;

procedure TBM.EditPalette1Click(Sender: TObject);
begin
Application.CreateForm(TEditPal, EditPal);
EditPal.ShowModal;
end;

procedure ApplyNewPalette;
var
Bitmap24: TBitmap;
j,i: integer;
//index : LongInt;
RowRGB,RowRGB24 :  pRGBArray;
begin
Bitmap24 := TBitmap.Create;
Bitmap24.PixelFormat := pf24bit;
Bitmap24.Width  := BM.ClientWidth;
Bitmap24.Height := BM.ClientHeight;
Bitmap24.Assign(BM.original);
bitmap24.Canvas.Pixels[0,0] := BM.original.Canvas.Pixels[0,0];
Bitmap24.PixelFormat := pf24bit;
for j := 0 to BM.original.Height-1 do
    begin
      RowRGB  := BM.original.ScanLine[j];
      RowRGB24  := Bitmap24.ScanLine[j];
      for i := 0 to BM.original.Width -1 do
      begin
        //index := RowRGB[i]; //BM.original.Canvas.Pixels[i,j];
        //index := RGB(RowRGB[i].rgbtRed,RowRGB[i].rgbtGreen,RowRGB[i].rgbtBlue);

        FindColorIndex2(RGB(RowRGB[i].rgbtRed,RowRGB[i].rgbtGreen,RowRGB[i].rgbtBlue));
        //index := RowRGB[i].rgbtGreen;
        //RowRGB24[i] := pRGBTriple(ColorList.Items[index])^;
        RowRGB24[i] := pRGBTriple(ColorList.Items[colorindex])^;
      end;
    end;
BM.temp.Assign(bitmap24);
BM.temp.Canvas.Pixels[0,0] := Bitmap24.Canvas.Pixels[0,0];
BM.temp.PixelFormat := pf24bit;
BM.Canvas.CopyRect(BM.ClientRect,BM.temp.Canvas,BM.ClientRect);
bitmap24.free;
end;

procedure TBM.FlipandMiror1Click(Sender: TObject);
begin
CopyUndoBmp;
  // Flip + Miror
BM.Canvas.StretchDraw(Rect(BM.ClientWidth,BM.ClientHeight,0,0), temp);
temp.Width := BM.ClientWidth;
temp.Height := BM.ClientHeight;
temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
original.Assign(temp);
if SoundOn then MessageBeep(MB_ICONEXCLAMATION);
end;

//procedure TBM.Browse1Click(Sender: TObject);
//begin
//  Application.CreateForm(TBrowsFrm, BrowsFrm);
//  BrowsFrm.ShowModal;
//end;

procedure TBM.Center1Click(Sender: TObject);
var
WinDir : array[0..MAX_PATH] of Char;
FName : String;
begin
GetWindowsDirectory( WinDir, MAX_PATH);
FName := String (WinDir)+'\ElifracWallPaper.bmp';
temp.SaveTofile(FName);
SystemParametersInfo(SPI_SETDESKWALLPAPER,0,Pchar(Fname),SPIF_SENDWININICHANGE);
end;

procedure TBM.JPEGOptions1Click(Sender: TObject);
begin
Application.CreateForm(TJpegOptionsForm, JpegOptionsForm);
 JpegOptionsForm.ShowModal;
end;

//procedure TBM.PageSetUp1Click(Sender: TObject);
//begin
//PageDialog1.Execute;
//end;

//procedure TBM.N8BitColor1Click(Sender: TObject);
//begin
//   N8BitColor1.Checked := not N8BitColor1.Checked;
//   N15bitcolor1.Checked := not N8BitColor1.Checked;
//   N24bitcolor1.Checked := not N8BitColor1.Checked;
//   N8bitgrayscale1.Checked := not N8BitColor1.Checked;
//   FIFColorFormat := RGB8;
//end;
//
//procedure TBM.N8BitGrayScale1Click(Sender: TObject);
//begin
//   N8BitGrayScale1.Checked := not N8BitGrayScale1.Checked;
//   N8BitColor1.Checked :=  not N8BitGrayScale1.Checked;
//   N15bitcolor1.Checked := not N8BitGrayScale1.Checked;
//   N24bitcolor1.Checked := not N8BitGrayScale1.Checked;
//   FIFColorFormat := GRAYSCALE8;
//end;
//
//procedure TBM.N15BitColor1Click(Sender: TObject);
//begin
//   N15bitcolor1.Checked := not N15bitcolor1.Checked;
//   N8BitGrayScale1.Checked := not N15bitcolor1.Checked;
//   N8BitColor1.Checked :=  not N15bitcolor1.Checked;
//   N24bitcolor1.Checked := not N15bitcolor1.Checked;
//   FIFColorFormat := RGB15;
//end;
//
//procedure TBM.N24BitColor1Click(Sender: TObject);
//begin
//   N24bitcolor1.Checked := not N24bitcolor1.Checked;
//   N15bitcolor1.Checked := not N24bitcolor1.Checked;
//   N8BitGrayScale1.Checked := not N24bitcolor1.Checked;
//   N8BitColor1.Checked :=  not N24bitcolor1.Checked;
//   FIFColorFormat := RGB24;
//end;

procedure TBM.Rossler1Click(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clrscr;
clearchecked;
WhatFractal := 15;
StrangeAttractors1.Checked := True;
Rossler1.Checked := True;
Rossler3.Checked := True;
Lorenz1.Checked := False;
Lorenz3.Checked := False;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[RosslerAttractor];
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := false;
Params1.OutsideCombo.Enabled := false;
StUpdate;
Attractors(1);
end;

procedure TBM.Lorenz1Click(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clrscr;
clearchecked;
WhatFractal := 16;
StrangeAttractors1.Checked := True;
Lorenz1.Checked := True;
Rossler1.Checked := False;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[LorenzAttractor];
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := false;
Params1.OutsideCombo.Enabled := false;
StUpdate;
Attractors(2);

end;

procedure TBM.Magnets1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 11;
Magnets1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[magnet1m];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then SParams.ShowModal;
StUpdate;
FractalProc := ComputeMagnet1m;
AllFractals;
end;

procedure TBM.BarnsleysFractal1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 0;
BarnsleysFractal1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[barnsleyfractal3];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then SParams.ShowModal;
StUpdate;
FractalProc := ComputeBarnsley3;
AllFractals;
end;

procedure TBM.LegendreFractal1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 9;
LegendreFractal1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[LegendreFractal];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := ComputeLegendrePoly;
AllFractals;
end;

procedure TBM.T51Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
Tchebychev1.Checked := True;
WhatFractal := 18;
T51.Checked := True;
T31.Checked := False;
C61.Checked := false;
T53.Checked := True;
T33.Checked := False;
C63.Checked := false;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
Cut1.Enabled := True;
Copy1.Enabled := True;
FractalName := Fractal[TchebychevT5];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then SParams.ShowModal;
StUpdate;
FractalProc := ComputeTchebyT5;
AllFractals;
end;

procedure TBM.T31Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
Tchebychev1.Checked := True;
WhatFractal := 17;
T51.Checked := false;
C61.Checked := false;
T31.Checked := true;
T53.Checked := false;
C63.Checked := false;
T33.Checked := true;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[TchebychevT3];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then SParams.ShowModal;
StUpdate;
FractalProc := ComputeTchebyT3;
AllFractals;
end;

procedure TBM.C61Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
Tchebychev1.Checked := True;
WhatFractal := 19;
T51.Checked := false;
T31.Checked := false;
C61.Checked := true;
T53.Checked := false;
T33.Checked := false;
C63.Checked := true;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[TchebychevC6];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then SParams.ShowModal;
StUpdate;
FractalProc := ComputeTchebyC6;
AllFractals;
end;

procedure TBM.StUpdate;
begin
With Info do
if Visible then begin
 Label11.Caption  := IntToStr(k);
 Label12.Caption  := IntToStr(kstart);
 Label13.Caption  := IntToStr(kend);
 Label14.Caption  := IntToStr(kstep);
 Label15.Caption := Format(F1817,[r]);
 Label16.Caption := Format(F1817,[recen]);
 Label17.Caption := Format(F1817,[imcen]);
 Label18.Caption := Format(F1817,[stepx]);
 Label19.Caption := Format(F1817,[stepy]);
 Label22.Caption := IntToStr(Iters);
 Label26.Caption := Format(F1817,[XMax]);
 Label30.Caption := Format(F1817,[XMin]);
 Label32.Caption := Format(F1817,[YMax]);
 Label34.Caption := Format(F1817,[YMin]);
 Label36.Caption := FractalName;
 Label38.Caption := PaletteName;
end;
//if TFractalTypes(whatFractal) in CommonFuncSet then HQPic.Enabled := true
 //else HQPic.Enabled := false;
end;

{procedure TBM.DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
begin
 if DrawingTool = dtNone then exit;
  with BM.Canvas do
  begin
    Pen.Mode := AMode;
    case DrawingTool of
      dtLine:  begin
                MoveTo(TopLeft.X, TopLeft.Y);
                LineTo(BottomRight.X, BottomRight.Y);
               end;
      dtFree     : LineTo(BottomRight.X, BottomRight.Y);
      dtRectangle: Rectangle(TopLeft.X, TopLeft.Y, BottomRight.X,BottomRight.Y);
      dtEllipse  : Ellipse(Topleft.X, TopLeft.Y, BottomRight.X,BottomRight.Y);
      dtRoundRect: RoundRect(TopLeft.X, TopLeft.Y, BottomRight.X,BottomRight.Y,
                    (TopLeft.X - BottomRight.X) div 2,(TopLeft.Y - BottomRight.Y) div 2);
      dtFill     :  with BM.Canvas do
                      Floodfill(Origin.x,Origin.y,Pixels[Origin.x,Origin.y],fsSurface);
      dtText     :  begin
                     Txtbmp.Canvas.TextOut(1,1,CanvasText);
                     BM.Canvas.CopyMode := cmSrcCopy;
                     BM.Canvas.Draw(Origin.x,Origin.y, Txtbmp);
                     temp.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
                     DrawingTool := dtNone;
                    end;
    end;
  end;
end;  }

procedure TBM.View1Click(Sender: TObject);
begin
if Info.Visible then
N3.Caption := 'Hide Info Window'
else  N3.Caption := 'Show Info Window';
{if FracTools.Visible then
 ShowTools1.Caption := 'Hide Tools'
else ShowTools1.Caption := 'Show Tools';  }
end;

procedure TBM.N3Click(Sender: TObject);
begin
Info.Visible := not Info.Visible;
if Info.Visible  then StUpdate;
SetFocus;
end;

{procedure TBM.ShowTools1Click(Sender: TObject);
begin
// FracTools.Visible := not FracTools.Visible;
end; }

procedure TBM.N5Click(Sender: TObject);
begin
with BM.Canvas do
     begin
       Brush.Style := bsClear;
       Pen.Mode := pmNot;
       Rectangle(A1,B1,C1,D1);
       MoveTo(crossx,crossy-10 );
       LineTo(crossx,crossy+10 );
       MoveTo(crossx-10,crossy );
       LineTo(crossx+10,crossy );
       Brush.Style := bsSolid;
       Pen.Mode := pmCopy;
     end;
end;

procedure TBM.VideoClip1Click(Sender: TObject);
var
DoDefault : Boolean;
begin
Video.FileName := VideoDirectory + '\Fractals.avi';
VideoClick(Self, btPlay, DoDefault);
end;

procedure TBM.VideoClick(Sender: TObject; Button: TMPBtnType; var DoDefault: Boolean);
begin
 with Video do
 begin
   DoDefault := False;
   Open;
   Wait := True;
   Play;
   Close;
   Enabled := True;
end;
end;

procedure TBM.OpenCommandLineParam(Fnm: String);
label J20;
var
 Fin: TextFile;
 dummy : String;
 Inx,m : Integer;
begin
  passes := 1;
  AssignFile(Fin,Fnm);
  Reset(Fin);
  Readln(Fin,dummy);
  CloseFile(Fin);
  if dummy <> FRACPARAMFILE2 then
   begin
    Application.MessageBox(NOFPR,DLGERROR, MB_ICONERROR + MB_OK);
    Exit;
   end;
   ReadParamFile(Inx, Fnm);
   StUpdate;
  if PaletteName = '' then
   InitPalete
  else FastLoadPal;
  if LoadwithBMPFlag then
    begin
      for m := 0 to TypesMenu1.Count-1 do
      TypesMenu1.Items[m].Checked := False;
      TypesMenu1.Items[inx].Checked := True;
      LoadwithBMPFlag := false;
      case inx of
       0 : FractalProc := ComputeBarnsley3;
       1 : FractalProc := ComputeCosine;
       2 : FractalProc := ComputeExponent;
       3 : FractalProc := ComputeHyperCosine;
       4 : FractalProc := ComputeHyperSine;
    6,20 : FractalProc := ComputeFullJulia;
       8 : FractalProc := ComputeFilledMandelOrbits;
       9 : FractalProc := ComputeLegendrePoly;
      11 : FractalProc := ComputeMagnet1m;
      12 : FractalProc := ComputeMandel;
      13 : FractalProc := ComputeSine;
      16 : begin
            if FractalName = fractal[TchebychevT3] then FractalProc := ComputeTchebyT3
            else if FractalName = fractal[TchebychevT5] then FractalProc := ComputeTchebyT5
            else if FractalName = fractal[TchebychevC6] then FractalProc := ComputeTchebyC6;
           end;
      19 : FractalProc := ComputeHalley;
      22 : FractalProc := ComputeUnity;
      24 : FractalProc := computeNewFractal;
      25 : FractalProc := ComputeLambdaFractal;
      26 : FractalProc := ComputeBioFractal;
      27 : FractalProc := ComputeNewton;
      end;
      LoadedFractalInit;
      exit;
    end
    else  Caption := fcapt + ' [ ' + OpenDialog1.Filename + ' ]';
    clrscr;
    if Inx = 16 then
    begin                                                // Added 7-3-98 to support
    if FractalName = fractal[TchebychevT3] then T31.Click      // Tchebychev Fractals.
    else if FractalName = fractal[TchebychevT5] then T51.Click
    else if FractalName = fractal[TchebychevC6] then C61.Click;
    end
  else if Inx = 15 then
    begin
    if FractalName = fractal[RosslerAttractor] then Rossler1.Click
    else if FractalName = fractal[LorenzAttractor] then Lorenz1.Click;
    end
  else
  TypesMenu1.Items[Inx].Click;
end;

procedure TBM.PlasmaClick(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clrscr;
clearchecked;
Plasma.Checked := True;
WhatFractal := 21;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := False;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[plasmaDisplay];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := false;
Params1.OutsideCombo.Enabled := false;
StUpdate;
PlasmaProc;
end;

procedure TBM.TimerMenuClick(Sender: TObject);
begin
if  TimerMenu.checked then
   begin
   TimerMenu.checked := False;
   TimerMenu.Caption := 'Timer =  OFF';
   TimerOn := false;
   end
   else begin
   TimerMenu.checked := True;
   TimerMenu.Caption := 'Timer =  ON';
   TimerOn := true;
   end;
end;

procedure TBM.Halley1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 22;
Halley1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[halleymap];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := true; //false;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true; //false;
if ((not ComingFromZoom) and (FractalCompleted)) then HalFunc.ShowModal;
StUpdate;
//OutSideColor := 0;
FractalProc := ComputeHalley;
AllFractals;
end;

procedure FindColorIndex(x: Integer);
var i: Integer;
begin
 for i := 0 to 255 do
  begin
    if pal[i] = x then
      begin
       colorindex := i;
       Info.Label43.Caption := 'Index In Palette ' + IntToStr(colorindex);
       //x := i;
       exit;
      end;
  end;
  Info.Label43.Caption := 'No Match';
  //colorindex:= 0;
  //x := 0;
end;

procedure FindColorIndex2(x: Integer);
var i: Integer;
begin
 for i := 0 to 255 do
  begin
    if pal[i] = x then
      begin
       colorindex := i;
       exit;
      end;
  end;
  colorindex := 0;
end;

procedure TBM.SelectSplitScreenFunctionOrder1Click(Sender: TObject);
begin
SplitConForm.ShowModal;
end;


procedure TBM.EditParamClick(Sender: TObject);
var
er: Integer;
fn : String;
begin
OpenDialog1.Title := s4;
OpenDialog1.FilterIndex := 10;
OpenDialog1.InitialDir := ParamsDirectory;
if OpenDialog1.Execute then
 begin
 fn := OpenDialog1.FileName;
 if (not FileEditMenu.Checked) then
  begin
  er := ShellExecute(Self.Handle,PChar('open'), PChar('NotePad.exe'),PChar(fn), nil, SW_SHOWNORMAL );
  if er <= 32 then MessageDlg('Error Opening The NotePad ',mtError,[mbOK],0);
  end
// else begin
//        EdText.TextDataSet1.FileName := fn;
//        EdText.TextDataSet1.Active := True;
//        EdText.Caption := fn;
//        EdText.Show;
//      end;
 end;
end;

procedure TBM.LoadTexture;
var
bitmap1,btm2 : TBitmap;
//Gif1 : TGifImage; //TGifBitmap;
Jpg1 : TJPEGImage;
//png1 : TPngImage;
i,j,v : Integer;
FExt,ss : String;
label bailout,common;
begin
OpenDialog1.Title := s1;
OpenDialog1.FilterIndex := 13;
OpenDialog1.InitialDir := TexturesDirectory;
Bitmap1 := TBitmap.Create;
CopyUndoBmp;
if OpenDialog1.Execute  then
 begin
  Application.ProcessMessages;
  info.G1.Progress := 0;
  info.G1.Visible := true;
  passes := 1;
  ss := OpenDialog1.Filename;
  FExt := UpperCase(ExtractFileExt(ss));
  if  ((FExt = FileX[feTEX]) or (FExt = FileX[feBMP]) or
       (FExt = FileX[feDIB]) or (FExt = FileX[feRLE])) then
    Bitmap1.LoadFromFile(ss)
//    else if (FExt = FileX[feGIF]) then
//     begin
//       Gif1 := TGifImage.Create;
//       Gif1.LoadFromFile(ss);
//       Bitmap1.Assign(Gif1);
//       Gif1.Free;
//     end
//   else if ((FExt = FileX[feTIF]) or (FExt = FileX[feTIFF])) then
//        begin
//         LoadTiffFromFile(ss, Bitmap1);
//        end
//  else if (FExt = FileX[fePNG]) then
//    begin
//     ReadBitmapFromPngFile(ss, Bitmap1);
     {Png1 := TPngImage.Create;
     Png1.LoadFromFile(ss);
     bitmap1.Width := png1.Width;
     bitmap1.Height := png1.Height;
     png1.Draw(bitmap1.Canvas,Bitmap1.Canvas.ClipRect);
     Png1.Release;
    end  }
  else if (FExt = FileX[feJPG]) then
    begin
     Jpg1 := TJPEGImage.Create;
     Jpg1.PixelFormat := jpgPxlFrm;
     Jpg1.Grayscale := GraySc;
     Jpg1.ProgressiveDisplay := PrDisplay;
     Jpg1.Performance := jpgPerf;
     Jpg1.Scale := jpgSize;
     Jpg1.Smoothing := SmoothDisplay;
     Jpg1.LoadFromFile(ss);
     Bitmap1.Assign(Jpg1);
     Jpg1.Free;
    end
 else
   begin
   MessageDlg(FILENOTSUPPORTED,mtError,[mbOK],0);
   goto bailout;
   end;
//******************** Common Code for all file types *****************************
   btm2 := TBitmap.Create;
   btm2.Height := maxy;
   btm2.Width := maxx;
   btm2.Canvas.Brush.Style := bssolid;
   btm2.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
   btm2.canvas.CopyMode := cmSrcCopy;
   for v := 1 to 2 do
    begin
    i:=0;
    while i < maxx do
      begin
       j:=0;
       while j< maxy  do
          begin
            btm2.Canvas.draw(i,j,bitmap1);
            inc(j,bitmap1.Height);
          end;
       inc(i,bitmap1.Width);
      end;
      Info.G1.Progress := (100 * i) div v*maxx;
     end;
    Canvas.CopyMode := cmSrcAnd	;
    Canvas.CopyRect(ClientRect,btm2.Canvas,ClientRect);
    temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
    btm2.Free;
end;  //if opendialog
bailout:
Canvas.CopyMode := cmSrcCopy;
info.G1.Visible := false;
bitmap1.free;
end;  //procedure

procedure TBM.Texture1Click(Sender: TObject);
begin
 LoadTexture;
end;

procedure TBM.MonoCyan1Click(Sender: TObject);
begin
copyundobmp;
 ColorIntens := 0;
 clfl := (Sender as TMenuItem).Tag;
 case clfl of
  0..6 : begin
          if MonoForm.ShowModal = mrOk then exit
          else Undo1Click(Self);
         end;
     7 : begin
          if ChromaForm.ShowModal = mrOk then exit
          else Undo1Click(Self);
         end;
 end;
end;

//procedure TBM.FileDrag1Drop(Sender: TObject);
//begin
//   FileExt := Uppercase(FileDrag1.Extension[0]);
//   FileExt := '.'+FileExt;
//   BM.SetFocus;
//      if (FileExt = FileX[feFPR]) then
//        begin
//        Application.BringToFront;
//        OpenCommandLineParam(FileDrag1.NameWithPath[0]);
//        end
//        else if FileExt = FileX[feLSM] then
//        begin
//         Application.BringToFront;
//         DoLoadLsys(FileDrag1.NameWithPath[0]);
//         lsysflag := false;
//         end
//        else if FileExt = FileX[feIFS] then
//         begin
//         Application.BringToFront;
//         DoLoadIfs(FileDrag1.NameWithPath[0]);
//         ifsflag := false;
//         end
//   else
//   if ((FileExt = FileX[feBMP]) or (FileExt = FileX[feTEX]) or (FileExt = FileX[feJPG]) or
//    (FileExt = FileX[feGIF])or (FileExt = FileX[feFIF])or(FileExt = FileX[feTGA])or (FileExt = FileX[fePCX])or
//    (FileExt = FileX[feDIB])or (FileExt = FileX[feRLE]) or (FileExt = FileX[feWMF]) or (FileExt = FileX[feEMF]) or
//    (FileExt = FileX[fePNG])or (FileExt = FileX[feTIF]) or (FileExt = FileX[feTIFF]))  then
//   begin
//   BM.SetFocus;
//   s9 := FileDrag1.NameWithPath[0];
//   Revert1.Enabled := true;
//   Application.BringToFront;
//   Revert1.Click;
//   BM.SetFocus;
//   end
//   else MessageDlg(FILENOTSUPPORTED,mtError,[mbOK],0);
//   BM.SetFocus;
//end;

procedure PaintRainbow(Dc : hDc; {Canvas to paint to}
                       x : integer; {Start position X}
                       y : integer;  {Start position Y}
                   Width : integer; {Width of the rainbow}
                  Height : integer {Height of the rainbow};
               bVertical : bool; {Paint verticallty}
               WrapToRed : bool); {Wrap spectrum back to red}
var
i : integer;
ColorChunk : integer;
OldBrush : hBrush;
r : integer;
g : integer;
b : integer;
Chunks : integer;
pt : TPoint;
begin
 OffsetViewportOrgEx(Dc,x,y,pt);
 if WrapToRed = false then
    Chunks := 5 else
    Chunks := 6;
 if bVertical = false then
    ColorChunk := Width div Chunks else
    ColorChunk := Height div Chunks;

   {Red To Yellow}
 r := 255;
 b := 0;
 for i := 0 to ColorChunk do begin
   g:= (255 div ColorChunk) * i;
   OldBrush := SelectObject(Dc, CreateSolidBrush(Rgb(r, g, b)));
   if bVertical = false then
      PatBlt(Dc, i, 0, 1, Height, PatCopy) else
      PatBlt(Dc, 0, i, Width, 1, PatCopy);
   DeleteObject(SelectObject(Dc, OldBrush));
 end;

  {Yellow To Green}
 g:=255;
 b:=0;
 for i := ColorChunk  to (ColorChunk * 2) do begin
     r := 255 - (255 div ColorChunk) * (i - ColorChunk);
     OldBrush := SelectObject(Dc, CreateSolidBrush(Rgb(r, g, b)));
     if bVertical = false then
        PatBlt(Dc, i, 0, 1, Height, PatCopy) else
        PatBlt(Dc, 0, i, Width, 1, PatCopy);
     DeleteObject(SelectObject(Dc, OldBrush));
 end;

 {Green To Cyan}
 r:=0;
 g:=255;
 for i:= (ColorChunk * 2) to (ColorChunk * 3) do begin
   b := (255 div ColorChunk)*(i - ColorChunk * 2);
   OldBrush := SelectObject(Dc, CreateSolidBrush(Rgb(r, g, b)));
   if bVertical = false then
      PatBlt(Dc, i, 0, 1, Height, PatCopy) else
      PatBlt(Dc, 0, i, Width, 1, PatCopy);
   DeleteObject(SelectObject(Dc,OldBrush));
 end;

  {Cyan To Blue}
 r := 0;
 b := 255;
 for i:= (ColorChunk * 3) to (ColorChunk * 4) do begin
     g := 255 - ((255 div ColorChunk) * (i - ColorChunk * 3));
     OldBrush := SelectObject(Dc, CreateSolidBrush(Rgb(r, g, b)));
     if bVertical = false then
        PatBlt(Dc, i, 0, 1, Height, PatCopy) else
        PatBlt(Dc, 0, i, Width, 1, PatCopy);
     DeleteObject(SelectObject(Dc, OldBrush));
 end;

 {Blue To Magenta}
 g := 0;
 b := 255;
 for i:= (ColorChunk * 4) to (ColorChunk * 5) do begin
     r := (255 div ColorChunk) * (i - ColorChunk * 4);
     OldBrush := SelectObject(Dc, CreateSolidBrush(Rgb(r, g, b)));
     if bVertical = false then
        PatBlt(Dc, i, 0, 1, Height, PatCopy) else
        PatBlt(Dc, 0, i, Width, 1, PatCopy);
    DeleteObject(SelectObject(Dc, OldBrush))
 end;

if WrapToRed <> false then begin
  {Magenta To Red}
 r := 255;
 g := 0;
 for i := (ColorChunk * 5) to ((ColorChunk * 6) - 1) do begin
     b := 255 -((255 div ColorChunk) * (i - ColorChunk * 5));
     OldBrush := SelectObject(Dc, CreateSolidBrush(Rgb(r,g,b)));
     if bVertical = false then
        PatBlt(Dc, i, 0, 1, Height, PatCopy) else
        PatBlt(Dc, 0, i, Width, 1, PatCopy);
     DeleteObject(SelectObject(Dc,OldBrush));
 end; // for
end;  // if

 {Fill Remainder}
 if (Width - (ColorChunk * Chunks) - 1 ) > 0 then begin
 if WrapToRed <> false then begin
    r := 255;
    g := 0;
    b := 0;
  end else begin
    r := 255;
    g := 0;
    b := 255;
  end;
 OldBrush := SelectObject(Dc, CreateSolidBrush(Rgb(r, g, b)));
 if bVertical = false then
    PatBlt(Dc,ColorChunk * Chunks,0,Width - (ColorChunk * Chunks),Height,PatCopy) else
    PatBlt(Dc,0,ColorChunk * Chunks,Width,Height - (ColorChunk * Chunks),PatCopy);
    DeleteObject(SelectObject(Dc,OldBrush));
 end;
 OffsetViewportOrgEx(Dc,Pt.x,Pt.y,pt);
end;

procedure TBM.Horizontal2Click(Sender: TObject);
begin
 CopyUndoBmp;
 PaintRainbow(Canvas.Handle,0,0,ClientWidth,ClientHeight,true,true);
 temp.Width := ClientWidth;
 temp.Height := ClientHeight;
 temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
 original.Assign(temp);
 clrback.checked := false;
end;

procedure TBM.VerticalRainbow1Click(Sender: TObject);
begin
 CopyUndoBmp;
 PaintRainbow(Canvas.Handle,0,0,ClientWidth,ClientHeight,false,true);
 temp.Width := ClientWidth;
 temp.Height := ClientHeight;
 temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
 original.Assign(temp);
 clrback.checked := false;
end;

procedure TBM.MakeItGrayClick(Sender: TObject);
var
i,j : Integer;
cl : TColor;
RowRGB   :  pRGBArray;
temp1: TBitmap;
begin
Screen.Cursor := crHourglass;
copyundobmp;
temp1 := TBitmap.Create;
temp1.PixelFormat := pf24bit;
temp1.Height := ClientHeight;
temp1.Width := ClientWidth;
temp1.Canvas.CopyRect(BM.ClientRect,BM.Canvas,BM.ClientRect);
for j := 0 to ClientHeight-1 do
  begin
   RowRGB  := temp1.ScanLine[j];
   for i := 0 to ClientWidth-1 do
    begin
     cl := Round((0.30 * RowRGB[i].rgbtRed) +
                (0.59 * RowRGB[i].rgbtGreen) +
                (0.11 * RowRGB[i].rgbtBlue));
      RowRGB[i].rgbtRed := cl;
      RowRGB[i].rgbtGreen := cl;
      RowRGB[i].rgbtBlue := cl;
    end;
  end;
Screen.Cursor := crDefault;
if SndMenu.checked then MessageBeep(MB_ICONEXCLAMATION);
temp.Assign(temp1);
original.Assign(temp);
Canvas.CopyRect(BM.ClientRect,temp.Canvas,BM.ClientRect);
temp1.free;
end;

//procedure TBM.MetaStrechClick(Sender: TObject);
//begin
//MetaStrech.Checked := not MetaStrech.Checked;
//end;

//procedure TBM.ClearWind1Click(Sender: TObject);
//begin
//ClearWind1.Checked := not ClearWind1.Checked;
//end;

procedure TBM.Land3dClick(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clrscr;
clearchecked;
WhatFractal := 23;
Land3d.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[land_3d];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := false;
Params1.OutsideCombo.Enabled := false;
StUpdate;
do3dland;
end;

procedure TBM.FileEditMenuClick(Sender: TObject);
begin
 FileEditMenu.Checked := not FileEditMenu.Checked;
end;

procedure TBM.MartinMenuClick(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clrscr;
clearchecked;
WhatFractal := 24;
MartinMenu.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[martin];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := false;
Params1.RadioGroup1.Enabled := false;
Params1.OutsideCombo.Enabled := false;
if (not ComingFromZoom) then MartinParams.ShowModal;
StUpdate;
DoMartin;
end;

procedure TBM.UnityMenuClick(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 25;
UnityMenu.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[unityfr];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := true;
Params1.RadioGroup1.Enabled := true;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := ComputeUnity;
AllFractals;
end;

procedure TBM.HelpContents1Click(Sender: TObject);
begin
Application.HelpCommand(HELP_FINDER,0);
end;

procedure TBM.HelpOnHelp1Click(Sender: TObject);
begin
Application.HelpCommand(HELP_HELPONHELP	,0);
end;

procedure TBM.HelpMain1Click(Sender: TObject);
begin
Application.HelpCommand(HELP_CONTEXT,999);
end;

procedure TBM.BifMenuClick(Sender: TObject);
begin
WalkMode := false;
WalkMenu.Enabled := false;
CopyUndoBmp;
clrscr;
clearchecked;
WhatFractal := 26;
BifMenu.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := true;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[bifurc];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := False;
Params1.RadioGroup1.Enabled := false;
Params1.OutsideCombo.Enabled := false;
StUpdate;
Bif;
end;

procedure TBM.ProgBarMenuClick(Sender: TObject);
begin
if  ProgBarMenu.checked then
   begin
   ProgBarMenu.checked := False;
   ProgBarMenu.Caption := 'Progress Bar =  OFF';
   ProgressBarOn := False;
   end
   else begin
   ProgBarMenu.checked := True;
   ProgBarMenu.Caption := 'Progress Bar =  ON';
   ProgressBarOn := True;
   end;
end;

procedure TBM.New1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 27;
New1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[circlepattern];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := computeNewFractal;
AllFractals;
end;

var oldwalkmenu : boolean;

procedure TBM.WalkTheFractal1Click(Sender: TObject);
begin
WalkMode := True;
WalkTheFractal1.Checked := True;
WalkModeOFF1.Checked := false;
Screen.Cursor := crHandPoint;
end;

procedure TBM.WalkModeOFF1Click(Sender: TObject);
begin
WalkMode := false;
WalkModeOFF1.Checked := true;
WalkTheFractal1.Checked := false;
Screen.Cursor := crDefault;
end;

procedure TBM.Circle1Click(Sender: TObject);
var
NewRgn : HRGN;
begin
//FracTools.Enabled := False;
oldwalkmenu := WalkMenu.Enabled;
WalkMode := false;
WalkMenu.Enabled := false;
if NormalRgn then GetWindowRgn(handle,OrginalRgn);
BorderStyle:=bsNone;
if ClientWidth > ClientHeight then
   NewRgn:=CreateEllipticRgn( ClientWidth div 2 - ClientHeight div 2, 20,
                ClientWidth div 2 + ClientHeight div 2,ClientHeight)
else
   NewRgn:=CreateEllipticRgn( 0,(ClientHeight div 2 - ClientWidth div 2)+20,
                                ClientWidth,ClientHeight div 2 + ClientWidth div 2);
SetWindowRgn(Handle, NewRgn,true);
RemoveProp(Handle,'region');
SetProp(Handle, 'region', NewRgn);
if  NormalRgn then NormalRgn := Not NormalRgn;
WinMovable := true;
end;

{procedure TBM.Triangle1Click(Sender: TObject);
var
NewRgn : HRGN;
Pints : array[1..3] of TPoint;
begin
oldwalkmenu := WalkMenu.Enabled;
WalkMode := false;
WalkMenu.Enabled := false;
if NormalRgn then GetWindowRgn(handle,OrginalRgn);
BorderStyle:=bsNone;
Pints[1].x:= 0;
Pints[1].y:= 20;
Pints[2].x:= ClientWidth;
Pints[2].y:= 20;
Pints[3].x:= ClientWidth div 2;
Pints[3].y:= ClientHeight;
NewRgn:=CreatePolygonRgn(Pints,3, ALTERNATE );
SetWindowRgn(Handle, NewRgn,true);
RemoveProp(Handle,'region');
SetProp(Handle, 'region', NewRgn);
if NormalRgn then NormalRgn:=Not(NormalRgn);
WinMovable := true;
end;  }

procedure TBM.NormalWindow1Click(Sender: TObject);
begin
if Not(NormalRgn) then
 begin
  BorderStyle:=bsSizeable;
  SetWindowRgn(Handle,OrginalRgn,true);
  NormalRgn:=Not(NormalRgn);
//  FracTools.Enabled := true;
  WalkMenu.Enabled := oldwalkmenu;
  WinMovable := false;
 end;
end;

procedure TBM.FractalType1Click(Sender: TObject);
begin
 popupmenu2.Popup(150,20);
end;

procedure TBM.PopupMenu2Popup(Sender: TObject);
var i : byte;
begin
 for i := 0 to TypesMenu1.Count-1 do
     popupmenu2.Items[i].Checked := TypesMenu1.Items[i].Checked;
end;

procedure TBM.Lamda1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 28;
Lamda1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=true;
FractalName := Fractal[Lambda];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := true;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
if ((not ComingFromZoom) and (FractalCompleted)) then SParams.ShowModal;
c := Complexfunc(LamdaR,LamdaIm);
StUpdate;
FractalProc :=  ComputeLambdaFractal;
AllFractals;
end;

procedure TBM.Go;
var i: byte;
begin
for i := 0 to TypesMenu1.Count-1 do
   if TypesMenu1.Items[i].Checked then
      begin
      ComingFromZoom := True;
      TypesMenu1.Items[i].Click;
      end;
if StrangeAttractors1.Checked then              // Added 23-2-98 to support
   begin
   if Rossler1.Checked then Rossler1.Click      // Strange Attractors.
   else if Lorenz1.Checked then Lorenz1.Click;
   end
else if Tchebychev1.Checked then
   begin                              // Added 25-2-98 to support
   if T31.Checked then T31.Click      // Tchebychev Fractals.
   else if T51.Checked then T51.Click
   else if C61.Checked then C61.Click;
end;
end;

procedure TBM.GODrawSelectedFractal1Click(Sender: TObject);
begin
 if working then begin   // Εάν Δουλεύει
  escpressed := True;   //  Σταμάτα το.
  exit;                 // επιστροφή.
 end;
 Go;
end;

procedure TBM.FormDestroy(Sender: TObject);
begin
Image.Picture.Graphic := nil;
ColorList.Clear;
TrueColorColorList.Clear;
ColorList.Free;
TrueColorColorList.Free;
end;

procedure CopyColorList2Palette;
var i: integer;
begin
new(node);
with ColorList do
for i:=0 to Count-1 do
  begin
    node :=  items[i];
    pal[i] :=  RGB(node.rgbtRed,node.rgbtGreen,node.rgbtBlue);
  end;
end;

procedure TBM.ColorCycling1Click(Sender: TObject);
var howmany: integer;
begin
original.PixelFormat := pf24bit;
DoTrueColor := true;
CycleStart := 1;
howmany := CountColors(original,false); // count the colors first
TrueColorColorList.Clear;
TrueColorColorList.Capacity := howmany+1; // set capacity of ColorList
CountColors(original,true);             // count the colors again and fill the colorList
TrueColorColorList.Pack;                // pack the List
TrueColorColorList.Capacity := TrueColorColorList.Count; // free memory of deleted nodes of list
with ColorCyclingForm do
 begin
  Clientwidth := BM.ClientWidth;
  Clientheight := BM.Clientheight+Panel1.Height;
  Image1.Picture.Graphic.Assign(original);
  Image1.Picture.Bitmap.Canvas.Pixels[0,0] := original.Canvas.Pixels[0,0];
  ShowModal;
 end;
end;

  //*******************  CountColors  **********************************************
  // Count number of unique R-G-B triples in a pf24bit Bitmap.
  //
  // Use 2D array of TBits objects -- when (R,G) combination occurs
  // for the first time, create 256-bit array of bits in blue dimension.
  // So, overall this is a fairly sparse matrix for most pictures.
  // Tested with pictures created with a known number of colors, including
  // a specially constructed image with 1024*1024 = 1,048,576 colors.
  //
  // efg, October 1998.
  // Modified to fill a color List at the same time. (Elias 25-4-99)
function CountColors(const Bitmap:  TBitmap; FillList: boolean): integer;
var
 Flags:  array[Byte, Byte] of TBits;
 i    :  INTEGER;
 j    :  INTEGER;
 k    :  INTEGER;
 rowIn:  pRGBArray; //pRGBTripleArray;
 RowRGB24   :  pRGBArray;
// nodes:Integer;
begin
if fillList then TrueColorColorList.clear;
//nodes:=0;
 // Be sure bitmap is 24-bits/pixel
 Assert(Bitmap.PixelFormat = pf24Bit,NO24BITMAP);
 // Clear 2D array of TBits objects
  for j := 0 to 255 do
   for i := 0 to 255 do
     Flags[i,j] := nil;
 // Step through each scanline of image
  for j := 0 to Bitmap.Height-1 do
   begin
      rowIn  := Bitmap.Scanline[j];
      RowRGB24 := Bitmap.Scanline[j];
      for i := 0 to Bitmap.Width-1 do
       begin

        with rowIn[i] do
         begin
          if   not Assigned(Flags[rgbtRed, rgbtGreen]) then
           begin
            // Create 3D column when needed
            Flags[rgbtRed, rgbtGreen] := TBits.Create;
            Flags[rgbtRed, rgbtGreen].Size := 256;
           end;
          // Mark this R-G-B triple
          Flags[rgbtRed,rgbtGreen].Bits[rgbtBlue] := true;
            //**************************************************
            if FillList then            // Fill In the True Color List
            begin
               if ((i <= min(255,bitmap.Height)) and (j<= min(255,bitmap.Width) )) then
               if   Assigned(Flags[i,j]) then
               begin
               for k:=0 to 255 do
               if Flags[i,j].Bits[k] then
                begin
             new(Node);
             //node^ := rowrgb24[i];  //rowrgb24[i];
               WITH Node^ DO
                BEGIN
                 rgbtRed   := rowrgb24[i].rgbtRed;
                 rgbtGreen := rowrgb24[j].rgbtGreen;
                 rgbtBlue  := rowrgb24[k].rgbtBlue;
               END;
              TrueColorColorList.Add(Node);
              //inc(nodes);
              //BM.canvas.TextOut(BM.ClientWidth-50,10,Inttostr(nodes));
             end;
           end;
         end;
     //***************************************************
        end;
      end;
    end;
  Result := 0;
  // Count and Free TBits objects
  for j := 0 to 255 do
    begin
     for i := 0 to 255 do
      begin
        if   Assigned(Flags[i,j]) then
         begin
          for k := 0 to 255 do
            if   Flags[i,j].Bits[k] then
             begin
             inc(Result);
           end;
          Flags[i,j].Free;
        end;
      end;
    end;
end;   {CountColors}

procedure TBM.CountColors1Click(Sender: TObject);
var ColorsInBitmap : Integer;
r: string;
begin
 original.PixelFormat := pf24bit;
 if (original.PixelFormat <> pf24Bit) then
  begin MessageDlg(NO24BITMAP,mtCustom,[mbOK],0); exit; end;
 ColorsInBitmap := CountColors(original,false); //don't fill the colorlist
 r := 'Total of' + Format(' %8d  ',[ColorsInBitmap])+ 'Unique Colors found';
 MessageDlg(r,mtCustom,[mbOk],0);
end;

procedure TBM.ColorCycling2Click(Sender: TObject);
begin
original.PixelFormat := pf24bit;
DoTrueColor := false;
CycleStart := 1;
with ColorCyclingForm do
 begin
  Clientwidth := BM.ClientWidth;
  Clientheight := BM.Clientheight+Panel1.Height;
  Image1.Picture.Graphic.Assign(original);
  Image1.Picture.Bitmap.Canvas.Pixels[0,0] := original.Canvas.Pixels[0,0];
  ShowModal;
 end;
end;

procedure TBM.AllPalettesClick(Sender: TObject);
var
    R,G,B     :  Byte;
    Filename  :  String;
    MapCount  :  Integer;
    tc        :  Integer;
    MapFile   :  TextFile;
    node      :  pRGBTriple;
    Path,r1   :  String;
    ReturnCode:  Integer;
    SearchRec :  TSearchRec;
    pals: boolean;
label dopals,fin;
begin
 MapCount := 0;
 ColorList.Clear;
 pals:=false;
  Path := PaletteDirectory+'\';
  ReturnCode := FindFirst(Path + '*.MAP', faAnyFile, SearchRec);
dopals:
  while ReturnCode = 0 do
  begin
    FileName := Path + SearchRec.Name;
    AssignFile(MapFile, Filename);
    Reset(MapFile);
    if not pals then
    begin
    try
      while not EOF(MapFile)
      do begin
        readln(MapFile, R, G, B);
        New(Node);
        with Node^ do
        begin
          rgbtRed   := R;
          rgbtGreen := G;
          rgbtBlue  := B
        end;
        ColorList.Add(Node);
      end;
    finally
      CloseFile(MapFile);
    end;
    end
    else
    begin
      Readln(MapFile,r1);
      if r1 <> s8 then
      begin
       MessageDlg(NOPALETTE + #10#13 + FileName,mtError,[mbOK],0);
       goto fin;
      end;
      while not Eof(MapFile) do
       begin
        Readln(MapFile,r1);
        tc := StrToInt(r1);
        R := GetRValue(tc);
        G := GetGValue(tc);
        B := GetBValue(tc);
        New(Node);
        with Node^ do
        begin
          rgbtRed   := R;
          rgbtGreen := G;
          rgbtBlue  := B
        end;
        ColorList.Add(Node);
       end;
 fin:
      CloseFile(MapFile);
   end;
    Info.Label45.Caption := 'Colors  '+ IntToStr(ColorList.Count);
    inc(MapCount);
    Info.Label47.Caption := 'Palettes  ' +IntToStr(MapCount);
    Application.ProcessMessages;
    ReturnCode := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
  if not pals then
  begin
   ReturnCode := FindFirst(Path + '*.PAL', faAnyFile, SearchRec);
   pals := true;
   goto dopals;
  end;
  ColorCycling2.Click;
end;

procedure TBM.CreateLargeDiskImage1Click(Sender: TObject);
var
row,col: Integer;
LargeBitmap: TBitmap;
Jpg1 : TJPEGImage;
FileExtS: String;
label  bailout;
begin
SaveDialog1.Title := s2;
SaveDialog1.FilterIndex := 6;
SaveDialog1.InitialDir := GraphicsDirectory;
if not SaveDialog1.Execute then exit;
FileExtS := UpperCase(ExtractFileExt(SaveDialog1.Filename));
 if (FileExtS <> FileX[feBMP]) and (FileExtS <> FileX[feJPG]) then
    begin
    MessageDlg(' You Can Only Save This File As JPEG or BMP ',mtError,[mbOk],0);
    goto bailout;
 end;
if LBSizeFrm.ShowModal = mrCancel then exit;
Application.ProcessMessages;
clrscr;
LargeBitmap := TBitmap.Create;
LargeBitmap.PixelFormat := pf24bit;
 LargeBitmap.Width  := LargeBitmapX; //2048;
 LargeBitmap.Height := LargeBitmapY; //2048;
PatBlt(LargeBitmap.canvas.handle,0,0,LargeBitmap.Width,LargeBitmap.height,BLACKNESS);
LargeDiskImage := true;
escpressed := False;
Working := True;
WalkMode := false;
BM.WalkModeOFF1.Checked := true;
BM.WalkTheFractal1.Checked := false;
Screen.Cursor := crHourglass;
 stepx := 2*r / LargeBitmap.Width ;
 stepy := 2*r / LargeBitmap.Height;
 rec := stepx+recen;
 imc := imcen;
 XMax := recen + r;
 XMin := recen - r;
 YMax := imcen - r;
 YMin := imcen + r;
 if (kend > Iters) then
  begin
   Iters := kend;
   end;
 with LargeBitmap.Canvas do
 begin
   Pen.Mode := pmCopy;
   Pen.Width := 1;
   Brush.Style := bsclear;
   Brush.Color := BM.Color;
end;
 deltaP := (XMax-XMin)/LargeBitmap.width;
 deltaQ := (YMax-YMin)/LargeBitmap.Height;
 if ProgressBarOn then begin
 info.G1.Progress := 0;
 info.G1.Visible := true;
 end;
if TimerOn then begin Timer1.Enabled :=True; StartTime := Time; end;
 for row := 0 to LargeBitmap.Height-1 do
 begin
  Application.ProcessMessages;
  if escpressed then begin escpressed:= False; break; end;
  Lrgb  := LargeBitmap.ScanLine[row];
  for col := 0 to LargeBitmap.Width-1 do
      FractalProc(col,row);

  if ProgressBarOn then Info.G1.Progress := (100 * row) div LargeBitmap.width;
 end; // for row
Info.G1.Progress := 100;
if FileExtS = FileX[feJPG] then
begin
  Jpg1 := TJPEGImage.Create;
  Jpg1.Assign(LargeBitmap);
  Jpg1.ProgressiveEncoding := jpgProgEncode;
  Jpg1.CompressionQuality := jpgCmpQlt;
 // Canvas.StretchDraw(ClientRect,LargeBitmap);
 // LargeBitmap.free;
  Application.ProcessMessages;
  Jpg1.SaveToFile(SaveDialog1.Filename);
  jpg1.Free
end
else LargeBitmap.SaveToFile(SaveDialog1.Filename);

Canvas.StretchDraw(ClientRect,LargeBitmap);
LargeBitmap.free;
if SndMenu.checked then MessageBeep(MB_ICONEXCLAMATION);
//if FileExtS = FileX[feBMP] then Canvas.StretchDraw(ClientRect,LargeBitmap);
Application.ProcessMessages;
temp.Width := ClientWidth;
temp.Height := ClientHeight;
temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
original.Width := ClientWidth;
original.Height := ClientHeight;
original.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
//if FileExtS = FileX[feJPG] then jpg1.Free
//else LargeBitmap.Free;
bailout:
LargeDiskImage := false;
Screen.Cursor := crDefault;
Working := False;
BM.Timer1.Enabled := False;
Info.G1.visible:= false;
LoadedFractalInit;
end;

procedure TBM.BioMorphJulia1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 29;
BioMorphJulia1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[Biojulia];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := true;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := ComputeBioFractal; //ComputeFullJulia;
AllFractals;
end;

//procedure SetGifOptions(var GIF: TGifImage);
//begin
//with BM do begin
// if Netscape216.Checked then GIF.ColorReduction := rmNetscape
// else if BlackWhite.Checked then GIF.ColorReduction := rmMonochrome
// else if Gray256.Checked then GIF.ColorReduction := rmGrayScale
// else if WindowsGray4.Checked then GIF.ColorReduction := rmWindowsGray
// else if WindowsSys20.Checked then GIF.ColorReduction := rmWindows20
// else if WindowsHalftone.Checked then GIF.ColorReduction := rmWindows256
// else if Optimized1.Checked then GIF.ColorReduction := rmQuantize
// else if OptimizedWin.Checked then GIF.ColorReduction := rmQuantizeWindows
// else GIF.ColorReduction := rmNone;
//
// if (ErrorDifusion1.Checked) then GIF.DitherMode := dmFloydSteinberg
// else GIF.DitherMode := dmNearest;
//
// if (LZW1.Checked) then GIF.Compression := gcLZW
// else GIF.Compression := gcRLE;
//
// end; //with BM
//end;

//procedure TBM.RLE1Click(Sender: TObject);
//begin
//RLE1.Checked := true;
//LZW1.Checked := false;
//end;
//
//procedure TBM.LZW1Click(Sender: TObject);
//begin
//LZW1.Checked := true;
//RLE1.Checked := false;
//end;

//procedure TBM.NearestColor1Click(Sender: TObject);
//begin
//NearestColor1.Checked := true;
//ErrorDifusion1.Checked := false;
//end;
//
//procedure TBM.ErrorDifusion1Click(Sender: TObject);
//begin
//ErrorDifusion1.Checked := true;
//NearestColor1.Checked := false;
//end;
//
//procedure TBM.N256colors1Click(Sender: TObject);
//begin
//GIFImageDefaultColorReductionBits := 8;
//N256colors1.Checked := true;
//N128colors1.Checked:= false;
//N64colors1.Checked := false;
//N32colors1.Checked := false;
//N16colors1.Checked:= false;
//N8colors1.Checked := false;
//end;
//
//procedure TBM.N128colors1Click(Sender: TObject);
//begin
//GIFImageDefaultColorReductionBits := 7;
//N128colors1.Checked:= true;
//N256colors1.Checked := false;
//N64colors1.Checked := false;
//N32colors1.Checked := false;
//N16colors1.Checked := false;
//N8colors1.Checked := false;
//end;
//
//procedure TBM.N64colors1Click(Sender: TObject);
//begin
//GIFImageDefaultColorReductionBits := 6;
//N64colors1.Checked:= true;
//N256colors1.Checked := false;
//N128colors1.Checked:= false;
//N32colors1.Checked := false;
//N16colors1.Checked := false;
//N8colors1.Checked := false;
//end;
//
//procedure TBM.N32colors1Click(Sender: TObject);
//begin
//GIFImageDefaultColorReductionBits := 5;
//N32colors1.Checked:= true;
//N256colors1.Checked := false;
//N128colors1.Checked:= false;
//N64colors1.Checked := false;
//N16colors1.Checked := false;
//N8colors1.Checked := false;
//end;
//
//procedure TBM.N16colors1Click(Sender: TObject);
//begin
//GIFImageDefaultColorReductionBits := 4;
//N16colors1.Checked:= true;
//N256colors1.Checked := false;
//N128colors1.Checked:= false;
//N64colors1.Checked := false;
//N32colors1.Checked := false;
//N8colors1.Checked := false;
//end;
//
//procedure TBM.N8colors1Click(Sender: TObject);
//begin
//GIFImageDefaultColorReductionBits := 3;
//N8colors1.Checked:= true;
//N256colors1.Checked := false;
//N128colors1.Checked:= false;
//N64colors1.Checked := false;
//N32colors1.Checked := false;
//N16colors1.Checked := false;
//end;
//
//procedure TBM.None1Click(Sender: TObject);
//begin
//None1.Checked := true;
//WindowsSys20.Checked:= false;
//WindowsHalftone.Checked:= false;
//WindowsGray4.Checked:= false;
//BlackWhite.Checked:= false;
//Gray256.Checked:= false;
//Netscape216.Checked:= false;
//Optimized1.Checked:= false;
//OptimizedWin.Checked:= false;
//end;

//procedure TBM.WindowsSys20Click(Sender: TObject);
//begin
//None1.Checked := false;
//WindowsSys20.Checked:= true;
//WindowsHalftone.Checked:= false;
//WindowsGray4.Checked:= false;
//BlackWhite.Checked:= false;
//Gray256.Checked:= false;
//Netscape216.Checked:= false;
//Optimized1.Checked:= false;
//OptimizedWin.Checked:= false;
//end;

//procedure TBM.WindowsHalftoneClick(Sender: TObject);
//var
//  DesktopDC		: HDC;
//  BitsPerPixel		: integer;
//begin
//DesktopDC := GetDC(0);
//  try
//    BitsPerPixel := GetDeviceCaps(DesktopDC, BITSPIXEL) * GetDeviceCaps(DesktopDC, PLANES);
//  finally
//    ReleaseDC(0, DesktopDC);
//  end;
//  if (BitsPerPixel > 8) then
//    ShowMessage('Please note that the Windows Halftone color reduction method'+#13+
//                'only works properly in 256 color display mode.'+#13+#13+
//                'Since your display adapter is currently in '+IntToStr({1 SHL} BitsPerPixel)+'bit color mode,'+#13+
//                'the Windows Halftone Palette method will produce the same'+#13+
//                'result as the Windows System Palette method.');
//
//WindowsHalftone.Checked:= true;
//None1.Checked := false;
//WindowsSys20.Checked:= false;
//WindowsGray4.Checked:= false;
//BlackWhite.Checked:= false;
//Gray256.Checked:= false;
//Netscape216.Checked:= false;
//Optimized1.Checked:= false;
//OptimizedWin.Checked:= false;
//end;
//
//procedure TBM.WindowsGray4Click(Sender: TObject);
//begin
//WindowsGray4.Checked:= true;
//None1.Checked := false;
//WindowsSys20.Checked:= false;
//WindowsHalftone.Checked:= false;
//BlackWhite.Checked:= false;
//Gray256.Checked:= false;
//Netscape216.Checked:= false;
//Optimized1.Checked:= false;
//OptimizedWin.Checked:= false;
//end;
//
//procedure TBM.BlackWhiteClick(Sender: TObject);
//begin
//BlackWhite.Checked:= true;
//None1.Checked := false;
//WindowsSys20.Checked:= false;
//WindowsHalftone.Checked:= false;
//WindowsGray4.Checked:= false;
//Gray256.Checked:= false;
//Netscape216.Checked:= false;
//Optimized1.Checked:= false;
//OptimizedWin.Checked:= false;
//end;
//
//procedure TBM.Gray256Click(Sender: TObject);
//begin
//Gray256.Checked:= true;
//None1.Checked := false;
//WindowsSys20.Checked:= false;
//WindowsHalftone.Checked:= false;
//WindowsGray4.Checked:= false;
//BlackWhite.Checked:= false;
//Netscape216.Checked:= false;
//Optimized1.Checked:= false;
//OptimizedWin.Checked:= false;
//end;
//
//procedure TBM.Netscape216Click(Sender: TObject);
//begin
//Netscape216.Checked:= true;
//None1.Checked := false;
//WindowsSys20.Checked:= false;
//WindowsHalftone.Checked:= false;
//WindowsGray4.Checked:= false;
//BlackWhite.Checked:= false;
//Gray256.Checked:= false;
//Optimized1.Checked:= false;
//OptimizedWin.Checked:= false;
//end;
//
//procedure TBM.OptimizedWinClick(Sender: TObject);
//begin
//OptimizedWin.Checked:= true;
//None1.Checked := false;
//WindowsSys20.Checked:= false;
//WindowsHalftone.Checked:= false;
//WindowsGray4.Checked:= false;
//BlackWhite.Checked:= false;
//Gray256.Checked:= false;
//Netscape216.Checked:= false;
//Optimized1.Checked:= false;
//end;
//
//procedure TBM.Optimized1Click(Sender: TObject);
//begin
//OptimizedWin.Checked:= false;
//None1.Checked := false;
//WindowsSys20.Checked:= false;
//WindowsHalftone.Checked:= false;
//WindowsGray4.Checked:= false;
//BlackWhite.Checked:= false;
//Gray256.Checked:= false;
//Netscape216.Checked:= false;
//Optimized1.Checked:= true;
//end;

procedure TBM.KeyboardShortcuts1Click(Sender: TObject);
begin
Application.HelpCommand(HELP_CONTEXT,3000);
end;

//procedure TBM.MoreAboutEliFrac1Click(Sender: TObject);
//begin
//Application.CreateForm(TaboutForm1,AboutForm1);
//AboutForm1.Showmodal;
//end;

//procedure TBM.OpenGIFAnimation1Click(Sender: TObject);
//begin
//OpenPictureDialog1.Title := 'Open GIF Animation';
//OpenPictureDialog1.FilterIndex := 8;
////if not RememberLastDir1.checked then
//OpenPictureDialog1.InitialDir := AnimDirectory;
//if OpenPictureDialog1.Execute then
// begin
// Image.Picture.Graphic := nil;
// Image.Picture.LoadFromFile(OpenPictureDialog1.FileName);
// Image.Enabled := true;
// Image.Visible:= true;
// AnimStopped := false;
//  (Image.Picture.Graphic as TGIFImage).DrawOptions :=
//    (Image.Picture.Graphic as TGIFImage).DrawOptions + [goDirectDraw];
// end;
//end;

//procedure TBM.ImageClick(Sender: TObject);
//begin
// if Image.Picture.Graphic is TBitmap then exit;
// if AnimStopped then
//     begin
//     (Image.Picture.Graphic as TGIFImage).PaintResume;
//     AnimStopped := false;
//     end
//   else
//    begin
//    (Image.Picture.Graphic as TGIFImage).PaintPause;
//    AnimStopped := true;
//    end;
//end;

//procedure TBM.ImageDblClick(Sender: TObject);
//begin
// if Image.Picture.Graphic is TBitmap then exit;
// (Image.Picture.Graphic as TGIFImage).PaintStop;
// AnimStopped := true;
// Image.Picture.Graphic := nil;
// Image.Enabled := false;
// Image.Visible:= false;
//end;

function IntToColor(i:Integer):TFColor;
begin
  Result.b:=i shr 16;
  Result.g:=i shr 8;
  Result.r:=i;
end;

function IntToByte(i:Integer):Byte;
begin
  if      i>255 then Result:=255
  else if i<0   then Result:=0
  else               Result:=i;
end;

function TrimInt(i,Min,Max:Integer):Integer;
begin
  if      i>Max then Result:=Max
  else if i<Min then Result:=Min
  else               Result:=i;
end;

{
procedure TBM.Process(fun : TProcessingFunction2);
var
SrcImage,DstImage : pIplImage;
//i: Integer;
b : boolean;
ms : TMemoryStream;
bmih : pBitmapInfoHeader;
ABitmap : TBitmap;
p : pointer;
begin
 Screen.Cursor := crHourGlass;
 ms := TMemoryStream.Create;
 original.HandleType := bmDIB;
 ABitmap := TBitmap.Create;
 ABitmap.Assign(original);
 ABitmap.SaveToStream(ms);
 bmih := @(pbyteArray(ms.Memory)^[SizeOf(TBitmapFileHeader)]);
 b:=True;
 srcImage := IplTranslateDIB(bmih, b);
 dstImage := IplCloneImage(srcImage);
 IplSet(dstImage, 0);
 p := pointer(Cardinal(ms.Memory) + pBitmapFileHeader(ms.Memory)^.bfOffBits);

 if (Assigned(srcImage)) and (Assigned(dstImage))
   then  fun(srcImage, dstImage);

 Move(dstImage^.ImageData^, p^, BMIH^.biSizeImage);
 IplDeallocateImage(srcImage);
 IplDeallocateImage(dstImage);
 ms.Position := 0;
 temp.LoadFromStream(ms);
 ms.Free;
 Canvas.CopyRect(ClientRect,temp.Canvas,ClientRect);
 Screen.Cursor := crDefault;
 ABitmap.Free;
 if not preview then
    begin
    original.Assign(temp);
    if SndMenu.checked then MessageBeep(MB_ICONEXCLAMATION);
    end;
end;
}


//procedure TBM.LaplasMenuClick(Sender: TObject);
//begin
// CopyUndoBmp;
//Process(Laplas); // 12-12-99 Using Intel Library
//end;

{procedure TBM.ThresholdMenuClick(Sender: TObject);
begin
CopyUndobmp;
InFilPar.ShowModal;
if InFilPar.ModalResult = mrOk then
begin
 original.Assign(temp);
 exit;
end
else Undo1Click(self);
end;  }

{procedure TBM.LogarithmicMenuClick(Sender: TObject);
begin
CopyUndobmp;
InFilPar2.ShowModal;
if InFilPar2.ModalResult = mrOk then
begin
 original.Assign(temp);
 exit;
end
else Undo1Click(self);
end; }

{procedure TBM.ExponentFilterMenuClick(Sender: TObject);
begin
CopyUndobmp;
InFilPar3.ShowModal;
if InFilPar3.ModalResult = mrOk then
begin
 original.Assign(temp);
 exit;
end
else Undo1Click(self);
end; }

//procedure TBM.HyperFilterMenuClick(Sender: TObject);
//begin
{CopyUndobmp;
Process(Hyperb);  // 12-12-99 Using Intel Library
}
//end;

{procedure TBM.IntensifyMenuClick(Sender: TObject);
begin
CopyUndobmp;
InFilPar4.ShowModal;
if InFilPar4.ModalResult = mrOk then
begin
 original.Assign(temp);
 exit;
end
else Undo1Click(self);
end; }

//procedure TBM.ArithmeticMenuClick(Sender: TObject);
//begin
{CopyUndobmp;
InFilPar5.ShowModal;
if InFilPar5.ModalResult = mrOk then
begin
 original.Assign(temp);
 exit;
end
else Undo1Click(self);  }
//end;

//procedure TBM.MaxFilterMenuClick(Sender: TObject);
//begin
{CopyUndobmp;
Process(MaxFilter);  // 12-12-99 Using Intel Library
}
//end;

//procedure TBM.MinFilterMenuClick(Sender: TObject);
//begin
{CopyUndobmp;
Process(MinFilter);  // 12-12-99 Using Intel Library
}
//end;

//procedure TBM.ErodeMenuClick(Sender: TObject);
//begin
{CopyUndobmp;
InFilPar6.ShowModal;
if InFilPar6.ModalResult = mrOk then
begin
 original.Assign(temp);
 exit;
end
else Undo1Click(self); }
//end;

//procedure TBM.DialateMenuClick(Sender: TObject);
//begin
{CopyUndobmp;
InFilPar7.ShowModal;
if InFilPar7.ModalResult = mrOk then
begin
 original.Assign(temp);
 exit;
end
else Undo1Click(self);  }
//end;

{procedure TBM.OpenFilterMenuClick(Sender: TObject);
begin
CopyUndobmp;
pInteger(Coeff)^ := 1;
Process(Opening);
end; }

{procedure TBM.CloseFilterMenuClick(Sender: TObject);
begin
CopyUndobmp;
pInteger(Coeff)^ := 1;
Process(Closing);
end; }

procedure TBM.Newton1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 30;
Newton1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := True;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[newton];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := ComputeNewton;
AllFractals;
end;

procedure TBM.RGBToCMYK1Click(Sender: TObject);
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
black: byte;
//oldb,oldg,oldr: byte;
begin
//*************************************************
{CMY to CMYK
Black   = minimum (Cyan,Magenta,Yellow)
Cyan    = (Cyan-Black)/(1-Black)
Magenta = (Magenta-Black)/(1-Black)
Yellow  = (Yellow-Black)/(1-Black)            }
//************************************************
{CMYK to CMY
Cyan    = minimum(1,Cyan*(1-Black)+Black)
Magenta = minimum(1,Magenta*(1-Black)+Black)
Yellow  = minimum(1,Yellow*(1-Black)+Black)     }
//**************************************************

CopyUndobmp;
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        black := min(RowRGB[x].rgbtRed,min(RowRGB[x].rgbtGreen,RowRGB[x].rgbtBlue));
        RowRGB[x].rgbtRed   := (RowRGB[x].rgbtRed - black) div max(1,1-black);
        RowRGB[x].rgbtGreen := (RowRGB[x].rgbtGreen - black) div max(1,1-black);
        RowRGB[x].rgbtBlue  := (RowRGB[x].rgbtBlue  - black) div max(1,1-black);
       end;
    end;
temp.Assign(temp1);
original.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.RGBToCMY1Click(Sender: TObject);
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;

begin
CopyUndobmp;
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := 255 - RowRGB[x].rgbtRed;
        RowRGB[x].rgbtGreen := 255 - RowRGB[x].rgbtGreen;
        RowRGB[x].rgbtBlue  := 255 - RowRGB[x].rgbtBlue;
       end;
    end;
temp.Assign(temp1);
original.Assign(temp1);
Repaint;
temp1.free;
end;

(*
  procedure TBM.RGBToHLS1Click(Sender: TObject);
  begin
  //CopyUndobmp;
  //Process(RGB2HLS);
  end;
*)

procedure TBM.RGBToYIQClick(Sender: TObject);
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
oldred,oldgreen,oldblue :byte;
begin
{*******************************************************************
Here is the RGB -> YIQ conversion:

    [ Y ]     [ 0.299   0.587   0.114 ] [ R ]
    [ I ]  =  [ 0.596  -0.275  -0.321 ] [ G ]
    [ Q ]     [ 0.212  -0.523   0.311 ] [ B ]

Here is the YIQ -> RGB conversion:

    [ R ]     [ 1   0.956   0.621 ] [ Y ]
    [ G ]  =  [ 1  -0.272  -0.647 ] [ I ]
    [ B ]     [ 1  -1.105   1.702 ] [ Q ]
*******************************************************************}
CopyUndobmp;
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        oldred:=  RowRGB[x].rgbtRed;
        oldgreen:= rowrgb[x].rgbtGreen;
        oldblue:= rowrgb[x].rgbtBlue;

        RowRGB[x].rgbtRed   := inttobyte(floor(255+(0.299*oldRed  + 0.587*oldgreen + 0.114*oldblue)) mod 255 );
        RowRGB[x].rgbtGreen := inttobyte(floor(255+(0.596*oldred  - 0.275*oldgreen - 0.321*oldblue))mod 255 );
        RowRGB[x].rgbtBlue  := inttobyte(floor(255+(0.212*oldred  - 0.523*oldgreen + 0.311*oldblue)) mod 255);
       end;
    end;
temp.Assign(temp1);
original.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.RGBTOYUV1Click(Sender: TObject);
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
oldred :byte;
begin
CopyUndobmp;
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

    //Y = [(9798 R + 19235G + 3736 B) >>15]
    //U = [(16122 (B - Y))>>15]
    //V = [(25203 (R - Y))>>15]

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        oldred:=  RowRGB[x].rgbtRed;
        RowRGB[x].rgbtRed   := ((9798*RowRGB[x].rgbtRed + 19235*RowRGB[x].rgbtGreen + 3736*RowRGB[x].rgbtBlue) shr 15);
        RowRGB[x].rgbtGreen := ((16122*(RowRGB[x].rgbtBlue - RowRGB[x].rgbtRed)) shr 15);
        RowRGB[x].rgbtBlue  := ((25203 *(oldred - RowRGB[x].rgbtRed)) shr 15);
       end;
    end;
temp.Assign(temp1);
original.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.RGBToYCrCb1Click(Sender: TObject);
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
oldred,oldgreen,oldblue :byte;
begin
//Y  =  (0.257 * R) + (0.504 * G) + (0.098 * B) + 16
//Cr =  (0.439 * R) - (0.368 * G) - (0.071 * B) + 128
//Cb = -(0.148 * R) - (0.291 * G) + (0.439 * B) + 128
CopyUndobmp;
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        oldred:=  RowRGB[x].rgbtRed;
        oldgreen:= rowrgb[x].rgbtGreen;
        oldblue:= rowrgb[x].rgbtBlue;

        RowRGB[x].rgbtRed   := inttobyte(floor((0.257*oldRed  + 0.504*oldgreen + 0.098*oldblue +16)) );
        RowRGB[x].rgbtGreen := inttobyte(floor((0.439*oldred  - 0.368*oldgreen - 0.071*oldblue +128)));
        RowRGB[x].rgbtBlue  := inttobyte(floor((0.148*oldred  - 0.291*oldgreen + 0.439*oldblue +128)));
       end;
    end;
temp.Assign(temp1);
original.Assign(temp1);
Repaint;
temp1.free;
end;

(*
  procedure TBM.Spray1Click(Sender: TObject);
  begin
  CopyUndobmp;
  SprayForm.ShowModal;
  if Sprayform.ModalResult = mrOk then
   begin
    Application.ProcessMessages;
    original.Assign(temp);
   end
  else undo1click(self);
  end;
*)

procedure TBM.Contrast1Click(Sender: TObject);
begin
CopyUndobmp;
ContrastForm.ShowModal;
if ContrastForm.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
 end
else undo1click(self);
end;

procedure TBM.AddColorNoise1Click(Sender: TObject);
begin
CopyUndobmp;
CNoiseForm.ShowModal;
if CNoiseForm.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
 end
else undo1click(self);
end;

procedure TBM.RGBMenu1Click(Sender: TObject);
begin
CopyUndobmp;
RGBForm.ShowModal;
if RGBForm.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
 end
else undo1click(self);
end;

procedure TBM.Saturation1Click(Sender: TObject);
begin
CopyUndobmp;
SaturationForm.ShowModal;
if SaturationForm.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
 end
else undo1click(self);
end;

procedure TBM.Lightness1Click(Sender: TObject);
begin
CopyUndobmp;
LightnessForm.ShowModal;
if LightnessForm.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
 end
else undo1click(self);
end;

procedure TBM.TwistApply(Amount:integer);
var
  fxmid, fymid : Extended;
  txmid, tymid : Extended;
  fx,fy : Extended;
  tx2, ty2 : Extended;
  r : Extended;
  theta : Extended;
  ifx, ify : integer;
  dx, dy : Extended;
  OFFSET : Extended;
  ty, tx             : Integer;
  total,new              : TRGBTriple;
  weight_x, weight_y     : array[0..1] of Extended;
  weight                 : Extended;
  ix, iy,w,h             : Integer;
  costh,sinth            : extended;
  sli                : pRGBArray;
  temp1              : TBitmap;
  AllScanLines: array[0..800] of pRGBArray;

function ArcTan2(xt,yt : Extended): Extended;
  begin
    if xt = 0 then
      if yt > 0 then
        Result := Pi/2
      else
        Result := -(Pi/2)
    else begin
      Result := ArcTan(yt/xt);
      if xt < 0 then
        Result := Pi + ArcTan(yt/xt);
    end;
end;

//procedure TBM.TwistApply.ArcTan2;
begin
if working then exit;
working := true;
temp1 := TBitmap.Create;
temp1.Width := BM.original.width;
temp1.Height := BM.original.height;
temp1.Assign(BM.original);

  w:= temp1.width;
  h:= temp1.height;
  OFFSET := (Pi/2);
  dx := w - 1;
  dy := h - 1;
  r := Sqrt(dx * dx + dy * dy);
  tx2 := r;
  ty2 := r;
  txmid := (w-1)/2;    //Adjust these to move center of rotation.
  tymid := (h-1)/2;   //Adjust these to move center of rotation.
  fxmid := (w-1)/2;
  fymid := (h-1)/2;
  if tx2 >= w then tx2 := w-1;
  if ty2 >= h then ty2 := h-1;

  for ix:=0 to h-1 do
    AllScanLines[ix] := temp1.scanline[ix];

  for ty := 0 to Round(ty2) do begin
    for tx := 0 to Round(tx2) do begin
      dx := tx - txmid;
      dy := ty - tymid;
      r := Sqrt(dx * dx + dy * dy);
      if r = 0 then begin
        fx := 0;
        fy := 0;
      end
      else begin
        theta := ArcTan2(dx,dy) - r/Amount - OFFSET;
        sincos(theta,sinth,costh);
        fx := r * {Cos(theta)} costh ;
        fy := r * {Sin(theta)} sinth ;
      end;
      fx := fx + fxmid;
      fy := fy + fymid;

      ify := Trunc(fy);
      ifx := Trunc(fx);
                // Calculate the weights.
      if fy >= 0  then begin
        weight_y[1] := fy - ify;
        weight_y[0] := 1 - weight_y[1];
      end else begin
        weight_y[0] := -(fy - ify);
        weight_y[1] := 1 - weight_y[0];
      end;
      if fx >= 0 then begin
        weight_x[1] := fx - ifx;
        weight_x[0] := 1 - weight_x[1];
      end else begin
        weight_x[0] := -(fx - ifx);
        Weight_x[1] := 1 - weight_x[0];
      end;

      if ifx < 0 then
        ifx := w-1-(-ifx mod w)
      else if ifx > w-1  then
        ifx := ifx mod w;
      if ify < 0 then
        ify := h-1-(-ify mod h)
      else if ify > h-1 then
        ify := ify mod h;

        total := zero;
      for iy := 0 to 1 do begin
        if ify + iy < h then
            sli := bm.original.Scanline[ify + iy]
          else
            sli := bm.original.Scanline[h - ify - iy];
        for ix := 0 to 1 do begin
           if ((ifx + ix) < w) then new := sli[ifx + ix]
            else new := sli[w - ifx - ix];

            weight := weight_x[ix] * weight_y[iy];
            total.rgbtRed   := round(total.rgbtRed   + new.rgbtRed   * weight);
            total.rgbtGreen := round(total.rgbtGreen + new.rgbtGreen * weight);
            total.rgbtBlue  := round(total.rgbtBlue  + new.rgbtBlue  * weight);
        end;
      end;
      AllScanLines[ty,tx]  := total;
    end;
  end;
temp.Assign(temp1);
repaint;
temp1.free;
working:=false;
end;

procedure TBM.Twist1Click(Sender: TObject);
begin
CopyUndobmp;
Screen.Cursor := crHourGlass;
TwistApply(100);
Screen.Cursor := crDefault;
original.Assign(temp);
if SndMenu.checked then MessageBeep(MB_ICONEXCLAMATION);
end;

{procedure TBM.RememberLastDir1Click(Sender: TObject);
begin
 RememberLastDir1.Checked := not RememberLastDir1.Checked;
end;  }

procedure TBM.Timer2Timer(Sender: TObject);
begin
repaint;
//tcan.Draw(0,0,bm.temp);
end;

(*
  procedure TBM.Mosaic1Click(Sender: TObject);
  begin
   CopyUndobmp;
   MosaicForm1.ShowModal;
   if MosaicForm1.ModalResult = mrOk then
   begin
    Application.ProcessMessages;
    original.Assign(temp);
   end
  else undo1click(self);
  end;
*)

//procedure TBM.SelectScanner1Click(Sender: TObject);  // 21-5-2000
//begin
// if not ImgScan1.ScannerAvailable then begin
//   MessageDlg(NOSCANNER, mtInformation,[mbOk], 0);
//   exit;
// end;
// try
//  ImgScan1.ShowSelectScanner;
// finally
// end;
//end;

//procedure TBM.AquireImage1Click(Sender: TObject);
//begin
//if ImgScan1.ScannerAvailable then
// try
// ImgScan1.OpenScanner;
// if not ShowScanOptions1.Checked then
//    ImgScan1.StartScan
// else
//    ImgScan1.ShowScanNew;
// Image.Picture.Graphic := nil;
// Image.Picture.Bitmap.LoadFromFile(ImgScan1.Image);
// ScannedImage1.Checked := true;
// Image.Enabled := true;
// Image.Visible:= true;
// Image.Stretch:= true;
// DeleteScannedImagefromMemory1.Enabled:= true;
// finally
//  ImgScan1.CloseScanner;
//  DeleteFile(ImgScan1.Image);
// end
// else
//   MessageDlg(NOSCANNER, mtInformation,[mbOk], 0);
//end;
//
//procedure TBM.ScannerPreferences1Click(Sender: TObject);
//begin
// if ImgScan1.ScannerAvailable then
//    ImgScan1.ShowScanPreferences
// else
//     MessageDlg(NOSCANNER, mtInformation,[mbOk], 0);
//end;
//
//procedure TBM.ShowScanOptions1Click(Sender: TObject);
//begin
// ShowScanOptions1.Checked := not ShowScanOptions1.Checked;
//end;
//
//procedure TBM.ScannedImage1Click(Sender: TObject);
//begin
//ScannedImage1.Checked := not ScannedImage1.Checked;
//if ScannedImage1.Checked then
//   begin
//    Image.Enabled := true;
//    Image.Visible:= true;
//    Image.Stretch:= true;
//   end
//else
//   begin
//    Image.Enabled := false;
//    Image.Visible:= false;
//    Image.Stretch:= false;
//   end;
//end;
//
//procedure TBM.SaveScannedImage1Click(Sender: TObject);
//var
//Bitmap1 : TBitmap;
//Jpg1 : TJPEGImage;
//Gifile1 : TGifImage;
////Png1 : TPngImage;
//FileExtS : String;
//label bailout;
//begin
// SaveDialog1.Title := s2;
// SaveDialog1.FilterIndex := 6;
// SaveDialog1.InitialDir := ScannedDirectory;
// Bitmap1 := TBitmap.Create;
// Bitmap1.PixelFormat := pf24bit;
// Bitmap1.Width := Image.Picture.Bitmap.Width;
// Bitmap1.Height := Image.Picture.Bitmap.Height;
// Bitmap1.Assign(Image.Picture.Bitmap);
// if SaveDialog1.Execute then
// begin
//   FileExtS := UpperCase(ExtractFileExt(SaveDialog1.Filename));
//   if FileExtS = FileX[feBMP] then
//    begin
//     Bitmap1.SaveTofile(SaveDialog1.Filename);
//     Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
//    end
//    else if FileExtS = FileX[feJPG] then
//      begin
//      Jpg1 := TJPEGImage.Create;
//      Jpg1.Assign(Bitmap1);
//      Jpg1.ProgressiveEncoding := jpgProgEncode;
//      Jpg1.CompressionQuality := jpgCmpQlt;
//        try
//        Jpg1.SaveToFile(SaveDialog1.Filename );
//        Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
//        finally
//        jpg1.Free;
//        end;
//      end
//      else if ((FileExtS = FileX[feTIF]) or (FileExtS = FileX[feTIFF])) then
//      begin
//       WriteTiffToFile (SaveDialog1.Filename, BitMap1);
//       Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
//      end
//      else if (FileExtS = FileX[feGIF]) then
//      begin
//        Gifile1 := TGifImage.Create;
//        SetGifOptions(Gifile1);
//        Gifile1.Assign(Bitmap1);
//        Gifile1.SaveToFile(SaveDialog1.Filename);
//        Caption := fcapt + ' [ ' + SaveDialog1.Filename + ' ]';
//        Gifile1.Free;
//      end
//    else begin
//          beep;
//          MessageDlg(NOGRAPHIC,mtError,[mbOk],0);
//          goto bailout;
//         end;
// end;
//bailout:
// Bitmap1.Free;
//end;
//
//procedure TBM.DeleteScannedImagefromMemory1Click(Sender: TObject);
//begin
//Image.Picture.Graphic := nil;
//Image.Enabled := false;
//Image.Visible:= false;
//ScannedImage1.Checked := false;
//Image.Stretch:= false;
//DeleteScannedImagefromMemory1.Enabled := false;
//end;

procedure TBM.SetFractalFinished1Click(Sender: TObject);
begin
 FractalCompleted := true;
end;

procedure TBM.Spider1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 31;
Spider1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[Spider];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := ComputeSpider;
AllFractals;
end;

procedure TBM.MandelFlower1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 32;
MandelFlower1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[MandelFlower];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := True;
Params1.RadioGroup1.Enabled := True;
Params1.OutsideCombo.Enabled := true;
StUpdate;
FractalProc := ComputeMandelFlower;
AllFractals;
end;

procedure TBM.Smiley1Click(Sender: TObject);
begin
CopyUndoBmp;
if FractalCompleted then clrscr;
clearchecked;
WhatFractal := 33;
Smiley1.Checked := True;
Cut1.Enabled := True;
Copy1.Enabled := True;
N2.Enabled := false;
SpecialFractalParameters1.Enabled:=false;
FractalName := Fractal[Smiley];
//Params1.Auto1.Checked := True;
Params1.ColoringMode.Enabled := FALSE; //True;
Params1.RadioGroup1.Enabled := FALSE; //True;
Params1.OutsideCombo.Enabled := FALSE; //true;
Drawface(2);

temp.Width := ClientWidth;
temp.Height := ClientHeight;
temp.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
original.Width := ClientWidth;
original.Height := ClientHeight;
original.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
StUpdate;
//FractalProc := ComputeTestFunction;
//AllFractals;
end;

procedure TBM.CustomFilterMenuClick(Sender: TObject);
begin
CopyUndobmp;
CusFilForm.showmodal;
if CusFilForm.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
 end
else undo1click(self);
end;

//**********************************************************************************
var
exjulx,exjuly : Extended;

procedure ContinuesJulia;
var
xn,yn,a,b: Extended;
i,sx,sy: Integer;
label
100,150,200,300,bailout;
begin
escpressed := False;
Working := True;
 stepx := 2*r / maxx;
 stepy := 2*r / maxy;
 rec := stepx+recen;
 imc := imcen;
 XMax := recen + r;
 XMin := recen - r;
 YMax := imcen - r;
 YMin := imcen + r;
 x1 := 0; y1 := 0;
 x2 := maxx; y2 := maxy;
A1:=x1; B1:=y1; C1:=x2; D1:=y2;

 color1 := clBlue; //Random( 16777215);
 xn := recen; //0.25;
 yn := imcen; //0;
 sx := maxx div 3;
 sy := maxy div 3;

//while contjul {((ContJul) and (not mousepressed) and (not escpressed))} do begin
  Application.ProcessMessages;
  if escpressed then
    begin
      working := false;
      escpressed:= False;
      ContJul := False;
      exit;
    end;
 if (exjulx <> Julx) or (exjuly <> July) then begin  BM.clrscr; {continue;} end;
 //BM.clrscr;
 rec := Julx; //stepx+recen;   // 17-5-98  Get Starting Parameters from mouse Position
 imc := July; //imcen;         // 17-5-98  On the Mandelbrot Set.
 exjulx := Julx;  exjuly := July;
 for i := 1 to 5000 do
 begin
   a := xn-rec;
   b := yn-imc;
   // compute sqr with re>=0
   if a > 0 then goto 100;
   if a < 0 then goto 150;
   xn := sqrt(abs(b)/2);
   if xn > 0 then yn := b/(2*xn)
   else yn:=0;
   goto 200;
100: xn := sqrt((sqrt(a*a+b*b)+a)/2);
     yn:= b/(2*xn);
     goto 200;
150: yn := sqrt((sqrt(a*a+b*b)-a)/2);
     if b < 0 then yn := -yn;
     xn := b/(2*yn);
     // first step is computation of repelling fixed point.
200: if i=1 then xn := xn + 0.5;
     // choose one of the two symmetric roots at random
     if random < 0.5 then goto 300;
     xn := -xn;
     yn := -yn;
300: BM.Canvas.Pixels[round(xn*sx)+halfx,round(yn*sy)+halfy] := pal[random(254)+1]; //color1;
end;
//end; //while
bailout:
working := false;
escpressed:= False;
//ContJul := False;
//MessageBeep(MB_ICONEXCLAMATION);
end;

(*
  procedure TBM.EdgeDetection1Click(Sender: TObject);
  begin
  copyundobmp;
  EdgeFilter1.showmodal;
  if EdgeFilter1.ModalResult = mrOk then
   begin
    Application.ProcessMessages;
    original.Assign(temp);
   end
  else undo1click(self);
  end;
*)

procedure TBM.Shift1Click(Sender: TObject);
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
CopyUndobmp;
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := RowRGB[x].rgbtRed shl 1;
        RowRGB[x].rgbtGreen := RowRGB[x].rgbtGreen shl 1;
        RowRGB[x].rgbtBlue  := RowRGB[x].rgbtBlue shl 1;
       end;
    end;
temp.Assign(temp1);
original.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.ShiftRight1Click(Sender: TObject);
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
CopyUndobmp;
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := RowRGB[x].rgbtRed shr 1;
        RowRGB[x].rgbtGreen := RowRGB[x].rgbtGreen shr 1;
        RowRGB[x].rgbtBlue  := RowRGB[x].rgbtBlue shr 1;
       end;
    end;
temp.Assign(temp1);
original.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.XorValClick(Sender: TObject);
begin
CopyUndobmp;
nfn := 0;
EnterVal.ShowModal;
if EnterVal.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
end
else undo1click(self);
end;

procedure TBM.XorApply;
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := RowRGB[x].rgbtRed xor value2;
        RowRGB[x].rgbtGreen := RowRGB[x].rgbtGreen xor value2;
        RowRGB[x].rgbtBlue  := RowRGB[x].rgbtBlue xor value2;
       end;
    end;
temp.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.OrApply;
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
//temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := RowRGB[x].rgbtRed or value2;
        RowRGB[x].rgbtGreen := RowRGB[x].rgbtGreen or value2;
        RowRGB[x].rgbtBlue  := RowRGB[x].rgbtBlue or value2;
       end;
    end;
temp.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.OrValue1Click(Sender: TObject);
begin
CopyUndobmp;
nfn := 1;
EnterVal.ShowModal;
if EnterVal.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
end
else undo1click(self);
end;

procedure TBM.AndValue1Click(Sender: TObject);
begin
CopyUndobmp;
nfn := 2;
EnterVal.ShowModal;
if EnterVal.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
end
else undo1click(self);
end;

procedure TBM.AndApply;
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := RowRGB[x].rgbtRed and value2;
        RowRGB[x].rgbtGreen := RowRGB[x].rgbtGreen and value2;
        RowRGB[x].rgbtBlue  := RowRGB[x].rgbtBlue and value2;
       end;
    end;
temp.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.AddValue1Click(Sender: TObject);
begin
CopyUndobmp;
nfn := 3;
EnterVal.ShowModal;
if EnterVal.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
end
else undo1click(self);
end;

procedure TBM.AddApply;
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := RowRGB[x].rgbtRed + value2;
        RowRGB[x].rgbtGreen := RowRGB[x].rgbtGreen + value2;
        RowRGB[x].rgbtBlue  := RowRGB[x].rgbtBlue + value2;
       end;
    end;
temp.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.SubtractValue1Click(Sender: TObject);
begin
CopyUndobmp;
nfn := 4;
EnterVal.ShowModal;
if EnterVal.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
end
else undo1click(self);
end;

procedure TBM.SubtractFromValue1Click(Sender: TObject);
begin
CopyUndobmp;
nfn := 5;
EnterVal.ShowModal;
if EnterVal.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
end
else undo1click(self);
end;

procedure TBM.SubtractValApply;
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := RowRGB[x].rgbtRed - value2;
        RowRGB[x].rgbtGreen := RowRGB[x].rgbtGreen - value2;
        RowRGB[x].rgbtBlue  := RowRGB[x].rgbtBlue - value2;
       end;
    end;
temp.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.SubtractFromValApply;
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := original.width;
temp1.Height := original.height;
temp1.Assign(original);
temp1.Canvas.Pixels[0,0] := original.Canvas.pixels[0,0];

   for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   := value2 - RowRGB[x].rgbtRed;
        RowRGB[x].rgbtGreen := value2 - RowRGB[x].rgbtGreen;
        RowRGB[x].rgbtBlue  := value2 - RowRGB[x].rgbtBlue;
       end;
    end;
temp.Assign(temp1);
Repaint;
temp1.free;
end;

procedure TBM.DrawFace({bm : TBitmap;} pen_width : Integer);
var
    x1, y1, x2, y2, x3, y3, x4, y4 : Integer;
    old_width                      : Integer;
    old_color                      : TColor;
begin
 with bm.canvas do begin
    // Save the original brush color and pen width.
    old_width := Pen.Width;
    old_color := Brush.Color;

    // Draw the head.
    Pen.Width := pen_width;
    Brush.Color := clYellow;
    x1 := Round(bm.clientWidth * 0.05);
    y1 := x1;
    x2 := Round(bm.clientHeight * 0.95);
    y2 := x2;
    Ellipse(x1, y1, x2, y2);

    // Draw the eyes.
    Brush.Color := clWhite;
    x1 := Round(bm.Width * 0.25);
    y1 := Round(bm.Height * 0.25);
    x2 := Round(bm.Width * 0.4);
    y2 := Round(bm.Height * 0.4);
    Ellipse(x1, y1, x2, y2);
    x1 := Round(bm.Width * 0.75);
    x2 := Round(bm.Width * 0.6);
    Ellipse(x1, y1, x2, y2);

    // Draw the pupils.
    Brush.Color := clBlack;
   // Refresh;
    x1 := Round(bm.Width * 0.275);
    y1 := Round(bm.Height * 0.3);
    x2 := Round(bm.Width * 0.375);
    y2 := Round(bm.Height * 0.4);
    Ellipse(x1, y1, x2, y2);
    x1 := Round(bm.Width * 0.725);
    x2 := Round(bm.Width * 0.625);
    Ellipse(x1, y1, x2, y2);

    // Draw the nose.
    Brush.Color := clAqua;
    x1 := Round(bm.Width * 0.425);
    y1 := Round(bm.Height * 0.425);
    x2 := Round(bm.Width * 0.575);
    y2 := Round(bm.Height * 0.6);
    Ellipse(x1, y1, x2, y2);

    // Draw a crooked smile.
    x1 := Round(bm.Width * 0.25);
    y1 := Round(bm.Height * 0.25);
    x2 := Round(bm.Width * 0.75);
    y2 := Round(bm.Height * 0.75);
    x3 := Round(bm.Width * 0.4);
    y3 := Round(bm.Height * 0.6);
    x4 := Round(bm.Width * 0.8);
    y4 := Round(bm.Height * 0.6);
    Arc(x1, y1, x2, y2, x3, y3, x4, y4);

    Brush.Color := old_color;
    Pen.Width := old_width;
  end; // with
end;

procedure TBM.Threshold1Click(Sender: TObject);
begin
CopyUndobmp;
ThresholdForm.ShowModal;
if ThresholdForm.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
end
else undo1click(self);
end;

(*
  procedure TBM.ExChRGBClick(Sender: TObject);
  begin
  CopyUndobmp;
  ExChangeForm.ShowModal;
  if ExChangeForm.ModalResult = mrOk then
   begin
    Application.ProcessMessages;
    original.Assign(temp);
  end
  else undo1click(self);
  end;
*)

procedure TBM.ApplyFishEye(Amount:Extended);
var
xmid,ymid,
fx,fy,r1,r2,dx,dy,
rmax,weight            : Extended;
total,new              : TRGBTriple;
weight_x, weight_y     : array[0..1] of Extended;
ifx, ify               : integer;
ty, tx,w,h             : Integer;
ix, iy                 : Integer;
sli                    : pRGBArray;
temp1                  : TBitmap;
AllScanLines: array[0..800] of pRGBArray;
begin
if Amount = 0 then exit;
temp1 := TBitmap.Create;
temp1.Width  := original.Width;
temp1.Height := original.Height;
temp1.Assign(original);

  w:= temp1.width;
  h:= temp1.height;
  xmid := w/2;
  ymid := h/2;
  rmax := w * Amount;

for ix:=0 to h-1 do
    AllScanLines[ix] := temp1.scanline[ix];

  for ty := 0 to h -1 do begin
    for tx := 0 to w - 1 do begin
      dx := tx - xmid;
      dy := ty - ymid;
      r1 := Sqrt(dx * dx + dy* dy);
      if r1 = 0 then begin
        fx := xmid;
        fy := ymid;
      end
      else begin
        r2 := rmax / 2 * (1 / (1 - r1/rmax) - 1);
        fx := dx * r2 / r1 + xmid;
        fy := dy * r2 / r1 + ymid;
      end;
      ify := Trunc(fy);
      ifx := Trunc(fx);
                // Calculate the weights.
      if fy >= 0  then begin
        weight_y[1] := fy - ify;
        weight_y[0] := 1 - weight_y[1];
      end else begin
        weight_y[0] := -(fy - ify);
        weight_y[1] := 1 - weight_y[0];
      end;
      if fx >= 0 then begin
        weight_x[1] := fx - ifx;
        weight_x[0] := 1 - weight_x[1];
      end else begin
        weight_x[0] := -(fx - ifx);
        Weight_x[1] := 1 - weight_x[0];
      end;

      if ifx < 0 then
        ifx := w-1-(-ifx mod w)
      else if ifx > w-1  then
        ifx := ifx mod w;
      if ify < 0 then
        ify := h-1-(-ify mod h)
      else if ify > h-1 then
        ify := ify mod h;

      total:=zero;
      for iy := 0 to 1 do begin
         if ((ify + iy) < h) then sli := bm.original.Scanline[ify + iy]
          else sli := bm.original.Scanline[h - ify - iy];
         for ix := 0 to 1 do begin
            if ((ifx + ix) < w) then new := sli[ifx + ix]
            else new := sli[w - ifx - ix];

            weight := weight_x[ix] * weight_y[iy];
            total.rgbtRed   := round(total.rgbtRed   + new.rgbtRed   * weight);
            total.rgbtGreen := round(total.rgbtGreen + new.rgbtGreen * weight);
            total.rgbtBlue  := round(total.rgbtBlue  + new.rgbtBlue  * weight);
        end;
      end;
      AllScanLines[ty,tx]  := total;
    end;
  end;
temp.Assign(temp1);
repaint;
temp1.free;
end;

procedure TBM.FishEye1Click(Sender: TObject);
begin
copyundobmp;
Screen.Cursor := crHourGlass;
ApplyFishEye(1);
Screen.Cursor := crDefault;
original.Assign(temp);
end;

procedure TBM.ApplyEmboss;
var
x,y,i   : Integer;
line2 : pRGBArray;
temp1 : TBitmap;
AllScanLines : array[0..800] of pRGBArray;
begin
temp1 := TBitmap.Create;
temp1.Width  := original.Width;
temp1.Height := original.Height;
temp1.Assign(original);
for x:= 0 to temp1.Height do
    AllScanLines[x]:= temp1.ScanLine[x];
i:=3;
  for y:=0 to temp1.Height-1 do
  begin
    line2 := original.scanline[y+i];
    for x:=0 to temp1.Width-1 do
    begin
     AllScanLines[y,x].rgbtBlue  := (AllScanLines[y,x].rgbtBlue   + (line2[x].rgbtBlue  xor $ff)) shr 1;
     AllScanLines[y,x].rgbtGreen := (AllScanLines[y,x].rgbtGreen  + (line2[x].rgbtGreen xor $ff)) shr 1;
     AllScanLines[y,x].rgbtRed   := (AllScanLines[y,x].rgbtRed    + (line2[x].rgbtRed   xor $ff)) shr 1;
     if (y >= (temp1.Height-4)) then  i:=0;
    end;
  end;
temp.Assign(temp1);
repaint;
temp1.free;
end;

(*
  procedure TBM.Emboss1Click(Sender: TObject);
  begin
  copyundobmp;
  ApplyEmboss;
  original.Assign(temp);
  end;
*)

procedure TBM.Deform1Click(Sender: TObject);
begin
copyundobmp;
DeformFrm.ShowModal;
if DeformFrm.modalResult = mrok then
  begin
  Application.ProcessMessages;
  original.assign(temp);
  end
  else undo1click(self);
end;

procedure TBM.AddMonoNoise1Click(Sender: TObject);
begin
CopyUndobmp;
MonoNoiseForm.ShowModal;
if MonoNoiseForm.ModalResult = mrOk then
 begin
  Application.ProcessMessages;
  original.Assign(temp);
 end
else undo1click(self);
end;

procedure SplitBlur(Amount:Integer);
var
Line1,Line2 : pRGBArray;
cx,x,y,w,h  : Integer;
Buf         : array[0..3]of TRGBTriple;
Temp1: TBitmap;
begin

temp1 := TBitmap.Create;
temp1.Width := BM.original.width;
temp1.Height := BM.original.height;
temp1.Assign(bm.original);
w:= temp1.Width;
h:= temp1.Height;
    for y:=0 to h-1 do
    begin
      Line1:= temp1.Scanline[TrimInt(y+Amount,0,h-1)];
      Line2:= temp1.Scanline[TrimInt(y-Amount,0,h-1)];
      for x:=0 to w-1 do
      begin
        cx:=TrimInt(x+Amount,0,w-1);
        Buf[0]:=Line1[cx];
        Buf[1]:=Line2[cx];
        cx:=TrimInt(x-Amount,0,w-1);
        Buf[2]:=Line1[cx];
        Buf[3]:=Line2[cx];
        Line1[x].rgbtBlue  := (Buf[0].rgbtBlue+Buf[1].rgbtBlue+Buf[2].rgbtBlue+Buf[3].rgbtBlue)shr 2;
        Line1[x].rgbtGreen := (Buf[0].rgbtGreen+Buf[1].rgbtGreen+Buf[2].rgbtGreen+Buf[3].rgbtGreen)shr 2;
        Line1[x].rgbtRed   := (Buf[0].rgbtRed+Buf[1].rgbtRed+Buf[2].rgbtRed+Buf[3].rgbtRed)shr 2;
      end;
    end;
bm.temp.assign(temp1);
bm.repaint;
temp1.free;
end;

procedure TBM.GaussianBlur1Click(Sender: TObject);
begin
CopyUndobmp;
SplitBlur(1);
original.Assign(temp);
end;

procedure TBM.SetProperty1(val: Integer);
begin
end;

end.
