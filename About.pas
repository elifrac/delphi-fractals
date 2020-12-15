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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  //  procedure InitializeCaptions;
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
Action := caFree;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
 // InitializeCaptions;
end;

{procedure TAboutBox.InitializeCaptions;
var
  MS: TMemoryStatus;
begin
  ScrollText2.Items[2] := 'Version '+ Format('%2.1f',[VerNum]);
  MS.dwLength := SizeOf(TMemoryStatus);
  GlobalMemoryStatus(MS);
  PhysMem.Caption := FormatFloat('#,###" KB"', MS.dwTotalPhys div 1024);
  FreeRes.Caption := Format('%d %%', [MS.dwMemoryLoad]);
  AvailablePhys.Caption := FormatFloat('###,###" KB"',MS.dwAvailPhys div 1024);
  TotalPageFile.Caption := FormatFloat('###,###" MB"',MS.dwTotalPageFile div 1048576);
  AvailPageFile.Caption := FormatFloat('###,###" MB"',MS.dwAvailPageFile div 1048576);
  TotalVirtual.Caption := FormatFloat('###,###" MB"',MS.dwTotalVirtual div 1048576);
  AvailVirtual.Caption := FormatFloat('###,###" MB"',MS.dwAvailVirtual div 1048576);
end; }

end.

