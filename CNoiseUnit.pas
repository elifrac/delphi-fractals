unit CNoiseUnit;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TCNoiseForm = class(TForm)
    ScrollBar1: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddColorNoise(Amount:Integer);
  end;

var
  CNoiseForm: TCNoiseForm;
  inprogress : boolean;
implementation

uses Main;

{$R *.DFM}

procedure TCNoiseForm.AddColorNoise(Amount:Integer);
var
x,y: Integer;
RowRGB : pRGBArray;
temp1: TBitmap;
begin
temp1 := TBitmap.Create;
temp1.Width := BM.original.width;
temp1.Height := BM.original.height;
temp1.Assign(bm.original);
     for y:= 0 to temp1.Height-1 do
      begin
       RowRGB  := temp1.ScanLine[y];
       for x:= 0 to temp1.Width-1 do
       begin
        RowRGB[x].rgbtRed   :=  IntToByte(RowRGB[x].rgbtRed+(Random(Amount)-(Amount shr 1)));
        RowRGB[x].rgbtGreen :=  IntToByte(RowRGB[x].rgbtGreen+(Random(Amount)-(Amount shr 1)));
        RowRGB[x].rgbtBlue  :=  IntToByte(RowRGB[x].rgbtBlue+(Random(Amount)-(Amount shr 1)));
       end;
    end;
BM.temp.Assign(temp1);
BM.Repaint;
temp1.free;
end;

procedure TCNoiseForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
if not inprogress then begin
inprogress := true;
AddColorNoise(scrollbar1.position);
inprogress := false;
end;
end;

end.
