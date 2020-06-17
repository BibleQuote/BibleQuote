unit MyBibleSourceReader;

interface

uses SourceReader, System.Classes, InfoSource, MyBibleUtils, Sets,
     FireDAC.Comp.Client, System.RegularExpressions, Bible, BibleQuoteUtils,
     LinksParser, SysUtils;

type
  TMyBibleSourceReader = class(TSourceReader)
  private
    procedure ClearMyBibleTags(var aLines: TStrings);
  public
    constructor Create(Bible: TBible);

    function GetBibleChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean; override;
    function GetCommentaryChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean; override;
    function CountVerses(aBook, aChapter: Integer): Integer; override;
    function GetBookVerses(aBook: Integer): TStrings; override;
    function GetSpecialSearchSections(): TStrings; override;
    function ParseLisks(Query: String; var FormattedQuery: String): TIntSet; override;
    function GetSectionBooks(SectionIndex: Integer): TIntSet; override;
  end;

implementation

constructor TMyBibleSourceReader.Create(Bible: TBible);
begin
  inherited Create(Bible);
end;

function TMyBibleSourceReader.GetBibleChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean;
var
  SQLiteQuery: TFDQuery;
begin
  Result := False;

  SQLiteQuery := TMyBibleUtils.CreateQuery(FBible.Path);
  try

    TMyBibleUtils.GetBibleChapter(SQLiteQuery, aBook, aChapter, aLines);

//    remove strong tags from html
//    ClearMyBibleTags(aLines);

    Result := True;
  finally
    TMyBibleUtils.CloseOpenConnection(SQLiteQuery);
  end;
end;

function TMyBibleSourceReader.GetCommentaryChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean;
var
  SQLiteQuery: TFDQuery;
begin
  Result := False;

  SQLiteQuery := TMyBibleUtils.CreateQuery(FBible.Path);
  try

    TMyBibleUtils.GetCommentaryChapter(SQLiteQuery, aBook, aChapter, aLines);

    Result := True;
  finally
    TMyBibleUtils.CloseOpenConnection(SQLiteQuery);
  end;
end;

procedure TMyBibleSourceReader.ClearMyBibleTags(var aLines: TStrings);
var
  i: Integer;
  RegEx: TRegEx;
  Options: TRegExOptions;
begin
  Options := [roMultiLine];
  RegEx := TRegEx.Create('<S>(?P<word>.*?)<\/S>', Options);

  for I := 0 to aLines.Count-1 do
    aLines[i] := RegEx.Replace(aLines[i], '');

end;

function TMyBibleSourceReader.CountVerses(aBook, aChapter: Integer): Integer;
var
  SQLiteQuery: TFDQuery;
begin
  SQLiteQuery := TMyBibleUtils.CreateQuery(FBible.Path);
  try

    Result := TMyBibleUtils.GetVersesCount(SQLiteQuery, aBook, aChapter);
  finally
    TMyBibleUtils.CloseOpenConnection(SQLiteQuery);
  end;
end;

function TMyBibleSourceReader.GetBookVerses(aBook: Integer): TStrings;
var
  SQLiteQuery: TFDQuery;
  Verses: TStrings;
begin
  SQLiteQuery := TMyBibleUtils.CreateQuery(FBible.Path);
  try

//    if FBible.IsBible then
  if not FBible.Info.IsCommentary then
      Verses := TMyBibleUtils.GetBookVerses(SQLiteQuery, aBook)
    else
      Verses := TMyBibleUtils.GetCommentaryVerses(SQLiteQuery, aBook);

    ClearMyBibleTags(Verses);

    Result := Verses;
  finally
    TMyBibleUtils.CloseOpenConnection(SQLiteQuery);
  end;
end;

function TMyBibleSourceReader.GetSpecialSearchSections(): TStrings;
var
  Items: TStrings;
begin
  Items := TStringList.Create;

  if (FBible.IsBible) then
    Items.AddObject(Lang.Say('SearchWholeBible'), TObject(0))
  else
    Items.AddObject(Lang.Say('SearchAllBooks'), TObject(0));

  Result := Items;
end;

function TMyBibleSourceReader.GetSectionBooks(SectionIndex: Integer): TIntSet;
var
  BookSet: TIntSet;
  I: Integer;
begin
  BookSet := TIntSet.Create;
  if SectionIndex = 0 then
  begin
    for I := 0 to FBible.Info.BookQty - 1 do
      BookSet.Include(FBible.GetBookNumberAt(I));
  end
  else
    BookSet.Include(SectionIndex); // here, SectionIndex == BookNumber

  Result := BookSet;
end;

function TMyBibleSourceReader.ParseLisks(Query: String; var FormattedQuery: String): TIntSet;
var
  Lnks: TStrings;
  I, LinksCnt: Integer;
  S: TIntSet;
  Book, Chapter, V1, V2: Integer;
begin
  S := TIntSet.Create;
  Lnks := TStringList.Create;
  try
    FormattedQuery := '';

    try
      StrToLinks(Query, Lnks);
    except
      // skip error
    end;

    LinksCnt := Lnks.Count - 1;
    for I := 0 to LinksCnt do
    begin
      if FBible.OpenReference(Lnks[I], Book, Chapter, V1, V2) and (Book > 0) and (Book < 77) then
      begin
        S.Include(Book);
        if Pos(FBible.GetShortNames(Book), FormattedQuery) <= 0 then
          FormattedQuery := FormattedQuery + FBible.GetShortNames(Book) + ' ';
      end;
    end;

    FormattedQuery := Trim(FormattedQuery);
    Result := S;
  finally
    Lnks.Free();
  end;
end;

end.
