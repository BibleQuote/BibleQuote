// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
program BibleQuote6;





{%TogetherDiagram 'ModelSupport_BibleQuote6\default.txaPackage'}

uses
  BibleQuoteUtils in 'BibleQuoteUtils.pas',
  tntForms,
  forms,
  string_procs in 'string_procs.pas',
  WCharWindows in 'WCharWindows.pas',
  WCharReader in 'WCharReader.pas',
  Classes,
  WideStringsMod,
  SysUtils,
  TntSysUtils,
  MultiLanguage in 'MultiLanguage.pas',
  input in 'input.pas' {InputForm},
  copyright in 'copyright.pas' {CopyrightForm},
  config in 'config.pas' {ConfigForm},
  hotkeys in 'hotkeys.pas' {HotKeyForm},
  Dict in 'Dict.pas',
  Bible in 'Bible.pas',
  AlekPageControl in 'AlekPageControl.pas',
  Tabs in 'Tabs.pas',
  BibleQuoteConfig in 'BibleQuoteConfig.pas',
  main in 'main.pas' {MainForm: TTntForm},
  AboutForm in 'AboutForm.pas' {frmAbout: TTntForm},
  XPTheme in 'XPTheme.pas',
  BQExceptionTracker in 'BQExceptionTracker.pas' {bqExceptionForm},
  qNavTest in 'qNavTest.pas' {frmQNav},
  VersesDB in 'VersesDB.pas' {VerseListEngine: TDataModule},
  bqHintTools in 'bqHintTools.pas',
  bqLinksParserIntf in 'bqLinksParserIntf.pas',
  sevenZipHelper in 'sevenZipHelper.pas',
  bqContainers in 'bqContainers.pas',
  bqPlainUtils in 'bqPlainUtils.pas',
  bqHistoryContainer in 'bqHistoryContainer.pas',
  links_parser in 'links_parser.pas',
  BibleLinkParser in 'BibleLinkParser.pas',
  bqCollectionsEdit in 'bqCollectionsEdit.pas' {bqCollectionsEditor},
  bqGfxRenderers in 'bqGfxRenderers.pas',
  bqICommandProcessor in 'bqICommandProcessor.pas',
  bqWinUIServices in 'bqWinUIServices.pas',
  bqCommandProcessor in 'bqCommandProcessor.pas',
  bqHTMLViewerSite in 'bqHTMLViewerSite.pas';

{$R *.res}
var
  fn: string;
begin
  try
    if AnsiUpperCase(ParamStr(1)) = '/DEBUG' then begin
      fn := WideExtractFilePath(tntApplication.Exename) + 'dbg.log';
      G_DebugEx:=1;
      end
    else begin
      fn := 'nul';
      G_DebugEx:=0;
     end;
    Assign(Output, fn);
//    if FileExists(fn) then
//      Append(Output)
//    else
      Rewrite(Output);
    writeln('BibleQuote dbg log started' );
    Flush(Output);
  except
  end;

  Application.Initialize;
//  Application.HintPause :=100;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInputForm, InputForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TbqExceptionForm, bqExceptionForm);
  Application.CreateForm(TbqCollectionsEditor, bqCollectionsEditor);
  Application.Run;
  try
    Close(Output);
  except
  end;
end.

