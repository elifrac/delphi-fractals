unit About;
//****************************************************************************************
//  This File is part of the EliFrac Project.
//  Author : Kyriakopoulos Elias  ©  1997-2000
//  Modifications :
// 15-10-98  : Added  Memory Status Routine.
//****************************************************************************************
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls; {ScrollTe, ScrollText;}

//const
//VerNum = 2.0;

type
  TAboutBox = class(TForm)
    OKButton: TButton;
    ProgramIcon: TImage;
    Label2: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    PhysMem: TLabel;
    FreeRes: TLabel;
    AvailablePhys: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure InitializeCaptions;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation
//uses  Globs;
{$R *.DFM}


procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
close;
//Action := caFree;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  InitializeCaptions;
end;

procedure TAboutBox.InitializeCaptions;
var
  MS: TMemoryStatusEx;
begin
 // ScrollText2.Items[2] := 'Version '+ Format('%2.1f',[VerNum]);
  MS.dwLength := SizeOf(TMemoryStatusEx);
  GlobalMemoryStatusEx(MS);
  PhysMem.Caption := PhysMem.Caption + FormatFloat('#,###" MB"', (MS.ullTotalPhys div 1024)div 1024);
  FreeRes.Caption := FreeRes.Caption + Format('%d %%', [MS.dwMemoryLoad]);
  AvailablePhys.Caption := AvailablePhys.Caption + FormatFloat('##,###" MB"',(MS.ullAvailPhys div 1024)div 1024);

end;

end.

