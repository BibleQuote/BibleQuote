unit BibleqtIni;

interface

uses Classes, IniFiles, IOProcs, ChapterData, Generics.Collections;

  const
    MAX_BOOKQTY = 256;

  const
    DEFAULT_ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' +
      '¿¡¬√ƒ≈®∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰Â∏ÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ';

type

  TBibleqtIni = class
  private
    FDataPairs: TStrings;

    FBibleName, FBibleShortName, FCopyright: String;
    FIsBible: Boolean;
    FChapterString, FChapterStringPs, FChapterZeroString: String;
    FDesiredUIFont, FDesiredFontName, FInstallFonts: String;
    FChapterSign, FVerseSign: String;
    FAlphabet, FHTMLFilter, FSoundDirectory: String;
    FUseRightAlignment, FStrongsPrefixed: Boolean;

    FModuleName, FModuleAuthor, FModuleVersion, FModuleCompiler, FModuleImage: String;
    FOldTestament, FNewTestament, FApocrypha, FChapterZero, FEnglishPsalms,
    FStrongNumbers, FNoForcedLineBreaks, FUseChapterHead :Boolean;
    FDesiredFontCharset, FBookQty: Integer;

    FChapterDatas: TList<TChapterData>;
    FCategories: String;
  protected
    class function OpenBibleqtIniFile(aBibleqtIniPath: String): TStrings;
    class procedure ClearEmptyAndComments(aDataPairs: TStrings);
    procedure LoadRegularValues();
    procedure LoadPathValues(aIniPath: String);

    function ReadStringValue(aKey: String; aDefault: String = ''): String;
    function ReadIntegerValue(aKey: String; aDefault: Integer = 0): Integer;
    function ReadBooleanValue(aKey: String; aDefault: Boolean = false): Boolean;
    function StringValueToBoolean(aValue: String): Boolean;

  public
    constructor Create(aBibleqtIniPath: String);
    destructor Destroy; override;

    property IsBible: Boolean read FIsBible;
    property BibleName: String read FBibleName;
    property BibleShortName: String read FBibleShortName;
    property Copyright: String read FCopyright;
    property ModuleName: String read FModuleName;
    property ModuleAuthor: String read FModuleAuthor;
    property ModuleCompiler: String read FModuleCompiler;
    property ModuleVersion: String read FModuleVersion;
    property ModuleImage: String read FModuleImage;
    property UseRightAlignment: Boolean read FUseRightAlignment;
    property Alphabet: String read FAlphabet;
    property DesiredFontName: String read FDesiredFontName;
    property SoundDirectory: String read FSoundDirectory;
    property DesiredUIFont: String read FDesiredUIFont;
    property ChapterSign: String read FChapterSign;
    property ChapterString: String read FChapterString;
    property ChapterStringPs: String read FChapterStringPs;
    property ChapterZeroString: String read FChapterZeroString;
    property HTMLFilter: String read FHTMLFilter;
    property VerseSign: String read FVerseSign;
    property BookQty: Integer read FBookQty;
    property StrongsPrefixed: Boolean read FStrongsPrefixed;
    property DesiredFontCharset: Integer read FDesiredFontCharset;
    property InstallFonts: String read FInstallFonts;
    property Categories: String read FCategories;

    property OldTestament: Boolean read FOldTestament;
    property NewTestament: Boolean read FNewTestament;
    property Apocrypha: Boolean read FApocrypha;
    property ChapterZero: Boolean read FChapterZero;
    property EnglishPsalms: Boolean read FEnglishPsalms;
    property StrongNumbers: Boolean read FStrongNumbers;
    property NoForcedLineBreaks: Boolean read FNoForcedLineBreaks;
    property UseChapterHead: Boolean read FUseChapterHead;

    property ChapterDatas: TList<TChapterData> read FChapterDatas;

    class function GetBibleqtIni(aDirPath: String): TBibleqtIni;
  end;



implementation

{ TBibleqtINI }
uses SysUtils, StringProcs, IOUtils;


class procedure TBibleqtINI.ClearEmptyAndComments(aDataPairs: TStrings);
const
  COMMENT_CHAR = ';';
var
  i: Integer;
  CurString: String;
begin

  i := 0;

  while i < aDataPairs.Count do
  begin
    CurString := Trim(aDataPairs[i]);

    if (CurString.IsEmpty) or (CurString.StartsWith(COMMENT_CHAR)) then
    begin
      aDataPairs.Delete(i);
    end
    else
      i := i +1;

  end;

end;

constructor TBibleqtINI.Create(aBibleqtIniPath: String);
begin

  FChapterDatas := TList<TChapterData>.Create();

  FDataPairs := OpenBibleqtIniFile(aBibleqtIniPath);
  try
    LoadRegularValues();
    LoadPathValues(aBibleqtIniPath);
  finally
    FreeAndNil(FDataPairs);
  end;


end;

destructor TBibleqtINI.Destroy;
var
  i: Integer;
begin

  if Assigned(FDataPairs) then
    FreeAndNil(FDataPairs);

  for i := 0 to FChapterDatas.Count - 1 do
  begin;
    FChapterDatas[i].Free;
  end;

  inherited;
end;

class function TBibleqtINI.GetBibleqtIni(aDirPath: String): TBibleqtIni;
const
  BibleqtFile = 'bibleqt.ini';
var
  BibleqtFilePath: String;
begin

  BibleqtFilePath := TPath.Combine(aDirPath, BibleqtFile);

  if FileExists(BibleqtFilePath) then
  begin
    Result := TBibleqtINI.Create(BibleqtFilePath);
  end
  else
    Result := nil;

end;

procedure TBibleqtINI.LoadPathValues(aIniPath: String);
var
  ChapterData: TChapterData;
  i: Integer;
  Name: String;
  Value: String;
begin

  for I := 0 to FDataPairs.Count - 1 do
  begin
    Name := Trim(FDataPairs.Names[i]);
    Value := Trim(FDataPairs.ValueFromIndex[i]);

    Writeln( Format('%s = %s ', [Name, Value]));

    if Name = 'PathName' then
    begin
      ChapterData := TChapterData.Create;
      FChapterDatas.Add(ChapterData);

      ChapterData.PathName := Value;
    end
    else if Name = 'FullName' then
    begin
      if Assigned(ChapterData) then
        ChapterData.FullName := Value;
    end
    else if Name = 'ShortName' then
    begin
      if Assigned(ChapterData) then
        ChapterData.ShortName := Value;
    end
    else if Name = 'ChapterQty' then
    begin
      if Assigned(ChapterData) then
        ChapterData.ChapterQty := StrToInt(Value);
    end;

  end;
end;

procedure TBibleqtINI.LoadRegularValues;
begin
  FBibleName := ReadStringValue('BibleName');
  FBibleShortName := ReadStringValue('BibleShortName');
  FCopyright := ReadStringValue('Copyright');
  FIsBible := StringValueToBoolean(ReadStringValue('Bible'));

  FChapterString:= ReadStringValue('ChapterString');
  FChapterStringPs:= ReadStringValue('ChapterStringPs');
  FChapterZeroString := ReadStringValue('ChapterZeroString');

  FHTMLFilter := ReadStringValue('HTMLFilter');
  FAlphabet := ReadStringValue('Alphabet', DEFAULT_ALPHABET);
  FDesiredUIFont := ReadStringValue('DesiredUIFont');
  FDesiredFontName := ReadStringValue('DesiredFontName');

  FUseRightAlignment := StringValueToBoolean(ReadStringValue('UseRightAlignment'));
  FChapterSign := ReadStringValue('ChapterSign');
  FVerseSign := ReadStringValue('VerseSign');

  FSoundDirectory := ReadStringValue('SoundDirectory');
  FStrongsPrefixed := StringValueToBoolean(ReadStringValue('StrongsPrefixed'));

  FModuleName := ReadStringValue('ModuleName');
  FModuleAuthor := ReadStringValue('ModuleAuthor');
  FModuleVersion := ReadStringValue('ModuleVersion');
  FModuleCompiler := ReadStringValue('ModuleCompiler');
  FModuleImage := ReadStringValue('ModuleImage');

  FOldTestament := StringValueToBoolean(ReadStringValue('OldTestament'));
  FNewTestament := StringValueToBoolean(ReadStringValue('NewTestament'));
  FApocrypha := StringValueToBoolean(ReadStringValue('Apocrypha'));
  FChapterZero := StringValueToBoolean(ReadStringValue('ChapterZero'));
  FEnglishPsalms := StringValueToBoolean(ReadStringValue('EnglishPsalms'));
  FStrongNumbers := StringValueToBoolean(ReadStringValue('StrongNumbers'));
  FNoForcedLineBreaks := StringValueToBoolean(ReadStringValue('NoForcedLineBreaks'));
  FUseChapterHead := StringValueToBoolean(ReadStringValue('UseChapterHead'));

  FDesiredFontCharset := ReadIntegerValue('DesiredFontCharset', -1);
  FBookQty := ReadIntegerValue('BookQty');

  FInstallFonts := ReadStringValue('InstallFonts');
  FCategories := ReadStringValue('Categories');
end;

class function TBibleqtINI.OpenBibleqtIniFile(aBibleqtIniPath: String): TStrings;
var
  DataPairs: TStrings;
begin
  DataPairs := TStringList.Create();
  Result := DataPairs;

  DataPairs.NameValueSeparator := '=';
  DataPairs.LoadFromFile(aBibleqtIniPath);

  ClearEmptyAndComments(DataPairs);
end;

function TBibleqtIni.ReadBooleanValue(aKey: String; aDefault: Boolean): Boolean;
var
  StrValue: String;
begin
  Result := aDefault;

  StrValue := ReadStringValue(aKey);
  if not StrValue.IsEmpty then
    Result := StringValueToBoolean(StrValue);

end;

function TBibleqtINI.ReadIntegerValue(aKey: String; aDefault: Integer): Integer;
var
  StrValue: String;
begin
  Result := aDefault;

  StrValue := ReadStringValue(aKey);
  if not StrValue.IsEmpty then
    Result := StrToInt(StrValue);

end;

function TBibleqtINI.ReadStringValue(aKey: String; aDefault: String): String;
var S:TStrings;
begin

  Result := aDefault;

  if FDataPairs.IndexOfName(aKey) <> -1 then
    Result := Trim(FDataPairs.Values[aKey]);

end;

function TBibleqtINI.StringValueToBoolean(aValue: String): Boolean;
begin
  Result := (aValue = 'Y') or (aValue = 'y');
end;

end.
