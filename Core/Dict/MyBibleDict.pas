unit MyBibleDict;

interface

uses DictInterface, Classes;

type
  TMyBibleDict = class(TInterfacedObject, IDict)
  private
    FWords: TStrings;
    FName: String;
    FSQLitePath: String;
  protected
    function SearchWordDescriptionInDB(aWord: String): String;

  public
    constructor Create;
    destructor Destroy(); override;
    procedure Initialize(aName: String; aWords: TStrings; aSQLitePath: String);

    function GetWordCount(): Cardinal;
    function GetWord(aIndex: Cardinal): String;
    function GetName(): String;
    function Lookup(aWord: String): String;
    function GetDictPath(): String;

  end;

implementation

{ TMyBibleDict }
uses FireDAC.Comp.Client, SysUtils;

constructor TMyBibleDict.Create;
begin
  inherited Create;

  FWords := TStringList.Create();
end;

destructor TMyBibleDict.Destroy;
begin
  FWords.Free();

  inherited;
end;

function TMyBibleDict.GetDictPath: String;
begin
  Result := 'c:\';
end;

function TMyBibleDict.GetName: String;
begin
  Result := FName;
end;

function TMyBibleDict.GetWord(aIndex: Cardinal): String;
begin
  Result := FWords[aIndex];
end;

function TMyBibleDict.GetWordCount: Cardinal;
begin
  Result := FWords.Count;
end;

procedure TMyBibleDict.Initialize(aName: String; aWords: TStrings;
  aSQLitePath: String);
begin
  FName := aName;
  FSQLitePath := aSQLitePath;
  FWords.AddStrings(aWords);
end;

function TMyBibleDict.Lookup(aWord: String): String;
var
  i: Integer;

begin
  i := FWords.IndexOf(aWord);

  if i = -1 then
  begin
    Result := '';

  end
  else
  begin

    Result := SearchWordDescriptionInDB(aWord);



  end;
end;

function TMyBibleDict.SearchWordDescriptionInDB(aWord: String): String;
var
  SQLiteConnection: TFDConnection;
  SQLiteQuery: TFDQuery;
begin
  Result := '';

  SQLiteConnection := TFDConnection.Create(nil);
  SQLiteConnection.DriverName := 'SQLite';
  SQLiteConnection.Params.Values['Database'] := FSQLitePath;
  SQLiteConnection.Open();

  SQLiteQuery := TFDQuery.Create(nil);
  SQLiteQuery.Connection := SQLiteConnection;

  try
    SQLiteQuery.SQL.Text := Format('SELECT definition FROM [dictionary] where topic = "%s"', [aWord]);
    SQLiteQuery.Open();

    if SQLiteQuery.Eof then exit;

    Result := SQLiteQuery.FieldByName('definition').AsString;

  finally
    SQLiteQuery.Close();
    SQLiteQuery.Free();
    SQLiteConnection.Close;
    SQLiteConnection.Free;
  end;
end;

end.
