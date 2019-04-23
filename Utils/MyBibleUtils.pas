unit MyBibleUtils;

interface

uses Classes, FireDAC.Comp.Client, Generics.Collections, ChapterData;

type

  TMyBibleUtils = class
  private
    class function GetSingleValue(aSQLiteQuery: TFDQuery; aSqlQuery: String): String;
    class function GetInfoValue(aSQLiteQuery: TFDQuery; aKey: String): String;
    class function GetBookNumber(aSQLiteQuery: TFDQuery; aSourceTable: String; aBook: Integer): Integer;
    class function FillChapterDatas(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
    class function IsTableExists(aSQLiteQuery: TFDQuery; aTableName: String): Boolean;
  public
    class function GetCommentaryBookQty(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
    class function GetBibleBookQty(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
    class function GetLanguage(aSQLiteQuery: TFDQuery): String;
    class function GetChapterString(aSQLiteQuery: TFDQuery): String;
    class function GetChapterStringPs(aSQLiteQuery: TFDQuery): String;
    class function GetDictName(aSQLiteQuery: TFDQuery): String;
    class function GetStrong(aSQLiteQuery: TFDQuery): Boolean;
    class function GetHistory(aSQLiteQuery: TFDQuery): String;
    class procedure FillWords(aWords: TStrings;
                    aSQLiteQuery: TFDQuery);
    class procedure GetCommentaryChapter(aSQLiteQuery: TFDQuery; aBook, aChapter: Integer; aLines: TStrings);
    class procedure GetBibleChapter(aSQLiteQuery: TFDQuery; aBook, aChapter: Integer; aLines: TStrings);

    class function OpenDatabase(aFileEntryPath: String): TFDConnection;
    class procedure CloseDatabase(aSQLiteConnection: TFDConnection);
    class function CreateQuery(aSQLiteConnection: TFDConnection): TFDQuery; overload;
    class function CreateQuery(aFileEntryPath: String): TFDQuery; overload;
    class procedure CloseQuery(aSQLiteQuery: TFDQuery);
    class procedure CloseOpenConnection(aSQLiteQuery: TFDQuery);

  end;

implementation

uses SysUtils, BibleQuoteUtils;

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

class function TMyBibleUtils.GetBibleBookQty(aSQLiteQuery: TFDQuery;
  aChapterDatas: TList<TChapterData>): Integer;
begin
  Result := 0;

  aSQLiteQuery.SQL.Text := 'select C.*, books.long_name as name from '+
                           '(select book_number, count(*) as chapterqty from ( '+
                           ' select book_number, chapter, count(*) as verseqty from verses group by book_number, chapter '+
                           ') B group by book_number ) C left join books ON books.book_number= C.book_number';
  aSQLiteQuery.Open();

  try

    Result := FillChapterDatas(aSQLiteQuery, aChapterDatas);

  finally
    aSQLiteQuery.Close;
  end;

end;

class procedure TMyBibleUtils.GetBibleChapter(aSQLiteQuery: TFDQuery; aBook,
  aChapter: Integer; aLines: TStrings);
var
  BookNumber: Integer;
  ChapterText: string;
begin

  BookNumber := GetBookNumber(aSQLiteQuery, 'verses', aBook);

  aSQLiteQuery.SQL.Text := Format('SELECT text FROM [verses] where book_number=%d  and chapter=%d', [BookNumber, aChapter]);
  aSQLiteQuery.Open();

  try

    while not aSQLiteQuery.Eof do
    begin
      aLines.Add(aSQLiteQuery.Fields[0].AsString);
      aSQLiteQuery.Next;
    end;

  finally
    aSQLiteQuery.Close;
  end;

end;

class function TMyBibleUtils.GetBookNumber(aSQLiteQuery: TFDQuery; aSourceTable: String;
  aBook: Integer): Integer;
var
  BookNumber: String;
begin

  Result := 0;

  BookNumber := GetSingleValue(aSQLiteQuery,
    Format('SELECT book_number, count(*) FROM [%s] group by book_number order by book_number limit 1 offset %d', [aSourceTable, aBook-1]));

  if BookNumber.IsEmpty then exit;

  Result := StrToInt(BookNumber);

end;

class function TMyBibleUtils.GetCommentaryBookQty(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
var
  BookTableExist: Boolean;
  Query: String;
begin
  Result := 0;

  Query:= 'SELECT book_number, count(*) as chapterqty FROM commentaries group by book_number order by book_number';

  if IsTableExists(aSQLiteQuery, 'books') then
  begin
    Query := 'select C.*, books.short_name as name from ('+
             Query+
             ') C left join books ON books.book_number= C.book_number';
  end;

  aSQLiteQuery.SQL.Text := Query;
  aSQLiteQuery.Open();

  try

    Result := FillChapterDatas(aSQLiteQuery, aChapterDatas);

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


class function TMyBibleUtils.FillChapterDatas(aSQLiteQuery: TFDQuery;
  aChapterDatas: TList<TChapterData>): Integer;
var
  BookQty: Integer;
  ChapterData: TChapterData;
  BookName : String;
  BookNumber: Integer;
begin
  BookQty := 0;

  while not aSQLiteQuery.Eof do
  begin

    ChapterData:= TChapterData.Create;
    BookName := '';


    if aSQLiteQuery.FindField('name') <> nil then
      BookName := aSQLiteQuery.FieldByName('name').AsString;

    if (BookName.IsEmpty) then begin
      BookNumber := aSQLiteQuery.FieldByName('book_number').AsInteger;
      BookName := Lang.Say(Format('StrMyBibleBook%d', [BookNumber]));
    end;

    ChapterData.FullName := BookName;
    ChapterData.ShortName := ChapterData.FullName;
    ChapterData.ChapterQty := aSQLiteQuery.FieldByName('chapterqty').AsInteger;
    aChapterDatas.Add(ChapterData);

    BookQty := BookQty + 1;

    aSQLiteQuery.Next();
  end;

  Result := BookQty;

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

class procedure TMyBibleUtils.GetCommentaryChapter(aSQLiteQuery: TFDQuery; aBook,
  aChapter: Integer; aLines: TStrings);
var
  BookNumber: Integer;
  ChapterText: string;
begin

  BookNumber := GetBookNumber(aSQLiteQuery, 'commentaries', aBook);

  ChapterText := GetSingleValue(aSQLiteQuery,
    Format('SELECT text FROM [commentaries] where book_number=%d order by chapter_number_from limit 1 offset %d', [BookNumber, aChapter-1]));

  aLines.Add(ChapterText);
end;

class function TMyBibleUtils.GetChapterString(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'chapter_string');
end;

class function TMyBibleUtils.GetChapterStringPs(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'chapter_string_ps');
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


class function TMyBibleUtils.IsTableExists(aSQLiteQuery: TFDQuery;
  aTableName: String): Boolean;
var
  Name :String;
begin

  Name := GetSingleValue(aSQLiteQuery, Format('SELECT name FROM sqlite_master WHERE type=''table'' AND name like ''%s''', [aTableName]));

  Result := not Name.IsEmpty;

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
