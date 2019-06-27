unit MyBibleDictLoader;

interface

uses Classes, DictLoaderInterface, IOUtils, Types, FireDAC.Comp.Client,
     MyBibleDict, MyBibleUtils, DictInterface;

type
  TMyBibleDictLoader = class(TInterfacedObject, IDictLoader)
  public
    function LoadDictionaries(aFileEntryPath: String): IDict;
    procedure LoadDictionary(Dictionary: TMyBibleDict; aDictFilePath: String);
  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm, SysUtils;


function TMyBibleDictLoader.LoadDictionaries(aFileEntryPath: String): IDict;
var
  Dictionary: TMyBibleDict;
begin
  Result := nil;
  Dictionary := TMyBibleDict.Create;
  LoadDictionary(Dictionary, aFileEntryPath);

  if Assigned(Dictionary) then
    Result := Dictionary;
end;

procedure TMyBibleDictLoader.LoadDictionary(Dictionary: TMyBibleDict; aDictFilePath: String);
var
  SQLiteQuery: TFDQuery;
  DictName, Style: String;
  Words: TStringList;
  SQLiteConnection: TFDConnection;
begin
  Words := TStringList.Create();

  SQLiteConnection := nil;
  SQLiteQuery := nil;
  try
    SQLiteConnection := TMyBibleUtils.OpenDatabase(aDictFilePath);

    SQLiteQuery := TFDQuery.Create(nil);
    SQLiteQuery.Connection := SQLiteConnection;
    try

      DictName := TMyBibleUtils.GetDictName(SQLiteQuery);
      Style := TMyBibleUtils.GetStyle(SQLiteQuery);

      TMyBibleUtils.FillWords(Words, SQLiteQuery);

      Dictionary.Initialize(DictName, Words, aDictFilePath, Style);

    except
      on e: Exception do
      begin
        BqShowException(e);
      end;
    end;

  finally
    if Assigned(SQLiteQuery) then
    begin
      SQLiteQuery.Close();
      SQLiteQuery.Free();
    end;

    if Assigned(SQLiteConnection) then
    begin
      SQLiteConnection.Close();
      SQLiteConnection.Free();
    end;

    Words.Free();
  end;

end;

end.
