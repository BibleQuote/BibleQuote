unit MyBibleInfoSourceLoader;

interface

uses Classes, InfoSourceLoaderInterface, InfoSource, FireDAC.Comp.Client;

type
  TMyBibleInfoSourceLoader = class(TInterfacedObject, IInfoSourceLoader)
  protected
    procedure LoadRegularValues(aInfoSource: TInfoSource;
              aSQLiteConnection: TFDConnection);
    procedure LoadPathValues(aInfoSource: TInfoSource; aFileEntryPath: String);

  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadInfoSource(aFileEntryPath: String; aInfoSource: TInfoSource);

  end;

implementation

{ TNativeInfoSourceLoader}
uses MyBibleUtils, SysUtils, ExceptionFrm;

constructor TMyBibleInfoSourceLoader.Create;
begin
  inherited Create;
end;

destructor TMyBibleInfoSourceLoader.Destroy;
begin

  inherited;
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
begin

  SQLiteQuery := TFDQuery.Create(nil);
  SQLiteQuery.Connection := aSQLiteConnection;

  try
    try

      DictName := TMyBibleUtils.GetDictName(SQLiteQuery);

      aInfoSource.BibleName := DictName;
      aInfoSource.BibleShortName := DictName;

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
