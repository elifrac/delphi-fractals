unit Deform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin;

type
  TDeformFrm = class(TForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
  procedure Prev;
  function mags(X,Y : Integer) : Integer;
  function magsTan(X,Y : Integer) : Integer;
    { Public declarations }
  end;

var
  DeformFrm: TDeformFrm;
  wx,hy,w,h: integer;
implementation

uses Main,math;

{$R *.DFM}

procedure TDeformFrm.RadioGroup1Click(Sender: TObject);
begin
Prev;
end;

function TDeformFrm.mags(X,Y : Integer) : Integer;
var
row,col,t : Integer;
begin
  col := sqr(wx-X);
  row := sqr(hy-Y);
  t := round(sqrt(col+row)) +wx;
  if ((t<w) and (t<h))  then mags := t
  else mags:=0;
end;

function TDeformFrm.magsTan(X,Y : Integer) : Integer;
var
row,col,t : Integer;

begin
  col := sqr(wx-round(tan(Y)));
  row := sqr(hy+round(tan(X)));
  t := round(sqrt(col+row));
  if ((t<w) and (t<h))  then magsTan := t
  else magsTan:=0;
end;

procedure TDeformFrm.Prev;
var
i,j,tm,t,t1: Integer;
AllScanLines: array[0..800] of pRGBArray;
temp1 : TBitmap;

begin
temp1 := TBitmap.Create;
temp1.Width  := bm.original.Width;
temp1.Height := bm.original.Height;
temp1.assign(bm.original);

w:= temp1.Width;
h:= temp1.Height;
wx:= w div 2;
hy:= h div 2;

for i:=0 to h do
    AllScanLines[i] := temp1.scanline[i];

 for i:= 0 to w-1 do
  begin
  for j:= 0 to h-1 do
   begin

    case RadioGroup1.ItemIndex of
     0 : begin
          tm := mags(i,j);
          AllScanLines[j,i]  := AllScanLines[tm,tm];
         end;
     1 : begin
         tm := mags(i,j);
         t:=tm-j;
         if ((t)>h) then t := h;
         AllScanLines[j,i]  := AllScanLines[tm,t];
         end;
     2 : begin
         tm := mags(i,j);
         t:=tm-i;
         if ((t)>h) then t := h;
         AllScanLines[j,i]  := AllScanLines[tm,t];
         end;
     3 : begin
          tm := mags(i,j);
          t:=tm-i;
         if ((t)>w) then t := w
         else if(t<0)then t:=0;
          AllScanLines[j,i]  := AllScanLines[t,tm];
         end;
     4 : begin
          tm := mags(i,j);
          t:=tm-j;
         if ((t)>w) then t := w
          else if(t<0)then t:=0;
          AllScanLines[j,i]  := AllScanLines[t,tm];
         end;
     5 : begin
         tm := mags(i,j);
         t:=tm-j;
         if ((t)>h) then t := h
          else if(t<0)then t:=0;
         t1:=tm-i;
         if ((t1)>w) then t1 := w
          else if(t1<0)then t1:=0;
         AllScanLines[j,i]  := AllScanLines[t1,t];
         end;
     6 : begin
         tm := mags(i,j);
         AllScanLines[j,i]  := AllScanLines[tm,i];
         end;
     7 : begin
          tm := mags(i,j);
          AllScanLines[j,i]  := AllScanLines[tm,j];
         end;
     8 : begin
          tm := mags(i,j);
          t:=tm-j+i;
          if ((t)>h) then t := h
          else if(t<0)then t:=0;
          AllScanLines[j,i]  := AllScanLines[tm,t];
         end;
     9 : begin
          tm := mags(i,j);
          t:=tm-i+j-(wx div 5);
          if ((t)>h) then t := h
          else if(t<0)then t:=0;
         t1:= tm-j+i-(wx div 5);
         if ((t1)>w) then t1 := w
          else if(t1<0)then t1:=0;
          AllScanLines[j,i]  := AllScanLines[t,t1];
         end;
    10 : begin
          tm := mags(i,j);
          t:=tm-j;
          if ((t)>w) then t := w
          else if(t<0)then t:=0;
          AllScanLines[j,i]  := AllScanLines[t,i];
         end;
    11 : begin
          tm := mags(i,j);
          t:=tm-j;
          if ((t)>w) then t := w
          else if(t<0)then t:=0;
          AllScanLines[j,i]  := AllScanLines[t,j];
         end;
    12 : begin
          tm := mags(i,j);
          t:=tm-j;
          if ((t)>w) then t := w
          else if(t<0)then t:=0;
          t1:=tm-i;
          if ((t1)>h) then t1 := h
          else if(t1<0)then t1:=0;
          AllScanLines[j,i]  := AllScanLines[t,t1];
         end;
    13 : begin
          tm := mags(i,j);
          t:= tm-(i div 4);
          if ((t)>h) then t := h
          else if(t<0)then t:=0;
         t1:= tm-(j div 4);
         if ((t1)>w) then t1 := w
          else if(t1<0)then t1:=0;
          AllScanLines[j,i]  := AllScanLines[t1,t];
         end;
    14 : begin
         tm := magsTan(i,j);
         t:= tm-(j div 2);
          if ((t)>h) then t := h
          else if(t<0)then t:=0;
         t1:= tm-(i div 2);
         if ((t1)>w) then t1 := w
          else if(t1<0)then t1:=0;
         AllScanLines[j,i]  := AllScanLines[t1,t];
         end;
    15 : begin
          tm := magsTan(i,j);
           t:= tm-i+(i div 2);
          if ((t)>h) then t := h
          else if(t<0)then t:=0;
         t1:= tm-j+(j div 2);
         if ((t1)>w) then t1 := w
          else if(t1<0)then t1:=0;
          AllScanLines[j,i]  := AllScanLines[t1,t];
         end;
    end;
   end;  // for j loop
  end;  // for i loop

bm.temp.Assign(temp1);
bm.repaint;
temp1.free;
end;

procedure TDeformFrm.FormShow(Sender: TObject);
begin
RadioGroup1.ItemIndex := 0;
Prev;
end;

end.
