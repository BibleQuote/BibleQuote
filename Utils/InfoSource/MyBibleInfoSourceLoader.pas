unit MyBibleInfoSourceLoader;

interface

uses Classes, InfoSourceLoaderInterface, InfoSource, FireDAC.Comp.Client,
 ChapterData, Generics.Collections, IOUtils;

type
  TMyBibleInfoSourceLoader = class(TInterfacedObject, IInfoSourceLoader)
  private
    function GetChapterStr(aLanguage: String): String;
    function GetChapterPsStr(aLanguage: String): String;
    procedure FreeChapterDatas(ChapterDatas: TList<TChapterData>);
  protected
    procedure LoadRegularValues(aInfoSource: TInfoSource;
              aSQLiteConnection: TFDConnection);
    procedure LoadPathValues(aInfoSource: TInfoSource; aFileEntryPath: String);
    function ExtractLastChangedDat(aHistory: String): String;
    function ExtractDat(aRow: String): String;
    procedure LoadCommentaryValues(aInfoSource: TInfoSource; aSQLiteConnection: TFDConnection);
    procedure LoadBibleValues(aInfoSource: TInfoSource; aSQLiteConnection: TFDConnection);

  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadInfoSource(aFileEntryPath: String; aInfoSource: TInfoSource);

  end;

implementation

{ TNativeInfoSourceLoader}
uses MyBibleUtils, SysUtils, ExceptionFrm, RegularExpressions, SelectEntityType;

function TMyBibleInfoSourceLoader.GetChapterPsStr(aLanguage: String): String;
begin
  if aLanguage = 'en' then
    Result:= 'Psalom'
  else
    Result := 'Псалом';

end;

function TMyBibleInfoSourceLoader.GetChapterStr(aLanguage: String): String;
begin
  if aLanguage = 'en' then
    Result:= 'Chapter'
  else
    Result := 'Глава';
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

procedure TMyBibleInfoSourceLoader.FreeChapterDatas(
  ChapterDatas: TList<TChapterData>);
var
  i: Integer;
begin
  for i := 0 to ChapterDatas.Count -1 do
    ChapterDatas[i].Free;

  ChapterDatas.Clear;
  ChapterDatas.Free();
end;

procedure TMyBibleInfoSourceLoader.LoadBibleValues(aInfoSource: TInfoSource;
  aSQLiteConnection: TFDConnection);
var
  SQLiteQuery: TFDQuery;
  BookQty: Integer;
  ChapterDatas: TList<TChapterData>;
  Language: String;

begin
  SQLiteQuery := TMyBibleUtils.CreateQuery(aSQLiteConnection);
  ChapterDatas := TList<TChapterData>.Create;

  try
    try

      Language := TMyBibleUtils.GetLanguage(SQLiteQuery);
      aInfoSource.ChapterString := TMyBibleUtils.GetChapterString(SQLiteQuery);
      aInfoSource.ChapterStringPs := TMyBibleUtils.GetChapterStringPs(SQLiteQuery);

      BookQty := TMyBibleUtils.GetBibleBookQty(SQLiteQuery, ChapterDatas);

      aInfoSource.BookQty := BookQty;
      aInfoSource.ChapterDatas := ChapterDatas;
      aInfoSource.OldTestament := BookQty in [39, 66];
      aInfoSource.NewTestament := BookQty in [27, 66];

      aInfoSource.StrongNumbers := TMyBibleUtils.GetStrong(SQLiteQuery);

    except
      on e: Exception do
      begin
        BqShowException(e);
      end;
    end;

  finally
    TMyBibleUtils.CloseQuery(SQLiteQuery);
    FreeChapterDatas(ChapterDatas);
  end;

end;

procedure TMyBibleInfoSourceLoader.LoadCommentaryValues(
  aInfoSource: TInfoSource; aSQLiteConnection: TFDConnection);
var
  SQLiteQuery: TFDQuery;
  BookQty: Integer;
  ChapterDatas: TList<TChapterData>;
  Language: String;
begin

  SQLiteQuery := TMyBibleUtils.CreateQuery(aSQLiteConnection);
  ChapterDatas := TList<TChapterData>.Create;

  try
    try

      Language := TMyBibleUtils.GetLanguage(SQLiteQuery);
      aInfoSource.ChapterString := GetChapterStr(Language);
      aInfoSource.ChapterStringPs := GetChapterPsStr(Language);

      BookQty := TMyBibleUtils.GetCommentaryBookQty(SQLiteQuery, ChapterDatas);

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
    FreeChapterDatas(ChapterDatas);
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

    aInfoSource.IsBible := TSelectEntityType.IsMyBibleBible(aFileEntryPath);
    aInfoSource.IsCommentary := TSelectEntityType.IsMyBibleCommentary(aFileEntryPath);

    LoadRegularValues(aInfoSource, SQLiteConnection);
    LoadPathValues(aInfoSource, aFileEntryPath);

    if aInfoSource.IsCommentary then
      LoadCommentaryValues(aInfoSource, SQLiteConnection)
    else if aInfoSource.IsBible then
      LoadBibleValues(aInfoSource, SQLiteConnection);


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

  // the cover image is supposed to be in the same folder as db file
  aInfoSource.ModuleImage := TPath.Combine(
    ExtractFileDir(aFileEntryPath), 'image.jpg');
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

      aInfoSource.HTMLFilter := '<t <pb ';
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
