program BibleQuote6;

{%TogetherDiagram 'ModelSupport_BibleQuote6\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\XPTheme\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\input\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\config\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\WCharWindows\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\WComp\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\SysHot\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\Dict\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\AlekPageControl\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\WCharReader\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\Tabs\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\BibleQuote6\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\string_procs\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\bible\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\MultiLanguage\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\links_parser\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\copyright\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\AlekNavigator\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\hotkeys\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\config\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\BibleQuote6\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\XPTheme\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\AlekPageControl\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\input\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\WCharWindows\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\copyright\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\hotkeys\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\Dict\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\string_procs\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\MultiLanguage\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\SysHot\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\bible\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\WCharReader\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\links_parser\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\WComp\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\main\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\Tabs\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BibleQuote6\AlekNavigator\default.txvpck'}

uses
  {$IFDEF MEMCHECK}
  MemCheck,
  {$ENDIF}
  XPTheme in 'XPTheme.pas',
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
  BibleQuoteUtils in 'BibleQuoteUtils.pas';

{$R *.res}
var fn:string;
begin
  try
  if  AnsiUpperCase(ParamStr(1))='debug' then
  fn:=ExtractFilePath(Application.ExeName)+'dbg.log'
  else fn:='nul';
  Assign(Output, fn );
  if FileExists(fn) then   Append(Output)
  else Rewrite(Output);
  except end;
  writeln(Now, ': Старт Цитаты');
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInputForm, InputForm);
  Application.CreateForm(TCopyrightForm, CopyrightForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
  try
  Close(Output);
  except end;
end.
