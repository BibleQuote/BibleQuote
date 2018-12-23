unit BookFra;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Contnrs, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ToolWin, HTMLEmbedInterfaces, Htmlview, Vcl.Tabs, Vcl.DockTabSet, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, MainFrm, TabData, HintTools,
  WinApi.ShellApi, StrUtils, BibleQuoteUtils, CommandProcessor, LinksParserIntf,
  SevenZipHelper, StringProcs, HTMLUn2, ExceptionFrm, ChromeTabs, Clipbrd,
  Bible, Math, IOUtils, BibleQuoteConfig, IOProcs, BibleLinkParser, PlainUtils,
  System.Types, LayoutConfig, LibraryFra, VirtualTrees, UITools, PopupFrm,
  Vcl.Menus, SearchFra, TagsDb, InputFrm, AppIni, JclNotify, NotifyMessages;

type
  TBookFrame = class(TFrame, IBookView)
    pnlMainView: TPanel;
    bwrHtml: THTMLViewer;
    pnlViewPageToolbar: TPanel;
    tlbViewPage: TToolBar;
    tbtnBack: TToolButton;
    tbtnSep02: TToolButton;
    tbtnPrevChapter: TToolButton;
    tbtnNextChapter: TToolButton;
    tbtnSep03: TToolButton;
    tbtnCopy: TToolButton;
    tbtnStrongNumbers: TToolButton;
    tbtnMemos: TToolButton;
    tbtnSep04: TToolButton;
    tbtnQuickSearch: TToolButton;
    tbtnSep05: TToolButton;
    tedtReference: TEdit;
    tbtnReference: TToolButton;
    tbtnReferenceInfo: TToolButton;
    tlbQuickSearch: TToolBar;
    tbtnQuickSearchPrev: TToolButton;
    tedtQuickSearch: TEdit;
    tbtnQuickSearchNext: TToolButton;
    tbtnSep08: TToolButton;
    tbtnMatchCase: TToolButton;
    tbtnMatchWholeWord: TToolButton;
    pnlPaint: TPanel;
    dtsBible: TDockTabSet;
    ilImages: TImageList;
    pmBrowser: TPopupMenu;
    miSearchWord: TMenuItem;
    miSearchWindow: TMenuItem;
    miCompare: TMenuItem;
    N3: TMenuItem;
    miCopySelection: TMenuItem;
    miCopyPassage: TMenuItem;
    miCopyVerse: TMenuItem;
    N2: TMenuItem;
    miAddBookmark: TMenuItem;
    miAddBookmarkTagged: TMenuItem;
    miAddMemo: TMenuItem;
    N4: TMenuItem;
    miMemosToggle: TMenuItem;
    pmMemo: TPopupMenu;
    miMemoCopy: TMenuItem;
    miMemoCut: TMenuItem;
    miMemoPaste: TMenuItem;
    tbtnSatellite: TToolButton;
    pnlNav: TPanel;
    splMain: TSplitter;
    vdtModules: TVirtualStringTree;
    tbtnSep01: TToolButton;
    tbtnToggle: TToolButton;
    tbtnForward: TToolButton;
    procedure miSearchWordClick(Sender: TObject);
    procedure miSearchWindowClick(Sender: TObject);
    procedure miCompareClick(Sender: TObject);
    procedure miCopySelectionClick(Sender: TObject);
    procedure miCopyPassageClick(Sender: TObject);
    procedure miCopyVerseClick(Sender: TObject);
    procedure miAddBookmarkClick(Sender: TObject);
    procedure miAddMemoClick(Sender: TObject);
    procedure miMemosToggleClick(Sender: TObject);
    procedure miMemoCopyClick(Sender: TObject);
    procedure miMemoCutClick(Sender: TObject);
    procedure miMemoPasteClick(Sender: TObject);
    procedure bwrHtmlHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure bwrHtmlHotSpotCovered(Sender: TObject; const SRC: string);
    procedure bwrHtmlImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
    procedure bwrHtmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrHtmlKeyPress(Sender: TObject; var Key: Char);
    procedure bwrHtmlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bwrHtmlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bwrHtmlMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure dtsBibleChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure dtsBibleClick(Sender: TObject);
    procedure dtsBibleDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dtsBibleDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure dtsBibleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dtsBibleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure dtsBibleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tbtnQuickSearchNextClick(Sender: TObject);
    procedure tbtnQuickSearchPrevClick(Sender: TObject);
    procedure tedtQuickSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbtnBackClick(Sender: TObject);
    procedure tbtnCopyClick(Sender: TObject);
    procedure tbtnForwardClick(Sender: TObject);
    procedure tbtnMemosClick(Sender: TObject);
    procedure tbtnNextChapterClick(Sender: TObject);
    procedure tbtnPrevChapterClick(Sender: TObject);
    procedure tbtnQuickSearchClick(Sender: TObject);
    procedure tbtnReferenceClick(Sender: TObject);
    procedure tbtnReferenceInfoClick(Sender: TObject);
    procedure tbtnStrongNumbersClick(Sender: TObject);
    procedure tedtReferenceDblClick(Sender: TObject);
    procedure tedtReferenceEnter(Sender: TObject);
    procedure tedtReferenceKeyPress(Sender: TObject; var Key: Char);
    procedure pmBrowserPopup(Sender: TObject);
    procedure tbtnSatelliteClick(Sender: TObject);

    procedure CopyBrowserSelectionToClipboard();
    procedure ToggleStrongNumbers();
    procedure BrowserHotSpotCovered(viewer: THTMLViewer; src: string);
    procedure FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    procedure ToggleQuickSearchPanel(const enable: Boolean);

    function ProcessCommand(bookTabInfo: TBookTabInfo; command: string; hlVerses: TbqHLVerseOption; disableHistory: boolean = false): Boolean;
    procedure SafeProcessCommand(bookTabInfo: TBookTabInfo; wsLocation: string; hlOption: TbqHLVerseOption);
    function PreProcessAutoCommand(bookTabInfo: TBookTabInfo; const cmd: string; const prefModule: string; out ConcreteCmd: string): HRESULT;
    function GoAddress(bookTabInfo: TBookTabInfo; var book, chapter, fromverse, toverse: integer; var hlVerses: TbqHLVerseOption): TNavigateResult;

    procedure HistoryAdd(s: string);
    procedure HistoryClear();
    procedure UpdateHistory();
    procedure HistoryItemClick(Sender: TObject);
    function GetHistoryItemIndex(historyItem: TMenuItem): integer;
    function GetCurrentHistoryItem(): TMenuItem;
    function GetCurrentHistoryIndex(): integer;
    procedure CheckHistoryItem(itemIndex: integer);
    procedure NavigateToSearch(searchText: string; bookTypeIndex: integer = -1);

    procedure HistoryPopup(Sender: TObject);

    function GetModuleText(
      cmd: string;
      refBook: TBible;
      out fontName: string;
      out bl: TBibleLink;
      out txt: string;
      out passageSignature: string;
      options: TgmtOptions = [];
      maxWords: integer = 0): integer;

    function GetRefBible(ix: integer): TModuleEntry;
    function RefBiblesCount: integer;
    procedure RealignToolBars(AParent: TWinControl);

    procedure SelectSatelliteModule();
    procedure tbtnSatelliteMouseEnter(Sender: TObject);
    procedure vdtModulesAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtModulesFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtModulesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vdtModulesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vdtModulesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure tbtnToggleClick(Sender: TObject);
  private
    { Private declarations }
    mMainView: TMainForm;
    mTabsView: ITabsView;
    mSatelliteForm: TForm;
    mSatelliteLibraryView: TLibraryFrame;
    mHistoryOn: boolean;

    mBrowserSearchPosition: Longint;
    mUpdateOnTreeNodeSelect: boolean;
    pmHistory: PopupFrm.TPopupMenu;
    mNotifier: IJclNotifier;

    procedure SetMemosVisible(showMemos: Boolean);

    procedure SearchForward();
    procedure SearchBackward();
    procedure SelectSatelliteBibleByName(const bibleName: string);

    procedure OnSelectSatelliteModule(Sender: TObject; modEntry: TModuleEntry);
    procedure OnSatelliteFormDeactivate(Sender: TObject);

    function OpenChapter: Boolean;
    function IsPsalms(bible: TBible; bookIndex: integer): Boolean;
    procedure SelectModuleTreeNode(bible: TBible);
    function GetChildNodeByIndex(parentNode: PVirtualNode; index: Integer): PVirtualNode;
    procedure UpdateModuleTreeFont(book: TBible);
    procedure AddBookmarkTagged(tagName: string);
    procedure AddThemedBookmarkClick(Sender: TObject);
    procedure NotifyFontChanged(delta: integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; mainView: TMainForm; tabsView: ITabsView); reintroduce;

    property HistoryOn: boolean read mHistoryOn write mHistoryOn;

    procedure AdjustBibleTabs(moduleName: string = '');
    procedure LoadSecondBookByName(const name: string);
    procedure LoadBibleToXref(cmd: string; const id: string);
    function GetAutoTxt(btinfo: TBookTabInfo; const cmd: string; maxWords: integer; out fnt: string; out passageSignature: string): string;
    procedure GoRandomPlace;

    function GetBookTabInfo: TBookTabInfo;
    property BookTabInfo: TBookTabInfo read GetBookTabInfo;
    procedure Translate();
    procedure ApplyConfig(appConfig: TAppConfig);
    procedure UpdateModuleTreeSelection(book: TBible);
    procedure UpdateModuleTree(book: TBible);
    function GetCurrentBookNode(): PVirtualNode;
  end;

implementation

{$R *.dfm}
uses DockTabsFrm;

function TBookFrame.GetBookTabInfo(): TBookTabInfo;
var
  tabInfo: IViewTabInfo;
begin
  tabInfo := mTabsView.GetActiveTabInfo();
  if not Assigned(tabInfo) then
  begin
    Result := nil;
    Exit;
  end;

  if (tabInfo.GetViewType = vttBook) then
    Result := TBookTabInfo(tabInfo)
  else
    Result := nil;
end;

procedure TBookFrame.Translate();
begin
  Lang.TranslateControl(self, 'DockTabsForm');
  mSatelliteLibraryView.Translate();
  mSatelliteForm.Caption := Lang.SayDefault('SelectParaBible', 'Select secondary bible');
end;

procedure TBookFrame.ApplyConfig(appConfig: TAppConfig);
var
  browserpos: integer;
begin
  with bwrHtml do
  begin
    browserpos := Position and $FFFF0000;
    DefFontName := AppConfig.DefFontName;
    DefFontSize := AppConfig.DefFontSize;
    DefFontColor := AppConfig.DefFontColor;
    DefBackGround := AppConfig.BackgroundColor;
    DefHotSpotColor := AppConfig.HotSpotColor;

    if AppConfig.HrefUnderline then
      htOptions := htOptions - [htNoLinkUnderline]
    else
      htOptions := htOptions + [htNoLinkUnderline];

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

  if Assigned(BookTabInfo) and Assigned(BookTabInfo.Bible) then
    UpdateModuleTreeFont(BookTabInfo.Bible);
end;

function TBookFrame.IsPsalms(bible: TBible; bookIndex: integer): Boolean;
var
  chaptersCount: integer;
begin
  try
    chaptersCount := bible.ChapterQtys[bookIndex];
    Result := (chaptersCount = C_TotalPsalms) or (chaptersCount = C_TotalPsalms + 1);
  except
    Result := False;
  end;
end;

function TBookFrame.OpenChapter: Boolean;
var
  data: PBookNodeData;
  node: PVirtualNode;
  bookIndex: integer;
  chapterIndex: integer;
  command: string;
  bible: TBible;
begin
  Result := false;
  node := vdtModules.GetFirstSelected();
  if Assigned(node) then
  begin
    data := vdtModules.GetNodeData(node);

    if (data.NodeType = btBook) then
    begin
      bookIndex := node.Index + 1;
      chapterIndex := 1;
    end
    else
    begin
      bookIndex := node.Parent.Index + 1;
      chapterIndex := node.Index + 1;
    end;

    bible := BookTabInfo.Bible;
    command := Format('go %s %d %d', [bible.ShortPath, bookIndex, chapterIndex]);
    Result := ProcessCommand(BookTabInfo, command, hlDefault);
  end;
end;

procedure TBookFrame.vdtModulesAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if (mUpdateOnTreeNodeSelect) then
    OpenChapter();
end;

procedure TBookFrame.vdtModulesFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PBookNodeData;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TBookFrame.vdtModulesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PBookNodeData;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data.Caption;
end;

procedure TBookFrame.vdtModulesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var
  Level: Integer;
  bible: TBible;
begin
  Level := Sender.GetNodeLevel(Node);
  if Assigned(BookTabInfo) then
  begin
    bible := BookTabInfo.Bible;
    ChildCount := IfThen(Level = 0, bible.ChapterQtys[Node.Index + 1], 0);
  end
  else
  begin
    ChildCount := 0;
  end;
end;

procedure TBookFrame.vdtModulesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PBookNodeData;
  Level: Integer;
  bookIndex, chapterIndex: integer;
  chapterString: string;
  bible: TBible;
begin
  with Sender do
  begin
    Level := GetNodeLevel(Node);
    Data := GetNodeData(Node);

    if Level < 1 then
      Include(InitialStates, ivsHasChildren);

    if not Assigned(BookTabInfo) then
    begin
      if (Level = 0) then
        vdtModules.RootNodeCount := 0
      else
        ParentNode.ChildCount := 0;
      Exit;
    end;

    bible := BookTabInfo.Bible;

    if (Level = 0) then
    begin
      Data.Caption := bible.FullNames[Node.Index + 1];
      Data.NodeType := btBook;
    end
    else
    begin
      chapterIndex := Integer(Node.Index) + IfThen(bible.Trait[bqmtZeroChapter], 0, 1);

      if (chapterIndex = 0) and (Length(Trim(bible.ChapterZeroString)) > 0) then
      begin
        chapterString := Trim(bible.ChapterZeroString);
      end
      else
      begin
        bookIndex := node.Parent.Index + 1;
        if (IsPsalms(bible, bookIndex)) then
          chapterString := Trim(bible.ChapterStringPs)
        else
          chapterString := Trim(bible.ChapterString);

        if (Length(chapterString) > 0) then
          chapterString := chapterString + ' ';

        chapterString := chapterString + IntToStr(chapterIndex);
      end;

      Data.Caption := chapterString;
      Data.NodeType := btChapter;
    end;
  end;
end;

procedure TBookFrame.bwrHtmlHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  first, verse: integer;
  scode, unicodeSRC: string;
  cb: THTMLViewer;
  ws: string;
  iscontrolDown: Boolean;
  bookTabState: TBookTabInfoState;
  num, code: integer;
begin
  unicodeSRC := SRC;
  iscontrolDown := IsDown(VK_CONTROL);

  if GetCommandType(SRC) = bqctGoCommand then
  // verse hyperlink
  begin
    if iscontrolDown then
    begin
      if bwrHtml.LinkAttributes.Count > 1 then
      begin
        ws := bwrHtml.LinkAttributes[1];
        first := Pos('bqResLnk', ws);
        if first > 0 then
        begin
          ws := Copy(ws, first + 8, $FF);
          LoadBibleToXref(unicodeSRC, ws);
          Handled := true;
          Exit;
        end
      end
    end;
    if IsDown(VK_MENU) then
    begin
      if not Assigned(BookTabInfo) then
      begin
        bookTabState := mMainView.DefaultBookTabState;
      end
      else
        bookTabState := BookTabInfo.State;

      mMainView.NewBookTab(unicodeSRC, '', bookTabState, '', true);

    end
    else
    begin
      ProcessCommand(BookTabInfo, unicodeSRC, hlDefault);
    end;
    Handled := true;
  end

  else if Pos('http://', unicodeSRC) = 1 then { // WWW }
  begin
    if (Application.MessageBox(
      PChar(Format(Lang.Say('GoingOnline'), [unicodeSRC])),
      'WWW',
      MB_OKCancel Or MB_DEFBUTTON1) = ID_OK) then
    begin
      ShellExecute(Application.Handle, nil, PChar(unicodeSRC), nil, nil, SW_NORMAL);
    end;

    Handled := true;
  end
  else if Pos('mailto:', unicodeSRC) = 1 then
  begin
    ShellExecute(Application.Handle, nil, PChar(unicodeSRC), nil, nil, SW_NORMAL);
    Handled := true;
  end
  else if Pos('verse ', unicodeSRC) = 1 then
  begin
    verse := StrToInt(Copy(unicodeSRC, 7, Length(unicodeSRC) - 6));

    if Assigned(BookTabInfo) then
    begin
    with BookTabInfo.Bible do
      HistoryAdd(Format('go %s %d %d %d %d $$$%s %s',
        [ShortPath, CurBook, CurChapter, verse, 0,
        // history comment
        FullPassageSignature(CurBook, CurChapter, verse, 0), ShortName]));
    end;

    mMainView.OpenOrCreateTSKTab(BookTabInfo, verse);
  end
  else if Pos('s', unicodeSRC) = 1 then
  begin
    scode := Copy(unicodeSRC, 2, Length(unicodeSRC) - 1);
    Val(scode, num, code);
    if (code = 0) then
      mMainView.OpenOrCreateStrongTab(BookTabInfo, num);
  end
  else
  begin
    cb := Sender as THTMLViewer;
    if Pos('BQNote', cb.LinkAttributes.Text) > 0 then
    begin
      Handled := true;
      try
        if EndsStr('??', cb.Base) then
        begin
          unicodeSRC := ReplaceStr(cb.HtmlExpandFilename(SRC), '??\', '??');
        end
        else
          unicodeSRC := cb.HtmlExpandFilename(SRC);

      except
        g_ExceptionContext.Add('src:' + SRC);
        g_ExceptionContext.Add('base:' + cb.Base);
        g_ExceptionContext.Add('unicodeSrc:' + unicodeSRC);
        g_ExceptionContext.Add('cFile:' + cb.CurrentFile);
        raise;
      end;
    end;
  end // else
  // in all other cases, the link is processed according to HTML rules :-)
end;

procedure TBookFrame.BrowserHotSpotCovered(viewer: THTMLViewer; src: string);
var
  unicodeSRC, ConcreteCmd: string;
  wstr, ws2, fontName, replaceModPath: string;
  bl: TBibleLink;
  modIx, status: integer;
begin
  if (SRC = '') or (viewer.LinkAttributes.Count < 3) then
  begin
    viewer.Hint := '';
    bwrHtml.Hint := '';
    Application.CancelHint();
    Exit
  end;
  if Pos(viewer.LinkAttributes[2], 'CLASS=bqResolvedLink') <= 0 then
    Exit;

  unicodeSRC := SRC;
  wstr := PeekToken(Pointer(unicodeSRC), ' ');
  if SysUtils.CompareText(wstr, 'go') <> 0 then
    Exit;

  if Length(wstr) <= 0 then
    Exit;

  if not Assigned(BookTabInfo) then
    Exit;

  if (viewer <> bwrHtml) and (BookTabInfo.Bible.isBible) then
    replaceModPath := BookTabInfo.Bible.ShortPath
  else
  begin
    modIx := mMainView.mModules.FindByName(BookTabInfo.SatelliteName);
    if modIx < 0 then
      modIx := mMainView.mModules.FindByName(AppConfig.DefaultBible);

    if modIx >= 0 then
      replaceModPath := mMainView.mModules[modIx].mShortPath;
  end;

  if (replaceModPath = '') then
  begin
    wstr := Lang.SayDefault('SelectDefaultBible', 'Please select default translation in File -> Settings -> Favorite modules');
  end
  else
  begin
    status := PreProcessAutoCommand(BookTabInfo, unicodeSRC, replaceModPath, ConcreteCmd);
    if status > -2 then
      status := GetModuleText(ConcreteCmd, BookTabInfo.ReferenceBible, fontName, bl, ws2, wstr, [gmtBulletDelimited, gmtLookupRefBibles, gmtEffectiveAddress]);

    if status < 0 then
      wstr := ConcreteCmd + #13#10 + Lang.SayDefault('HintNotFound', '--not found--')
    else
    begin
      wstr := wstr + ' (' + BookTabInfo.ReferenceBible.ShortName + ')'#13#10;
      if ws2 <> '' then
        wstr := wstr + ws2
      else
        wstr := wstr + Lang.SayDefault('HintNotFound', '--not found--');
    end;
  end;
  viewer.Hint := wstr;
end;

procedure TBookFrame.bwrHtmlHotSpotCovered(Sender: TObject; const SRC: string);
begin
  BrowserHotSpotCovered(Sender as THTMLViewer, SRC);
end;

procedure TBookFrame.bwrHtmlImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
var
  archive: string;
  ix, sz: integer;
{$J+}
const
  ms: TMemoryStream = nil;
{$J-}
begin
  try
    if not Assigned(BookTabInfo) then
      Exit;
    archive := BookTabInfo.Bible.inifile;
    if (Length(archive) <= 0) or (archive[1] <> '?') then
      Exit;
    getSevenZ().SZFileName := Copy(GetArchiveFromSpecial(archive), 2, $FFFFFF);
    ix := getSevenZ().GetIndexByFilename(SRC, @sz);
    if ix = 0 then
      Exit;
    if not Assigned(ms) then
      ms := TMemoryStream.Create;
    ms.Size := sz;
    getSevenZ().ExtracttoMem(ix, ms.Memory, ms.Size);
    if getSevenZ().ErrCode = 0 then
      Stream := ms;
  except
  end;
end;

procedure TBookFrame.bwrHtmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  mMainView.BrowserPosition := bwrHtml.Position;

  if (Shift = [ssCtrl]) then
  begin
    if (Key = VK_INSERT) then
    begin
      Key := 0;
      CopyBrowserSelectionToClipboard();
      Exit;
    end;
    if Key = $41 then
    begin
      bwrHtml.SelectAll();
      UpdateWindow(bwrHtml.Handle);
      Exit
    end;
  end;
  if Key = $43 { THE C KEY } then
  begin
    bwrHtml.RightMouseClickPos := bwrHtml.LeftMouseClickPos;
    pmBrowserPopup(self);

    if miCopyPassage.Visible then
    begin
      miCopyPassageClick(self);
    end
    else if miCopyVerse.Visible then
    begin
      miCopyVerseClick(self);
    end;

  end;
end;

procedure TBookFrame.bwrHtmlKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '+' then
  begin
    Key := #0;
    NotifyFontChanged(1);
  end
  else if Key = '-' then
  begin
    Key := #0;
    NotifyFontChanged(-1);
  end;
end;

procedure TBookFrame.NotifyFontChanged(delta: integer);
var
  defFontSz: integer;
begin
  defFontSz := AppConfig.DefFontSize + delta;
  if (delta = 0) or (defFontSz > 48) or (defFontSz < 6) then
    Exit;

  AppConfig.DefFontSize := defFontSz;
  mNotifier.Notify(TAppConfigChangedMessage.Create());
end;

procedure TBookFrame.bwrHtmlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  verse: integer;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  if BookTabInfo.LocationType = vtlFile then
    Exit;

  if (Key = VK_NEXT) and (bwrHtml.Position = mMainView.BrowserPosition) then
  begin
    mMainView.GoNextChapter;
    Exit;
  end;

  if (Key = VK_PRIOR) and (bwrHtml.Position = mMainView.BrowserPosition) then
  begin
    mMainView.GoPrevChapter;
    if (BookTabInfo.Bible.CurBook <> 1) or (BookTabInfo.Bible.CurChapter <> 1) then
      bwrHtml.PositionTo('endofchapterNMFHJAHSTDGF123');
    Exit;
  end;

  if Key = VK_HOME then
  begin
    bwrHtml.Position := 0;
    Exit;
  end;

  if Key = VK_END then
  begin
    bwrHtml.PositionTo('endofchapterNMFHJAHSTDGF123');
  end;

  if Key = $4C { THE L KEY } then
  begin
    mMainView.miRecognizeBibleLinks.Click();
    Exit
  end;

  if ssAlt in Shift then
  begin
    if Key = VK_LEFT then
    begin
      tbtnBack.Click;
      Exit;
    end;
    if Key = VK_RIGHT then
    begin
      tbtnForward.Click;
      Exit
    end;
  end;

  if Key = VK_SPACE then
  begin
    verse := Get_ANAME_VerseNumber(bwrHtml.DocumentSource, mMainView.CurFromVerse, bwrHtml.FindSourcePos(bwrHtml.CaretPos, true));

    mMainView.OpenOrCreateTSKTab(BookTabInfo, verse);
  end;
end;

procedure TBookFrame.bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  num, code: integer;
  text: string;
begin
  if not mMainView.mDictionariesFullyInitialized then
  begin
    mMainView.LoadDictionaries(true);
  end;

  text := Trim(bwrHtml.SelText);
  Val(text, num, code);
  if code = 0 then
    mMainView.OpenOrCreateStrongTab(BookTabInfo, num)
  else
  begin
    if (text.Length > 0) then
      mMainView.OpenOrCreateDictionaryTab(text);
  end;
end;

procedure TBookFrame.bwrHtmlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  section: TSectionBase;
  topPos, Index: integer;
  classname: string;
begin
  section := bwrHtml.SectionList.FindSectionAtPosition(bwrHtml.LeftMouseClickPos, topPos, index);

  if section = nil then
    Exit;

  classname := section.classname;
  OutputDebugString(Pointer(classname));
end;

procedure TBookFrame.bwrHtmlMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  fontSize: integer;
  delta, tm: integer;
{$J+}
const
  lastWheelTime: integer = 0;
{$J-}
begin
  tm := GetTickCount();
  if abs(tm - lastWheelTime) < 1000 then
  begin
    Handled := true;
    Exit;
  end;
  if not(ssCtrl in Shift) then
  begin
    if WheelDelta < 0 then
    begin
      if (bwrHtml.VScrollBarPosition >= (bwrHtml.VScrollBarRange)) and
        (bwrHtml.VScrollBarPosition >= mMainView.msbPosition) then
      begin
        if mMainView.mScrollAcc > 2 then
        begin
          lastWheelTime := tm;
          mTabsView.MakeActive();
          mMainView.GoNextChapter();
          Handled := true;

        end
        else
          inc(mMainView.mScrollAcc);
      end
      else
        mMainView.mScrollAcc := 0;
    end
    else if WheelDelta > 0 then
    begin
      if (bwrHtml.VScrollBarPosition <= 0) and
        (bwrHtml.VScrollBarPosition <= mMainView.msbPosition) then
      begin
        if mMainView.mScrollAcc > 2 then
        begin
          lastWheelTime := tm;
          mTabsView.MakeActive();
          mMainView.GoPrevChapter();
          bwrHtml.PositionTo('endofchapterNMFHJAHSTDGF123');
          Handled := true;
        end
        else
          inc(mMainView.mScrollAcc);

      end;

    end;
    Exit;
  end;
  Handled := true;
  fontSize := bwrHtml.DefFontSize;
  delta := round(fontSize / 10);

  if delta = 0 then
    delta := 1;

  if WheelDelta < 0 then
    delta := -delta;

  NotifyFontChanged(delta);
  //mMainView.FontChanged(delta);
end;

constructor TBookFrame.Create(AOwner: TComponent; mainView: TMainForm; tabsView: ITabsView);
begin
  inherited Create(AOwner);
  mMainView := mainView;
  mTabsView := tabsView;

  mNotifier := mainView.mNotifier;
  mSatelliteForm := TForm.Create(self);
  mSatelliteForm.OnDeactivate := OnSatelliteFormDeactivate;

  mSatelliteLibraryView := TLibraryFrame.Create(nil);
  mSatelliteLibraryView.OnSelectModule := OnSelectSatelliteModule;
  mSatelliteLibraryView.cmbBookType.Enabled := false;
  mSatelliteLibraryView.cmbBookType.ItemIndex := 1;
  mSatelliteLibraryView.Align := TAlign.alClient;
  mSatelliteLibraryView.Parent := mSatelliteForm;

  tbtnToggle.Down := pnlNav.Visible;
  // Let the tree know how much data space we need.
  vdtModules.NodeDataSize := SizeOf(TBookNodeData);

  // Create custom popup menu
  pmHistory := PopupFrm.TPopupMenu.Create(self);
  pmHistory.PopupMode := pmCustom;
  pmHistory.PopupForm := mainView;

  // this will show 10 menu items and the rest will be accessible by scroll bars
  pmHistory.PopupCount := 10;
  pmHistory.OnPopup := HistoryPopup;

  // assign custom popup for history forward button
  tbtnForward.DropdownMenu := pmHistory;

  mUpdateOnTreeNodeSelect := true;
  mHistoryOn := true;

  ApplyConfig(AppConfig);
  RealignToolBars(Self);
end;

procedure TBookFrame.HistoryPopup(Sender: TObject);
var
  popup: PopupFrm.TPopupForm;
  histIndex: integer;
begin
  if (Sender is PopupFrm.TPopupForm) then
  begin
    popup := PopupFrm.TPopupForm(Sender);
    histIndex := GetCurrentHistoryIndex();
    if (histIndex >= 0) and (histIndex < pmHistory.Items.Count) then
      popup.ListBox.TopIndex := GetCurrentHistoryIndex();
  end;
end;

procedure TBookFrame.dtsBibleChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
var
  me: TModuleEntry;
begin
  if mMainView.mInterfaceLock then
    Exit;
  try

    if NewTab >= dtsBible.Tabs.Count - 1 then
    begin
      AllowChange := false;
      Exit;
    end
    else
    begin
      if IsDown(VK_SHIFT) or IsDown(VK_MENU) then
      begin
        AllowChange := false;
        Exit;
      end;
      me := dtsBible.Tabs.Objects[NewTab] as TModuleEntry;
      mMainView.GoModuleName(me.mFullName);
    end;
  except
    on E: Exception do
      BqShowException(E);
  end;

  mMainView.tbLinksToolBar.Visible := false;
end;

procedure TBookFrame.dtsBibleClick(Sender: TObject);
var
  pt: TPoint;
  it, modIx: integer;
  me: TModuleEntry;
  s: string;
begin
  if mMainView.mInterfaceLock then
    Exit;
  pt := dtsBible.ScreenToClient(Mouse.CursorPos);
  it := dtsBible.ItemAtPos(pt);
  if (it < 0) or (it >= dtsBible.Tabs.Count) then
    Exit;
  if (it = dtsBible.Tabs.Count - 1) then
  begin
    if IsDown(VK_SHIFT) then
    begin
      SelectSatelliteBibleByName('');
      Exit;
    end;
    modIx := mMainView.mModules.FindByFolder(BookTabInfo.Bible.ShortPath);
    if modIx >= 0 then
    begin
      me := TModuleEntry(mMainView.mModules.Items[modIx]);
      if mMainView.mFavorites.AddModule(me) then
        AdjustBibleTabs();
    end;
    Exit;
  end;

  me := dtsBible.Tabs.Objects[it] as TModuleEntry;
  if IsDown(VK_SHIFT) then
  begin
    SelectSatelliteBibleByName(me.mFullName);
    Exit;
  end;
  if IsDown(VK_MENU) then
  begin
    s := BookTabInfo.Location;
    StrReplace(s, BookTabInfo.Bible.ShortPath, me.mShortPath, false);
    mMainView.NewBookTab(s, BookTabInfo.SatelliteName, BookTabInfo.State, '', true);
    Exit;
  end;
end;

procedure TBookFrame.dtsBibleDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  TabIndex, sourceTabIx, modIx: integer;
  dragDropPoint: TPoint;
  me: TModuleEntry;
  moduleTabIndex: integer;
begin
  dragDropPoint.X := X;
  dragDropPoint.Y := Y;
  TabIndex := dtsBible.ItemAtPos(dragDropPoint);
  if (TabIndex < 0) or (TabIndex >= dtsBible.Tabs.Count) then
    Exit;

  if Source is TChromeTabs then
  begin
    try
      moduleTabIndex := (Source as TChromeTabs).tag;
      if (moduleTabIndex < 0) then
        Exit;

      if not Assigned(BookTabInfo) then
        Exit;

      if TabIndex = dtsBible.Tabs.Count - 1 then
      begin
        // drop on *** - last tab, adding new tab
        modIx := mMainView.mModules.FindByFolder(bookTabInfo.Bible.ShortPath);
        if modIx >= 0 then
        begin
          me := TModuleEntry(mMainView.mModules.Items[modIx]);
          mMainView.mFavorites.AddModule(me);
          AdjustBibleTabs(bookTabInfo.Bible.ShortName);
        end;
        Exit;
      end;
      // replace
      modIx := mMainView.mModules.FindByFolder(bookTabInfo.Bible.ShortPath);
      if modIx < 0 then
        Exit;

      me := TModuleEntry(mMainView.mModules.Items[modIx]);
      if not Assigned(me) then
        Exit;

      mMainView.mFavorites.ReplaceModule(TModuleEntry(dtsBible.Tabs.Objects[TabIndex]), me);
      AdjustBibleTabs(BookTabInfo.Bible.ShortName);
    except
    end;
  end
  else if Source is TDockTabSet then
  begin // move/exchange
    if (TabIndex = dtsBible.Tabs.Count) then
      Exit;

    sourceTabIx := dtsBible.tag;
    if (sourceTabIx < 0) or (sourceTabIx >= dtsBible.Tabs.Count) or
      (sourceTabIx = TabIndex) then
      Exit;

    me := TModuleEntry(dtsBible.Tabs.Objects[sourceTabIx]);
    mMainView.mFavorites.MoveItem(me, TabIndex);

    AdjustBibleTabs(bookTabInfo.Bible.ShortName);
    mMainView.SetFavouritesShortcuts();
  end;
end;

procedure TBookFrame.dtsBibleDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  tabIx, delta: integer;
  dragOverPoint: TPoint;
begin
  dragOverPoint.X := X;
  dragOverPoint.Y := Y;
  tabIx := dtsBible.ItemAtPos(dragOverPoint);
  if Source is TDockTabSet then
    delta := 1
  else
    delta := 0;
  Accept := (tabIx >= 0) and (tabIx < dtsBible.Tabs.Count - delta);
end;

procedure TBookFrame.dtsBibleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  ix: integer;
begin
  if Button <> mbLeft then
    Exit;
  pt.X := X;
  pt.Y := Y;
  ix := dtsBible.ItemAtPos(pt);
  dtsBible.tag := ix;
  if (ix < 0) or (ix >= dtsBible.Tabs.Count - 1) then
    Exit;
  dtsBible.BeginDrag(false, 20);
end;

procedure TBookFrame.dtsBibleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
{$J+}
const
  last_mouse_pos: TPoint = (X: 0; Y: 0);
  last_mouse_time: Cardinal = Cardinal(0);

  last_ix: integer = -1;
var
  tm: Cardinal;
  ps: TPoint;
  it: integer;
  me: TModuleEntry;
  ws: string;
begin
  ps.X := X;
  ps.Y := Y;
  tm := GetTickCount();
  it := dtsBible.ItemAtPos(ps);
  if (it = last_ix) { and (tm-last_mouse_time<1000) } then
    Exit;
  last_mouse_time := tm;

  if last_ix <> it then
  begin
    last_ix := it;
    mMainView.hint_expanded := 0;
  end
  else if mMainView.hint_expanded >= 1 then
    Exit; // same tab hint already expanded

  if (it < 0) or (it = dtsBible.Tabs.Count - 1) then
  begin
    dtsBible.Hint := '';
    Exit
  end;

  me := dtsBible.Tabs.Objects[it] as TModuleEntry;
  ws := me.mFullName;

  if mMainView.hint_expanded = 0 then
    mMainView.hint_expanded := 1;
  dtsBible.Hint := ws;
  Application.CancelHint();
end;

procedure TBookFrame.dtsBibleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  itemIx: integer;
begin
  mMainView.miDeteleBibleTab.tag := 0;
  if Button <> mbRight then
    Exit;
  pt.X := X;
  pt.Y := Y;
  itemIx := dtsBible.ItemAtPos(pt);
  if ((itemIx < 0) or (itemIx >= dtsBible.Tabs.Count - 1)) or (dtsBible.Tabs.Count <= 2) then
    Exit;

  mMainView.miDeteleBibleTab.tag := itemIx;
  pt := dtsBible.ClientToScreen(pt);
  mMainView.pmEmpty.Popup(pt.X, pt.Y);
end;

procedure TBookFrame.FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
var tabsForm: TDockTabsForm;
begin
  tabsForm := mTabsView as TDockTabsForm;
  tabsForm.MakeActive;
end;

procedure TBookFrame.miAddBookmarkClick(Sender: TObject);
begin
  mMainView.AddBookmark(miAddBookmark.Caption);
end;

procedure TBookFrame.miAddMemoClick(Sender: TObject);
begin
  if (mMainView.AddMemo(miAddMemo.Caption)) then
  begin
    if not mMainView.MemosOn then
      miMemosToggle.Click
    else
    begin
      miMemosToggle.Click; // off
      miMemosToggle.Click; // on - to show new memos...
    end;
  end;
end;

procedure TBookFrame.miCompareClick(Sender: TObject);
begin
  mMainView.CompareTranslations();
end;

procedure TBookFrame.miCopyPassageClick(Sender: TObject);
begin
  mMainView.CopyPassageToClipboard();
end;

procedure TBookFrame.CopyBrowserSelectionToClipboard();
var
  s: string;
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      if (bwrHtml.SelLength <> 0) or
        ((bwrHtml.SelLength = 0) and (bwrHtml.tag <> bsText)) then
      begin
        bwrHtml.CopyToClipboard;
        if not (AppConfig.AddFontParams xor IsDown(VK_SHIFT)) then
        begin
          if bwrHtml.tag <= bsText then
          begin
            s := Clipboard.AsText;

            // carriage returns are replaced by space
            StrReplace(s, '  ', ' ', true);

            // double spaces are replaced by single space
            Clipboard.AsText := s;
          end
          else
            Clipboard.AsText := mMainView.CopyPassage(mMainView.CurFromVerse, mMainView.CurToVerse);
        end
      end;
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TBookFrame.miCopySelectionClick(Sender: TObject);
begin
  CopyBrowserSelectionToClipboard();
end;

procedure TBookFrame.miCopyVerseClick(Sender: TObject);
begin
  mMainView.CopyVerse;
end;

procedure TBookFrame.miMemoCopyClick(Sender: TObject);
begin
  if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).CopyToClipboard
  else if pmMemo.PopupComponent is TComboBox then
    Clipboard.AsText := (pmMemo.PopupComponent as TComboBox).Text;
end;

procedure TBookFrame.miMemoCutClick(Sender: TObject);
begin
  if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).CutToClipboard
  else if pmMemo.PopupComponent is TComboBox then
  begin
    Clipboard.AsText := (pmMemo.PopupComponent as TComboBox).Text;
    (pmMemo.PopupComponent as TComboBox).Text := '';
  end;
end;

procedure TBookFrame.miMemoPasteClick(Sender: TObject);
begin
  if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).PasteFromClipboard;
end;

procedure TBookFrame.SetMemosVisible(showMemos: Boolean);
begin
  miMemosToggle.Checked := showMemos;
  tbtnMemos.Down := showMemos;

  mMainView.MemosOn := showMemos;
  BookTabInfo[vtisShowNotes] := showMemos;

  ProcessCommand(BookTabInfo, BookTabInfo.Location, TbqHLVerseOption(ord(BookTabInfo[vtisHighLightVerses])));
end;

procedure TBookFrame.miMemosToggleClick(Sender: TObject);
begin
  SetMemosVisible(miMemosToggle.Checked);
end;

procedure TBookFrame.miSearchWindowClick(Sender: TObject);
begin
  // to quick search tab
  Winapi.Windows.SetFocus(tedtQuickSearch.Handle);

  if bwrHtml.SelLength <> 0 then
  begin
    tedtQuickSearch.Text := Trim(bwrHtml.SelText);
    SearchForward();
  end;
end;

procedure TBookFrame.miSearchWordClick(Sender: TObject);
begin
  NavigateToSearch(bwrHtml.SelText);
end;

procedure TBookFrame.NavigateToSearch(searchText: string; bookTypeIndex: integer = -1);
begin
  searchText := Trim(searchText);

  if searchText.Length <= 0 then
    Exit;

  if not Assigned(BookTabInfo) then
    Exit;

  mMainView.OpenOrCreateSearchTab(BookTabInfo.Bible.ShortPath, searchText, bookTypeIndex);
end;

procedure TBookFrame.pmBrowserPopup(Sender: TObject);
var
  s, scap: string;
  i: integer;
  tagsVersesList: TbqVerseTagsList;
  tagMenu: TMenuItem;
begin
  if bwrHtml.tag <> bsText then
  begin
    miCopyPassage.Visible := false;
    miCopyVerse.Visible := false;
    Exit;
  end
  else
  begin
    miCopyPassage.Visible := true;
    miCopyVerse.Visible := true;
  end;

  mMainView.CurVerseNumber := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, mMainView.CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.RightMouseClickPos, true));

  mMainView.CurSelStart := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, mMainView.CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.SelStart, true));

  mMainView.CurSelEnd := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, mMainView.CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.SelStart + bwrHtml.SelLength, true));

  if mMainView.CurSelStart > mMainView.CurSelEnd then
  begin
    i := mMainView.CurSelStart;
    mMainView.CurSelStart := mMainView.CurSelEnd;
    mMainView.CurSelEnd := i;
  end;

  miCopyPassage.Visible := (mMainView.CurSelStart < mMainView.CurSelEnd);

  miAddBookmarkTagged.Clear;
  tagsVersesList := TbqVerseTagsList.Create(true);
  try
    try
      TagsDbEngine.SeedNodes(tagsVersesList);
      for i := 0 to tagsVersesList.Count - 1 do
      begin
        tagMenu := TMenuItem.Create(miAddBookmarkTagged);
        tagMenu.Caption := TVersesNodeData(tagsVersesList.Items[i]).getText();
        tagMenu.OnClick := AddThemedBookmarkClick;
        miAddBookmarkTagged.Add(tagMenu);
      end;
      miAddBookmarkTagged.Enabled := tagsVersesList.Count > 0;
    finally
      tagsVersesList.Free;
    end;
  except
    // skip error
  end;

  if mMainView.CurVerseNumber = 0 then
  begin
    miCompare.Visible := false;
    miCopyVerse.Visible := false;
  end
  else
    with BookTabInfo.Bible do
    begin
      if miCopyPassage.Visible then
        miCopyPassage.Caption := Format('%s  "%s"',
          [FirstWord(miCopyVerse.Caption), FullPassageSignature(CurBook, CurChapter, mMainView.CurSelStart, mMainView.CurSelEnd)]);

      miCopyVerse.Caption := Format('%s  "%s"',
        [FirstWord(miCopyVerse.Caption), FullPassageSignature(CurBook, CurChapter, mMainView.CurVerseNumber, mMainView.CurVerseNumber)]);

      scap := miAddBookmark.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);

      miAddBookmark.Caption := Format('%s  "%s"',
        [s, FullPassageSignature(CurBook, CurChapter, mMainView.CurVerseNumber, mMainView.CurVerseNumber)]);

      scap := miAddMemo.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);

      miAddMemo.Caption := Format(
        '%s  "%s"',
        [s, FullPassageSignature(CurBook, CurChapter, mMainView.CurVerseNumber, mMainView.CurVerseNumber)]);
    end;
end;

procedure TBookFrame.tbtnBackClick(Sender: TObject);
var
  histItem: TMenuItem;
  itemIndex: integer;
begin
  if (pmHistory.Items.Count = 0) then
    Exit;

  histItem := GetCurrentHistoryItem();
  if not Assigned(histItem) then
    Exit;

  itemIndex := GetHistoryItemIndex(histItem);

  if itemIndex < pmHistory.Items.Count - 1 then
  begin
    ProcessCommand(BookTabInfo, BookTabInfo.History[itemIndex + 1], hlDefault, true);
    CheckHistoryItem(itemIndex + 1);
  end;

  Winapi.Windows.SetFocus(bwrHtml.Handle);
end;

procedure TBookFrame.tbtnCopyClick(Sender: TObject);
begin
  CopyBrowserSelectionToClipboard();
end;

procedure TBookFrame.tbtnForwardClick(Sender: TObject);
var
  histItem: TMenuItem;
  itemIndex: integer;
begin
  if (pmHistory.Items.Count = 0) then
    Exit;

  histItem := GetCurrentHistoryItem();
  if not Assigned(histItem) then
    Exit;

  itemIndex := GetHistoryItemIndex(histItem);

  if itemIndex >= 1 then
  begin
    ProcessCommand(BookTabInfo, BookTabInfo.History[itemIndex - 1], hlDefault, true);
    CheckHistoryItem(itemIndex - 1);
  end;

  Winapi.Windows.SetFocus(bwrHtml.Handle);
end;

function TBookFrame.GetCurrentHistoryItem(): TMenuItem;
var
  menuItem: TMenuItem;
begin
  Result := nil;
  for menuItem in pmHistory.Items do
  begin
    if (menuItem.Checked) then
    begin
      Result := menuItem;
      Exit;
    end;
  end;
end;

function TBookFrame.GetCurrentHistoryIndex(): integer;
var
  menuItem: TMenuItem;
  idx: integer;
begin
  Result := -1;
  idx := 0;
  for menuItem in pmHistory.Items do
  begin
    if (menuItem.Checked) then
    begin
      Result := idx;
      Exit;
    end;
    idx := idx + 1;
  end;
end;

function TBookFrame.GetHistoryItemIndex(historyItem: TMenuItem): integer;
var
  menuItem: TMenuItem;
  index: integer;
begin
  Result := -1;
  index := 0;
  for menuItem in pmHistory.Items do
  begin
    if (menuItem = historyItem) then
      Result := index;
    index := index + 1;
  end;
end;

procedure TBookFrame.HistoryItemClick(Sender: TObject);
var
  menuItem : TMenuItem;
  historyIndex: integer;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  if Sender is TMenuItem then
  begin
    menuItem := TMenuItem(Sender);

    historyIndex := GetHistoryItemIndex(menuItem);
    ProcessCommand(BookTabInfo, BookTabInfo.History[historyIndex], hlDefault, true);
    CheckHistoryItem(historyIndex);
  end;
end;

procedure TBookFrame.tbtnMemosClick(Sender: TObject);
begin
  SetMemosVisible(tbtnMemos.Down);
end;

procedure TBookFrame.tbtnNextChapterClick(Sender: TObject);
begin
  mMainView.GoNextChapter;
end;

procedure TBookFrame.tbtnPrevChapterClick(Sender: TObject);
begin
  mMainView.GoPrevChapter;
end;

procedure TBookFrame.ToggleQuickSearchPanel(const enable: Boolean);
begin
  tbtnQuickSearch.Down := enable;
  tlbQuickSearch.Visible := enable;
  tlbQuickSearch.Height := IfThen(enable, tlbViewPage.Height, 0);

  if (enable) then
    Winapi.Windows.SetFocus(tedtQuickSearch.Handle);
end;

procedure TBookFrame.tbtnQuickSearchClick(Sender: TObject);
begin
  ToggleQuickSearchPanel(tbtnQuickSearch.Down);
end;

procedure TBookFrame.tbtnQuickSearchNextClick(Sender: TObject);
begin
  SearchForward();
end;

procedure TBookFrame.tbtnQuickSearchPrevClick(Sender: TObject);
begin
  SearchBackward();
end;

procedure TBookFrame.tbtnReferenceClick(Sender: TObject);
begin
  mMainView.GoReference();
end;

procedure TBookFrame.tbtnReferenceInfoClick(Sender: TObject);
begin
  mMainView.ShowReferenceInfo();
end;

procedure TBookFrame.ToggleStrongNumbers();
var savePosition: integer;
begin
  BookTabInfo[vtisShowStrongs] := tbtnStrongNumbers.Down;

  if not BookTabInfo.Bible.Trait[bqmtStrongs] then
  begin
    tbtnStrongNumbers.Enabled := false;
    Exit;
  end;
  savePosition := bwrHtml.Position;
  ProcessCommand(BookTabInfo, BookTabInfo.Location, TbqHLVerseOption(ord(BookTabInfo[vtisHighLightVerses])));
  bwrHtml.Position := savePosition;
end;

procedure TBookFrame.SelectSatelliteModule();
var
  vhl: TbqHLVerseOption;
begin
  tbtnSatellite.Down := false;
  if not Assigned(BookTabInfo) then
    Exit;

  if (Length(BookTabInfo.SatelliteName) > 0) and (BookTabInfo.SatelliteName <> '------') then
  begin
    BookTabInfo.SatelliteName := '------';
    if BookTabInfo.LocationType in [vtlUnspecified, vtlModule] then
    begin
      if BookTabInfo[vtisHighLightVerses] then
        vhl := hlTrue
      else
        vhl := hlFalse;
      ProcessCommand(BookTabInfo, BookTabInfo.Location, vhl);
    end;
    Exit;
  end;

  mSatelliteLibraryView.SetModules(mMainView.mModules);

  mSatelliteForm.Width := AppConfig.LibFormWidth;
  mSatelliteForm.Height := AppConfig.LibFormHeight;
  mSatelliteForm.Top := AppConfig.LibFormTop;
  mSatelliteForm.Left := AppConfig.LibFormLeft;

  mSatelliteForm.ShowModal();
end;

procedure TBookFrame.tbtnSatelliteClick(Sender: TObject);
begin
  SelectSatelliteModule();
end;

procedure TBookFrame.tbtnSatelliteMouseEnter(Sender: TObject);
begin
  if tbtnSatellite.Down then
  begin
    if Assigned(BookTabInfo) then
      tbtnSatellite.Hint := BookTabInfo.SatelliteName;
  end
  else
  begin
    tbtnSatellite.Hint := Lang.SayDefault(
      'DockTabsForm.tbtnSatellite.Hint',
      'Choose secondary Bible');
  end;
end;

procedure TBookFrame.OnSatelliteFormDeactivate(Sender: TObject);
begin
  AppConfig.LibFormWidth := mSatelliteForm.Width;
  AppConfig.LibFormHeight := mSatelliteForm.Height;
  AppConfig.LibFormTop := mSatelliteForm.Top;
  AppConfig.LibFormLeft := mSatelliteForm.Left;
end;

procedure TBookFrame.OnSelectSatelliteModule(Sender: TObject; modEntry: TModuleEntry);
begin
  SelectSatelliteBibleByName(modEntry.mFullName);
  PostMessage(mSatelliteForm.Handle, wm_close, 0, 0);
end;

procedure TBookFrame.SelectSatelliteBibleByName(const bibleName: string);
var
  broserPos: integer;
begin
  try
    BookTabInfo.SatelliteName := bibleName;
    if BookTabInfo.Bible.isBible then
    begin
      broserPos := bwrHtml.Position;
      ProcessCommand(BookTabInfo, BookTabInfo.Location, TbqHLVerseOption(ord(BookTabInfo[vtisHighLightVerses])));
      bwrHtml.Position := broserPos;
    end
    else
    begin
      try
        LoadSecondBookByName(bibleName);
      except
        on E: Exception do
          BqShowException(E);
      end;
    end; // else
    tbtnSatellite.Down := bibleName <> '------';
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure TBookFrame.tbtnStrongNumbersClick(Sender: TObject);
begin
  ToggleStrongNumbers();
end;

procedure TBookFrame.tbtnToggleClick(Sender: TObject);
var
  showNav: boolean;
begin
  showNav := not pnlNav.Visible;
  splMain.Visible := showNav;
  pnlNav.Visible := showNav;
end;

procedure TBookFrame.tedtQuickSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    SearchForward();
  end;
end;

procedure TBookFrame.tedtReferenceDblClick(Sender: TObject);
begin
  mMainView.GoReference();
end;

procedure TBookFrame.tedtReferenceEnter(Sender: TObject);
begin
  PostMessageW(tedtReference.Handle, EM_SETSEL, 0, -1);
end;

procedure TBookFrame.tedtReferenceKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    mMainView.GoReference();
  end;
end;

procedure TBookFrame.SearchForward();
var
  searchText: string;
  searchOptions: TStringSearchOptions;
  i: Integer;
  dx, dy: Integer;
  X, Y: Integer;
begin
  searchText := tedtQuickSearch.Text;

  searchOptions := [soDown];
  if (tbtnMatchCase.Down) then
    Include(searchOptions, soMatchCase);
  if (tbtnMatchWholeWord.Down) then
    Include(searchOptions, soWholeWord);

  if mBrowserSearchPosition = 0 then
  begin
    mBrowserSearchPosition := Pos('</title>', string(bwrHtml.DocumentSource));
    if mBrowserSearchPosition > 0 then
      inc(mBrowserSearchPosition, Length('</title>'));
  end;

  i := FindPosition(bwrHtml.DocumentSource, searchText, mBrowserSearchPosition + 1, searchOptions);
  if i > 0 then
  begin
    mBrowserSearchPosition := i;
    dx := bwrHtml.FindDisplayPos(i, true);
    dy := bwrHtml.FindDisplayPos(i + Length(searchText), true);
    bwrHtml.SelStart := dx - 1;
    bwrHtml.SelLength := dy - dx;
    bwrHtml.DisplayPosToXY(dx, X, Y);
    if (Y > 10) then
      bwrHtml.VScrollBarPosition := Y - 10
    else
      bwrHtml.VScrollBarPosition := Y;
  end
  else
    mBrowserSearchPosition := 0;
end;

procedure TBookFrame.SearchBackward();
var
  searchText: string;
  searchOptions: TStringSearchOptions;
  i: Integer;
  dx, dy: Integer;
  X, Y: Integer;
begin
  searchText := tedtQuickSearch.Text;

  searchOptions := [];
  if (tbtnMatchCase.Down) then
    Include(searchOptions, soMatchCase);
  if (tbtnMatchWholeWord.Down) then
    Include(searchOptions, soWholeWord);

  i := FindPosition(bwrHtml.DocumentSource, searchText, mBrowserSearchPosition - 1, searchOptions);
  if i > 0 then
  begin
    mBrowserSearchPosition := i;
    dx := bwrHtml.FindDisplayPos(i, true);
    dy := bwrHtml.FindDisplayPos(i + Length(searchText), true);
    bwrHtml.SelStart := dx - 1;
    bwrHtml.SelLength := dy - dx;
    bwrHtml.DisplayPosToXY(dx, X, Y);
    if (Y > 10) then
      bwrHtml.VScrollBarPosition := Y - 10
    else
      bwrHtml.VScrollBarPosition := Y;
  end
  else
  begin
    if (Length(bwrHtml.DocumentSource) > 0) then
      mBrowserSearchPosition := bwrHtml.DocumentSource.Length - 1
    else
      mBrowserSearchPosition := 0;
  end;
end;

procedure TBookFrame.AdjustBibleTabs(moduleName: string = '');
var
  i, tabCount, tabIx, offset: integer;
  ws: string;
begin

  if Length(moduleName) = 0 then
    moduleName := BookTabInfo.Bible.ShortName;

  offset := ord(mMainView.mBibleTabsInCtrlKeyDownState) shl 1;
  tabCount := dtsBible.Tabs.Count - 1;
  tabIx := -1;

  for i := 0 to tabCount do
  begin
    ws := dtsBible.Tabs.Strings[i];
    if CompareString(LOCALE_SYSTEM_DEFAULT, 0, PChar(Pointer(moduleName)), -1, PChar(Pointer(ws)) + offset,-1) = CSTR_EQUAL then
    begin
      tabIx := i;
      break;
    end;
  end;
  dtsBible.OnChange := nil;
  if tabIx >= 0 then
    dtsBible.TabIndex := tabIx
  else
    dtsBible.TabIndex := dtsBible.Tabs.Count - 1;

  // not a favorite book
  dtsBible.OnChange := dtsBibleChange;
end;

procedure TBookFrame.LoadSecondBookByName(const name: string);
var
  ix: integer;
  ini: string;
begin
  if (Assigned(mMainView.mModules)) then
  begin
    ix := mMainView.mModules.FindByName(name);
    if ix >= 0 then
    begin
      ini := MainFileExists(TPath.Combine(mMainView.mModules[ix].mShortPath, 'bibleqt.ini'));
      if (ini <> BookTabInfo.SecondBible.inifile) then
        BookTabInfo.SecondBible.inifile := ini;
    end;
  end;
end;

function TBookFrame.GetCurrentBookNode(): PVirtualNode;
var
  currentNodes: TNodeArray;
  data: PBookNodeData;
begin
  Result := nil;
  currentNodes := vdtModules.GetSortedSelection(false);
  if (Length(currentNodes) > 0) then
  begin
    data := vdtModules.GetNodeData(currentNodes[0]);
    if (data.NodeType = btBook) then
    begin
      Result := currentNodes[0];
    end
    else
    begin
      Result := currentNodes[0].Parent;
    end;
  end;
end;

procedure TBookFrame.UpdateModuleTreeFont(book: TBible);
var
  uifont: string;
begin
  if (Length(book.DesiredUIFont) > 0) then
    uifont := mMainView.mFontManager.SuggestFont(mMainView.Canvas.Handle, book.DesiredUIFont, book.path, $7F)
  else
    uifont := mMainView.Font.Name;

  if vdtModules.Font.Name <> uifont then
    vdtModules.Font.Name := uifont;
end;

procedure TBookFrame.UpdateModuleTree(book: TBible);
begin
  vdtModules.Clear;
  UpdateModuleTreeFont(book);

  vdtModules.RootNodeCount := book.BookQty;
  UpdateModuleTreeSelection(book);
end;

procedure TBookFrame.UpdateModuleTreeSelection(book: TBible);
var
  bookNode, chapterNode: PVirtualNode;
  chapterIndex, bookIndex: integer;
begin
  vdtModules.ClearSelection;

  bookIndex := book.CurBook - 1;
  if (bookIndex < 0) then
    bookIndex := 0;

  bookNode := GetChildNodeByIndex(nil, bookIndex);
  if Assigned(bookNode) then
  begin
    chapterIndex := book.CurChapter - 1;
    if (chapterIndex < 0) then
      chapterIndex := 0;

    chapterNode := GetChildNodeByIndex(bookNode, chapterIndex);

    if Assigned(chapterNode) then
    begin
      if (vdtModules.Selected[chapterNode] = False) then
      begin
        if (vdtModules.Expanded[bookNode] = False) then
          vdtModules.Expanded[bookNode] := True;

        mUpdateOnTreeNodeSelect := false;
        try
          vdtModules.Selected[chapterNode] := True;
        finally
          mUpdateOnTreeNodeSelect := true;
        end;
      end;
    end
    else
    begin
      mUpdateOnTreeNodeSelect := false;
      try
        vdtModules.Selected[bookNode] := True;
      finally
        mUpdateOnTreeNodeSelect := true;
      end;
    end;
  end;
end;

procedure TBookFrame.SelectModuleTreeNode(bible: TBible);
var
  i: Integer;
  bookNode: PVirtualNode;
  chapterNode: PVirtualNode;
begin
  i := bible.CurBook - 1;
  if bible.BookQty > 0 then
  begin
    bookNode := GetChildNodeByIndex(nil, i);
    if Assigned(bookNode) then
    begin
      i := bible.CurChapter - 1;
      if (i < 0) then
        i := 0;
      chapterNode := GetChildNodeByIndex(bookNode, i);
      if Assigned(chapterNode) then
      begin
        if (vdtModules.Selected[chapterNode] = False) then
        begin
          if (vdtModules.Expanded[bookNode] = False) then
            vdtModules.Expanded[bookNode] := True;

            mUpdateOnTreeNodeSelect := false;
            try
              vdtModules.Selected[chapterNode] := True;
            finally
              mUpdateOnTreeNodeSelect := true;
            end;
        end;
      end
      else
      begin
        mUpdateOnTreeNodeSelect := false;
        try
          vdtModules.Selected[bookNode] := True;
        finally
          mUpdateOnTreeNodeSelect := true;
        end;
      end;
    end;
  end;
end;

function TBookFrame.GetChildNodeByIndex(parentNode: PVirtualNode; index: Integer): PVirtualNode;
begin
  Result := nil;
  if (parentNode = nil) then
  begin
    Result := vdtModules.GetFirst();
    while (index <> 0) do
    begin
      Result := vdtModules.GetNextSibling(Result);
      Dec(index);
    end;
    exit;
  end;

  if (vsHasChildren in parentNode.States) then
  begin
    Result := vdtModules.GetFirstChild(parentNode);
    while (Assigned(Result) and (index <> 0)) do
    begin
      Result := vdtModules.GetNextSibling(Result);
      Dec(index);
    end;
  end;
end;

function TBookFrame.ProcessCommand(bookTabInfo: TBookTabInfo; command: string; hlVerses: TbqHLVerseOption; disableHistory: boolean = false): Boolean;
var
  value, dup, path, oldPath, ConcreteCmd: string;
  focusVerse: integer;
  i, j, oldbook, oldchapter, status: integer;
  wasSearchHistory, wasFile: Boolean;
  browserpos: Longint;
  dBrowserSource: string;
  oldSignature: string;
  navRslt: TNavigateResult;
  bibleLink: TBibleLinkEx;
label
  exitlabel;

  procedure revertToOldLocation();
  begin
    if oldPath = '' then
    begin
      oldPath := MainFileExists(TPath.Combine(mMainView.mDefaultLocation, C_ModuleIniName));
      if bwrHtml.GetTextLen() <= 0 then
      begin
        ProcessCommand(bookTabInfo, Format('go %s 1 1 1', [mMainView.mDefaultLocation]), hlFalse);
        Exit
      end;
    end;

    bookTabInfo.Bible.inifile := oldPath;
    bibleLink.modName := bookTabInfo.Bible.ShortPath;
    bibleLink.book := oldbook;
    bibleLink.chapter := oldchapter;

    mMainView.UpdateBookView();
  end;

begin
  if disableHistory then
    mHistoryOn := false;

  Result := false;

  if command = '' then
    Exit; // exit, the command is empty

  Screen.Cursor := crHourGlass;
  mMainView.mInterfaceLock := true;
  try
    wasFile := false;
    browserpos := bwrHtml.Position;
    bwrHtml.tag := bsText;

    oldPath := bookTabInfo.Bible.inifile;
    oldbook := bookTabInfo.Bible.CurBook;
    oldchapter := bookTabInfo.Bible.CurChapter;

    dup := command; // command copy

    if bibleLink.FromBqStringLocation(dup) then
    begin
      // make path to module's ini
      if bibleLink.IsAutoBible() then
      begin
        if bookTabInfo.Bible.isBible then
          value := bookTabInfo.Bible.ShortPath
        else if bookTabInfo.SecondBible.isBible then
          value := bookTabInfo.SecondBible.ShortPath
        else
          value := '';
        status := PreProcessAutoCommand(bookTabInfo, dup, value, ConcreteCmd);
        if status <= -2 then
          Exit; // fail
        bibleLink.FromBqStringLocation(ConcreteCmd);
      end;

      path := MainFileExists(bibleLink.GetIniFileShortPath());

      if Length(path) < 1 then
        goto exitlabel;

      oldSignature := bookTabInfo.Bible.FullPassageSignature(bookTabInfo.Bible.CurBook, bookTabInfo.Bible.CurChapter, 0, 0);

      // try to load module
      if path <> bookTabInfo.Bible.inifile then
        try
          bookTabInfo.Bible.inifile := path;
        except // revert to old location if something goes wrong
          revertToOldLocation();
        end;

      try
        // read and display
        navRslt := GoAddress(bookTabInfo, bibleLink.book, bibleLink.chapter, bibleLink.vstart, bibleLink.vend, hlVerses);
        // save history
        if navRslt > nrEndVerseErr then
        begin
          focusVerse := 0;
        end;

        with bookTabInfo.Bible do
          if (bibleLink.vstart = 0) or (navRslt > nrEndVerseErr) then
            // if the final verse is not specified
            // looks like
            // "go module_folder book_no Chapter_no verse_start_no 0 mod_shortname

            command := Format('go %s %d %d %d 0 $$$%s %s',
              [ShortPath, CurBook, CurChapter, focusVerse,
              // history comment
              FullPassageSignature(CurBook, CurChapter, bibleLink.vstart, 0), ShortName])
          else
            command := Format('go %s %d %d %d %d $$$%s %s',
              [ShortPath, CurBook, CurChapter, bibleLink.vstart, bibleLink.vend,
              // history comment
              FullPassageSignature(CurBook, CurChapter, bibleLink.vstart, bibleLink.vend), ShortName]);

        HistoryAdd(command);

        // here we set proper name to tab
        with bookTabInfo.Bible, mTabsView.ChromeTabs do
        begin
          if ActiveTabIndex >= 0 then
            try
              // save the context
              bookTabInfo.Location := command;
              bookTabInfo.LocationType := vtlModule;

              bookTabInfo.IsCompareTranslation := false;
              bookTabInfo.CompareTranslationText := '';

              if navRslt <= nrEndVerseErr then
                bookTabInfo[vtisHighLightVerses] := hlVerses = hlTrue
              else
                bookTabInfo[vtisHighLightVerses] := false;
              bookTabInfo.Title := Format('%.6s-%.6s:%d', [ShortName, ShortNames[CurBook], CurChapter - ord(Trait[bqmtZeroChapter])]);

              mTabsView.ChromeTabs.ActiveTab.Caption := bookTabInfo.Title;

            except
              on E: Exception do
                BqShowException(E);
            end;
        end;

        AppConfig.LastCommand := command;
      except
        on E: TBQPasswordException do
        begin
          mMainView.PasswordPolicy.InvalidatePassword(E.mArchive);
          MessageBox(self.Handle, PChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
          revertToOldLocation();
        end;
        on E: TBQException do
        begin
          MessageBox(self.Handle, PChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
          revertToOldLocation();
        end
        else
          revertToOldLocation(); // in any case
      end;

      goto exitlabel;
    end; // first word is go

    if FirstWord(dup) = 'file' then
    begin
      wasFile := true; // *** - not a favorite
      wasSearchHistory := false;
      // if a Bible path was stored with file... (after search procedure)
      i := Pos('***', dup);
      if i > 0 then
      begin
        j := Pos('$$$', dup);
        value := MainFileExists(TPath.Combine(Copy(dup, i + 3, j - i - 4), 'bibleqt.ini'));

        if bookTabInfo.Bible.inifile <> value then
          bookTabInfo.Bible.inifile := value;

        wasSearchHistory := true;
      end;

      DeleteFirstWord(dup);

      i := Pos('***', dup);
      if i = 0 then
        i := Length(dup);
      j := Pos('$$$', dup);

      if i > j then
        path := Copy(dup, 1, j - 1)
      else
        path := Copy(dup, 1, i - 1);

      if not FileExists(path) then
      begin
        ShowMessage(Format(Lang.Say('FileNotFound'), [path]));
        goto exitlabel;
      end;

      bwrHtml.Base := ExtractFilePath(path);
      ReadHtmlTo(path, dBrowserSource, TEncoding.GetEncoding(1251));

      if wasSearchHistory then
      begin
        StrReplace(dBrowserSource, '<*>', '<font color="' + Color2Hex(AppConfig.SelTextColor) + '">', true);
        StrReplace(dBrowserSource, '</*>', '</font>', true);

      end;

      if bookTabInfo[vtisResolveLinks] then
      begin
        dBrowserSource := ResolveLinks(dBrowserSource, bookTabInfo[vtisFuzzyResolveLinks]);
      end;
      bwrHtml.LoadFromString(dBrowserSource);
      value := '';
      if Trim(bwrHtml.DocumentTitle) <> '' then
        value := bwrHtml.DocumentTitle
      else
        value := ExtractFileName(path);

      if Length(value) <= 0 then
        try
          value := 'Unknown';
          raise Exception.Create('File open- cannot extract valid name');
        except
          on E: Exception do
            BqShowException(E);
        end;

      if (bookTabInfo.History.Count > 0) and (bookTabInfo.History[0] = command) then
        bwrHtml.Position := browserpos;

      HistoryAdd(command);

      if wasSearchHistory then
        bwrHtml.tag := bsSearch
      else
        bwrHtml.tag := bsFile;

      bookTabInfo.Title := Format('%.12s', [value]);
      mTabsView.ChromeTabs.ActiveTab.Caption := bookTabInfo.Title;
      bookTabInfo.Location := command;
      bookTabInfo.LocationType := vtlFile;

      bookTabInfo.IsCompareTranslation := false;
      bookTabInfo.CompareTranslationText := '';

      goto exitlabel;
    end; // first word is "file"

    if ExtractFileName(dup) = dup then
      try
        bwrHtml.LoadFromFile(bwrHtml.Base + dup);
        bookTabInfo.Title := Format('%.12s', [command]);
        mTabsView.ChromeTabs.ActiveTab.Caption := BookTabInfo.Title;

        bookTabInfo.Location := command;
        bookTabInfo.LocationType := vtlFile;

        bookTabInfo.IsCompareTranslation := false;
        bookTabInfo.CompareTranslationText := '';
      except
        on E: Exception do
          BqShowException(E);
      end;

  exitlabel:
    if Length(path) <= 0 then
      Exit;
    Result := true;

    SelectModuleTreeNode(bookTabInfo.Bible);

    if (not wasFile) then
      AdjustBibleTabs();
  finally
    mMainView.mInterfaceLock := false;
    Screen.Cursor := crDefault;

    if disableHistory then
      mHistoryOn := true;

  end;
end; // proc processcommand

procedure TBookFrame.UpdateHistory();
var
  i: integer;
  historyItem: TMenuItem;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  for i := 0 to BookTabInfo.History.Count - 1 do
  begin
    historyItem := TMenuItem.Create(pmHistory);
    historyItem.Caption := Comment(BookTabInfo.History[i]);
    historyItem.GroupIndex := 1;
    historyItem.OnClick := HistoryItemClick;

    pmHistory.Items.Add(historyItem);
  end;

  if (pmHistory.Items.Count > 0) then
  begin
    if BookTabInfo.HistoryIndex >= 0 then
      CheckHistoryItem(BookTabInfo.HistoryIndex)
    else
      CheckHistoryItem(0);
  end;
end;

procedure TBookFrame.HistoryClear();
begin
  pmHistory.Items.Clear();
end;

procedure TBookFrame.HistoryAdd(s: string);
var
  historyItem: TMenuItem;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  with BookTabInfo do
  begin
    if (not mHistoryOn) or ((History.Count > 0) and (History[0] = s)) then
      Exit;

    if History.Count >= MAXHISTORY then
    begin
      History.Delete(History.Count - 1);
      pmHistory.Items.Delete(pmHistory.Items.Count - 1);
    end;

    History.Insert(0, s);

    historyItem := TMenuItem.Create(pmHistory);
    historyItem.Caption := Comment(s);
    historyItem.GroupIndex := 1;
    historyItem.OnClick := HistoryItemClick;

    pmHistory.Items.Insert(0, historyItem);
    CheckHistoryItem(0);
  end;
end;

procedure TBookFrame.CheckHistoryItem(itemIndex: integer);
var
  menuItem: TMenuItem;
  idx: integer;
begin
  idx := 0;
  for menuItem in pmHistory.Items do
  begin
    if (idx = itemIndex) then
      menuItem.Checked := true
    else
      menuItem.Checked := false;
    idx := idx + 1;
  end;

  BookTabInfo.HistoryIndex := itemIndex;
  tbtnBack.Enabled := itemIndex < pmHistory.Items.Count - 1;
  tbtnForward.Enabled := true;
end;

procedure TBookFrame.SafeProcessCommand(bookTabInfo: TBookTabInfo; wsLocation: string; hlOption: TbqHLVerseOption);
var
  succeeded: Boolean;
begin
  if Length(Trim(wsLocation)) > 1 then
  begin
    succeeded := ProcessCommand(bookTabInfo, wsLocation, hlOption);
    if succeeded then
      Exit;
  end;

  if Length(Trim(AppConfig.LastCommand)) > 1 then
  begin
    succeeded := ProcessCommand(bookTabInfo, AppConfig.LastCommand, hlOption);
    if succeeded then
      Exit;
  end;
  ProcessCommand(bookTabInfo, Format('go %s %d %d %d', [mMainView.mDefaultLocation, 1, 1, 1]), hlDefault);
end;

function TBookFrame.PreProcessAutoCommand(bookTabInfo: TBookTabInfo; const cmd: string; const prefModule: string; out ConcreteCmd: string): HRESULT;
label Fail;
var
  ps, refCnt, refIx, prefModIx: integer;
  me: TModuleEntry;
  bl, moduleEffectiveLink: TBibleLink;
  dp: string;
  refBook: TBible;
begin
  if not Assigned(bookTabInfo) then
  begin
    Result := -2;
    Exit;
  end;

  refBook := bookTabInfo.ReferenceBible;
  me := nil;
  try
    if Pos('go', Trim(cmd)) <> 1 then
      goto Fail;
    ps := Pos(C__bqAutoBible, cmd);
    if ps = 0 then
      goto Fail;
    if not bl.FromBqStringLocation(cmd, dp) then
      goto Fail;
    prefModIx := mMainView.mModules.FindByFolder(prefModule);
    if prefModIx >= 0 then
    begin
      me := mMainView.mModules[prefModIx];
      if me.modType = modtypeBible then
        Result := refBook.LinkValidnessStatus(me.getIniPath(), bl, true)
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
        Result := refBook.LinkValidnessStatus(me.getIniPath(), bl, true);
        if Result > -2 then
          break;
      end;
    end;
    if Result > -2 then
    begin
      refBook.InternalToReference(bl, moduleEffectiveLink);
      if (me <> nil) then
        ConcreteCmd := moduleEffectiveLink.ToCommand(me.mShortPath);
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

function TBookFrame.GoAddress(bookTabInfo: TBookTabInfo; var book, chapter, fromverse, toverse: integer; var hlVerses: TbqHLVerseOption): TNavigateResult;
var
  paragraph, hlParaStart, hlParaEnd, hlstyle, Title, head, Text, s, strVerseNumber, ss: string;
  verse: integer;
  locVerseStart, locVerseEnd, bverse, everse: integer;
  i, ipos, B, C, V, ib, ic, iv, chapterCount: integer;
  UseParaBible, opened, multiHl, isCommentary, showStrongs: Boolean;
  dBrowserSource, wsMemoTxt: string;
  fontName, uiFontName: string;
  fistBookCell, SecondbookCell: string;
  mainbook_right_aligned, secondbook_right_aligned, hlCurrent: Boolean;
  hlVerseStyle: integer;
  highlight_verse: TPoint;
  modEntry: TModuleEntry;
  bible, secondBible: TBible;
begin
  bible := bookTabInfo.Bible;
  secondBible := bookTabInfo.SecondBible;
  // check and correction of the book number
  highlight_verse := Point(fromverse, toverse);
  UseParaBible := false;
  Result := nrSuccess;
  locVerseStart := fromverse;
  locVerseEnd := toverse;

  // check and correction of the book
  if book < 1 then
  begin
    Result := nrBookErr;
    book := 1;
  end
  else if book > bible.BookQty then
  begin
    book := bible.BookQty;
    Result := nrBookErr;
  end;

  // check and correct chapter number
  if chapter < 0 then
  begin
    Result := nrChapterErr;
    chapter := 1;
  end
  else if chapter > bible.ChapterQtys[book] then
  begin
    if Result = nrSuccess then
      Result := nrChapterErr;
    chapter := bible.ChapterQtys[book];
  end;

  if Result <> nrSuccess then
  begin
    highlight_verse := Point(0, 0);
    fromverse := 0;
    toverse := 0; // reset verse on chapter err
    locVerseStart := 1;
    locVerseEnd := 0;
  end;

  try
    opened := bible.OpenChapter(book, chapter);
    if not opened then
      raise Exception.CreateFmt('invaid chapter %d for book %d', [chapter, book]);

  except
    on E: EAbort do
    begin
      raise;
    end;
    else
    begin
      if Result = nrSuccess then
        Result := nrChapterErr;
      highlight_verse := Point(0, 0);
      bible.OpenChapter(1, 1);
      book := 1;
      chapter := 1;
      fromverse := 0;
      locVerseStart := 1;
      toverse := 0;
      locVerseEnd := 0;
    end;
  end;

  chapterCount := bible.ChapterCountForBook(bible.CurBook, false);
  mainbook_right_aligned := bible.UseRightAlignment;

  // search for a secondary Bible if the first module is bible
  if bible.isBible then
  begin
    isCommentary := bible.isCommentary;
    showStrongs := bookTabInfo[vtisShowStrongs];
    s := bookTabInfo.SatelliteName;
    if (s = '------') or isCommentary then
      UseParaBible := false
    else
    begin
      // search in the list of modules
      try
        modEntry := mMainView.mModules.ResolveModuleByNames(s, '');
      except
        on E: Exception do
        begin
          BqShowException(E, Format('GoAddress err: mod=%s | book=%d | chapter=%d', [bible.Name, book, chapter]));
        end;
      end;
      if Assigned(modEntry) then
      { // now UseParaBible will be used if satellite text is found... }
      begin

        secondBible.inifile := modEntry.getIniPath();

        secondbook_right_aligned := secondBible.UseRightAlignment;
        UseParaBible := secondBible.ModuleType = bqmBible;

        // if the primary module displays an NT, and the second one does not contain an NT
        if (((bible.CurBook < 40) and (bible.Trait[bqmtOldCovenant])) and (not secondBible.Trait[bqmtOldCovenant])) or
        // or if in the primary OT module and the second one does not contain OT
          (((bible.CurBook > 39) or (bible.Trait[bqmtNewCovenant] and
          (not bible.Trait[bqmtOldCovenant]))) and
          (not SecondBible.Trait[bqmtNewCovenant])) then
          UseParaBible := false; // cancel display
      end; // if UseParaBible is found in the list of modules
    end; // if a secondary Bible is selected
  end // if the module is bible

  else
    isCommentary := false;

  // check and correct start verse
  if fromverse > bible.VerseQty then
  begin
    fromverse := 0;
    locVerseStart := 1;
    highlight_verse.X := 0;
    if Result = nrSuccess then
      Result := nrStartVerseErr;
  end;

  // check and correct target verse
  if (toverse > bible.VerseQty) or (toverse < fromverse) then
  begin
    if (toverse < fromverse) and (toverse <= bible.VerseQty) then
    begin
      toverse := highlight_verse.Y;
      highlight_verse.Y := highlight_verse.X;
      highlight_verse.X := toverse;
    end
    else
      highlight_verse.Y := highlight_verse.X;
    toverse := 0;
    locVerseEnd := 0;
    if Result = nrSuccess then
      Result := nrEndVerseErr;
  end;

  if (highlight_verse.X <= 0) and (highlight_verse.Y > 0) then
    highlight_verse.X := highlight_verse.Y;

  if hlVerses = hlFalse then
    highlight_verse := Point(-1, -1);

  if bible.Trait[bqmtNoForcedLineBreaks] then
    paragraph := ''
  else
  begin
    if (bible.isBible) then
      paragraph := ' <BR>'
    else
      paragraph := '<P>';
  end;

  if toverse = 0 then
  begin // display the entire chapter
    // if only one chapter in the book
    if bible.ChapterQtys[book] = 1 then
      head := bible.FullNames[book]
    else
      head := bible.FullPassageSignature(book, chapter, 1, 0);
  end
  else
    head := bible.FullPassageSignature(book, chapter, fromverse, toverse);

  Title := '<head>'#13#10'<title>' + head + '</title>'#13#10 + bqPageStyle + #13#10'</head>';
  if Length(bible.DesiredUIFont) > 0 then
    uiFontName := bible.DesiredUIFont
  else
    uiFontName := AppConfig.DefFontName;
  head := '<font face="' + uiFontName + '">' + head + '</font>';

  Text := '';
  if locVerseStart = 0 then
  begin
    locVerseStart := 1;
  end;

  bverse := 1;
  if (locVerseStart > 0) and (not AppConfig.FullContextLinks) then
    bverse := locVerseStart;

  if (locVerseEnd = 0) or (AppConfig.FullContextLinks) then
    everse := bible.VerseQty
  else
    everse := locVerseEnd;

  mMainView.CurFromVerse := bverse;
  mMainView.CurToVerse := everse;

  opened := false;

  if UseParaBible then
  begin
    if bible.Trait[bqmtZeroChapter] and (chapter = 1) then
      // in chapter zero in primary view
      UseParaBible := false;
  end;

  if UseParaBible then
  begin
    if ((Length(SecondBible.fontName) > 0)) or (SecondBible.desiredCharset > 2)
    then
      fontName := mMainView.FontManager.SuggestFont(self.Handle, SecondBible.fontName, SecondBible.path, SecondBible.desiredCharset)
    else
      fontName := AppConfig.DefFontName;
    bwrHtml.DefFontName := fontName;
  end;

  Text := bible.ChapterHead;

  for verse := bverse to everse do
  begin
    s := bible.Verses[verse - 1];
    if (highlight_verse.X > 0) and (highlight_verse.Y > 0) and (AppConfig.HighlightVerseHits) then
    begin
      hlCurrent := (verse <= highlight_verse.Y) and (verse >= highlight_verse.X);
      hlVerseStyle := ord(verse = highlight_verse.X) + (ord(verse = highlight_verse.Y) shl 1);
    end
    else
    begin
      hlCurrent := false;
      hlVerseStyle := 0;
    end;
    if hlCurrent then
    begin
      hlstyle := 'background-color:' + Color2Hex(AppConfig.VerseHighlightColor) + ';';
      if bible.Trait[bqmtNoForcedLineBreaks] then
      begin
        hlParaStart := '<span style="';
        hlParaEnd := '</span>';
      end
      else
      begin
        hlParaStart := '<div style="';
        hlParaEnd := '</div>';
      end;
      hlParaStart := hlParaStart + hlstyle + '">';

    end
    else
    begin
      hlParaStart := '';
      hlParaEnd := '';
      hlstyle := '';
    end;

    strVerseNumber := StrDeleteFirstNumber(s);

    if (bible.isBible) and (not isCommentary) then
    begin // if bible display verse numbers

      if MainForm.miShowSignatures.Checked then
        ss := bible.ShortNames[bible.CurBook] + IntToStr(bible.CurChapter) + ':'
      else
        ss := '';

      strVerseNumber := '<a href="verse ' + strVerseNumber
        + '" CLASS=OmegaVerseNumber>' +
        ss + strVerseNumber + '</a>';

      if bible.Trait[bqmtNoForcedLineBreaks] then
        strVerseNumber := '<sup>' + strVerseNumber + '</sup>';

      if bible.Trait[bqmtStrongs] then
      begin
        if (not showStrongs) then
          s := DeleteStrongNumbers(s)
        else
          s := FormatStrongNumbers(s, (bible.CurBook < 40) and (bible.Trait[bqmtOldCovenant]), true);
      end;
    end;
    // if the module is non bible or there is no secondary Bible
    if (not bible.isBible) or (not UseParaBible) then
    begin // no satellite text
      if mainbook_right_aligned then
        Text := Text + Format
          (#13#10'%s<F>%s</F><a name="bqverse%d">%s</a>%s',
          [hlParaStart, s, verse, strVerseNumber, hlParaEnd])
      else
      begin
        if (bible.isBible) and (not bible.Trait[bqmtNoForcedLineBreaks])
        then
          Text := Text + Format
            (#13#10'%s<a name="bqverse%d">%s <F>%s</F></a>%s',
            [hlParaStart, verse, strVerseNumber, s, hlParaEnd])
        else
          Text := Text + Format
            (#13#10'%s<a name="bqverse%d">%s <F>%s</F></a>%s',
            [hlParaStart, verse, strVerseNumber, s, hlParaEnd]);
      end;
      if (not hlCurrent) or ((hlVerseStyle and 2 > 0) and not bible.isBible)
      then
        Text := Text + paragraph;
    end
    else
    begin
      if UseParaBible then
      begin // if text is found in the secondary Bible
        try
          with bible do
            ReferenceToInternal(CurBook, CurChapter, verse, B, C, V);

          SecondBible.InternalToReference(B, C, V, ib, ic, iv);

          if (ib <> SecondBible.CurBook) or (ic <> SecondBible.CurChapter) or (not opened) then
          begin
            opened := SecondBible.OpenChapter(ib, ic);
            UseParaBible := opened;
          end;
        except
          UseParaBible := false;
        end;

        if iv <= 0 then
          iv := 1;
        if mainbook_right_aligned then
          fistBookCell :=
            '<table width=100% cellpadding=0 border=0 cellspacing=10em >' +
            '<tr style="' + hlstyle + '"><td valign=top width=50% align=right>'
            + Format(#13#10'<a name="bqverse%d">%s <F>%s</F> ',
            [verse, strVerseNumber, s])
        else
          fistBookCell :=
            '<table width=100% cellpadding=0 border=0 cellspacing=10em >' +
            '<tr style="' + hlstyle + '"><td valign=top width=50% align=left>' +
            Format(#13#10'<a name="bqverse%d">%s<F> %s</F></a>',
            [verse, strVerseNumber, s]);

        SecondbookCell := '';

        if iv <= SecondBible.verseCount() then
        begin
          ss := SecondBible.Verses[iv - 1];
          StrDeleteFirstNumber(ss);
          if SecondBible.Trait[bqmtStrongs] then
            if showStrongs then
              ss := FormatStrongNumbers(ss, B < 40, true)
            else
              ss := DeleteStrongNumbers(ss);
          if secondbook_right_aligned then
            SecondbookCell :=
              Format
              ('</td><td valign=top width=50%% align=right><font size=1>%d:%d</font><font face="%s">%s</font>',
              [ic, iv, fontName, ss]) + '</td></tr></table>' + #13#10
          else
            SecondbookCell :=
              Format
              ('</td><td valign=top width=50%%><font face="Arial" size=1>%d:%d </font><font face="%s">%s</font>',
              [ic, iv, fontName, ss]) + '</td></tr></table>' + #13#10;
        end;
        if Length(SecondbookCell) <= 0 then
          SecondbookCell :=
            '</td><td valign=top width=50%> </td></tr></table>'#13#10;

        Text := Text + fistBookCell + SecondbookCell;

      end;
    end;

    // memos...
    if mMainView.MemosOn then
    begin // if notes are enabled
      with bible do // search for 'Быт.1:1 RST $$$' in Memos.
        i := FindString(
          mMainView.Memos,
          ShortPassageSignature(CurBook, CurChapter, verse, verse) + ' ' + ShortName + ' $$$');

      if i > -1 then
      begin // found memo
        wsMemoTxt := '<font color=' + Color2Hex(AppConfig.SelTextColor) + '>' + Comment(mMainView.Memos[i]) + '</font>' + paragraph;
        if bookTabInfo[vtisResolveLinks] then
          wsMemoTxt := ResolveLinks(wsMemoTxt, bookTabInfo[vtisFuzzyResolveLinks]);

        Text := Text + wsMemoTxt;
      end;
    end; // if notes are enabled
  end;
  if not UseParaBible then
  begin
    if mainbook_right_aligned then
      Text := '<div style="text-align:right">' + Text + '</div>'
    else
      Text := '<div style="text-align:justify">' + Text + '</div>'
  end;

  dBrowserSource := mMainView.TextTemplate;
  StrReplace(dBrowserSource, '%HEAD%', head, false);
  StrReplace(dBrowserSource, '%TEXT%', Text, false);

  if ((Length(bible.fontName) > 0) and (bible.fontName = bwrHtml.DefFontName)) then
    fontName := bible.fontName
  else
    fontName := '';

  // if a font is specified, but is not yet selected in browser properties or encoding is specified
  if (Length(fontName) <= 0) and ((Length(bible.fontName) > 0) or (bible.desiredCharset > 2)) then
    fontName := mMainView.FontManager.SuggestFont(self.Handle, bible.fontName, bible.path, bible.desiredCharset);

  if Length(fontName) <= 0 then
    fontName := AppConfig.DefFontName;

  bwrHtml.DefFontName := fontName;
  StrReplace(dBrowserSource, '<F>', '<font face="' + fontName + '">', true);
  StrReplace(dBrowserSource, '</F>', '</font>', true);

  // fonts processing
  dBrowserSource := '<HTML>' + Title + dBrowserSource + '</HTML>';
  bwrHtml.Base := bible.path;

  for i := 1 downto 0 do
  begin
    try
      bwrHtml.LoadFromString(dBrowserSource);
      break;
    except
      on E: Exception do
      begin
        BqShowException(E, 'LoadFromString failed!');
        if i = 0 then
          raise;
      end;
    end;
  end;

  bwrHtml.Position := 0;
  multiHl := (highlight_verse.X > 0) and (highlight_verse.Y > 0) and (highlight_verse.Y <> highlight_verse.X);

  if highlight_verse.X > 0 then
    verse := highlight_verse.X
  else if highlight_verse.Y > 0 then
    verse := highlight_verse.Y
  else
    verse := 0;

  hlVerses := TbqHLVerseOption(ord(verse > 0));
  if (hlVerses = hlTrue) then
    bwrHtml.PositionTo('bqverse' + IntToStr(verse), not multiHl);

  mMainView.VersePosition := verse;

  s := bible.ShortName + ' ' + bible.FullPassageSignature(book, chapter, fromverse, toverse);

  mMainView.lblTitle.Font.Name := fontName;
  mMainView.lblTitle.Caption := s;
  mMainView.lblTitle.Hint := s + '   ';

  try
    bookTabInfo.TitleLocation := s;
    bookTabInfo.TitleFont := fontName;
  except
  end;
  if bible.Copyright <> '' then
  begin
    s := '; © ' + bible.Copyright;
  end
  else
    s := '; ' + Lang.Say('PublicDomainText');

  if Assigned(bookTabInfo) then
    bookTabInfo.CopyrightNotice := s;
end;

procedure TBookFrame.GoRandomPlace;
var
  bookIndex, chapterIndex, verseIndex: integer;
  book: TBible;
begin
  book := BookTabInfo.Bible;

  Randomize();
  bookIndex := Random(book.BookQty) + 1;
  chapterIndex := Random(book.ChapterQtys[bookIndex]) + 1;
  verseIndex := Random(book.CountVerses(bookIndex, chapterIndex)) + 1;

  ProcessCommand(BookTabInfo, Format('go %s %d %d %d', [book.ShortPath, bookIndex, chapterIndex, verseIndex]), hlTrue);
end;

procedure TBookFrame.LoadBibleToXref(cmd: string; const id: string);
var
  fn, ws, psg, doc, ConcreteCmd: string;
  bl: TBibleLink;
  status_load: integer;
begin
  status_load := PreProcessAutoCommand(BookTabInfo, cmd, BookTabInfo.SecondBible.ShortPath, ConcreteCmd);

  if status_load <= -2 then
    Exit;

  status_load := GetModuleText(ConcreteCmd, BookTabInfo.ReferenceBible, fn, bl, ws, psg, [gmtLookupRefBibles]);
  if status_load < 0 then
  begin
    MessageBeep(MB_ICONEXCLAMATION);
    Exit;
  end;

  // TODO: to figure it out
//  ws := Format('%s '#13#10'<a href="bqnavMw:bqResLnk%s">%s</a><br><hr align=left width=80%%>', [ws, id, psg]);
//
//  doc := mMainView.bwrXRef.DocumentSource;
//  mMainView.bwrXRef.LoadFromString(doc + ws);
//  if mMainView.pgcMain.ActivePage <> mMainView.tbXRef then
//    mMainView.pgcMain.ActivePage := mMainView.tbXRef;
//
//  mMainView.bwrXRef.Position := mMainView.bwrXRef.MaxVertical;
end;

function TBookFrame.GetAutoTxt(btinfo: TBookTabInfo; const cmd: string; maxWords: integer; out fnt: string; out passageSignature: string): string;
var
  autoCmd: Boolean;
  currentModule: TBible;
  prefBible, txt: string;
  bl: TBibleLink;
  status_GetModTxt: integer;
begin
  status_GetModTxt := 1;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;

  if autoCmd then
  begin
    if not Assigned(btinfo) then
    begin
      Result := '';
      Exit;
    end;

    currentModule := btinfo.Bible;
    if (currentModule.ModuleType = bqmBible) then
      prefBible := currentModule.ShortPath
    else
      prefBible := '';
    status_GetModTxt := PreProcessAutoCommand(btinfo, cmd, prefBible, Result);
  end
  else
    Result := cmd;

  if status_GetModTxt > -2 then
  begin
    if Assigned(btinfo) then
    begin
      status_GetModTxt := GetModuleText(
        Result, btinfo.ReferenceBible, fnt, bl, txt, passageSignature,
        [gmtBulletDelimited, gmtEffectiveAddress, gmtLookupRefBibles], maxWords);
    end;
  end;

  if status_GetModTxt >= 0 then
  begin
    Result := txt;
  end
  else
  begin
    Result := 'Не найдено подходящей Библии для отображения отрывка(' + IntToStr(ord(autoCmd)) + ')';
  end;

end;

function TBookFrame.GetModuleText(
  cmd: string;
  refBook: TBible;
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
label lblErrNotFnd;
  function NextRefBible(): Boolean;
  var
    me: TModuleEntry;
  begin
    if currentBibleIx < prefBibleCount then
    begin
      me := GetRefBible(currentBibleIx);
      inc(currentBibleIx);
      refBook.inifile := MainFileExists(me.getIniPath());
      Result := true;
    end
    else
      Result := false;

  end;

begin
  Result := -1;
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
      path := MainFileExists(TPath.Combine(path, 'bibleqt.ini'));
      // try to load the module
      refBook.inifile := path;
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

      status_valid := refBook.LinkValidnessStatus(refBook.inifile, effectiveLnk, false);
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
          txt := txt + DeleteStrongNumbers(refBook.Verses[i - 1]) + delimiter
        else
        begin
          line := StrLimitToWordCnt(
            DeleteStrongNumbers(refBook.Verses[i - 1]),
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
        txt := txt + DeleteStrongNumbers(refBook.Verses[C])
      else
      begin
        if not limited then
        begin
          line := StrLimitToWordCnt(
            DeleteStrongNumbers(refBook.Verses[C]),
            maxWords - wordCounter, wordsAdded, limited);

          txt := txt + line;
        end;
        addEllipsis := limited;
      end;
      if addEllipsis then
        txt := txt + '...';

      if Length(refBook.fontName) > 0 then
      begin
        fontFound := mMainView.mFontManager.PrepareFont(refBook.fontName, refBook.path);
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
        fontName := FontFromCharset(self.Handle, refBook.desiredCharset, bwrHtml.DefFontName);
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

function TBookFrame.GetRefBible(ix: integer): TModuleEntry;
var
  i, cnt, bi: integer;
  me: TModuleEntry;
begin
  cnt := mMainView.mFavorites.mModuleEntries.Count - 1;
  bi := 0;
  me := nil;

  for i := 0 to cnt do
  begin
    me := mMainView.mFavorites.mModuleEntries[i];
    if me.modType = modtypeBible then
      inc(bi);
    if bi > ix then
    begin
      break
    end;
  end;

  if bi > ix then
    Result := me
  else
    Result := nil;
end;

function TBookFrame.RefBiblesCount: integer;
var
  i, cnt: integer;
begin
  cnt := mMainView.mFavorites.mModuleEntries.Count - 1;
  Result := 0;
  for i := 0 to cnt do
    if mMainView.mFavorites.mModuleEntries[i].modType = modtypeBible then
      inc(Result);
end;

procedure TBookFrame.RealignToolBars(AParent: TWinControl);
begin
  EnumControls(AParent, TUITools.RealignToolBars);
end;

procedure TBookFrame.AddBookmarkTagged(tagName: string);
var
  F, t: integer;
  bible: TBible;
begin
  InputForm.tag := 0;

  if mMainView.CurSelStart < mMainView.CurSelEnd then
  begin
    F := mMainView.CurSelStart;
    t := mMainView.CurSelEnd;
  end
  else
  begin
    F := mMainView.CurVerseNumber;
    t := mMainView.CurVerseNumber;
  end;

  bible := BookTabInfo.Bible;
  TagsDbEngine.AddVerseTagged(tagName, bible.CurBook, bible.CurChapter, F, t, bible.ShortPath, true);
end;

procedure TBookFrame.AddThemedBookmarkClick(Sender: TObject);
var
  menuItem: TMenuItem;
begin
  menuItem := TMenuItem(Sender);
  AddBookmarkTagged(menuItem.Caption);
end;

end.
