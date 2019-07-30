unit NativeSourceReader;

interface

uses SourceReader, System.Classes, InfoSource, Bible, IOProcs, SysUtils,
     BibleQuoteUtils, AppPaths, SourceReaderIntf, LinksParser, StringProcs,
     Sets, PlainUtils, StrUtils, ChapterData;

type
  TNativeSourceReader = class(TSourceReader)
  private
    function GetChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean;
    function GetChapterPath(aBook: Integer): String;
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

constructor TNativeSourceReader.Create(Bible: TBible);
begin
  inherited Create(Bible);
end;

function TNativeSourceReader.GetBibleChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean;
begin
  Result := GetChapter(aBook, aChapter, aLines);
end;

function TNativeSourceReader.GetCommentaryChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean;
begin
  Result := GetChapter(aBook, aChapter, aLines);
end;

function TNativeSourceReader.GetChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean;
var
  iChapter: Integer;
  FoundChapter: Boolean;
  j, k: Integer;
  BookLines: TStrings;
  ChapterPath: String;
begin
  ChapterPath := GetChapterPath(aBook);
  if not (FileExists(ChapterPath)) then
  begin
    ChapterPath := ExtractRelativePath(TAppDirectories.Root, ChapterPath);
    raise EFileNotFoundException.Create(
      String.Format(Lang.SayDefault('FileNotFound', 'File "%s" not found.'), [ChapterPath]));
  end;

  BookLines := TStringList.Create;
  try
    ReadHtmlTo(ChapterPath, BookLines, FBible.DefaultEncoding);

    iChapter := 0;

    j := -1;

    repeat
      Inc(j);
      if Pos(FBible.Info.ChapterSign, BookLines[j]) > 0 then
        Inc(iChapter);
    until (j = BookLines.Count - 1) or (iChapter = aChapter);

    FoundChapter := (iChapter = aChapter);

    if iChapter = aChapter then
    begin
      if foundchapter then
        k := j + 1
      else
        k := j;

      for j := k to BookLines.Count - 1 do
      begin
        if Pos(FBible.Info.ChapterSign, BookLines[j]) > 0 then
          break;

        if Pos(FBible.Info.VerseSign, BookLines[j]) > 0 then
        begin
          aLines.Add(BookLines[j]); // add newly found verse of this chapter
        end
        else if aLines.Count > 0 then
          aLines[aLines.Count - 1] := aLines[aLines.Count - 1] + ' ' + BookLines[j]
        else if FBible.Trait[bqmtIncludeChapterHead] then
          FBible.ChapterHead := FBible.ChapterHead + BookLines[j];
        // add to current verse (paragraph)
      end;

      Result := True;

    end
    else
      Result := False;

  finally
    BookLines.Free;
  end;
end;

function TNativeSourceReader.GetChapterPath(aBook: Integer): String;
begin
  Result := FBible.Path + FBible.PathNames[aBook];
end;

function TNativeSourceReader.CountVerses(aBook, aChapter: Integer): Integer;
var
  BookLines: TStrings;
  i, Count: integer;
  ChapterPath: String;
begin
  BookLines := nil;
  try
    ChapterPath := GetChapterPath(aBook);
    BookLines := ReadHtml(ChapterPath, FBible.DefaultEncoding);

    i := 0;
    Count := 0;
    repeat
      if Pos(FBible.Info.ChapterSign, BookLines[i]) > 0 then
        Inc(Count);
      if Count = aChapter then
        break;
      Inc(i);
    until i = BookLines.Count;

    if i = BookLines.Count then
    begin
      Result := 0;
      exit;
    end;

    Count := 0;
    repeat
      if Pos(FBible.Info.VerseSign, BookLines[i]) > 0 then
        Inc(Count);
      Inc(i);
    until (i = BookLines.Count) or (Pos(FBible.Info.ChapterSign, BookLines[i]) > 0);

  finally
    BookLines.Free;

  end;

  Result := Count;
end;

function TNativeSourceReader.GetBookVerses(aBook: Integer): TStrings;
var
  RawLines: TStrings;
  BookLines, Verses: TStringList;
  S: String;
  I, Chapter, Verse: Integer;
  VerseMeta: TVerseMeta;
begin
  RawLines := TStringList.Create;
  ReadHtmlTo(FBible.Path + FBible.PathNames[aBook], RawLines, FBible.DefaultEncoding);

  BookLines := TStringList.Create;

  S := '';
  for I := 0 to RawLines.Count - 1 do
  begin
    if (ContainsText(RawLines[I], FBible.Info.ChapterSign)) or (ContainsText(RawLines[I], FBible.Info.VerseSign)) then
    begin
      BookLines.Add(S);
      S := RawLines[I];
    end
    else
      S := S + ' ' + RawLines[I]; // concatenate paragraphs
  end;
  BookLines.Add(S);

  Verses := TStringList.Create;
  Chapter := 0;
  Verse := 0;

  for I := 0 to BookLines.Count - 1 do
  begin
    if ContainsText(BookLines[I], FBible.Info.ChapterSign) then
    begin
      Inc(Chapter);
      Verse := 0;

      Continue;
    end;

    if ContainsText(BookLines[I], FBible.Info.VerseSign) then
    begin
      Inc(Verse);
      VerseMeta := TVerseMeta.Create;
      VerseMeta.ChapterNumber := Chapter;
      VerseMeta.VerseNumber   := Verse;

      Verses.AddObject(BookLines[I], VerseMeta);
    end;

  end;

  Result := Verses;
end;

function TNativeSourceReader.GetSpecialSearchSections(): TStrings;
var
  Items: TStrings;
begin
  Items := TStringList.Create;

  if (FBible.IsBible) then
  begin
    Items.AddObject(Lang.Say('SearchWholeBible'), TObject(0));
    if FBible.Trait[bqmtOldCovenant] and FBible.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchOT'), TObject(-1)); // Old Testament
    if FBible.Trait[bqmtNewCovenant] and FBible.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchNT'), TObject(-2)); // New Testament
    if FBible.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchPT'), TObject(-3)); // Pentateuch
    if FBible.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchHP'), TObject(-4)); // Historical and Poetical
    if FBible.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchPR'), TObject(-5)); // Prophets
    if FBible.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchGA'), TObject(-6)); // Gospels and Acts
    if FBible.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchER'), TObject(-7)); // Epistles and Revelation
    if FBible.Trait[bqmtApocrypha] then
      Items.AddObject(Lang.Say('SearchAP'), TObject(-8)); // Apocrypha
  end
  else
    Items.AddObject(Lang.Say('SearchAllBooks'), TObject(0));

  Result := Items;
end;

function TNativeSourceReader.GetSectionBooks(SectionIndex: Integer): TIntSet;
var
  Book: Integer;
  BookSet: TIntSet;
  procedure IncludeRange(MinBookIndex, MaxBookIndex: Integer);
  var
    I: Integer;
  begin
    for I := MinBookIndex to MaxBookIndex do
      BookSet.Include(FBible.GetBookNumberAt(I));
  end;
begin
  BookSet := TIntSet.Create();
  case Integer(SectionIndex) of
  0:
    IncludeRange(0, 65);
  -1:
    IncludeRange(0, 38);
  -2:
    IncludeRange(39, 65);
  -3:
    IncludeRange(0, 4);
  -4:
    IncludeRange(5, 21);
  -5:
    IncludeRange(22, 38);
  -6:
    IncludeRange(39, 43);
  -7:
    IncludeRange(44, 65);
  -8:
    begin
      if FBible.Trait[bqmtApocrypha] then
        IncludeRange(66, FBible.Info.BookQty - 1)
      else
        BookSet.Include(FBible.GetBookNumberAt(0))
    end;
  else
    // Search in single book
    BookSet.Include(SectionIndex); // here, SectionIndex = BookNumber
  end;

  Result := BookSet;
end;

function TNativeSourceReader.ParseLisks(Query: String; var FormattedQuery: String): TIntSet;
var
  Lnks: TStrings;
  I, LinksCnt: Integer;
  S: TIntSet;
  Book, Chapter, V1, V2: Integer;

  procedure IncludeRange(BookSet: TIntSet; MinBookIndex, MaxBookIndex: Integer);
  var
    I: Integer;
  begin
    for I := MinBookIndex to MaxBookIndex do
      BookSet.Include(FBible.GetBookNumberAt(I));
  end;

  function Metabook(const Str: string): Boolean;
  var
    Wl: string;
  label success;
  begin
    Wl := LowerCase(Str);
    if (Pos('нз', Wl) = 1) or (Pos('nt', Wl) = 1) then
    begin

      if FBible.Trait[bqmtNewCovenant] and FBible.InternalToReference(40, 1, 1, Book, Chapter, V1) then
        IncludeRange(S, 39, 65);

      goto Success;
    end
    else if (Pos('вз', Wl) = 1) or (Pos('ot', Wl) = 1) then
    begin
      if FBible.Trait[bqmtOldCovenant] and FBible.InternalToReference(1, 1, 1, Book, Chapter, V1) then
        IncludeRange(S, 0, 38);

      goto Success;
    end
    else if (Pos('пят', Wl) = 1) or (Pos('pent', Wl) = 1) or
      (Pos('тор', Wl) = 1) or (Pos('tor', Wl) = 1) then
    begin
      if FBible.Trait[bqmtOldCovenant] and FBible.InternalToReference(1, 1, 1, Book, Chapter, V1) then
        IncludeRange(S, 0, 4);

      goto Success;
    end
    else if (Pos('ист', Wl) = 1) or (Pos('hist', Wl) = 1) then
    begin
      if FBible.Trait[bqmtOldCovenant] then
        IncludeRange(S, 0, 15);

      goto Success;
    end
    else if (Pos('уч', Wl) = 1) or (Pos('teach', Wl) = 1) then
    begin
      if FBible.Trait[bqmtOldCovenant] then
        IncludeRange(S, 16, 21);

      goto Success;
    end
    else if (Pos('бпрор', Wl) = 1) or (Pos('bproph', Wl) = 1) then
    begin
      if FBible.Trait[bqmtOldCovenant] then
        IncludeRange(S, 22, 26);

      goto Success;
    end
    else if (Pos('мпрор', Wl) = 1) or (Pos('mproph', Wl) = 1) then
    begin
      if FBible.Trait[bqmtOldCovenant] then
        IncludeRange(S, 27, 38);

      goto Success;
    end
    else if (Pos('прор', Wl) = 1) or (Pos('proph', Wl) = 1) then
    begin
      if FBible.Trait[bqmtOldCovenant] then
      begin
        IncludeRange(S, 22, 38);
        if FBible.Trait[bqmtNewCovenant] and FBible.InternalToReference(66, 1, 1, Book, Chapter, V1) then
          S.Include(65);

        goto Success;
      end
    end
    else if (Pos('ева', Wl) = 1) or (Pos('gos', Wl) = 1) then
    begin
      if FBible.Trait[bqmtNewCovenant] then
        IncludeRange(S, 39, 42);

      goto Success;
    end
    else if (Pos('пав', Wl) = 1) or (Pos('paul', Wl) = 1) then
    begin
      if FBible.Trait[bqmtNewCovenant] and FBible.InternalToReference(52, 1, 1, Book, Chapter, V1) then
        IncludeRange(S, Book - 1, Book + 12);

      goto Success;
    end;

    Result := false;
    Exit;
  Success:
    Result := true;
  end;

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
      if Metabook(Lnks[I]) then
      begin

        FormattedQuery := FormattedQuery + FirstWord(Lnks[I]) + ' ';
        continue;
      end
      else if FBible.OpenReference(Lnks[I], Book, Chapter, V1, V2) and (Book > 0) and (Book < 77) then
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

