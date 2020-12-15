unit TwistUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TTwistForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label5: TLabel;
    TrackBar2: TTrackBar;
    procedure TrackBar2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   procedure TwistApply(Amount:integer);
  end;

var
  TwistForm1: TTwistForm1;
  am: integer;
  working : boolean;
implementation

uses math,Main;

{$R *.DFM}

procedure TTwistForm1.TrackBar2Change(Sender: TObject);
begin
{am := trackbar2.position;
label5.caption := inttostr(am);
Application.ProcessMessages;
if not working then TwistApply(am);
Application.ProcessMessages;  }
end;

procedure TTwistForm1.FormShow(Sender: TObject);
begin
{trackbar2.position := 0;
am := 0;
label5.caption := inttostr(am);
working := false;   }
end;

procedure TTwistForm1.TwistApply(Amount:integer);
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

begin
if working then exit;
//if Amount =0 then begin
//bm.temp.Assign(bm.original);
//bm.repaint;
//exit;
//end;

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
bm.temp.Assign(temp1);
bm.repaint;
temp1.free;
working:=false;
end;

end.
