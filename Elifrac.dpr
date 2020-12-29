program Elifrac;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-2000
//
//****************************************************************************************


uses
  Windows,
  SysUtils,
  Forms,
  Main in 'Main.pas' {BM},
  Inf in 'Inf.pas' {Info},
  Bparams in 'Bparams.pas' {Params1},
  Angle in 'Angle.pas' {AngleFrm},
  Custifs in 'Custifs.pas' {CustomIFSForm},
  Fullscr in 'Fullscr.pas' {FullScreen},
  Graddial in 'Graddial.pas' {gradformBack},
  Ifsfrm in 'Ifsfrm.pas' {IfsForm},
  Lsys in 'Lsys.pas' {Lsysfrm},
  Psize in 'Psize.pas' {PSizeForm},
  Spar in 'Spar.pas' {SParams},
  Winsize in 'Winsize.pas' {WinSize1},
  Edpal in 'Edpal.pas' {EditPal},
  About in 'About.pas' {AboutBox},
  JpOpt in 'JpOpt.pas' {JpegOptionsForm},
  Fchngdlg in 'Fchngdlg.pas' {ChangeDlg},
  Attrpar in 'Attrpar.pas' {AttractorForm},
  SplitCnf in 'SplitCnf.pas' {SplitConForm},
  HalSel in 'HalSel.pas' {HalFunc},
  Mono in 'Mono.pas' {MonoForm},
  MartPar in 'MartPar.pas' {MartinParams},
  UnityFrm in 'UnityFrm.pas' {UnityForm},
  TrigPar in 'TrigPar.pas' {TrigParams},
  BifPar in 'BifPar.pas' {Bifparams},
  ColCycl in 'ColCycl.pas' {ColorCyclingForm},
  LBS in 'LBS.pas' {LBSizeFrm},
  ChrmUnit in 'ChrmUnit.pas' {ChromaForm},
  Sprayunit in 'Sprayunit.pas' {SprayForm},
  CNoiseUnit in 'CNoiseUnit.pas' {CNoiseForm},
  RGBUnit in 'RGBUnit.pas' {RGBForm},
  ContrastUnit in 'ContrastUnit.pas' {ContrastForm},
  SaturationUnit in 'SaturationUnit.pas' {SaturationForm},
  LightnessUnit in 'LightnessUnit.pas' {LightnessForm},
  Edgedt in 'Edgedt.pas' {EdgeFilter1},
  EnterValUnit in 'EnterValUnit.pas' {EnterVal},
  ThresholdUnit in 'ThresholdUnit.pas' {ThresholdForm},
  ExChangeRGBUnit in 'ExChangeRGBUnit.pas' {ExChangeForm},
  MosaicUnit in 'MosaicUnit.pas' {MosaicForm1},
  MonoNoiseUnit in 'MonoNoiseUnit.pas' {MonoNoiseForm},
  Deform in 'Deform.pas' {DeformFrm},
  Vcl.Themes,
  Vcl.Styles;

{$R ELIFRAC.RES}
//const
//CRFM = 'Loading ... ';

var
Fext : String;

begin
  randomize;
  Application.MainFormOnTaskbar := false;
  Application.Initialize;
{ Splash := TSplash.Create(Application);
  Splash.Show;
  Splash.Update;

  Splash.dbmeter1.Position := 3;
  Splash.Label1.Caption := CRFM+'EliFrac Main Window' ;
  Splash.Label1.Update;    }

  TStyleManager.TrySetStyle('Amakrits');
  Application.Title := 'Elifrac';
  Application.HelpFile := 'C:\Develop\Elifrac5\Help\ELIFRAC.HLP';
  Application.CreateForm(TBM, BM);
  Application.CreateForm(TInfo, Info);
  Application.CreateForm(TIfsForm, IfsForm);
  Application.CreateForm(TParams1, Params1);
  Application.CreateForm(TSParams, SParams);
  Application.CreateForm(TAngleFrm, AngleFrm);
  Application.CreateForm(TCustomIFSForm, CustomIFSForm);
  Application.CreateForm(TLsysfrm, Lsysfrm);
  Application.CreateForm(TPSizeForm, PSizeForm);
  Application.CreateForm(TChangeDlg, ChangeDlg);
  Application.CreateForm(TAttractorForm, AttractorForm);
  Application.CreateForm(TSplitConForm, SplitConForm);
  Application.CreateForm(THalFunc, HalFunc);
  Application.CreateForm(TMonoForm, MonoForm);
  Application.CreateForm(TMartinParams, MartinParams);
  Application.CreateForm(TUnityForm, UnityForm);
  Application.CreateForm(TTrigParams, TrigParams);
  Application.CreateForm(TBifparams, Bifparams);
  Application.CreateForm(TColorCyclingForm, ColorCyclingForm);
  Application.CreateForm(TLBSizeFrm, LBSizeFrm);
  Application.CreateForm(TChromaForm, ChromaForm);
  Application.CreateForm(TSprayForm, SprayForm);
  Application.CreateForm(TCNoiseForm, CNoiseForm);
  Application.CreateForm(TRGBForm, RGBForm);
  Application.CreateForm(TContrastForm, ContrastForm);
  Application.CreateForm(TSaturationForm, SaturationForm);
  Application.CreateForm(TLightnessForm, LightnessForm);
  Application.CreateForm(TEdgeFilter1, EdgeFilter1);
  Application.CreateForm(TEnterVal, EnterVal);
  Application.CreateForm(TThresholdForm, ThresholdForm);
  Application.CreateForm(TExChangeForm, ExChangeForm);
  Application.CreateForm(TMosaicForm1, MosaicForm1);
  Application.CreateForm(TMonoNoiseForm, MonoNoiseForm);
  Application.CreateForm(TDeformFrm, DeformFrm);
  BM.Visible := True;
  Info.Visible := Infovis;
  BM.SetFocus;

  if ParamCount = 1 then
   begin
   Fext := UpperCase(ExtractFileExt(ParamStr(1)));
   if (Fext = '.FPR') then
      BM.OpenCommandLineParam(ParamStr(1))
   else if Fext = '.LSM' then
      BM.LSystems1.Click
   else if Fext = '.IFS' then
      BM.IFS1.Click;
   end;
//   Application.OnIdle := TColorCyclingForm.IdleAction;
   Application.Run;
end.
