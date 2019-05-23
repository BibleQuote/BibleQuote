unit ScanModules;

interface

uses
  Classes, SyncObjs, System.Types, System.SysUtils, IOUtils, Contnrs,
  bible, BibleQuoteUtils, BibleQuoteConfig, Engine, EngineInterfaces,
  AppPaths, AppIni;

type
  TScanCompleteEvent = procedure(CachedModules: TCachedModules) of object;

type
  TModulesScanner = class
  private
    FSecondDirectory: String;
    FTempBook: TBible;
    FLimit: Integer;

    procedure ScanArchives(Modules: TCachedModules; Directory: string; AsCommentaries: Boolean = False);
    procedure ScanDirectory(Modules: TCachedModules; Directory: string; ModType: TModuleType);
    function IsLimit(Modules: TCachedModules): Boolean;
  public
    constructor Create(TempBook: TBible; Limit: Integer = -1);

    property SecondDirectory: String read FSecondDirectory write FSecondDirectory;
    property Limit: Integer read FLimit;

    function TryLoadCachedModules(var Modules: TCachedModules): Boolean;

    function Scan(): TCachedModules;
  end;

type
  TScanThread = class(TThread)
  private
    FSection: TCriticalSection;
    FBusy: Boolean;
    FModules: TCachedModules;
    FScanner: TModulesScanner;
    FOnScanDone: TScanCompleteEvent;
  protected
    procedure Execute; override;

    function GetBusy(): Boolean;
    procedure SetBusy(aVal: Boolean);
    property Busy: Boolean read GetBusy write SetBusy;
  public
    constructor Create(Scanner: TModulesScanner);
    destructor Destroy; override;

    property OnScanDone: TScanCompleteEvent read FOnScanDone write FOnScanDone;
    property Modules: TCachedModules read FModules;
  end;

implementation

constructor TModulesScanner.Create(TempBook: TBible; Limit: Integer = -1);
begin
  FTempBook := TempBook;
  FLimit := Limit;
end;

function TModulesScanner.Scan(): TCachedModules;
var
  Modules: TCachedModules;
begin
  Modules := TCachedModules.Create();

  ScanDirectory(Modules, TLibraryDirectories.Bibles, modtypeBible);
  ScanDirectory(Modules, TLibraryDirectories.Books, modtypeBook);

  ScanArchives(Modules, TLibraryDirectories.CompressedModules);

  if (SecondDirectory <> '') and (ExtractFilePath(SecondDirectory) <> ExtractFilePath(TLibraryDirectories.Root))
  then
  begin
    ScanDirectory(Modules, TPath.Combine(SecondDirectory, C_BiblesSubDirectory), modtypeBible);
    ScanDirectory(Modules, TPath.Combine(SecondDirectory, C_BooksSubDirectory), modtypeBook);
  end;

  ScanDirectory(Modules, TLibraryDirectories.Commentaries, modtypeComment);
  ScanArchives(Modules, TPath.Combine(TLibraryDirectories.CompressedModules, C_CommentariesSubDirectory), True);

  ScanDirectory(Modules, TLibraryDirectories.Dictionaries, modtypeDictionary);
  ScanArchives(Modules, TPath.Combine(TLibraryDirectories.CompressedModules, C_DictionariesSubDirectory), True);

  Modules._Sort;
  Result := Modules;
end;

procedure TModulesScanner.ScanArchives(Modules: TCachedModules; Directory: string; AsCommentaries: Boolean = False);
var
  ModType: TModuleType;
  ModEntry: TModuleEntry;
  SearchRec: TSearchRec;
  SearchResult: Integer;
begin
  if (IsLimit(Modules)) then
    Exit;

  if not DirectoryExists(Directory) then
    Exit;

  SearchResult := FindFirst(TPath.Combine(Directory, '*.bqb'), faAnyFile, SearchRec);

  if SearchResult = 0 then
    repeat
      try
        FTempBook.SetInfoSource('?' + Directory + '\' + SearchRec.Name + '??' + C_ModuleIniName);
        if (AsCommentaries) then
          ModType := modtypeComment
        else
        begin
          if FTempBook.isBible then
            ModType := modtypeBible
          else
            ModType := modtypeBook;
        end;

        ModEntry := TModuleEntry.Create(
          ModType,
          FTempBook.Name,
          FTempBook.ShortName,
          FTempBook.ShortPath,
          Directory + '\' + SearchRec.Name,
          FTempBook.GetStucture(),
          FTempBook.Categories,
          FTempBook.Author,
          FTempBook.ModuleVersion,
          FTempBook.ModuleImage,
          FTempBook.trait[bqmtStrongs]);

        Modules.Add(ModEntry);
        if (IsLimit(Modules)) then
          Exit;
      except
        on E: TBQException do
          // failed to load module, skip it
      end;
      SearchResult := FindNext(SearchRec);
    until (SearchResult <> 0);

  if SearchResult <> 0 then
    FindClose(SearchRec);
end;

procedure TModulesScanner.ScanDirectory(Modules: TCachedModules; Directory: string; ModType: TModuleType);
var
  ModEntry: TModuleEntry;
  ModulePath: string;
  SearchRec: TSearchRec;
  SearchResult: Integer;
  IsDirectory: Boolean;
begin
  if (IsLimit(Modules)) then
    Exit;

  SearchResult := FindFirst(TPath.Combine(Directory, '*.*'), faAnyFile, SearchRec);

  if (SearchResult = 0) then // search results are not empty
    repeat
      if (SearchRec.Name = '.') or (SearchRec.Name = '..') then
      begin
        SearchResult := FindNext(SearchRec);

        Continue;
      end;


      try
        ModulePath := TPath.Combine(Directory, SearchRec.Name);

        if FTempBook.SetInfoSource(ModulePath) then
        begin

          ModEntry := TModuleEntry.Create(
            ModType,
            FTempBook.Name,
            FTempBook.ShortName,
            FTempBook.ShortPath,
            EmptyWideStr,
            FTempBook.GetStucture(),
            FTempBook.Categories,
            FTempBook.Author,
            FTempBook.ModuleVersion,
            FTempBook.ModuleImage,
            FTempBook.trait[bqmtStrongs]);

          Modules.Add(ModEntry);
          if (IsLimit(Modules)) then
            Exit;
        end
        else
        begin
          // failed to identify the module from the search record

          // scan subdirectory
          IsDirectory := (SearchRec.Attr and faDirectory) = faDirectory;
          if (IsDirectory) then
            ScanDirectory(Modules, ModulePath, ModType);
        end;
      except
        on E: TBQException do
          // failed to load module, skip it
      end;

      SearchResult := FindNext(SearchRec);

    until (SearchResult <> 0);

  if (SearchResult <> 0) then
    FindClose(SearchRec);
end;

function TModulesScanner.IsLimit(Modules: TCachedModules): Boolean;
begin
  Result := (FLimit > 0) and (FLimit < Modules.Count);
end;

function TModulesScanner.TryLoadCachedModules(var Modules: TCachedModules): Boolean;
var
  ModulesList: TStringList;
  I, LineCount, ModIx: Integer;
  ModEntry: TModuleEntry;
  ModType: TModuleType;
  Cats: string;
  BookNames: string;
  HasStrong: Boolean;
  CachedModsFilePath: string;
begin
  try
    ModulesList := TStringList.Create();
    try
      CachedModsFilePath := TPath.Combine(TAppDirectories.UserSettings, C_CachedModsFileName);

      if not FileExists(CachedModsFilePath) then
      begin
        Result := False;
        Exit;
      end;

      ModulesList.LoadFromFile(CachedModsFilePath);
      I := 1;

      if ModulesList[0] <> 'v5' then
      begin
        Result := False;
        Exit;
      end;

      LineCount := ModulesList.Count - 1;
      if LineCount < 10 then
        abort;
      repeat
        ModIx := Modules.IndexOf(ModulesList[I + 1]);
        if ModIx < 0 then
        begin
{$R+}
          ModType := TModuleType(StrToInt(ModulesList[I]));
          Cats := ModulesList[I + 6];
          HasStrong := StrToBool(ModulesList[I + 9]);

          if Cats = '***' then
            Cats := '';
          BookNames := ModulesList[I + 5];

          ModEntry := TModuleEntry.Create(ModType, ModulesList[I + 1],
            ModulesList[I + 2], ModulesList[I + 3],
            ModulesList[I + 4], BookNames, Cats, ModulesList[I + 7],
            // todo: figure out ModuleVersion
            'ModuleVersion', ModulesList[I + 8], HasStrong);
{$R-}
          Modules.Add(ModEntry);
        end;
        inc(I, 9);
        while (I <= LineCount) and (ModulesList[I] <> '***') do
          inc(I);
        inc(I);

      until (I + 10) > LineCount;
      Modules._Sort();
      Result := True;
    finally
      ModulesList.Free();
    end;

  except
    Modules.Clear();
    Result := False;
  end;

end;

constructor TScanThread.Create(Scanner: TModulesScanner);
begin
  FScanner := Scanner;
  FSection := TCriticalSection.Create;
  FModules := TCachedModules.Create(True);

  inherited Create(True);
end;

destructor TScanThread.Destroy;
begin
  FreeAndNil(FSection);
  FreeAndNil(FModules);

  inherited;
end;

procedure TScanThread.Execute;
var
  FoundModules: TCachedModules;
begin
  Busy := True;
  try
    FModules.Clear;

    FoundModules := FScanner.Scan();
    FModules.Assign(FoundModules);
  finally
    Busy := False;

    if Assigned(FOnScanDone) then
      FOnScanDone(FModules);
  end;
end;

function TScanThread.GetBusy: Boolean;
begin
  try
    FSection.Acquire();
    Result := FBusy;
  finally
    FSection.Release()
  end;
end;

procedure TScanThread.SetBusy(aVal: Boolean);
begin
  try
    FSection.Acquire();
    FBusy := aVal;
  finally
    FSection.Release()
  end;
end;

end.
