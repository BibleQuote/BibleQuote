// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
program BibleQuote;

uses
  BibleQuoteUtils in 'BibleQuoteUtils.pas',
  Forms,
  Classes,
  WideStrings,
  SysUtils,
  MultiLanguage in 'MultiLanguage.pas',
  InputFrm in 'Forms\InputFrm.pas' {InputForm},
  CopyrightFrm in 'Forms\CopyrightFrm.pas' {CopyrightForm},
  ConfigFrm in 'Forms\ConfigFrm.pas' {ConfigForm},
  Dict in 'Dict.pas',
  Bible in 'Bible.pas',
  BibleQuoteConfig in 'BibleQuoteConfig.pas',
  ExceptionFrm in 'Forms\ExceptionFrm.pas' {ExceptionForm},
  MyLibraryFrm in 'Forms\MyLibraryFrm.pas' {MyLibraryForm},
  HintTools in 'HintTools.pas',
  LinksParserIntf in 'LinksParserIntf.pas',
  SevenZipHelper in 'SevenZipHelper.pas',
  Containers in 'Containers.pas',
  PlainUtils in 'PlainUtils.pas',
  LinksParser in 'LinksParser.pas',
  BibleLinkParser in 'BibleLinkParser.pas',
  GfxRenderers in 'GfxRenderers.pas',
  ICommandProcessor in 'ICommandProcessor.pas',
  WinUIServices in 'WinUIServices.pas',
  CommandProcessor in 'CommandProcessor.pas',
  HTMLViewerSite in 'HTMLViewerSite.pas',
  VDTEditLink in 'VDTEditLink.pas',
  BackgroundServices in 'BackgroundServices.pas',
  Engine in 'Engine.pas',
  EngineInterfaces in 'EngineInterfaces.pas',
  MainFrm in 'Forms\MainFrm.pas' {MainForm: TTntForm},
  IOProcs in 'IOProcs.pas',
  AboutFrm in 'Forms\AboutFrm.pas' {AboutForm},
  PasswordDlg in 'Forms\PasswordDlg.pas' {PasswordBox},
  StringProcs in 'StringProcs.pas',
  TagsDb in 'Data\TagsDb.pas' {TagsDbEngine: TDataModule},
  ModuleProcs in 'ModuleProcs.pas',
  AppInfo in 'AppInfo.pas',
  TabData in 'TabData.pas',
  Favorites in 'Favorites.pas',
  SystemInfo in 'SystemInfo.pas';

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

