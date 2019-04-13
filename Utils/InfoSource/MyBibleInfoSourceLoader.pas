unit MyBibleInfoSourceLoader;

interface

uses Classes, InfoSourceLoaderInterface, InfoSource, FireDAC.Comp.Client;

type
  TMyBibleInfoSourceLoader = class(TInterfacedObject, IInfoSourceLoader)
  private
    function GetChapterStr(aLanguage: String): String;
    function GetChapterPsStr(aLanguage: String): String;
  protected
    procedure LoadRegularValues(aInfoSource: TInfoSource;
              aSQLiteConnection: TFDConnection);
    procedure LoadPathValues(aInfoSource: TInfoSource; aFileEntryPath: String);
    function ExtractLastChangedDat(aHistory: String): String;
    function ExtractDat(aRow: String): String;
    procedure LoadCommentaryValues(aInfoSource: TInfoSource;
              aSQLiteConnection: TFDConnection);


  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadInfoSource(aFileEntryPath: String; aInfoSource: TInfoSource);

  end;

implementation

{ TNativeInfoSourceLoader}
uses MyBibleUtils, SysUtils, ExceptionFrm, RegularExpressions, ChapterData,
  Generics.Collections, SelectEntityType;

function TMyBibleInfoSourceLoader.GetChapterPsStr(aLanguage: String): String;
begin
  if aLanguage = 'en' then
    Result:= 'Psalom'
  else
    Result := 'ѕсалом';

end;

function TMyBibleInfoSourceLoader.GetChapterStr(aLanguage: String): String;
begin
  if aLanguage = 'en' then
    Result:= 'Chapter'
  else
    Result := '√лава';
end;


constructor TMyBibleInfoSourceLoader.Create;
begin
  inherited Create;
end;

destructor TMyBibleInfoSourceLoader.Destroy;
begin

  inherited;
end;

function TMyBibleInfoSourceLoader.ExtractDat(aRow: String): String;
var
  RegEx: TRegEx;
  Options: TRegExOptions;
  MatchCollection: TMatchCollection;
begin

  Result := '';

  Options := [roSingleLine, roIgnoreCase, roExplicitCapture];

  RegEx := TRegEx.Create('\((?P<lastdat>.*?)\).*', Options);

  if not RegEx.IsMatch(aRow) then exit;

  MatchCollection := RegEx.Matches(aRow);

  if MatchCollection.Count = 0 then exit;

  Result := MatchCollection[0].Groups.Item[1].Value;

end;

function TMyBibleInfoSourceLoader.ExtractLastChangedDat(
  aHistory: String): String;
var
  Histories: TStrings;
begin
  Result := '';

  Histories := TStringList.Create;
  try
    Histories.Text := aHistory;

    if Histories.Count = 0 then exit;

    Result := ExtractDat(Histories[0]);

  finally
    Histories.Free;
  end;
end;

procedure TMyBibleInfoSourceLoader.LoadCommentaryValues(
  aInfoSource: TInfoSource; aSQLiteConnection: TFDConnection);
var
  SQLiteQuery: TFDQuery;
  BookQty: Integer;
  History: String;
  ChapterDatas: TList<TChapterData>;
  I: Integer;
  Language: String;
begin

  SQLiteQuery := TMyBibleUtils.CreateQuery(aSQLiteConnection);
  ChapterDatas := TList<TChapterData>.Create;

  try
    try

      Language := TMyBibleUtils.GetLanguage(SQLiteQuery);
      aInfoSource.ChapterString := GetChapterStr(Language);
      aInfoSource.ChapterStringPs := GetChapterPsStr(Language);

      BookQty := TMyBibleUtils.GetBookQty(SQLiteQuery, ChapterDatas);

      aInfoSource.BookQty := BookQty;
      aInfoSource.ChapterDatas := ChapterDatas;

      aInfoSource.StrongNumbers := TMyBibleUtils.GetStrong(SQLiteQuery);

    except
      on e: Exception do
      begin
        BqShowException(e);
      end;
    end;

  finally
    TMyBibleUtils.CloseQuery(SQLiteQuery);

    for I := 0 to ChapterDatas.Count -1 do
      ChapterDatas[i].Free;
    ChapterDatas.Clear;
    ChapterDatas.Free();
  end;


end;

procedure TMyBibleInfoSourceLoader.LoadInfoSource(aFileEntryPath: String;
  aInfoSource: TInfoSource);
var
  SQLiteConnection: TFDConnection;
begin

  SQLiteConnection := TFDConnection.Create(nil);
  SQLiteConnection.DriverName := 'SQLite';

  SQLiteConnection.Params.Values['Database'] := aFileEntryPath;
  SQLiteConnection.Open();

  try

    aInfoSource.IsCommentary := TSelectEntityType.IsMyBibleCommentary(aFileEntryPath);

    LoadRegularValues(aInfoSource, SQLiteConnection);
    LoadPathValues(aInfoSource, aFileEntryPath);

    if aInfoSource.IsCommentary then
      LoadCommentaryValues(aInfoSource, SQLiteConnection);


  finally
    SQLiteConnection.Close;
    SQLiteConnection.Free;
  end;

end;

procedure TMyBibleInfoSourceLoader.LoadPathValues(aInfoSource: TInfoSource;
  aFileEntryPath: String);
begin
  aInfoSource.FileName := aFileEntryPath;
  aInfoSource.IsCompressed := false;

end;

procedure TMyBibleInfoSourceLoader.LoadRegularValues(aInfoSource: TInfoSource;
  aSQLiteConnection: TFDConnection);
var
  SQLiteQuery: TFDQuery;
  DictName: String;
  History: String;
begin

  SQLiteQuery := TMyBibleUtils.CreateQuery(aSQLiteConnection);

  try
    try

      DictName := TMyBibleUtils.GetDictName(SQLiteQuery);
      History := TMyBibleUtils.GetHistory(SQLiteQuery);

      aInfoSource.BibleName := DictName;
      aInfoSource.BibleShortName := DictName;
      aInfoSource.ModuleVersion := ExtractLastChangedDat(History);

      aInfoSource.StrongNumbers := TMyBibleUtils.GetStrong(SQLiteQuery);

    except
      on e: Exception do
      begin
        BqShowException(e);
      end;
    end;

  finally
    TMyBibleUtils.CloseQuery(SQLiteQuery);
  end;

end;


end.
