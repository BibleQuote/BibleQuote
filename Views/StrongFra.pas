unit StrongFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, System.ImageList, Vcl.ImgList,
  Vcl.Menus, System.UITypes, BibleQuoteUtils, MainFrm, HTMLEmbedInterfaces,
  Htmlview, Clipbrd, Bible, BookFra, StringProcs, BibleQuoteConfig, IOUtils,
  ExceptionFrm, NativeDict, System.Threading, VirtualTrees, AppPaths, AppIni, StrUtils,
  StrongsConcordance, Math, Character;

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
    procedure bwrStrongKeyPress(Sender: TObject; var Key: Char);
  private
    mWorkspace: IWorkspace;
    mMainView: TMainForm;

    mCurrentBook: TBible;
    mLoaded: boolean;

    FStrongsConcordance: TStrongsConcordance;

    procedure ShowStrong(stext: string);
    procedure CMShowingChanged(var Message: TMessage); MESSAGE CM_SHOWINGCHANGED;
    function IsStrongChar(Ch: Char): Boolean;
    procedure RedirectAlphanumericKey(var Key: Char);
  public
    constructor Create(AOwner: TComponent; AMainView: TMainForm; AWorkspace: IWorkspace); reintroduce;

    procedure DisplayStrongs(number: String);
    procedure SetCurrentBook(shortPath: string);
    procedure Translate();
    procedure ApplyConfig(appConfig: TAppConfig);
    procedure EventFrameKeyDown(var Key: Char);
    function GetBookPath(): string;

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
  mCurrentBook.SetInfoSource(ResolveFullPath(iniPath));
end;

function TStrongFrame.GetSelectedStrong(): string;
var
  pn: PVirtualNode;
begin
  pn := vstStrong.GetFirstSelected();
  if not Assigned(pn) then
    Exit;

  Result := vstStrong.Text[pn, 0];
end;

procedure TStrongFrame.tbtnSearchClick(Sender: TObject);
var
  searchText, word: string;
  bookTypeIndex: integer;
  bookPath: string;
  defaultModIx: integer;
  book: TBible;
  pn: PVirtualNode;
  isHebrew: boolean;
  num: integer;
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
      bookPath := TPath.Combine(mMainView.mModules[defaultModIx].ShortPath, 'bibleqt.ini');
      book.SetInfoSource(ResolveFullPath(bookPath));
    end;
  end;

  if Assigned(book) then
  begin
    word := vstStrong.Text[pn, 0];
    word := Copy(word, 1, 100); // reduce text to search
    searchText := word;

    if book.StrongsPrefixed then
      bookTypeIndex := 0 // full book
    else
    begin
      if StartsText('H', word) then
        searchText := word + ' 0' + word.Substring(2); // search for both numbers: with 'H' and '0' prefixes

      if StartsText('G', word) then
        searchText := word + ' ' + word.Substring(2); // search for both numbers: with 'G' prefix and without it

      StrongVal(word, num, isHebrew);
      bookTypeIndex := IfThen(isHebrew, 1 {old testament}, 2 {new testament});
    end;

    mMainView.OpenOrCreateSearchTab(book.path, searchText, bookTypeIndex, [soFreeOrder, soIgnoreCase]);
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
  num: integer;
  isHebrew: boolean;
  scode: string;
begin
  if Pos('s', SRC) = 1 then
    DisplayStrongs(sCode);
end;

procedure TStrongFrame.bwrStrongKeyPress(Sender: TObject; var Key: Char);
begin
  RedirectAlphanumericKey(Key);
end;

procedure TStrongFrame.bwrStrongMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  num, code: integer;
begin
  Val(Trim(bwrStrong.SelText), num, code);

  if code = 0 then
    // TODO: check if strong number
    //DisplayStrongs(bwrStrong.SelText)
  else
    mMainView.OpenOrCreateDictionaryTab(Trim(bwrStrong.SelText));
end;

constructor TStrongFrame.Create(AOwner: TComponent; AMainView: TMainForm; AWorkspace: IWorkspace);
begin
  inherited Create(AOwner);

  mLoaded := false;

  mMainView := AMainView;
  mWorkspace := AWorkspace;

  FStrongsConcordance := AMainView.StrongsConcordance;

  ApplyConfig(AppConfig);
end;

procedure TStrongFrame.ShowStrong(stext: string);
begin
  // TODO: check if number is valid
  DisplayStrongs(stext);
end;

procedure TStrongFrame.edtStrongKeyPress(Sender: TObject; var Key: Char);
var
  SText: string;
  Ch: Char;
begin
  if Key = #13 then
  begin
    Key := #0;

    SText := Trim(edtStrong.Text);
    ShowStrong(SText);
    Exit;
  end;

  Ch := Char(Key);
  if ((Ch.IsSymbol or Ch.IsPunctuation or Ch.IsLetterOrDigit) and not (IsStrongChar(Ch))) then
    Key := #0;
end;

procedure TStrongFrame.EventFrameKeyDown(var Key: Char);
begin

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
  word := vstStrong.Text[Node, 0];

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

procedure TStrongFrame.RedirectAlphanumericKey(var Key: Char);
begin
  if (Key.IsLetterOrDigit) then
  begin
    PostMessage(edtStrong.Handle, WM_CHAR, WPARAM(Key), 0);
    edtStrong.SetFocus;
    Key := #0;
  end;

  // do not process further
end;

function TStrongFrame.IsStrongChar(Ch: Char): Boolean;
begin
  Result := Ch.IsDigit or Ch.ToUpper.IsInArray(['G', 'H']);
end;

procedure TStrongFrame.DisplayStrongs(number: String);
var
  res, Copyright: string;
  i: integer;
begin
  try
    FStrongsConcordance.EnsureStrongLoaded;

    res := FStrongsConcordance.StrongDict.Lookup(number);
    StrReplace(res, '<h4>', '<h4>', false);
    Copyright := FStrongsConcordance.StrongDict.GetName();
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

    edtStrong.Text := number;
    edtStrong.SelectAll;

    SelectStrongWord(number);
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
    CellText := FStrongsConcordance.StrongDict.GetWord(Node.Index);
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
  RedirectAlphanumericKey(Key);
  if (Key = #0) then
    Exit;

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
      if mLoaded then
        Exit;

      LoadStrongDictionaries();
    end;
  end;

end;

procedure TStrongFrame.LoadStrongDictionaries();
begin
  FStrongsConcordance.EnsureStrongLoaded;
  vstStrong.BeginUpdate();
  try
    vstStrong.Clear;
    vstStrong.RootNodeCount := FStrongsConcordance.GetTotalWords;
  finally
    vstStrong.EndUpdate();
    mLoaded := true;
  end;
end;

end.
