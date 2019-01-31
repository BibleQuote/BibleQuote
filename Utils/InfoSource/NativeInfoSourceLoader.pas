unit NativeInfoSourceLoader;

interface

uses Classes, InfoSourceLoaderInterface, InfoSource, RegularExpressions;

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
    class function TrimName(aRow: String): String;
    class function TrimNameEvaluator(const Match: TMatch): String;
  protected
    class function OpenBibleqtIniFile(aInfoSource: TInfoSource; aBibleqtIniPath: String): TStrings;
    procedure LoadRegularValues(aInfoSource: TInfoSource);
    procedure LoadPathValues(aInfoSource: TInfoSource; aIniPath: String);
    class procedure RemoveGarbage(aDataPairs: TStrings);

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
uses SysUtils, ChapterData, Generics.Collections, IOUtils, SelectEntityType,
    IOProcs;

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
var
  BibleqtIniPath: String;  
begin

  BibleqtIniPath := TSelectEntityType.FormBibleqtIniPath(aFileEntryPath);

  FDataPairs := OpenBibleqtIniFile(aInfoSource, BibleqtIniPath);
  try
    LoadRegularValues(aInfoSource);
    LoadPathValues(aInfoSource, BibleqtIniPath);
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

class function TNativeInfoSourceLoader.OpenBibleqtIniFile(aInfoSource: TInfoSource;
   aBibleqtIniPath: String): TStrings;
var
  DataPairs: TStrings;
  FileText: String;
begin
  aInfoSource.DefaultEncoding := LoadBibleqtIniFileEncoding(aBibleqtIniPath, aInfoSource.DefaultEncoding);
  FileText := ReadTextFile(aBibleqtIniPath, aInfoSource.DefaultEncoding);

  DataPairs := TStringList.Create();
  Result := DataPairs;

  DataPairs.NameValueSeparator := '=';
  DataPairs.Text := FileText;

  RemoveGarbage(DataPairs);
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


class procedure TNativeInfoSourceLoader.RemoveGarbage(aDataPairs: TStrings);
const
  COMMENT_CHAR = ';';
var
  i: Integer;
  CurString: String;
begin

  i := 0;

  while i < aDataPairs.Count do
  begin
    CurString := aDataPairs[i].Trim;

    if (CurString.IsEmpty) or (CurString.StartsWith(COMMENT_CHAR)) then
    begin
      aDataPairs.Delete(i);
    end
    else
    begin
      aDataPairs[i] := TrimName(CurString);

      i := i +1;
    end;
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

class function TNativeInfoSourceLoader.TrimName(aRow: String): String;
var
  Options: TRegExOptions;
  RegEx: TRegEx;
begin
  Result := aRow;

  Options := [roMultiLine];

  RegEx := TRegEx.Create('(?P<name>.*?)=(?P<rest>.*)', Options);

  if RegEx.IsMatch(aRow) then
  begin
    Result := RegEx.Replace(aRow, TrimNameEvaluator);
  end;


end;

class function TNativeInfoSourceLoader.TrimNameEvaluator(const Match: TMatch): String;
var
  gc: Integer;
  Name, Value: String;
begin
  Result := Match.Value;

  if Match.Groups.Count < 0  then exit;

  gc := Match.Groups.Count;
  if Match.Groups.Count >=3 then
  begin
      Name:= Match.Groups[1].Value.Trim;
      Value:= Match.Groups[2].Value;
      Result:= Format('%s=%s', [Name, Value]);
  end;
end;

end.
