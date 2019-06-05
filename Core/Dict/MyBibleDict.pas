unit MyBibleDict;

interface

uses Classes, BaseDict, RegularExpressions;

type
  TMyBibleDict = class(TBaseDict)
  private
    FSQLitePath: String;
  protected
    function SearchWordDescriptionInDB(aWord: String): String;
    function FixedLinks(aDescription: String): String;
    function RemoveHRefEvaluator(const Match: TMatch): String;
  public
    procedure Initialize(aName: String; aWords: TStrings; aSQLitePath: String);

    function Lookup(aWord: String): String; override;
  end;

implementation

{ TMyBibleDict }
uses FireDAC.Comp.Client, SysUtils;

function TMyBibleDict.RemoveHRefEvaluator(const Match: TMatch): String;
begin

  Result := Match.Value;

  if Match.Groups.Count < 0  then exit;

  if Match.Groups.Count >=2 then
  begin
      Result:= Match.Groups[1].Value;
  end;


end;

function TMyBibleDict.FixedLinks(aDescription: String): String;
var
  Options: TRegExOptions;
  RegEx: TRegEx;
begin
  Result := aDescription;

  Options := [roMultiLine];

  RegEx := TRegEx.Create('<a href=''.?:.*?''>(?P<word>.*?)</a>', Options);

  if RegEx.IsMatch(aDescription) then
  begin
    Result := RegEx.Replace(aDescription, RemoveHRefEvaluator);
  end;

end;

procedure TMyBibleDict.Initialize(aName: String; aWords: TStrings;
  aSQLitePath: String);
begin
  FName := aName;
  FSQLitePath := aSQLitePath;
  FWords.AddStrings(aWords);
  FDictDir := ExtractFilePath(aSQLitePath);
end;

function TMyBibleDict.Lookup(aWord: String): String;
var
  i: Integer;
  Description: String;
begin
  i := FWords.IndexOf(aWord);

  if i = -1 then
  begin
    Result := '';
  end
  else
  begin

    Description := SearchWordDescriptionInDB(aWord);

    Description := FixedLinks(Description);

    Result := Description;
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
