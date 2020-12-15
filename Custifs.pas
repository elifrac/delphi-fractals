unit CustIfs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles,StdCtrls;

type
  TCustomIFSForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Button1: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label36: TLabel;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Button5: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EditAllExit(Sender: TObject);
  private
    { Private declarations }
  public
    procedure setIfsparams;
    { Public declarations }
  end;

var
CustomIFSForm: TCustomIFSForm;

procedure ReadIfsParams;


implementation
uses Globs, Main;
{$R *.DFM}

procedure TCustomIFSForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
setIfsparams;
Action := caHide;
end;

procedure TCustomIFSForm.setIfsparams;
begin
if Edit1.Text = EmptyStr then Edit1.Text := ZEROEX;
if Edit2.Text = EmptyStr then Edit2.Text := ZEROEX;
if Edit3.Text = EmptyStr then Edit3.Text := ZEROEX;
if Edit4.Text = EmptyStr then Edit4.Text := ZEROEX;

if Edit5.Text = EmptyStr then Edit5.Text := ZEROEX;
if Edit6.Text = EmptyStr then Edit6.Text := ZEROEX;
if Edit7.Text = EmptyStr then Edit7.Text := ZEROEX;
if Edit8.Text = EmptyStr then Edit8.Text := ZEROEX;

if Edit9.Text =  EmptyStr then Edit9.Text := ZEROEX;
if Edit10.Text = EmptyStr then Edit10.Text := ZEROEX;
if Edit11.Text = EmptyStr then Edit11.Text := ZEROEX;
if Edit12.Text = EmptyStr then Edit12.Text := ZEROEX;

if Edit13.Text = EmptyStr then Edit13.Text := ZEROEX;
if Edit14.Text = EmptyStr then Edit14.Text := ZEROEX;
if Edit15.Text = EmptyStr then Edit15.Text := ZEROEX;
if Edit16.Text = EmptyStr then Edit16.Text := ZEROEX;

if Edit17.Text = EmptyStr then Edit17.Text := ZEROEX;
if Edit18.Text = EmptyStr then Edit18.Text := ZEROEX;
if Edit19.Text = EmptyStr then Edit19.Text := ZEROEX;
if Edit20.Text = EmptyStr then Edit20.Text := ZEROEX;

if Edit21.Text = EmptyStr then Edit21.Text := ZEROEX;
if Edit22.Text = EmptyStr then Edit22.Text := ZEROEX;
if Edit23.Text = EmptyStr then Edit23.Text := ZEROEX;
if Edit24.Text = EmptyStr then Edit24.Text := ZEROEX;

if Edit25.Text = EmptyStr then Edit25.Text := ZEROEX;
if Edit26.Text = EmptyStr then Edit26.Text := ZEROEX;
if Edit27.Text = EmptyStr then Edit27.Text := ZEROEX;
if Edit28.Text = EmptyStr then Edit28.Text := ZEROEX;

if Edit29.Text = EmptyStr then Edit29.Text := ZEROEX;
if Edit30.Text = EmptyStr then Edit30.Text := ZEROEX;
if Edit31.Text = EmptyStr then Edit31.Text := ZEROEX;
if Edit32.Text = EmptyStr then Edit32.Text := ZEROEX;

if Edit33.Text = EmptyStr then Edit33.Text := ZEROEX;
if Edit34.Text = EmptyStr then Edit34.Text := ZEROEX;
if Edit35.Text = EmptyStr then Edit35.Text := ZEROEX;

a[0]:= StrToFloat(Edit1.Text);
a[1]:= StrToFloat(Edit2.Text);
a[2]:= StrToFloat(Edit3.Text);
a[3]:= StrToFloat(Edit4.Text);
a[4]:= StrToFloat(Edit29.Text);

b[0]:= StrToFloat(Edit5.Text);
b[1]:= StrToFloat(Edit6.Text);
b[2]:= StrToFloat(Edit7.Text);
b[3]:= StrToFloat(Edit8.Text);
b[4]:= StrToFloat(Edit30.Text);

cc[0]:= StrToFloat(Edit9.Text);
cc[1]:= StrToFloat(Edit10.Text);
cc[2]:= StrToFloat(Edit11.Text);
cc[3]:= StrToFloat(Edit12.Text);
cc[4]:= StrToFloat(Edit31.Text);

d[0]:= StrToFloat(Edit13.Text);
d[1]:= StrToFloat(Edit14.Text);
d[2]:= StrToFloat(Edit15.Text);
d[3]:= StrToFloat(Edit16.Text);
d[4]:= StrToFloat(Edit32.Text);

e[0]:= StrToFloat(Edit17.Text);
e[1]:= StrToFloat(Edit18.Text);
e[2]:= StrToFloat(Edit19.Text);
e[3]:= StrToFloat(Edit20.Text);
e[4]:= StrToFloat(Edit33.Text);

f[0]:= StrToFloat(Edit21.Text);
f[1]:= StrToFloat(Edit22.Text);
f[2]:= StrToFloat(Edit23.Text);
f[3]:= StrToFloat(Edit24.Text);
f[4]:= StrToFloat(Edit34.Text);

p[0]:= StrToFloat(Edit25.Text);
p[1]:= StrToFloat(Edit26.Text);
p[2]:= StrToFloat(Edit27.Text);
p[3]:= StrToFloat(Edit28.Text);
p[4]:= StrToFloat(Edit35.Text);

end;

procedure ReadIfsParams;
begin
with CustomIFSForm do
begin
Edit1.Text := Format(F109,[a[0]]);
Edit2.Text := Format(F109,[a[1]]);
Edit3.Text := Format(F109,[a[2]]);
Edit4.Text := Format(F109,[a[3]]);
Edit29.Text := Format(F109,[a[4]]);

Edit5.Text := Format(F109,[b[0]]);
Edit6.Text := Format(F109,[b[1]]);
Edit7.Text := Format(F109,[b[2]]);
Edit8.Text := Format(F109,[b[3]]);
Edit30.Text := Format(F109,[b[4]]);

Edit9.Text := Format(F109,[cc[0]]);
Edit10.Text := Format(F109,[cc[1]]);
Edit11.Text := Format(F109,[cc[2]]);
Edit12.Text := Format(F109,[cc[3]]);
Edit31.Text := Format(F109,[cc[4]]);

Edit13.Text := Format(F109,[d[0]]);
Edit14.Text := Format(F109,[d[1]]);
Edit15.Text := Format(F109,[d[2]]);
Edit16.Text := Format(F109,[d[3]]);
Edit32.Text := Format(F109,[d[4]]);

Edit17.Text := Format(F109,[e[0]]);
Edit18.Text := Format(F109,[e[1]]);
Edit19.Text := Format(F109,[e[2]]);
Edit20.Text := Format(F109,[e[3]]);
Edit33.Text := Format(F109,[e[4]]);

Edit21.Text := Format(F109,[f[0]]);
Edit22.Text := Format(F109,[f[1]]);
Edit23.Text := Format(F109,[f[2]]);
Edit24.Text := Format(F109,[f[3]]);
Edit34.Text := Format(F109,[f[4]]);

Edit25.Text := Format(F109,[p[0]]);
Edit26.Text := Format(F109,[p[1]]);
Edit27.Text := Format(F109,[p[2]]);
Edit28.Text := Format(F109,[p[3]]);
Edit35.Text := Format(F109,[p[4]]);
end;
end;

procedure TCustomIFSForm.FormActivate(Sender: TObject);
begin
ReadIfsParams;
end;

procedure TCustomIFSForm.Button3Click(Sender: TObject);
begin
setIfsparams;
BM.PSave.Click;
Caption := 'Custom IFS' + ' [ ' + BM.SaveDialog1.Filename + ' ]';
end;

procedure TCustomIFSForm.Button4Click(Sender: TObject);
var
 I: TIniFile;
 j : Integer;
begin

 BM.OpenDialog1.Title := s4;
 BM.OpenDialog1.FilterIndex := 5;
 BM.OpenDialog1.InitialDir := ParamsDirectory;

 if BM.OpenDialog1.Execute then
 begin
 I := TIniFile.Create(BM.OpenDialog1.Filename);
 I.ReadString(s12,'NAME',BM.OpenDialog1.Filename);
 transforms := I.ReadInteger(s12,'TRANSFORMS',transforms);
 j:=0;
 while j < transforms do
  begin
  a[j] := StrToFloat(I.ReadString(s12,'a['+IntToStr(j)+']',Format(F109,[a[j]])));
  b[j] := StrToFloat(I.ReadString(s12,'b['+IntToStr(j)+']',Format(F109,[b[j]])));
 cc[j] := StrToFloat(I.ReadString(s12,'cc['+IntToStr(j)+']',Format(F109,[cc[j]])));
  d[j] := StrToFloat(I.ReadString(s12,'d['+IntToStr(j)+']',Format(F109,[d[j]])));
  e[j] := StrToFloat(I.ReadString(s12,'e['+IntToStr(j)+']',Format(F109,[e[j]])));
  f[j] := StrToFloat(I.ReadString(s12,'f['+IntToStr(j)+']',Format(F109,[f[j]])));
  p[j] := StrToFloat(I.ReadString(s12,'p['+IntToStr(j)+']',Format(F109,[p[j]])));
  inc(j);
  end;
  while j < transforms+3 do
  begin
    a[j] := 0.00000;
    b[j] := 0.00000;
   cc[j] := 0.00000;
    d[j] := 0.00000;
    e[j] := 0.00000;
    f[j] := 0.00000;
    p[j] := 0.00000;
    inc(j);
  end;

 I.Free;
 Caption := 'Custom IFS' + ' [ ' + BM.OpenDialog1.Filename + ' ]';
 ReadIfsParams;
 end;
end;

procedure TCustomIFSForm.Button5Click(Sender: TObject);
var
j : Integer;
begin
  j:=0;
  while j < 6 do
  begin
    a[j] := 0.00000;
    b[j] := 0.00000;
   cc[j] := 0.00000;
    d[j] := 0.00000;
    e[j] := 0.00000;
    f[j] := 0.00000;
    p[j] := 0.00000;
    inc(j);
  end;
  ReadIfsParams;
end;

procedure TCustomIFSForm.FormShow(Sender: TObject);
begin
ReadIfsParams;
end;

procedure TCustomIFSForm.Button1Click(Sender: TObject);
begin
close;
end;

procedure TCustomIFSForm.EditAllExit(Sender: TObject);
begin
  setIfsparams;
end;

end.
