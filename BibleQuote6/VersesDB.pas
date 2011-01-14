unit VersesDB;

interface

uses
  SysUtils, Classes, DB, DBClient, BibleQuoteUtils, pcre, ASGSQLite3,contnrs ;

type
  TVersesNodeType=(bqvntTag, bqvntVerse);

  TVersesNodeData=class
  nodeType:TVersesNodeType;
  SelfId:int64;
  cachedTxt:WideString;
  Parents:TObjectList;
  constructor Create(aSelfId:integer;const name:AnsiString; vt:TVersesNodeType);
  destructor Destroy();override;
  function getText():WideString;
  class function FindNodeById(lst:TObjectList; id:integer;nodeType:TVersesNodeType; out node:TVersesNodeData):integer;static;
  end;




  TVerseListEngine = class(TDataModule)
    cdTagNames: TASQLite3Query;
    cdVerses: TASQLite3Query;
    cdRelations: TASQLite3Query;     
    DbTags: TASQLite3DB;
    cdTagNamesTagId: TIntegerField;
    cdTagNamesTagName: TMemoField;
    cdRelationsTAGID: TIntegerField;
    cdRelationsVERSEID: TIntegerField;
    cdVersesID: TIntegerField;
    cdVersesBookIx: TStringField;
    cdVersesChapterIx: TStringField;
    cdVersesVerseStart: TStringField;
    cdVersesVerseEnd: TStringField;
    dsRels: TDataSource;
    dsTags: TDataSource;
    cdRelationsVersBookIx: TIntegerField;
    cdRelationsVerseChapter: TIntegerField;
    cdRelationsVerseStart: TIntegerField;
    cdRelationsVerseEnd: TIntegerField;
    procedure dsRelsDataChange(Sender: TObject; Field: TField);
    procedure dsTagsDataChange(Sender: TObject; Field: TField);
    procedure dsTagsUpdateData(Sender: TObject);
  private
    { Private declarations }
  mInitialized:boolean;
  function CreateDB(const path:WideString):integer;

  function InternalAddTag(const ws:WideString):integer;
  public
  procedure InitVerseListEngine(const fromPath:WideString);
  function SeedNodes(NodeLst:TObjectList):integer;
  function AddTagged(tgid:integer; bk, ch, vs, ve:integer):HRESULT;
  function AddTag(const tn:Widestring):integer;
    { Public declarations }
  end;

var
  VerseListEngine: TVerseListEngine;

implementation
uses BQExceptionTracker;
{$R *.dfm}

{ TVerseListEngine }

function TVerseListEngine.AddTag(const tn: Widestring): integer;
begin
result:=InternalAddTag(tn);
end;

function TVerseListEngine.AddTagged(tgid:integer; bk, ch, vs,
  ve: integer): HRESULT;
  var
      matchCount,i:integer;
      w:UTF8String;
begin
try
//cdTagNames.Connection:=DbTags;
//cdTagNames.Open;
cdVerses.Last();
result:=DbTags.SQLite3_ExecSQL(Format(
'insert into [Verses] (BookIx,ChapterIx,VerseStart,VerseEnd) values (%d,%d,%d,%d)',
[bk,ch,vs,ve]));
cdVerses.Last();

result:=DbTags.SQLite3_ExecSQL(Format(
 'insert into [VTRelations] (TAGID, VERSEID) values (%d,%d)',
 [tgid,cdVersesID.AsInteger]));
except on e:Exception do BqShowException (e) end;
end;


function TVerseListEngine.CreateDB(const path: WideString): integer;
begin
DbTags.Database:=Path;
DbTags.Open();
result:=DbTags.SQLite3_ExecSQL('CREATE TABLE [Verses] ('#13#10+
  '[ID] INTEGER  PRIMARY KEY ASC,'#13#10+
  '[BookIx] SMALLINT NOT NULL,'#13#10+
  '[ChapterIx] SMALLINT NOT NULL,'#13#10+
  '[VerseStart] SMALLINT NOT NULL,'#13#10+
  '[VerseEnd] SMALLINT NOT NULL);'#13#10+

  'CREATE TABLE [TagNames] ('#13#10+
  '[TagId] INTEGER PRIMARY KEY ASC,'#13#10+
  '[TagName] TEXT NOT NULL);'#13#10+
  'CREATE UNIQUE INDEX [un] ON [TagNames] ([TagName] COLLATE BINARY);'#13#10+

  'CREATE TABLE [VTRelations] ('#13#10+
  '[TAGID] INT,'#13#10+
  '[VERSEID] INT);'#13#10+
  'CREATE INDEX [vid] ON [VTRelations] ([VERSEID]);'#13#10+
  'CREATE INDEX [tid] ON [VTRelations] ([TAGID]);'
  );
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

procedure TVerseListEngine.InitVerseListEngine(const fromPath:WideString);
var re:integer;
begin
try
mInitialized:=true;
If not FileExists(fromPath) then re:=CreateDB(fromPath)
else begin
 DbTags.Database:=fromPath;  DbTags.Open;
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

except on e:Exception do  begin BqShowException(e)end end;
end;

function TVerseListEngine.InternalAddTag(const ws: WideString): integer;
begin
try
//cdTagNames.Connection:=DbTags;
//cdTagNames.Open;

result:=DbTags.SQLite3_ExecSQL('insert into [TagNames] (TagName) values ("'+
UTF8Encode(ws)+ '")');
except on e:Exception do BqShowException (e) end;
end;

function TVerseListEngine.SeedNodes(NodeLst: TObjectList): integer;
var cVid,cTid:integer;
    ni,nt:TVersesNodeData;
begin
NodeLst.Clear();
cdTagNames.First;
if cdTagNames.Eof then exit;
repeat
cTid:=cdTagNamesTagId.AsInteger;
ni:=TVersesNodeData.Create(cTid,  cdTagNamesTagName.AsString,bqvntTag);
ni.Parents:=nil;
NodeLst.Add(ni);
cdTagNames.Next;
until cdTagNames.Eof;
cdRelations.First;
if cdRelations.Eof then exit;
repeat
cVid:=cdRelationsVERSEID.AsInteger;
ni:=TVersesNodeData.Create(cVid, '',bqvntVerse);
ni.Parents:=TObjectList.Create(false);
repeat
TVersesNodeData.FindNodeById(NodeLst, cdRelationsTAGID.AsInteger, bqvntTag, nt);
ni.Parents.Add(nt);
cdRelations.Next;
until cdRelations.Eof or (cdRelationsVERSEID.AsInteger <>cVid);
NodeLst.Add(ni);
until cdRelations.Eof ;
end;

{ TVersesNodeData }

constructor TVersesNodeData.Create(aSelfId:integer;const name: AnsiString; vt: TVersesNodeType);
begin
SelfId:=aSelfId;
cachedTxt:=UTF8Decode(name);nodeType:=vt;
end;

destructor TVersesNodeData.Destroy;
begin
try
  if assigned(Parents) then Parents.Free;
except on e:Exception do BqShowException(e) end;
  inherited;
end;

class function TVersesNodeData.FindNodeById(lst:TObjectList; id: integer;nodeType:TVersesNodeType;
  out node: TVersesNodeData): integer;
  var i,c:integer;
begin
result:=-1;
node:=nil;
c:=lst.Count-1;

for i:=0 to c do if (TVersesNodeData(lst[i]).SelfId=Id) and
(TVersesNodeData(lst[i]).nodeType=nodeType) then begin result:=i; break; end;
if result>0 then node:=TVersesNodeData( lst[result]);
end;

function TVersesNodeData.getText: WideString;
begin
result:=cachedTxt;
end;

end.
