unit SearchFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, BibleQuoteUtils,
  HTMLEmbedInterfaces, Htmlview, Vcl.StdCtrls, Vcl.ExtCtrls, Bible,
  StringProcs, LinksParser, MainFrm, LibraryFra, LayoutConfig, IOUtils,
  System.ImageList, Vcl.ImgList, LinksParserIntf, HintTools, Vcl.Menus,
  Clipbrd, AppIni, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Sets, SourceReaderIntf;

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
    pmRef: TPopupMenu;
    miRefCopy: TMenuItem;
    miOpenNewView: TMenuItem;
    miRefPrint: TMenuItem;
    imgCollection: TImageCollection;
    vimgList: TVirtualImageList;
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
    procedure chkAllClick(Sender: TObject);
    procedure chkPartsClick(Sender: TObject);
    procedure chkPhraseClick(Sender: TObject);
  private
    mMainView: TMainForm;
    mWorkspace: IWorkspace;

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
    constructor Create(AOwner: TComponent; mainView: TMainForm; workspace: IWorkspace); reintroduce;
    destructor Destroy; override;

    procedure DisplaySearchResults(page: integer);
    procedure Translate();
    procedure ApplyConfig(appConfig, oldConfig: TAppConfig);
    procedure EventFrameKeyDown(var Key: Char);

    function GetBookPath(): string;
    property SearchState: TSearchTabState read mSearchState write mSearchState;
    procedure SetCurrentBook(shortPath: string);
    procedure OnVerseFound(bible: TBible; NumVersesFound, book, chapter, verse: integer; s: string; removeStrongs: boolean);
    procedure OnSearchComplete(bible: TBible);
  end;

implementation

{$R *.dfm}

constructor TSearchFrame.Create(AOwner: TComponent; mainView: TMainForm; workspace: IWorkspace);
begin
  inherited Create(AOwner);
  mMainView := mainView;
  mWorkspace := workspace;

  mSearchState := TSearchTabState.Create;

  mBookSelectForm := TForm.Create(self);
  mBookSelectForm.OnDeactivate := OnBookSelectFormDeactivate;

  mBookSelectView := TLibraryFrame.Create(nil, mMainView, mWorkspace);
  mBookSelectView.OnSelectModule := OnBookSelect;
  mBookSelectView.cmbBookType.Enabled := true;
  mBookSelectView.cmbBookType.ItemIndex := 0;
  mBookSelectView.Align := TAlign.alClient;
  mBookSelectView.Parent := mBookSelectForm;

  ApplyConfig(AppConfig, AppConfig);
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
  SetCurrentBook(modEntry.ShortPath);

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
  mBookSelectView.UpdateBookList();

  mBookSelectForm.Width := AppConfig.LibFormWidth;
  mBookSelectForm.Height := AppConfig.LibFormHeight;
  mBookSelectForm.Top := AppConfig.LibFormTop;
  mBookSelectForm.Left := AppConfig.LibFormLeft;

  mBookSelectForm.ShowModal();
end;

procedure TSearchFrame.btnFindClick(Sender: TObject);
var
  BookSet, S: TIntSet;
  SearchSource, SearchText, Wrd, Wrdnew, BooksQuery: string;
  SearchOptions: TSearchOptions;
  LinksCnt, I: integer;
  SectionIndex: Integer;
  SourceReader: ISourceReader;
begin
  if not Assigned(mCurrentBook) then
    Exit;

  mSearchState.SearchPageSize := StrToInt(cbQty.Items[cbQty.ItemIndex]);
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

    BookSet := TIntSet.Create;
    SourceReader := mCurrentBook.GetSourceReader();

    if (not mCurrentBook.isBible) then
    begin
      SectionIndex := Integer(cbList.Items.Objects[cbList.ItemIndex]);
      BookSet.IncludeSet(SourceReader.GetSectionBooks(SectionIndex));
    end
    else
    begin // FULL BIBLE SEARCH
      SearchSource := Trim(cbList.Text);
      LinksCnt := cbList.Items.Count - 1;
      if not mSearchState.SearchBooksDDAltered then
        if (cbList.ItemIndex < 0) then
          for I := 0 to LinksCnt do
            if CompareText(cbList.Items[I], SearchSource) = 0 then
            begin
              cbList.ItemIndex := I;
              break;
            end;

      if (cbList.ItemIndex < 0) or (mSearchState.SearchBooksDDAltered) then
      begin
        S := SourceReader.ParseLisks(SearchSource, BooksQuery);
        if (S.HasAny) then
          BookSet.IncludeSet(S);

        BooksQuery := Trim(BooksQuery);
        if (Length(BooksQuery) > 0) and (mSearchState.SearchBooksCache.IndexOf(BooksQuery) < 0) then
          mSearchState.SearchBooksCache.Add(BooksQuery);
      end
      else
      begin
        SectionIndex := Integer(cbList.Items.Objects[cbList.ItemIndex]);
        BookSet.IncludeSet(SourceReader.GetSectionBooks(SectionIndex));
      end;
    end;

    SearchText := Trim(cbSearch.Text);
    StrReplace(SearchText, '.', ' ', true);
    StrReplace(SearchText, ',', ' ', true);
    StrReplace(SearchText, ';', ' ', true);
    StrReplace(SearchText, '?', ' ', true);
    StrReplace(SearchText, '"', ' ', true);
    SearchText := Trim(SearchText);

    if SearchText <> '' then
    begin
      if cbSearch.Items.IndexOf(SearchText) < 0 then
        cbSearch.Items.Insert(0, SearchText);

      mSearchState.SearchResults.Clear;

      mSearchState.SearchWords.Clear;
      Wrd := cbSearch.Text;

      if not chkExactPhrase.Checked then
      begin
        while Wrd <> '' do
        begin
          Wrdnew := DeleteFirstWord(Wrd);

          mSearchState.SearchWords.Add(Wrdnew);
        end;
      end
      else
      begin
        Wrdnew := Trim(Wrd);
        mSearchState.SearchWords.Add(Wrdnew);
      end;

      SearchOptions := [];

      if not chkParts.Checked then
        Include(SearchOptions, soWordParts);

      if not chkAll.Checked then
        Include(SearchOptions, soContainAll);

      if not chkPhrase.Checked then
        Include(SearchOptions, soFreeOrder);

      if not chkCase.Checked then
        Include(SearchOptions, soIgnoreCase);

      if chkExactPhrase.Checked then
        Include(SearchOptions, soExactPhrase);

      if (SearchOptions >= [soExactPhrase, soWordParts]) then
        Exclude(SearchOptions, soWordParts);

      // TODO: fix search with strongs, currently false
      mCurrentBook.Search(SearchText, SearchOptions, BookSet, False, Self);
    end;
  finally
    Screen.Cursor := crDefault;
  end
end;

procedure TSearchFrame.BookSearchComplete(bible: TBible);
begin
  mSearchState.IsSearching := false;
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
  mSearchState.SearchPageSize := StrToInt(cbQty.Items[cbQty.ItemIndex]);
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

procedure TSearchFrame.chkAllClick(Sender: TObject);
begin
  if chkAll.Checked then
    chkExactPhrase.Checked := False;
end;

procedure TSearchFrame.chkExactPhraseClick(Sender: TObject);
begin
  if chkExactPhrase.Checked then
  begin
    chkAll.Checked := False;
    chkPhrase.Checked := False;
    chkParts.Checked := False;
  end;
end;

procedure TSearchFrame.chkPartsClick(Sender: TObject);
begin
  if chkParts.Checked then
    chkExactPhrase.Checked := False;
end;

procedure TSearchFrame.chkPhraseClick(Sender: TObject);
begin
  if chkPhrase.Checked then
    chkExactPhrase.Checked := False;
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

procedure TSearchFrame.ApplyConfig(appConfig, oldConfig: TAppConfig);
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
  begin
    Font.Name := appConfig.MainFormFontName;
    lblBook.Font.Name := appConfig.MainFormFontName;
  end;

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
  caption: string;
begin
  if (shortPath = '') then
  begin
    lblBook.Caption := Lang.SayDefault('SelectBook', 'Select book');
    mCurrentBook := nil;
    Exit;
  end;

  mCurrentBook := TBible.Create();

  mCurrentBook.SetInfoSource(ResolveFullPath(shortPath));
  SearchListInit;

  caption := Format('%s, %s', [mCurrentBook.Name, mCurrentBook.Info.BibleShortName]);
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

  dSource := Format('<b>"<font face="%s">%s</font>"</b> (%d) <p>', [mCurrentBook.Info.DesiredFontName, cbSearch.Text, mSearchState.SearchResults.Count]);

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

procedure TSearchFrame.EventFrameKeyDown(var Key: Char);
begin

end;

procedure TSearchFrame.OnVerseFound(bible: TBible; NumVersesFound, book, chapter, verse: integer; s: string; removeStrongs: boolean);
var
  i: integer;
begin
  if not Assigned(bible) then
    Exit;

  lblSearch.Caption := Format('[%d] %s', [NumVersesFound, bible.GetFullNames(book)]);

  if s <> '' then
  begin
    s := ParseHTML(s, '');

    if bible.Trait[bqmtStrongs] and (removeStrongs = true) then
      s := DeleteStrongNumbers(s);

    StrDeleteFirstNumber(s);

    // color search result!!!
    for i := 0 to mSearchState.SearchWords.Count - 1 do
      StrColorUp(s, mSearchState.SearchWords[i], '<*>', '</*>', chkCase.Checked, chkParts.Checked);

    mSearchState.SearchResults.Add(
      Format('<a href="go %s %d %d %d 0">%s</a> <font face="%s">%s</font><br>',
      [bible.ShortPath, book, chapter, verse,
      bible.ShortPassageSignature(book, chapter, verse, verse),
      bible.Info.DesiredFontName, s]));
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
begin
  if not Assigned(mCurrentBook) then
    Exit;

  with cbList do
  begin
    Items.BeginUpdate;
    Items.Clear;

    Items.AddStrings(mCurrentBook.GetSearchSections);

    Items.EndUpdate;
    ItemIndex := 0;
  end;
end;

end.
