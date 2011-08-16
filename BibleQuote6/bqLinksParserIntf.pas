unit bqLinksParserIntf;
interface
type
  TBibleBookNameEntry=class
  public
    nameBookIx:integer;
    chapterCnt:integer;
    key,usgCnt, lastHitPos:integer;
    modSigIx:integer;
    destructor Destroy;override;
  end;

  TBibleLinkProcessingOption=(blpLimitChapterTxt);
  TBibleLinkProcessingOptions= set of   TBibleLinkProcessingOption;
  TLikenessTraits=(bltBook, bltChapter, bltVerse1, bltVerse2);
  TBibleLinkLikeness=set of TLikenessTraits;

  TBibleLink=object
    book, chapter, vstart, vend,tokenStartOffset, tokenEndOffset:integer;
    function AsString():WideString;
    procedure Reset();
    procedure Build(aBook, aChapter, aVStart, aVEnd:integer);
    function GetHref(idNum:cardinal=0;bloOptions: TBibleLinkProcessingOptions=[]):WideString;
    function ToCommand(const path: WideString; bloOptions: TBibleLinkProcessingOptions=[]):WideString;
    function FromBqStringLocation(loc:WideString; out path:WideString):boolean;
    function GetLikeNess(const bl:TBibleLink):TBibleLinkLikeness;
    procedure AssignTo(out dest:TBibleLink);
  end;
  PBibleLink=^TBibleLink;
  TBibleLinkArray=array of TBibleLink;
  TBibleLinkExLikeNessTraits=(bllTag, bllModName,bllBook, bllChapter, bllVerse1, bllVerse2);
  TBibleLinkExLikeness=set of TBibleLinkExLikeNessTraits;
  TBibleLinkEx=object(TBibleLink)
  modName:WideString;
  tag:Cardinal;
  function FromBqStringLocation(loc:WideString):boolean;
  function GetLikeNess(const bl:TBibleLinkEx):TBibleLinkExLikeness;
  function ToCommand(bloOptions: TBibleLinkProcessingOptions=[]):WideString;
  function IsAutoBible():boolean;
  function GetIniFileShortPath():WideString;
  function VisualSig():WideString;
  destructor Destroy();
  end;

  PBibleLinkEx=^TBibleLinkEx;

implementation
uses SysUtils, BibleQuoteConfig,Windows;

const
  gRussianShortNames: array[1..66] of WideString =
    // used to translate dictionary references
  (
    'Быт. Ge.',
    'Исх. Ex.',
    'Лев. Lv.',
    'Чис. Num.',
    'Втор.Deut.',
    'Нав. Jos.',
    'Суд. Jdg.',
    'Руф. Ru.',
    '1Цар.1Sa.',
    '2Цар.2Sa.',
    '3Цар. 1Ki.',
    '4Цар. 2Ki.',
    '1Пар. 1Ch.',
    '2Пар.2Ch.',
    'Ездр.Ezr.',
    'Неем.Neh.',
    'Есф.Esth. Est.',
    'Иов Job',
    'Пс. Ps.',
    'Прит. Pr.',
    'Еккл Ec.',
    'Песн. Song.',
    'Ис. Isa.',
    'Иер. Jer.',
    'Плач. Lam.',
    'Иез. Ez.',
    'Дан. Dan.',
    'Ос. Hos.',
    'Иоил. Joel',
    'Ам. Am.',
    'Авд. Obad.',
    'Ион. Jona',
    'Мих. Mic.',
    'Наум. Nah.',
    'Авв. Hab.',
    'Соф. Zeph.',
    'Агг. Hag.',
    'Зах. Ze.',
    'Мал. Mal.',
    'Мф. Mt.',
    'Мк. Mk.',
    'Лк. Lk.',
    'Ин. Jn.',
    'Деян. Acts',
    'Иак. Jms.',
    '1Пет. 1Pe.',
    '2Пет. 2Pe',
    '1Ин. 1Jn.',
    '2Ин.  2Jo.',
    '3Ин. 3Jn.',
    'Иуд. Jud.',
    'Рим. Ro.',
    '1Кор. 1Co.',
    '2Кор. 2Co.',
    'Гал. Gal.',
    'Еф. Eph.',
    'Фил. Php.',
    'Кол. Col.',
    '1Фес. 1Th.',
    '2Фес. 2Th.',
    '1Тим. 1Tim.',
    '2Тим. 2Tim.',
    'Тит. Tit.',
    'Флм. Phm.',
    'Евр. Heb.',
    'Отк. Re.'
    );

type TfnResolveLnks=function(const txt: WideString): WideString;
     TfnPrepare=function(fn:WideString;var df:Text):boolean;

//var _sparser:HModule;
//    fnResolveLnks:TfnResolveLnks=nil;
//    fnPrepare:TfnPrepare=nil;
    //parserAvail:boolean;






function ExtractFirstTkn(var s: WideString): WideString;
var
  s1: WideString;
  i: integer;
begin
  Result := s;

  s1 := Trim(s);
  i := Pos(' ', s1);
  if i > 0 then begin
    Result := Copy(s, 1, i-1);
    s := Copy(s1, i+1, Length(s1));
  end
  else s := '';
 end;

{ TBibleLink }
function TBibleLink.AsString: WideString;
var bn:WideString;
    i:integer;
begin
   i:=Pos(' ',gRussianShortNames[book]);
   if i<=0 then i:=$FF;
   bn:=Copy(gRussianShortNames[book],1, i-1);
  if vstart <=0 then begin
      Result:=WideFormat('%s %d',[bn, chapter] );
      exit;
  end;
  if vend >0 then
   Result:= WideFormat('%s %d:%d-%d', [bn, chapter,vstart, vend ])
   else
    Result:=WideFormat('%s %d:%d',[bn, chapter, vstart ] );
end;

procedure TBibleLink.AssignTo(out dest:TBibleLink);
begin
dest.book:=book;dest.chapter:=chapter;dest.vstart:=vstart;dest.vend:=vend;
dest.tokenStartOffset:=tokenStartOffset; dest.tokenEndOffset:=tokenEndOffset;
end;


procedure TBibleLink.Reset();
begin
book:=0;chapter:=0; vstart:=0; vend:=0;tokenStartOffset:=0; tokenEndOffset:=0;
end;

function TBibleLink.FromBqStringLocation( loc: WideString; out path:WideString): boolean;
var value:WideString;
begin
try

   path := ExtractFirstTkn(loc);
   book:=1; chapter:=1; vstart:=0; vend:=0;
   if path='go' then  path := ExtractFirstTkn(loc)
   else {if path='file' then} begin result:=false; exit; end;
  //читаем номер книги
    result:=true;
    value := ExtractFirstTkn(loc);
    if value = '' then exit;
    book :=  StrToInt(value);
    //читаем номер главы
    value := ExtractFirstTkn(loc);
    if value = '' then exit;
    chapter := StrToInt(value);
    //читаем номер начального стиха
    value := ExtractFirstTkn(loc);
    if value = '' then exit;
    vstart := StrToInt(value);
    // читаем номер конечного стиха
    value := ExtractFirstTkn(loc);
    if value <> '' then
      vend := StrToInt(value)
    else
      vend := vstart;
    result:=true;
except result:=false; end;

  //формируем путь к ini модуля
end;

function TBibleLink.GetHref(idNum:cardinal=0;bloOptions: TBibleLinkProcessingOptions=[]): WideString;
//var id:widestring;
begin
//result:='<a href="'+AsString() + '">';
//  if vstart <=0 then begin
//      Result:=WideFormat('<a href="go rststrong %d %d 1 0">',[book, chapter] );
//      exit;
//  end;
//  if vend >0 then
//   Result:= WideFormat('<a href="go rststrong %d %d %d %d">', [book, chapter,
//     vstart, vend ])
//   else
//    Result:=WideFormat('<a href="go rststrong %d %d %d 0">',[book,
//     chapter, vstart ] );
//if idNum=0 then
result:=WideFormat('<a href="%s " ID="bqResLnk%d" '+
'CLASS=bqResolvedLink >',[ToCommand(C__bqAutoBible,bloOptions), idNum]);
//'<a href="'+ ToCommand(C__bqAutoBible,bloOptions)
//+'" ID="bqResLnk'+Inttostr(idNum)+'" CLASS=bqResolvedLink >';
//else
//result:='<a href="'+ ToCommand(C__bqAutoBible,bloOptions)
//      + '" NAME "bqResLnk'+Inttostr(idNum)+'" CLASS=bqResolvedLink >';
if idNum>0 then result:=WideFormat('<A NAME="bqResLnk%d">%s',
      [idNum,result]);

end;

function TBibleLink.GetLikeNess(const bl: TBibleLink): TBibleLinkLikeness;
begin
result:=[];
if self.book=bl.book then Include(result,bltBook);
if self.chapter = bl.chapter then Include(result, bltChapter);
if self.vstart=bl.vstart then Include(result, bltVerse1);
if self.vend=bl.vend then Include(result, bltVerse2);

end;

function TBibleLink.ToCommand(const path: WideString; bloOptions: TBibleLinkProcessingOptions=[]): WideString;
begin
  if vstart <=0 then begin
      Result:=WideFormat('go %s %d %d 0 0',[path,book, chapter] );
      exit;
  end;
  if vend >0 then
   Result:= WideFormat('go %s %d %d %d %d', [path,book, chapter,
     vstart, vend ])
   else
    Result:=WideFormat('go %s %d %d %d 0',[path,book,
    chapter, vstart ] );
end;

procedure TBibleLink.Build(aBook, aChapter, aVStart, aVEnd:integer);
begin
Reset();
book:=aBook; chapter:=aChapter; vstart:=avstart; vend:=avend;
end;
{TBibleLinkEx}
function TBibleLinkEx.FromBqStringLocation(loc:WideString):boolean;
begin
result:=inherited FromBqStringLocation(loc,modName);
end;
destructor TBibleLinkEx.Destroy();
begin
end;

function TBibleLinkEx.GetLikeNess(const bl:TBibleLinkEx):TBibleLinkExLikeness;
begin
result:=[];
if WideCompareText(self.modName, bl.modName)=0 then
    Include(result, bllModName);
if self.tag=bl.tag then include(result,bllTag);
if self.book=bl.book then Include(result,bllBook);
if self.chapter = bl.chapter then Include(result, bllChapter);
if self.vstart=bl.vstart then Include(result, bllVerse1);
if self.vend=bl.vend then Include(result, bllVerse2);

end;


 function TBibleLinkEx.ToCommand(bloOptions: TBibleLinkProcessingOptions=[]):WideString;
 begin
  result:= inherited ToCommand(modName, bloOptions );
 end;

 function TBibleLinkEx.VisualSig():WideString;
 begin
 result:=modName+ ' '+ AsString();
 end;

function TBibleLinkEx.IsAutoBible():boolean;
begin
result:=modName=C__bqAutoBible;
end;

function TBibleLinkEx.GetIniFileShortPath():WideString;
begin
result:=modName + '\'+C_ModuleIniName;
end;

destructor TBibleBookNameEntry.Destroy;
begin
inherited;
end;

end.
