// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
program BibleQuote;

uses
  Forms,
  Classes,
  WideStrings,
  SysUtils,
  InputFrm in 'Forms\InputFrm.pas' {InputForm},
  CopyrightFrm in 'Forms\CopyrightFrm.pas' {CopyrightForm},
  ConfigFrm in 'Forms\ConfigFrm.pas' {ConfigForm},
  ExceptionFrm in 'Forms\ExceptionFrm.pas' {ExceptionForm},
  MyLibraryFrm in 'Forms\MyLibraryFrm.pas' {MyLibraryForm},
  MainFrm in 'Forms\MainFrm.pas' {MainForm: TTntForm},
  AboutFrm in 'Forms\AboutFrm.pas' {AboutForm},
  PasswordDlg in 'Forms\PasswordDlg.pas' {PasswordBox},
  Containers in 'Collections\Containers.pas',
  Bible in 'Core\Bible.pas',
  BibleLinkParser in 'Core\BibleLinkParser.pas',
  BibleQuoteConfig in 'Core\BibleQuoteConfig.pas',
  BibleQuoteUtils in 'Core\BibleQuoteUtils.pas',
  CommandProcessor in 'Core\CommandProcessor.pas',
  Engine in 'Core\Engine.pas',
  EngineInterfaces in 'Core\EngineInterfaces.pas',
  AppInfo in 'Utils\AppInfo.pas',
  SystemInfo in 'Utils\SystemInfo.pas',
  GfxRenderers in 'UI\GfxRenderers.pas',
  HintTools in 'UI\HintTools.pas',
  HTMLViewerSite in 'UI\HTMLViewerSite.pas',
  WinUIServices in 'UI\WinUIServices.pas',
  ICommandProcessor in 'Core\ICommandProcessor.pas',
  VDTEditLink in 'UI\VDTEditLink.pas',
  Dict in 'Core\Dict.pas',
  SevenZipHelper in 'Utils\SevenZipHelper.pas',
  LinksParser in 'Core\LinksParser.pas',
  LinksParserIntf in 'Core\LinksParserIntf.pas',
  Favorites in 'Core\Favorites.pas',
  PlainUtils in 'Utils\PlainUtils.pas',
  StringProcs in 'Utils\StringProcs.pas',
  BackgroundServices in 'IO\BackgroundServices.pas',
  IOProcs in 'IO\IOProcs.pas',
  ModuleProcs in 'IO\ModuleProcs.pas',
  TagsDb in 'Data\TagsDb.pas' {TagsDbEngine: TDataModule},
  MultiLanguage in 'Core\MultiLanguage.pas',
  TabData in 'Core\TabData.pas',
  CRC32 in 'Utils\CRC32.pas';

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
    writeln(NowDateTimeString(), 'BibleQuote dbg log started' );
    Flush(Output);
    if ParamStartedWith('/memcheck',param) then begin
      ReportMemoryLeaksOnShutdown:=true;
    end
    else   ReportMemoryLeaksOnShutdown:=false;
  except
  end;


  Application.Initialize;

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TExceptionForm, ExceptionForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TPasswordBox, PasswordBox);
  Application.CreateForm(TInputForm, InputForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
  try
    Close(Output);
  except
  end;
end.

