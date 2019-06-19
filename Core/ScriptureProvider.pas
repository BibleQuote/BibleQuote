unit ScriptureProvider;

interface

uses Bible, LinksParserIntf, BibleQuoteUtils, MainFrm, SysUtils, PlainUtils,
     BibleQuoteConfig, SelectEntityType, ExceptionFrm, IOUtils, AppIni,
     StringProcs, ManageFonts;

type
  TScriptureProvider = class
  private
    FMainView: TMainForm;
  public
    constructor Create(MainForm: TMainForm);

    function GetRefBible(ix: integer): TModuleEntry;
    function RefBiblesCount: integer;
    function GetLinkHint(command: string; defFontName: string; modPath: string): String;
    function PreProcessAutoCommand(RefBible: TBible; const cmd: string; const prefModule: string; out ConcreteCmd: string): HRESULT; overload;
    function PreProcessAutoCommand(const cmd: string; const prefModule: string; out ConcreteCmd: string): HRESULT; overload;
    function GetModuleText(
      cmd: string;
      defFontName: string;
      out fontName: string;
      out bl: TBibleLink;
      out txt: string;
      out passageSignature: string;
      options: TgmtOptions = [];
      maxWords: integer = 0): integer;

    procedure FixBookNumberForLink(var aBibleLnk: TBibleLink; aBible: TBible);
    function GetDefaultBibleSourcePath(): String;

  end;

implementation

constructor TScriptureProvider.Create(MainForm: TMainForm);
begin
  FMainView := MainForm;
end;

function TScriptureProvider.GetDefaultBibleSourcePath(): String;
var
  modIx: integer;
  modEntry: TModuleEntry;
begin
  Result := '';

  modIx := FMainView.mModules.FindByName(AppConfig.DefaultBible);
  if (modIx < 0) then
  begin
    modEntry := FMainView.mModules.ModTypedAsFirst(modtypeBible);
    if Assigned(modEntry) then
      modIx := FMainView.mModules.FindByName(modEntry.FullName);
  end;

  if (modIx >= 0) then
    Result := FMainView.mModules[modIx].ShortPath;
end;

function TScriptureProvider.GetLinkHint(command: string; defFontName: string; modPath: string): String;
var
  RefBible: TBible;
  status: Integer;
  fontName, ConcreteCmd: string;
  link: TBibleLink;
  text, passage: string;
begin
  if (modPath = '') then
  begin
    Result := Lang.SayDefault('SelectDefaultBible', 'Please select default translation in File -> Settings -> Favorite modules');
  end
  else
  begin
    RefBible := TBible.Create(FMainView);
    try
      status := PreProcessAutoCommand(RefBible, command, modPath, ConcreteCmd);

      if status > -2 then
        status := GetModuleText(ConcreteCmd, defFontName, fontName, link, text, passage, [gmtBulletDelimited, gmtLookupRefBibles, gmtEffectiveAddress]);

      if status < 0 then
        text := ConcreteCmd + ''#13''#10'' + Lang.SayDefault('HintNotFound', '--not found--')
      else
      begin
        passage := passage + ' (' + RefBible.ShortName + ')'#13''#10'';
        if text <> '' then
          text := passage + text
        else
          text := passage + Lang.SayDefault('HintNotFound', '--not found--');
      end;

      Result := text;
    finally
      RefBible.Free;
    end;
  end;
end;

function TScriptureProvider.PreProcessAutoCommand(RefBible: TBible; const cmd: string; const prefModule: string; out ConcreteCmd: string): HRESULT;
label Fail;
var
  ps, refCnt, refIx, prefModIx: integer;
  me: TModuleEntry;
  bl, moduleEffectiveLink: TBibleLink;
  dp: string;
begin
  me := nil;
  try
    if Pos('go', Trim(cmd)) <> 1 then
      goto Fail;
    ps := Pos(C__bqAutoBible, cmd);
    if ps = 0 then
      goto Fail;
    if not bl.FromBqStringLocation(cmd, dp) then
      goto Fail;

    prefModIx := FMainView.mModules.FindByFolder(prefModule);
    if prefModIx >= 0 then
    begin
      me := FMainView.mModules[prefModIx];
      if me.modType = modtypeBible then
      begin
        RefBible.SetInfoSource(me.GetInfoPath());
        FixBookNumberForLink(bl, RefBible);
        Result := RefBible.LinkValidnessStatus(me.GetInfoPath(), bl, true)
      end
      else
        Result := -2;
    end
    else
      Result := -2;

    if Result < -1 then
    begin
      refCnt := RefBiblesCount() - 1;
      Result := -2;
      for refIx := 0 to refCnt do
      begin
        me := GetRefBible(refIx);
        RefBible.SetInfoSource(me.GetInfoPath());
        FixBookNumberForLink(bl, RefBible);
        Result := RefBible.LinkValidnessStatus(me.GetInfoPath(), bl, true);
        if Result > -2 then
          break;
      end;
    end;
    if Result > -2 then
    begin
      RefBible.InternalToReference(bl, moduleEffectiveLink);
      if (me <> nil) then
        ConcreteCmd := moduleEffectiveLink.ToCommand(me.ShortPath);
      Exit;
    end;
  Fail:
    Result := -2;
    ConcreteCmd := cmd;
  except
    g_ExceptionContext.Add('PreProcessAutoCommand.cmd' + cmd);
    g_ExceptionContext.Add('PreProcessAutoCommand.prefModule' + prefModule);
    raise;
  end;
end;

function TScriptureProvider.RefBiblesCount: integer;
var
  i, cnt: integer;
begin
  cnt := FMainView.mFavorites.mModuleEntries.Count - 1;
  Result := 0;
  for i := 0 to cnt do
    if FMainView.mFavorites.mModuleEntries[i].ModType = modtypeBible then
      inc(Result);
end;

function TScriptureProvider.GetRefBible(ix: integer): TModuleEntry;
var
  i, cnt, bi: integer;
  me: TModuleEntry;
begin
  cnt := FMainView.mFavorites.mModuleEntries.Count - 1;
  bi := 0;
  me := nil;

  for i := 0 to cnt do
  begin
    me := FMainView.mFavorites.mModuleEntries[i];
    if me.modType = modtypeBible then
      inc(bi);
    if bi > ix then
    begin
      break;
    end;
  end;

  if bi > ix then
    Result := me
  else
    Result := nil;
end;

procedure TScriptureProvider.FixBookNumberForLink(var aBibleLnk: TBibleLink; aBible: TBible);
var
  MyBibleBookNumber: Integer;
begin

  if (TSelectEntityType.IsMyBibleFileEntry(aBible.InfoSource.FileName)) then
  begin
    MyBibleBookNumber := aBible.NativeToMyBibleBookNumber(aBibleLnk.book);
    aBibleLnk.book := MyBibleBookNumber;
  end;
end;

function TScriptureProvider.GetModuleText(
  cmd: string;
  defFontName: string;
  out fontName: string;
  out bl: TBibleLink;
  out txt: string;
  out passageSignature: string;
  options: TgmtOptions = [];
  maxWords: integer = 0): integer;
var
  i, verseCount, C, status_valid: integer;
  path: string;
  fontFound, addEllipsis, limited, linkValid: Boolean;
  ibl, effectiveLnk: TBibleLink;
  delimiter, line: string;
  currentBibleIx, prefBibleCount, wordCounter, wordsAdded: integer;
  refBook: TBible;
label lblErrNotFnd;
  function NextRefBible(): Boolean;
  var
    me: TModuleEntry;
  begin
    if currentBibleIx < prefBibleCount then
    begin
      me := GetRefBible(currentBibleIx);
      inc(currentBibleIx);
      refBook.SetInfoSource(ResolveFullPath(me.GetInfoPath()));
      Result := true;
    end
    else
      Result := false;

  end;

begin
  Result := -1;
  refBook := TBible.Create(FMainView);
  try
    linkValid := ibl.FromBqStringLocation(cmd, path);
    if not linkValid then
    begin
      txt := 'Неверный аргумент GetModuleText:' + StackLst(GetCallerEIP(), nil);
      Exit;
    end;

    if path <> C__bqAutoBible then
    begin
      // form the path to the ini module
      path := ResolveFullPath(TPath.Combine(path, 'bibleqt.ini'));
      // try to load the module
      refBook.SetInfoSource(path);
    end
    else
      raise Exception.Create('Неверный аргумент GetModuleText:не указан модуль');

    if gmtLookupRefBibles in options then
    begin
      currentBibleIx := 0;
      prefBibleCount := RefBiblesCount();
    end;
    repeat
      if not(gmtEffectiveAddress in options) then
      begin
        if refBook.InternalToReference(ibl, effectiveLnk) < -1 then
          goto lblErrNotFnd;
      end
      else
        effectiveLnk := ibl;

      status_valid := refBook.LinkValidnessStatus(refBook.InfoSource.FileName, effectiveLnk, false);
      effectiveLnk.AssignTo(bl);
      if status_valid < -1 then
        goto lblErrNotFnd;
      refBook.SetHTMLFilterX('', true);
      refBook.OpenChapter(effectiveLnk.book, effectiveLnk.chapter);

      // already opened?
      passageSignature := refBook.ShortPassageSignature(
        effectiveLnk.book,
        effectiveLnk.chapter,
        effectiveLnk.vstart,
        effectiveLnk.vend);

      verseCount := refBook.verseCount();
      if effectiveLnk.vstart = 0 then
        effectiveLnk.vstart := 1;
      if effectiveLnk.vend <= 0 then
        C := verseCount
      else
        C := effectiveLnk.vend;
      if (effectiveLnk.vstart > verseCount) then
        Exit;
      if (effectiveLnk.vend > verseCount) then
        effectiveLnk.vend := verseCount;

      if gmtBulletDelimited in options then
        delimiter := C_BulletChar + #32
      else
        delimiter := #13#10;
      Dec(C);
      if (C - effectiveLnk.vstart) > 10 then
      begin
        C := effectiveLnk.vstart + 10;
        addEllipsis := true
      end
      else
        addEllipsis := false;
      wordCounter := 0;

      for i := effectiveLnk.vstart to C do
      begin
        if maxWords = 0 then
          txt := txt + DeleteStrongNumbers(refBook.GetVerseByNumber(i)) + delimiter
        else
        begin
          line := StrLimitToWordCnt(
            DeleteStrongNumbers(refBook.GetVerseByNumber(i)),
            maxWords - wordCounter, wordsAdded, limited);

          inc(wordCounter, wordsAdded);

          txt := txt + line;
          if not limited then
            txt := txt + delimiter
          else
            break;
        end;
      end;
      if maxWords = 0 then
        txt := txt + DeleteStrongNumbers(refBook.GetVerseByNumber(C+1))
      else
      begin
        if not limited then
        begin
          line := StrLimitToWordCnt(
            DeleteStrongNumbers(refBook.GetVerseByNumber(C+1)),
            maxWords - wordCounter, wordsAdded, limited);

          txt := txt + line;
        end;
        addEllipsis := limited;
      end;
      if addEllipsis then
        txt := txt + '...';

      if Length(refBook.fontName) > 0 then
      begin
        fontFound := FontManager.PrepareFont(refBook.fontName, refBook.path);
        fontName := refBook.fontName;
      end
      else
        fontFound := false;
      // if there is no preferred font or it is not found, and encoding is specified
      if not fontFound and (refBook.desiredCharset >= 2) then
      begin
        // find the font with the desired encoding, take into account default font
        if Length(refBook.fontName) > 0 then
          fontName := refBook.fontName
        else
          fontName := '';

        fontName := FontFromCharset(refBook.desiredCharset, defFontName);
      end;
      if Length(fontName) = 0 then
        fontName := AppConfig.DefFontName;
      Result := 0;
      break;
    lblErrNotFnd:

    until (not(gmtLookupRefBibles in options)) or (not NextRefBible());
  except
  end;
end;

function TScriptureProvider.PreProcessAutoCommand(const cmd: string; const prefModule: string; out ConcreteCmd: string): HRESULT;
var
  RefBible: TBible;
begin
  RefBible := TBible.Create(FMainView);

  try
    Result := PreProcessAutoCommand(RefBible, cmd, prefModule, ConcreteCmd);
  finally
    RefBible.Free;
  end;

end;

end.
