unit NativeInfoSourceLoader;

interface

uses Classes, InfoSourceLoaderInterface, InfoSource;

  const
    MAX_BOOKQTY = 256;

  const
    DEFAULT_ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' +
      'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя';


type
  TNativeInfoSourceLoader = class(TInterfacedObject, IInfoSourceLoader)
  private
    FDataPairs: TStrings;
  
    function IsCommentary(aFileEntryPath: String): Boolean;
  protected
    class function OpenBibleqtIniFile(aBibleqtIniPath: String): TStrings;
    procedure LoadRegularValues(aInfoSource: TInfoSource);
    procedure LoadPathValues(aInfoSource: TInfoSource; aIniPath: String);
    class procedure ClearAndEmptyComments(aDataPairs: TStrings);

    function ReadStringValue(aKey: String; aDefault: String = ''): String;
    function ReadIntegerValue(aKey: String; aDefault: Integer = 0): Integer;
    function ReadBooleanValue(aKey: String; aDefault: Boolean = false): Boolean;
    function StringValueToBoolean(aValue: String): Boolean;

  public
    constructor Create;
    destructor Destroy; override;
  
    procedure LoadInfoSource(aFileEntryPath: String; aInfoSource: TInfoSource);
    class function LoadNativeInfoSource(aDirPath: String): TInfoSource;

  end;

implementation

{ TNativeInfoSourceLoader }
uses SysUtils, ChapterData, Generics.Collections, IOUtils;

constructor TNativeInfoSourceLoader.Create;
begin
  inherited Create;
end;

destructor TNativeInfoSourceLoader.Destroy;
begin

  inherited;
end;

function TNativeInfoSourceLoader.IsCommentary(aFileEntryPath: String): Boolean;
var
  S: String;
begin
  S := ExtractFileDir(aFileEntryPath);

  s := ExtractFileName(s);
  Result := UpperCase(s) = 'COMMENTARIES';
end;

procedure TNativeInfoSourceLoader.LoadInfoSource(
  aFileEntryPath: String; aInfoSource: TInfoSource);
begin

  FDataPairs := OpenBibleqtIniFile(aFileEntryPath);
  try
    LoadRegularValues(aInfoSource);
    LoadPathValues(aInfoSource, aFileEntryPath);
  finally
    FreeAndNil(FDataPairs);
  end;

end;

class function TNativeInfoSourceLoader.LoadNativeInfoSource(
  aDirPath: String): TInfoSource;
const
  BibleqtFile = 'bibleqt.ini';
var
  BibleqtFilePath: String;
  InfoSourceLoader: TNativeInfoSourceLoader;
  InfoSource : TInfoSource;
begin

  BibleqtFilePath := TPath.Combine(aDirPath, BibleqtFile);

  if FileExists(BibleqtFilePath) then
  begin
    InfoSourceLoader := TNativeInfoSourceLoader.Create;
    InfoSource := TInfoSource.Create;
    try

      InfoSourceLoader.LoadInfoSource(BibleqtFilePath, InfoSource);
  
      Result := InfoSource;
    finally
      InfoSourceLoader.Free;
    end;
  end
  else
    Result := nil;


end;

class function TNativeInfoSourceLoader.OpenBibleqtIniFile(aBibleqtIniPath: String): TStrings;
var
  DataPairs: TStrings;
begin
  DataPairs := TStringList.Create();
  Result := DataPairs;

  DataPairs.NameValueSeparator := '=';
  DataPairs.LoadFromFile(aBibleqtIniPath);

  ClearAndEmptyComments(DataPairs);
end;

procedure TNativeInfoSourceLoader.LoadRegularValues(aInfoSource: TInfoSource);
begin

  with aInfoSource do
  begin
    BibleName := ReadStringValue('BibleName');
    BibleShortName := ReadStringValue('BibleShortName');
    Copyright := ReadStringValue('Copyright');
    IsBible := StringValueToBoolean(ReadStringValue('Bible'));

    ChapterString := ReadStringValue('ChapterString');
    ChapterStringPs := ReadStringValue('ChapterStringPs');
    ChapterZeroString := ReadStringValue('ChapterZeroString');

    HTMLFilter := ReadStringValue('HTMLFilter');
    Alphabet := ReadStringValue('Alphabet', DEFAULT_ALPHABET);
    DesiredUIFont := ReadStringValue('DesiredUIFont');
    DesiredFontName := ReadStringValue('DesiredFontName');

    UseRightAlignment := StringValueToBoolean(ReadStringValue('UseRightAlignment'));
    ChapterSign := ReadStringValue('ChapterSign');
    VerseSign := ReadStringValue('VerseSign');

    SoundDirectory := ReadStringValue('SoundDirectory');
    StrongsPrefixed := StringValueToBoolean(ReadStringValue('StrongsPrefixed'));

    ModuleName := ReadStringValue('ModuleName');
    ModuleAuthor := ReadStringValue('ModuleAuthor');
    ModuleVersion := ReadStringValue('ModuleVersion');
    ModuleCompiler := ReadStringValue('ModuleCompiler');
    ModuleImage := ReadStringValue('ModuleImage');

    OldTestament := StringValueToBoolean(ReadStringValue('OldTestament'));
    NewTestament := StringValueToBoolean(ReadStringValue('NewTestament'));
    Apocrypha := StringValueToBoolean(ReadStringValue('Apocrypha'));
    ChapterZero := StringValueToBoolean(ReadStringValue('ChapterZero'));
    EnglishPsalms := StringValueToBoolean(ReadStringValue('EnglishPsalms'));
    StrongNumbers := StringValueToBoolean(ReadStringValue('StrongNumbers'));
    NoForcedLineBreaks := StringValueToBoolean(ReadStringValue('NoForcedLineBreaks'));
    UseChapterHead := StringValueToBoolean(ReadStringValue('UseChapterHead'));

    DesiredFontCharset := ReadIntegerValue('DesiredFontCharset', -1);
    BookQty := ReadIntegerValue('BookQty');

    InstallFonts := ReadStringValue('InstallFonts');
    Categories := ReadStringValue('Categories');
  end;
end;

procedure TNativeInfoSourceLoader.LoadPathValues(aInfoSource: TInfoSource; aIniPath: String);
var
  ChapterData: TChapterData;
  ChapterDatas : TList<TChapterData>;
  i: Integer;
  Name: String;
  Value: String;
begin

  aInfoSource.FileName := aIniPath;
  aInfoSource.IsCompressed := aIniPath[1]='?';
  aInfoSource.IsCommentary := IsCommentary(aIniPath);

  ChapterDatas := TList<TChapterData>.Create;
  try

  for I := 0 to FDataPairs.Count - 1 do
  begin
    Name := Trim(FDataPairs.Names[i]);
    Value := Trim(FDataPairs.ValueFromIndex[i]);

    Writeln( Format('%s = %s ', [Name, Value]));

    if Name = 'PathName' then
    begin
      ChapterData := TChapterData.Create;
      ChapterDatas.Add(ChapterData);

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


  aInfoSource.ChapterDatas := ChapterDatas;
  
  finally
    for I := 0 to ChapterDatas.Count -1 do
      ChapterDatas[i].Free;
      
    FreeAndNil(ChapterDatas);
  end;
end;


class procedure TNativeInfoSourceLoader.ClearAndEmptyComments(aDataPairs: TStrings);
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

function TNativeInfoSourceLoader.ReadBooleanValue(aKey: String; aDefault: Boolean): Boolean;
var
  StrValue: String;
begin
  Result := aDefault;

  StrValue := ReadStringValue(aKey);
  if not StrValue.IsEmpty then
    Result := StringValueToBoolean(StrValue);

end;

function TNativeInfoSourceLoader.ReadIntegerValue(aKey: String; aDefault: Integer): Integer;
var
  StrValue: String;
begin
  Result := aDefault;

  StrValue := ReadStringValue(aKey);
  if not StrValue.IsEmpty then
    Result := StrToInt(StrValue);

end;

function TNativeInfoSourceLoader.ReadStringValue(aKey: String; aDefault: String): String;
begin

  Result := aDefault;

  if FDataPairs.IndexOfName(aKey) <> -1 then
    Result := Trim(FDataPairs.Values[aKey]);

end;

function TNativeInfoSourceLoader.StringValueToBoolean(aValue: String): Boolean;
begin
  Result := (aValue = 'Y') or (aValue = 'y');
end;

end.
