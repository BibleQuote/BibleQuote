﻿unit ModuleProcs;

interface

uses
  Classes, SysUtils, bible, BibleQuoteUtils, Engine, EngineInterfaces;

const
  C_CompressedModulesSubPath = 'compressed\modules';
  C_CommentariesSubPath = 'compressed\commentaries';
  C_NumOfModulesToScan = 5;
  C_ModuleIniName = 'bibleqt.ini';
  C_CachedModsFileName = 'cached.lst';

type
  TArchiveModuleLoadFailedEvent = procedure(Sender: TObject; E: TBQException) of object;

  TModuleLoader = class
  private
    mBqEngine: TBibleQuoteEngine;
    mSearchInitialized: Boolean;

    mCachedModules: TCachedModules;

    // track scanning process
    mFolderCommentsScanned: Boolean;
    mFolderModulesScanned: Boolean;
    mArchivedBiblesScanned: Boolean;
    mSecondFolderModulesScanned: Boolean;
    mArchivedCommentsScanned: Boolean;
    mScanDone: Boolean;

    FOnDictionariesLoading: TNotifyEvent;
    FOnDictionariesLoaded: TNotifyEvent;
    FOnModulesLoading: TNotifyEvent;
    FOnScanDone: TNotifyEvent;
    FOnArchiveModuleLoadFailed: TArchiveModuleLoadFailedEvent;
  public
    constructor Create(BqEngine: TBibleQuoteEngine);
    destructor Destroy(); override;

    function LoadModules(tmpBook: TBible; background: Boolean): Boolean;
    function LoadDictionaries(foreground: Boolean): Boolean;
    function AddArchivedModules(path: string; tempBook: TBible; background: Boolean; addAsCommentaries: Boolean = false): Boolean;
    function AddFolderModules(path: string; tempBook: TBible; background: Boolean; addAsCommentaries: Boolean = false): Boolean;

    function LoadCachedModules(): Boolean;
    procedure SaveCachedModules();

    function GetCachedModules: TCachedModules;
    property CachedModules: TCachedModules read GetCachedModules;

    function GetScanDone: Boolean;
    property ScanDone: Boolean read GetScanDone;

    property OnDictionariesLoading: TNotifyEvent read FOnDictionariesLoading write FOnDictionariesLoading;
    property OnDictionariesLoaded: TNotifyEvent read FOnDictionariesLoaded write FOnDictionariesLoaded;
    property OnModulesLoading: TNotifyEvent read FOnModulesLoading write FOnModulesLoading;
    property OnScanDone: TNotifyEvent read FOnScanDone write FOnScanDone;
    property OnArchiveModuleLoadFailed: TArchiveModuleLoadFailedEvent read FOnArchiveModuleLoadFailed write FOnArchiveModuleLoadFailed;
  end;

implementation

constructor TModuleLoader.Create(BqEngine: TBibleQuoteEngine);
begin
  mBqEngine := BqEngine;
  mSearchInitialized := false;

  mFolderCommentsScanned := false;
  mFolderModulesScanned := false;
  mArchivedBiblesScanned := false;
  mSecondFolderModulesScanned := false;
  mArchivedCommentsScanned := false;

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

function TModuleLoader.LoadDictionaries(foreground: Boolean): Boolean;
begin
  Result := mBqEngine[bqsDictionariesLoaded];
  if not Result then
  begin
    if mBqEngine[bqsDictionariesLoading] then
    begin
      if not foreground then
        Exit; // just wait
    end;

    if Assigned(OnDictionariesLoading) then
      OnDictionariesLoading(self);

    mBqEngine.LoadDictionaries(ExePath() + 'Dictionaries\', foreground);
    if not foreground then
      Exit;
  end;
  // init dic tokens list
  Result := mBqEngine[bqsDictionariesListCreated];
  if not Result then
  begin
    if mBqEngine[bqsDictionariesListCreating] and (not foreground) then
    begin
      Exit; // just wait
    end;
    mBqEngine.InitDictionaryItemsList(foreground);
    if not foreground then
      Exit;
  end;

  Result := true;
  if Assigned(OnDictionariesLoaded) then
      OnDictionariesLoaded(self);
end;

function TModuleLoader.LoadModules(tmpBook: TBible; background: Boolean): Boolean;
var
  compressedModulesDir: string;
begin
  Result := false;
  try
    if not background then
    begin
      AddFolderModules(ExePath, tmpBook, background);
      compressedModulesDir := ExePath + C_CompressedModulesSubPath;
      AddArchivedModules(compressedModulesDir, tmpBook, background);

      if (G_SecondPath <> '') and (ExtractFilePath(G_SecondPath) <> ExtractFilePath(ExePath)) then
        AddFolderModules(G_SecondPath, tmpBook, background);

      AddArchivedModules(ExePath + C_CommentariesSubPath, tmpBook, background, true);
      AddFolderModules(ExePath + 'Commentaries\', tmpBook, background, true);
      mScanDone := true;
      Result := true;
    end
    else
    begin
      if not(mFolderModulesScanned) then
      begin
        mFolderModulesScanned := AddFolderModules(ExePath, tmpBook, background);
        Exit;
      end;
      if not mArchivedBiblesScanned then
      begin
        compressedModulesDir := ExePath + C_CompressedModulesSubPath;
        mArchivedBiblesScanned := AddArchivedModules(compressedModulesDir, tmpBook, background);
        Exit;
      end;
      if not mSecondFolderModulesScanned then
      begin
        if (G_SecondPath <> '') and
          (ExtractFilePath(G_SecondPath) <> ExtractFilePath(ExePath)) then
        begin
          mSecondFolderModulesScanned := AddFolderModules(G_SecondPath, tmpBook, background);
          Exit;
        end
        else
          mSecondFolderModulesScanned := true;
      end; // sencond folder
      if not mArchivedCommentsScanned then
      begin
        mArchivedCommentsScanned :=
          AddArchivedModules(ExePath + C_CommentariesSubPath, tmpBook, background, true);
        Exit;
      end;
      if not mFolderCommentsScanned then
      begin
        mFolderCommentsScanned := AddFolderModules(ExePath + 'Commentaries\', tmpBook, background, true);
        Exit;
      end
      else
      begin
        mScanDone := true;
        Result := true;
      end;
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
  searchRecord: TSearchRec;
  searchResult: integer;
begin
  // count - либо несколько либо все
  Count := C_NumOfModulesToScan + (ord(not background) shl 12);
  if not DirectoryExists(path) then
  begin
    mSearchInitialized := false;
    // на всякий случай сбросить флаг активного поиска
    Result := true;
    Exit // сканирование завершено
  end;
  if (not mSearchInitialized) then
  begin
    // инициализация поиска, установка флага акт. поиска
    searchResult := FindFirst(path + '\*.bqb', faAnyFile, searchRecord);
    mSearchInitialized := true;
  end;

  if searchResult = 0 then
    repeat
      try
        tempBook.inifile := '?' + path + '\' + searchRecord.Name + '??' + C_ModuleIniName;
        // ТИП МОДУЛЯ
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
          path + '\' + searchRecord.Name,
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
      searchResult := FindNext(searchRecord);
      Dec(Count);
    until (searchResult <> 0) or (Count <= 0);
  if searchResult <> 0 then
  begin // если поиск завершен
    FindClose(searchRecord);
    mSearchInitialized := false;
    Result := true;
  end
  else
    Result := false;
end;

function TModuleLoader.AddFolderModules(path: string; tempBook: TBible; background: Boolean; addAsCommentaries: Boolean = false): Boolean;
var
  Count: integer;
  modEntry: TModuleEntry;
  mt: TModuleType;
  searchRecord: TSearchRec;
  searchResult: integer;
begin
  // count - либо несколько либо все
  Count := C_NumOfModulesToScan + (ord(not background) shl 12);
  if not(mSearchInitialized) then
  begin // инициализация поиска
    searchResult := FindFirst(path + '*.*', faDirectory, searchRecord);
    mSearchInitialized := true;
  end;

  if (searchResult = 0) then // если что-то найдено
    repeat
      if (searchRecord.Attr and faDirectory = faDirectory) and
        ((searchRecord.Name <> '.') and (searchRecord.Name <> '..')) and
        FileExists(path + searchRecord.Name + '\bibleqt.ini') then
      begin
        try
          tempBook.inifile := path + searchRecord.Name + '\bibleqt.ini';
          // ТИП МОДУЛЯ
          if (addAsCommentaries) then
            mt := modtypeComment
          else
          begin
            if tempBook.isBible then
              mt := modtypeBible
            else
              mt := modtypeBook;
          end;

          modEntry := TModuleEntry.Create(mt, tempBook.Name, tempBook.ShortName,
            tempBook.ShortPath, EmptyWideStr, tempBook.GetStucture(),
            tempBook.Categories);

          mCachedModules.Add(modEntry);
        except
        end;
      end; // if directory

      Dec(Count);
      searchResult := FindNext(searchRecord);

    until (searchResult <> 0) or (Count <= 0);
  if (searchResult <> 0) then
  begin // если сканирование завершено
    FindClose(searchRecord);
    mSearchInitialized := false;
    Result := true // то есть сканирование завершено
  end
  else
    Result := false; // нужен повторный проход
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
        Add(wsFullName);
        Add(wsShortName);
        Add(wsShortPath);
        Add(wsFullPath);
        Add(modBookNames);
        Add(modCats);
        Add('***');
      end; // with tabInfo, tabStringList
    end; // for
    wsFolder := GetCachedModulesListDir();
    modStringList.SaveToFile(wsFolder + C_CachedModsFileName, TEncoding.UTF8);
  finally
    modStringList.Free()
  end;
end;

end.