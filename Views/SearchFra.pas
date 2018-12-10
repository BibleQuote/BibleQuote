unit SearchFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, BibleQuoteUtils,
  HTMLEmbedInterfaces, Htmlview, Vcl.StdCtrls, Vcl.ExtCtrls, Bible,
  StringProcs, LinksParser, MainFrm, LibraryFra, LayoutConfig, IOUtils,
  System.ImageList, Vcl.ImgList, LinksParserIntf, HintTools, Vcl.Menus,
  Clipbrd, AppIni;

type
  TSearchFrame = class(TFrame, ISearchView, IBookSearchCallback)
    pnlSearch: TPanel;
    lblSearch: TLabel;
    cbSearch: TComboBox;
    cbList: TComboBox;
    btnFind: TButton;
    chkAll: TCheckBox;
    chkPhrase: TCheckBox;
    chkParts: TCheckBox;
    chkCase: TCheckBox;
    chkExactPhrase: TCheckBox;
    cbQty: TComboBox;
    btnSearchOptions: TButton;
    bwrSearch: THTMLViewer;
    btnBookSelect: TButton;
    lblBook: TLabel;
    imgList: TImageList;
    pmRef: TPopupMenu;
    miRefCopy: TMenuItem;
    miOpenNewView: TMenuItem;
    miRefPrint: TMenuItem;
    procedure bwrSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrSearchHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure bwrSearchHotSpotCovered(Sender: TObject; const SRC: string);
    procedure btnFindClick(Sender: TObject);
    procedure cbSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbListDropDown(Sender: TObject);
    procedure chkExactPhraseClick(Sender: TObject);
    procedure btnSearchOptionsClick(Sender: TObject);
    procedure cbQtyChange(Sender: TObject);
    procedure btnBookSelectClick(Sender: TObject);
    procedure pmRefPopup(Sender: TObject);
    procedure miRefCopyClick(Sender: TObject);
    procedure miOpenNewViewClick(Sender: TObject);
    procedure miRefPrintClick(Sender: TObject);
  private
    mMainView: TMainForm;
    mTabsView: ITabsView;

    mSearchState: TSearchTabState;

    mCurrentBook: TBible;

    mBookSelectView: TLibraryFrame;
    mBookSelectForm: TForm;

    mSearchCommand: string;

    procedure SearchListInit;
    procedure BookSearchComplete(bible: TBible);
    procedure OnBookSelectFormDeactivate(Sender: TObject);
    procedure OnBookSelect(Sender: TObject; modEntry: TModuleEntry);
  public
    constructor Create(AOwner: TComponent; mainView: TMainForm; tabsView: ITabsView); reintroduce;
    destructor Destroy; override;

    procedure DisplaySearchResults(page: integer);
    procedure Translate();
    procedure ApplyConfig(appConfig: TAppConfig);

    function GetBookPath(): string;
    property SearchState: TSearchTabState read mSearchState write mSearchState;
    procedure SetCurrentBook(shortPath: string);
    procedure OnVerseFound(bible: TBible; NumVersesFound, book, chapter, verse: integer; s: string; removeStrongs: boolean);
    procedure OnSearchComplete(bible: TBible);
  end;

implementation

{$R *.dfm}

constructor TSearchFrame.Create(AOwner: TComponent; mainView: TMainForm; tabsView: ITabsView);
begin
  inherited Create(AOwner);
  mMainView := mainView;
  mTabsView := tabsView;

  mSearchState := TSearchTabState.Create;

  mBookSelectForm := TForm.Create(self);
  mBookSelectForm.OnDeactivate := OnBookSelectFormDeactivate;

  mBookSelectView := TLibraryFrame.Create(nil);
  mBookSelectView.OnSelectModule := OnBookSelect;
  mBookSelectView.cmbBookType.Enabled := true;
  mBookSelectView.cmbBookType.ItemIndex := 0;
  mBookSelectView.Align := TAlign.alClient;
  mBookSelectView.Parent := mBookSelectForm;

  ApplyConfig(AppConfig);
end;

procedure TSearchFrame.OnBookSelectFormDeactivate(Sender: TObject);
begin
  AppConfig.LibFormWidth := mBookSelectForm.Width;
  AppConfig.LibFormHeight := mBookSelectForm.Height;
  AppConfig.LibFormTop := mBookSelectForm.Top;
  AppConfig.LibFormLeft := mBookSelectForm.Left;
end;

procedure TSearchFrame.OnBookSelect(Sender: TObject; modEntry: TModuleEntry);
begin
  SetCurrentBook(modEntry.mShortPath);

  PostMessage(mBookSelectForm.Handle, wm_close, 0, 0);
end;

destructor TSearchFrame.Destroy();
begin
  if Assigned(mSearchState) then
    FreeAndNil(mSearchState);

  inherited;
end;

procedure TSearchFrame.btnBookSelectClick(Sender: TObject);
begin
  mBookSelectView.SetModules(mMainView.mModules);

  mBookSelectForm.Width := AppConfig.LibFormWidth;
  mBookSelectForm.Height := AppConfig.LibFormHeight;
  mBookSelectForm.Top := AppConfig.LibFormTop;
  mBookSelectForm.Left := AppConfig.LibFormLeft;

  mBookSelectForm.ShowModal();
end;

procedure TSearchFrame.btnFindClick(Sender: TObject);
var
  s: set of 0 .. 255;
  searchText, wrd, wrdnew, books: string;
  params: byte;
  lnks: TStringList;
  book, chapter, v1, v2, linksCnt, i: integer;

  function metabook(const bible: TBible; const str: string): Boolean;
  var
    wl: string;
  label success;
  begin
    wl := LowerCase(str);
    if (Pos('нз', wl) = 1) or (Pos('nt', wl) = 1) then
    begin

      if bible.Trait[bqmtNewCovenant] and bible.InternalToReference(40, 1, 1, book, chapter, v1) then
      begin
        s := s + [39 .. 65];
      end;
      goto success;
    end
    else if (Pos('вз', wl) = 1) or (Pos('ot', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] and bible.InternalToReference(1, 1, 1, book, chapter, v1) then
      begin
        s := s + [0 .. 38];
      end;
      goto success;
    end
    else if (Pos('пят', wl) = 1) or (Pos('pent', wl) = 1) or
      (Pos('тор', wl) = 1) or (Pos('tor', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] and bible.InternalToReference(1, 1, 1, book, chapter, v1) then
      begin
        s := s + [0 .. 4];
      end;
      goto success;
    end
    else if (Pos('ист', wl) = 1) or (Pos('hist', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [0 .. 15];
      end;
      goto success;
    end
    else if (Pos('уч', wl) = 1) or (Pos('teach', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [16 .. 21];
      end;
      goto success;
    end
    else if (Pos('бпрор', wl) = 1) or (Pos('bproph', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [22 .. 26];
      end;
      goto success;
    end
    else if (Pos('мпрор', wl) = 1) or (Pos('mproph', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [27 .. 38];
      end;
      goto success;
    end
    else if (Pos('прор', wl) = 1) or (Pos('proph', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [22 .. 38];
        if bible.Trait[bqmtNewCovenant] and bible.InternalToReference(66, 1, 1, book, chapter, v1) then
        begin
          Include(s, 65);
        end;
        goto success;
      end
    end
    else if (Pos('ева', wl) = 1) or (Pos('gos', wl) = 1) then
    begin
      if bible.Trait[bqmtNewCovenant] then
      begin
        s := s + [39 .. 42];
      end;
      goto success;
    end
    else if (Pos('пав', wl) = 1) or (Pos('paul', wl) = 1) then
    begin
      if bible.Trait[bqmtNewCovenant] and bible.InternalToReference(52, 1, 1, book, chapter, v1) then
      begin
        s := s + [book - 1 .. book + 12];
      end;
      goto success;
    end;

    Result := false;
    Exit;
  success:
    Result := true;
  end;

begin
  if not Assigned(mCurrentBook) then
    Exit;

  if cbQty.ItemIndex < cbQty.Items.Count - 1 then
    mSearchState.SearchPageSize := StrToInt(cbQty.Items[cbQty.ItemIndex])
  else
    mSearchState.SearchPageSize := 50000;

  if mSearchState.IsSearching then
  begin
    mSearchState.IsSearching := false;
    mCurrentBook.StopSearching;
    Screen.Cursor := crDefault;
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    mSearchState.IsSearching := true;

    s := [];

    if (not mCurrentBook.isBible)
    then
    begin
      if (cbList.ItemIndex <= 0) then
        s := [0 .. mCurrentBook.BookQty - 1]
      else
        s := [cbList.ItemIndex - 1];
    end
    else
    begin // FULL BIBLE SEARCH
      searchText := Trim(cbList.Text);
      linksCnt := cbList.Items.Count - 1;
      if not mSearchState.SearchBooksDDAltered then
        if (cbList.ItemIndex < 0) then
          for i := 0 to linksCnt do
            if CompareText(cbList.Items[i], searchText) = 0 then
            begin
              cbList.ItemIndex := i;
              break;
            end;

      if (cbList.ItemIndex < 0) or (mSearchState.SearchBooksDDAltered) then
      begin
        lnks := TStringList.Create;
        try
          books := '';
          StrToLinks(searchText, lnks);
          linksCnt := lnks.Count - 1;
          for i := 0 to linksCnt do
          begin
            if metabook(mCurrentBook, lnks[i]) then
            begin

              books := books + FirstWord(lnks[i]) + ' ';
              continue
            end
            else if mCurrentBook.OpenReference(lnks[i], book, chapter, v1, v2) and
              (book > 0) and (book < 77) then
            begin
              Include(s, book - 1);
              if Pos(mCurrentBook.ShortNames[book], books) <= 0 then
              begin

                books := books + mCurrentBook.ShortNames[book] + ' ';
              end;

            end;

          end;
          books := Trim(books);
          if (Length(books) > 0) and (mSearchState.SearchBooksCache.IndexOf(books) < 0) then
            mSearchState.SearchBooksCache.Add(books);

        finally
          lnks.Free();
        end;
      end
      else
        case integer(cbList.Items.Objects[cbList.ItemIndex]) of
          0:
            s := [0 .. 65];
          -1:
            s := [0 .. 38];
          -2:
            s := [39 .. 65];
          -3:
            s := [0 .. 4];
          -4:
            s := [5 .. 21];
          -5:
            s := [22 .. 38];
          -6:
            s := [39 .. 43];
          -7:
            s := [44 .. 65];
          -8:
            begin
              if mCurrentBook.Trait[bqmtApocrypha] then
                s := [66 .. mCurrentBook.BookQty - 1]
              else
                s := [0];
            end;
        else
          s := [cbList.ItemIndex - 8 - ord(mCurrentBook.Trait[bqmtApocrypha])];
          // search in single book
        end;
    end;

    searchText := Trim(cbSearch.Text);
    StrReplace(searchText, '.', ' ', true);
    StrReplace(searchText, ',', ' ', true);
    StrReplace(searchText, ';', ' ', true);
    StrReplace(searchText, '?', ' ', true);
    StrReplace(searchText, '"', ' ', true);
    searchText := Trim(searchText);

    if searchText <> '' then
    begin
      if cbSearch.Items.IndexOf(searchText) < 0 then
        cbSearch.Items.Insert(0, searchText);

      mSearchState.SearchResults.Clear;

      mSearchState.SearchWords.Clear;
      wrd := cbSearch.Text;

      if not chkExactPhrase.Checked then
      begin
        while wrd <> '' do
        begin
          wrdnew := DeleteFirstWord(wrd);

          mSearchState.SearchWords.Add(wrdnew);
        end;
      end
      else
      begin
        wrdnew := Trim(wrd);
        mSearchState.SearchWords.Add(wrdnew);
      end;

      params :=
        spWordParts * (1 - ord(chkParts.Checked)) +
        spContainAll * (1 - ord(chkAll.Checked)) +
        spFreeOrder * (1 - ord(chkPhrase.Checked)) +
        spAnyCase * (1 - ord(chkCase.Checked)) +
        spExactPhrase * ord(chkExactPhrase.Checked);

      if (params and spExactPhrase = spExactPhrase) and (params and spWordParts = spWordParts) then
        params := params - spWordParts;

      mSearchState.SearchTime := GetTickCount;

      // TODO: fix search with strongs, currently false
      mCurrentBook.Search(searchText, params, s, false, Self);
      //mCurrentBook.Search(searchText, params, s, not (vtisShowStrongs in bookView.BookTabInfo.State), Self);
    end;
  finally
    Screen.Cursor := crDefault;
  end
end;

procedure TSearchFrame.BookSearchComplete(bible: TBible);
begin
  mSearchState.IsSearching := false;
  mSearchState.SearchTime := GetTickCount - mSearchState.SearchTime;
  lblSearch.Caption := lblSearch.Caption + ' (' + IntToStr(mSearchState.SearchTime) + ')';
  DisplaySearchResults(1);
end;

procedure TSearchFrame.btnSearchOptionsClick(Sender: TObject);
begin
  if pnlSearch.Height > chkCase.Top + chkCase.Height then
  begin // wrap it
    pnlSearch.Height := chkAll.Top;
    btnSearchOptions.Caption := '>';
  end
  else
  begin
    pnlSearch.Height := lblSearch.Top + lblSearch.Height + 10;
    btnSearchOptions.Caption := '<';
  end;

  cbSearch.SetFocus;
end;

procedure TSearchFrame.bwrSearchHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  i, code: integer;
  book, chapter, fromverse, toverse: integer;
  command: string;
begin
  if not Assigned(mCurrentBook) then
    Exit;

  command := SRC;
  Val(command, i, code);
  if code = 0 then
    DisplaySearchResults(i)
  else
  begin
    if (Copy(command, 1, 3) <> 'go ') then
    begin
      if mCurrentBook.OpenReference(command, book, chapter, fromverse, toverse) then
        command := Format('go %s %d %d %d %d', [mCurrentBook.ShortPath, book, chapter, fromverse, toverse])
      else
        command := '';
    end;

    if Length(command) > 0 then
      mMainView.OpenOrCreateBookTab(command, '', mMainView.DefaultBookTabState);
  end;
  Handled := true;
end;

procedure TSearchFrame.bwrSearchHotSpotCovered(Sender: TObject; const SRC: string);
begin
  // TODO: decide what source to use for hints
  // show hints from this source
end;

procedure TSearchFrame.bwrSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  mSearchState.SearchBrowserPosition := bwrSearch.Position;
end;

procedure TSearchFrame.bwrSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_NEXT) and (bwrSearch.Position = mSearchState.SearchBrowserPosition) then
    DisplaySearchResults(mSearchState.SearchPage + 1);

  if (Key = VK_PRIOR) and (bwrSearch.Position = mSearchState.SearchBrowserPosition) then
  begin
    if mSearchState.SearchPage = 1 then
      Exit;
    DisplaySearchResults(mSearchState.SearchPage - 1);
    bwrSearch.PositionTo('endofsearchresults');
  end;
end;

procedure TSearchFrame.cbListDropDown(Sender: TObject);
begin
  if not Assigned(mCurrentBook) then
    Exit;

  if IsDown(VK_MENU) and (mCurrentBook.isBible) and (mSearchState.SearchBooksCache.Count > 0)
  then
  begin
    cbList.Items.Assign(mSearchState.SearchBooksCache);
    mSearchState.SearchBooksDDAltered := true;
  end
  else
  begin
    if mSearchState.SearchBooksDDAltered then
      SearchListInit();
    mSearchState.SearchBooksDDAltered := false;
  end;
end;

procedure TSearchFrame.cbQtyChange(Sender: TObject);
begin
  if cbQty.ItemIndex < cbQty.Items.Count - 1 then
    mSearchState.SearchPageSize := StrToInt(cbQty.Items[cbQty.ItemIndex])
  else
    mSearchState.SearchPageSize := 50000;
  DisplaySearchResults(1);
end;

procedure TSearchFrame.cbSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  s: TComboBox;
begin
  if Key = VK_RETURN then
  begin
    s := (Sender as TComboBox);
    if s.DroppedDown then
      s.DroppedDown := false;
  end;
end;

procedure TSearchFrame.chkExactPhraseClick(Sender: TObject);
begin
  if chkExactPhrase.Checked then
  begin
    chkAll.Checked := false;
    chkPhrase.Checked := false;
    chkParts.Checked := false;
    chkCase.Checked := false;
  end;
end;

procedure TSearchFrame.Translate();
begin
  Lang.TranslateControl(self, 'MainForm');
  Lang.TranslateControl(self, 'DockTabsForm');

  if not Assigned(mCurrentBook) then
    lblBook.Caption := Lang.SayDefault('SelectBook', 'Select book');

  cbList.ItemIndex := 0;
  mBookSelectView.Translate();

  mBookSelectForm.Caption := Lang.SayDefault('SelectBook', 'Select book');
end;

procedure TSearchFrame.ApplyConfig(appConfig: TAppConfig);
var
  browserpos: integer;
begin
  with bwrSearch do
  begin
    browserpos := Position and $FFFF0000;
    DefFontName := AppConfig.RefFontName;
    DefFontSize := AppConfig.RefFontSize;
    DefFontColor := AppConfig.RefFontColor;

    DefBackGround := AppConfig.BackgroundColor;
    DefHotSpotColor := AppConfig.HotSpotColor;

    if (DocumentSource <> '') then
    begin
      LoadFromString(DocumentSource);
      Position := browserpos;
    end;
    Refresh();
  end;

  if (appConfig.MainFormFontName <> Font.Name) then
    Font.Name := appConfig.MainFormFontName;

  if (appConfig.MainFormFontSize <> Font.Size) then
    Font.Size := appConfig.MainFormFontSize;
end;

function TSearchFrame.GetBookPath(): string;
begin
  Result := '';
  if Assigned(mCurrentBook) then
    Result := mCurrentBook.ShortPath;
end;

procedure TSearchFrame.miOpenNewViewClick(Sender: TObject);
var
  command: string;
begin
  command := Trim(mSearchCommand);
  if Length(command) <= 0 then
    Exit;

  mSearchCommand := '';
  mMainView.NewBookTab(command, '------', mMainView.DefaultBookTabState, '', true);
end;

procedure TSearchFrame.miRefCopyClick(Sender: TObject);
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      if not(AppConfig.AddFontParams xor IsDown(VK_SHIFT)) then
        Clipboard.AsText := (pmRef.PopupComponent as THTMLViewer).SelText
      else
        (pmRef.PopupComponent as THTMLViewer).CopyToClipboard();
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TSearchFrame.miRefPrintClick(Sender: TObject);
begin
  with mMainView.PrintDialog do
    if Execute then
      (pmRef.PopupComponent as THTMLViewer).Print(MinPage, MaxPage)
end;

procedure TSearchFrame.SetCurrentBook(shortPath: string);
var
  iniPath: string;
  caption: string;
begin
  if (shortPath = '') then
  begin
    lblBook.Caption := Lang.SayDefault('SelectBook', 'Select book');
    mCurrentBook := nil;
    Exit;
  end;

  mCurrentBook := TBible.Create(mMainView);

  iniPath := TPath.Combine(shortPath, 'bibleqt.ini');
  mCurrentBook.inifile := MainFileExists(iniPath);
  SearchListInit;

  if (mCurrentBook.isBible) then
    cbList.Style := csDropDownList
  else
    cbList.Style := csDropDown;

  caption := Format('%s, %s', [mCurrentBook.Name, mCurrentBook.ShortName]);
  lblBook.Caption := caption.Trim([',', ' ']);
end;

procedure TSearchFrame.DisplaySearchResults(page: integer);
var
  i, limit: integer;
  s: string;
  dSource: string;
begin
  if not Assigned(mCurrentBook) then
  begin
    bwrSearch.Clear;
    Exit;
  end;

  if (mSearchState.SearchPageSize * (page - 1) > mSearchState.SearchResults.Count) or (mSearchState.SearchResults.Count = 0) then
  begin
    Screen.Cursor := crDefault;
    bwrSearch.Clear;
    Exit;
  end;

  mSearchState.SearchPage := page;

  dSource := Format('<b>"<font face="%s">%s</font>"</b> (%d) <p>', [mCurrentBook.fontName, cbSearch.Text, mSearchState.SearchResults.Count]);

  limit := mSearchState.SearchResults.Count div mSearchState.SearchPageSize + 1;
  if mSearchState.SearchPageSize * (limit - 1) = mSearchState.SearchResults.Count then
    limit := limit - 1;

  s := '';
  for i := 1 to limit - 1 do
  begin
    if i <> page then
      s := s + Format('<a href="%d">%d-%d</a> ', [i, mSearchState.SearchPageSize * (i - 1) + 1, mSearchState.SearchPageSize * i])
    else
      s := s + Format('%d-%d ', [mSearchState.SearchPageSize * (i - 1) + 1, mSearchState.SearchPageSize * i]);
  end;

  if limit <> page then
    s := s + Format('<a href="%d">%d-%d</a> ',
      [limit, mSearchState.SearchPageSize * (limit - 1) + 1, mSearchState.SearchResults.Count])
  else
    s := s + Format('%d-%d ', [mSearchState.SearchPageSize * (limit - 1) + 1, mSearchState.SearchResults.Count]);

  limit := mSearchState.SearchPageSize * page - 1;
  if limit >= mSearchState.SearchResults.Count then
    limit := mSearchState.SearchResults.Count - 1;

  for i := mSearchState.SearchPageSize * (page - 1) to limit do
    AddLine(dSource, '<font size=-1>' + IntToStr(i + 1) + '.</font> ' + mSearchState.SearchResults[i]);

  AddLine(dSource, '<a name="endofsearchresults"><p>' + s + '<br><p>');

  //bwrSearch.CharSet := mTabsView.Browser.CharSet;

  StrReplace(dSource, '<*>', '<font color=' + Color2Hex(AppConfig.SelTextColor) + '>', true);
  StrReplace(dSource, '</*>', '</font>', true);

  bwrSearch.LoadFromString(dSource);

  mSearchState.LastSearchResultsPage := page;
  Screen.Cursor := crDefault;

  try
    bwrSearch.SetFocus;
  except
    // do nothing
  end;

end;

procedure TSearchFrame.OnVerseFound(bible: TBible; NumVersesFound, book, chapter, verse: integer; s: string; removeStrongs: boolean);
var
  i: integer;
begin
  if not Assigned(bible) then
    Exit;

  lblSearch.Caption := Format('[%d] %s', [NumVersesFound, bible.FullNames[book]]);

  if s <> '' then
  begin
    s := ParseHTML(s, '');

    if bible.Trait[bqmtStrongs] and (removeStrongs = true) then
      s := DeleteStrongNumbers(s);

    StrDeleteFirstNumber(s);

    // color search result!!!
    for i := 0 to mSearchState.SearchWords.Count - 1 do
      StrColorUp(s, mSearchState.SearchWords[i], '<*>', '</*>', chkCase.Checked);

    mSearchState.SearchResults.Add(
      Format('<a href="go %s %d %d %d 0">%s</a> <font face="%s">%s</font><br>',
      [bible.ShortPath, book, chapter, verse,
      bible.ShortPassageSignature(book, chapter, verse, verse),
      bible.fontName, s]));
  end;

  Application.ProcessMessages;
end;

procedure TSearchFrame.pmRefPopup(Sender: TObject);
begin
  miOpenNewView.Visible := true;
  mSearchCommand := Get_AHREF_VerseCommand(
    bwrSearch.DocumentSource,
    bwrSearch.SectionList.FindSourcePos(bwrSearch.RightMouseClickPos));
end;

procedure TSearchFrame.OnSearchComplete(bible: TBible);
begin
  BookSearchComplete(bible);
end;

procedure TSearchFrame.SearchListInit;
var
  i: integer;
begin
  if not Assigned(mCurrentBook) then
    Exit;

  if (not mCurrentBook.isBible) then
    with cbList do
    begin
      Items.BeginUpdate;
      Items.Clear;

      Items.AddObject(Lang.Say('SearchAllBooks'), TObject(0));

      for i := 1 to mCurrentBook.BookQty do
        Items.AddObject(mCurrentBook.FullNames[i], TObject(i));

      Items.EndUpdate;
      ItemIndex := 0;
      Exit;
    end;

  with cbList do
  begin
    Items.BeginUpdate;
    Items.Clear;

    Items.AddObject(Lang.Say('SearchWholeBible'), TObject(0));
    if mCurrentBook.Trait[bqmtOldCovenant] and mCurrentBook.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchOT'), TObject(-1)); // Old Testament
    if mCurrentBook.Trait[bqmtNewCovenant] and mCurrentBook.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchNT'), TObject(-2)); // New Testament
    if mCurrentBook.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchPT'), TObject(-3)); // Pentateuch
    if mCurrentBook.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchHP'), TObject(-4));
    // Historical and Poetical
    if mCurrentBook.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchPR'), TObject(-5)); // Prophets
    if mCurrentBook.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchGA'), TObject(-6)); // Gospels and Acts
    if mCurrentBook.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchER'), TObject(-7)); // Epistles and Revelation
    if mCurrentBook.Trait[bqmtApocrypha] then
      Items.AddObject(Lang.Say('SearchAP'), TObject(-8)); // Apocrypha

    for i := 1 to mCurrentBook.BookQty do
      Items.AddObject(mCurrentBook.FullNames[i], TObject(i));

    Items.EndUpdate;
    ItemIndex := 0;
  end;
end;

end.
