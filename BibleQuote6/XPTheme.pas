unit XPTheme;

{
  XPTheme.pas v1.0 (2001-12-26) by Jordan Russell, www.jrsoftware.org

  See XPTheme-README.txt for usage instructions.
}

interface

implementation

{$R XPTheme.res}

uses
  CommCtrl, sysutils;

initialization
  { This call is necessary; some apps won't start without it. }
  if Win32MajorVersion > 5 then
          InitCommonControls;

end.
