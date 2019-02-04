unit MyBibleInfoSourceLoader;

interface

uses Classes, InfoSourceLoaderInterface, InfoSource, FireDAC.Comp.Client;

type
  TMyBibleInfoSourceLoader = class(TInterfacedObject, IInfoSourceLoader)
  protected
    procedure LoadRegularValues(aInfoSource: TInfoSource;
              aSQLiteConnection: TFDConnection);
    procedure LoadPathValues(aInfoSource: TInfoSource; aFileEntryPath: String);
    function ExtractLastChangedDat(aHistory: String): String;
    function ExtractDat(aRow: String): String;

  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadInfoSource(aFileEntryPath: String; aInfoSource: TInfoSource);

  end;

implementation

{ TNativeInfoSourceLoader}
uses MyBibleUtils, SysUtils, ExceptionFrm, RegularExpressions;

constructor TMyBibleInfoSourceLoader.Create;
begin
  inherited Create;
end;

destructor TMyBibleInfoSourceLoader.Destroy;
begin

  inherited;
end;

function TMyBibleInfoSourceLoader.ExtractDat(aRow: String): String;
var
  RegEx: TRegEx;
  Options: TRegExOptions;
  MatchCollection: TMatchCollection;
begin

  Result := '';

  Options := [roSingleLine, roIgnoreCase, roExplicitCapture];

  RegEx := TRegEx.Create('\((?P<lastdat>.*?)\).*', Options);

  if not RegEx.IsMatch(aRow) then exit;

  MatchCollection := RegEx.Matches(aRow);

  if MatchCollection.Count = 0 then exit;

  Result := MatchCollection[0].Groups.Item[1].Value;

end;

function TMyBibleInfoSourceLoader.ExtractLastChangedDat(
  aHistory: String): String;
var
  Histories: TStrings;
begin
  Result := '';

  Histories := TStringList.Create;
  try
    Histories.Text := aHistory;

    if Histories.Count = 0 then exit;

    Result := ExtractDat(Histories[0]);

  finally
    Histories.Free;
  end;
end;

procedure TMyBibleInfoSourceLoader.LoadInfoSource(aFileEntryPath: String;
  aInfoSource: TInfoSource);
var
  SQLiteConnection: TFDConnection;
begin

  SQLiteConnection := TFDConnection.Create(nil);
  SQLiteConnection.DriverName := 'SQLite';

  SQLiteConnection.Params.Values['Database'] := aFileEntryPath;
  SQLiteConnection.Open();

  try

    LoadRegularValues(aInfoSource, SQLiteConnection);
    LoadPathValues(aInfoSource, aFileEntryPath);

  finally
    SQLiteConnection.Close;
    SQLiteConnection.Free;
  end;

end;

procedure TMyBibleInfoSourceLoader.LoadPathValues(aInfoSource: TInfoSource;
  aFileEntryPath: String);
begin
  aInfoSource.FileName := aFileEntryPath;
  aInfoSource.IsCompressed := false;
  aInfoSource.IsCommentary := false;
end;

procedure TMyBibleInfoSourceLoader.LoadRegularValues(aInfoSource: TInfoSource;
  aSQLiteConnection: TFDConnection);
var
  SQLiteQuery: TFDQuery;
  DictName: String;
  History: String;
begin

  SQLiteQuery := TFDQuery.Create(nil);
  SQLiteQuery.Connection := aSQLiteConnection;

  try
    try

      DictName := TMyBibleUtils.GetDictName(SQLiteQuery);
      History := TMyBibleUtils.GetHistory(SQLiteQuery);

      aInfoSource.BibleName := DictName;
      aInfoSource.BibleShortName := DictName;
      aInfoSource.ModuleVersion := ExtractLastChangedDat(History);

      aInfoSource.StrongNumbers := TMyBibleUtils.GetStrong(SQLiteQuery);

    except
      on e: Exception do
      begin
        BqShowException(e);
      end;
    end;

  finally
    aSQLiteConnection.Close();
    SQLiteQuery.Close();
    SQLiteQuery.Free();
  end;

end;


end.
