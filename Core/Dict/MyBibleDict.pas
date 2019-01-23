unit MyBibleDict;

interface

uses Classes, BaseDict;

type
  TMyBibleDict = class(TBaseDict)
  private
    FSQLitePath: String;
  protected
    function SearchWordDescriptionInDB(aWord: String): String;

  public
    procedure Initialize(aName: String; aWords: TStrings; aSQLitePath: String);

    function Lookup(aWord: String): String; override;

  end;

implementation

{ TMyBibleDict }
uses FireDAC.Comp.Client, SysUtils;

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
