unit StrongFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, System.ImageList, Vcl.ImgList,
  Vcl.Menus, System.UITypes, BibleQuoteUtils, MainFrm, HTMLEmbedInterfaces,
  Htmlview, Clipbrd, Bible, BookFra, StringProcs, BibleQuoteConfig, IOUtils,
  ExceptionFrm, NativeDict, System.Threading, VirtualTrees, AppPaths, AppIni, StrUtils,
  StrongsConcordance, Math, Character, HtmlParser, DOMCore, Formatter,
  HtmlTags, BibleLinkParser, ScriptureProvider, DataServices;

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
    procedure bwrStrongHotSpotCovered(Sender: TObject; const SRC: string);
  private
    mWorkspace: IWorkspace;
    mMainView: TMainForm;

    mCurrentBook: TBible;
    FShown: boolean;
    mScriptureProvider: TScriptureProvider;
    mDataService: TDataService;

    FStrongsConcordance: TStrongsConcordance;

    procedure ShowStrong(stext: string);
    procedure CMShowingChanged(var Message: TMessage); MESSAGE CM_SHOWINGCHANGED;
    function IsStrongChar(Ch: Char): Boolean;
    procedure RedirectAlphanumericKey(var Key: Char);
    function ProcessCustomTags(htmlString: String): String;
    procedure ProcessElementCustomTags(const Element: TElement);
    function IsStandardTag(const Element: TElement): Boolean;
  public
    constructor Create(AOwner: TComponent; AMainView: TMainForm; AWorkspace: IWorkspace); reintroduce;

    procedure DisplayStrongs(number: Integer; isHebrew: Boolean);
    procedure SetCurrentBook(shortPath: string);
    procedure Translate();
    procedure ApplyConfig(appConfig, oldConfig: TAppConfig);
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

  mCurrentBook := TBible.Create();

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
    defaultModIx := mDataService.Modules.FindByName(AppConfig.DefaultStrongBible);

    if defaultModIx >= 0 then
    begin
      book := TBible.Create();
      bookPath := TPath.Combine(mDataService.Modules[defaultModIx].ShortPath, 'bibleqt.ini');
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
  modPath, cmd: string;
  status: HRESULT;
begin
  if Pos('s', SRC) = 1 then
  begin
    scode := Copy(SRC, 2, Length(SRC) - 1);
    if StrongVal(scode, num, isHebrew) then
    begin
      DisplayStrongs(num, isHebrew);
      Handled := True;
    end;

    Exit;
  end;

  modPath := mScriptureProvider.GetDefaultBibleSourcePath();
  if modPath <> '' then
  begin
    if (Pos(C__bqAutoBible, SRC) <> 0) then
    begin
      status := mScriptureProvider.PreProcessAutoCommand(SRC, modPath, cmd);
      if status <= -2 then
        Exit;
    end;

    mMainView.OpenOrCreateBookTab(cmd, '', mMainView.DefaultBookTabState);
  end;

  Handled := true;
end;

procedure TStrongFrame.bwrStrongHotSpotCovered(Sender: TObject; const SRC: string);
var
  cmd, concreteCmd: string;
  status: integer;
  modPath: string;
begin

  if (SRC = '') or (bwrStrong.LinkAttributes.Count < 3) then
  begin
    bwrStrong.Hint := '';
    Application.CancelHint();
    Exit;
  end;

  if Pos(bwrStrong.LinkAttributes[2], 'CLASS=bqResolvedLink') <= 0 then
    Exit;

  cmd := PeekToken(Pointer(src), ' ');
  if CompareText(cmd, 'go') <> 0 then
    Exit;

  if Length(cmd) <= 0 then
    Exit;

  try
    modPath := mScriptureProvider.GetDefaultBibleSourcePath();
    if modPath <> '' then
    begin
      if (Pos(C__bqAutoBible, SRC) <> 0) then
      begin
        status := mScriptureProvider.PreProcessAutoCommand(SRC, modPath, concreteCmd);
        if status <= -2 then
          Exit;
      end;

      bwrStrong.Hint := mScriptureProvider.GetLinkHint(SRC, bwrStrong.DefFontName, modPath);
    end;
  except
    // skip error
  end;
end;

procedure TStrongFrame.bwrStrongKeyPress(Sender: TObject; var Key: Char);
begin
  RedirectAlphanumericKey(Key);
end;

procedure TStrongFrame.bwrStrongMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  text: String;
  num: Integer;
  hebrew: Boolean;
begin
  text := Trim(bwrStrong.SelText);
  if StrongVal(text, num, hebrew) then
    DisplayStrongs(num, hebrew)
  else
    mMainView.OpenOrCreateDictionaryTab(text);
end;

constructor TStrongFrame.Create(AOwner: TComponent; AMainView: TMainForm; AWorkspace: IWorkspace);
begin
  inherited Create(AOwner);

  FShown := false;

  mMainView := AMainView;
  mWorkspace := AWorkspace;
  mDataService := AMainView.DataService;
  mScriptureProvider := TScriptureProvider.Create(AMainView);

  FStrongsConcordance := AMainView.StrongsConcordance;

  ApplyConfig(AppConfig, AppConfig);
end;

procedure TStrongFrame.ShowStrong(stext: string);
var
  hebrew: Boolean;
  num: Integer;
begin
  if StrongVal(stext, num, hebrew) then
    DisplayStrongs(num, hebrew);
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

procedure TStrongFrame.DisplayStrongs(number: Integer; isHebrew: Boolean);
var
  res, Copyright, Style: string;
  sword, letter: string;
  html: string;
begin
  sword := FormatStrong(number, isHebrew);

  try
    if (FStrongsConcordance.IsAvailable) then
    begin
      if (FStrongsConcordance.EnsureStrongLoaded) then
      begin
        res := FStrongsConcordance.StrongDict.Lookup(sword);
        letter := Copy(sword, 1, 1);
        StrReplace(res, '<h4>', '<h4>' + letter, false);

        Copyright := FStrongsConcordance.StrongDict.GetName();
        Style := FStrongsConcordance.StrongDict.Style;
      end;
    end;
  except
    on e: Exception do
    begin

      BqShowException(e);
    end;
  end;

  if res <> '' then
  begin
    res := ResolveLinks(res, True);
    AddLine(res, '<p><font size=-1>' + Copyright + '</font>');

    html := Format('<html><head>%s</head><body>%s</body></html>', [
      IfThen(Length(Style) > 0, Format('<style>%s</style>', [Style]), ''),
      res]);

    try
      html := ProcessCustomTags(html);
    Except
      // failed to process html
      // try to display it without processing
    end;

    bwrStrong.LoadFromString(html);

    edtStrong.Text := sword;
    edtStrong.SelectAll;

    SelectStrongWord(sword);
  end;

end;

function TStrongFrame.GetBookPath(): string;
begin
  Result := '';

  if Assigned(mCurrentBook) then
    Result := mCurrentBook.ShortPath;
end;

function TStrongFrame.ProcessCustomTags(htmlString: String): String;
var
  HtmlDoc: TDocument;
  Parser: THtmlParser;
  Formatter: TBaseFormatter;
begin
  Parser := THtmlParser.Create;
  try
    HtmlDoc := Parser.parseString(htmlString);
  finally
    Parser.Free
  end;

  ProcessElementCustomTags(HtmlDoc.documentElement);
  Formatter := THtmlFormatter.Create;
  try
    Result := Formatter.getText(HtmlDoc);
  finally
    Formatter.Free
  end;

  HtmlDoc.Free;
end;

procedure TStrongFrame.ProcessElementCustomTags(const Element: TElement);
var
  I: Integer;
  ChildNode: TNode;
  TagName: String;
  ClassAttr: TAttr;
begin
  // replace custom tags with 'span' tags
  // and add a class of the same name for these 'span' tags
  // e.g. <df> tag becomes <span class="df"> tag

  if Element.nodeType <> ELEMENT_NODE then
    Exit;

  if not (IsStandardTag(Element)) then
  begin
    TagName := Element.tagName;

    Element.nodeName := 'span';
    ClassAttr := Element.getAttributeNode('class');

    if not Assigned(ClassAttr) then
      Element.setAttribute('class', TagName)
    else
      ClassAttr.value := ClassAttr.value + ' ' + TagName;
  end;

  for I := 0 to Element.childNodes.length - 1 do
  begin
    ChildNode := Element.childNodes.item(I);
    if (ChildNode.nodeType = ELEMENT_NODE) then
      ProcessElementCustomTags(ChildNode as TElement);
  end;
end;

function TStrongFrame.IsStandardTag(const Element: TElement): Boolean;
var
  Tag: THtmlTag;
begin
  Tag := HtmlTagList.GetTagByName(Element.tagName);
  Result := Tag.Number <> UNKNOWN_TAG;
end;

procedure TStrongFrame.Translate();
begin
  Lang.TranslateControl(self, 'MainForm');
  Lang.TranslateControl(self, 'DockTabsForm');
end;

procedure TStrongFrame.ApplyConfig(appConfig, oldConfig: TAppConfig);
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
      if FShown then
        Exit;

      LoadStrongDictionaries();
    end;
  end;

end;

procedure TStrongFrame.LoadStrongDictionaries();
var
  Count: Integer;
begin
  if (FStrongsConcordance.IsAvailable) then
  begin
    if (FStrongsConcordance.EnsureStrongLoaded) then
      Count := FStrongsConcordance.GetTotalWords
    else
      Count := 0;

    vstStrong.BeginUpdate();
    try
      vstStrong.Clear;

      vstStrong.RootNodeCount := Count;
    finally
      vstStrong.EndUpdate();
      FShown := True;
    end;

  end;
end;

end.
