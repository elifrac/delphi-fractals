unit EdgeDt;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin;

type
  TElFilter = array[0..2,0..2] of shortint;
  TEdgeFilter1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   procedure autoPrev;
   procedure EdgeApply(d : Integer ; filter : TElFilter );
  end;

const
EdgeMask1 : TElFilter = ((-1,0,-1),(0,4,0),(-1,0,-1));     // Edge Detection Mask       5  }
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
TraceContour   : TElFilter = ((1,1,1),(1,-9,1),(1,1,1));    // Trace Contour. Invert Image after filter  30

var
  EdgeFilter1: TEdgeFilter1;

implementation

uses Main;

{$R *.DFM}

procedure TEdgeFilter1.FormShow(Sender: TObject);
begin
If ((RadioGroup1.ItemIndex = 0) or (RadioGroup1.ItemIndex = 9)) then RadioGroup2.Enabled := False
else RadioGroup2.Enabled := True;
end;

procedure TEdgeFilter1.autoPrev;
begin
if RadioGroup2.Enabled then
case RadioGroup2.ItemIndex of
 0 : begin
      case RadioGroup1.ItemIndex of
       1 : begin whichfilter := 6; EdgeApply(1,TElFilter(EdgeKirschMask0));   end;  // East
       2 : begin whichfilter := 7; EdgeApply(1,TElFilter(EdgeKirschMask1));   end; // NE
       3 : begin whichfilter := 8; EdgeApply(1,TElFilter(EdgeKirschMask2));   end; // North
       4 : begin whichfilter := 9;  EdgeApply(1,TElFilter(EdgeKirschMask3));  end;  // NW
       5 : begin whichfilter := 10; EdgeApply(1,TElFilter(EdgeKirschMask4));  end;  // West
       6 : begin whichfilter := 11; EdgeApply(1,TElFilter(EdgeKirschMask5));  end;  // SW
       7 : begin whichfilter := 12; EdgeApply(1,TElFilter(EdgeKirschMask6));  end;  // South
       8 : begin whichfilter := 13; EdgeApply(1,TElFilter(EdgeKirschMask7));  end; // SE
      end;
     end;
 1 : begin
      case RadioGroup1.ItemIndex of
       1 : begin whichfilter := 14; EdgeApply(1,TElFilter(EdgePrewittMask0));  end;  // East
       2 : begin whichfilter := 15; EdgeApply(1,TElFilter(EdgePrewittMask1));  end; // NE
       3 : begin whichfilter := 16; EdgeApply(1,TElFilter(EdgePrewittMask2));  end; // North
       4 : begin whichfilter := 17; EdgeApply(1,TElFilter(EdgePrewittMask3)); end;  // NW
       5 : begin whichfilter := 18; EdgeApply(1,TElFilter(EdgePrewittMask4));  end;  // West
       6 : begin whichfilter := 29; EdgeApply(1,TElFilter(EdgePrewittMask5));  end;  // SW
       7 : begin whichfilter := 20; EdgeApply(1,TElFilter(EdgePrewittMask6));  end;  // South
       8 : begin whichfilter := 21; EdgeApply(1,TElFilter(EdgePrewittMask7));  end; // SE
      end;
     end;
 2 : begin
       case RadioGroup1.ItemIndex of
        1 : begin whichfilter := 22; EdgeApply(1,TElFilter(EdgeSobelMask0));  end;  // East
        2 : begin whichfilter := 23; EdgeApply(1,TElFilter(EdgeSobelMask1));  end; // NE
        3 : begin whichfilter := 24; EdgeApply(1,TElFilter(EdgeSobelMask2));  end; // North
        4 : begin whichfilter := 25; EdgeApply(1,TElFilter(EdgeSobelMask3));  end;  // NW
        5 : begin whichfilter := 26; EdgeApply(1,TElFilter(EdgeSobelMask4));  end;  // West
        6 : begin whichfilter := 27; EdgeApply(1,TElFilter(EdgeSobelMask5));  end;  // SW
        7 : begin whichfilter := 28; EdgeApply(1,TElFilter(EdgeSobelMask6));  end;  // South
        8 : begin whichfilter := 29; EdgeApply(1,TElFilter(EdgeSobelMask7));  end; // SE
       end;
     end;
end
else
 case  RadioGroup1.ItemIndex of
       0 : begin whichfilter := 5; EdgeApply(1,TElFilter(EdgeMask1)); end;  // All
       9 : begin
            whichfilter := 30;
            EdgeApply(1,TELFilter(TraceContour));
            PatBlt(bm.canvas.handle,0,0,bm.clientwidth,bm.clientheight,DSTINVERT);
            //bm.canvas.CopyMode := cmNotSrcCopy;
            //bm.Canvas.CopyRect(bm.ClientRect,bm.canvas,bm.ClientRect);
            //bm.canvas.CopyMode := cmSrcCopy;
           end; //Trace Contour
 end;
end;

procedure TEdgeFilter1.RadioGroup1Click(Sender: TObject);
begin
If ((RadioGroup1.ItemIndex = 0) or (RadioGroup1.ItemIndex = 9))then RadioGroup2.Enabled := False
else RadioGroup2.Enabled := True;
AutoPrev;
end;

procedure TEdgeFilter1.RadioGroup2Click(Sender: TObject);
begin
AutoPrev;
end;

procedure TEdgeFilter1.FormActivate(Sender: TObject);
begin
autoprev;
end;

procedure TEdgeFilter1.EdgeApply(d : Integer ; filter : TElFilter );
var
x,i,j,sumR,sumG,sumB: Integer;
a,b : Integer;
//RowRGB : pRGBArray;
AllScanLines : array[0..800] of pRGBArray;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := bm.original.width;
temp1.Height := bm.original.height;
temp1.Assign(bm.original);
for x:= 0 to temp1.Height do
    AllScanLines[x]:= temp1.ScanLine[x];

   for j:= 1 to temp1.Height-1 do
      begin
      // RowRGB  := AllScanLines[j];
       for i:= 1 to temp1.Width-1 do
       begin
        sumR := 0; sumG := 0; sumB := 0;
        for a:= -1 to 1 do
         for b:=-1 to 1 do
          begin
           case filter[a+1,b+1] of
             0 : ;
             1 : begin
                  sumR := sumR + AllScanLines[j+b,i+a].rgbtRed;
                  sumG := sumG + AllScanLines[j+b,i+a].rgbtGreen;
                  sumB := sumB + AllScanLines[j+b,i+a].rgbtBlue;
                 end;
              -1 : begin
                    sumR := sumR - AllScanLines[j+b,i+a].rgbtRed;
                    sumG := sumG - AllScanLines[j+b,i+a].rgbtGreen;
                    sumB := sumB - AllScanLines[j+b,i+a].rgbtBlue;
                   end;
             else  begin
                    sumR := sumR + AllScanLines[j+b,i+a].rgbtRed * filter[a+1,b+1];
                    sumG := sumG + AllScanLines[j+b,i+a].rgbtGreen * filter[a+1,b+1];
                    sumB := sumB + AllScanLines[j+b,i+a].rgbtBlue * filter[a+1,b+1];
                   end;
          end; // case
        end;  // for b and a loops
        if sumR < 0 then sumR := 0 else if sumR > $ff then sumR := $ff;
        if sumG < 0 then sumG := 0 else if sumG > $ff then sumG := $ff;
        if sumB < 0 then sumB := 0 else if sumB > $ff then sumB := $ff;

        AllScanLines[j-1,i-1].rgbtRed := sumR;
        AllScanLines[j-1,i-1].rgbtGreen := sumG;
        AllScanLines[j-1,i-1].rgbtBlue := sumB;
       end; // i loop
     //RowRGB := AllScanLines[j];
    end; // j loop
with bm do begin
temp.Assign(temp1);
//*************** Fix Edges *************************************************
PatBlt(temp.canvas.handle,0,temp.height-2,temp.width,temp.height,BLACKNESS);
PatBlt(temp.canvas.handle,temp.Width-2,0,temp.width,temp.height,BLACKNESS);
//***************************************************************************
Repaint;
end;
temp1.free;
end;

procedure TEdgeFilter1.Button1Click(Sender: TObject);
begin
hide; // hide the form first.
 if (whichfilter = 30)  then  // if trace contour
  autoprev;
end;

end.
