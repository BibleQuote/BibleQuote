unit StrongFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, System.ImageList, Vcl.ImgList,
  Vcl.Menus, System.UITypes, BibleQuoteUtils, MainFrm, HTMLEmbedInterfaces,
  Htmlview, Clipbrd, Bible, BookFra, StringProcs, BibleQuoteConfig, IOUtils,
  ExceptionFrm, Dict, System.Threading, VirtualTrees, AppPaths, AppIni;

type
  TStrongFrame = class(TFrame, IStrongView)
    edtStrong: TEdit;
    bwrStrong: THTMLViewer;
    pmRef: TPopupMenu;
    miRefCopy: TMenuItem;
    miRefPrint: TMenuItem;
    pnlToolbar: TPanel;
    tlbMain: TToolBar;
    pnlMainView: TPanel;
    splMain: TSplitter;
    pnlNav: TPanel;
    tbtnToggle: TToolButton;
    tbtnSeparator: TToolButton;
    tbtnSearch: TToolButton;
    ilImages: TImageList;
    vstStrong: TVirtualStringTree;
    procedure bwrStrongHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure bwrStrongMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edtStrongKeyPress(Sender: TObject; var Key: Char);
    procedure miRefCopyClick(Sender: TObject);
    procedure miRefPrintClick(Sender: TObject);
    procedure tbtnSearchClick(Sender: TObject);
    procedure tbtnToggleClick(Sender: TObject);
    procedure vstStrongGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstStrongKeyPress(Sender: TObject; var Key: Char);
    procedure vstStrongAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    mTabsView: ITabsView;
    mMainView: TMainForm;

    StrongHebrew, StrongGreek: TDict;

    mCurrentBook: TBible;
    mLoaded: boolean;
    mLoading: boolean;

    procedure ShowStrong(stext: string);
    procedure CMShowingChanged(var Message: TMessage); MESSAGE CM_SHOWINGCHANGED;
    function GetStrongWordByIndex(ix: Integer): string;
  public
    constructor Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView); reintroduce;

    procedure DisplayStrongs(num: integer; hebrew: Boolean);
    procedure SetCurrentBook(shortPath: string);
    procedure Translate();
    procedure ApplyConfig(appConfig: TAppConfig);
    function GetBookPath(): string;

    procedure EnsureStrongHebrewLoaded(reportError: boolean);
    procedure EnsureStrongGreekLoaded(reportError: boolean);
    procedure LoadStrongDictionaries();
    procedure SearchText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
    procedure DisplaySelectedItem();
    function GetSelectedStrong(): string;
    procedure SelectStrongWord(word: string);
  end;

implementation

{$R *.dfm}

procedure TStrongFrame.SetCurrentBook(shortPath: string);
var
  iniPath: string;
begin
  if (shortPath = '') then
    Exit;

  mCurrentBook := TBible.Create(mMainView);

  iniPath := TPath.Combine(shortPath, 'bibleqt.ini');
  mCurrentBook.inifile := MainFileExists(iniPath);
end;

function TStrongFrame.GetSelectedStrong(): string;
var
  pn: PVirtualNode;
begin
  pn := vstStrong.GetFirstSelected();
  if not Assigned(pn) then
    Exit;

  Result := GetStrongWordByIndex(pn.Index);
end;

procedure TStrongFrame.tbtnSearchClick(Sender: TObject);
var
  searchText, word: string;
  bookTypeIndex: integer;
  bookPath: string;
  defaultModIx: integer;
  book: TBible;
  pn: PVirtualNode;
begin
  pn := vstStrong.GetFirstSelected();
  if not Assigned(pn) then
    Exit;

  book := mCurrentBook;
  if not Assigned(book) then
  begin
    defaultModIx := mMainView.mModules.FindByName(AppConfig.DefaultStrongBible);

    if defaultModIx >= 0 then
    begin
      book := TBible.Create(mMainView);
      bookPath := TPath.Combine(mMainView.mModules[defaultModIx].mShortPath, 'bibleqt.ini');
      book.inifile := MainFileExists(bookPath);
    end;
  end;

  if Assigned(book) then
  begin
    word := GetStrongWordByIndex(pn.Index);

    if book.StrongsPrefixed then
      bookTypeIndex := 0 // full book
    else
    begin
      if Copy(word, 1, 1) = 'H' then
        searchText := '0' + Copy(word, 2, 100)
      else if Copy(word, 1, 1) = 'G' then
        searchText := Copy(word, 2, 100)
      else
        searchText := word;

      if Copy(searchText, 1, 1) = '0' then
        bookTypeIndex := 1 // old testament
      else
        bookTypeIndex := 2; // new testament
    end;

    mMainView.OpenOrCreateSearchTab(book.path, searchText, bookTypeIndex, true);
  end
  else
  begin
    MessageBox(
        self.Handle,
        Pointer(Lang.SayDefault('bqStrongBibleNotDefined', C_TagRenameError)),
        Pointer(Lang.SayDefault('bqError', 'Error')),
        MB_OK or MB_ICONERROR);
  end;
end;

procedure TStrongFrame.tbtnToggleClick(Sender: TObject);
var
  showNav: boolean;
begin
  showNav := not pnlNav.Visible;
  splMain.Visible := showNav;
  pnlNav.Visible := showNav;
end;

procedure TStrongFrame.bwrStrongHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  num, code: integer;
  scode: string;
begin
  if Pos('s', SRC) = 1 then
  begin
    scode := Copy(SRC, 2, Length(SRC) - 1);
    Val(scode, num, code);
    if code = 0 then
      DisplayStrongs(num, (Copy(scode, 1, 1) = '0'));
  end;
end;

procedure TStrongFrame.bwrStrongMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  num, code: integer;
begin
  Val(Trim(bwrStrong.SelText), num, code);

  if code = 0 then
    DisplayStrongs(num, Copy(Trim(bwrStrong.SelText), 1, 1) = '0')
  else
    mMainView.OpenOrCreateDictionaryTab(Trim(bwrStrong.SelText));
end;

constructor TStrongFrame.Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView);
begin
  inherited Create(AOwner);

  mLoaded := false;
  mLoading := false;

  mMainView := AMainView;
  mTabsView := ATabsView;

  StrongHebrew := TDict.Create;
  StrongGreek := TDict.Create;

  ApplyConfig(AppConfig);
end;

procedure TStrongFrame.EnsureStrongHebrewLoaded(reportError: boolean);
var
  loaded: boolean;
  strongDir: string;
begin
  strongDir := TLibraryDirectories.Strong;
  loaded := StrongHebrew.Initialize(TPath.Combine(strongDir, 'hebrew.idx'), TPath.Combine(strongDir, 'hebrew.htm'));

  if (not loaded) and (reportError) then
    ShowMessage('Error in ' + TPath.Combine(strongDir, 'hebrew.*'));
end;

procedure TStrongFrame.EnsureStrongGreekLoaded(reportError: boolean);
var
  loaded: boolean;
  strongDir: string;
begin
  strongDir := TLibraryDirectories.Strong;
  loaded := StrongGreek.Initialize(TPath.Combine(strongDir, 'greek.idx'), TPath.Combine(strongDir, 'greek.htm'));

  if (not loaded) and (reportError) then
    ShowMessage('Error in ' + TPath.Combine(strongDir, 'greek.*'));
end;

procedure TStrongFrame.ShowStrong(stext: string);
var
  hebrew: Boolean;
  num, code: Integer;
begin
  if Copy(stext, 1, 1) = '0' then
    hebrew := true
  else if Copy(stext, 1, 1) = 'H' then
  begin
    hebrew := true;
    stext := Copy(stext, 2, Length(stext) - 1);
  end
  else if Copy(stext, 1, 1) = 'G' then
  begin
    hebrew := false;
    stext := Copy(stext, 2, Length(stext) - 1);
  end
  else
    hebrew := false;

  try
    Val(Trim(stext), num, code);
  finally
  end;

  if code = 0 then
    DisplayStrongs(num, hebrew);
end;

procedure TStrongFrame.edtStrongKeyPress(Sender: TObject; var Key: Char);
var
  stext: string;
begin
  if Key = #13 then
  begin
    Key := #0;

    stext := Trim(edtStrong.Text);
    ShowStrong(stext);
  end;
end;

procedure TStrongFrame.miRefCopyClick(Sender: TObject);
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      if not (AppConfig.AddFontParams xor IsDown(VK_SHIFT)) then
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

procedure TStrongFrame.miRefPrintClick(Sender: TObject);
begin
  with mMainView.PrintDialog do
    if Execute then
      (pmRef.PopupComponent as THTMLViewer).Print(MinPage, MaxPage)
end;

procedure TStrongFrame.SearchText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  word, sText: string;
begin
  word := GetStrongWordByIndex(Node.Index);

  sText := string(data);
  if Length(sText) > 0 then
  begin
    if sText = word then
    begin
      Sender.Selected[Node] := true;
      Abort := true;
    end;
  end;
end;

procedure TStrongFrame.SelectStrongWord(word: string);
begin
  if (word <> '') then
    vstStrong.IterateSubtree(nil, SearchText, PChar(word));
end;

function TStrongFrame.GetStrongWordByIndex(ix: Integer): string;
var
  hebrew: Boolean;
  num: Integer;
  word: string;
begin
  if (ix < StrongHebrew.Words.Count) then
  begin
    word := StrongHebrew.Words[ix];
    hebrew := true;
  end
  else
  begin
    ix := ix - StrongHebrew.Words.Count;
    word := StrongGreek.Words[ix];
    hebrew := false;
  end;

  num := StrToInt(word);
  word := IntToStr(num);

  if hebrew then
    word := 'H' + word
  else
    word := 'G' + word;

  Result := word;
end;

procedure TStrongFrame.DisplayStrongs(num: integer; hebrew: Boolean);
var
  res, s, Copyright: string;
  i: integer;
begin
  s := IntToStr(num);
  for i := Length(s) to 4 do
    s := '0' + s;

  try
    if hebrew or (num = 0) then
    begin
      EnsureStrongHebrewLoaded(true);

      res := StrongHebrew.Lookup(s);
      StrReplace(res, '<h4>', '<h4>H', false);
      Copyright := StrongHebrew.Name;
    end
    else
    begin
      EnsureStrongGreekLoaded(true);

      res := StrongGreek.Lookup(s);
      StrReplace(res, '<h4>', '<h4>G', false);
      Copyright := StrongGreek.Name;
    end;
  except
    on e: Exception do
    begin

      BqShowException(e);
    end;
  end;

  if res <> '' then
  begin
    res := FormatStrongNumbers(res, false, false);

    AddLine(res, '<p><font size=-1>' + Copyright + '</font>');
    bwrStrong.LoadFromString(res);

    s := IntToStr(num);
    if hebrew then
      s := 'H' + s
    else
      s := 'G' + s;

    SelectStrongWord(s);
  end;

end;

function TStrongFrame.GetBookPath(): string;
begin
  Result := '';

  if Assigned(mCurrentBook) then
    Result := mCurrentBook.ShortPath;
end;

procedure TStrongFrame.Translate();
begin
  Lang.TranslateControl(self, 'MainForm');
  Lang.TranslateControl(self, 'DockTabsForm');
end;

procedure TStrongFrame.ApplyConfig(appConfig: TAppConfig);
var
  browserpos: integer;
begin
  with bwrStrong do
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
  end;

  if (appConfig.MainFormFontName <> Font.Name) then
    Font.Name := appConfig.MainFormFontName;

  if (appConfig.MainFormFontSize <> Font.Size) then
    Font.Size := appConfig.MainFormFontSize;
end;

procedure TStrongFrame.vstStrongAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  DisplaySelectedItem();
end;

procedure TStrongFrame.DisplaySelectedItem();
var
  pn: PVirtualNode;
begin
  pn := vstStrong.GetFirstSelected();
  if not Assigned(pn) then
    Exit;

  ShowStrong(vstStrong.Text[pn, 0]);
end;

procedure TStrongFrame.vstStrongGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  if not Assigned(Node) then
    Exit;

  try
    CellText := GetStrongWordByIndex(Node.Index);
  except
    on E: Exception do
    begin
      BqShowException(E)
    end
  end;
end;

procedure TStrongFrame.vstStrongKeyPress(Sender: TObject; var Key: Char);
var
  pn: PVirtualNode;
begin
  pn := vstStrong.GetFirstSelected();
  if not Assigned(pn) then
    Exit;

  if (Key = #13) then
    ShowStrong(vstStrong.Text[pn, 0]);
end;

procedure TStrongFrame.CMShowingChanged(var Message: TMessage);
begin
  inherited;

  // load dictionaries on the first show
  if not (csDesigning in ComponentState) then begin
    if Showing then begin
      if mLoaded or mLoading then
        Exit;

      LoadStrongDictionaries();
    end;
  end;

end;

procedure TStrongFrame.LoadStrongDictionaries();
var
  proc: ITask;
begin
  mLoading := true;
  proc := TTask.Create(
    procedure
    begin
      EnsureStrongHebrewLoaded(false);
      EnsureStrongGreekLoaded(false);

      TThread.Queue(nil, procedure
      begin
        try
          vstStrong.BeginUpdate();
          vstStrong.Clear;
          vstStrong.RootNodeCount := StrongHebrew.Words.Count + StrongGreek.Words.Count;
        finally
          vstStrong.EndUpdate();
        end;
      end);

      mLoading := false;
      mLoaded := true;
    end);
  proc.Start;
end;

end.
