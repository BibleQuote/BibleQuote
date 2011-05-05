unit BibleLinkParser;

interface
uses JclUnicode, Classes, WideStringsMod, bqLinksParserIntf, bqContainers;
type
  TLinkMatchType = (lmtNone, lmtFirst, lmtConCat, lmtSecond, lmtBoth);
  TLinkParserFlag = (lpsBookEntered, lpsChapterEntered, lpsFirstVerseEntered);

  TBibleBookNames = class(TWideStringList)
    mModSigs: TWideStringList;
    constructor Create();
    function FromFile(const fn: WideString): boolean;
    function ItemIndexFromBookIx(): integer;
  end;

  TBQBooksHistory = object(TBQHistoryContainer)
    function BestValidBookFor(chapter, key: integer): TBibleBookNameEntry;
  end;

  TLinkParserOption = (lpoIgnoreOneNumberValues, lpoTextRecognition, lpoExtractLnks);
  TLinkParserOptions = set of TLinkParserOption;

  TLinkParserFlags = set of TLinkParserFlag;
  TBibleLinkParser = class
    mBook, mBookEntryIx, mOldBook, mChapter, mOldChapter, mV1, mV2,
      mSaveBook, mSaveChapter, mSaveV1, mSaveV2: integer;
    mSigList: TBibleBookNames;
    mLastTokenWasDelim: boolean;
    mBibleLink, mOutputBibleLink: TBibleLink;
    mSoftDelim, mLastDelim, mPrevDelim, mChapDelim: AnsiChar;
    mFlags: TLinkParserFlags;
    mLastVerse, mPrevVerse: integer;
    mLinkReady: boolean;
    mLazyLink: boolean;
    mBookExpicitSet: boolean;
    mLinkParserOptions: TLinkParserOptions;
    mVerseToChapterTransitionMade: boolean;
    mLinkCounter: integer;
    mInCurrentChapterVerseAdded: boolean;
    mWeakChapterSign: boolean;
    mbookUsed: TBQBooksHistory;
    mTokenCnter: integer;
    mBlArray:TBibleLinkArray;
    mBlArrayCnt:integer;
  class var SessionNum: integer;
//    procedure PrepareBookNames();
procedure Init();
type TLinkValueRecognitionOption = (lvroAllowPartialVerses, lvroAllowRomans);
      TLinkValueRecognitionOptions = set of TLinkValueRecognitionOption;
class function VerseTokenValue(const tkn: WideString;
  options: TLinkValueRecognitionOptions = []): integer; static;
function CheckDelim(const tkn: WideString): boolean;
function SetupLink(book, chapter, vstart, vend: integer; tokenOffset:
  integer; preserveStartOffset: boolean): boolean;
function BookNameParse(const tFirst: WideString; const tSecond:
  WideString): TLinkMatchType;
function AddTokens(const tkn1: WideString; const tkn2: WideString; var pBibleLnk: PBibleLink):
  TLinkMatchType;
procedure FinalizeParse(var pBibleLnk: PBibleLink);
function ExprEndHardDelimiter(dl: AnsiChar): boolean; inline;
function IsHardChapterDelim(dl: WideChar): boolean; inline;
function BookCached(): boolean; inline;
function VerseTo(const tkn: WideString): TLinkMatchType;
function VerseAdd(const tkn: WideString): TLinkMatchType;
function VerseStart(const tkn: WideString): TLinkMatchType;
function ChapterSet(const tkn: WideString; const tkn2: WideString): TLinkMatchType;
type TChapterValidationResult = (cvrAccept, cvrIsNotChapter, cvrContextChange);
function ValidateChapterAndBook(book, chapter: integer; explicitSet: boolean;
  out sugBook: integer; out sugChapter: integer): TChapterValidationResult;
function ValidateChater(allowBookChange: boolean = true): TBibleBookNameEntry;
procedure DeleteLastLink();
procedure ClearLinks();
procedure AddLink(const bl:TBibleLink);
function ParseBuffer(const wsBuffer: WideString; lnks: TWideStrings): boolean;
procedure ProcessLines(lns: TWideStrings);
constructor Create();
property LazyLinks: boolean read mLazyLink write mLazyLink;
property ParserFlags: TLinkParserFlags read mFlags;
property BookExplicitSet: boolean read mBookExpicitSet;
property Options: TLinkParserOptions read mLinkParserOptions
  write mLinkParserOptions;
end;

    function Prepare(fn: WideString; var df: Text): boolean;
    function ResolveLnks(const txt: WideString): WideString;

    function extractLnks(const txt:WideString;var la:TBibleLinkArray):boolean;
implementation
uses bqPlainUtils, BibleQuoteUtils, JCLDebug, Dialogs,BQExceptionTracker,
  SysUtils, {string_procs,} windows {$IFDEF DEBUG} , TypInfo{$ENDIF};

var bookNamesObj: TBibleBookNames;
  lparser: TBibleLinkParser;

const  oleaut32 = 'oleaut32.dll';
function SysAllocStringLen(psz: PWideChar; len: Integer): PWideChar; stdcall; external oleaut32 name 'SysAllocString';
procedure SysFreeString(bstr: PWideChar); stdcall;  external oleaut32 name 'SysFreeString';




 { TBibleLinkParser }



function TBibleLinkParser.AddTokens(const tkn1: WideString; const tkn2:
  WideString; var pBibleLnk: PBibleLink): TLinkMatchType;
var
  chk: boolean;
  save, vl: integer;
  tst: boolean;
  suggestedBook,suggestedChapter:integer;
  chapterValidation:TChapterValidationResult;
label tail;
begin
  pBibleLnk := nil;
  Inc(mTokenCnter);
  chk := CheckDelim(tkn1);
  if chk and (lpsBookEntered in mFlags) and ExprEndHardDelimiter(mLastDelim) then begin
    result := lmtFirst;
        // inc(mBibleLink.tokenEndOffset);
    tst := SetupLink(mBook, mChapter, mV1, mV2, mBibleLink.tokenEndOffset, false);
    writeln('Hard delimiter', tkn1, ' setting link');
    Inc(mBibleLink.tokenStartOffset);
    mFlags := [lpsBookEntered];
    goto tail;
  end;
  if lpsFirstVerseEntered in mFlags then begin
    if chk or mLazyLink then begin

      if (tkn1 = '-') or ((length(tkn1) = 1) and (Integer(tkn1[1]) >= $2010)
        and (integer(tkn1[1]) < $2015)) then begin
        // Ge 1:3-5;
        result := VerseTo(tkn2);
        goto tail;
      end;
      if chk and IsHardChapterDelim(WideChar(mLastDelim)) then begin
        //Ge 3:3,4:Some_txt or  Ge 6:4,5-3:6  or ErrNum, 3:14
        vl := VerseTokenValue(tkn2, [lvroAllowPartialVerses, lvroAllowRomans]);
        if {(mPrevDelim<>'-') and}(vl < 0) then begin
        //Ge 3:3,4: this is how
          mOldChapter := mChapter;
          result := lmtNone;
          goto tail;
        end
        else begin
          if (vl > 0) then begin
            if (not mInCurrentChapterVerseAdded) and
              (not mBookExpicitSet) and (mWeakChapterSign) then begin
          //errNum, 3:3 //not Ge 3,3:4  //not 3:5-3:6
              mChapter := mV1;
              mV1 := vl;
              mV2 := vl;
              Inc(mBibleLink.tokenStartOffset);
              mFlags := [lpsBookEntered, lpsChapterEntered, lpsFirstVerseEntered];
              result := lmtBoth;
              goto tail;
            end
            else if mPrevDelim = '-' then begin
          //4:7-8:6
              save := mV2;
              SetupLink(mBook, mChapter, mV1, mV1, 1, false);
              mChapter := save;         //set new chapter
              mFlags := [lpsBookEntered, lpsChapterEntered];
              result := lmtFirst;
              mV2 := 0;
              goto tail;
            end
            else begin
        //5:4 ,3:1
              chapterValidation:=ValidateChapterAndBook(mBook, mLastVerse,
               mBookExpicitSet,suggestedBook,suggestedChapter);
              if chapterValidation=cvrIsNotChapter then begin
              //5:4,200:3
                mFlags:=[lpsBookEntered];
                mBookExpicitSet:=false;
                result:=lmtNone;
                goto tail;
              end
              else if chapterValidation=cvrContextChange then begin
                mBook:=suggestedBook;
                mBookExpicitSet:=false;
              end;
              mChapter := mLastVerse;
              mFlags := [lpsBookEntered, lpsChapterEntered];
              result := lmtFirst;
              mV2 := 0; mV1 := 0;
              goto tail;
            end;
          end                           //second token is verseval
        end;                            //else
      end;                              //hard chapter

      mSoftDelim := mLastDelim;

      if chk then begin                 // Ge 3:4,Gal 3 or someErrval, Gal 3
      //if delimiter but not in [;,.,:]
      //simply try to ignore
        result := VerseAdd(tkn2);
        if result > lmtNone then
//       mBibleLink.tokenStartOffset:=ord(not mLinkReady );
          goto tail;
      end

      else begin                        // last chance, lazy link case??
        result := TLinkMatchType(ord(VerseAdd(tkn1)) div 2);
       {if result >= lmtFirst then}goto tail;
      end;
    end;

    result := BookNameParse(IntToStr(mLastVerse) + tkn1, tkn2);
    if result > lmtNone then begin
     // R 2:3,2 Kor. 3
    //here "kor ."
      mV1 := 0; mV2 := 0;
      mLinkReady := false;
      if not mInCurrentChapterVerseAdded then
        Inc(mBibleLink.tokenStartOffset);//need to skip first of - 10 1 ‘ес
      goto tail;
    end;

     // Rom 2:3,2 Gal 3
    //here "kor ."
    result := BookNameParse(tkn1, tkn2);
    if result > lmtNone then begin
      mV1 := 0; mV2 := 0; mBibleLink.tokenStartOffset := 0;
      goto tail;
    end;

     //Rom 2:3,2 SOMETXT
    mFlags := [lpsBookEntered, lpsChapterEntered, lpsFirstVerseEntered];
    result := lmtNone;
    goto tail;

  end;

//      result:= BookNameParse(IntToStr(mLastVerse)+ tkn1, tkn2);
//      if Result in [lmtNone, lmtBoth, lmtSecond]  then begin
//      result:=lmtNone;
//      mLinkReady:=false;
//      mFlags:=[lpsBookEntered,lpsChapterEntered,lpsFirstVerseEntered];
//      end else begin
//      mLinkReady:=false;
//      end;
//      goto tail;
//  end;

  if lpsChapterEntered in mFlags then begin //never verse entered
    if mBookExpicitSet and (tkn1 = '-') then begin //links links like Rom 1-3
      //Rom. 1-3
        vl:=VerseTokenValue(tkn2, [lvroAllowRomans]);
        if vl>= 0 then begin
        SetupLink(mBook, mChapter, 0, 0, 0, false);
        mFlags := [lpsBookEntered, lpsChapterEntered];
        mChapter:=vl;
        result := lmtSecond;
        goto tail;
      end;
    end;

    result := VerseAdd(tkn1);
    if Result >= lmtFirst then begin
      if (mFlags = [lpsBookEntered]) and (not mLinkReady) then begin
    // Ge 3, Ro
        Inc(mBibleLink.tokenStartOffset);
      end;

      result := lmtFirst; goto tail;
    end
//    here we not succeeded in verse tkn1
    else if mVerseToChapterTransitionMade then begin
      //Ge 3:4: some_txt
      mV1 := mChapter;
      mV2 := mChapter;
      mChapter := mOldChapter;
      mBibleLink.tokenEndOffset := 1;
      mFlags := [lpsBookEntered, lpsChapterEntered, lpsFirstVerseEntered];
      result := lmtNone;
      goto tail;
    end
    else if (not mBookExpicitSet) and (mChapter < 5) then begin
       //1 Cor
      result := BookNameParse(IntToStr(mChapter), tkn1);
      if result <> lmtConCat then begin
        result := lmtNone;
        exit
      end
      else begin
        mBookExpicitSet := true;
        goto tail;
      end;
    end;
  end

  else if lpsBookEntered in mFlags then begin
    Result := ChapterSet(tkn1, tkn2);
    if result <> lmtNone then begin
      if length(tkn2) > 0 then mChapDelim := AnsiChar(tkn2[1]);
      goto tail;
    end;
  end;
  save := mBibleLink.tokenStartOffset;
  result := BookNameParse(tkn1, tkn2);
  mBibleLink.tokenStartOffset := save;
  tail:
  if result > lmtFirst then Inc(mTokenCnter);
  if mLinkReady then begin pBibleLnk := @mOutputBibleLink; mLinkReady := false; end;
end;

function TBibleLinkParser.BookCached: boolean;
begin
  result := mBook > 0;
end;

function TBibleLinkParser.ValidateChater(allowBookChange: boolean = true): TBibleBookNameEntry;
begin
end;

function TBibleLinkParser.ValidateChapterAndBook(book, chapter: integer; explicitSet: boolean;
  out sugBook: integer; out sugChapter: integer): TChapterValidationResult;
var i, booksHisCount, curProbBookIx: integer;
  curProbIndex, probVal, distance: double;
  bne: TBibleBookNameEntry;
  cvr: TChapterValidationResult;
  saveOffs: integer;
  chapterInv, longdistance: boolean;
begin
  result := cvrIsNOtChapter;
  if chapter > 250 then exit;
  result := cvrAccept;
  curProbIndex := -1; curProbBookIx := -1;
  booksHisCount := mbookUsed.EffectiveDepth() - 1;

  chapterInv := true;
  longdistance := false;
  for i := 0 to booksHisCount do begin
    bne := TBibleBookNameEntry(mBookUsed.items[i]);
    if bne.key <> self.SessionNum then continue;

    if (chapter > bne.chapterCnt) then begin
      chapterInv := true;
      continue;
    end;

    if explicitSet and (bne.nameBookIx = book) then begin
       curProbIndex := $FFFF; curProbBookIx := book; break;
    end;
    distance := mTokenCnter - bne.lastHitPos;

    if distance = 0 then distance := 1;

// if (bne.nameBookIx=book) and (distance>900) then  longdistance:=true;
    probVal := (10000000 / (distance * distance * distance)) * bne.usgCnt;
    if probVal > curProbIndex then begin curProbIndex := probVal;
      curProbBookIx := bne.nameBookIx;
    end;
  end;

  if  (curProbIndex > 0) then begin
    if (book = curProbBookIx) then begin result := cvrAccept; end
    else begin
      result := cvrContextChange;
      sugBook := bne.nameBookIx;
    end;
  end
  else if not chapterInv then result := cvrAccept
  else result := cvrIsNOtChapter;

end;

function TBibleLinkParser.ChapterSet(const tkn: WideString; const tkn2: WideString): TLinkMatchType;
var
  vl, tl, sugBk, sugChap, saveoffs: integer;
  cvr: TChapterValidationResult;
begin

 // Val(tkn, vl, err);
  vl := VerseTokenValue(tkn, [lvroAllowRomans]);
  if vl < 0 then begin
    if (tkn = '.') and mBookExpicitSet then begin
      vl := VerseTokenValue(tkn2, [lvroAllowRomans]); {vl:= (tkn2, vl, err);}
    end;
    if vl >= 0 then begin
    //first token is '.' and second is chapter value
    //skip one token to add this chapter in next it
      result := lmtFirst;
      exit;
  //mChapter := vl;
    end
    else begin
      result := lmtNone;
      exit;
    end;
  end
  else if (vl <= 4) {and (not mBookExpicitSet)} then begin
    saveoffs := mBibleLink.tokenStartOffset;
    result := BookNameParse(Inttostr(vl) + tkn2, '');
    mBibleLink.tokenStartOffset := saveoffs;
    if Result = lmtFirst then begin
      mLinkReady := false;
      result := lmtConCat;
      exit;
    end

  end;

  mLastTokenWasDelim := false;
  cvr := ValidateChapterAndBook(mBook, vl, mBookExpicitSet, sugBk, sugChap);
  if cvr = cvrIsNotChapter then begin
    result := lmtNone;
    exit;
  end;
  if cvr = cvrContextChange then begin
    mBook := sugBk;
  end;

  if (lpsChapterEntered in mFlags) then SetupLink(
      mBook, mChapter, mV1, mV2, 0, false);
  mInCurrentChapterVerseAdded := false;
  mFlags := [lpsChapterEntered, lpsBookEntered];
  mChapter := vl;

  tl := length(tkn2);
  mWeakChapterSign := (tl > 1) or (tl < 1) or (not IsHardChapterDelim(tkn2[1]));
  if ((tkn2 = ':') or (tkn2 = '.') or (tkn2 = ',')) then result := lmtBoth else result := lmtFirst;
  exit;

  result := BookNameParse(tkn, tkn2);
  if result = lmtNone then begin exit; end;

  if (lpsBookEntered in mFlags) then SetupLink(mBook, mChapter,
      mV1, mV2, 0, false);
  mFlags := [lpsBookEntered];
end;

function TBibleLinkParser.CheckDelim(const tkn: WideString): boolean;
var prev: AnsiChar;
begin
  prev := mLastDelim;
  if tkn = ',' then begin
    mLastTokenWasDelim := true; mLastDelim := ','; result := true;
  end
  else if tkn = ';' then
  begin mLastTokenWasDelim := true; mLastDelim := ';'; result := true; end
  else if (tkn = '.') or (tkn = ':') then
  begin mLastTokenWasDelim := true; mLastDelim := '.'; result := true; end
  else if (tkn = '-') or ((Integer(tkn[1]) >= $2010) and (integer(tkn[1]) < $2015)) then begin mLastTokenWasDelim := true; mLastDelim := '-'; result := true; end
  else begin result := false; end;
  if result then begin
    mPrevDelim := prev;
  end;
end;

constructor TBibleLinkParser.Create;
begin
  Init();
  mSigList := bookNamesObj;
  mLinkParserOptions := [lpoIgnoreOneNumberValues];
end;

procedure TBibleLinkParser.DeleteLastLink;
begin

end;

procedure TBibleLinkParser.ClearLinks();
begin
SetLength(mBlArray,0);
mBlArrayCnt:=0;
end;
procedure TBibleLinkParser.AddLink(const bl:TBibleLink);
var l:integer;
begin
l:=length(mBlArray);
if l<=mBlArrayCnt then begin
  if l=0 then l:=2
  else l:=mBlArrayCnt shl 1;
SetLength(mBlArray, l);

end;
bl.AssignTo( mBlArray[mBlArrayCnt] );
inc(mBlArrayCnt);
end;

function TBibleLinkParser.ExprEndHardDelimiter(dl: AnsiChar): boolean;
begin
  result := dl in [';'];
end;

procedure TBibleLinkParser.FinalizeParse(var pBibleLnk: PBibleLink);
var saveBl: TBibleLink;
label tail;
begin
  pBibleLnk := nil;
  mWeakChapterSign := true;

  if not (lpsChapterEntered in mFlags) then begin
    if mOldBook > 0 then
      mBook := mOldBook;
    goto tail;
  end;
//saveBl:=mBibleLink;
  Inc(mBibleLink.tokenEndOffset, ord(mVerseToChapterTransitionMade));
  if not SetupLink(mBook, mChapter, mV1, mV2,
    mBibleLink.tokenEndOffset, false) then goto tail;

//if (saveBl.book=mBibleLink.book) and
//  (saveBl.chapter=mBibleLink.chapter) and
//  (saveBl.vstart=mBibleLink.vstart) and
//  (saveBl.vend=mBibleLink.vend) then goto tail;
//mOutputBibleLink:=mBibleLink;
  pBibleLnk := @mOutputBibleLink;
  tail:
  mBookExpicitSet := false;
  mInCurrentChapterVerseAdded := false;
  mBibleLink.tokenStartOffset := 0;
  mBibleLink.tokenEndOffset := 0;
  mLinkReady := false;
  mVerseToChapterTransitionMade := false;
  mPrevDelim := #0; mLastDelim := #0;
  Exclude(mFlags, lpsChapterEntered);
  Exclude(mFlags, lpsFirstVerseEntered);
end;

procedure TBibleLinkParser.Init;
begin
  mFlags := [];
  Inc(SessionNum);
  mWeakChapterSign := true;
  mLastTokenWasDelim := false;
  mLinkCounter := 0;
  mTokenCnter := 0;
  mbookUsed.Init(400);
//mbookUsed.Clear();
  mBookExpicitSet := false;
  mBibleLink.tokenStartOffset := 0;
  mLastVerse := 0; mBook := 0; mBookEntryIx := -1; mChapter := 0; mV1 := -1; mV2 := 0; mLinkReady := false;
  mSoftDelim := #0; mLastDelim := #0; mChapDelim := #0; mPrevDelim := #0;
  mVerseToChapterTransitionMade := false;
end;

function TBibleLinkParser.IsHardChapterDelim(dl: WideChar): boolean;
begin
  result := (dl = ':') or (dl = '.');
end;

function TBibleLinkParser.BookNameParse(const tFirst,
  tSecond: WideString): TLinkMatchType;
var
  iVal, ix, tokenLen: integer;
  s1res, s2res, lowerCased, dotted: boolean;
  tkn: WideString;
  bne: TBibleBookNameEntry;
label Hit;
begin
  ival := 0;
  if (length(tFirst) = 1) then begin

//    ival := Integer(tFirst[1]) - ord('0');
    ival := VerseTokenValue(tFirst, [lvroAllowRomans]);
    if (ival <= 0) or (ival > 4) then begin tkn := tSecond; ival := -1; end
    else tkn := inttostr(ival) + tSecond;
  end
  else begin tkn := tFirst; ival := 0; end;
  if (mSigList.Find(tkn, ix)) then begin
    if ival > 0 then result := lmtConCat
    else if ival < 0 then result := lmtSecond //special case 2-nd tkn
    else result := lmtFirst;            //first tkn matched
//    mBook := Integer(mSigList.Objects[ix]);
//    mFlags := [lpsBookEntered];
//    exit;
    goto Hit;
  end;
  if ((ival > 0) {первый-число} and (mSigList.Find(tSecond, ix))) then
  begin
    result := lmtSecond;

    Hit:
    bne := TBibleBookNameEntry(mSigList.Objects[ix]);
    mbookUsed.Push(PAnsiChar(bne));
    bne.key := SessionNum; Inc(bne.usgCnt); bne.lastHitPos := mTokenCnter;

    lowerCased := false;
    dotted := (ival = 0) and (tSecond = '.');
    if dotted then begin result := lmtConCat; end;

    if lpoTextRecognition in mLinkParserOptions then begin
      tokenLen := length(tkn);
      lowerCased := UnicodeIsLower(Cardinal(tkn[1]));
      if (tokenLen < 4) and lowerCased
        and not UnicodeIsDigit(Cardinal(tkn[1])) then begin

        result := lmtNone;
      end;

    end;
    {Say 1Kor 16:24,12:11 2 Kor 3:12}
    if ((lpsBookEntered in mFlags) {and
      (mBookExpicitSet)}) then
       SetupLink(mBook, mChapter, mV1, mV2, 0, false);

    if (lowercased) then mOldBook := mBook else mOldBook := -1;

    mBook := bne.nameBookIx;
    mBookEntryIx := ix;
    if (result <> lmtNone) and (bne.chapterCnt <= 1) then begin
      mFlags := [lpsBookEntered, lpsChapterEntered];
      mChapter := 1;
    end
    else mFlags := [lpsBookEntered];
    mBookExpicitSet := true;

    exit;
  end;
  result := lmtNone;
end;

function TBibleLinkParser.ParseBuffer(const wsBuffer: WideString; lnks: TWideStrings): boolean;
var sl: TWideStrings;
  c, i: integer;
  first, second, bookTkn: WideString;
  r: TLinkMatchType;
  pbl: PBibleLink;
begin
  sl := TWideStringList.Create;
// Tokenize(wsBuffer,  sl);
  c := sl.Count; i := 1;
  sl.Add('');
  if c < 2 then exit;
  first := sl[0]; second := sl[1];
  Init();
  repeat
    r := AddTokens(first, second, pbl);
    if assigned(pbl) then lnks.Add(pbl^.AsString);

    if r = lmtNone then break;
    if r = lmtFirst then begin first := second; inc(i); if i > c then break;
      second := sl[i]; end
    else begin
      inc(i, 2); if i > c then break; first := sl[i - 1]; second := sl[i]; end;

  until i > c;
  FinalizeParse(pbl);
  if assigned(pbl) then if assigned(pbl) then lnks.Add(pbl^.AsString);

end;

//procedure TBibleLinkParser.PrepareBookNames;
//var
//  bookit, bstart, bend, sigCnt, sigIt: integer;
//  sl: TWideStringList;
//begin
//  bstart := 1; bend := High(TSKShortNames);
//  sl := TWideStringList.Create;
//  sl.CaseSensitive:=false;
//  if not assigned(mSigList) then mSigList := TBibleBookNames.Create()
//  else mSigList.Clear();
//  try
//    for bookit := bstart to bend do begin
//      StrToTokens(RussianShortNames[bookit], ' ', sl);
//      sigCnt := sl.Count - 1;
//      for sigIt := 0 to sigCnt do begin
//        mSigList.AddObject(sl[sigIt], TObject(bookit));
//      end;
//    end;
//    mSigList.Sorted := true;
//  finally sl.Free(); end;
//end;

procedure TBibleLinkParser.ProcessLines(lns: TWideStrings);
begin
//IsDelimiter()
end;

function TBibleLinkParser.SetupLink(book, chapter, vstart, vend: integer;
  tokenOffset: integer; preserveStartOffset: boolean): boolean;
label tail;
begin
  result := false;
  mLinkReady := false;
  if not (lpsChapterEntered in mFlags) then goto tail;
  mOutputBibleLink.tokenEndOffset := tokenOffset;

  mOutputBibleLink.tokenStartOffset := mBibleLink.tokenStartOffset;
  if (lpoIgnoreOneNumberValues in mLinkParserOptions) and
    ((not (lpsFirstVerseEntered in mFlags)) and (not mBookExpicitSet)) then
    goto tail;
  Inc(mLinkCounter);
  mOutputBibleLink.book := book; mOutputBibleLink.chapter := chapter;
  mSaveBook := book; mSaveChapter := chapter;

  if lpsFirstVerseEntered in mFlags then begin
    mSaveV1 := vstart; mSaveV2 := vend;
    mOutputBibleLink.vstart := vstart; mOutputBibleLink.vend := vend;
  end
  else begin mOutputBibleLink.vstart := 0; mOutputBibleLink.vend := 0; end;

  mLinkReady := true;
  result := true;
  mBibleLink.tokenStartOffset := 0;
  mBibleLink.tokenEndOffset := 0;
  mBibleLink.chapter := 0;
  mV1 := 0; mV2 := 0;
  exit;
  tail:
  if not preserveStartOffset   then
     Inc(mBibleLink.tokenStartOffset);
end;

function TBibleLinkParser.VerseAdd(const tkn: WideString): TLinkMatchType;
var
  vl, err: integer;
  chk: boolean;
  saveparserstate: TLinkParserFlags;
begin
//  Val(tkn, vl, err);
  vl := VerseTokenValue(tkn, [lvroAllowPartialVerses]);
  if vl >= 0 then begin
    if vl > 300 then begin result := lmtNone; exit end;

    mLastVerse := vl;
    mVerseToChapterTransitionMade := false;
    if lpsFirstVerseEntered in mFlags then begin
      SetupLink(mBook, mChapter, mV1, mV2,
        0, false);
      mInCurrentChapterVerseAdded := true;
    end;
    mFlags := [lpsFirstVerseEntered, lpsChapterEntered, lpsBookEntered];
    result := lmtSecond;
    mLastTokenWasDelim := false;
    mPrevVerse := mV1;
    mV1 := vl;
    mV2 := vl;
    exit
  end;

  saveparserstate := mFlags;
  vl := mBook;
  chk := mBookExpicitSet;
  if BookNameParse(tkn, '') <> lmtFirst then begin
    result := lmtNone;
    exit;
  end;
  mFlags := saveparserstate;
 // mBookExpicitSet:=chk;
//  SetupLink(vl,mChapter,mV1,mV2,0);
  mBookExpicitSet := true;
//  if chk then debugbreak();
  result := lmtSecond;
  mFlags := [lpsBookEntered];
//  mBibleLink.tokenStartOffset:=1;
end;

function TBibleLinkParser.VerseStart(const tkn: WideString): TLinkMatchType;
begin

end;

function TBibleLinkParser.VerseTo(const tkn: WideString): TLinkMatchType;
var
  vl, err: integer;
begin
  //Val(tkn, vl, err);
  vl := VerseTokenValue(tkn, [lvroAllowPartialVerses]);
  if (vl < 0) or (vl > 300) then begin result := lmtNone; exit end;

//
  if (lpsFirstVerseEntered in mFlags) and (vl<=mV2) then begin
    result:=lmtFirst;
    mLinkReady:=SetupLink(mBook, mChapter, mV1, mV1,0,true);
    if mLinkReady then begin
    mFlags:= mFlags * [lpsBookEntered];
    end;
    exit;
  end;
  mLastVerse := vl;
  mV2 := vl;
  mLastTokenWasDelim := false;
  result := lmtBoth;
end;

class function TBibleLinkParser.VerseTokenValue(const tkn: WideString; options: TLinkValueRecognitionOptions = []): integer;
var err: integer;
  lastch: WideChar;
  tokLen: integer;

  function RomanVal(pTkn: PWideChar; tLength: integer): integer;
  var
    i, lastValue, curValue: integer;
  label err;
  begin
    Result := 0;
    lastValue := 0;
    Dec(tLength);
    for i := tLength downto 0 do
    begin
      case (pTkn[i]) of
        'C', 'c':
          curValue := 100;
        'D', 'd':
          curValue := 500;
        'I', 'i':
          curValue := 1;
        'L', 'l':
          curValue := 50;
        'M', 'm':
          curValue := 1000;
        'V', 'v':
          curValue := 5;
        'X', 'x':
          curValue := 10;
      else begin result := -2; exit; end;

      end;
      if curValue < lastValue then
        Dec(Result, curValue)
      else
        Inc(Result, curValue);
      lastValue := curValue;
    end;
    exit;

  end;

begin
  result := -2;
  Val(tkn, result, err);
  if err = 0 then exit;
  result := -2;
  tokLen := length(tkn);
  if (tokLen < 1) or ([lvroAllowPartialVerses, lvroAllowRomans] * options = []) then exit;

  lastch := tkn[tokLen];
  err := 1;
  if lvroAllowPartialVerses in options then
    case ord(lastch) of
      ord('a'), ord('b'), $42C, $430, $431, $44C: Val(Copy(tkn, 1, tokLen - 1), result, err);
    end;
  if err = 0 then exit;

  if (lvroAllowRomans in options) then begin
    result := RomanVal(PWideChar(Pointer(tkn)), tokLen);
    exit;
  end;
  result := -2;
end;

function Prepare(fn: WideString; var df: Text): boolean;
begin
  result := false;
  try
    TTextRec(Output) := TTextRec(df);
    if not assigned(bookNamesObj) then bookNamesObj := TBibleBookNames.Create();
    bookNamesObj.CaseSensitive := false;
    bookNamesObj.FromFile(fn);

    lparser := TBibleLinkParser.Create();
    lparser.Init();
//lparser.PrepareBookNames();
    lparser.Options :=
      lparser.Options + [lpoTextRecognition];

  except
  g_ExceptionContext.Add('Prepare.fn='+fn);
  raise;
  end;

end;

var                                     // Note fields must be declared as class fields
  mLinkedTxtBuffer: PWideChar;
  mLinkedTxtBufferLen: integer;

function bqIsDelimiter(wc: WideChar; var Ignore: boolean): boolean;

begin

//  if (integer(wc) > 255) then begin result := false; exit; end;
//  case integer(wc) of
//    0..$2F, $3A..$40, $5B..$60, $7B..$7E,
//    ord('Ч')  //,$82,$84,$85, $8B,$91..$97
//      : result := true;
//  else result := false;
//  end;
  Ignore := (wc <> ':') and (wc <> '.') and (wc <> ',') and (wc <> '-') and
    (wc <> ';') and ((integer(wc) < ($2010)) or (integer(wc) > $2015));

  result := not UnicodeIsAlphaNum(Cardinal(wc));

end;

function IsTerminator(ch: WideChar): boolean; inline;
begin
  case ch of
    #$D, ')', '(': result := true;
  else result := false;
  end;                                  //case
end;

function extractLnks(const txt:WideString;var la:TBibleLinkArray):boolean;
begin
lparser.mBlArray:=la;
Include(lparser.mLinkParserOptions,lpoExtractLnks);
try
ResolveLnks(txt);
finally
exclude(lparser.mLinkParserOptions,lpoExtractLnks);
end;
end;

function ResolveLnks(const txt: WideString): WideString;
var
  pCurrent, pLastTag, pFirstToken, pSavedFirstToken, pSecondToken, pLinkStart, pNewLinkStart,
    pWriteBuf, pWriteFence, pLastWrittenFrom, pLastTokenParsed,
    pOldLastTokenParsed,
    psFence, pLastLink, pTerm, pNewCurrent, pMoveOrg: PWideChar;
  firstToken, secondToken: WideString;
  state, writeCnt, sourceLen, ix, tknCounter, vl, patchDelta, dbg_tki: integer;
  saveChar: WideChar;
  extractLnks, firstTokenFound: boolean;
  lmt: TLinkMatchType;
  pBibleLnk: PBibleLink;
  wsLinkCode: WideString;
  blIgnoreDelimiter, isTokenSeparator, delUsed: boolean;
  ctrLastTokensParsed, ctrLinkStarts: TBQHistoryContainer;
  pf, pc1, pc2: int64;
  tc: integer;

  procedure ValidateBuffer(p: PAnsiChar);
  var cbWriteOffset:integer;
  begin
    if p >= pWriteFence then begin
      Inc(mLinkedTxtBufferLen, sourceLen * 4);
      cbWriteOffset:=pWriteBuf-mLinkedTxtBuffer ;
      ReallocMem(mLinkedTxtBuffer, mLinkedTxtBufferLen);
      pWriteBuf:=mLinkedTxtBuffer+cbWriteOffset;
      pWriteFence := mLinkedTxtBuffer + (mLinkedTxtBufferLen div 2);

    end;
  end;

  procedure subWriteBuffer(pStart, pLinkEnd: PWideChar);

  begin
    //if pLinkStart = nil then ls := pLastLink else ls := pLinkStart;

    writeCnt := PAnsiChar(pStart) - PAnsiChar(pLastWrittenFrom);
    if not extractLnks then begin
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt);
    move(pLastWrittenFrom^, pWriteBuf^, writeCnt);
    end;
    Inc(PAnsiChar(pLastWrittenFrom), writeCnt);
    Inc(PAnsiChar(pWriteBuf), writeCnt);

    wsLinkCode := pBibleLnk^.GetHref(lparser.mLinkCounter);
    writeCnt := length(wsLinkCode) * 2;
    if not extractLnks then begin
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt);
    move(Pointer(wsLinkCode)^, pWriteBuf^, writeCnt);
    end
    else begin
      lparser.AddLink(pBibleLnk^);
    end;

    Inc(PAnsiChar(pWriteBuf), writeCnt);

    writecnt := PAnsiChar(pLinkEnd) - PAnsiChar(pStart);
    pLastWrittenFrom := pLinkEnd;
   if not extractLnks then begin
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt);
    move(Pointer(pStart)^, pWriteBuf^, writeCnt);
    end;
    Inc(PAnsiChar(pWriteBuf), writeCnt);

    wsLinkCode := '</a></a>';
    writeCnt := length(wsLinkCode) * 2;
    if not extractLnks then begin
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt);
    move(Pointer(wsLinkCode)^, pWriteBuf^, writeCnt) ;
    end;
    Inc(PAnsiChar(pWriteBuf), writeCnt);
  end;

 procedure subRecordLnk(pStart, pLinkEnd: PWideChar);

  begin
    //if pLinkStart = nil then ls := pLastLink else ls := pLinkStart;

    writeCnt := PAnsiChar(pStart) - PAnsiChar(pLastWrittenFrom);
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt);
    move(pLastWrittenFrom^, pWriteBuf^, writeCnt);
    Inc(PAnsiChar(pLastWrittenFrom), writeCnt);
    Inc(PAnsiChar(pWriteBuf), writeCnt);

    wsLinkCode := pBibleLnk^.GetHref(lparser.mLinkCounter);
    writeCnt := length(wsLinkCode) * 2;
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt);
    move(Pointer(wsLinkCode)^, pWriteBuf^, writeCnt);
    Inc(PAnsiChar(pWriteBuf), writeCnt);

    writecnt := PAnsiChar(pLinkEnd) - PAnsiChar(pStart);
    pLastWrittenFrom := pLinkEnd;
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt);
    move(Pointer(pStart)^, pWriteBuf^, writeCnt);
    Inc(PAnsiChar(pWriteBuf), writeCnt);

    wsLinkCode := '</a></a>';
    writeCnt := length(wsLinkCode) * 2;
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt);
    move(Pointer(wsLinkCode)^, pWriteBuf^, writeCnt);
    Inc(PAnsiChar(pWriteBuf), writeCnt);
  end;

  procedure InsertPatch(pSourcePos: PWideChar; sourceReplaceCnt: integer; const replaceStr: WideString);
  var writeCnt: integer;
    patchLen: integer;
  begin
    writeCnt := PAnsiChar(pSourcePos) - PAnsiChar(pLastWrittenFrom);
//    patchLen:=length(replaceStr)*2;
    ValidateBuffer(PAnsiChar(pWriteBuf) + writeCnt {+patchLen});
    move(pLastWrittenFrom^, pWriteBuf^, writeCnt);
    Inc(PAnsiChar(pLastWrittenFrom), writeCnt {+sourceReplaceCnt});
    Inc(PAnsiChar(pWriteBuf), writeCnt);
    exit;

    move(Pointer(replaceStr)^, pWriteBuf^, patchLen);
    Inc(PAnsiChar(pWriteBuf), patchLen);
  end;

  procedure AddTokenPos(lmt: TLinkMatchType; shrintToFirst: boolean = false);
  var le, dbg:PWideChar;
    ln:integer;
  begin
  //detect the beginning of current hit
    if shrintToFirst then lmt := lmtFirst;

    if (lmt = lmtFirst) or (lmt = lmtConCat) or (lmt = lmtBoth) then
      pLinkStart := pSavedFirstToken
    else if lmt = lmtSecond then pLinkStart := pSecondToken;
    {$IFDEF DEBUG}
      write(WideFormat('pushed lnkstart:%.20s',[pLinkStart] ),#13#10);
    {$ENDIF}
    ctrLinkStarts.push(PAnsiChar(pLinkStart));
   //record the end of the current hit
    if lmt = lmtFirst then begin
      le:=pSavedFirstToken + length(firstToken);
     {$IFDEF DEBUG}
// #     write(WideFormat('pushed lnkend:%.20s',[pSavedFirstToken + length(firstToken)] ),#13#10);
    {$ENDIF}
      end
    else if (lmt >= lmtConCat) then begin
    le:=pSecondToken + length(secondToken);
     {$IFDEF DEBUG}
//        write(WideFormat('pushed lnkend:%.20s',[pSecondToken + length(secondToken)] ), #13#10);
     {$ENDIF}
    end
    else le:=nil;
    if le<>nil then begin
     ctrLastTokensParsed.Push(PAnsiChar(le));
     ln:=PWideChar(le)-PWideChar(pLinkStart) ;
    write(WideFormat('токен %.*s',[ln, pLinkStart]),#13#10);

     end;
    Inc(tknCounter);
   {$IFDEF DEBUG}
        write(WideFormat('in addtknpos tknCounter:%d',[tknCounter] ),#13#10);
  {$ENDIF}
  end;

  function bqParseContextStr(): WideString;
  var ws: WideString;
    pl, pf: PWideChar;
  begin
    result := WideFormat('Ctx: l:%s r:%s', [firstToken, secondToken]);
    if assigned(pBibleLnk) then
      result := result + #13#10 + WideFormat(
        'bl: bk=%d, ch=%d vs=%d ve=%d (%d:%d) lmt=%d tknc=%d',
        [pBibleLnk^.book, pBibleLnk^.chapter,
        pBibleLnk^.vstart, pBibleLnk^.vend, pBibleLnk^.tokenStartOffset,
          pBibleLnk^.tokenEndOffset, ord(lmt), tknCounter]);
    pl := pCurrent + 30;
    if pl >= psFence then pl := psFence - 1;
    pf := pCurrent - 70;
    if pf < PWideChar(Pointer(txt)) then pf := PWideChar(Pointer(txt));
    pl^ := #0;
    ws := pf;
    result := result + #13#10 + ws;
  end;

begin
  extractLnks:=lpoExtractLnks in lparser.mLinkParserOptions;
  tc := GetTickCount();
  dbg_tki := 0;

  try
    result:='';
    sourceLen := length(txt);
    if sourceLen<=0 then begin
    exit;
    end;

    state := 0; firstTokenFound := false;

    ctrLastTokensParsed.Init(16);
    ctrLinkStarts.Init(16); tknCounter := 0;
    if sourceLen * 4 > mLinkedTxtBufferLen then begin
      mLinkedTxtBufferLen := sourceLen * 4;
      ReallocMem(mLinkedTxtBuffer, mLinkedTxtBufferLen);
    end;
    pWriteBuf := mLinkedTxtBuffer;
    pWriteFence := mLinkedTxtBuffer + (mLinkedTxtBufferLen div 2);
    pCurrent := PWideChar(Pointer(txt));
    psFence := pCurrent + sourceLen;
    lparser.Init();
    pLastWrittenFrom := pCurrent;
    pTerm := nil;
    if pCurrent^ <> '<' then pFirstToken := pCurrent else pFirstToken := nil;
    pSecondToken := nil;
    pLinkStart := nil;
    pSavedFirstToken := pFirstToken;
    delUsed := false;
    repeat

      if (pCurrent^ = '>') then begin
        state := 0;
        if not (firstTokenFound) then begin
          pFirstToken := pCurrent + 1; pSavedFirstToken := pFirstToken; delUsed := false; end
        else pSecondToken := pCurrent + 1;
      end
      else if (state = 0) then begin
        blIgnoreDelimiter := true;
        patchDelta := 0;
        if (pCurrent^ = '&') and ((pCurrent + 1)^ = '#') then begin
          pNewCurrent := PWideChar2Int(pCurrent + 2, vl);
          patchDelta := pNewCurrent - pCurrent;
          if (pNewCurrent^ = ';') and (patchDelta > 2) then begin
            if vl = 151 then vl := 8212;
            if firstTokenFound then begin
              pMoveOrg := pSavedFirstToken;
              Inc(pSavedFirstToken, patchDelta);
              if pSecondToken <> nil then Inc(pSecondToken, patchDelta);
            end
            else if pFirstToken <> nil then begin
              pMoveOrg := pFirstToken;
              Inc(pFirstToken, patchDelta);
            end;
//          InsertPatch(pCurrent,0,'');

            pMoveOrg := pLastWrittenFrom;

            move(pMoveOrg^, (pMoveOrg + patchDelta)^,
              (pCurrent - pMoveOrg) * 2);

            Inc(pLastWrittenFrom, patchDelta);
            ctrLastTokensParsed.OffsetTokens((patchDelta) * 2);
            ctrLinkStarts.OffsetTokens((patchDelta) * 2);
            Inc(pCurrent, patchDelta); ;
            pCurrent^ := WideChar(vl);
          end else patchDelta := 0;
        end;

        isTokenSeparator := bqIsDelimiter(pCurrent^, blIgnoreDelimiter);

        if isTokenSeparator or delUsed then begin
          delUsed := (not blIgnoreDelimiter);
          if (pSecondToken <> nil) then begin
            if (PCurrent - pSecondToken < 1) then begin
              if isTokenSeparator then
                pSecondToken := pCurrent + ord(blIgnoreDelimiter)
            end
            else begin                  //secord word are ready!
              saveChar := pCurrent^; pCurrent^ := #0;
              secondToken := pSecondToken; pCurrent^ := savechar;

              lmt := lparser.AddTokens(firstToken, secondToken, pBibleLnk);
               Inc(dbg_tki);
{$IFDEF DEBUG}
              if lmt > lmtNone then
              write(WideFormat('tokens: %s & %s rslt: %s, dbg_tki: %d',[firstToken, secondToken,  WideString(GetEnumName(TypeInfo(TLinkMatchType), ord(lmt))),dbg_tki]),#13#10);

{$ENDIF}
              if lmt > lmtNone then begin
                AddTokenPos(lmt);
//                if (pCurrent^ = '.') and
//                  (lpsBookEntered in lparser.ParserFlags)
//                  and not (lpsChapterEntered in lparser.ParserFlags)
//                    then blIgnoreDelimiter := true;
                if (assigned(pBibleLnk)) then begin
                  if pBibleLnk^.tokenStartOffset > 0 then Now();
                  subWriteBuffer(
                    PWideChar(ctrLinkStarts.items[tknCounter
                    - 1 - pBibleLnk^.tokenStartOffset]),
                      PWideChar(ctrLastTokensParsed.items[1 +
                    pBibleLnk^.tokenEndOffset])
                      );
//                  if lmt>lmtNone then tknCounter:=0;//else we'll need it later
                  tknCounter := pBibleLnk^.tokenEndOffset + 1;
                  {$IFDEF DEBUG}
                  writeln('in first wr tknCounter: ', tknCounter);
                  {$ENDIF}

                end;                    //if bible link pending
              end;                      //if hit in parser

              if lmt = lmtNone then begin //finalize parse
               //finalize parse when tokens not match, add pending tokens
                lparser.FinalizeParse(pBibleLnk);
                if assigned(pBibleLnk) then begin
                  if pBibleLnk^.tokenStartOffset > 0 then
                    Now;

                  subWriteBuffer(
                    PWideChar(ctrLinkStarts.items[tknCounter - 1 - pBibleLnk^.tokenStartOffset]),
                    PWideChar(ctrLastTokensParsed.Items[pBibleLnk^.tokenEndOffset])
                    );
                {$IFDEF DEBUG}
                  writeln('after fin  tknCounter: 0 nulled: ');
                 {$ENDIF}

                end;
                tknCounter := 0;
  //              pLinkStart := nil;
              end;

//              if pLinkStart <> nil then pLastLink := pLinkStart;
              if (lmt = lmtNone) or (lmt = lmtFirst) then begin
                firstToken := secondToken;
                pSavedFirstToken := pSecondToken;
                pSecondToken := pCurrent +
                  ord(isTokenSeparator and blIgnoreDelimiter)
                {+patchdelta};
              end                       //if skip one char
              else begin
                firstTokenFound := false;
                //next char+ (1 if separator to ignore)
                pFirstToken := pCurrent + ord(isTokenSeparator and blIgnoreDelimiter);
                pSavedFirstToken := pFirstToken;
                pSecondToken := nil;
              end;                      //else -skip 2 chars

            end;                        //else - Second word is 1 or chars
          end                           //second word not nil
          else begin
            if (not firstTokenFound) then begin
              if (pFirstToken = nil) or (PCurrent - pFirstToken < 1) then begin
                pFirstToken := pCurrent + {patchdelta+} ord(isTokenSeparator and blIgnoreDelimiter);
                pSavedFirstToken := pFirstToken;
              end
              else begin
                saveChar := pCurrent^; pCurrent^ := #0;
                firstToken := pFirstToken; pCurrent^ := savechar;
                firstTokenFound := true;
                pSecondToken := pCurrent + {patchdelta+} ord(isTokenSeparator and blIgnoreDelimiter);
//              pSaveFw := pFw;
                pFirstToken := nil
              end;
            end
            else pSecondToken := pCurrent + 1;
          end                           //second is about to find
        end;                            //separator
//        Inc(pCurrent,patchDelta);

      end;                              //state
      if (state = 0) and IsTerminator(PCurrent^) then begin
        delUsed := true;
        if firstTokenFound then begin
          lmt := lparser.AddTokens(firstToken, ' ', pBibleLnk);
          if lmt <> lmtNone then
          begin
            AddTokenPos(lmt, true);
            if assigned(pBibleLnk) then begin
              subWriteBuffer(
                PWideChar(ctrLinkStarts.items[tknCounter - 1 - pBibleLnk^.tokenStartOffset]),
                PWideChar(ctrLastTokensParsed.Items[pBibleLnk^.tokenEndOffset + 1])
                );
              tknCounter := 0;          // pBibleLnk^.tokenEndOffset + 1;
            end;
          end;
        end;

        lparser.FinalizeParse(pBibleLnk);

        if assigned(pBibleLnk) then begin
         // if tknCounter=0 then DebugBreak;
          subWriteBuffer(
            PWideChar(ctrLinkStarts.items[tknCounter - 1 - pBibleLnk^.tokenStartOffset]),
            PWideChar(ctrLastTokensParsed.Items[pBibleLnk^.tokenEndOffset])
            );
        end;
        tknCounter := 0;
        lparser.mFlags := lparser.mFlags * [lpsBookEntered];
//      tknCounter:=0;
        firstTokenFound := false; pSavedFirstToken := nil;
        pSecondToken := nil; pFirstToken := nil;
      end;

      if pCurrent^ = '<' then begin
        state := 1;
        pLastTag := pCurrent;
      end;
      inc(pCurrent);
    until (pCurrent^ = #0) or (pCurrent >= psFence);
    writeCnt := PAnsiChar(psFence)  - PAnsiChar(pLastWrittenFrom);
    if not extractLnks then begin
    ValidateBuffer(PAnsiChar(pWriteBuf) + writecnt+2);
    Move(pLastWrittenFrom^, pWriteBuf^, writeCnt);
    PWideChar( PChar(pWriteBuf)+writeCnt )^:=#0;

    result := mLinkedTxtBuffer;
    end;
  except on e: Exception do begin
      if not extractLnks then
      result := txt;
      BqShowException(e,bqParseContextStr());
    end;
  end;
  ctrLastTokensParsed.Done();
  tc := GetTickCount() - tc;
  if tc = 0 then tc := 1;
  writeln('length:', sourceLen, ' wchars in ', tc, ' ticks, avr ', sourceLen div tc, ' wchar/tick');
  Flush(Output);
//  ShowMessageFmt('length: %d uchars in %d ticks, avr %f char/ms',[sourceLen, tc,sourceLen/tc]);
end;

{ TBibleBookNames }

constructor TBibleBookNames.Create;
begin
  inherited;
  mModSigs := TWideStringList.Create();

end;

function TBibleBookNames.FromFile(const fn: WideString): boolean;
var i, sli, slc, searchSlen, val, tokenIx, tokenCnt: integer;
  notFnd: boolean;
  ws, ws2, ss: wideString;
  sl, tokens: TWideStringList;
  pItem: TBibleBookNameEntry;
label fnd1, fnd2;
begin
  try
    result := false;
    sl := TWideStringList.Create;
    try
      Clear();
      sl.LoadFromFile(fn);
      tokens := TWideStringList.Create;
      i := 1; sli := 0; slc := sl.Count;
      sorted := true; Duplicates := dupIgnore;

      if slc <= 0 then begin result := false; exit end;

      repeat
        pItem := nil;
        ss := 'bqBibleBook';            //+inttoStr(i) ;
        searchSlen := length(ss);
        repeat
          ws := sl.Names[sli];
          if Pos(ss, ws) = 1 then goto fnd1;
          sl.Delete(sli);
          Dec(slc);
        until sli >= slc;
        break;
        fnd1:
        val := StrToInt(Copy(ws, searchSlen + 1, $FFF));
        ws := sl.ValueFromIndex[sli];

        ss := 'bqChaptersCount' + inttoStr(val);
        searchSlen := length(ss);
        repeat
          ws2 := sl[sli];
          if Pos(ss, ws2) = 1 then goto fnd2;
          sl.Delete(sli);
          Dec(slc);
        until sli >= slc;
        break;
        fnd2:
        tokens.Clear();
        StrToTokens(ws, '|', tokens);
        tokenCnt := tokens.Count - 1;
        for tokenIx := 0 to tokenCnt do begin
          pItem := TBibleBookNameEntry.Create;
          pItem.nameBookIx := val;
          pItem.chapterCnt := StrToInt(Copy(ws2, searchSlen + 2, $FFF));
          pItem.modSigIx := 0;
          AddObject(tokens[tokenIx], pItem);
        end;
        inc(sli);
      until (sli >= slc);
      Sorted := true;
    finally sl.Free(); end;
    result := true;
  except
on e:exception do begin
  g_ExceptionContext.Add('TBibleBookNames.FromFile.fn='+fn);
  BqShowException(E);
  end;
  end;
end;

function TBibleBookNames.ItemIndexFromBookIx(): integer;
begin

end;

{ TBQBooksHistory }

function TBQBooksHistory.BestValidBookFor(chapter, key: integer): TBibleBookNameEntry;
begin
//
end;

initialization
   // Enable raw mode (default mode uses stack frames which aren't always generated by the compiler)
  Include(JclStackTrackingOptions, stRawMode);
  // Disable stack tracking in dynamically loaded modules (it makes stack tracking code a bit faster)
  Include(JclStackTrackingOptions, stStaticModuleList);
  // Initialize Exception tracking
  JclStartExceptionTracking;

end.

