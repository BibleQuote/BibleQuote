// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
program BibleQuote6;



{%TogetherDiagram 'ModelSupport_BibleQuote6\default.txaPackage'}

uses
  BibleQuoteUtils in 'BibleQuoteUtils.pas',
  Forms,
  string_procs in 'string_procs.pas',
  WCharWindows in 'WCharWindows.pas',
  WCharReader in 'WCharReader.pas',
  Classes,
  WideStrings,
  SysUtils,
  links_parser in 'links_parser.pas',
  MultiLanguage in 'MultiLanguage.pas',
  input in 'input.pas' {InputForm},
  copyright in 'copyright.pas' {CopyrightForm},
  config in 'config.pas' {ConfigForm},
  hotkeys in 'hotkeys.pas' {HotKeyForm},
  Dict in 'Dict.pas',
  Bible in 'Bible.pas',
  WComp in 'Hotkey\WComp.pas',
  SysHot in 'Hotkey\SysHot.pas',
  AlekPageControl in 'AlekPageControl.pas',
  Tabs in 'Tabs.pas',
  BibleQuoteConfig in 'BibleQuoteConfig.pas',
  main in 'main.pas' {MainForm: TTntForm},
  AboutForm in 'AboutForm.pas' {frmAbout: TTntForm},
  XPTheme in 'XPTheme.pas',
  htmlview in 'Thtml\package\htmlview.pas',
  HTMLSubs in 'Thtml\package\HTMLSubs.pas',
  BQExceptionTracker in 'BQExceptionTracker.pas' {bqExceptionForm},
  qNavTest in 'qNavTest.pas' {frmQNav},
  SevenZipVCL in 'SevenZip\SevenZipVCL.pas',
  VersesDB in 'VersesDB.pas' {VerseListEngine: TDataModule},
  bqHintTools in 'bqHintTools.pas',
  bqLinksParserIntf in 'bqLinksParserIntf.pas',
  sevenZipHelper in 'sevenZipHelper.pas',
  bqContainers in 'bqContainers.pas',
  bqPlainUtils in 'bqPlainUtils.pas',
  bqHistoryContainer in 'bqHistoryContainer.pas';

{$R *.res}
var
  fn: string;
begin
  try
    if AnsiUpperCase(ParamStr(1)) = '/DEBUG' then begin
      fn := ExtractFilePath(Application.ExeName) + 'dbg.log';
      G_DebugEx:=1;
      end
    else begin
      fn := 'nul';
      G_DebugEx:=0;
     end;
    Assign(Output, fn);
    if FileExists(fn) then
      Append(Output)
    else
      Rewrite(Output);
  except
  end;

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInputForm, InputForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TbqExceptionForm, bqExceptionForm);
  Application.Run;
  try
    Close(Output);
  except
  end;
end.

