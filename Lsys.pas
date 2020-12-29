unit lsys;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles,StdCtrls, ExtCtrls;

type
  TLsysfrm = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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
    Initiator: TEdit;
    d1gen: TEdit;
    D2gen: TEdit;
    Lgen: TEdit;
    Rgen: TEdit;
    Xgen: TEdit;
    Ygen: TEdit;
    Tgen: TEdit;
    StartX: TEdit;
    StartY: TEdit;
    StartAngle: TEdit;
    Divisor: TEdit;
    div2: TEdit;
    div3: TEdit;
    Angle1: TEdit;
    LineLength: TEdit;
    Button1: TButton;
    Label18: TLabel;
    Lvl: TEdit;
    Button3: TButton;
    Button4: TButton;
    LSName: TEdit;
    Label19: TLabel;
    PaintBox1: TPaintBox;
    Button5: TButton;
    Button6: TButton;
    Button2: TButton;
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  //  procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Lsysfrm: TLsysfrm;

implementation

uses Globs,Main; // LsysHlp;

{$R *.DFM}

procedure TLsysfrm.Button4Click(Sender: TObject);
var
 I: TIniFile;
 s1 : String;
begin
 BM.SaveDialog1.Title := s11;
 BM.SaveDialog1.FilterIndex := 4;
 BM.SaveDialog1.InitialDir := ParamsDirectory;
 s1 := 'L-System Parameter File';
 if BM.SaveDialog1.Execute then
 begin
 I := TIniFile.Create(BM.SaveDialog1.Filename);
 I.WriteString(s1,'FRACTAL NAME',LSName.Text);
 I.WriteString(s1,'Initiator',Initiator.text );
 I.WriteString(s1,'d Generator',d1gen.text );
 I.WriteString(s1,'D Generator',D2gen.text );
 I.WriteString(s1,'L Generator',Lgen.text );
 I.WriteString(s1,'R Generator',Rgen.text );
 I.WriteString(s1,'X Generator',Xgen.text );
 I.WriteString(s1,'Y Generator',Ygen.text );
 I.WriteString(s1,'T Generator',Tgen.text );
 I.WriteString(s1,'Start X',StartX.Text);
 I.WriteString(s1,'Start Y',StartY.Text);
 I.WriteString(s1,'Start Angle',StartAngle.Text);
 I.WriteString(s1,'Divisor',Divisor.Text);
 I.WriteString(s1,'Second Divisor',Div2.Text);
 I.WriteString(s1,'Third Divisor',Div3.Text);
 I.WriteString(s1,'Angle',angle1.Text);
 I.WriteString(s1,'Line Length',LineLength.Text);
 I.WriteString(s1,'Level',Lvl.Text);
 I.Free;
end;
end;

procedure TLsysfrm.Button3Click(Sender: TObject);
var
 I: TIniFile;
 s1 : String;
begin
 BM.OpenDialog1.Title := s10;
 BM.OpenDialog1.FilterIndex := 4;
 BM.OpenDialog1.InitialDir := ParamsDirectory;
 s1 := 'L-System Parameter File';
 if BM.OpenDialog1.Execute then
 begin
 I := TIniFile.Create(BM.OpenDialog1.Filename);
 LSName.Text :=    I.ReadString(s1,'FRACTAL NAME',LSName.Text);
 Initiator.text := I.ReadString(s1,'Initiator',Initiator.text );
 d1gen.text :=     I.ReadString(s1,'d Generator',d1gen.text );
 D2gen.text :=     I.ReadString(s1,'D Generator',D2gen.text );
 Lgen.text :=      I.ReadString(s1,'L Generator',Lgen.text );
 Rgen.text :=      I.ReadString(s1,'R Generator',Rgen.text );
 Xgen.text :=      I.ReadString(s1,'X Generator',Xgen.text );
 Ygen.text :=      I.ReadString(s1,'Y Generator',Ygen.text );
 Tgen.text :=      I.ReadString(s1,'T Generator',Tgen.text );
 StartX.Text :=    I.ReadString(s1,'Start X',StartX.Text);
 StartY.Text :=    I.ReadString(s1,'Start Y',StartY.Text);
 StartAngle.Text:= I.ReadString(s1,'Start Angle',StartAngle.Text);
 Divisor.Text :=   I.ReadString(s1,'Divisor',Divisor.Text);
 Div2.Text :=      I.ReadString(s1,'Second Divisor',Div2.Text);
 Div3.Text :=      I.ReadString(s1,'Third Divisor',Div3.Text);
 angle1.Text :=    I.ReadString(s1,'Angle',angle1.Text);
 LineLength.Text:= I.ReadString(s1,'Line Length',LineLength.Text);
 Lvl.Text :=       I.ReadString(s1,'Level',Lvl.Text);
 I.Free;
end;

end;

procedure TLsysfrm.FormPaint(Sender: TObject);
begin
 with PaintBox1.Canvas do
  begin
   Brush.Color := lsysColor;
   Rectangle(0,0,Width,Height);
  end;
end;

procedure TLsysfrm.FormCreate(Sender: TObject);
begin
lsyscolor := clBlue;
end;

procedure TLsysfrm.Button5Click(Sender: TObject);
begin
BM.ColorDialog1.Color := lsysColor;
If BM.ColorDialog1.Execute then
   begin
     lsysColor := BM.ColorDialog1.Color;
     with PaintBox1.Canvas do
       begin
       Brush.Color := lsysColor;
       Rectangle(0,0,Width,Height);
       end;
   end;
end;

{procedure TLsysfrm.Button2Click(Sender: TObject);
begin
Application.CreateForm(TLsysHelp, LsysHelp);
LsysHelp.ShowModal; // L System Help.
end; }

procedure TLsysfrm.Button2Click(Sender: TObject);
begin
Application.HelpCommand(HELP_CONTEXT,1050);
end;

end.
