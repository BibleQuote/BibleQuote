unit MyBibleUtils;

interface

uses Classes, FireDAC.Comp.Client, Generics.Collections, ChapterData;

type

  TMyBibleUtils = class
  private
    class function GetSingleValue(aSQLiteQuery: TFDQuery; aSqlQuery: String): String;
    class function GetInfoValue(aSQLiteQuery: TFDQuery; aKey: String): String;
    class function GetBookNumber(aSQLiteQuery: TFDQuery; aBook: Integer): Integer;
  public
    class function GetBookQty(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
    class function GetLanguage(aSQLiteQuery: TFDQuery): String;
    class function GetDictName(aSQLiteQuery: TFDQuery): String;
    class function GetStrong(aSQLiteQuery: TFDQuery): Boolean;
    class function GetHistory(aSQLiteQuery: TFDQuery): String;
    class procedure FillWords(aWords: TStrings;
                    aSQLiteQuery: TFDQuery);
    class function GetChapter(aSQLiteQuery: TFDQuery; aBook, aChapter: Integer): String;

    class function OpenDatabase(aFileEntryPath: String): TFDConnection;
    class procedure CloseDatabase(aSQLiteConnection: TFDConnection);
    class function CreateQuery(aSQLiteConnection: TFDConnection): TFDQuery; overload;
    class function CreateQuery(aFileEntryPath: String): TFDQuery; overload;
    class procedure CloseQuery(aSQLiteQuery: TFDQuery);
    class procedure CloseOpenConnection(aSQLiteQuery: TFDQuery);

  end;

implementation

uses SysUtils;

class function TMyBibleUtils.GetSingleValue(aSQLiteQuery: TFDQuery;
  aSqlQuery: String): String;
begin
  Result := '';

  aSQLiteQuery.SQL.Text := aSqlQuery;
  aSQLiteQuery.Open();

  try

    if aSQLiteQuery.Eof then exit;

    Result := aSQLiteQuery.Fields[0].AsString;

  finally
    aSQLiteQuery.Close;
  end;

end;

class function TMyBibleUtils.GetInfoValue(aSQLiteQuery: TFDQuery;
  aKey: String): String;
begin

  Result := GetSingleValue(aSQLiteQuery, Format('SELECT value FROM [info] where Name="%s"', [aKey]))

end;

class function TMyBibleUtils.GetBookNumber(aSQLiteQuery: TFDQuery;
  aBook: Integer): Integer;
var
  BookNumber: String;
begin

  Result := 0;

  BookNumber := GetSingleValue(aSQLiteQuery,
    Format('SELECT book_number, count(*) FROM [commentaries] group by book_number order by book_number limit 1 offset %d', [aBook-1]));

  if BookNumber.IsEmpty then exit;

  Result := StrToInt(BookNumber);

end;

class function TMyBibleUtils.GetBookQty(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
var
  ChapterData: TChapterData;
  BookQty: Integer;
begin
  Result := 0;

  aSQLiteQuery.SQL.Text := 'SELECT book_number, count(*) as chapterqty FROM commentaries group by book_number order by book_number';
  aSQLiteQuery.Open();

  try
    if aSQLiteQuery.Eof then exit;

    BookQty := 0;

    while not aSQLiteQuery.Eof do
    begin

      ChapterData:= TChapterData.Create;
      ChapterData.FullName := 'Book '+ aSQLiteQuery.FieldByName('book_number').AsString;
      ChapterData.ShortName := ChapterData.FullName;
      ChapterData.ChapterQty := aSQLiteQuery.FieldByName('chapterqty').AsInteger;
      aChapterDatas.Add(ChapterData);

      BookQty := BookQty + 1;

      aSQLiteQuery.Next();
    end;

    Result := BookQty;

  finally
    aSQLiteQuery.Close;
  end;

end;


class function TMyBibleUtils.GetLanguage(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'language');
end;

class function TMyBibleUtils.GetDictName(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'description');
end;

class function TMyBibleUtils.GetStrong(aSQLiteQuery: TFDQuery): Boolean;
begin
  Result := GetInfoValue(aSQLiteQuery, 'is_strong') = 'true';
end;


class function TMyBibleUtils.GetHistory(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'history_of_changes');
end;


class procedure TMyBibleUtils.FillWords(aWords: TStrings;
  aSQLiteQuery: TFDQuery);
begin
  aSQLiteQuery.SQL.Text := 'SELECT topic FROM [dictionary]';
  aSQLiteQuery.Open();

  try

    while not aSQLiteQuery.Eof do
    begin
      aWords.Add(aSQLiteQuery.FieldByName('topic').AsString);

      aSQLiteQuery.Next();
    end;

  finally
    aSQLiteQuery.Close;
  end;
end;

class function TMyBibleUtils.GetChapter(aSQLiteQuery: TFDQuery; aBook,
  aChapter: Integer): String;
var
  BookNumber: Integer;

begin
  Result := '';

  BookNumber := GetBookNumber(aSQLiteQuery, aBook);

  Result := GetSingleValue(aSQLiteQuery,
    Format('SELECT text FROM [commentaries] where book_number=%d order by chapter_number_from limit 1 offset %d', [BookNumber, aChapter-1]));

end;

class function TMyBibleUtils.OpenDatabase(aFileEntryPath: String): TFDConnection;
var
  SQLiteConnection: TFDConnection;
begin

  if not FileExists(aFileEntryPath) then
    raise Exception.Create(Format('Cannot open SQLite dabase: %s', [aFileEntryPath]));


  SQLiteConnection := TFDConnection.Create(nil);
  SQLiteConnection.DriverName := 'SQLite';

  SQLiteConnection.Params.Values['Database'] := aFileEntryPath;
  SQLiteConnection.Open();

  Result := SQLiteConnection;
end;


class procedure TMyBibleUtils.CloseDatabase(aSQLiteConnection: TFDConnection);
begin
  aSQLiteConnection.Close;
  aSQLiteConnection.Free;
end;

class procedure TMyBibleUtils.CloseOpenConnection(aSQLiteQuery: TFDQuery);
begin
  aSQLiteQuery.Connection.Close();
  aSQLiteQuery.Connection.Free();
  aSQLiteQuery.Close();
  aSQLiteQuery.Free();
end;

class procedure TMyBibleUtils.CloseQuery(aSQLiteQuery: TFDQuery);
begin
  aSQLiteQuery.Connection.Close();
  aSQLiteQuery.Close();
  aSQLiteQuery.Free();
end;

class function TMyBibleUtils.CreateQuery(aFileEntryPath: String): TFDQuery;
var
  SQLiteConnection: TFDConnection;
begin
  SQLiteConnection := OpenDatabase(aFileEntryPath);
  Result := CreateQuery(SQLiteConnection);
end;

class function TMyBibleUtils.CreateQuery(
  aSQLiteConnection: TFDConnection): TFDQuery;
var
  SQLiteQuery: TFDQuery;
begin
  SQLiteQuery := TFDQuery.Create(nil);
  SQLiteQuery.Connection := aSQLiteConnection;

  Result := SQLiteQuery;
end;

end.
