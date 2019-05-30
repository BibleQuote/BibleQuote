unit AppIni;

interface

uses
  Inifiles, Classes, Graphics, SysUtils, Forms, StringProcs, SystemInfo,
  AppPaths, IOUtils, Types.Extensions, UITools;

const
  C_SectionMainForm = 'MainForm';
  C_SectionLibForm = 'LibForm';
  C_SectionCopyOptions = 'CopyOptions';
  C_SectionUI = 'UI';
  C_SectionDefaults = 'Defaults';

  C_ConfigIniFile = 'bibleqt.ini';

  C_DefaultLanguage = 'Русский';
  C_DefaultLanguageFile = 'Русский.lng';

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
    VerseHighlightColor: TColor;

    LastCommand: string;
    LastBibleCommand: string;
    LocalizationFile: string;
    LastLibraryViewMode: TLibraryViewMode;

    HotKeyChoice: integer;

    SecondPath: string;
    DefaultBible: string;
    DefaultStrongBible: string;
    SatelliteBible: string;
    SaveDirectory: string;
    FullContextLinks: boolean;
    HighlightVerseHits: boolean;

    procedure RestoreDefaults();
    procedure Save();
    procedure Load();
  end;

var
  AppConfig: TAppConfig;
  DefaultAppConfig: TAppConfig;

implementation

uses TabData;

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
    ini.WriteString(C_SectionUI, 'VerseHighlightColor', Color2Hex(VerseHighlightColor));

    ini.WriteString(C_SectionDefaults, 'LastCommand', LastCommand);
    ini.WriteString(C_SectionDefaults, 'LastBibleCommand', LastBibleCommand);
    ini.WriteString(C_SectionDefaults, 'LocalizationFile', LocalizationFile);
    ini.WriteString(C_SectionDefaults, 'LastLibraryViewMode', TExtensions.EnumToString(LastLibraryViewMode));

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

procedure TAppConfig.RestoreDefaults;
begin
  LocalizationFile := C_DefaultLanguageFile;

  MainFormFontName := 'Microsoft Sans Serif';
  MainFormFontSize := 9;

  MainFormWidth := 0;
  MainFormHeight := 0;
  MainFormTop := 0;
  MainFormLeft := 0;

  MainFormMaximized := false;
  MinimizeToTray := false;

  LibFormWidth := 400;
  LibFormHeight := 600;
  LibFormTop := 100;
  LibFormLeft := 100;

  AddVerseNumbers := true;
  AddFontParams := false;
  AddReference := true;
  AddReferenceChoice := 1;
  AddLineBreaks := true;
  AddModuleName := false;

  DefFontName := 'Microsoft Sans Serif';
  DefFontSize := 12;
  DefFontColor := clWindowText;

  RefFontName := 'Microsoft Sans Serif';
  RefFontSize := 12;
  RefFontColor := clWindowText;

  HotSpotColor := clHotLight;
  BackgroundColor := clWhite;
  SelTextColor := clRed;
  VerseHighlightColor := clInfoBk;

  LastCommand := '';
  LastBibleCommand := '';
  LastLibraryViewMode := lvmDetail;

  HotKeyChoice := 0;

  SecondPath := '';
  DefaultBible := '';
  DefaultStrongBible := '';
  SatelliteBible := '';
  SaveDirectory := GetMyDocuments;
  FullContextLinks := true;
  HighlightVerseHits := true;
end;

procedure TAppConfig.Load;
var
  ini: TMemIniFile;
  path: string;
  vmode: string;
begin
  path := GetAppConfigPath();
  ini := TMemIniFile.Create(path, TEncoding.Unicode);
  try
    MainFormFontName := ini.ReadString(C_SectionMainForm, 'FontName', DefaultAppConfig.MainFormFontName);
    MainFormFontSize := ini.ReadInteger(C_SectionMainForm, 'FontSize', DefaultAppConfig.MainFormFontSize);

    MainFormWidth := ini.ReadInteger(C_SectionMainForm, 'Width', DefaultAppConfig.MainFormWidth);
    MainFormHeight := ini.ReadInteger(C_SectionMainForm, 'Height', DefaultAppConfig.MainFormHeight);
    MainFormTop := ini.ReadInteger(C_SectionMainForm, 'Top', DefaultAppConfig.MainFormTop);
    MainFormLeft := ini.ReadInteger(C_SectionMainForm, 'Left', DefaultAppConfig.MainFormLeft);

    MainFormMaximized := ini.ReadBool(C_SectionMainForm, 'Maximized', DefaultAppConfig.MainFormMaximized);
    MinimizeToTray := ini.ReadBool(C_SectionMainForm, 'MinimizeToTray', DefaultAppConfig.MinimizeToTray);

    LibFormWidth := ini.ReadInteger(C_SectionLibForm, 'Width', DefaultAppConfig.LibFormWidth);
    LibFormHeight := ini.ReadInteger(C_SectionLibForm, 'Height', DefaultAppConfig.LibFormHeight);
    LibFormTop := ini.ReadInteger(C_SectionLibForm, 'Top', DefaultAppConfig.LibFormTop);
    LibFormLeft := ini.ReadInteger(C_SectionLibForm, 'Left', DefaultAppConfig.LibFormLeft);

    AddVerseNumbers := ini.ReadBool(C_SectionCopyOptions, 'AddVerseNumbers', DefaultAppConfig.AddVerseNumbers);
    AddFontParams := ini.ReadBool(C_SectionCopyOptions, 'AddFontParams', DefaultAppConfig.AddFontParams);
    AddReference := ini.ReadBool(C_SectionCopyOptions, 'AddReference', DefaultAppConfig.AddReference);
    AddReferenceChoice := ini.ReadInteger(C_SectionCopyOptions, 'AddReferenceChoice', DefaultAppConfig.AddReferenceChoice);
    AddLineBreaks := ini.ReadBool(C_SectionCopyOptions, 'AddLineBreaks', DefaultAppConfig.AddLineBreaks);
    AddModuleName := ini.ReadBool(C_SectionCopyOptions, 'AddModuleName', DefaultAppConfig.AddModuleName);

    DefFontName := ini.ReadString(C_SectionUI, 'DefFontName', DefaultAppConfig.DefFontName);
    DefFontSize := ini.ReadInteger(C_SectionUI, 'DefFontSize', DefaultAppConfig.DefFontSize);
    DefFontColor := Hex2Color(ini.ReadString(C_SectionUI, 'DefFontColor', Color2Hex(DefaultAppConfig.DefFontColor)));

    RefFontName := ini.ReadString(C_SectionUI, 'RefFontName', DefaultAppConfig.RefFontName);
    RefFontSize := ini.ReadInteger(C_SectionUI, 'RefFontSize', DefaultAppConfig.RefFontSize);
    RefFontColor := Hex2Color(ini.ReadString(C_SectionUI, 'RefFontColor', Color2Hex(DefaultAppConfig.RefFontColor)));

    HotSpotColor := Hex2Color(ini.ReadString(C_SectionUI, 'HotSpotColor', Color2Hex(DefaultAppConfig.HotSpotColor)));
    BackgroundColor := Hex2Color(ini.ReadString(C_SectionUI, 'BackgroundColor', Color2Hex(DefaultAppConfig.BackgroundColor)));
    SelTextColor := Hex2Color(ini.ReadString(C_SectionUI, 'SelTextColor', Color2Hex(DefaultAppConfig.SelTextColor)));
    VerseHighlightColor := Hex2Color(ini.ReadString(C_SectionUI, 'VerseHighlightColor', Color2Hex(DefaultAppConfig.VerseHighlightColor)));

    LastCommand := ini.ReadString(C_SectionDefaults, 'LastCommand', DefaultAppConfig.LastCommand);
    LastBibleCommand := ini.ReadString(C_SectionDefaults, 'LastBibleCommand', DefaultAppConfig.LastBibleCommand);
    LocalizationFile := ini.ReadString(C_SectionDefaults, 'LocalizationFile', DefaultAppConfig.LocalizationFile);

    vmode := ini.ReadString(C_SectionDefaults, 'LastLibraryViewMode', '');
    LastLibraryViewMode := TExtensions.StringToEnum(vmode, DefaultAppConfig.LastLibraryViewMode);

    HotKeyChoice := ini.ReadInteger(C_SectionDefaults, 'HotKeyChoice', DefaultAppConfig.HotKeyChoice);

    SecondPath := ini.ReadString(C_SectionDefaults, 'SecondPath', DefaultAppConfig.SecondPath);
    DefaultBible := ini.ReadString(C_SectionDefaults, 'DefaultBible', DefaultAppConfig.DefaultBible);
    DefaultStrongBible := ini.ReadString(C_SectionDefaults, 'DefaultStrongBible', DefaultAppConfig.DefaultStrongBible);
    SatelliteBible := ini.ReadString(C_SectionDefaults, 'SatelliteBible', DefaultAppConfig.SatelliteBible);
    SaveDirectory := ini.ReadString(C_SectionDefaults, 'SaveDirectory', DefaultAppConfig.SaveDirectory);
    FullContextLinks := ini.ReadBool(C_SectionDefaults, 'FullContextLinks', DefaultAppConfig.FullContextLinks);
    HighlightVerseHits := ini.ReadBool(C_SectionDefaults, 'HighlightVerseHits', DefaultAppConfig.HighlightVerseHits);
  finally
    ini.Free;
  end;
end;

function TAppConfig.GetAppConfigPath(): string;
var
  fileName: string;
begin
  fileName := TPath.GetFileName(Application.ExeName);
  fileName := ChangeFileExt(fileName, '.ini');
  Result := TPath.Combine(TAppDirectories.UserSettings, fileName);
end;

initialization
begin
  AppConfig := TAppConfig.Create;

  DefaultAppConfig := TAppConfig.Create;
  DefaultAppConfig.RestoreDefaults;
end;

finalization
begin
  FreeAndNil(AppConfig);
  FreeAndNil(DefaultAppConfig);
end;

end.
