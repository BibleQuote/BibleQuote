// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
program BibleQuote6;

uses
  BibleQuoteUtils in 'BibleQuoteUtils.pas',
  Forms,
  StringProcs in 'StringProcs.pas',
  WCharWindows in 'WCharWindows.pas',
  Classes,
  WideStrings,
  SysUtils,
  MultiLanguage in 'MultiLanguage.pas',
  InputFrm in 'Forms\InputFrm.pas' {InputForm},
  CopyrightFrm in 'Forms\CopyrightFrm.pas' {CopyrightForm},
  ConfigFrm in 'Forms\ConfigFrm.pas' {ConfigForm},
  Dict in 'Dict.pas',
  Bible in 'Bible.pas',
  AlekPageControl in 'AlekPageControl.pas',
  BibleQuoteConfig in 'BibleQuoteConfig.pas',
  XPTheme in 'XPTheme.pas',
  ExceptionFrm in 'Forms\ExceptionFrm.pas' {ExceptionForm},
  MyLibraryFrm in 'Forms\MyLibraryFrm.pas' {MyLibraryForm},
  HintTools in 'HintTools.pas',
  LinksParserIntf in 'LinksParserIntf.pas',
  SevenZipHelper in 'SevenZipHelper.pas',
  Containers in 'Containers.pas',
  PlainUtils in 'PlainUtils.pas',
  HistoryContainer in 'HistoryContainer.pas',
  LinksParser in 'LinksParser.pas',
  BibleLinkParser in 'BibleLinkParser.pas',
  GfxRenderers in 'GfxRenderers.pas',
  ICommandProcessor in 'ICommandProcessor.pas',
  WinUIServices in 'WinUIServices.pas',
  CommandProcessor in 'CommandProcessor.pas',
  HTMLViewerSite in 'HTMLViewerSite.pas',
  VDTEditLink in 'VDTEditLink.pas',
  Settings in 'Settings.pas',
  BackgroundServices in 'BackgroundServices.pas',
  Engine in 'Engine.pas',
  EngineInterfaces in 'EngineInterfaces.pas',
  MainFrm in 'Forms\MainFrm.pas' {MainForm: TTntForm},
  WCharReader in 'WCharReader.pas',
  AboutFrm in 'Forms\AboutFrm.pas' {AboutForm},
  VersesDb in 'Data\VersesDb.pas' {VerseListEngine: TDataModule},
  Tabs in 'Tabs.pas';

{$R *.res}
var
  fn: string;
  param:string;
begin
  try
    if ParamStartedWith('/debug',param) then begin
      fn := ExtractFilePath(Application.Exename) + 'dbg.log';
      G_DebugEx:=1;
      end
    else begin
      fn := 'nul';
      G_DebugEx:=0;
     end;
    Assign(Output, fn);
    Rewrite(Output);
    writeln(bqNowDateTimeString(), 'BibleQuote dbg log started' );
    Flush(Output);
    if ParamStartedWith('/memcheck',param) then begin
      ReportMemoryLeaksOnShutdown:=true;
    end
    else   ReportMemoryLeaksOnShutdown:=false;
  except
  end;


  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TVerseListEngine, VerseListEngine);
  //  Application.HintPause :=100;
  Application.CreateForm(TInputForm, InputForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TExceptionForm, ExceptionForm);

  Application.Run;
  try
    Close(Output);
  except
  end;
end.

