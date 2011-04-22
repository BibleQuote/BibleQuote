unit VersesDB;

interface

uses
  SysUtils, Classes, DB, BibleQuoteUtils, ASGSQLite3, contnrs,bqLinksParserIntf;

type
  TVersesNodeType = (bqvntTag, bqvntVerse);

  TVersesNodeData = class

    nodeType: TVersesNodeType;
    SelfId: int64;
    cachedTxt: WideString;
    fnt:WideString;
    Parents: TObjectList;
    class var cdTags, cdVerses:TASQLite3Query;
    constructor Create(const aSelfId: int64; const name: UTF8String; vt: TVersesNodeType);
    destructor Destroy(); override;
    function getText(): WideString;
    function getBibleLinkEx():TBibleLinkEx;
    procedure packCached(const sig:WideString; const txt:WideString; const font:WideString);
    function unpackCached(const ws:WideString; out sig:WideString; out font:WideString; out txt:WIdeString):HRESULT;//return text
    class function FindNodeById(lst: TObjectList; id: int64; nodeType: TVersesNodeType; out node: TVersesNodeData): integer; static;
  end;
  TTagOperation=procedure (id:int64; const txt:wideString) of object;
  TVerseOperation=procedure ( verse_id,tagId:int64; const book_cmd:WideString) of object;
  TVerseListEngine = class(TDataModule)
    cdTagNames: TASQLite3Query;
    cdVerses: TASQLite3Query;
    cdRelations: TASQLite3Query;
    DbTags: TASQLite3DB;
    cdTagNamesTagId: TIntegerField;
    cdRelationsTAGID: TIntegerField;
    cdRelationsVERSEID: TIntegerField;
    cdVersesID: TIntegerField;
    cdVersesChapterIx: TIntegerField;
    cdVersesVerseStart: TIntegerField;
    cdVersesVerseEnd: TIntegerField;
    cdRelationsVersBookIx: TIntegerField;
    cdRelationsVerseChapter: TIntegerField;
    cdRelationsVerseStart: TIntegerField;
    cdRelationsVerseEnd: TIntegerField;
    cdTagNamesTagName: TStringField;
    cdVersesBookIx: TIntegerField;
    RelationsRELATIONID: TIntegerField;
    RelationsTagName: TStringField;
    updSQL: TASQLite3UpdateSQL;
    procedure dsRelsDataChange(Sender: TObject; Field: TField);
    procedure dsTagsDataChange(Sender: TObject; Field: TField);
    procedure dsTagsUpdateData(Sender: TObject);
  private
    { Private declarations }
    mInitialized: boolean;
    mTagAdded, mTagDeleted:TTagOperation;
    mVerseAdded, mVerseDelled:TVerseOperation;
    function CreateDB(const path: WideString): integer;

    function InternalAddTag(const ws: WideString; out dbTagid:int64): integer;
    function InternalAddVerse(bk, ch, vs, ve: integer; out dbVerseId:int64): HRESULT;
    function InternalAddRelation(dbTagId, dbVerseId, relationId:int64):HRESULT;
    function RelationFromChar(ch:WideChar):integer;
    function InternalDeleteTag(const tn: WideString;dbTagid:int64; uiRelaxed:boolean): integer;
    function InternalCheckVerseLive(verseId:int64):boolean;
  public
    procedure InitVerseListEngine(const fromPath: WideString;tagAdded,tagDeleted:TTagOperation; verseAdded, verseDeleted:TVerseOperation);
    function SeedNodes(NodeLst: TObjectList): integer;
//    function AddTagged(tgid: int64; bk, ch, vs, ve: integer): HRESULT;overload;
    function AddVerseTagged(tagsList:WideString; bk, ch, vs, ve: integer): HRESULT;
    function AddTag(const tn: Widestring): integer;
    function DeleteTag(const tn: WideString;dbTagid:int64; uiRelaxed:boolean=false): integer;
    { Public declarations }
  end;

  TbqVerseTagsList=class(TObjectList)
    function FindTagItem(const txt: WideString):TVersesNodeData;
    function FindItemIxById(id:int64; startIx:integer):integer;

  end;
var
  VerseListEngine: TVerseListEngine;
const RELATION_NORMAL=20;
implementation
uses BQExceptionTracker,bqPlainUtils,WideStringsMod,BibleQuoteConfig, Windows;
{$R *.dfm}

{ TVerseListEngine }

function TVerseListEngine.AddTag(const tn: Widestring): integer;
var dbTagid:int64;
begin
  cdTagNames.SQL.Text := 'select * from TagNames where TagName like "' + tn + '"';
  cdTagNames.Open();
  if cdTagNames.Eof then begin
    result := InternalAddTag(tn,dbTagId ); cdTagNames.Close();
    cdTagNames.SQL.Text:='select * from TagNames';
    cdTagNames.Open();
  end;
  if not cdTagNames.Eof then result := cdTagNames.FieldByName('TagId').AsInteger;

end;

//function TVerseListEngine.AddTagged(tgid: integer; bk, ch, vs,
//  ve: integer): HRESULT;
//var
//  matchCount, i: integer;
//  w: UTF8String;
//begin
//  try
////cdTagNames.Connection:=DbTags;
////cdTagNames.Open;
//    cdVerses.Last();
//    result := DbTags.SQLite3_ExecSQL(Format(
//      'insert into [Verses] (BookIx,ChapterIx,VerseStart,VerseEnd) values (%d,%d,%d,%d)',
//      [bk, ch, vs, ve]));
//    cdVerses.Last();
//
//    result := DbTags.SQLite3_ExecSQL(Format(
//      'insert into [VTRelations] (TAGID, VERSEID) values (%d,%d)',
//      [tgid, cdVersesID.AsInteger]));
//  except on e: Exception do BqShowException(e) end;
//end;

function TVerseListEngine.AddVerseTagged(tagsList: WideString; bk, ch, vs,
  ve: integer): HRESULT;
  var sl:TWideStringList;
var i,c:integer;
     dbTagId,dbVerseId: int64;
    firstChar:WideChar;
    curTag:WideString;
    relation:integer;
begin
sl:=TWideStringList.Create();
StrToTokens(tagsList, '|',sl);
c:=sl.Count-1;
cdVerses.SQL.Text:=WideFormat('Select * from [Verses] where ((BookIx=%d) AND  '+
'(ChapterIx=%d) AND (VerseStart=%d) AND (VerseEnd=%d))',[bk, ch,vs,ve]);
cdVerses.Open();
if cdVerses.Eof then begin
  InternalAddVerse(bk, ch,vs,ve,dbVerseId);
end
else dbVerseId:=cdVersesID.Value;

if dbVerseId<0 then raise Exception.CreateFmt('Cannot add this passage (%d,%d,%d,%d)',[bk,ch,vs,ve] );

for I := 0 to c do begin
curTag:=sl[i];
if length(curTag)<2 then continue;
firstChar:=curTag[1];
relation:=RelationFromChar(firstChar);
if relation<>RELATION_NORMAL  then curTag:=Copy(curTag, 2,$FFFF);
cdTagNames.SQL.Text:='SELECT * From [TagNames] where TagName like "'+UTF8Encode(curTag)+'"';
cdTagNames.Open();
if cdTagNames.Eof then begin
  InternalAddTag(curTag,dbTagId);
end
else dbTagId:=cdTagNamesTagId.Value;
if dbTagId<0 then begin
raise Exception.CreateFmt('Cannot add tag: %s . Operation aborted',[curTag]);
end;

cdRelations.SQL.Text:=Format('SELECT * from [VTRelations] where'+
      '((TagId=%d) AND (VerseId=%d))', [dbTagId, dbVerseId] );
cdRelations.Open();
if cdRelations.Eof then begin begin
      InternalAddRelation(dbTagId,dbVerseId, relation);

     end;
end;

end;

end;

function TVerseListEngine.CreateDB(const path: WideString): integer;
begin
  DbTags.Database := Path;
  DbTags.Open();
  try
  result := DbTags.SQLite3_ExecSQL(
    'CREATE TABLE [Verses] ('#13#10 +
    '[ID] INTEGER  PRIMARY KEY ASC,'#13#10 +
    '[LoCID] INTEGER NOT NULL,'#13#10+
    '[BookIx] INTEGER NOT NULL,'#13#10 +
    '[ChapterIx] INTEGER NOT NULL,'#13#10 +
    '[VerseStart] INTEGER NOT NULL,'#13#10 +
    '[VerseEnd] INTEGER NOT NULL);'#13#10 +

    'CREATE TABLE [VLocations] ('#13#10 +
    '[LOCID] INTEGER  PRIMARY KEY ASC,'#13#10 +
    '[LocStringID] VARCHAR NOT NULL);'#13#10+

    'CREATE TABLE [TagNames] ('#13#10 +
    '[TAGID] INTEGER PRIMARY KEY ASC,'#13#10 +
    '[TagName] VARCHAR NOT NULL);'#13#10 +
    'CREATE UNIQUE INDEX [un] ON [TagNames] ([TagName] COLLATE BINARY);'#13#10 +

    'CREATE TABLE [VTRelations] ('#13#10 +
    '[TAGID] INTEGER NOT NULL,'#13#10 +
    '[VERSEID] INTEGER NOT NULL,'#13#10 +
    '[RELATIONID] INTEGER);'#13#10+
    'CREATE INDEX [VERSEIX] ON [VTRelations] ([VERSEID]);'#13#10 +
    'CREATE INDEX [TAGIX] ON [VTRelations] ([TAGID]);'+

    'CREATE TABLE [TTRelations] ('#13#10 +
    '[ORG_TAGID] INTEGER NOT NULL,'#13#10 +
    '[REL_TAGID] INTEGER NOT NULL,'#13#10 +
    '[TTRELATIONID] INTEGER);'#13#10+
    'CREATE INDEX [ORGTIX] ON [VTRelations] ([ORG_TAGID]);'#13#10 +
    'CREATE INDEX [RELTAGIX] ON [VTRelations] ([REL_TAGID]);'

    );
    except
      DeleteFileW(@(Path[1]));
      raise;
    end;
end;

function TVerseListEngine.DeleteTag(const tn: WideString;dbTagid:int64; uiRelaxed:boolean=false): integer;
begin
  result := InternalDeleteTag(tn,dbTagid, uiRelaxed);
end;

procedure TVerseListEngine.dsRelsDataChange(Sender: TObject; Field: TField);
begin
//
end;

procedure TVerseListEngine.dsTagsDataChange(Sender: TObject; Field: TField);
begin
//
end;

procedure TVerseListEngine.dsTagsUpdateData(Sender: TObject);
begin
//
end;


procedure TVerseListEngine.InitVerseListEngine(const fromPath: WideString;tagAdded, tagDeleted: TTagOperation;verseAdded, verseDeleted:TVerseOperation);
var re: integer;
begin
  try
    mInitialized := true;
    mTagAdded:=tagAdded;
    mTagDeleted:=tagDeleted;
    mVerseAdded:=verseAdded;
    mVerseDelled:=verseDeleted;

    if not FileExists(fromPath) then re := CreateDB(fromPath)
    else begin
      DbTags.Database := fromPath; DbTags.Open;
    end;

    cdTagNames.Open();
    cdTagNames.First();
    cdVerses.Open();

    cdRelations.Open();
//re:=DbTags.SQLite3_ExecSQL('insert into [TagNames] (TagName) values ("tsst")');
//re:=DbTags.SQLite3_ExecSQL('insert into [TagNames] (TagName) values ("tddst")');

//cdTagNames.SQL.Text:='insert into TagNames(TagName) values ("'
//      +Utf8Encode('Тест')+'")';

///cdTagNames.ExecSQL;

  except on e: Exception do begin BqShowException(e) end end;
end;

function TVerseListEngine.InternalAddRelation(dbTagId,
  dbVerseId,relationId: int64): HRESULT;
begin
result := DbTags.SQLite3_ExecSQL(Format('insert into [VTRelations] (TAGID, VERSEID, RELATIONID)'
 + 'values (%d,%d,%d)',[dbTagId,dbVerseId, relationId]) );
 if result=0 then begin
  mVerseAdded(dbVerseId,dbTagId,'');
 end;
end;

function TVerseListEngine.InternalAddTag(const ws: WideString; out dbTagid:int64): integer;
var tag:UTF8String;
begin
  try
dbTagId:=-1;
cdTagNames.Connection:=DbTags;
tag:=UTF8Encode(ws);
result := DbTags.SQLite3_ExecSQL('insert into [TagNames] (TagName) values ("' +
       tag + '")');
cdTagNames.SQL.Text:='Select * from [TagNames] where tagName="'+ tag+'"';
cdTagNames.Open;
if not cdTagNames.Eof then begin
  dbTagId:= cdTagNamesTagId.Value;
  mTagAdded(dbTagId, ws);
end;
  except on e: Exception do BqShowException(e) end;
end;

function TVerseListEngine.InternalAddVerse(bk, ch, vs, ve: integer;
  out dbVerseId: int64): HRESULT;
begin
 dbVerseId:=-1;
 result := DbTags.SQLite3_ExecSQL(Format('insert into [Verses] (BookIx,ChapterIx,VerseStart,VerseEnd)'
 + 'values (%d,%d,%d,%d)',[bk,ch,vs,ve]));
 if result<>0 then exit;
 
cdVerses.SQL.Text:=WideFormat('Select * from [Verses] where ((BookIx=%d) AND  '+
'(ChapterIx=%d) AND (VerseStart=%d) AND (VerseEnd=%d))',[bk, ch,vs,ve]);
cdVerses.Open();
if not cdVerses.Eof then dbVerseId:=cdVersesID.Value;


end;

function TVerseListEngine.InternalCheckVerseLive(verseId: int64): boolean;
begin
cdRelations.SQL.Text:=''
end;

function TVerseListEngine.InternalDeleteTag(const tn: WideString;dbTagid:int64; uiRelaxed:boolean): integer;
var utf8tn:UTF8String;
begin
  utf8tn:=UTF8Encode(tn);
  if dbTagid<0 then begin
    cdTagNames.SQL.Text:=Format('SELECT * OF [TAGNAMES] where tagName like "%s"',[utf8tn]);
    cdTagNames.Open();
    if cdTagNames.Eof then begin
    exit;
    end;
    dbTagid:=cdTagNamesTagId.Value;
  end;
  cdRelations.SQL.Text:=Format('SELECT * from [VTRelations] where (TAGID=%d)',[dbTagid]);
  cdRelations.Open();
  DbTags.SQLite3_ExecSQL(Format('DELETE from [VTRelations] where (TAGID=%d)', [dbTagid]) );

  result := DbTags.SQLite3_ExecSQL('Delete from TagNames where TagName like"' + utf8tn + '"');
  if not uiRelaxed then   mTagDeleted(-1, tn);

end;

function TVerseListEngine.RelationFromChar(ch: WideChar): integer;
begin
case ch of
'-': result:=-100;
'~':result:=0;
'!':result:=100;
else
result:=RELATION_NORMAL;
end;
end;

function TVerseListEngine.SeedNodes(NodeLst: TObjectList): integer;
var cVid, cTid: integer;
  ni, nt: TVersesNodeData;
begin
  NodeLst.Clear();
  cdTagNames.First;
  TVersesNodeData.cdTags:=cdTagNames;
  TVersesNodeData.cdVerses:=cdVerses;
  if cdTagNames.Eof then exit;
  repeat
    cTid := cdTagNamesTagId.AsInteger;
    ni := TVersesNodeData.Create(cTid, ''{cdTagNamesTagName.AsString}, bqvntTag);
    ni.Parents := nil;
    NodeLst.Add(ni);
    cdTagNames.Next;
  until cdTagNames.Eof;
  cdRelations.First;
  if cdRelations.Eof then exit;
  repeat
    cVid := cdRelationsVERSEID.AsInteger;
    ni := TVersesNodeData.Create(cVid, '', bqvntVerse);
    ni.Parents := TObjectList.Create(false);
    repeat
      TVersesNodeData.FindNodeById(NodeLst, cdRelationsTAGID.AsInteger, bqvntTag, nt);
      ni.Parents.Add(nt);
      cdRelations.Next;
    until cdRelations.Eof or (cdRelationsVERSEID.AsInteger <> cVid);
    NodeLst.Add(ni);
  until cdRelations.Eof;

end;

{ TVersesNodeData }

constructor TVersesNodeData.Create(const aSelfId: int64; const name: UTF8String; vt: TVersesNodeType);
begin
  SelfId := aSelfId;
  cachedTxt := UTF8Decode(name); nodeType := vt;
  if nodeType=bqvntVerse then begin
  Parents:=TbqVerseTagsList.Create();
  end;
end;

destructor TVersesNodeData.Destroy;
begin
  try
    if (nodeType=bqvntVerse) and assigned(Parents) then Parents.Free;
  except on e: Exception do BqShowException(e) end;
  inherited;
end;

class function TVersesNodeData.FindNodeById(lst: TObjectList; id: int64; nodeType: TVersesNodeType;
  out node: TVersesNodeData): integer;
var i, c: integer;
begin
  result := -1;
  node := nil;
  c := lst.Count - 1;

  for i := 0 to c do if (TVersesNodeData(lst[i]).SelfId = Id) and
    (TVersesNodeData(lst[i]).nodeType = nodeType) then begin result := i; break; end;
  if result >= 0 then node := TVersesNodeData(lst[result]);
end;

function TVersesNodeData.getBibleLinkEx(): TBibleLinkEx;
begin
  if nodeType<>bqvntVerse then  raise Exception.Create('Incorrect usage of TVersesNodeData.getBibleLinkEx');
  cdVerses.SQL.Text:=Format('SELECT * FROM (Verses) where ID=%d',[SelfId]);
  cdVerses.Open();
  if cdVerses.Eof then raise Exception.Create('VereseNodeData structured corrutpted');

  result.modName:= C__bqAutoBible;
  result.book:=VerseListEngine.cdVersesBookIx.Value;
  result.chapter:=VerseListEngine.cdVersesChapterIx.Value;
  result.vstart:=VerseListEngine.cdVersesVerseStart.Value;
  Result.vend:=VerseListEngine.cdVersesVerseEnd.Value;
end;

function TVersesNodeData.getText: WideString;
var
    IdFieldName, tableName, TextFieldName:widestring;
    bl:TBibleLinkEx;
begin
  if Length(cachedTxt)>0 then begin
     result:=cachedTxt; exit;
  end;

  if nodeType=bqvntTag then begin
   cdTags.SQL.Text:=WideFormat('Select * from [TagNames] where TagId=%d',[SelfId]);
   cdTags.Open();
   if cdTags.Eof then begin result:='!TAGS Database or Logic Error!'; exit; end;
   cachedTxt:=Utf8Decode(VerseListEngine.cdTagnamesTagname.value);
   result := cachedTxt;
  end
  else if nodeType=bqvntVerse then begin
  bl:=getBibleLinkEx();
  result:=bl.ToCommand();
  end;
  end;




procedure TVersesNodeData.packCached(const sig, txt, font: WideString);
begin
cachedTxt:=WideFormat('bqvndPacked|%s|%s|%s', [sig,  font,txt] );
end;

function TVersesNodeData.unpackCached(const ws: WideString; out sig,
  font: WideString; out txt:WideString): HRESULT;
  var i,startIx:integer;
  label fail;
begin
if  (ws='') or (Copy(ws,1, 12)<>'bqvndPacked|') then goto fail;

i:=12;
startIx:=13;
repeat inc(i)until (ws[i]='|') or (ws[i]=#0);
if ws[i]=#0 then goto fail;
sig:=Copy(ws, startIx, i-startIx);
startIx:=i+1;

repeat inc(i)until (ws[i]='|') or (ws[i]=#0);
if ws[i]=#0 then goto fail;
font:=Copy(ws, startIx, i-startIx);

txt:=Copy(ws, i+1, $FFF);
result:=0;
exit;
fail:
result:=1;
end;

{ TbqVerseTagsList }

function TbqVerseTagsList.FindItemIxById(id: int64; startIx: integer): integer;
var i,c:integer;
begin
 c:=Count-1;
 for i := startIx to c do begin
 if TVersesNodeData(Items[i]).SelfId=id then begin result:=i; exit; end;
  end;
 result:=-1;
   
end;

function TbqVerseTagsList.FindTagItem(const txt: WideString): TVersesNodeData;
var i,c:integer;
    vnd:TVersesNodeData;
begin
c:=Count-1;
result:=nil;
for I := 0 to c do begin
  vnd:=TVersesNodeData( Items[i]);
  if vnd.nodeType<>bqvntTag then continue;
  if vnd.getText()<>txt then continue;
  result:=vnd; break;
end;
end;

end.

