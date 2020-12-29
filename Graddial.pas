unit GradDial;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  This File is part of the EliFrac Project
//****************************************************************************************
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TgradformBack = class(TForm)
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Label2: TLabel;
    Label3: TLabel;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    Button3: TButton;
    Button4: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure PaintBox1DblClick(Sender: TObject);
    procedure PaintBox2DblClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
gradformBack: TgradformBack;

implementation

uses Main,Gradient;
{$R *.DFM}


procedure TgradformBack.FormClose(Sender: TObject; var Action: TCloseAction);
begin
case RadioGroup1.ItemIndex of
  0 : Direction := fdTopToBottom;
  1 : Direction := fdBottomToTop;
  2 : Direction := fdLeftToRight;
  3 : Direction := fdRightToLeft;
end;
Action := caFree;
end;

procedure TgradformBack.FormPaint(Sender: TObject);
begin
 with PaintBox1.Canvas do
  begin
   Brush.Color := BeginColor;
   Rectangle(0,0,Width,Height);
  end;
 with PaintBox2.Canvas do
  begin
   Brush.Color := EndColor;
   Rectangle(0,0,Width,Height);
  end;
end;

procedure TgradformBack.PaintBox1DblClick(Sender: TObject);
begin
If BM.ColorDialog1.Execute then
   begin
     BeginColor := BM.ColorDialog1.Color;
     with PaintBox1.Canvas do
       begin
       Brush.Color := BeginColor;
       Rectangle(0,0,Width,Height);
       end;
   end;
end;

procedure TgradformBack.PaintBox2DblClick(Sender: TObject);
begin
If BM.ColorDialog1.Execute then
   begin
     EndColor := BM.ColorDialog1.Color;
     with PaintBox2.Canvas do
       begin
       Brush.Color := EndColor;
       Rectangle(0,0,Width,Height);
     end;
   end;
end;

end.
