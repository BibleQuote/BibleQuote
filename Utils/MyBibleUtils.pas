unit MyBibleUtils;

interface

uses Classes, System.Types, FireDAC.Comp.Client, Generics.Collections, ChapterData,
     Data.DB;

const

  CHAPTER_NOT_NULL_CONDITION = 'chapter_number_from is not null and verse_number_from is not null ';

type

  TMyBibleUtils = class
  private
    class function GetSingleValue(aSQLiteQuery: TFDQuery; aSqlQuery: String): String;
    class procedure GetMultiValues(aSQLiteQuery: TFDQuery; aSqlQuery:String; aLines: TStrings);
    class function GetInfoValue(aSQLiteQuery: TFDQuery; aKey: String): String;
    class function GetBookNumber(aSQLiteQuery: TFDQuery; aSourceTable: String; aBook: Integer): Integer;

    class function FillChapterDatas(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
    class procedure FillAllChapterNumbers(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>;
      aChapterNumberQueryTempl: String);
    class function FillChapterNumbers(aSQLiteQuery: TFDQuery;
      aChapterNumberQuery: String): TArray<Integer>;
    class function FillCommentaryChapterNumbers(aSQLiteQuery: TFDQuery;
      aChapterNumberQuery: String): TArray<Integer>;

  public
    class function IsTableExists(aSQLiteQuery: TFDQuery; aTableName: String): Boolean;
    class function GetCommentaryBookQty(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
    class function GetBibleBookQty(aSQLiteQuery: TFDQuery; aChapterDatas: TList<TChapterData>): Integer;
    class function GetLanguage(aSQLiteQuery: TFDQuery): String;
    class function GetIsRussianNumbering(aSQLiteQuery: TFDQuery): Boolean;
    class function GetChapterString(aSQLiteQuery: TFDQuery): String;
    class function GetChapterStringPs(aSQLiteQuery: TFDQuery): String;
    class function GetDictName(aSQLiteQuery: TFDQuery): String;
    class function GetStrong(aSQLiteQuery: TFDQuery): Boolean;
    class function GetHistory(aSQLiteQuery: TFDQuery): String;
    class function GetStyle(aSQLiteQuery: TFDQuery): String;
    class procedure FillWords(aWords: TStrings;
                    aSQLiteQuery: TFDQuery);
    class procedure GetCommentaryChapter(aSQLiteQuery: TFDQuery; aBook, aChapter: Integer; aLines: TStrings);
    class procedure GetBibleChapter(aSQLiteQuery: TFDQuery; aBook, aChapter: Integer; aLines: TStrings);
    class function GetVersesCount(aSQLiteQuery: TFDQuery; aBook, aChapter: Integer): Integer;
    class function GetBookVerses(aSQLiteQuery: TFDQuery; aBook: Integer): TStrings;
    class function GetCommentaryVerses(aSQLiteQuery: TFDQuery; aBook: Integer): TStrings;

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
  aSQLiteQuery.FetchAll();

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
var
  ChapterNumberQueryTempl: String;

begin
  Result := 0;

  aSQLiteQuery.SQL.Text := 'select C.*, books.long_name as name, books.short_name as short_name from '+
                           '(select book_number, count(*) as chapterqty from ( '+
                           ' select book_number, chapter, count(*) as verseqty from verses group by book_number, chapter '+
                           ') B group by book_number ) C left join books ON books.book_number= C.book_number';

  aSQLiteQuery.Open();
  aSQLiteQuery.FetchAll();

  try

    Result := FillChapterDatas(aSQLiteQuery, aChapterDatas);

  finally
    aSQLiteQuery.Close;
  end;

  ChapterNumberQueryTempl := 'select chapter as chapter_number, count(*) from verses where book_number=%d group by chapter';
  FillAllChapterNumbers(aSQLiteQuery, aChapterDatas, ChapterNumberQueryTempl);

end;

class function TMyBibleUtils.GetVersesCount(aSQLiteQuery: TFDQuery; aBook, aChapter: Integer): Integer;
var
  Query: String;
  CountStr: String;
begin
  Query := Format('SELECT count(verse) FROM [verses] where book_number=%d and chapter=%d order by verse', [aBook, aChapter]);
  CountStr := GetSingleValue(aSQLiteQuery, Query);
  Result := StrToInt(CountStr);
end;

class function TMyBibleUtils.GetBookVerses(aSQLiteQuery: TFDQuery; aBook: Integer): TStrings;
var
  Query: String;
  Verses: TStringList;
  VerseText: String;
  VerseMeta: TVerseMeta;
begin
  Verses := TStringList.Create();
  Query := Format('SELECT text, chapter, verse FROM [verses] where book_number=%d order by chapter, verse', [aBook]);

  aSQLiteQuery.SQL.Text := Query;
  aSQLiteQuery.Open();
  aSQLiteQuery.FetchAll();

  try

    while not aSQLiteQuery.Eof do
    begin
      try
        VerseText := aSQLiteQuery.Fields[0].AsString;

        VerseMeta := TVerseMeta.Create;
        VerseMeta.ChapterNumber := aSQLiteQuery.Fields[1].AsInteger;
        VerseMeta.VerseNumber   := aSQLiteQuery.Fields[2].AsInteger;

        Verses.AddObject(VerseText, VerseMeta);
      except
        // failed to read/parse verse, skip it
      end;

      aSQLiteQuery.Next;
    end;

  finally
    aSQLiteQuery.Close;
  end;

  Result := Verses;
end;

class function TMyBibleUtils.GetCommentaryVerses(aSQLiteQuery: TFDQuery; aBook: Integer): TStrings;
var
  Query: String;
  Verses: TStringList;
  VerseText: String;
  VerseMeta: TVerseMeta;
begin
  Verses := TStringList.Create();
  Query := Format('SELECT text, chapter_number_from, verse_number_from FROM [commentaries] where book_number=%d', [aBook]);

  aSQLiteQuery.SQL.Text := Query;
  aSQLiteQuery.Open();
  aSQLiteQuery.FetchAll();

  try

    while not aSQLiteQuery.Eof do
    begin
      try
        VerseText := aSQLiteQuery.Fields[0].AsString;

        VerseMeta := TVerseMeta.Create;
        VerseMeta.ChapterNumber := aSQLiteQuery.Fields[1].AsInteger;
        VerseMeta.VerseNumber   := aSQLiteQuery.Fields[2].AsInteger;

        Verses.AddObject(VerseText, VerseMeta);
      finally
        // failed to read/parse verse, skip it
      end;

      aSQLiteQuery.Next;
    end;

  finally
    aSQLiteQuery.Close;
  end;

  Result := Verses;
end;

class procedure TMyBibleUtils.GetBibleChapter(aSQLiteQuery: TFDQuery; aBook,
  aChapter: Integer; aLines: TStrings);
var
  Query: String;
begin

  Query:= Format('SELECT verse || '' '' || text FROM [verses] where book_number=%d  and chapter=%d order by verse', [aBook, aChapter]);
  GetMultiValues(aSQLiteQuery, Query, aLines);

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
  Query: String;
  ChapterNumberQueryTempl: String;

  ChapterNumberQuery: String;
  ChapterNumbers: TIntegerDynArray;
  i: Integer;
  BookNumber: Integer;
begin
  Result := 0;

  Query:= 'select book_number from commentaries group by book_number order by book_number';

  if IsTableExists(aSQLiteQuery, 'books') then
  begin
    Query := 'select C.*, books.short_name as name from ('+
             Query+
             ') C left join books ON books.book_number= C.book_number';
  end;

  aSQLiteQuery.SQL.Text := Query;
  aSQLiteQuery.Open();
  aSQLiteQuery.FetchAll();

  try
    Result := FillChapterDatas(aSQLiteQuery, aChapterDatas);
  finally
    aSQLiteQuery.Close;
  end;

  ChapterNumberQueryTempl :=
    'select chapter_number_from, chapter_number_to from commentaries where book_number=%d and chapter_number_from is not null';

  for i := 0 to aChapterDatas.Count - 1 do
  begin
    BookNumber := aChapterDatas[i].BookNumber;
    ChapterNumberQuery := Format(ChapterNumberQueryTempl, [BookNumber]);
    ChapterNumbers := FillCommentaryChapterNumbers(aSQLiteQuery, ChapterNumberQuery );
    aChapterDatas[i].ChapterNumbers := Copy(ChapterNumbers, 0, Length(ChapterNumbers));
  end;
end;


class function TMyBibleUtils.GetLanguage(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'language');
end;

class procedure TMyBibleUtils.GetMultiValues(aSQLiteQuery: TFDQuery;
  aSqlQuery: String; aLines: TStrings);
begin

  aSQLiteQuery.SQL.Text := aSqlQuery;
  aSQLiteQuery.Open();
  aSQLiteQuery.FetchAll();

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

class function TMyBibleUtils.GetDictName(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'description');
end;

class function TMyBibleUtils.GetStrong(aSQLiteQuery: TFDQuery): Boolean;
begin
// wrong property name
//  Result := GetInfoValue(aSQLiteQuery, 'is_strong') = 'true';
  Result := GetInfoValue(aSQLiteQuery, 'strong_numbers') = 'true';
end;

class function TMyBibleUtils.GetHistory(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'history_of_changes');
end;

class function TMyBibleUtils.GetStyle(aSQLiteQuery: TFDQuery): String;
begin
  Result := GetInfoValue(aSQLiteQuery, 'html_style');
end;

class function TMyBibleUtils.FillChapterDatas(aSQLiteQuery: TFDQuery;
  aChapterDatas: TList<TChapterData>): Integer;
var
  BookQty: Integer;
  ChapterData: TChapterData;
  BookName : String;
  ShortName: String;
begin
  BookQty := 0;

  while not aSQLiteQuery.Eof do
  begin

    ChapterData:= TChapterData.Create();
    BookName := '';

    ChapterData.BookNumber := aSQLiteQuery.FieldByName('book_number').AsInteger;

    if aSQLiteQuery.FindField('name') <> nil then
      BookName := aSQLiteQuery.FieldByName('name').AsString;

    if (BookName.IsEmpty) then
    begin
      BookName := Lang.SayDefault(Format('StrMyBibleBook%d', [ChapterData.BookNumber]), '');
      if BookName.IsEmpty then
      begin
        BookName := Lang.SayDefault(Format('StrMyBibleBookOther', [ChapterData.BookNumber]), '');
        if not (BookName.IsEmpty) then
          BookName := BookName + ' ' + IntToStr(ChapterData.BookNumber)
        else
          BookName := IntToStr(ChapterData.BookNumber);
      end;
    end;

    ShortName := ChapterData.FullName;
    if aSQLiteQuery.FindField('short_name') <> nil then
      ShortName := aSQLiteQuery.FieldByName('short_name').AsString;

    ChapterData.FullName := BookName;
    ChapterData.ShortName := StringReplace(ShortName, ' ', '', [rfReplaceAll]);

    aChapterDatas.Add(ChapterData);

    BookQty := BookQty + 1;

    aSQLiteQuery.Next();
  end;

  Result := BookQty;

end;

class procedure TMyBibleUtils.FillAllChapterNumbers(aSQLiteQuery: TFDQuery;
  aChapterDatas: TList<TChapterData>; aChapterNumberQueryTempl: String);
var
  ChapterNumberQuery: String;
  ChapterNumbers: TIntegerDynArray;
  i: Integer;
  BookNumber: Integer;
begin

  for i := 0 to aChapterDatas.Count - 1 do
  begin
    BookNumber := aChapterDatas[i].BookNumber;
    ChapterNumberQuery := Format( aChapterNumberQueryTempl, [BookNumber]);
    ChapterNumbers := FillChapterNumbers(aSQLiteQuery, ChapterNumberQuery );
    aChapterDatas[i].ChapterNumbers := Copy(ChapterNumbers, 0, Length(ChapterNumbers));
  end;

end;

class function TMyBibleUtils.FillCommentaryChapterNumbers(aSQLiteQuery: TFDQuery;
  aChapterNumberQuery: String): TArray<Integer>;
var
  ChapterFrom, ChapterTo, TempVal: Integer;
  FieldTo: TField;
  ChapterDict: TDictionary<Integer, Integer>;
  Chapter: Integer;
begin
  aSQLiteQuery.Close();
  aSQLiteQuery.SQL.Text := aChapterNumberQuery;
  aSQLiteQuery.Open();
  aSQLiteQuery.FetchAll();

  try

    ChapterDict := TDictionary<Integer, Integer>.Create();
    aSQLiteQuery.First;

    while not aSQLiteQuery.Eof do
    begin
      ChapterFrom := aSQLiteQuery.FieldByName('chapter_number_from').AsInteger;
      ChapterTo := ChapterFrom;

      FieldTo := aSQLiteQuery.FieldByName('chapter_number_to');
      if not (FieldTo.IsNull) then
      begin
        TempVal := FieldTo.AsInteger;
        if TempVal > ChapterFrom then
          ChapterTo := TempVal;
      end;

      for Chapter := ChapterFrom to ChapterTo do
        ChapterDict.AddOrSetValue(Chapter, 0);

      aSQLiteQuery.Next;
    end;

    Result := ChapterDict.Keys.ToArray;
    TArray.Sort<Integer>(Result);
  finally
    aSQLiteQuery.Close;
  end;

end;

class function TMyBibleUtils.FillChapterNumbers(aSQLiteQuery: TFDQuery;
  aChapterNumberQuery: String): TArray<Integer>;
var

  i: Integer;
begin
  aSQLiteQuery.Close();
  aSQLiteQuery.SQL.Text := aChapterNumberQuery;
  aSQLiteQuery.Open();
  aSQLiteQuery.FetchAll();

  try

    i := 0;

    SetLength(Result, aSQLiteQuery.RecordCount);
    aSQLiteQuery.First;

    while not aSQLiteQuery.Eof do
    begin

      Result[i] := aSQLiteQuery.FieldByName('chapter_number').AsInteger;

      i := i+1;
      aSQLiteQuery.Next;
    end;

  finally
    aSQLiteQuery.Close;
  end;

end;

class procedure TMyBibleUtils.FillWords(aWords: TStrings;
  aSQLiteQuery: TFDQuery);
begin
  aSQLiteQuery.SQL.Text := 'SELECT topic FROM [dictionary]';
  aSQLiteQuery.Open();
  aSQLiteQuery.FetchAll();

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
  Query: String;
begin
  Query := Format(
    'SELECT text FROM [commentaries] ' +
    'where book_number=%0:d and (chapter_number_from=%1:d or (chapter_number_to is not null and chapter_number_from<=%1:d and chapter_number_to>=%1:d)) ' +
    'order by chapter_number_from', [aBook, aChapter]);

  GetMultiValues(aSQLiteQuery, Query, aLines);
end;

class function TMyBibleUtils.GetIsRussianNumbering(aSQLiteQuery: TFDQuery): Boolean;
begin
  Result := GetInfoValue(aSQLiteQuery, 'russian_numbering') = 'true';
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
