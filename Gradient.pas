unit Gradient;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//****************************************************************************************
interface
uses
  SysUtils,Windows,Graphics;

type
TFillDirection = (fdTopToBottom, fdBottomToTop, fdLeftToRight, fdRightToLeft);

procedure GradientFill;

var
Direction: TFillDirection;
NumberOfColors : Integer = 255;
BeginColor: TColor = clBlue;
EndColor: TColor = clBlack;

implementation
uses Main;

procedure GradientFill;
var
  { Set up working variables }
  BeginRGBValue  : array[0..2] of Byte;    { Begin RGB values }
  RGBDifference  : array[0..2] of integer; { Difference between begin and end }
                                           { RGB values                       }
  ColorBand : TRect;    { Color band rectangular coordinates }
  I         : Integer;  { Color band index }
  R         : Integer;     { Color band Red value }
  G         : Integer;     { Color band Green value }
  B         : Integer;     { Color band Blue value }
  WorkBmp   : TBitmap;  { Off screen working bitmap }
begin
{ Create the working bitmap and set its width and height }
WorkBmp := TBitmap.Create;
WorkBmp.Width := BM.temp.Width;
WorkBmp.Height := BM.temp.Height;

{ Use working bitmap to draw the gradient }
with WorkBmp do
begin
  { Extract the begin RGB values }
  case Direction of

    { If direction is set to TopToBottom or LeftToRight }
    fdTopToBottom, fdLeftToRight:
      begin
        { Set the Red, Green and Blue colors }
        BeginRGBValue[0] := GetRValue (ColorToRGB (BeginColor));
        BeginRGBValue[1] := GetGValue (ColorToRGB (BeginColor));
        BeginRGBValue[2] := GetBValue (ColorToRGB (BeginColor));
        { Calculate the difference between begin and end RGB values }
        RGBDifference[0] := GetRValue (ColorToRGB (EndColor)) -
                            BeginRGBValue[0];
        RGBDifference[1] := GetGValue (ColorToRGB (EndColor)) -
                            BeginRGBValue[1];
        RGBDifference[2] := GetBValue (ColorToRGB (EndColor)) -
                            BeginRGBValue[2];
      end;

    { If direction is set to BottomToTop or RightToLeft}
    fdBottomToTop, fdRightToLeft:
      begin
        { Set the Red, Green and Blue colors }
        { Reverse of TopToBottom and LeftToRight directions }
        BeginRGBValue[0] := GetRValue (ColorToRGB (EndColor));
        BeginRGBValue[1] := GetGValue (ColorToRGB (EndColor));
        BeginRGBValue[2] := GetBValue (ColorToRGB (EndColor));
        { Calculate the difference between begin and end RGB values }
        { Reverse of TopToBottom and LeftToRight directions }
        RGBDifference[0] := GetRValue (ColorToRGB (BeginColor)) -
                            BeginRGBValue[0];
        RGBDifference[1] := GetGValue (ColorToRGB (BeginColor)) -
                            BeginRGBValue[1];
        RGBDifference[2] := GetBValue (ColorToRGB (BeginColor)) -
                            BeginRGBValue[2];
      end;
  end;

  { Set the pen style and mode }
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Mode := pmCopy;

  case Direction of

    { Calculate the color band's top and bottom coordinates }
    { for TopToBottom and BottomToTop fills }
    fdTopToBottom, fdBottomToTop:
      begin
        ColorBand.Left := 0;
        ColorBand.Right := Width;
      end;

    { Calculate the color band's left and right coordinates }
    { for LeftToRight and RightToLeft fills }
    fdLeftToRight, fdRightToLeft:
      begin
        ColorBand.Top := 0;
        ColorBand.Bottom := Height;
      end;
  end;

  { Perform the fill }
  for I := 0 to NumberOfColors do
    begin
    case Direction of

      { Calculate the color band's top and bottom coordinates }
      fdTopToBottom, fdBottomToTop:
        begin
          ColorBand.Top    := MulDiv (I    , Height, NumberOfColors);
          ColorBand.Bottom := MulDiv (I + 1, Height, NumberOfColors);
        end;

      { Calculate the color band's left and right coordinates }
      fdLeftToRight, fdRightToLeft:
        begin
          ColorBand.Left  := MulDiv (I  , Width, NumberOfColors);
          ColorBand.Right := MulDiv (I + 1, Width, NumberOfColors);
        end;
    end;

    { Calculate the color band's color }
    if NumberOfColors > 1 then
    begin
      R := BeginRGBValue[0] + MulDiv (I, RGBDifference[0], NumberOfColors - 1);
      G := BeginRGBValue[1] + MulDiv (I, RGBDifference[1], NumberOfColors - 1);
      B := BeginRGBValue[2] + MulDiv (I, RGBDifference[2], NumberOfColors - 1);
    end
    else
    { Set to the Begin Color if set to only one color }
    begin
      R := BeginRGBValue[0];
      G := BeginRGBValue[1];
      B := BeginRGBValue[2];
    end;

    { Select the brush and paint the color band }
    Canvas.Brush.Color := RGB (R, G, B);
    Canvas.FillRect (ColorBand);
    end;
  end;

  { Copy the working bitmap to the main canvas }
  BM.Canvas.Draw(0, 0, WorkBmp);

  { Release the working bitmap resources }
  WorkBmp.Free;
end;


end.
