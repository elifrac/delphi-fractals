unit ExChangeRGBUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TExChangeForm = class(TForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
  procedure TestApply;
    { Public declarations }
  end;

var
  ExChangeForm: TExChangeForm;
  itin: integer;
implementation

uses Main;

{$R *.DFM}

procedure TExChangeForm.TestApply;
var
i,j: Integer;
a,b : Integer;
AllScanLines : array[0..800] of pRGBArray;
dummy: TRGBTriple;
temp1: TBitmap;
begin
temp1 := Tbitmap.Create;
temp1.Width := bm.original.width;
temp1.Height := bm.original.height;
temp1.Assign(bm.original);
for j:= 0 to temp1.Height do
    AllScanLines[j]:= temp1.ScanLine[j];

   for j:= 1 to temp1.Height-1 do
      begin
      if itin = 3 then break;
       for i:= 1 to temp1.Width-1 do
       begin
        for a:= -1 to 1 do
         for b:=-1 to 1 do
          begin
           case itin of
            0: begin
                 dummy.rgbtRed := AllScanLines[j+a,i+b].rgbtRed;
                 AllScanLines[j+a,i+b].rgbtRed := AllScanLines[j+a,i+b].rgbtGreen;
                 AllScanLines[j+a,i+b].rgbtGreen := dummy.rgbtRed;
               end;
            1: begin
                 dummy.rgbtRed := AllScanLines[j+a,i+b].rgbtRed;
                 AllScanLines[j+a,i+b].rgbtRed := AllScanLines[j+a,i+b].rgbtBlue;
                 AllScanLines[j+a,i+b].rgbtBlue := dummy.rgbtRed;
               end;
            2: begin
                 dummy.rgbtBlue := AllScanLines[j+a,i+b].rgbtBlue;
                 AllScanLines[j+a,i+b].rgbtBlue := AllScanLines[j+a,i+b].rgbtGreen;
                 AllScanLines[j+a,i+b].rgbtGreen := dummy.rgbtBlue;  
               end;
            3: ;
           end; // case
          end;  // for b and a loops
        end; // i loop
    end; // j loop
with bm do begin
temp.Assign(temp1);
Repaint;
end;
temp1.free;
end;

procedure TExChangeForm.FormShow(Sender: TObject);
begin
itin := Radiogroup1.ItemIndex;
TestApply;
end;

procedure TExChangeForm.RadioGroup1Click(Sender: TObject);
begin
itin := Radiogroup1.ItemIndex;
TestApply;
end;

end.
