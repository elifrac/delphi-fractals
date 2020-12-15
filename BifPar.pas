unit BifPar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TBifparams = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    RadioGroup1: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Bifparams: TBifparams;

implementation

uses Globs;

{$R *.DFM}

procedure TBifparams.FormShow(Sender: TObject);
begin
Edit1.Text := IntToStr(bifiter);
Edit2.Text := IntToStr(bifhide);
Edit3.Text := floatToStr(bifxr);
Edit4.Text := floatToStr(bifyr);
end;

procedure TBifparams.Button1Click(Sender: TObject);
begin
bifiter := StrToInt(Edit1.Text);
bifhide := StrToInt(Edit2.Text);
bifxr :=  StrTofloat(Edit3.Text);
bifyr :=  StrTofloat(Edit4.Text);
end;

procedure TBifparams.FormCreate(Sender: TObject);
begin
case Radiogroup1.ItemIndex of
  0 : begin bifxr := 1.5; bifyr := 0.5; end;
  1,2,3,4 : begin bifxr := 10; bifyr := 6; end;
end;
end;

procedure TBifparams.RadioGroup1Click(Sender: TObject);
begin
case Radiogroup1.ItemIndex of
  0 : begin bifxr := 1.5; bifyr := 0.5; end;
  1,2,3,4 : begin bifxr := 10; bifyr := 6; end;
end;
Edit3.Text := floatToStr(bifxr);
Edit4.Text := floatToStr(bifyr);
bifxcenter := 2.5;
bifycenter := 0.5;
end;

end.
