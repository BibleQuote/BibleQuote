unit ModuleProcs;

interface

uses
  Classes, SysUtils, IOUtils, Contnrs, bible, BibleQuoteUtils, BibleQuoteConfig,
  Engine, EngineInterfaces;

const
  C_NumOfModulesToScan = 5;

type
  TArchiveModuleLoadFailedEvent = procedure(Sender: TObject; E: TBQException) of object;

  TModuleLoader = class
  private
    mSearchInitialized: Boolean;

    mCachedModules: TCachedModules;

    // track scanning process
    mFolderBiblesScanned: Boolean;
    mFolderBooksScanned: Boolean;
    mFolderCommentsScanned: Boolean;

    mArchivedModulesScanned: Boolean;
    mArchivedCommentsScanned: Boolean;

    mSecondFolderBiblesScanned: Boolean;
    mSecondFolderBooksScanned: Boolean;
    mSecondFolderCommentsScanned: Boolean;

    mScanDone: Boolean;

    mSearchRecord: TSearchRec;
    mSearchResult: integer;

    FOnScanDone: TNotifyEvent;
    FOnArchiveModuleLoadFailed: TArchiveModuleLoadFailedEvent;
  public
    constructor Create();
    destructor Destroy(); override;

    function LoadModules(tmpBook: TBible; background: Boolean): Boolean;
    function AddArchivedModules(path: string; tempBook: TBible; background: Boolean; addAsCommentaries: Boolean = false): Boolean;
    function AddFolderModules(path: string; tempBook: TBible; background: Boolean; modType: TModuleType): Boolean;

    function LoadCachedModules(): Boolean;
    procedure SaveCachedModules();

    function GetCachedModules: TCachedModules;
    property CachedModules: TCachedModules read GetCachedModules;

    function GetScanDone: Boolean;
    property ScanDone: Boolean read GetScanDone;

    property OnScanDone: TNotifyEvent read FOnScanDone write FOnScanDone;
    property OnArchiveModuleLoadFailed: TArchiveModuleLoadFailedEvent read FOnArchiveModuleLoadFailed write FOnArchiveModuleLoadFailed;
  end;

implementation

constructor TModuleLoader.Create();
begin
  mSearchInitialized := false;

  mFolderBiblesScanned := false;
  mFolderBooksScanned := false;
  mFolderCommentsScanned := false;

  mSecondFolderBiblesScanned := false;
  mSecondFolderBooksScanned := false;
  mSecondFolderCommentsScanned := false;

  mArchivedModulesScanned := false;
  mArchivedCommentsScanned := false;

  mScanDone := false;
  mCachedModules := TCachedModules.Create(true);
end;

destructor TModuleLoader.Destroy;
begin
  FreeAndNil(mCachedModules);
  inherited;
end;

function TModuleLoader.GetScanDone: Boolean;
begin
  Result := mScanDone;
end;

function TModuleLoader.GetCachedModules: TCachedModules;
begin
  Result := mCachedModules;
end;

function TModuleLoader.LoadModules(tmpBook: TBible; background: Boolean): Boolean;
begin
  Result := false;
  try
    if not background then
    begin
      AddFolderModules(TPath.Combine(ModulesDirectory, C_BiblesSubDirectory), tmpBook, background, modtypeBible);
      AddFolderModules(TPath.Combine(ModulesDirectory, C_BooksSubDirectory), tmpBook, background, modtypeBook);

      AddArchivedModules(CompressedModulesDirectory, tmpBook, background);

      if (G_SecondPath <> '') and (ExtractFilePath(G_SecondPath) <> ExtractFilePath(ModulesDirectory)) then
      begin
        AddFolderModules(TPath.Combine(G_SecondPath, C_BiblesSubDirectory), tmpBook, background, modtypeBible);
        AddFolderModules(TPath.Combine(G_SecondPath, C_BooksSubDirectory), tmpBook, background, modtypeBook);
      end;

      AddFolderModules(TPath.Combine(ModulesDirectory, C_CommentariesSubDirectory), tmpBook, background, modtypeComment);
      AddArchivedModules(TPath.Combine(CompressedModulesDirectory, C_CommentariesSubDirectory), tmpBook, background, true);

      mScanDone := true;
      Result := true;
    end
    else
    begin
      if not mFolderBiblesScanned then
      begin
        mFolderBiblesScanned := AddFolderModules(
          TPath.Combine(ModulesDirectory, C_BiblesSubDirectory),
          tmpBook,
          background,
          modtypeBible);

        Exit;
      end;

      if not mFolderBooksScanned then
      begin
        mFolderBooksScanned := AddFolderModules(
          TPath.Combine(ModulesDirectory, C_BooksSubDirectory),
          tmpBook,
          background,
          modtypeBook);

        Exit;
      end;

      if not mArchivedModulesScanned then
      begin
        mArchivedModulesScanned := AddArchivedModules(CompressedModulesDirectory, tmpBook, background);
        Exit;
      end;

      if not mSecondFolderBiblesScanned then
      begin
        if (G_SecondPath <> '') and (ExtractFilePath(G_SecondPath) <> ExtractFilePath(ModulesDirectory)) then
        begin
          mSecondFolderBiblesScanned := AddFolderModules(
            TPath.Combine(G_SecondPath, C_BiblesSubDirectory),
            tmpBook,
            background,
            modtypeBible);

          Exit;
        end
        else
          mSecondFolderBiblesScanned := true;
      end;

      if not mSecondFolderBooksScanned then
      begin
        if (G_SecondPath <> '') and (ExtractFilePath(G_SecondPath) <> ExtractFilePath(ModulesDirectory)) then
        begin
          mSecondFolderBooksScanned := AddFolderModules(
            TPath.Combine(G_SecondPath, C_BooksSubDirectory), tmpBook, background, modtypeBook);
          Exit;
        end
        else
          mSecondFolderBooksScanned := true;
      end;

      if not mFolderCommentsScanned then
      begin
        mFolderCommentsScanned := AddFolderModules(
          TPath.Combine(ModulesDirectory, C_CommentariesSubDirectory),
          tmpBook,
          background,
          modtypeComment);

        Exit;
      end;

      if not mArchivedCommentsScanned then
      begin
        mArchivedCommentsScanned := AddArchivedModules(
          TPath.Combine(CompressedModulesDirectory, C_CommentariesSubDirectory),
          tmpBook,
          background);

        Exit;
      end;

      mScanDone := true;
      Result := true;
    end;
  finally
    if mScanDone then
    begin
      mCachedModules._Sort();
      if Assigned(OnScanDone) then
        OnScanDone(self);
    end;
  end;
end;

function TModuleLoader.AddArchivedModules(path: string; tempBook: TBible; background: Boolean; addAsCommentaries: Boolean = false): Boolean;
var
  Count: integer;
  mt: TModuleType;
  modEntry: TModuleEntry;
begin
  Count := C_NumOfModulesToScan + (ord(not background) shl 12);
  if not DirectoryExists(path) then
  begin
    mSearchInitialized := false;
    Result := true;
    Exit;
  end;
  if (not mSearchInitialized) then
  begin
    // init search, set search initialized flag
    mSearchResult := FindFirst(TPath.Combine(path, '*.bqb'), faAnyFile, mSearchRecord);
    mSearchInitialized := true;
  end;

  if mSearchResult = 0 then
    repeat
      try
        tempBook.inifile := '?' + path + '\' + mSearchRecord.Name + '??' + C_ModuleIniName;
        if (addAsCommentaries) then
          mt := modtypeComment
        else
        begin
          if tempBook.isBible then
            mt := modtypeBible
          else
            mt := modtypeBook;
        end;

        modEntry := TModuleEntry.Create(
          mt,
          tempBook.Name,
          tempBook.ShortName,
          tempBook.ShortPath,
          path + '\' + mSearchRecord.Name,
          tempBook.GetStucture(),
          tempBook.Categories
        );

        mCachedModules.Add(modEntry);
      except
        on E: TBQException do
        begin
          if Assigned(OnArchiveModuleLoadFailed) then
            OnArchiveModuleLoadFailed(self, E);
        end
        else { do nothing }
      end;
      mSearchResult := FindNext(mSearchRecord);
      Dec(Count);
    until (mSearchResult <> 0) or (Count <= 0);
  if mSearchResult <> 0 then
  begin // seach complete
    FindClose(mSearchRecord);
    mSearchInitialized := false;
    Result := true;
  end
  else
    Result := false;
end;

function TModuleLoader.AddFolderModules(path: string; tempBook: TBible; background: Boolean; modType: TModuleType): Boolean;
var
  Count: integer;
  modEntry: TModuleEntry;
  modulePath: string;
begin
  Count := C_NumOfModulesToScan + (ord(not background) shl 12);
  if not mSearchInitialized then
  begin // init search
    mSearchResult := FindFirst(TPath.Combine(path, '*.*'), faDirectory, mSearchRecord);
    mSearchInitialized := true;
  end;

  if (mSearchResult = 0) then // search results are not empty
    repeat
      modulePath := TPath.Combine(path, mSearchRecord.Name) + '\bibleqt.ini';
      if (mSearchRecord.Attr and faDirectory = faDirectory) and
        ((mSearchRecord.Name <> '.') and (mSearchRecord.Name <> '..')) and
        FileExists(modulePath) then
      begin
        try
          tempBook.inifile := modulePath;

          modEntry := TModuleEntry.Create(
            modType,
            tempBook.Name,
            tempBook.ShortName,
            tempBook.ShortPath,
            EmptyWideStr,
            tempBook.GetStucture(),
            tempBook.Categories
          );

          mCachedModules.Add(modEntry);
        except
        end;
      end; // if directory

      Dec(Count);
      mSearchResult := FindNext(mSearchRecord);

    until (mSearchResult <> 0) or (Count <= 0);
  if (mSearchResult <> 0) then
  begin // search compleate
    FindClose(mSearchRecord);
    mSearchInitialized := false;
    Result := true
  end
  else
    Result := false; // to repeat the search
end;

function TModuleLoader.LoadCachedModules: Boolean;
var
  cachedModulesList: TStringList;
  i, linecount, modIx: integer;
  modEntry: TModuleEntry;
  modType: TModuleType;
  cats: string;
  bookNames: string;
  cachedModsFilePath: string;
begin
  try
    cachedModulesList := TStringList.Create();
    try
      cachedModsFilePath := GetCachedModulesListDir() + C_CachedModsFileName;
      if not FileExists(cachedModsFilePath) then begin
        Result := false;
        Exit;
      end;

      cachedModulesList.LoadFromFile(cachedModsFilePath);
      mCachedModules.Clear();
      i := 1;
      if cachedModulesList[0] <> 'v3' then
      begin
        Result := false;
        Exit;
      end;
      linecount := cachedModulesList.Count - 1;
      if linecount < 7 then
        abort;
      repeat
        modIx := mCachedModules.IndexOf(cachedModulesList[i + 1]);
        if modIx < 0 then
        begin
{$R+}
          modType := TModuleType(StrToInt(cachedModulesList[i]));
          cats := cachedModulesList[i + 6];

          if cats = '***' then
            cats := '';
          bookNames := cachedModulesList[i + 5];

          modEntry := TModuleEntry.Create(
            modType,
            cachedModulesList[i + 1],
            cachedModulesList[i + 2],
            cachedModulesList[i + 3],
            cachedModulesList[i + 4],
            bookNames,
            cats
          );
{$R-}
          mCachedModules.Add(modEntry);
        end;
        inc(i, 6);
        while (i <= linecount) and (cachedModulesList[i] <> '***') do
          inc(i);
        inc(i);

      until (i + 7) > linecount;
      Result := true;
      mCachedModules._Sort();
    finally
      cachedModulesList.Free();
    end;

  except
    mCachedModules.Clear();
    Result := false;
  end;

end;

procedure TModuleLoader.SaveCachedModules;
var
  modStringList: TStringList;
  count, i: integer;
  moduleEntry: TModuleEntry;
  wsFolder: string;
begin
  modStringList := TStringList.Create();
  try
    count := mCachedModules.Count - 1;
    if count <= 0 then
      Exit;
    modStringList.Add('v3');
    for i := 0 to count do
    begin
      moduleEntry := TModuleEntry(mCachedModules[i]);
      with modStringList, moduleEntry do
      begin
        Add(IntToStr(ord(modType)));
        Add(mFullName);
        Add(mShortName);
        Add(mShortPath);
        Add(mFullPath);
        Add(modBookNames);
        Add(modCats);
        Add('***');
      end;
    end;
    wsFolder := GetCachedModulesListDir();
    modStringList.SaveToFile(wsFolder + C_CachedModsFileName, TEncoding.UTF8);
  finally
    modStringList.Free()
  end;
end;

end.
