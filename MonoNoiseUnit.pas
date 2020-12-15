unit MonoNoiseUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMonoNoiseForm = class(TForm)
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
  procedure AddMonoNoise(Amount:Integer);
    { Public declarations }
  end;

var
  MonoNoiseForm: TMonoNoiseForm;
  inprogress: boolean;

implementation

uses Main;

{$R *.DFM}

procedure TMonoNoiseForm.AddMonoNoise(Amount:Integer);
var
//x,y,a: Integer;
//pc:    PFColor;
//pb:    PByte;
x,y,a: Integer;
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
        a:=Random(Amount)-(Amount shr 1);
        RowRGB[x].rgbtRed   :=  IntToByte(RowRGB[x].rgbtRed+a);
        RowRGB[x].rgbtGreen :=  IntToByte(RowRGB[x].rgbtGreen+a);
        RowRGB[x].rgbtBlue  :=  IntToByte(RowRGB[x].rgbtBlue+a);
       end;
    end;
BM.temp.Assign(temp1);
BM.Repaint;
temp1.free;
end;


procedure TMonoNoiseForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
if not inprogress then begin
inprogress := true;
AddMonoNoise(scrollbar1.position);
inprogress := false;
end;
end;

end.
