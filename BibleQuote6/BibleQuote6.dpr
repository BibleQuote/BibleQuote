// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
program BibleQuote6;

uses
  BibleQuoteUtils in 'BibleQuoteUtils.pas',
  Forms,
  string_procs in 'string_procs.pas',
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
  bqHintTools in 'bqHintTools.pas',
  bqLinksParserIntf in 'bqLinksParserIntf.pas',
  sevenZipHelper in 'sevenZipHelper.pas',
  bqContainers in 'bqContainers.pas',
  bqPlainUtils in 'bqPlainUtils.pas',
  bqHistoryContainer in 'bqHistoryContainer.pas',
  links_parser in 'links_parser.pas',
  BibleLinkParser in 'BibleLinkParser.pas',
  bqGfxRenderers in 'bqGfxRenderers.pas',
  bqICommandProcessor in 'bqICommandProcessor.pas',
  bqWinUIServices in 'bqWinUIServices.pas',
  bqCommandProcessor in 'bqCommandProcessor.pas',
  bqHTMLViewerSite in 'bqHTMLViewerSite.pas',
  bqVdtEditLink in 'bqVdtEditLink.pas',
  bqSettings in 'bqSettings.pas',
  bqBackgroundServices in 'bqBackgroundServices.pas',
  bqEngine in 'bqEngine.pas',
  bqEngineInterfaces in 'bqEngineInterfaces.pas',
  MainFrm in 'Forms\MainFrm.pas' {MainForm},
  WCharReader in 'WCharReader.pas',
  AboutFrm in 'Forms\AboutFrm.pas' {AboutForm},
  VersesDb in 'Data\VersesDb.pas' {VerseListEngine: TDataModule};

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

