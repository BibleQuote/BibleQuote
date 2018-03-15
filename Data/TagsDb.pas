unit TagsDb;

interface

uses
  System.SysUtils, System.Classes, System.Contnrs, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  BibleQuoteUtils, LinksParserIntf;

type
  TVersesNodeType = (bqvntTag, bqvntVerse);
  TVersesNodeStateFlags = (bqvnsInitialized);
  TVersesNodeState = set of TVersesNodeStateFlags;

  TVersesNodeData = class
    nodeType: TVersesNodeType;
    SelfId: int64;
    cachedTxt: string;
    fnt: string;
    Parents: TObjectList;
    nodeState: TVersesNodeState;
    class var cdTags, cdVerses, cdLocations: TFDQuery;
    constructor Create(const aSelfId: int64; const name: string;
      vt: TVersesNodeType);
    destructor Destroy(); override;
    function getText(): string;
    function getBibleLinkEx(): TBibleLinkEx;
    procedure packCached(const sig: string; const txt: string;
      const font: string);
    function unpackCached(const ws: string; out sig: string; out font: string;
      out txt: string): HRESULT;
    class function FindNodeById(lst: TObjectList; id: int64;
      nodeType: TVersesNodeType; out node: TVersesNodeData): integer; static;
  end;

  TTagOperation = procedure(id: int64; const txt: wideString) of object;

  TbqVerseTagsList = class(TObjectList)
    function FindTagItem(const txt: string): TVersesNodeData;
    function FindItemIxById(id: int64; startIx: integer): integer;
    function FindItemByTagPointer(ptr: Pointer; startIx: integer): integer;
  end;

  IuiVerseOperations = interface
    ['{14ED0EC0-45FE-1FD6-F1F0-54DF5DE47A78}']
    procedure VerseAdded(verse_id, tagId: int64; const cmd: string;
      show: boolean);
    procedure VerseDeleted(verse_id, tagId: int64);
    procedure TagAdded(tagId: int64; const txt: string; show: boolean);
    procedure TagDeleted(tagId: int64; const txt: string);
    procedure TagRenamed(tagId: int64; const newTxt: string);
  end;

  TTagsDbEngine = class(TDataModule)
    fdSQLiteDriver: TFDPhysSQLiteDriverLink;
    fdTagsConnection: TFDConnection;
    tlbVRelations: TFDQuery;
    tlbVRelationsTAGID: TIntegerField;
    tlbVRelationsVERSEID: TIntegerField;
    tlbVRelationsRELATIONID: TIntegerField;
    tlbVerses: TFDQuery;
    tlbVLocations: TFDQuery;
    tlbTRelations: TFDQuery;
    tlbTagNames: TFDQuery;
    tlbVersesID: TIntegerField;
    tlbVersesLoCID: TIntegerField;
    tlbVersesBookIx: TIntegerField;
    tlbVersesChapterIx: TIntegerField;
    tlbVersesVerseStart: TIntegerField;
    tlbVersesVerseEnd: TIntegerField;
    tlbTRelationsORG_TAGID: TIntegerField;
    tlbTRelationsREL_TAGID: TIntegerField;
    tlbTRelationsTTRELATIONID: TIntegerField;
    tlbTagNamesTAGID: TIntegerField;
    tlbTagNamesTagName: TWideStringField;
    tlbVLocationsLOCID: TIntegerField;
    tlbVLocationsLocStringID: TWideStringField;
  private
    { Private declarations }
    mInitialized: boolean;
    mUI: IuiVerseOperations;

    function CreateDB(const path: string): integer;
    function InternalAddTag(const tag: string; out dbTagid: int64): integer;
    function InternalAddVerse(bk, ch, vs, ve: integer; const loc: string;
      out dbVerseId: int64): HRESULT;
    function InternalAddLocation(loc: string; out dbLocId: int64): HRESULT;
    function InternalAddRelation(dbTagid, dbVerseId, relationId: int64;
      show: boolean): HRESULT;
    function RelationFromChar(ch: Char): integer;
    function InternalDeleteTag(const tn: string; dbTagid: int64;
      uiRelaxed: boolean): integer;
    function InternalDeleteVerse(const verseId: int64): HRESULT;
  public
    { Public declarations }

    procedure InitVerseListEngine(const fromPath: string;
      UI: IuiVerseOperations);
    function SeedNodes(NodeLst: TObjectList): integer;
    function InitNodeChildren(const vnd: TVersesNodeData;
      verse_tags_cache: TbqVerseTagsList): integer;
    procedure AddVerseTagged(tagsList: string; bk, ch, vs, ve: integer; const loc: string; show: boolean);
    function AddTag(const tn: string; out dbTagid: int64): HRESULT;
    function DeleteTag(const tn: string; dbTagid: int64;
      uiRelaxed: boolean = false): integer;
    function DeleteVerseFromTag(const verseId: int64; const dbTagName: string;
      uiRelaxed: boolean = false): HRESULT;
    function RenameTag(const tagId: int64; const newName: string): HRESULT;
  end;

var
  TagsDbEngine: TTagsDbEngine;

const
  RELATION_NORMAL = 20;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses ExceptionFrm, PlainUtils;

{$R *.dfm}
function is_not_unique_msg(const msg: string): boolean; forward;

function TTagsDbEngine.AddTag(const tn: string; out dbTagid: int64): HRESULT;
begin
  result := -1;

  try
    result := InternalAddTag(tn, dbTagid);
    tlbTagNames.Close();

  except
    on e: Exception do
      BqShowException(e);
  end;
end;

procedure TTagsDbEngine.AddVerseTagged(tagsList: string; bk, ch, vs, ve: integer;
  const loc: string; show: boolean);
var
  sl: TStringList;
var
  i, c: integer;
  dbTagid, dbVerseId: int64;
  firstChar: Char;
  curTag: string;
  relation: integer;
begin
  try
    sl := TStringList.Create();

    try
      StrToTokens(tagsList, '|', sl);
      c := sl.Count - 1;
      InternalAddVerse(bk, ch, vs, ve, loc, dbVerseId);

      if dbVerseId < 0 then
        raise Exception.CreateFmt('Cannot add this passage (%d,%d,%d,%d)',
          [bk, ch, vs, ve]);

      for i := 0 to c do
      begin
        curTag := sl[i];
        if length(curTag) < 2 then
          continue;
        firstChar := curTag[1];
        relation := RelationFromChar(firstChar);
        if relation <> RELATION_NORMAL then
          curTag := Copy(curTag, 2, $FFFF);
        InternalAddTag(curTag, dbTagid);
        if dbTagid < 0 then
        begin
          raise Exception.CreateFmt('Cannot add tag: %s . Operation aborted',
            [curTag]);
        end;
        InternalAddRelation(dbTagid, dbVerseId, relation, show);

      end;
    finally
      sl.Free();
    end;
  except
    on e: Exception do
      BqShowException(e, 'AddVerseTagged problem');
  end;
end;

function TTagsDbEngine.CreateDB(const path: string): integer;
begin
  result := -1;

  fdTagsConnection.Params.Values['Database'] := path;
  fdTagsConnection.Open();

  try
    result := fdTagsConnection.ExecSQL('CREATE TABLE [TagNames] ('#13#10 +
      ' [TAGID] INTEGER NOT NULL PRIMARY KEY,'#13#10 +
      ' [TagName] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT);'#13#10 +
      ' CREATE UNIQUE INDEX [un] ON [TagNames] ([TagName] COLLATE BINARY);'#13#10 +
      ' CREATE TABLE [TTRelations] ('#13#10 +
      '  [ORG_TAGID] INTEGER NOT NULL CONSTRAINT [ORGTIX_FK] REFERENCES [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT,'#13#10 +
      '  [REL_TAGID] INTEGER NOT NULL CONSTRAINT [REL_TIX_FK] REFERENCES [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT,'#13#10 +
      '  [TTRELATIONID] INTEGER NOT NULL,'#13#10 +
      '  UNIQUE([ORG_TAGID], [REL_TAGID]) ON CONFLICT ABORT);'#13#10 +

      ' CREATE INDEX [ORGTIX] ON [TTRelations] ([ORG_TAGID]);'#13#10 +

      ' CREATE INDEX [RELTAGIX] ON [TTRelations] ([REL_TAGID]);'#13#10 +

      ' CREATE TABLE [Verses] ('#13#10 +
      '   [ID] INTEGER NOT NULL PRIMARY KEY,'#13#10 +
      '   [LoCID] INTEGER NOT NULL CONSTRAINT [LOCID_FK] REFERENCES [VLocations]([LOCID]) ON DELETE RESTRICT ON UPDATE RESTRICT,'#13#10 +
      '   [BookIx] INTEGER NOT NULL,'#13#10 +
      '   [ChapterIx] INTEGER NOT NULL,'#13#10 +
      '   [VerseStart] INTEGER NOT NULL,'#13#10 +
      '   [VerseEnd] INTEGER NOT NULL,'#13#10 +
      '   UNIQUE([LoCID], [BookIx], [ChapterIx], [VerseStart], [VerseEnd]) ON CONFLICT ABORT);'#13#10
      +

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
      ' BEFORE INSERT'#13#10 + ' ON [TTRelations]'#13#10 +
      ' WHEN (NEW.ORG_TAGID=NEW.REL_TAGID)'#13#10 + ' BEGIN'#13#10 +
      ' SELECT RAISE( ABORT,"TTRELATIONS INSERT: TTRELATION: ORG_IX must not be equal to REL_IX");'#13#10 +
      ' END;'#13#10 +

      ' CREATE TRIGGER [TTRELATIONS_CHECK_NO_CIRCULAR_REF_UPD]'#13#10 +
      ' BEFORE UPDATE'#13#10 + ' ON [TTRelations]'#13#10 +
      ' WHEN (New.ORG_TAGID=New.REL_TAGID)'#13#10 + ' BEGIN'#13#10 +
      ' Select Raise(ABORT, "TTRELATIONS UPDATE: REL_TAGID AND ORG_TAGID must not be equal");'#13#10 +
      ' END;'#13#10 +

      ' CREATE TRIGGER [TTRELATIONS_CHECK_NO_DUPS]'#13#10 +
      ' BEFORE INSERT'#13#10 + ' ON [TTRelations]'#13#10 +
      ' WHEN (SELECT TTRELATIONID FROM TTRELATIONS WHERE (ORG_TAGID=New.REL_TAGID) AND (REL_TAGID=New.ORG_TAGID) IS NOT NULL)'#13#10 +
      ' BEGIN'#13#10 +
      ' SELECT RAISe(ABORT,"TTRELATIONS: indirect dup detected:aborted");'#13#10 +
      ' END;'#13#10 +

      ' CREATE TRIGGER [TTRELATIONS_CHECK_NO_DUPS_UPD]'#13#10 +
      ' BEFORE UPDATE'#13#10 + ' ON [TTRelations]'#13#10 +
      ' WHEN (SELECT TTRELATIONID FROM TTRelations WHERE (ORG_TAGID=new.REL_TAGID) OR (REL_TAGID=new.ORG_TAGID) is NOT NULL)'#13#10 +
      ' BEGIN'#13#10 +
      ' SELECT RAISE(ABORT, "TTRELATIONS UPDATE: indirect dup detected:aborted");'#13#10 +
      ' END;'#13#10 +
      '');
  except
    on e: Exception do
    begin
      fdTagsConnection.Close();
      DeleteFile(path);
      BqShowException(e);
    end;
  end;
end;

function TTagsDbEngine.DeleteTag(const tn: string; dbTagid: int64;
  uiRelaxed: boolean = false): integer;
var
  verseId: int64;
  i, c: integer;
  verseIdList: TList;
begin

  tlbTagNames.SQL.Text := Format('SELECT * FROM [TAGNAMES] where tagName like "%s"', [tn]);
  tlbTagNames.Open();

  if tlbTagNames.Eof then
  begin
    result := -1;
    exit;
  end;

  dbTagid := tlbTagNamesTAGID.Value;
  verseIdList := TList.Create();

  try
    tlbVRelations.SQL.Text := Format('SELECT * from [VTRelations] where (TAGID=%d)', [dbTagid]);
    tlbVRelations.Open();

    while (not tlbVRelations.Eof) do
    begin
      verseId := tlbVRelationsVERSEID.Value;
      verseIdList.Add(Pointer(verseId));
      tlbVRelations.Next();
    end;

    try
      fdTagsConnection.ExecSQL
        (Format('DELETE from [VTRelations] where (TAGID=%d)', [dbTagid]));
    except
      on e: Exception do
        BqShowException(e);
    end;

    c := verseIdList.Count - 1;

    for i := 0 to c do
    begin
      InternalDeleteVerse(int64(verseIdList.Items[i]));
    end;

  finally
    verseIdList.Free();
  end;

  result := InternalDeleteTag(tn, dbTagid, uiRelaxed);
end;

function TTagsDbEngine.DeleteVerseFromTag(const verseId: int64;
  const dbTagName: string; uiRelaxed: boolean): HRESULT;
var
  dbTagid: int64;
begin
  tlbTagNames.SQL.Text :=
    Format('SELECT * FROM [TAGNAMES] where tagName like "%s"', [dbTagName]);
  tlbTagNames.Open();
  if tlbTagNames.Eof then
  begin
    result := S_FALSE;
    exit;
  end;
  dbTagid := tlbTagNamesTAGID.Value;
  try
    fdTagsConnection.ExecSQL(Format('DELETE from [VTRelations] where ((TAGID=%d) AND (VERSEID=%d))', [dbTagid, verseId]));
  except
    on e: Exception do
      BqShowException(e);
  end;
  result := InternalDeleteVerse(verseId);
  mUI.VerseDeleted(verseId, dbTagid);
end;

function TTagsDbEngine.InitNodeChildren(const vnd: TVersesNodeData;
  verse_tags_cache: TbqVerseTagsList): integer;
var
  cVid: int64;
  vndChild: TVersesNodeData;
begin
  result := 0;

  if vnd.nodeType = bqvntTag then
  begin

    tlbVRelations.SQL.Text :=
      Format('SELECT * from [VTRelations] where (TAGID=%d) ORDER BY [VerseId]',
      [vnd.SelfId]);
    tlbVRelations.Open();
    Include(vnd.nodeState, bqvnsInitialized);
    while not tlbVRelations.Eof do
    begin
      inc(result); // inc node child cound
      cVid := tlbVRelationsVERSEID.AsInteger; // save verseId

      // check and create node if not exists
      TVersesNodeData.FindNodeById(verse_tags_cache, cVid, bqvntVerse, vndChild);

      mUI.VerseAdded(cVid, vnd.SelfId, '', false);
      tlbVRelations.Next();
    end;

  end;

end;

procedure TTagsDbEngine.InitVerseListEngine(const fromPath: string;
  UI: IuiVerseOperations);
begin
  try
    mInitialized := true;
    mUI := UI;
    if not FileExists(fromPath) then
      CreateDB(fromPath)
    else
    begin
      fdTagsConnection.Params.Values['Database'] := fromPath;
      fdTagsConnection.Open();
    end;
    if not fdTagsConnection.Connected then
    begin

      exit;
    end;
    fdTagsConnection.ExecSQL('PRAGMA foreign_keys = true;');

    tlbTagNames.Open();
    tlbTagNames.First();
  except
    on e: Exception do
    begin
      BqShowException(e)
    end
  end;
end;

function TTagsDbEngine.InternalAddLocation(loc: string;
  out dbLocId: int64): HRESULT;
begin
  fdTagsConnection.ExecSQL(Format('INSERT or ignore into [VLocations] (LocStringID) values ("%s")', [loc]));

  tlbVLocations.SQL.Text :=
    'SELECT * FROM [VLOCATIONS] WHERE LocStringID LIKE "' + loc + '"';
  tlbVLocations.Open();
  if tlbVLocations.Eof then
  begin
    raise Exception.Create('Cannot add location:' + loc);
  end;
  dbLocId := tlbVLocationsLOCID.Value;
  result := 0;
end;

function TTagsDbEngine.InternalAddRelation(dbTagid, dbVerseId,
  relationId: int64; show: boolean): HRESULT;
begin
  result := fdTagsConnection.ExecSQL
    (Format('insert or ignore into [VTRelations] (TAGID, VERSEID, RELATIONID)' +
    'values (%d,%d,%d)', [dbTagid, dbVerseId, relationId]));
  if (result > 0) then
    mUI.VerseAdded(dbVerseId, dbTagid, '', show);
  // mVerseAdded(dbVerseId, dbTagId, '',show);
end;

function is_not_unique_msg(const msg: string): boolean;
begin
  result := pos('UNIQUE constraint', msg) > 0;
end;

function TTagsDbEngine.InternalAddTag(const tag: string;
  out dbTagid: int64): integer;
var
  effectiveAdded: boolean;
  insertStatement: string;
begin
  dbTagid := -1;
  effectiveAdded := true;
  tlbTagNames.Connection := fdTagsConnection;
  insertStatement := Format('insert or ignore into [TagNames] (TagName) values ("%s")', [tag]);
  result := fdTagsConnection.ExecSQL(insertStatement);
  if (result <= 0) then
    effectiveAdded := false;
  tlbTagNames.SQL.Text := 'Select * from [TagNames] where tagName="' +
    tag + '"';
  tlbTagNames.Open;
  if not tlbTagNames.Eof then
  begin
    dbTagid := tlbTagNamesTAGID.Value;
    if effectiveAdded then
      mUI.TagAdded(dbTagid, tag, true); // mTagAdded(dbTagId, ws);
  end;

end;

function TTagsDbEngine.InternalAddVerse(bk, ch, vs, ve: integer;
  const loc: string; out dbVerseId: int64): HRESULT;
var
  locID: int64;
begin
  dbVerseId := -1;
  InternalAddLocation(loc, locID);
  result := fdTagsConnection.ExecSQL
    (Format('insert or ignore into [Verses] (LocId, BookIx,ChapterIx,VerseStart,VerseEnd)'
    + 'values (%d,%d,%d,%d,%d)', [locID, bk, ch, vs, ve]));

  tlbVerses.SQL.Text := Format('Select * from [Verses] where ((BookIx=%d) AND  '
    + '(ChapterIx=%d) AND (VerseStart=%d) AND (VerseEnd=%d) AND (LocId=%d) )',
    [bk, ch, vs, ve, locID]);
  tlbVerses.Open();
  if not tlbVerses.Eof then
    dbVerseId := tlbVersesID.Value
  else
    raise Exception.Create('Cannot add verse');

end;

function TTagsDbEngine.InternalDeleteTag(const tn: string; dbTagid: int64;
  uiRelaxed: boolean): integer;
begin
  result := -1;
  try
    result := fdTagsConnection.ExecSQL
      (Format('Delete from TTRELATIONS where ((ORG_TAGID=%d) OR (REL_TAGID=%d))',
      [dbTagid, dbTagid]));
  except
    on e: Exception do
      BqShowException(e);
  end;
  try
    result := fdTagsConnection.ExecSQL
      ('Delete from TagNames where TagName like"' + tn + '"');
  except
    on e: Exception do
      BqShowException(e);
  end;
  if (not uiRelaxed) and (result = 0) then
    mUI.TagDeleted(-1, tn); // mTagDeleted(-1, tn);
end;

function TTagsDbEngine.InternalDeleteVerse(const verseId: int64): HRESULT;
begin
  result := -1;
  try
    result := fdTagsConnection.ExecSQL('Delete from [Verses] where ID =' +
      IntToStr(verseId));
  except
    on e: EDatabaseError do
      if (pos('foreign key', e.Message) <= 0) then
        raise
  end;
end;

function TTagsDbEngine.RelationFromChar(ch: Char): integer;
begin
  case ch of
    '-':
      result := -100;
    '~':
      result := 0;
    '!':
      result := 100;
  else
    result := RELATION_NORMAL;
  end;
end;

function TTagsDbEngine.RenameTag(const tagId: int64;
  const newName: string): HRESULT;
begin
  try
    result := fdTagsConnection.ExecSQL
      (Format('UPDATE [TagNames] SET [TagName]="%s" Where TAGID=%d',
      [newName, tagId]));
    mUI.TagRenamed(tagId, newName);
  except
    on e: EDatabaseError do
    begin
      result := -2;
      if is_not_unique_msg(e.Message) then
        result := -1;
    end
    else
      result := -2;
  end;
end;

function TTagsDbEngine.SeedNodes(NodeLst: TObjectList): integer;
var
  cTid: integer;
  ni: TVersesNodeData;
begin
  NodeLst.Clear();
  result := 0;
  tlbTagNames.SQL.Text := 'Select * from  TagNames';
  tlbTagNames.Open();

  TVersesNodeData.cdTags := tlbTagNames;
  TVersesNodeData.cdVerses := tlbVerses;
  TVersesNodeData.cdLocations := tlbVLocations;
  if tlbTagNames.Eof then
    exit;
  tlbTagNames.First;
  repeat
    cTid := tlbTagNamesTAGID.AsInteger;
    ni := TVersesNodeData.Create(cTid, '', bqvntTag);
    ni.Parents := nil;
    NodeLst.Add(ni);
    tlbTagNames.Next;
  until tlbTagNames.Eof;

end;

{ TVersesNodeData }

constructor TVersesNodeData.Create(const aSelfId: int64; const name: string;
  vt: TVersesNodeType);
begin
  SelfId := aSelfId;
  cachedTxt := name;
  nodeType := vt;
  if nodeType = bqvntVerse then
  begin
    Parents := TbqVerseTagsList.Create(false);
  end;
end;

destructor TVersesNodeData.Destroy;
begin
  try
    if (nodeType = bqvntVerse) and assigned(Parents) then
      Parents.Free;
  except
    on e: Exception do
      BqShowException(e)
  end;
  inherited;
end;

class function TVersesNodeData.FindNodeById(lst: TObjectList; id: int64;
  nodeType: TVersesNodeType; out node: TVersesNodeData): integer;
var
  i, c: integer;
begin
  result := -1;
  node := nil;
  c := lst.Count - 1;

  for i := 0 to c do
    if (TVersesNodeData(lst[i]).SelfId = id) and
      (TVersesNodeData(lst[i]).nodeType = nodeType) then
    begin
      result := i;
      break;
    end;
  if result >= 0 then
    node := TVersesNodeData(lst[result]);
end;

function TVersesNodeData.getBibleLinkEx(): TBibleLinkEx;
begin
  if nodeType <> bqvntVerse then
    raise Exception.Create('Incorrect usage of TVersesNodeData.getBibleLinkEx');
  cdVerses.SQL.Text := Format('SELECT * FROM [Verses] where ID=%d', [SelfId]);
  cdVerses.Open();
  if cdVerses.Eof then
    raise Exception.Create('VereseNodeData structure corrutpted');

  result.book := TagsDbEngine.tlbVersesBookIx.Value;
  result.chapter := TagsDbEngine.tlbVersesChapterIx.Value;
  result.vstart := TagsDbEngine.tlbVersesVerseStart.Value;
  result.vend := TagsDbEngine.tlbVersesVerseEnd.Value;
  cdLocations.SQL.Text := Format('SELECT * FROM [VLocations] where LocID=%d',
    [TagsDbEngine.tlbVersesLoCID.Value]);
  cdLocations.Open();
  if cdLocations.Eof then
    raise Exception.Create('VereseNodeData structure corrutpted');
  result.modName := cdLocations.FieldByName('LocStringID').AsString;
end;

function TVersesNodeData.getText: string;
var
  bl: TBibleLinkEx;
begin
  if length(cachedTxt) > 0 then
  begin
    result := cachedTxt;
    exit;
  end;

  if nodeType = bqvntTag then
  begin
    cdTags.SQL.Text := Format('Select * from [TagNames] where TagId=%d',
      [SelfId]);
    cdTags.Open();
    if cdTags.Eof then
    begin
      result := '!TAGS Database or Logic Error!';
      exit;
    end;
    cachedTxt := TagsDbEngine.tlbTagNamesTagName.Value;

    result := cachedTxt;
  end
  else if nodeType = bqvntVerse then
  begin
    bl := getBibleLinkEx();
    result := bl.ToCommand();
  end;
end;

procedure TVersesNodeData.packCached(const sig, txt, font: string);
begin
  cachedTxt := Format('bqvndPacked|%s|%s|%s', [sig, font, txt]);
end;

function TVersesNodeData.unpackCached(const ws: string; out sig, font: string;
  out txt: string): HRESULT;
var
  i, startIx: integer;
label fail;
begin
  if (ws = '') or (Copy(ws, 1, 12) <> 'bqvndPacked|') then
    goto fail;

  i := 12;
  startIx := 13;
  repeat
    inc(i)
  until (ws[i] = '|') or (ws[i] = #0);
  if ws[i] = #0 then
    goto fail;
  sig := Copy(ws, startIx, i - startIx);
  startIx := i + 1;

  repeat
    inc(i)
  until (ws[i] = '|') or (ws[i] = #0);
  if ws[i] = #0 then
    goto fail;
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
var
  i, c: integer;
  vnd: TVersesNodeData;
begin
  c := Count - 1;
  for i := startIx to c do
  begin
    vnd := TVersesNodeData(Items[i]);
    if (vnd.nodeType = bqvntVerse) and (assigned(vnd.Parents)) and
      (vnd.Parents.IndexOf(ptr) >= 0) then
    begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;

function TbqVerseTagsList.FindItemIxById(id: int64; startIx: integer): integer;
var
  i, c: integer;
begin
  c := Count - 1;
  for i := startIx to c do
  begin
    if TVersesNodeData(Items[i]).SelfId = id then
    begin
      result := i;
      exit;
    end;
  end;
  result := -1;

end;

function TbqVerseTagsList.FindTagItem(const txt: string): TVersesNodeData;
var
  i, c: integer;
  vnd: TVersesNodeData;
begin
  c := Count - 1;
  result := nil;
  for i := 0 to c do
  begin
    vnd := TVersesNodeData(Items[i]);
    if vnd.nodeType <> bqvntTag then
      continue;
    if vnd.getText() <> txt then
      continue;
    result := vnd;
    break;
  end;
end;

end.
