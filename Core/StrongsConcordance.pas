unit StrongsConcordance;

interface

uses Windows, Classes, SysUtils, IOUtils, IOProcs, MyBibleDict, AppPaths, StrUtils,
     SyncObjs, StringProcs, MyBibleDictLoader, Math;

type
  TStrongWordList = class(TStringList)
   function CompareStrings(const S1, S2: string): Integer; override;
  end;

  TStrongsConcordance = class
  private
    FStrongDict: TMyBibleDict;
    FLock: TCriticalSection;
    FPath: String;
    FStrongLoaded: boolean;
    function InitializeDictionary(Dictionary: TMyBibleDict): boolean;
  public
    constructor Create(Path: String);
    destructor Destroy(); override;

    function EnsureStrongLoaded(): boolean;
    function GetTotalWords(): integer;
    function Lookup(number: string): string; overload;
    function Lookup(number: string; var value: string): boolean; overload;

    property StrongDict: TMyBibleDict read FStrongDict;
    property TotalWords: integer read GetTotalWords;

    function IsAvailable(): Boolean;
    class function CreateDefault(): TStrongsConcordance;
  end;

implementation

uses MyBibleInfoSourceLoader, InfoSource;

function TStrongWordList.CompareStrings(const S1, S2: string): Integer;
var
  H1, H2: Boolean;
  Num1, Num2: Integer;
begin
  if (StrongVal(S1, Num1, H1) and StrongVal(S2, Num2, H2)) then
  begin
    if (H1 xor H2) then
      Result := IfThen(H1, -1, 1)
    else
      Result := Num1 - Num2;
  end
  else
    Result := inherited CompareStrings(S1, S2);
end;

class function TStrongsConcordance.CreateDefault(): TStrongsConcordance;
var
  DefaultPath: String;
begin
  DefaultPath := TPath.Combine(TLibraryDirectories.Strong, 'Лексикон.dictionary.SQLite3');
  Result := TStrongsConcordance.Create(DefaultPath);
end;

constructor TStrongsConcordance.Create(Path: String);
var
  Words: TStrongWordList;
begin
  inherited Create;

  FPath := Path;
  FLock := TCriticalSection.Create;

  Words := TStrongWordList.Create;
  Words.Sorted := True;
  FStrongDict := TMyBibleDict.Create(Words);
  FStrongLoaded := False;
end;

destructor TStrongsConcordance.Destroy;
begin
  FreeAndNil(FLock);
  FreeAndNil(FStrongDict);

  inherited;
end;

function TStrongsConcordance.IsAvailable(): Boolean;
begin
  Result := FStrongLoaded or TFile.Exists(FPath);
end;

function TStrongsConcordance.EnsureStrongLoaded(): boolean;
begin
  if not FStrongLoaded then
    FStrongLoaded := InitializeDictionary(FStrongDict);

  Result := FStrongLoaded;
end;

function TStrongsConcordance.InitializeDictionary(Dictionary: TMyBibleDict): boolean;
var
  SqlitePath: string;
  Loader: TMyBibleDictLoader;
begin
  Result := False;
  Loader := TMyBibleDictLoader.Create;

  FLock.Acquire;
  try
    try
      Result := Loader.LoadDictionary(Dictionary, FPath);
    except on E: Exception do
      Result := False;
    end;
  finally
    FLock.Release;
  end;
end;

function TStrongsConcordance.GetTotalWords(): integer;
begin
  FLock.Acquire;
  try
    Result := StrongDict.GetWordCount();
  finally
    FLock.Release;
  end;
end;

function TStrongsConcordance.Lookup(number: string): string;
begin
  EnsureStrongLoaded;
  Result := StrongDict.Lookup(number);
end;

function TStrongsConcordance.Lookup(number: string; var value: string): boolean;
begin
  Result := False;
  if (EnsureStrongLoaded) then
  begin
    value := StrongDict.Lookup(number);
    Result := True;
  end;
end;

end.

