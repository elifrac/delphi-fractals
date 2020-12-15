unit Polygon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls;

type
  TPolygon = class(TGraphicControl)
  private
    FImage:TBitmap;
    FEnabled:Boolean;
    FInterval:Integer;
    FTimer:TTimer;
    FLineColor:TColor;
    FBackColor:TColor;
    FPoints:Array[1..5] Of TPoint;
    FStep:Array[1..4] Of TPoint;
    Procedure ChangeState(State:Boolean);
    Procedure SetInterval(WaitTime:Integer);
    Procedure TimesUp(Sender:TObject);
    Procedure SetLineColor(SetColor:TColor);
    Procedure SetBackColor(BackColor:TColor);
    Procedure PaintBackground;
  protected
    Procedure Paint; Override;
  public
    Constructor Create(AOwner:TComponent); Override;
    Destructor Destroy; Override;
  published
    Property Enabled:Boolean Read FEnabled Write ChangeState Default False;
    Property Interval:Integer Read FInterval Write SetInterval Default 100;
    Property LineColor:TColor Read FLineColor Write SetLineColor Default clBlue;
    Property BackColor:TColor Read FBackColor Write SetBackColor Default clWhite;
  end;

procedure Register;

implementation

Constructor TPolygon.Create(AOwner:TComponent);
Var
  I:Byte;
Begin
  Inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csFramed,csOpaque];
  Randomize;
  {Startvärden}
    FEnabled:=False;
    FInterval:=100;
    FLineColor:=clBlue;
    FBackColor:=clWhite;
  {/Startvärden}
  Width:=50;
  Height:=50;
  FTimer:=TTimer.Create(Self);
  FTimer.Enabled:=False;
  FTimer.Interval:=100;
  FTimer.OnTimer:=TimesUp;
  For I:=1 To 4 Do Begin
    FPoints[I].X:=Random(Width-2)+1;
    FPoints[I].Y:=Random(Height-2)+1;
    FStep[I].X:=Random(11)-5;
    FStep[I].Y:=Random(11)-5;
  End;
  FPoints[5]:=FPoints[1];
  FImage:=TBitmap.Create;
End;

Destructor TPolygon.Destroy;
Begin
  FImage.Destroy;
  Inherited Destroy;
End;

procedure Register;
begin
  RegisterComponents('Additional', [TPolygon]);
end;

Procedure TPolygon.ChangeState(State:Boolean);
Begin
  FEnabled:=State;
  If FEnabled Then FTimer.Enabled:=True
  Else FTimer.Enabled:=False;
  Refresh;
End;

Procedure TPolygon.TimesUp(Sender:TObject);
Var
  I:Byte;
Begin
  If ComponentState=[csDesigning] Then Exit;
  For I:=1 To 4 Do Begin
    FPoints[I].X:=FPoints[I].X+FStep[I].X;
    FPoints[I].Y:=FPoints[I].Y+FStep[I].Y;
    If FPoints[I].X<0 Then Begin
      FStep[I].X:=Random(5)+1;
      FPoints[I].X:=1;
    End;
    If FPoints[I].Y<0 Then Begin
      FStep[I].Y:=Random(5)+1;
      FPoints[I].Y:=1;
    End;
    If FPoints[I].X>(Width-1) Then Begin
      FStep[I].X:=-(Random(5)+1);
      FPoints[I].X:=Width-2;
    End;
    If FPoints[I].Y>(Height-1) Then Begin
      FStep[I].Y:=-(Random(5)+1);
      FPoints[I].Y:=Height-2;
    End;
  End;
  FPoints[5]:=FPoints[1];
  Paint;
End;

 Procedure TPolygon.SetLineColor(SetColor:TColor);
 Begin
   If Not(SetColor=FLineColor) Then Begin
     FLineColor:=SetColor;
     Refresh;
   End;
 End;

 Procedure TPolygon.SetInterval(WaitTime:Integer);
 Begin
   FInterval:=WaitTime;
   FTimer.Interval:=WaitTime;
   Refresh;
 End;

Procedure TPolygon.PaintBackground;
Var
  R:TRect;
Begin
  With FImage.Canvas Do Begin
    Pen.Color:=clBlack;
    Brush.Color:=FBackColor;
    Rectangle(0,0,Width,Height);
  End;
End;

Procedure TPolygon.Paint;
Var
  R:TRect;
Begin
  If Not(FImage.Width=Width) Or Not(FImage.Height=Height) Then Begin
    FImage.Width:=Width;
    FImage.Height:=Height;
  End;
  PaintBackground;
  With FImage.Canvas Do Begin
    Pen.Color:=FLineColor;
    PolyLine(FPoints);
  End;
  R:=Rect(0,0,Width,Height);
  Canvas.CopyRect(R,FImage.Canvas,R);
End;

Procedure TPolygon.SetBackColor(BackColor:TColor);
Begin
 If Not(BackColor=FBackColor) Then Begin
   FBackColor:=BackColor;
   Refresh;
 End;
End;

end.
