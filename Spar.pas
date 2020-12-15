unit SPar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TSParams = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SParams: TSParams;

implementation
uses Globs, Main; //Types;
{$R *.DFM}

procedure TSParams.FormShow(Sender: TObject);
begin
Label7.Caption := FractalName;
if (FractalName = Fractal[mandel])  then
  begin
   Edit1.Enabled := true;
   Edit2.Enabled := true;
   Edit3.Enabled := False;
   Edit4.Enabled := False;
   Edit1.Text := Format('%18.17f',[Xr]);
   Edit2.Text := Format('%18.17f',[Xim]);
  end
  else
if (FractalName = Fractal[juliaset]) then
  begin
   Edit1.Enabled := false;
   Edit2.Enabled := false;
   Edit3.Enabled := true;
   Edit4.Enabled := true;
   Edit3.Text := Format('%18.17f',[Yr]);    // 17-5-98
   Edit4.Text := Format('%18.17f',[Yim]);   // 17-5-98
  end
 else if (FractalName = Fractal[Lambda]) then
   begin
    Edit1.Enabled := false;
    Edit2.Enabled := false;
    Edit3.Enabled := true;
    Edit4.Enabled := true;
    Edit3.Text := Format('%18.17f',[LamdaR]);    // 19-4-99
    Edit4.Text := Format('%18.17f',[LamdaIm]);   // 19-4-99
   end
 else if (FractalName = Fractal[cosineset]) then
  begin
   Edit1.Enabled := true;
   Edit2.Enabled := true;
   Edit3.Enabled := False;
   Edit4.Enabled := False;
   Edit1.Text := Format('%18.17f',[CosXr]);     // 16-10-98
   Edit2.Text := Format('%18.17f',[CosXim]);    // 16-10-98
  end
  else if (FractalName = Fractal[sineset]) then
  begin
   Edit1.Enabled := true;
   Edit2.Enabled := true;
   Edit3.Enabled := False;
   Edit4.Enabled := False;
   Edit1.Text := Format('%18.17f',[SinXr]);     // 16-10-98
   Edit2.Text := Format('%18.17f',[SinXim]);    // 16-10-98
  end
  else  if (FractalName = Fractal[magnet1m]) then
  begin
   Edit1.Enabled := true;
   Edit2.Enabled := true;
   Edit3.Enabled := False;
   Edit4.Enabled := False;
   Edit1.Text := Format('%18.17f',[Xr]);
   Edit2.Text := Format('%18.17f',[Xim]);
   end
   else  if (FractalName = Fractal[barnsleyfractal3]) then
    begin
   Edit1.Enabled := false;
   Edit2.Enabled := false;
   Edit3.Enabled := true;
   Edit4.Enabled := true; //false;
   Edit3.Text := Format('%18.17f',[Br]);
   Edit4.Text := Format('%18.17f',[Bim]);
   end else if (FractalName = Fractal[TchebychevT3]) or
               (FractalName = Fractal[TchebychevT5]) or
               (FractalName = Fractal[TchebychevC6]) then
   begin
   Edit1.Enabled := true;
   Edit2.Enabled := true;
   Edit3.Enabled := False;
   Edit4.Enabled := False;
   Edit1.Text := Format('%18.17f',[T5r]);
   Edit2.Text := Format('%18.17f',[T5im]);
   end;
end;
procedure TSParams.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if (FractalName = Fractal[mandel]) then
  begin
   Xr  := StrToFloat(Edit1.Text);
   Xim := StrToFloat(Edit2.Text);
  end
  else  if (FractalName = Fractal[cosineset]) then
  begin
   CosXr  := StrToFloat(Edit1.Text);    //16-10-98
   CosXim := StrToFloat(Edit2.Text);    //16-10-98
  end
  else  if (FractalName = Fractal[sineset]) then
  begin
   SinXr  := StrToFloat(Edit1.Text);      //16-10-98
   SinXim := StrToFloat(Edit2.Text);      //16-10-98
  end
  else if (FractalName = Fractal[juliaset]) then
  begin
   Yr  := StrToFloat(Edit3.Text);
   Yim := StrToFloat(Edit4.Text);
  end
  else if (FractalName = Fractal[Lambda])  then
  begin
   LamdaR  := StrToFloat(Edit3.Text);
   LamdaIm := StrToFloat(Edit4.Text);
  end
  else  if (FractalName = Fractal[magnet1m]) then
           begin
            Xr  := StrToFloat(Edit1.Text);
            Xim := StrToFloat(Edit2.Text);
           end
 else if (FractalName = Fractal[barnsleyfractal3]) then
  begin
    Br := StrToFloat(Edit3.Text);
    BIm := StrToFloat(Edit4.Text);
 end else if (FractalName = Fractal[TchebychevT3]) or
             (FractalName = Fractal[TchebychevT5]) or
             (FractalName = Fractal[TchebychevC6]) then
       begin
        T5r  := StrToFloat(Edit1.Text);
        T5im := StrToFloat(Edit2.Text);
       end;

ComingFromZoom := false;
end;

end.
