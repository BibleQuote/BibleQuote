program BibleQuote6;

uses
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
  main in 'main.pas' {MainForm: TTntForm},
  AlekPageControl in 'AlekPageControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(THotKeyForm, HotKeyForm);
  Application.CreateForm(TInputForm, InputForm);
  Application.CreateForm(TCopyrightForm, CopyrightForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
end.
