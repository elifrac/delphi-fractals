unit EDAmnt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TSprayForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   procedure Spray(Amount:Integer);
  end;

var
  SprayForm: TSprayForm;

implementation

uses Main;

{$R *.DFM}

procedure TSprayForm.TrackBar1Change(Sender: TObject);
begin
 spray(trackbar1.position);
end;

procedure TSprayForm.Spray(Amount:Integer);
var
r,x,y,cl: Integer;
temp1 : TBitmap;
RowRGB   :  pRGBArray;
begin
Screen.Cursor := crHourGlass;
 temp1 := TBitmap.Create;
 temp1.PixelFormat := pf24bit;
 temp1.Width := bm.original.width;
 temp1.Height := bm.original.height;

 for y:= 0 to temp1.Height-1 do
 begin
   RowRGB  := temp1.ScanLine[y];
   for x:= 0 to temp1.Width-1 do
    begin
     r:=Random(Amount);
     cl := original.Canvas.Pixels[TrimInt(x+(r-Random(r*2)),0,temp1.Width-1),
                                  TrimInt(y+(r-Random(r*2)),0,temp1.Height-1)];
     RowRGB[x].rgbtRed   :=  getRValue(cl);
     RowRGB[x].rgbtGreen := getGValue(cl);
     RowRGB[x].rgbtBlue  := getBValue(cl);
    end;
  end;
temp.Assign(temp1);
//original.Assign(temp1);
temp1.free;
Application.ProcessMessages;
bm.Repaint;
Application.ProcessMessages;
Screen.Cursor := crDefault;
end;

end.
