unit LinksParserIntf;

interface

type
  TBibleBookNameEntry = class
  public
    nameBookIx: integer;
    chapterCnt: integer;
    key, usgCnt, lastHitPos: integer;
    modSigIx: integer;
    destructor Destroy; override;
  end;

  TBibleLinkProcessingOption = (blpLimitChapterTxt);
  TBibleLinkProcessingOptions = set of TBibleLinkProcessingOption;
  TLikenessTraits = (bltBook, bltChapter, bltVerse1, bltVerse2);
  TBibleLinkLikeness = set of TLikenessTraits;

  TBibleLink = object
    book, chapter, vstart, vend, tokenStartOffset, tokenEndOffset: integer;
    procedure Reset();
    procedure Build(aBook, aChapter, aVStart, aVEnd: integer);
    function GetHref(idNum: cardinal = 0; bloOptions: TBibleLinkProcessingOptions = []): string;
    function ToCommand(const path: string; bloOptions: TBibleLinkProcessingOptions = []): string;
    function FromBqStringLocation(loc: string; out path: string): boolean;
    function GetLikeNess(const bl: TBibleLink): TBibleLinkLikeness;
    procedure AssignTo(out dest: TBibleLink);
  end;

  PBibleLink = ^TBibleLink;
  TBibleLinkArray = array of TBibleLink;
  TBibleLinkExLikeNessTraits = (bllTag, bllModName, bllBook, bllChapter, bllVerse1, bllVerse2);
  TBibleLinkExLikeness = set of TBibleLinkExLikeNessTraits;

  TBibleLinkEx = object(TBibleLink)
    modName: string;
    tag: cardinal;
    function FromBqStringLocation(loc: string): boolean;
    function GetLikeNess(const bl: TBibleLinkEx): TBibleLinkExLikeness;
    function ToCommand(bloOptions: TBibleLinkProcessingOptions = []): string;
    function IsAutoBible(): boolean;
    function GetIniFileShortPath(): string;
    destructor Destroy();
  end;

  PBibleLinkEx = ^TBibleLinkEx;

implementation

uses SysUtils, IOUtils, BibleQuoteConfig;

type
  TfnResolveLnks = function(const txt: string): string;
  TfnPrepare = function(fn: string; var df: Text): boolean;

function ExtractFirstTkn(var s: string): string;
var
  s1: string;
  i: integer;
begin
  Result := s;

  s1 := Trim(s);
  i := Pos(' ', s1);
  if i > 0 then
  begin
    Result := Copy(s, 1, i - 1);
    s := Copy(s1, i + 1, Length(s1));
  end
  else
    s := '';
end;

{ TBibleLink }

procedure TBibleLink.AssignTo(out dest: TBibleLink);
begin
  dest.book := book;
  dest.chapter := chapter;
  dest.vstart := vstart;
  dest.vend := vend;
  dest.tokenStartOffset := tokenStartOffset;
  dest.tokenEndOffset := tokenEndOffset;
end;

procedure TBibleLink.Reset();
begin
  book := 0;
  chapter := 0;
  vstart := 0;
  vend := 0;
  tokenStartOffset := 0;
  tokenEndOffset := 0;
end;

function TBibleLink.FromBqStringLocation(loc: string; out path: string)
  : boolean;
var
  value: string;
begin
  try

    path := ExtractFirstTkn(loc);
    book := 1;
    chapter := 1;
    vstart := 0;
    vend := 0;
    if path = 'go' then
      path := ExtractFirstTkn(loc)
    else { if path='file' then }
    begin
      Result := false;
      exit;
    end;
    // читаем номер книги
    Result := true;
    value := ExtractFirstTkn(loc);
    if value = '' then
      exit;
    book := StrToInt(value);
    // читаем номер главы
    value := ExtractFirstTkn(loc);
    if value = '' then
      exit;
    chapter := StrToInt(value);
    // читаем номер начального стиха
    value := ExtractFirstTkn(loc);
    if value = '' then
      exit;
    vstart := StrToInt(value);
    // читаем номер конечного стиха
    value := ExtractFirstTkn(loc);
    if value <> '' then
      vend := StrToInt(value)
    else
      vend := vstart;
    Result := true;
  except
    Result := false;
  end;

  // формируем путь к ini модуля
end;

function TBibleLink.GetHref(idNum: cardinal = 0; bloOptions: TBibleLinkProcessingOptions = []): string;
begin
  Result := Format(
    '<a href="%s " ID="bqResLnk%d" CLASS=bqResolvedLink >',
    [ToCommand(C__bqAutoBible, bloOptions), idNum]);

  if idNum > 0 then
    Result := Format('<A NAME="bqResLnk%d">%s', [idNum, Result]);

end;

function TBibleLink.GetLikeNess(const bl: TBibleLink): TBibleLinkLikeness;
begin
  Result := [];

  if self.book = bl.book then
    Include(Result, bltBook);
  if self.chapter = bl.chapter then
    Include(Result, bltChapter);
  if self.vstart = bl.vstart then
    Include(Result, bltVerse1);
  if self.vend = bl.vend then
    Include(Result, bltVerse2);
end;

function TBibleLink.ToCommand(const path: string; bloOptions: TBibleLinkProcessingOptions = []): string;
begin
  if vstart <= 0 then
  begin
    Result := Format('go %s %d %d 0 0', [path, book, chapter]);
    exit;
  end;
  if vend > 0 then
    Result := Format('go %s %d %d %d %d', [path, book, chapter, vstart, vend])
  else
    Result := Format('go %s %d %d %d 0', [path, book, chapter, vstart]);
end;

procedure TBibleLink.Build(aBook, aChapter, aVStart, aVEnd: integer);
begin
  Reset();
  book := aBook;
  chapter := aChapter;
  vstart := aVStart;
  vend := aVEnd;
end;

{ TBibleLinkEx }
function TBibleLinkEx.FromBqStringLocation(loc: string): boolean;
begin
  Result := inherited FromBqStringLocation(loc, modName);
end;

destructor TBibleLinkEx.Destroy();
begin
end;

function TBibleLinkEx.GetLikeNess(const bl: TBibleLinkEx): TBibleLinkExLikeness;
begin
  Result := [];

  if CompareText(self.modName, bl.modName) = 0 then
    Include(Result, bllModName);
  if self.tag = bl.tag then
    Include(Result, bllTag);
  if self.book = bl.book then
    Include(Result, bllBook);
  if self.chapter = bl.chapter then
    Include(Result, bllChapter);
  if self.vstart = bl.vstart then
    Include(Result, bllVerse1);
  if self.vend = bl.vend then
    Include(Result, bllVerse2);
end;

function TBibleLinkEx.ToCommand(bloOptions: TBibleLinkProcessingOptions = []): string;
begin
  Result := inherited ToCommand(modName, bloOptions);
end;


function TBibleLinkEx.IsAutoBible(): boolean;
begin
  Result := modName = C__bqAutoBible;
end;

function TBibleLinkEx.GetIniFileShortPath(): string;
begin
  Result := TPath.Combine(modName, C_ModuleIniName);
end;

destructor TBibleBookNameEntry.Destroy;
begin
  inherited;
end;

end.

