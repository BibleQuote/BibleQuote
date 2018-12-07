unit AppIni;

interface

uses
  Inifiles, Classes, Graphics, SysUtils, Forms, StringProcs, SystemInfo,
  AppPaths, IOUtils;

const
  C_SectionMainForm = 'MainForm';
  C_SectionLibForm = 'LibForm';
  C_SectionCopyOptions = 'CopyOptions';
  C_SectionUI = 'UI';
  C_SectionDefaults = 'Defaults';

  C_ConfigIniFile = 'bibleqt.ini';

type
  TAppConfig = class
  private
    function GetAppConfigPath(): string;
  public
    MainFormFontName: string;
    MainFormFontSize: integer;
    MainFormWidth: integer;
    MainFormHeight: integer;
    MainFormLeft: integer;
    MainFormTop: integer;
    MainFormMaximized: boolean;
    MinimizeToTray: boolean;

    LibFormWidth: integer;
    LibFormHeight: integer;
    LibFormLeft: integer;
    LibFormTop: integer;

    HrefUnderline: boolean;

    AddVerseNumbers: boolean;
    AddFontParams: boolean;
    AddReference: boolean;
    AddReferenceChoice: integer;
    AddLineBreaks: boolean;
    AddModuleName: boolean;

    DefFontName: string;
    DefFontSize: integer;
    DefFontColor: TColor;

    RefFontName: string;
    RefFontSize: integer;
    RefFontColor: TColor;

    HotSpotColor: TColor;
    BackgroundColor: TColor;
    SelTextColor: TColor;
    //HyperlinksColor: TColor;
    VerseHighlightColor: TColor;

    LastCommand: string;
    LocalizationFile: string;

    HotKeyChoice: integer;

    SecondPath: string;
    DefaultBible: string;
    DefaultStrongBible: string;
    SatelliteBible: string;
    SaveDirectory: string;
    FullContextLinks: boolean;
    HighlightVerseHits: boolean;

    procedure Save();
    procedure Load();
    function Copy(): TAppConfig;
  end;

var
  AppConfig: TAppConfig;

implementation

procedure TAppConfig.Save;
var
  ini: TMemIniFile;
  path: string;
begin
  path := GetAppConfigPath();
  ini := TMemIniFile.Create(path, TEncoding.Unicode);
  try
    ini.WriteString(C_SectionMainForm, 'FontName', MainFormFontName);
    ini.WriteInteger(C_SectionMainForm, 'FontSize', MainFormFontSize);

    ini.WriteInteger(C_SectionMainForm, 'Width', MainFormWidth);
    ini.WriteInteger(C_SectionMainForm, 'Height', MainFormHeight);
    ini.WriteInteger(C_SectionMainForm, 'Top', MainFormTop);
    ini.WriteInteger(C_SectionMainForm, 'Left', MainFormLeft);

    ini.WriteBool(C_SectionMainForm, 'Maximized', MainFormMaximized);
    ini.WriteBool(C_SectionMainForm, 'MinimizeToTray', MinimizeToTray);

    ini.WriteInteger(C_SectionLibForm, 'Width', LibFormWidth);
    ini.WriteInteger(C_SectionLibForm, 'Height', LibFormHeight);
    ini.WriteInteger(C_SectionLibForm, 'Top', LibFormTop);
    ini.WriteInteger(C_SectionLibForm, 'Left', LibFormLeft);

    ini.WriteBool(C_SectionCopyOptions, 'AddVerseNumbers', AddVerseNumbers);
    ini.WriteBool(C_SectionCopyOptions, 'AddFontParams', AddFontParams);
    ini.WriteBool(C_SectionCopyOptions, 'AddReference', AddReference);
    ini.WriteInteger(C_SectionCopyOptions, 'AddReferenceChoice', AddReferenceChoice);
    ini.WriteBool(C_SectionCopyOptions, 'AddLineBreaks', AddLineBreaks);
    ini.WriteBool(C_SectionCopyOptions, 'AddModuleName', AddModuleName);

    ini.WriteString(C_SectionUI, 'DefFontName', DefFontName);
    ini.WriteInteger(C_SectionUI, 'DefFontSize', DefFontSize);
    ini.WriteString(C_SectionUI, 'DefFontColor', Color2Hex(DefFontColor));

    ini.WriteString(C_SectionUI, 'RefFontName', RefFontName);
    ini.WriteInteger(C_SectionUI, 'RefFontSize', RefFontSize);
    ini.WriteString(C_SectionUI, 'RefFontColor', Color2Hex(RefFontColor));

    ini.WriteString(C_SectionUI, 'HotSpotColor', Color2Hex(HotSpotColor));
    ini.WriteString(C_SectionUI, 'BackgroundColor', Color2Hex(BackgroundColor));
    ini.WriteString(C_SectionUI, 'SelTextColor', Color2Hex(SelTextColor));
    //ini.WriteString(C_SectionUI, 'HyperlinksColor', Color2Hex(HyperlinksColor));
    ini.WriteString(C_SectionUI, 'VerseHighlightColor', Color2Hex(VerseHighlightColor));

    ini.WriteString(C_SectionDefaults, 'LastCommand', LastCommand);
    ini.WriteString(C_SectionDefaults, 'LocalizationFile', LocalizationFile);

    ini.WriteInteger(C_SectionDefaults, 'HotKeyChoice', HotKeyChoice);

    ini.WriteString(C_SectionDefaults, 'SecondPath', SecondPath);
    ini.WriteString(C_SectionDefaults, 'DefaultBible', DefaultBible);
    ini.WriteString(C_SectionDefaults, 'DefaultStrongBible', DefaultStrongBible);
    ini.WriteString(C_SectionDefaults, 'SatelliteBible', SatelliteBible);
    ini.WriteString(C_SectionDefaults, 'SaveDirectory', SaveDirectory);
    ini.WriteBool(C_SectionDefaults, 'FullContextLinks', FullContextLinks);
    ini.WriteBool(C_SectionDefaults, 'HighlightVerseHits', HighlightVerseHits);

    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

procedure TAppConfig.Load;
var
  ini: TMemIniFile;
  path: string;
begin
  path := GetAppConfigPath();
  ini := TMemIniFile.Create(path, TEncoding.Unicode);
  try
    MainFormFontName := ini.ReadString(C_SectionMainForm, 'FontName', 'Microsoft Sans Serif');
    MainFormFontSize := ini.ReadInteger(C_SectionMainForm, 'FontSize', 9);

    MainFormWidth := ini.ReadInteger(C_SectionMainForm, 'Width', 0);
    MainFormHeight := ini.ReadInteger(C_SectionMainForm, 'Height', 0);
    MainFormTop := ini.ReadInteger(C_SectionMainForm, 'Top', 0);
    MainFormLeft := ini.ReadInteger(C_SectionMainForm, 'Left', 0);

    MainFormMaximized := ini.ReadBool(C_SectionMainForm, 'Maximized', false);
    MinimizeToTray := ini.ReadBool(C_SectionMainForm, 'MinimizeToTray', false);

    LibFormWidth := ini.ReadInteger(C_SectionLibForm, 'Width', 400);
    LibFormHeight := ini.ReadInteger(C_SectionLibForm, 'Height', 600);
    LibFormTop := ini.ReadInteger(C_SectionLibForm, 'Top', 100);
    LibFormLeft := ini.ReadInteger(C_SectionLibForm, 'Left', 100);

    AddVerseNumbers := ini.ReadBool(C_SectionCopyOptions, 'AddVerseNumbers', true);
    AddFontParams := ini.ReadBool(C_SectionCopyOptions, 'AddFontParams', false);
    AddReference := ini.ReadBool(C_SectionCopyOptions, 'AddReference', true);
    AddReferenceChoice := ini.ReadInteger(C_SectionCopyOptions, 'AddReferenceChoice', 1);
    AddLineBreaks := ini.ReadBool(C_SectionCopyOptions, 'AddLineBreaks', true);
    AddModuleName := ini.ReadBool(C_SectionCopyOptions, 'AddModuleName', false);

    DefFontName := ini.ReadString(C_SectionUI, 'DefFontName', 'Microsoft Sans Serif');
    DefFontSize := ini.ReadInteger(C_SectionUI, 'DefFontSize', 12);
    DefFontColor := Hex2Color(ini.ReadString(C_SectionUI, 'DefFontColor', Color2Hex(clWindowText)));

    RefFontName := ini.ReadString(C_SectionUI, 'RefFontName', 'Microsoft Sans Serif');
    RefFontSize := ini.ReadInteger(C_SectionUI, 'RefFontSize', 12);
    RefFontColor := Hex2Color(ini.ReadString(C_SectionUI, 'RefFontColor', Color2Hex(clWindowText)));

    HotSpotColor := Hex2Color(ini.ReadString(C_SectionUI, 'HotSpotColor', Color2Hex(clHotLight)));
    BackgroundColor := Hex2Color(ini.ReadString(C_SectionUI, 'BackgroundColor', Color2Hex(clWindow)));
    SelTextColor := Hex2Color(ini.ReadString(C_SectionUI, 'SelTextColor', Color2Hex(clRed)));
    //HyperlinksColor := Hex2Color(ini.ReadString(C_SectionUI, 'HyperlinksColor', Color2Hex(clWindowText)));
    VerseHighlightColor := Hex2Color(ini.ReadString(C_SectionUI, 'VerseHighlightColor', Color2Hex(clInfoBk)));

    LastCommand := ini.ReadString(C_SectionDefaults, 'LastCommand', '');
    LocalizationFile := ini.ReadString(C_SectionDefaults, 'LocalizationFile', '');

    HotKeyChoice := ini.ReadInteger(C_SectionDefaults, 'HotKeyChoice', 0);

    SecondPath := ini.ReadString(C_SectionDefaults, 'SecondPath', '');
    DefaultBible := ini.ReadString(C_SectionDefaults, 'DefaultBible', '');
    DefaultStrongBible := ini.ReadString(C_SectionDefaults, 'DefaultStrongBible', '');
    SatelliteBible := ini.ReadString(C_SectionDefaults, 'SatelliteBible', '');
    SaveDirectory := ini.ReadString(C_SectionDefaults, 'SaveDirectory', GetMyDocuments);
    FullContextLinks := ini.ReadBool(C_SectionDefaults, 'FullContextLinks', true);
    HighlightVerseHits := ini.ReadBool(C_SectionDefaults, 'HighlightVerseHits', true);
  finally
    ini.Free;
  end;
end;

function TAppConfig.Copy(): TAppConfig;
begin

end;
    
function TAppConfig.GetAppConfigPath(): string;
var
  fileName: string;
begin
  fileName := TPath.GetFileName(Application.ExeName);
  fileName := ChangeFileExt(fileName, '.ini');
  Result := TPath.Combine(TAppDirectories.UserSettings, fileName);
end;

end.
