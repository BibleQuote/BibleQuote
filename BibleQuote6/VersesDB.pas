unit VersesDB;

interface

uses
  SysUtils, Classes, DB, BibleQuoteUtils, ASGSQLite3, contnrs, bqLinksParserIntf;

type
  TVersesNodeType = (bqvntTag, bqvntVerse);
  TVersesNodeStateFlags=(bqvnsInitialized);
  TVersesNodeState=set of TVersesNodeStateFlags;
  TVersesNodeData = class
    nodeType: TVersesNodeType;
    SelfId: int64;
    cachedTxt: WideString;
    fnt: WideString;
    Parents: TObjectList;
    nodeState:TVersesNodeState;
    class var cdTags, cdVerses, cdLocations: TASQLite3Query;
    constructor Create(const aSelfId: int64; const name: UTF8String; vt: TVersesNodeType);
    destructor Destroy(); override;
    function getText(): WideString;
    function getBibleLinkEx(): TBibleLinkEx;
    procedure packCached(const sig: WideString; const txt: WideString; const font: WideString);
    function unpackCached(const ws: WideString; out sig: WideString; out font: WideString; out txt: WIdeString): HRESULT; //return text
    class function FindNodeById(lst: TObjectList; id: int64; nodeType: TVersesNodeType; out node: TVersesNodeData): integer; static;
  end;

    TTagOperation = procedure(id: int64; const txt: wideString) of object;
//    TVerseOperation = procedure(verse_id, tagId: int64; const book_cmd: WideString; show:boolean) of object;
    TbqVerseTagsList = class(TObjectList)
      function FindTagItem(const txt: WideString): TVersesNodeData;
      function FindItemIxById(id: int64; startIx: integer): integer;
      function FindItemByTagPointer(ptr: Pointer; startIx: integer): integer;
     end;

    IuiVerseOperations=interface
       ['{14ED0EC0-45FE-1FD6-F1F0-54DF5DE47A78}']
      procedure VerseAdded(verse_id, tagId: int64;const cmd: WideString; show:boolean);
      procedure VerseDeleted(verse_id, tagId: int64);
      procedure TagAdded(tagId: int64; const txt: WideString; show:boolean);
      procedure TagDeleted(tagId: int64; const txt: WideString);
      procedure TagRenamed(tagId:int64; const newTxt:WideString);
    end;

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
      cdTagNamesTagName: TStringField;
      cdVersesBookIx: TIntegerField;
      RelationsRELATIONID: TIntegerField;
      cdLocations: TASQLite3Query;
      cdLocationsLOCID: TIntegerField;
      cdLocationsLocStringID: TStringField;
      ASQLite3Query1: TASQLite3Query;
      IntegerField1: TIntegerField;
      StringField1: TStringField;
      cdTTRelations: TASQLite3Query;
      cdTTRelationsORG_TAGID: TIntegerField;
      cdTTRelationsREL_TAGID: TIntegerField;
      cdTTRelationsTTRELATIONID: TIntegerField;
      cdVersesLoCID: TIntegerField;
      ASQLite3Pragma1: TASQLite3Pragma;
    private
    { Private declarations }
      mInitialized: boolean;
//      mTagAdded, mTagDeleted: TTagOperation;
//      mVerseAdded, mVerseDelled: TVerseOperation;
      mUI:IuiVerseOperations;
      function CreateDB(const path: WideString): integer;

      function InternalAddTag(const ws: WideString; out dbTagid: int64): integer;
      function InternalAddVerse(bk, ch, vs, ve: integer; const loc: wideString; out dbVerseId: int64): HRESULT;
      function InternalAddLocation(loc: wideString; out dbLocId: int64): HRESULT;
      function InternalAddRelation(dbTagId, dbVerseId, relationId: int64; show:boolean): HRESULT;
      function RelationFromChar(ch: WideChar): integer;
      function InternalDeleteTag(const tn: UTF8String; dbTagid: int64; uiRelaxed: boolean): integer;
      function InternalDeleteVerse(const verseId: int64): HRESULT;
      function InternalCheckVerseLive(verseId: int64): boolean;
    public
      procedure InitVerseListEngine(const fromPath: WideString;ui:IuiVerseOperations);
      function SeedNodes(NodeLst: TObjectList): integer;
//      function InitNode(const vnd: TVersesNodeData; verse_tags_cache: TbqVerseTagsList; out addedCacheIx: integer): integer;
      function InitNodeChildren(const vnd: TVersesNodeData; verse_tags_cache: TbqVerseTagsList): integer;
//    function AddTagged(tgid: int64; bk, ch, vs, ve: integer): HRESULT;overload;
      function AddVerseTagged(tagsList: WideString; bk, ch, vs, ve: integer; const loc: wideString; show:boolean): HRESULT;
      function AddTag(const tn: Widestring; out dbTagId: int64): HRESULT;
      function DeleteTag(const tn: WideString; dbTagid: int64; uiRelaxed: boolean = false): integer;
      function DeleteVerseFromTag(const verseId: int64; const dbTagName: Widestring; uiRelaxed: boolean = false): HRESULT;
      function RenameTag(const TagId:int64; const newName:WideString):HRESULT;
    { Public declarations }
    end;

  var
    VerseListEngine: TVerseListEngine;
  const RELATION_NORMAL = 20;
implementation
uses BQExceptionTracker, bqPlainUtils, WideStringsMod, BibleQuoteConfig, Windows, TntSysUtils;
{$R *.dfm}

function is_not_unique_msg(const msg: string): boolean; forward;
{ TVerseListEngine }

function TVerseListEngine.AddTag(const tn: Widestring; out dbTagId: int64): HRESULT;
begin
  try
    result := InternalAddTag(tn, dbTagId); cdTagNames.Close();

  except on e: Exception do BqShowException(e); end;
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
  ve: integer; const loc: wideString; show:boolean): HRESULT;
var sl: TWideStringList;
var i, c: integer;
  dbTagId, dbVerseId: int64;
  firstChar: WideChar;
  curTag: WideString;
  relation: integer;
begin
  try
    sl := TWideStringList.Create();

    try
      StrToTokens(tagsList, '|', sl);
      c := sl.Count - 1;
      InternalAddVerse(bk, ch, vs, ve, loc, dbVerseId);

      if dbVerseId < 0 then raise Exception.CreateFmt('Cannot add this passage (%d,%d,%d,%d)', [bk, ch, vs, ve]);

      for I := 0 to c do begin
        curTag := sl[i];
        if length(curTag) < 2 then continue;
        firstChar := curTag[1];
        relation := RelationFromChar(firstChar);
        if relation <> RELATION_NORMAL then curTag := Copy(curTag, 2, $FFFF);
        InternalAddTag(curTag, dbTagId);
        if dbTagId < 0 then begin
          raise Exception.CreateFmt('Cannot add tag: %s . Operation aborted', [curTag]);
        end;
        InternalAddRelation(dbTagId, dbVerseId, relation,show);

      end;
    finally sl.Free(); end;
  except on e: Exception do BqShowException(e, 'AddVerseTagged problem'); end;
end;

function TVerseListEngine.CreateDB(const path: WideString): integer;
begin
  DbTags.Database := Path;
  DbTags.MustExist := false;
  DbTags.Open();
  try
    try
      result := DbTags.SQLite3_ExecSQL(
        'CREATE TABLE [TagNames] ('#13#10 +
        ' [TAGID] INTEGER NOT NULL PRIMARY KEY,'#13#10 +
        ' [TagName] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT);'#13#10 +
        ' CREATE UNIQUE INDEX [un] ON [TagNames] ([TagName] COLLATE BINARY);'#13#10 +

        ' CREATE TABLE [TTRelations] ('#13#10 +
        '  [ORG_TAGID] INTEGER NOT NULL CONSTRAINT [ORGTIX_FK] REFERENCES [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT,'#13#10 +
        '   [REL_TAGID] INTEGER NOT NULL CONSTRAINT [REL_TIX_FK] REFERENCES [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT,'#13#10 +
        '   [TTRELATIONID] INTEGER NOT NULL,'#13#10 +
        '   UNIQUE([ORG_TAGID], [REL_TAGID]) ON CONFLICT ABORT);'#13#10 +

        ' CREATE INDEX [ORGTIX] ON [TTRelations] ([ORG_TAGID]);'#13#10 +

        ' CREATE INDEX [RELTAGIX] ON [TTRelations] ([REL_TAGID]);'#13#10 +

        ' CREATE TABLE [Verses] ('#13#10 +
        '   [ID] INTEGER NOT NULL PRIMARY KEY,'#13#10 +
        '   [LoCID] INTEGER NOT NULL CONSTRAINT [LOCID_FK] REFERENCES [VLocations]([LOCID]) ON DELETE RESTRICT ON UPDATE RESTRICT,'#13#10 +
        '   [BookIx] INTEGER NOT NULL,'#13#10 +
        '   [ChapterIx] INTEGER NOT NULL,'#13#10 +
        '   [VerseStart] INTEGER NOT NULL,'#13#10 +
        '   [VerseEnd] INTEGER NOT NULL,'#13#10 +
        '   UNIQUE([LoCID], [BookIx], [ChapterIx], [VerseStart], [VerseEnd]) ON CONFLICT ABORT);'#13#10 +

        ' CREATE TABLE [VLocations] ('#13#10 +
        '   [LOCID] INTEGER NOT NULL PRIMARY KEY,'#13#10 +
        '   [LocStringID] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT);'#13#10 +

        ' CREATE TABLE [VTRelations] ('#13#10 +
        '   [TAGID] INTEGER NOT NULL CONSTRAINT [TagID_FK] REFERENCES [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT,'#13#10 +
        '   [VERSEID] INTEGER NOT NULL CONSTRAINT [VerseId_FK] REFERENCES [Verses]([ID]) ON DELETE RESTRICT ON UPDATE RESTRICT,'#13#10 +
        '   [RELATIONID] INTEGER,'#13#10 +
        '   UNIQUE([TAGID], [VERSEID]) ON CONFLICT ABORT);'#13#10 +

        ' CREATE INDEX [TAGIX] ON [VTRelations] ([TAGID]);'#13#10 +

        ' CREATE INDEX [VERSEIX] ON [VTRelations] ([VERSEID]);'#13#10 +

        ' CREATE TRIGGER [TTRELATIONS_CHECK_NO_CIRCULAR_REF]'#13#10 +
        ' BEFORE INSERT'#13#10 +
        ' ON [TTRelations]'#13#10 +
        ' WHEN (NEW.ORG_TAGID=NEW.REL_TAGID)'#13#10 +
        ' BEGIN'#13#10 +
        ' SELECT RAISE( ABORT,"TTRELATIONS INSERT: TTRELATION: ORG_IX must not be equal to REL_IX");'#13#10 +
        ' END;'#13#10 +

        ' CREATE TRIGGER [TTRELATIONS_CHECK_NO_CIRCULAR_REF_UPD]'#13#10 +
        ' BEFORE UPDATE'#13#10 +
        ' ON [TTRelations]'#13#10 +
        ' WHEN (New.ORG_TAGID=New.REL_TAGID)'#13#10 +
        ' BEGIN'#13#10 +
        ' Select Raise(ABORT, "TTRELATIONS UPDATE: REL_TAGID AND ORG_TAGID must not be equal");'#13#10 +
        ' END;'#13#10 +

        ' CREATE TRIGGER [TTRELATIONS_CHECK_NO_DUPS]'#13#10 +
        ' BEFORE INSERT'#13#10 +
        ' ON [TTRelations]'#13#10 +
        ' WHEN (SELECT TTRELATIONID FROM TTRELATIONS WHERE (ORG_TAGID=New.REL_TAGID) AND (REL_TAGID=New.ORG_TAGID) IS NOT NULL)'#13#10 +
        ' BEGIN'#13#10 +
        ' SELECT RAISe(ABORT,"TTRELATIONS: indirect dup detected:aborted");'#13#10 +
        ' END;'#13#10 +

        ' CREATE TRIGGER [TTRELATIONS_CHECK_NO_DUPS_UPD]'#13#10 +
        ' BEFORE UPDATE'#13#10 +
        ' ON [TTRelations]'#13#10 +
        ' WHEN (SELECT TTRELATIONID FROM TTRelations WHERE (ORG_TAGID=new.REL_TAGID) OR (REL_TAGID=new.ORG_TAGID) is NOT NULL)'#13#10 +
        ' BEGIN'#13#10 +
        ' SELECT RAISE(ABORT, "TTRELATIONS UPDATE: indirect dup detected:aborted");'#13#10 +
        ' END;'#13#10 +
        '');
    finally DbTags.MustExist := true; end;
  except
    on e: EXCEPTION do begin
      DbTags.Close();
      DeleteFileW(PWideChar(Pointer(Path)));
      BqShowException(e);
    end;
  end;
end;

function TVerseListEngine.DeleteTag(const tn: WideString; dbTagid: int64; uiRelaxed: boolean = false): integer;
var utf8tn: UTF8String;
  verseId: int64;
  i,c:Integer;
  verseIdList:TList;
begin
  utf8tn := UTF8Encode(tn);
//  if dbTagid < 0 then begin
  cdTagNames.SQL.Text := Format('SELECT * FROM [TAGNAMES] where tagName like "%s"', [utf8tn]);
  cdTagNames.Open();
  if cdTagNames.Eof then begin
    exit;
  end;
  dbTagid := cdTagNamesTagId.Value;
  verseIdList:=TList.Create();
  try
//  end;
  cdRelations.SQL.Text := Format('SELECT * from [VTRelations] where (TAGID=%d)', [dbTagid]);
  cdRelations.Open();
  while (not cdRelations.Eof) do begin
    verseId := cdRelationsVERSEID.Value;
    verseIdList.Add(Pointer(verseId));
//    result := InternalDeleteVerse(verseId);
    cdRelations.Next();
  end;                                  //while
  try
    DbTags.SQLite3_ExecSQL(Format('DELETE from [VTRelations] where (TAGID=%d)', [dbTagid]));
  except on e: Exception do bqShowException(e); end;
  c:=verseIdList.Count-1;
  for i := 0 to c do begin
    InternalDeleteVerse(Int64(verseIdList.Items[i]));
  end;
  
  finally verseIdList.Free(); end;

  result := InternalDeleteTag(utf8tn, dbTagid, uiRelaxed);
end;

function TVerseListEngine.DeleteVerseFromTag(const verseId: int64;
  const dbTagName: Widestring; uiRelaxed: boolean): HRESULT;
var utf8tn: UTF8String;
  dbTagId: int64;
begin
  utf8tn := UTF8Encode(dbTagName);
  cdTagNames.SQL.Text := Format('SELECT * FROM [TAGNAMES] where tagName like "%s"', [utf8tn]);
  cdTagNames.Open();
  if cdTagNames.Eof then begin
    exit;
  end;
  dbTagid := cdTagNamesTagId.Value;
  try
    result := DbTags.SQLite3_ExecSQL(Format('DELETE from [VTRelations] where ((TAGID=%d) AND (VERSEID=%d))', [dbTagid, verseId]));
  except on e: Exception do bqShowException(e); end;
  result := InternalDeleteVerse(verseId);
  mUI.VerseDeleted(verseId, dbtagId);// mVerseDelled(verseId, dbTagId, '',false);
end;

//function TVerseListEngine.InitNode(const vnd: TVersesNodeData; verse_tags_cache: TbqVerseTagsList; out addedCacheIx: integer): integer;
//var cVid: int64;
//  vndChild, parentTagVnd: TVersesNodeData;
//  ix: integer;
//begin
//  result := 0;
//  if vnd.nodeType=bqvntTag then begin
//    addedCacheIx := -1;
//    cdRelations.SQL.Text := Format('SELECT * from [VTRelations] where (TAGID=%d) ORDER BY [VerseId]', [vnd.SelfId]);
//    cdRelations.Open();
//    while not cdRelations.EOF do begin
//      inc(result);                        //inc node child cound
//      cVid := cdRelationsVERSEID.AsInteger; //save verseId
//      ix:=TVersesNodeData.FindNodeById(verse_tags_cache,cVid, bqvntVerse, vndChild);
//      if ix <0 then begin
//      vndChild := TVersesNodeData.Create(cVid, '', bqvntVerse); //new cache item
//      vndChild.Parents := TObjectList.Create(false);// new parent's list
//      ix := verse_tags_cache.Add(vndChild);
//      end;
//      if vndChild.Parents.IndexOf(vnd)<0 then
//      vndChild.Parents.Add(vnd);//only one parent now
//
//      if addedCacheIx < 0 then addedCacheIx := ix;
//     cdRelations.Next();
//    end;//while
// end;
//    repeat
//      TVersesNodeData.FindNodeById(verse_tags_cache, cdRelationsTAGID.AsInteger, bqvntTag, parentTagVnd);
//      vndChild.Parents.Add(parentTagVnd);
//      cdRelations.Next;
//    until cdRelations.Eof or (cdRelationsVERSEID.AsInteger <> cVid);
//    NodeLst.Add(ni);

///end;

function TVerseListEngine.InitNodeChildren(const vnd: TVersesNodeData;
  verse_tags_cache: TbqVerseTagsList): integer;
var cVid: int64;
  vndChild, parentTagVnd: TVersesNodeData;
  ix: integer;
begin
  result := 0;

  if vnd.nodeType=bqvntTag then begin
    
    cdRelations.SQL.Text := Format('SELECT * from [VTRelations] where (TAGID=%d) ORDER BY [VerseId]', [vnd.SelfId]);
    cdRelations.Open();
    Include( vnd.nodestate,bqvnsInitialized);
    while not cdRelations.EOF do begin
      inc(result);                          //inc node child cound
      cVid := cdRelationsVERSEID.AsInteger; //save verseId
      ix:=TVersesNodeData.FindNodeById(verse_tags_cache,cVid, bqvntVerse, vndChild);
//      if ix <0 then begin
//      vndChild := TVersesNodeData.Create(cVid, '', bqvntVerse); //new cache item
//      vndChild.Parents := TObjectList.Create(false);// new parent's list
//      ix := verse_tags_cache.Add(vndChild);
//      end;
//      if vndChild.Parents.IndexOf(vnd)<0 then
//      vndChild.Parents.Add(vnd);//only one parent now
      mUI.VerseAdded(cVid, vnd.SelfId,'', false);
     cdRelations.Next();
    end;//while

 end;

end;

procedure TVerseListEngine.InitVerseListEngine(const fromPath: WideString;ui:IuiVerseOperations);
var re: integer;
begin
  try
    mInitialized := true;
//    mTagAdded := tagAdded;
//    mTagDeleted := tagDeleted;
//    mVerseAdded := verseAdded;
//    mVerseDelled := verseDeleted;
    mUI:=ui;
    if not FileExists(fromPath) then re := CreateDB(fromPath)
    else begin
      DbTags.Database := fromPath; DbTags.Open;
    end;
    if not dbtags.Connected then begin

      exit;
    end;
    re := DbTags.SQLite3_ExecSQL('PRAGMA foreign_keys = true;');

    cdTagNames.Open();
    cdTagNames.First();
//    cdVerses.Open();

//    cdRelations.Open();
//re:=DbTags.SQLite3_ExecSQL('insert into [TagNames] (TagName) values ("tsst")');
//re:=DbTags.SQLite3_ExecSQL('insert into [TagNames] (TagName) values ("tddst")');

//cdTagNames.SQL.Text:='insert into TagNames(TagName) values ("'
//      +Utf8Encode('Тест')+'")';

///cdTagNames.ExecSQL;

  except on e: Exception do begin BqShowException(e) end end;
end;

function TVerseListEngine.InternalAddLocation(loc: wideString;
  out dbLocId: int64): HRESULT;
var utf8Loc, addErrInfo: UTF8String;

begin
  utf8Loc := UTF8Encode(loc);
  try
    result := DbTags.SQLite3_ExecSQL(Format('INSERT into [VLocations] (LocStringID) values ("%s")',
      [utf8Loc]));
  except
    on e: EDatabaseError do if not is_not_unique_msg(e.message) then raise;
  end;

  cdLocations.SQl.Text := 'SELECT * FROM [VLOCATIONS] WHERE LocStringID LIKE "' + utf8Loc + '"';
  cdLocations.Open();
  if cdLocations.Eof then begin
    if result = 0 then result := -1;
    if length(addErrInfo) > 0 then
      g_ExceptionContext.Add('insert into vtlocations:' + addErrInfo);

    raise exception.Create('Cannot add location:' + loc);

  end;
  dbLocId := cdLocationsLOCID.Value;
  result := 0;
end;

function TVerseListEngine.InternalAddRelation(dbTagId,
  dbVerseId, relationId: int64; show:boolean): HRESULT;
var effectiveAdded: boolean;
begin
  result := -1;
  effectiveAdded := true;
  try
    result := DbTags.SQLite3_ExecSQL(Format('insert into [VTRelations] (TAGID, VERSEID, RELATIONID)'
      + 'values (%d,%d,%d)', [dbTagId, dbVerseId, relationId]));
  except
    on e: EDatabaseError do begin
      effectiveAdded := false;
      if not is_not_unique_msg(e.Message) then raise;
    end;
  end;
  if effectiveAdded then mUI.VerseAdded(dbVerseId, dbTagId, '', show);//  mVerseAdded(dbVerseId, dbTagId, '',show);
end;

function is_not_unique_msg(const msg: string): boolean;
begin
  result := pos(' not unique', msg) > 0;
end;

function TVerseListEngine.InternalAddTag(const ws: WideString; out dbTagid: int64): integer;
var tag: UTF8String;
  effectiveAdded: boolean;
begin
  dbTagId := -1;
  effectiveAdded := true;
  cdTagNames.Connection := DbTags;
  tag := UTF8Encode(ws);
  try
    result := DbTags.SQLite3_ExecSQL('insert into [TagNames] (TagName) values ("' +
      tag + '")');
  except
    on e: EDatabaseError do begin
      effectiveAdded := false;
      if not is_not_unique_msg(e.Message) then raise;
    end;
  end;
  cdTagNames.SQL.Text := 'Select * from [TagNames] where tagName="' + tag + '"';
  cdTagNames.Open;
  if not cdTagNames.Eof then begin
    dbTagId := cdTagNamesTagId.Value;
    if effectiveAdded then mUI.TagAdded(dbTagid,ws, true);//  mTagAdded(dbTagId, ws);
  end;

end;

function TVerseListEngine.InternalAddVerse(bk, ch, vs, ve: integer; const loc: wideString;
  out dbVerseId: int64): HRESULT;
var locID: int64;
begin
  dbVerseId := -1;
  result := InternalAddLocation(loc, locId);
  try
    result := DbTags.SQLite3_ExecSQL(Format('insert into [Verses] (LocId, BookIx,ChapterIx,VerseStart,VerseEnd)'
      + 'values (%d,%d,%d,%d,%d)', [locid, bk, ch, vs, ve]));
  except on e: EDatabaseError do if not is_not_unique_msg(e.Message) then raise;
  end;
//  if result <> 0 then exit;

  cdVerses.SQL.Text := WideFormat('Select * from [Verses] where ((BookIx=%d) AND  ' +
    '(ChapterIx=%d) AND (VerseStart=%d) AND (VerseEnd=%d) AND (LocId=%d) )', [bk, ch, vs, ve, locid]);
  cdVerses.Open();
  if not cdVerses.Eof then dbVerseId := cdVersesID.Value
  else raise exception.Create('Cannot add verse');

end;

function TVerseListEngine.InternalCheckVerseLive(verseId: int64): boolean;
begin
  cdRelations.SQL.Text := ''
end;

function TVerseListEngine.InternalDeleteTag(const tn: UTF8String; dbTagid: int64; uiRelaxed: boolean): integer;
begin
  try
    result := DbTags.SQLite3_ExecSQL(
      Format('Delete from TTRELATIONS where ((ORG_TAGID=%d) OR (REL_TAGID=%d))', [dbTagid, dbTagid]));
  except on e: Exception do BqShowException(e); end;
  try
    result := DbTags.SQLite3_ExecSQL('Delete from TagNames where TagName like"' + tn + '"');
  except on e: Exception do BqShowException(e); end;
  if (not uiRelaxed) and (result = 0) then mUI.TagDeleted(-1, tn); //mTagDeleted(-1, tn);
end;

function TVerseListEngine.InternalDeleteVerse(const verseId: int64): HRESULT;
begin
  try
    result := DbTags.SQLite3_ExecSQL('Delete from [Verses] where ID =' + IntToStr(verseId));
  except on e: EDatabaseError do if (Pos('foreign key', e.Message)<=0) then raise   end;
end;

function TVerseListEngine.RelationFromChar(ch: WideChar): integer;
begin
  case ch of
    '-': result := -100;
    '~': result := 0;
    '!': result := 100;
  else
    result := RELATION_NORMAL;
  end;
end;

function TVerseListEngine.RenameTag(const TagId: int64;
  const newName: WideString): HRESULT;
begin
try
result:=DbTags.SQLite3_ExecSQL(Utf8Encode(
WideFormat( 'UPDATE [TagNames] SET [TagName]="%s" Where TAGID=%d',[newName, tagId])));
mUI.TagRenamed(tagid, newName);
except on e:EDatabaseError do begin
    if is_not_unique_msg(e.message) then result:=-1;
end
else result:=-2;
end;
end;

function TVerseListEngine.SeedNodes(NodeLst: TObjectList): integer;
var cVid, cTid: integer;
  ni, nt: TVersesNodeData;
begin
  NodeLst.Clear();
  cdTagNames.First;
  TVersesNodeData.cdTags := cdTagNames;
  TVersesNodeData.cdVerses := cdVerses;
  TVersesNodeData.cdLocations := cdLocations;
  if cdTagNames.Eof then exit;
  repeat
    cTid := cdTagNamesTagId.AsInteger;
    ni := TVersesNodeData.Create(cTid, '' {cdTagNamesTagName.AsString}, bqvntTag);
    ni.Parents := nil;
    NodeLst.Add(ni);
    cdTagNames.Next;
  until cdTagNames.Eof;
//  cdRelations.First;
//  if cdRelations.Eof then exit;
//  repeat
//    cVid := cdRelationsVERSEID.AsInteger;
//    ni := TVersesNodeData.Create(cVid, '', bqvntVerse);
//    ni.Parents := TObjectList.Create(false);
//    repeat
//      TVersesNodeData.FindNodeById(NodeLst, cdRelationsTAGID.AsInteger, bqvntTag, nt);
//      ni.Parents.Add(nt);
//      cdRelations.Next;
//    until cdRelations.Eof or (cdRelationsVERSEID.AsInteger <> cVid);
//    NodeLst.Add(ni);
//  until cdRelations.Eof;

end;

{ TVersesNodeData }

constructor TVersesNodeData.Create(const aSelfId: int64; const name: UTF8String; vt: TVersesNodeType);
begin
  SelfId := aSelfId;
  cachedTxt := UTF8Decode(name); nodeType := vt;
  if nodeType = bqvntVerse then begin
    Parents := TbqVerseTagsList.Create(false);
  end;
end;

destructor TVersesNodeData.Destroy;
begin
  try
    if (nodeType = bqvntVerse) and assigned(Parents) then Parents.Free;
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
  if nodeType <> bqvntVerse then raise Exception.Create('Incorrect usage of TVersesNodeData.getBibleLinkEx');
  cdVerses.SQL.Text := Format('SELECT * FROM [Verses] where ID=%d', [SelfId]);
  cdVerses.Open();
  if cdVerses.Eof then raise Exception.Create('VereseNodeData structure corrutpted');

  result.book := VerseListEngine.cdVersesBookIx.Value;
  result.chapter := VerseListEngine.cdVersesChapterIx.Value;
  result.vstart := VerseListEngine.cdVersesVerseStart.Value;
  Result.vend := VerseListEngine.cdVersesVerseEnd.Value;
  cdLocations.SQL.Text := Format('SELECT * FROM [VLocations] where LocID=%d', [VerseListEngine.cdVersesLoCID.Value]);
  cdLocations.Open();
  if cdLocations.Eof then raise Exception.Create('VereseNodeData structure corrutpted');
  result.modName := UTF8Decode(cdLocations.FieldByName('LocStringID').AsString);
end;

function TVersesNodeData.getText: WideString;
var
  IdFieldName, tableName, TextFieldName: widestring;
  bl: TBibleLinkEx;
begin
  if Length(cachedTxt) > 0 then begin
    result := cachedTxt; exit;
  end;

  if nodeType = bqvntTag then begin
    cdTags.SQL.Text := WideFormat('Select * from [TagNames] where TagId=%d', [SelfId]);
    cdTags.Open();
    if cdTags.Eof then begin result := '!TAGS Database or Logic Error!'; exit; end;
    cachedTxt := Utf8Decode(VerseListEngine.cdTagnamesTagname.value);
    result := cachedTxt;
  end
  else if nodeType = bqvntVerse then begin
    bl := getBibleLinkEx();
    result := bl.ToCommand();
  end;
end;

procedure TVersesNodeData.packCached(const sig, txt, font: WideString);
begin
  cachedTxt := WideFormat('bqvndPacked|%s|%s|%s', [sig, font, txt]);
end;

function TVersesNodeData.unpackCached(const ws: WideString; out sig,
  font: WideString; out txt: WideString): HRESULT;
var i, startIx: integer;
label fail;
begin
  if (ws = '') or (Copy(ws, 1, 12) <> 'bqvndPacked|') then goto fail;

  i := 12;
  startIx := 13;
  repeat inc(i)until (ws[i] = '|') or (ws[i] = #0);
  if ws[i] = #0 then goto fail;
  sig := Copy(ws, startIx, i - startIx);
  startIx := i + 1;

  repeat inc(i)until (ws[i] = '|') or (ws[i] = #0);
  if ws[i] = #0 then goto fail;
  font := Copy(ws, startIx, i - startIx);

  txt := Copy(ws, i + 1, $FFF);
  result := 0;
  exit;
  fail:
  result := 1;
end;

{ TbqVerseTagsList }

function TbqVerseTagsList.FindItemByTagPointer(ptr: Pointer;
  startIx: integer): integer;
var i, c: integer;
vnd:TVersesNodeData;
begin
  c := Count - 1;
  for i := startIx to c do begin
    vnd:=TVersesNodeData(Items[i]);
    if (vnd.nodeType=bqvntVerse) and  (assigned(vnd.Parents))
    and (vnd.Parents.IndexOf(ptr)>=0) then begin result := i; exit; end;
  end;
  result := -1;
end;

function TbqVerseTagsList.FindItemIxById(id: int64; startIx: integer): integer;
var i, c: integer;
begin
  c := Count - 1;
  for i := startIx to c do begin
    if TVersesNodeData(Items[i]).SelfId = id then begin result := i; exit; end;
  end;
  result := -1;

end;

function TbqVerseTagsList.FindTagItem(const txt: WideString): TVersesNodeData;
var i, c: integer;
  vnd: TVersesNodeData;
begin
  c := Count - 1;
  result := nil;
  for I := 0 to c do begin
    vnd := TVersesNodeData(Items[i]);
    if vnd.nodeType <> bqvntTag then continue;
    if vnd.getText() <> txt then continue;
    result := vnd; break;
  end;
end;

end.
//CREATE TABLE [Verses] (
//[ID] INTEGER  PRIMARY KEY ASC,
//[LoCID] INTEGER NOT NULL,
//[BookIx] INTEGER NOT NULL,
//[ChapterIx] INTEGER NOT NULL,
//[VerseStart] INTEGER NOT NULL,
//[VerseEnd] INTEGER NOT NULL);
//
//CREATE TABLE [VLocations] (
//[LOCID] INTEGER  PRIMARY KEY ASC,
//[LocStringID] VARCHAR NOT NULL);
//
//CREATE TRIGGER verses_insert
//BEFORE INSERT ON Verses
//BEGIN
//SELECT CASE
//WHEN (SELECT LOCID FROM VLocations WHERE LOCID=NEW.LoCID) IS NULL
//THEN RAISE( ABORT,"Foreign Key Violation: Verses.LocId is not in VLocations!")
//END;
//END;
//
//CREATE TRIGGER verses_update
//BEFORE UPDATE of LOCID  ON Verses
//BEGIN
//SELECT CASE
//WHEN (SELECT LOCID FROM VLocations WHERE LOCID=NEW.LoCID) IS NULL
//THEN RAISE( ABORT,"Foreign Key Violation: Verses.LocId is not in VLocations!")
//END;
//END;
//
//CREATE TRIGGER vlocations_delete
//BEFORE DELETE ON [VLocations]
//BEGIN
//SELECT CASE
//WHEN (SELECT COUNT(LOCID) FROM [VLocations] WHERE LOCID=OLD.LoCID)>0
//THEN RAISE( ABORT,"Foreign Key Violation: VLocations.LocId  cannot be deleted due to references in Verses table!")
//END;
//END;
//
//CREATE TRIGGER verses_delete
//BEFORE DELETE ON [Verses]
//BEGIN
//SELECT CASE
//WHEN (SELECT COUNT(VerseId) FROM [VTRelations] WHERE VerseID=OLD.ID)>0
//THEN RAISE( ABORT,"Foreign Key Violation: Verses: tuple cannot be deleted due to references in VTRelations table!")
//END;
//END;
//
//CREATE TABLE [VTRelations] (
//  [TAGID] INTEGER NOT NULL CONSTRAINT [TagID_FK] REFERENCES [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT,
//  [VERSEID] INTEGER NOT NULL CONSTRAINT [VerseId_FK] REFERENCES [Verses]([ID]) ON DELETE RESTRICT ON UPDATE RESTRICT,
//  [RELATIONID] INTEGER);
//
//CREATE INDEX [TAGIX] ON [VTRelations] ([TAGID]);
//
//CREATE INDEX [VERSEIX] ON [VTRelations] ([VERSEID]);
//
//CREATE TRIGGER [vtrelations_insert]
//BEFORE INSERT
//ON [VTRelations]
//BEGIN
//SELECT CASE
//WHEN ((SELECT ID FROM Verses WHERE ID=NEW.VerseId) IS NULL)
// OR ((SELECT TAGID FROM TagNames WHERE TagID=NEW.TagId) IS NULL)
//THEN RAISE( ABORT,"Foreign Key Violation: VTRelations.VerseId & VTRelations.TagID must be present in Verses, and Tagnames!")
//END;
//END;
//
//CREATE TABLE [TagNames] (
//  [TAGID] AUTOINC NOT NULL,
//  [TagName] VARCHAR NOT NULL,
//  CONSTRAINT [sqlite_autoindex_TagNames_1] PRIMARY KEY ([TAGID]));
//
//CREATE UNIQUE INDEX [un] ON [TagNames] ([TagName] COLLATE BINARY);
//
//CREATE TABLE [TTRelations] (
//  [ORG_TAGID] INTEGER NOT NULL CONSTRAINT [ORGTIX_FK] REFERENCES [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT,
//  [REL_TAGID] INTEGER NOT NULL CONSTRAINT [REL_TIX_FK] REFERENCES [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT,
//  [TTRELATIONID] INTEGER NOT NULL);
//
//CREATE INDEX [ORGTIX] ON [TTRelations] ([ORG_TAGID]);
//
//CREATE INDEX [RELTAGIX] ON [TTRelations] ([REL_TAGID]);
//

