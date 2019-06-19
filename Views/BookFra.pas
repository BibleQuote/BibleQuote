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
  Vcl.Menus, SearchFra, TagsDb, InputFrm, AppIni, JclNotify, NotifyMessages,
  StrongsConcordance, CommandInterface, CommandFactoryInterface,
  ScriptureProvider, AppStates, ManageFonts;

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
    tbtnResolveLinks: TToolButton;
    pmRecLinksOptions: TPopupMenu;
    miStrictLogic: TMenuItem;
    miFuzzyLogic: TMenuItem;
    tbtnSound: TToolButton;
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

    procedure SafeProcessCommand(bookTabInfo: TBookTabInfo; wsLocation: string; hlOption: TbqHLVerseOption);
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

    procedure RealignToolBars(AParent: TWinControl);

    procedure SelectSatelliteModule();
    procedure tbtnSatelliteMouseEnter(Sender: TObject);
    procedure vdtModulesAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtModulesFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtModulesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vdtModulesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vdtModulesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure tbtnToggleClick(Sender: TObject);
    procedure miChangeLogicClick(Sender: TObject);
    procedure tbtnResolveLinksClick(Sender: TObject);
    procedure tbtnSoundClick(Sender: TObject);
  private
    { Private declarations }
    FMainView: TMainForm;
    FWorkspace: IWorkspace;
    FSatelliteForm: TForm;
    FSatelliteLibraryView: TLibraryFrame;
    FHistoryOn: boolean;
    FCommandFactory: ICommandFactory;
    FScriptureProvider: TScriptureProvider;

    FBrowserSearchPosition: Longint;
    FUpdateOnTreeNodeSelect: boolean;
    pmHistory: PopupFrm.TPopupMenu;
    FNotifier: IJclNotifier;

    FCurFromVerse, FCurToVerse, FVersePosition: Integer;

    FCurVerseNumber, FCurSelStart, FCurSelEnd: Integer;
    FHTMLSelection: string;

    FStrongsConcordance: TStrongsConcordance;

    procedure SetMemosVisible(showMemos: Boolean);

    procedure SearchForward();
    procedure SearchBackward();
    procedure SelectSatelliteBibleByName(const bibleName: string);

    procedure OnSelectSatelliteModule(Sender: TObject; modEntry: TModuleEntry);
    procedure OnSatelliteFormDeactivate(Sender: TObject);

    function OpenChapter: Boolean;
    function IsPsalms(bible: TBible; bookIndex: integer): Boolean;
    function GetChildNodeByIndex(parentNode: PVirtualNode; index: Integer): PVirtualNode;
    function GetChildNodeByBookNumber(aBookNumber: Integer): PVirtualNode;
    function GetChildNodeByChapterNumber(aParentNode: PVirtualNode; aChapterNumber: Integer): PVirtualNode;
    function GetFirstChild(aParentNode: PVirtualNode): PVirtualNode;
    function GetBookNumber(aData: PBookNodeData; aDefault: Integer = 0): Integer;
    function GetChapterNumber(aData: PBookNodeData; aDefault: Integer = 0): Integer;
    function GetBookNumberForNode(aNode: PVirtualNode; aDefault: Integer = 0): Integer;
    function GetChapterNumberForNode(aNode: PVirtualNode; aDefault: Integer = 0): Integer;
    procedure UpdateModuleTreeFont(book: TBible);
    procedure AddBookmarkTagged(tagName: string);
    procedure AddThemedBookmarkClick(Sender: TObject);
    procedure NotifyFontChanged(delta: integer);
    procedure FixBookNumberForLink(var aBibleLnk: TBibleLink; aBible: TBible);
    procedure DisplayCopyrightNotice(bookTabInfo: TBookTabInfo);
    procedure DisplayTitle(bookTabInfo: TBookTabInfo; title: string; fontName: string);
    function GetBookHead(bible: TBible; book: Integer; chapter: Integer; fromverse: Integer; toverse: Integer): String;
    function GetBibleFont(Bible: TBible): String;
    function GetChapterText(bookTabInfo: TBookTabInfo; highlightRange: TPoint; locVerseStart: Integer; locVerseEnd: Integer; chapter: Integer): String;
    function GetParagraphTag(bible: TBible): String;
    function IsParabibleUsed(bookTabInfo: TBookTabInfo): Boolean;
    procedure SetResolveLinks(Resolve: Boolean; FuzzyLogic: Boolean);

    procedure AddBookmark(caption: string);
    function AddMemo(caption: string): Boolean;
    function CopyPassage(fromverse, toverse: integer): string;
    procedure ConvertClipboard;

    procedure CopyVerse();
    procedure CopyPassageToClipboard();
    procedure CompareTranslations();
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; mainView: TMainForm; workspace: IWorkspace); reintroduce;

    property HistoryOn: boolean read FHistoryOn write FHistoryOn;

    function ProcessCommand(bookTabInfo: TBookTabInfo; command: string; hlVerses: TbqHLVerseOption; disableHistory: boolean = false; updateTreeSelection: boolean = true): Boolean; overload;
    function ProcessCommand(Cmd: ICommand; hlVerses: TbqHLVerseOption; disableHistory: boolean = false): Boolean; overload;
    
    procedure AdjustBibleTabs(moduleName: string = '');
    procedure LoadSecondBookByName(const name: string);
    procedure LoadBibleToXref(cmd: string; const id: string);
    function GetAutoTxt(btinfo: TBookTabInfo; const cmd: string; maxWords: integer; out fnt: string; out passageSignature: string): string;
    procedure GoRandomPlace;

    function GetBookTabInfo: TBookTabInfo;
    property BookTabInfo: TBookTabInfo read GetBookTabInfo;
    procedure Translate();
    procedure ApplyConfig(appConfig, oldConfig: TAppConfig);
    procedure EventFrameKeyDown(var Key: Char);
    procedure UpdateModuleTreeSelection(book: TBible);
    procedure UpdateModuleTree(book: TBible);
    function GetCurrentBookNode(): PVirtualNode;
    procedure OpenModule(moduleName: string; fromBeginning: Boolean = false);
    procedure SyncView();
    function GetCurrentBookPassage(): String;

    procedure GoPrevChapter;
    procedure GoNextChapter;
    procedure PlaySound();
    procedure OpenQuickSearch();
    procedure FocusQuickNav();
  end;

implementation

{$R *.dfm}
uses DockTabsFrm, CommandFactory, SelectEntityType;

function TBookFrame.GetBookNumber(aData: PBookNodeData;
  aDefault: Integer): Integer;
begin

  Result := aDefault;

  if not Assigned(aData) then exit;

  if aData.BookNumber > 0 then
    Result := aData.BookNumber;

end;

function TBookFrame.GetBookNumberForNode(aNode: PVirtualNode; aDefault: Integer): Integer;
var
  Data: PBookNodeData;
begin
  Result := aDefault;

  if not Assigned(aNode) then exit;

  Data := vdtModules.GetNodeData(aNode);

  Result := GetBookNumber(Data, aDefault);

end;

function TBookFrame.GetBookTabInfo(): TBookTabInfo;
var
  tabInfo: IViewTabInfo;
begin
  tabInfo := FWorkspace.GetActiveTabInfo();
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
  FSatelliteLibraryView.Translate();
  FSatelliteForm.Caption := Lang.SayDefault('SelectParaBible', 'Select secondary bible');
end;

procedure TBookFrame.ApplyConfig(appConfig, oldConfig: TAppConfig);
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

  if Assigned(BookTabInfo) then
  begin
    if Assigned(BookTabInfo.Bible) then
      UpdateModuleTreeFont(BookTabInfo.Bible);

    if (appConfig.ShowVerseSignatures <> oldConfig.ShowVerseSignatures) then
    begin
      browserpos := bwrHtml.Position;
      ProcessCommand(BookTabInfo, BookTabInfo.Location, TbqHLVerseOption(ord(BookTabInfo[vtisHighLightVerses])));
      bwrHtml.Position := browserpos;
    end;

  end;
end;

function TBookFrame.IsPsalms(bible: TBible; bookIndex: integer): Boolean;
var
  chaptersCount: integer;
begin
  try
    chaptersCount := bible.GetChapterQtys(bookIndex);
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
      bookIndex := GetBookNumber(data, node.Index + 1);
      chapterIndex := GetChapterNumberForNode(GetFirstChild(node), 1);
    end
    else
    begin
      bookIndex :=  GetBookNumber( data, node.Parent.Index + 1);
      chapterIndex := GetChapterNumber(data, node.Index + 1);
    end;

    bible := BookTabInfo.Bible;
    command := Format('go %s %d %d', [bible.ShortPath, bookIndex, chapterIndex]);
    Result := ProcessCommand(BookTabInfo, command, hlDefault, false, false);
  end;
end;

procedure TBookFrame.vdtModulesAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if (FUpdateOnTreeNodeSelect) then
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
  Data: PBookNodeData;
begin
  Level := Sender.GetNodeLevel(Node);
  if Assigned(BookTabInfo) then
  begin
    bible := BookTabInfo.Bible;
    Data := Sender.GetNodeData(Node);
    ChildCount := IfThen(Level = 0, bible.GetChapterQtys(Data.BookNumber), 0);
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

      Data.NodeType := btBook;
      Data.BookNumber := bible.GetBookNumberAt(Node.Index);
      Data.Caption := bible.GetFullNames(  Data.BookNumber );

    end
    else
    begin

      chapterIndex := bible.GetChapterNumberAt(node.Parent.Index, Node.Index);

      if (bible.Trait[bqmtZeroChapter]) and (chapterIndex = 1) and (Length(Trim(bible.ChapterZeroString)) > 0) then
      begin
        chapterString := Trim(bible.ChapterZeroString);
      end
      else
      begin
        bookIndex := bible.GetBookNumberAt(node.Parent.Index);

        if (IsPsalms(bible, bookIndex)) then
          chapterString := Trim(bible.ChapterStringPs)
        else
          chapterString := Trim(bible.ChapterString);

        if (Length(chapterString) > 0) then
          chapterString := chapterString + ' ';

        chapterString := chapterString + IntToStr(chapterIndex - ifthen(bible.Trait[bqmtZeroChapter], 1, 0) );

      end;

      Data.Caption := chapterString;
      Data.NodeType := btChapter;
      Data.BookNumber := bible.GetBookNumberAt(Node.Parent.Index);
      Data.ChapterNumber := bible.GetChapterNumberAt(Node.Parent.Index, Node.Index)
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
  strongNum: Integer;
  isHebrew: Boolean;
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
        bookTabState := FMainView.DefaultBookTabState;
      end
      else
        bookTabState := BookTabInfo.State;

      FMainView.NewBookTab(unicodeSRC, '', bookTabState, '', true);

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

    FMainView.OpenOrCreateTSKTab(BookTabInfo, verse);
  end
  else if Pos('s', unicodeSRC) = 1 then
  begin
    scode := Copy(unicodeSRC, 2, Length(unicodeSRC) - 1);
    if (StrongVal(scode, strongNum, isHebrew)) then
      FMainView.OpenOrCreateStrongTab(BookTabInfo, strongNum, isHebrew);
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
  scode, cmd: string;
  hintText, modPath: string;
  modIx, num: integer;
  isHebrew: boolean;
  res: String;
begin
  if Pos('s', SRC) = 1 then
  begin
    scode := Copy(SRC, 2, Length(SRC) - 1);
    if (StrongVal(scode, num, isHebrew)) then
    begin
      if (FStrongsConcordance.EnsureStrongLoaded) then
      begin
        res := FStrongsConcordance.Lookup(FormatStrong(num, isHebrew));
        viewer.Hint := Trim(StripHtmlMarkup(res));
      end;
      Exit;
    end;
  end;

  if (SRC = '') or (viewer.LinkAttributes.Count < 3) then
  begin
    viewer.Hint := '';
    bwrHtml.Hint := '';
    Application.CancelHint();
    Exit;
  end;

  if Pos(viewer.LinkAttributes[2], 'CLASS=bqResolvedLink') <= 0 then
    Exit;

  cmd := PeekToken(Pointer(src), ' ');
  if SysUtils.CompareText(cmd, 'go') <> 0 then
    Exit;

  if Length(cmd) <= 0 then
    Exit;

  if not Assigned(BookTabInfo) then
    Exit;

  if (viewer <> bwrHtml) and (BookTabInfo.Bible.isBible) then
    modPath := BookTabInfo.Bible.ShortPath
  else
  begin
    modIx := FMainView.mModules.FindByName(BookTabInfo.SatelliteName);
    if modIx < 0 then
      modIx := FMainView.mModules.FindByName(AppConfig.DefaultBible);

    if modIx >= 0 then
      modPath := FMainView.mModules[modIx].ShortPath;
  end;

  hintText := FScriptureProvider.GetLinkHint(src, bwrHtml.DefFontName, modPath);

  viewer.Hint := hintText;
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
    archive := BookTabInfo.Bible.InfoSource.FileName;
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
  FMainView.BrowserPosition := bwrHtml.Position;

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
  FNotifier.Notify(TAppConfigChangedMessage.Create(AppConfig, AppConfig));
end;

procedure TBookFrame.bwrHtmlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  verse: integer;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  if BookTabInfo.LocationType = vtlFile then
    Exit;

  if (Key = VK_NEXT) and (bwrHtml.Position = FMainView.BrowserPosition) then
  begin
    GoNextChapter;
    Exit;
  end;

  if (Key = VK_PRIOR) and (bwrHtml.Position = FMainView.BrowserPosition) then
  begin
    GoPrevChapter;
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
    verse := Get_ANAME_VerseNumber(bwrHtml.DocumentSource, FCurFromVerse, bwrHtml.FindSourcePos(bwrHtml.CaretPos, true));

    FMainView.OpenOrCreateTSKTab(BookTabInfo, verse);
  end;
end;

procedure TBookFrame.bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  num: integer;
  text: string;
  hebrew: boolean;
begin
  if not FMainView.mDictionariesFullyInitialized then
  begin
    FMainView.LoadDictionaries(true);
  end;

  text := Trim(bwrHtml.SelText);
  if StrongVal(text, num, hebrew) then
    FMainView.OpenOrCreateStrongTab(BookTabInfo, num, hebrew)
  else
  begin
    if (text.Length > 0) then
      FMainView.OpenOrCreateDictionaryTab(text);
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
        (bwrHtml.VScrollBarPosition >= FMainView.msbPosition) then
      begin
        if FMainView.mScrollAcc > 2 then
        begin
          lastWheelTime := tm;
          FWorkspace.MakeActive();
          GoNextChapter();
          Handled := true;

        end
        else
          inc(FMainView.mScrollAcc);
      end
      else
        FMainView.mScrollAcc := 0;
    end
    else if WheelDelta > 0 then
    begin
      if (bwrHtml.VScrollBarPosition <= 0) and
        (bwrHtml.VScrollBarPosition <= FMainView.msbPosition) then
      begin
        if FMainView.mScrollAcc > 2 then
        begin
          lastWheelTime := tm;
          FWorkspace.MakeActive();
          GoPrevChapter();
          bwrHtml.PositionTo('endofchapterNMFHJAHSTDGF123');
          Handled := true;
        end
        else
          inc(FMainView.mScrollAcc);

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
end;

constructor TBookFrame.Create(AOwner: TComponent; mainView: TMainForm; workspace: IWorkspace);
begin
  inherited Create(AOwner);
  FMainView := mainView;
  FWorkspace := workspace;
  FCommandFactory := TCommandFactory.Create(mainView, workspace, Self);

  FStrongsConcordance := FMainView.StrongsConcordance;

  FNotifier := mainView.mNotifier;
  FScriptureProvider := TScriptureProvider.Create(mainView);

  FSatelliteForm := TForm.Create(self);
  FSatelliteForm.OnDeactivate := OnSatelliteFormDeactivate;

  FSatelliteLibraryView := TLibraryFrame.Create(nil, FMainView, FWorkspace);
  FSatelliteLibraryView.OnSelectModule := OnSelectSatelliteModule;
  FSatelliteLibraryView.cmbBookType.Enabled := false;
  FSatelliteLibraryView.cmbBookType.ItemIndex := 1;
  FSatelliteLibraryView.Align := TAlign.alClient;
  FSatelliteLibraryView.Parent := FSatelliteForm;

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

  FUpdateOnTreeNodeSelect := true;
  FHistoryOn := true;

  ApplyConfig(AppConfig, AppConfig);
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
  if FMainView.mInterfaceLock then
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
      OpenModule(me.FullName);
    end;
  except
    on E: Exception do
      BqShowException(E);
  end;

  FMainView.tbLinksToolBar.Visible := false;
end;

procedure TBookFrame.dtsBibleClick(Sender: TObject);
var
  pt: TPoint;
  it, modIx: integer;
  me: TModuleEntry;
  s: string;
begin
  if FMainView.mInterfaceLock then
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
    modIx := FMainView.mModules.FindByFolder(BookTabInfo.Bible.ShortPath);
    if modIx >= 0 then
    begin
      me := TModuleEntry(FMainView.mModules.Items[modIx]);
      if FMainView.mFavorites.AddModule(me) then
        AdjustBibleTabs();
    end;
    Exit;
  end;

  me := dtsBible.Tabs.Objects[it] as TModuleEntry;
  if IsDown(VK_SHIFT) then
  begin
    SelectSatelliteBibleByName(me.FullName);
    Exit;
  end;
  if IsDown(VK_MENU) then
  begin
    s := BookTabInfo.Location;
    StrReplace(s, BookTabInfo.Bible.ShortPath, me.ShortPath, false);
    FMainView.NewBookTab(s, BookTabInfo.SatelliteName, BookTabInfo.State, '', true);
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
        modIx := FMainView.mModules.FindByFolder(bookTabInfo.Bible.ShortPath);
        if modIx >= 0 then
        begin
          me := TModuleEntry(FMainView.mModules.Items[modIx]);
          FMainView.mFavorites.AddModule(me);
          AdjustBibleTabs(bookTabInfo.Bible.ShortName);
        end;
        Exit;
      end;
      // replace
      modIx := FMainView.mModules.FindByFolder(bookTabInfo.Bible.ShortPath);
      if modIx < 0 then
        Exit;

      me := TModuleEntry(FMainView.mModules.Items[modIx]);
      if not Assigned(me) then
        Exit;

      FMainView.mFavorites.ReplaceModule(TModuleEntry(dtsBible.Tabs.Objects[TabIndex]), me);
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
    FMainView.mFavorites.MoveItem(me, TabIndex);

    AdjustBibleTabs(bookTabInfo.Bible.ShortName);
    FMainView.SetFavouritesShortcuts();
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
    FMainView.hint_expanded := 0;
  end
  else if FMainView.hint_expanded >= 1 then
    Exit; // same tab hint already expanded

  if (it < 0) or (it = dtsBible.Tabs.Count - 1) then
  begin
    dtsBible.Hint := '';
    Exit
  end;

  me := dtsBible.Tabs.Objects[it] as TModuleEntry;
  ws := me.FullName;

  if FMainView.hint_expanded = 0 then
    FMainView.hint_expanded := 1;
  dtsBible.Hint := ws;
  Application.CancelHint();
end;

procedure TBookFrame.dtsBibleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  itemIx: integer;
begin
  FMainView.miDeteleBibleTab.tag := 0;
  if Button <> mbRight then
    Exit;
  pt.X := X;
  pt.Y := Y;
  itemIx := dtsBible.ItemAtPos(pt);
  if ((itemIx < 0) or (itemIx >= dtsBible.Tabs.Count - 1)) or (dtsBible.Tabs.Count <= 2) then
    Exit;

  FMainView.miDeteleBibleTab.tag := itemIx;
  pt := dtsBible.ClientToScreen(pt);
  FMainView.pmEmpty.Popup(pt.X, pt.Y);
end;

procedure TBookFrame.EventFrameKeyDown(var Key: Char);
begin

end;

procedure TBookFrame.FixBookNumberForLink(var aBibleLnk: TBibleLink; aBible: TBible);
var
  MyBibleBookNumber: Integer;
begin

  if (TSelectEntityType.IsMyBibleFileEntry(aBible.InfoSource.FileName)) then
  begin
    MyBibleBookNumber := aBible.NativeToMyBibleBookNumber(aBibleLnk.book);
    aBibleLnk.book := MyBibleBookNumber;
  end;


end;

procedure TBookFrame.FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
var tabsForm: TDockTabsForm;
begin
  tabsForm := FWorkspace as TDockTabsForm;
  tabsForm.MakeActive;
end;

procedure TBookFrame.miAddBookmarkClick(Sender: TObject);
begin
  AddBookmark(miAddBookmark.Caption);
end;

procedure TBookFrame.miAddMemoClick(Sender: TObject);
begin
  if (AddMemo(miAddMemo.Caption)) then
  begin
    if not AppState.MemosOn then
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
  CompareTranslations();
end;

procedure TBookFrame.miCopyPassageClick(Sender: TObject);
begin
  CopyPassageToClipboard();
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
            Clipboard.AsText := CopyPassage(FCurFromVerse, FCurToVerse);
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
  CopyVerse;
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

  AppState.MemosOn := showMemos;
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
var
  Query: String;
begin
  Query := bwrHtml.SelText;
  if (Trim(Query) <> '') then
  begin
    Query := Copy(Query, 1, 100); // search only the first 100 chars from the selected text
    NavigateToSearch(Query);
  end
  else
    OpenQuickSearch();
end;

procedure TBookFrame.OpenQuickSearch();
var
  inputForm: TInputForm;
begin
  inputForm := TInputForm.CreateText(Lang.SayDefault('QuickSearch', 'Быстрый ввод поисковой фразы'));
  if inputForm.ShowModal = mrOk then
    if Assigned(BookTabInfo) then
      NavigateToSearch(InputForm.GetValue);
end;

procedure TBookFrame.miChangeLogicClick(Sender: TObject);
var
  mi: TMenuItem;
  reload: Boolean;
begin
  mi := Sender as TMenuItem;

  if (Assigned(BookTabInfo)) then
  begin
    reload := not BookTabInfo[vtisResolveLinks] or (BookTabInfo[vtisFuzzyResolveLinks] xor (Sender = miFuzzyLogic));

    if reload then
    begin
      BookTabInfo[vtisPendingReload] := True;
      SetResolveLinks(True, mi = miFuzzyLogic);
    end;
  end;
end;

procedure TBookFrame.NavigateToSearch(searchText: string; bookTypeIndex: integer = -1);
begin
  searchText := Trim(searchText);

  if searchText.Length <= 0 then
    Exit;

  if not Assigned(BookTabInfo) then
    Exit;

  FMainView.OpenOrCreateSearchTab(
    BookTabInfo.Bible.ShortPath,
    searchText,
    bookTypeIndex,
    [soFreeOrder, soContainAll, soWordParts, soIgnoreCase]);
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

  FCurVerseNumber := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, FCurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.RightMouseClickPos, true));

  FCurSelStart := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, FCurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.SelStart, true));

  FCurSelEnd := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, FCurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.SelStart + bwrHtml.SelLength, true));

  if FCurSelStart > FCurSelEnd then
  begin
    i := FCurSelStart;
    FCurSelStart := FCurSelEnd;
    FCurSelEnd := i;
  end;

  miCopyPassage.Visible := (FCurSelStart < FCurSelEnd);

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

  if FCurVerseNumber = 0 then
  begin
    miCompare.Visible := false;
    miCopyVerse.Visible := false;
  end
  else
    with BookTabInfo.Bible do
    begin
      if miCopyPassage.Visible then
        miCopyPassage.Caption := Format('%s  "%s"',
          [FirstWord(miCopyVerse.Caption), FullPassageSignature(CurBook, CurChapter, FCurSelStart, FCurSelEnd)]);

      miCopyVerse.Caption := Format('%s  "%s"',
        [FirstWord(miCopyVerse.Caption), FullPassageSignature(CurBook, CurChapter, FCurVerseNumber, FCurVerseNumber)]);

      scap := miAddBookmark.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);

      miAddBookmark.Caption := Format('%s  "%s"',
        [s, FullPassageSignature(CurBook, CurChapter, FCurVerseNumber, FCurVerseNumber)]);

      scap := miAddMemo.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);

      miAddMemo.Caption := Format(
        '%s  "%s"',
        [s, FullPassageSignature(CurBook, CurChapter, FCurVerseNumber, FCurVerseNumber)]);
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

function TBookFrame.GetFirstChild(aParentNode: PVirtualNode): PVirtualNode;
begin
  Result := vdtModules.GetFirstChild(aParentNode);
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
  GoNextChapter;
end;

procedure TBookFrame.tbtnPrevChapterClick(Sender: TObject);
begin
  GoPrevChapter;
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
  FMainView.GoReference();
end;

procedure TBookFrame.tbtnReferenceInfoClick(Sender: TObject);
var
  CopyrightPath: String;
begin
  CopyrightPath := TPath.Combine(BookTabInfo.Bible.ShortPath, 'copyright.htm');
  CopyrightPath := ResolveFullPath(CopyrightPath);

  if (CopyrightPath <> '') then
  begin
    try
      ProcessCommand(BookTabInfo, 'go ' + ExtractFileDir(CopyrightPath) + ' -1', hlDefault);
    Except
      // do nothing
    end;
  end;
end;

procedure TBookFrame.tbtnResolveLinksClick(Sender: TObject);
var
  ResolveLinks: Boolean;
begin
  ResolveLinks := (vtisResolveLinks in BookTabInfo.State);
  SetResolveLinks(not ResolveLinks, True);
end;

procedure TBookFrame.SetResolveLinks(Resolve: Boolean; FuzzyLogic: Boolean);
var
  BrowserPos: Integer;
  Book: TBible;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  BookTabInfo[vtisResolveLinks] := Resolve;
  BookTabInfo[vtisFuzzyResolveLinks] := FuzzyLogic;

  SyncView();

  Book := BookTabInfo.Bible;
  if (Book.RecognizeBibleLinks <> Resolve) or (BookTabInfo[vtisPendingReload]) then
  begin
    BrowserPos := bwrHtml.Position;

    Book.RecognizeBibleLinks := Resolve;
    Book.FuzzyResolve := FuzzyLogic;

    SafeProcessCommand(BookTabInfo, BookTabInfo.Location, TbqHLVerseOption(ord(BookTabInfo[vtisHighLightVerses])));
    BookTabInfo[vtisPendingReload] := False;
    bwrHtml.Position := BrowserPos;
  end;
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

  FSatelliteLibraryView.UpdateBookList();

  FSatelliteForm.Width := AppConfig.LibFormWidth;
  FSatelliteForm.Height := AppConfig.LibFormHeight;
  FSatelliteForm.Top := AppConfig.LibFormTop;
  FSatelliteForm.Left := AppConfig.LibFormLeft;

  FSatelliteForm.ShowModal();
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
  AppConfig.LibFormWidth := FSatelliteForm.Width;
  AppConfig.LibFormHeight := FSatelliteForm.Height;
  AppConfig.LibFormTop := FSatelliteForm.Top;
  AppConfig.LibFormLeft := FSatelliteForm.Left;
end;

procedure TBookFrame.OnSelectSatelliteModule(Sender: TObject; modEntry: TModuleEntry);
begin
  SelectSatelliteBibleByName(modEntry.FullName);
  PostMessage(FSatelliteForm.Handle, wm_close, 0, 0);
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
  FMainView.GoReference();
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
    FMainView.GoReference();
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

  if FBrowserSearchPosition = 0 then
  begin
    FBrowserSearchPosition := Pos('</title>', string(bwrHtml.DocumentSource));
    if FBrowserSearchPosition > 0 then
      inc(FBrowserSearchPosition, Length('</title>'));
  end;

  i := FindPosition(bwrHtml.DocumentSource, searchText, FBrowserSearchPosition + 1, searchOptions);
  if i > 0 then
  begin
    FBrowserSearchPosition := i;
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
    FBrowserSearchPosition := 0;
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

  i := FindPosition(bwrHtml.DocumentSource, searchText, FBrowserSearchPosition - 1, searchOptions);
  if i > 0 then
  begin
    FBrowserSearchPosition := i;
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
      FBrowserSearchPosition := bwrHtml.DocumentSource.Length - 1
    else
      FBrowserSearchPosition := 0;
  end;
end;

procedure TBookFrame.AdjustBibleTabs(moduleName: string = '');
var
  i, tabCount, tabIx, offset: integer;
  ws: string;
begin

  if Length(moduleName) = 0 then
    moduleName := BookTabInfo.Bible.ShortName;

  offset := ord(FMainView.mBibleTabsInCtrlKeyDownState) shl 1;
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
  if (Assigned(FMainView.mModules)) then
  begin
    ix := FMainView.mModules.FindByName(name);
    if ix >= 0 then
    begin
      ini := ResolveFullPath(TPath.Combine(FMainView.mModules[ix].ShortPath, 'bibleqt.ini'));
      if ini <> BookTabInfo.SecondBible.InfoSource.FileName then
        BookTabInfo.SecondBible.SetInfoSource(ini);

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
    uifont := FontManager.SuggestFont(book.DesiredUIFont, book.path, $7F)
  else
    uifont := FMainView.Font.Name;

  if vdtModules.Font.Name <> uifont then
    vdtModules.Font.Name := uifont;
end;

procedure TBookFrame.UpdateModuleTree(book: TBible);
begin
  vdtModules.Clear;
  UpdateModuleTreeFont(book);

  vdtModules.RootNodeCount := book.BookQty;
end;

procedure TBookFrame.UpdateModuleTreeSelection(book: TBible);
var
  bookNode, chapterNode: PVirtualNode;
  chapterIndex, bookIndex: integer;
begin
  vdtModules.ClearSelection;

  bookIndex := book.GetBookNumberIndex(book.CurBook);
  if (bookIndex < 0) then
    bookIndex := 0;

  bookNode := GetChildNodeByIndex(nil, bookIndex);
  if Assigned(bookNode) then
  begin
    chapterIndex := book.GetChapterNumberIndex(book.CurBook, book.CurChapter);
    if (chapterIndex < 0) then
      chapterIndex := 0;

    chapterNode := GetChildNodeByIndex(bookNode, chapterIndex);

    if Assigned(chapterNode) then
    begin
      if (vdtModules.Selected[chapterNode] = False) then
      begin
        if (vdtModules.Expanded[bookNode] = False) then
          vdtModules.Expanded[bookNode] := True;

        FUpdateOnTreeNodeSelect := false;
        try
          vdtModules.Selected[chapterNode] := True;
        finally
          FUpdateOnTreeNodeSelect := true;
        end;
      end;
    end
    else
    begin
      FUpdateOnTreeNodeSelect := false;
      try
        vdtModules.Selected[bookNode] := True;
      finally
        FUpdateOnTreeNodeSelect := true;
      end;
    end;
  end;
end;

function TBookFrame.GetChapterNumber(aData: PBookNodeData;
  aDefault: Integer): Integer;
begin

  Result := aDefault;

  if not Assigned(aData) then exit;

  if aData.ChapterNumber > 0 then
    Result := aData.ChapterNumber;


end;

function TBookFrame.GetChapterNumberForNode(aNode: PVirtualNode; aDefault: Integer): Integer;
var
  Data: PBookNodeData;
begin
  Result := aDefault;

  if not Assigned(aNode) then exit;

  Data := vdtModules.GetNodeData(aNode);

  Result := GetChapterNumber(Data);

end;

function TBookFrame.GetChildNodeByBookNumber(aBookNumber: Integer): PVirtualNode;
var
  Data: PBookNodeData;
  Node : PVirtualNode;
begin
  Result := nil;

  Node := vdtModules.GetFirst();

  while True do
  begin

    if not Assigned(Node) then exit;
    Data := vdtModules.GetNodeData(Node);

    if (Data.BookNumber = aBookNumber) then
    begin
      Result := Node;
      exit;
    end;

    Node := vdtModules.GetNext(Node);

  end;

end;

function TBookFrame.GetChildNodeByChapterNumber(aParentNode: PVirtualNode;
  aChapterNumber: Integer): PVirtualNode;
var
  Data: PBookNodeData;
  Node : PVirtualNode;
begin
  Result := nil;

  if (vsHasChildren in aParentNode.States) then
  begin
    Node := vdtModules.GetFirstChild(aParentNode);

    while True do
    begin

      if not Assigned(Node) then exit;
      Data := vdtModules.GetNodeData(Node);

      if (Data.ChapterNumber = aChapterNumber) then
      begin
        Result := Node;
        exit;
      end;

      Node := vdtModules.GetNextSibling(Node);

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

function TBookFrame.ProcessCommand(Cmd: ICommand; hlVerses: TbqHLVerseOption; disableHistory: boolean = false): Boolean;
begin
  if disableHistory then
    FHistoryOn := false;

  Result := false;

  if not Assigned(Cmd) then
    Exit;

  Screen.Cursor := crHourGlass;
  FMainView.mInterfaceLock := true;
  try
    bwrHtml.tag := bsText;

    if not (Cmd.Execute(hlVerses)) then
      Exit;

    FWorkspace.UpdateBookTabHeader();

    if (bookTabInfo.Bible.isBible) then
      FNotifier.Notify(TActiveBibleChangedMessage.Create());

    Result := true;
    tbtnSatellite.Enabled := not bookTabInfo.Bible.InfoSource.IsCommentary;

    if not (bookTabInfo.LocationType = vtlFile) then
      AdjustBibleTabs();
  finally
    FMainView.mInterfaceLock := false;
    Screen.Cursor := crDefault;

    if disableHistory then
      FHistoryOn := true;

  end;
end;

function TBookFrame.ProcessCommand(bookTabInfo: TBookTabInfo; command: string; hlVerses: TbqHLVerseOption; disableHistory: boolean = false; updateTreeSelection: boolean = true): Boolean;
var
  Cmd: ICommand;
begin
  Result := False;
  if command = '' then
    Exit; // exit, the command is empty

  Cmd := FCommandFactory.CreateCommand(bookTabInfo, command);
  if not Assigned(Cmd) then
    Exit;
        
  Result := ProcessCommand(Cmd, hlVerses, disableHistory);
  if (Result and updateTreeSelection) then
    UpdateModuleTreeSelection(bookTabInfo.Bible);
end;

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
    if (not FHistoryOn) or ((History.Count > 0) and (History[0] = s)) then
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
  ProcessCommand(bookTabInfo, Format('go %s %d %d %d', [FMainView.mDefaultLocation, 1, 1, 1]), hlDefault);
end;

function TBookFrame.GoAddress(bookTabInfo: TBookTabInfo; var book, chapter, fromverse, toverse: integer; var hlVerses: TbqHLVerseOption): TNavigateResult;
var
  Title, head, Text, Signature: string;
  verse: integer;
  locVerseStart, locVerseEnd: integer;
  i: integer;
  opened, multiHl: Boolean;
  dBrowserSource: string;
  fontName, uiFontName: string;
  HighlightRange: TPoint;
  bible: TBible;
begin
  bible := bookTabInfo.Bible;

  // check and correction of the book number
  HighlightRange := Point(fromverse, toverse);
  Result := nrSuccess;
  locVerseStart := fromverse;
  locVerseEnd := toverse;

  // open copyright if the book number is negative
  if (book < 0) then
  begin
    if (bible.OpenCopyright()) then
    begin
      book := -1;
      chapter := 1;
      fromverse := 0;
      toverse := 0; // reset verse on chapter err

      bwrHtml.Base := bible.path;
      bwrHtml.LoadFromString(bible.GetAllVerses());

      DisplayTitle(bookTabInfo, bible.ShortName, GetBibleFont(bible));
      DisplayCopyrightNotice(bookTabInfo);

      Exit;
    end;
  end;

  // check and correction of the book
  if not bible.IsValidBookNumber(book) then
  begin
    Result := nrBookErr;
    book := bible.GetFirstBookNumber();
  end;

  // check and correct chapter number
  if not bible.IsValidChapterNumber(book, chapter) then
  begin
    Result := nrChapterErr;
    chapter := bible.GetFirstChapterNumber();
  end;

  if Result <> nrSuccess then
  begin
    HighlightRange := Point(0, 0);
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

      HighlightRange := Point(0, 0);
      bible.OpenChapter(1, 1);
      book := 1;
      chapter := 1;
      fromverse := 0;
      locVerseStart := 1;
      toverse := 0;
      locVerseEnd := 0;
    end;
  end;

  // check and correct start verse
  if fromverse > bible.VerseQty then
  begin
    fromverse := 0;
    locVerseStart := 1;
    HighlightRange.X := 0;
    if Result = nrSuccess then
      Result := nrStartVerseErr;
  end;

  // check and correct target verse
  if (toverse > bible.VerseQty) or (toverse < fromverse) then
  begin
    if (toverse < fromverse) and (toverse <= bible.VerseQty) then
    begin
      toverse := HighlightRange.Y;
      HighlightRange.Y := HighlightRange.X;
      HighlightRange.X := toverse;
    end
    else
      HighlightRange.Y := HighlightRange.X;
    toverse := 0;
    locVerseEnd := 0;
    if Result = nrSuccess then
      Result := nrEndVerseErr;
  end;

  if (HighlightRange.X <= 0) and (HighlightRange.Y > 0) then
    HighlightRange.X := HighlightRange.Y;

  if hlVerses = hlFalse then
  begin
    HighlightRange.X := -1;
    HighlightRange.Y := -1;
  end;

  head := GetBookHead(bible, book, chapter, fromverse, toverse);

  Title := '<head>'#13#10'<title>' + head + '</title>'#13#10 + bqPageStyle + #13#10'</head>';

  if Length(bible.DesiredUIFont) > 0 then
    uiFontName := bible.DesiredUIFont
  else
    uiFontName := AppConfig.DefFontName;

  head := '<font face="' + uiFontName + '">' + head + '</font>';

  Text := GetChapterText(bookTabInfo, HighlightRange, locVerseStart, locVerseEnd, chapter);

  dBrowserSource := FMainView.TextTemplate;
  StrReplace(dBrowserSource, '%HEAD%', head, false);
  StrReplace(dBrowserSource, '%TEXT%', Text, false);

  if ((Length(bible.fontName) > 0) and (bible.fontName = bwrHtml.DefFontName)) then
    fontName := bible.fontName
  else
    fontName := '';

  if (Length(fontName) <= 0) then
    fontName := GetBibleFont(bible);

  bwrHtml.DefFontName := fontName;
  StrReplace(dBrowserSource, '<F>', '<font face="' + fontName + '">', true);
  StrReplace(dBrowserSource, '</F>', '</font>', true);

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
  multiHl := (HighlightRange.X > 0) and (HighlightRange.Y > 0) and (HighlightRange.Y <> HighlightRange.X);

  if HighlightRange.X > 0 then
    verse := HighlightRange.X
  else if HighlightRange.Y > 0 then
    verse := HighlightRange.Y
  else
    verse := 0;

  hlVerses := TbqHLVerseOption(ord(verse > 0));
  if (hlVerses = hlTrue) then
    bwrHtml.PositionTo('bqverse' + IntToStr(verse), not multiHl);

  FVersePosition := verse;

  Signature := bible.ShortName + ' ' + bible.FullPassageSignature(book, chapter, fromverse, toverse);

  DisplayTitle(bookTabInfo, Signature, fontName);
  DisplayCopyrightNotice(bookTabInfo);
end;

procedure TBookFrame.GoRandomPlace;
var
  bookIndex, chapterIndex, verseIndex: integer;
  book: TBible;
begin
  book := BookTabInfo.Bible;

  Randomize();
  bookIndex := Random(book.BookQty) + 1;
  chapterIndex := Random(book.GetChapterQtys(bookIndex)) + 1;
  verseIndex := Random(book.CountVerses(bookIndex, chapterIndex)) + 1;

  ProcessCommand(BookTabInfo, Format('go %s %d %d %d', [book.ShortPath, bookIndex, chapterIndex, verseIndex]), hlTrue);
end;

procedure TBookFrame.LoadBibleToXref(cmd: string; const id: string);
var
  fn, ws, psg, doc, ConcreteCmd: string;
  bl: TBibleLink;
  status_load: integer;
begin
  status_load := FScriptureProvider.PreProcessAutoCommand(cmd, BookTabInfo.SecondBible.ShortPath, ConcreteCmd);

  if status_load <= -2 then
    Exit;

  status_load := FScriptureProvider.GetModuleText(ConcreteCmd, bwrHtml.DefFontName, fn, bl, ws, psg, [gmtLookupRefBibles]);
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
    status_GetModTxt := FScriptureProvider.PreProcessAutoCommand(cmd, prefBible, Result);
  end
  else
    Result := cmd;

  if status_GetModTxt > -2 then
  begin
    if Assigned(btinfo) then
    begin
      status_GetModTxt := FScriptureProvider.GetModuleText(
        Result, bwrHtml.DefFontName, fnt, bl, txt, passageSignature,
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

procedure TBookFrame.RealignToolBars(AParent: TWinControl);
begin
  EnumControls(AParent, TUITools.RealignToolBars);
end;

procedure TBookFrame.AddBookmarkTagged(tagName: string);
var
  F, t: integer;
  bible: TBible;
begin
  if FCurSelStart < FCurSelEnd then
  begin
    F := FCurSelStart;
    t := FCurSelEnd;
  end
  else
  begin
    F := FCurVerseNumber;
    t := FCurVerseNumber;
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

procedure TBookFrame.OpenModule(moduleName: string; fromBeginning: Boolean = false);
var
  i: integer;
  firstVisibleVerse: integer;
  wasBible: Boolean;
  me: TModuleEntry;
  bl, obl: TBibleLink;
  blValidAddressExtracted: Boolean;
  path: string;
  hlVerses: TbqHLVerseOption;
  R: integer;
  iniPath: string;
  bible: TBible;
begin
  i := FMainView.mModules.FindByName(moduleName);

  if i < 0 then
  begin
    g_ExceptionContext.Add('In GoModuleName: cannot find specified module name: ' + moduleName);
    raise Exception.Create('Exception mModules.FindByName failed!');
  end;

  me := FMainView.mModules.Items[i];

  hlVerses := hlFalse;
  if not Assigned(BookTabInfo) then
    Exit;

  bible := BookTabInfo.Bible;

  // remember old module's params
  wasBible := bible.isBible;
  blValidAddressExtracted := bl.FromBqStringLocation(BookTabInfo.Location, path);
  if not blValidAddressExtracted then
  begin
    bl.Build(bible.CurBook, bible.CurChapter, BookTabInfo.FirstVisiblePara, 0);
    blValidAddressExtracted := true;
  end
  else
    hlVerses := hlTrue;

  if blValidAddressExtracted then
  begin
    // if valid address
    R := bible.ReferenceToInternal(bl, obl);
    if R <= -2 then
    begin
      obl.Build(1, 1, 0, 0);
      hlVerses := hlFalse;
    end
    else if R = -1 then
    begin
      obl.vend := 0;
    end;
  end;

  bible := TBible.Create(FMainView);

  iniPath := TPath.Combine(me.ShortPath, 'bibleqt.ini');
  bible.SetInfoSource(ResolveFullPath(iniPath));

  if bible.isBible and wasBible and not fromBeginning then
  begin
    R := bible.InternalToReference(obl, bl);
    if R <= -2 then
      hlVerses := hlFalse;
    try
      if (bookTabInfo.FirstVisiblePara > 0) and (bookTabInfo.FirstVisiblePara < bible.verseCount()) then
        firstVisibleVerse := bookTabInfo.FirstVisiblePara
      else
        firstVisibleVerse := -1;

      ProcessCommand(BookTabInfo, bl.ToCommand(bible.ShortPath), hlVerses);

      if firstVisibleVerse > 0 then
      begin
        bwrHtml.PositionTo('bqverse' + IntToStr(firstVisibleVerse), false);
      end;
    except
    end;
  end // both previous and current are bibles
  else
    SafeProcessCommand(bookTabInfo, 'go ' + bible.ShortPath + ' 1 1 0', hlFalse);
end;

procedure TBookFrame.SyncView();
var
  ImageIndex: Integer;
  ResolveLinks, FuzzyLogic, MemosOn: Boolean;
begin
  if Assigned(BookTabInfo) then
  begin
    ResolveLinks := BookTabInfo[vtisResolveLinks];
    FuzzyLogic := BookTabInfo[vtisFuzzyResolveLinks];
    MemosOn := BookTabInfo[vtisShowNotes];

    if ResolveLinks then
      ImageIndex := IfThen(FuzzyLogic, 21, 20)
    else
      ImageIndex := 19;

    tbtnResolveLinks.ImageIndex := ImageIndex;

    miFuzzyLogic.Checked := ResolveLinks and FuzzyLogic;
    miStrictLogic.Checked := ResolveLinks and not FuzzyLogic;

    if (miMemosToggle.Checked <> MemosOn) then
      miMemosToggle.Checked := MemosOn;

    if (tbtnMemos.Down <> MemosOn) then
      tbtnMemos.Down := MemosOn;
  end;
end;

function TBookFrame.IsParabibleUsed(bookTabInfo: TBookTabInfo): Boolean;
var
  modEntry: TModuleEntry;
  Satellite: String;
  IsCommentary: Boolean;
  Bible, SecondBible: TBible;
begin
  Result := False;

  Bible := bookTabInfo.Bible;
  SecondBible := bookTabInfo.SecondBible;

  // search for a secondary Bible if the first module is bible
  if Bible.isBible then
  begin
    IsCommentary := Bible.InfoSource.IsCommentary;
    Satellite := bookTabInfo.SatelliteName;
    if (Satellite = '------') or IsCommentary then
      Result := False
    else
    begin
      modEntry := nil;
      // search in the list of modules
      try
        modEntry := FMainView.mModules.ResolveModuleByNames(Satellite, '');
      except
        on E: Exception do
        begin
          BqShowException(E, Format('Failed to load satellite bible ''%s''', [Satellite]));
        end;
      end;

      if Assigned(modEntry) then
      { // now UseParaBible will be used if satellite text is found... }
      begin
        SecondBible.SetInfoSource(modEntry.GetInfoPath);
        Result := SecondBible.ModuleType = bqmBible;
        // if the primary module displays an NT, and the second one does not contain an NT
        if (((Bible.CurBook < 40) and (Bible.Trait[bqmtOldCovenant])) and (not SecondBible.Trait[bqmtOldCovenant])) or // or if in the primary OT module and the second one does not contain OT
        (((Bible.CurBook > 39) or (Bible.Trait[bqmtNewCovenant] and (not Bible.Trait[bqmtOldCovenant]))) and (not SecondBible.Trait[bqmtNewCovenant])) then
          Result := False;
      end;
      // cancel display
    end;
    // if UseParaBible is found in the list of modules
  end;
end;


function TBookFrame.GetParagraphTag(bible: TBible): String;
begin
  if bible.Trait[bqmtNoForcedLineBreaks] then
    Result := ''
  else
  begin
    if (bible.isBible) then
      Result := ' <BR>'
    else
      Result := '<P>';
  end;
end;

function TBookFrame.GetChapterText(bookTabInfo: TBookTabInfo; highlightRange: TPoint; locVerseStart: Integer; locVerseEnd: Integer; chapter: Integer): String;
var
  Bible, SecondBible: TBible;
  bverse, everse: Integer;
  hlCurrent: Boolean;
  hlVerseStyle: Integer;
  hlstyle, hlParaStart, hlParaEnd: string;
  strVerseNumber: string;
  s, ss: string;
  B, C, V, ib, ic, iv: Integer;
  fistBookCell, SecondbookCell: string;
  ChapterText, MemoText: string;
  Verse, I: Integer;
  fontName: string;
  UseParaBible: Boolean;
  rightAligned, secondRightAligned: Boolean;
  isCommentary, showStrongs: Boolean;
  opened: Boolean;
  paragraph: string;
  TextBuilder: TStringBuilder;
begin
  Bible := bookTabInfo.Bible;
  SecondBible := bookTabInfo.SecondBible;
  rightAligned := bible.UseRightAlignment;

  showStrongs  := bible.isBible and bookTabInfo[vtisShowStrongs];
  isCommentary := bible.isBible and bible.InfoSource.IsCommentary;

  UseParaBible := IsParabibleUsed(bookTabInfo);
  paragraph := GetParagraphTag(bible);

  secondRightAligned := False;
  if (UseParaBible) then
    secondRightAligned := secondBible.UseRightAlignment;

  TextBuilder := TStringBuilder.Create;
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

  FCurFromVerse := bverse;
  FCurToVerse := everse;

  opened := false;

  if UseParaBible then
  begin
    if bible.Trait[bqmtZeroChapter] and (chapter = 1) then
      // in chapter zero in primary view
      UseParaBible := false;
  end;

  if UseParaBible then
  begin
    fontName := GetBibleFont(secondBible);
    bwrHtml.DefFontName := fontName;
  end;

  TextBuilder.Append(bible.ChapterHead);
  for Verse := bverse to everse do
  begin
    s := bible.Verses[Verse - 1];
    if (highlightRange.X > 0) and (highlightRange.Y > 0) and (AppConfig.HighlightVerseHits) then
    begin
      hlCurrent := (Verse <= highlightRange.Y) and (Verse >= highlightRange.X);
      hlVerseStyle := ord(Verse = highlightRange.X) + (ord(Verse = highlightRange.Y) shl 1);
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
    begin
      // if bible display verse numbers
      if AppConfig.ShowVerseSignatures then
        ss := bible.GetShortNames(bible.CurBook) + IntToStr(bible.CurChapter) + ':'
      else
        ss := '';
      strVerseNumber := '<a href="verse ' + strVerseNumber + '" CLASS=OmegaVerseNumber>' + ss + strVerseNumber + '</a>';
      if bible.Trait[bqmtNoForcedLineBreaks] then
        strVerseNumber := '<sup>' + strVerseNumber + '</sup>';
      if bible.Trait[bqmtStrongs] then
      begin
        if (not showStrongs) then
          s := DeleteStrongNumbers(s)
        else
          s := FormatStrongNumbers(s, true);
      end;
    end;
    // if the module is non bible or there is no secondary Bible
    if (not bible.isBible) or (not UseParaBible) then
    begin
      // no satellite text
      if rightAligned then
        TextBuilder.Append(
          Format(''#13''#10'%s<F>%s</F><a name="bqverse%d">%s</a>%s', [hlParaStart, s, Verse, strVerseNumber, hlParaEnd]))
      else
      begin
        if (bible.isBible) and (not bible.Trait[bqmtNoForcedLineBreaks]) then
          TextBuilder.Append(
            Format(''#13''#10'%s<a name="bqverse%d">%s <F>%s</F></a>%s', [hlParaStart, Verse, strVerseNumber, s, hlParaEnd]))
        else
          TextBuilder.Append(
            Format(''#13''#10'%s<a name="bqverse%d">%s <F>%s</F></a>%s', [hlParaStart, Verse, strVerseNumber, s, hlParaEnd]));
      end;

      if (not hlCurrent) or ((hlVerseStyle and 2 > 0) and not bible.isBible) then
        TextBuilder.Append(paragraph);

    end
    else
    begin
      if UseParaBible then
      begin
        // if text is found in the secondary Bible
        try
          with bible do
            ReferenceToInternal(CurBook, CurChapter, Verse, B, C, V);

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

        if rightAligned then
          fistBookCell :=
            '<table width=100% cellpadding=0 border=0 cellspacing=10em >' +
            '<tr style="' + hlstyle + '"><td valign=top width=50% align=right>' +
            Format(''#13''#10'<a name="bqverse%d">%s <F>%s</F> ', [Verse, strVerseNumber, s])
        else
          fistBookCell :=
            '<table width=100% cellpadding=0 border=0 cellspacing=10em >' +
            '<tr style="' + hlstyle + '"><td valign=top width=50% align=left>' +
            Format(''#13''#10'<a name="bqverse%d">%s<F> %s</F></a>', [Verse, strVerseNumber, s]);

        SecondbookCell := '';

        if iv <= SecondBible.verseCount then
        begin
          ss := SecondBible.Verses[iv - 1];
          StrDeleteFirstNumber(ss);
          if SecondBible.Trait[bqmtStrongs] then
            if showStrongs then
              ss := FormatStrongNumbers(ss, true)
            else
              ss := DeleteStrongNumbers(ss);
          if secondRightAligned then
            SecondbookCell := Format('</td><td valign=top width=50%% align=right><font size=1>%d:%d</font><font face="%s">%s</font>', [ic, iv, fontName, ss]) + '</td></tr></table>' + ''#13''#10''
          else
            SecondbookCell := Format('</td><td valign=top width=50%%><font face="Arial" size=1>%d:%d </font><font face="%s">%s</font>', [ic, iv, fontName, ss]) + '</td></tr></table>' + ''#13''#10'';
        end;

        if Length(SecondbookCell) <= 0 then
          SecondbookCell := '</td><td valign=top width=50%> </td></tr></table>'#13''#10'';

        TextBuilder.Append(fistBookCell + SecondbookCell);
      end;
    end;

    // memos...
    if AppState.MemosOn then
    begin
      // if notes are enabled
      with bible do
        // search for 'Быт.1:1 RST $$$' in Memos.
        I := FindString(AppState.Memos, ShortPassageSignature(CurBook, CurChapter, Verse, Verse) + ' ' + ShortName + ' $$$');
      if I > -1 then
      begin
        // found memo
        MemoText := '<font color=' + Color2Hex(AppConfig.SelTextColor) + '>' + Comment(AppState.Memos[Verse]) + '</font>' + paragraph;

        if bookTabInfo[vtisResolveLinks] then
          MemoText := ResolveLinks(MemoText, bookTabInfo[vtisFuzzyResolveLinks]);

        TextBuilder.Append(MemoText);
      end;
    end;
  end;

  ChapterText := TextBuilder.ToString;
  if not UseParaBible then
  begin
    if rightAligned then
      ChapterText := '<div style="text-align:right">' + ChapterText + '</div>'
    else
      ChapterText := '<div style="text-align:justify">' + ChapterText + '</div>';
  end;

  Result := ChapterText;
end;

function TBookFrame.GetBibleFont(Bible: TBible): String;
begin
  if ((Length(Bible.fontName) > 0)) or (Bible.desiredCharset > 2) then
    Result := FontManager.SuggestFont(Bible.fontName, Bible.path, Bible.desiredCharset)
  else
    Result := AppConfig.DefFontName;
end;

function TBookFrame.GetBookHead(bible: TBible; book: Integer; chapter: Integer; fromverse: Integer; toverse: Integer): String;
begin
  if toverse = 0 then
  begin
    // return the entire chapter
    // if only one chapter in the book
    if bible.GetChapterQtys(book) = 1 then
      Result := bible.GetFullNames(book)
    else
      Result := bible.FullPassageSignature(book, chapter, 1, 0);
  end
  else
    Result := bible.FullPassageSignature(book, chapter, fromverse, toverse);
end;

procedure TBookFrame.DisplayTitle(bookTabInfo: TBookTabInfo; title: string; fontName: string);
begin
  FMainView.lblTitle.Font.Name := fontName;
  FMainView.lblTitle.Caption := title;
  FMainView.lblTitle.Hint := title + '   ';

  if Assigned(bookTabInfo) then
  begin
    bookTabInfo.TitleLocation := title;
    bookTabInfo.TitleFont := fontName;
  end;

end;

procedure TBookFrame.DisplayCopyrightNotice(bookTabInfo: TBookTabInfo);
var
  Notice: String;
  Book: TBible;
begin
  if not Assigned(bookTabInfo) then
    Exit;

  Book := bookTabInfo.Bible;
  if Book.Copyright <> '' then
    Notice := '; © ' + Book.Copyright
  else
    Notice := '; ' + Lang.Say('PublicDomainText');

  bookTabInfo.CopyrightNotice := Notice;
end;

procedure TBookFrame.tbtnSoundClick(Sender: TObject);
begin
  PlaySound();
end;

procedure TBookFrame.PlaySound();
var
  book, chapter, verse: integer;
  fname3, fname2: string;
  find: string;
  bible: TBible;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  bible := BookTabInfo.Bible;

  if not bible.isBible then
    Exit;

  bible.InternalToReference(bible.CurBook, bible.CurChapter, 1, book, chapter, verse);

  if bible.SoundDirectory = '' then
  begin // 3 digits
    fname3 := Format('Sounds\%.2d\%.3d', [book, chapter]);
    fname2 := Format('Sounds\%.2d\%.2d', [book, chapter]);
  end
  else
  begin // 2 digits
    fname3 := Format('%s\%.2d\%.3d', [bible.SoundDirectory, book, chapter]);
    fname2 := Format('%s\%.2d\%.2d', [bible.SoundDirectory, book, chapter]);
  end;

  find := ResolveFullPath(fname3 + '.wav');
  if find = '' then
    find := ResolveFullPath(fname3 + '.mp3');
  if find = '' then
    find := ResolveFullPath(fname2 + '.wav');
  if find = '' then
    find := ResolveFullPath(fname2 + '.mp3');

  if find = '' then
    ShowMessage(Format(Lang.Say('SoundNotFound'), [FWorkspace.Browser.DocumentTitle]))
  else
    ShellExecute(Application.Handle, nil, PChar(find), nil, nil, SW_MINIMIZE);
end;

procedure TBookFrame.AddBookmark(caption: string);
var
  newstring: string;
  bible: TBible;
  inputForm: TInputForm;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  bible := BookTabInfo.Bible;
  if bible.verseCount() = 0 then
    bible.OpenChapter(bible.CurBook, bible.CurChapter);
  if bible.Trait[bqmtStrongs] then
    newstring := Trim(DeleteStrongNumbers(bible.Verses[FCurVerseNumber - FCurFromVerse]))
  else
    newstring := Trim(bible.Verses[FCurVerseNumber - FCurFromVerse]);

  StrDeleteFirstNumber(newstring);

  inputForm := TInputForm.CreateMemo(caption, newstring);

  if inputForm.ShowModal = mrOk then
  begin
    with bible do
      newstring :=
        ShortPassageSignature(CurBook, CurChapter, FCurVerseNumber, FCurVerseNumber) + ' ' +
        ShortName + ' ' +
        inputForm.GetValue;

    StrReplace(newstring, #13#10, ' ', true);

    with bible do
      AppState.Bookmarks.Insert(0, Format('go %s %d %d %d %d $$$%s',
        [ShortPath, CurBook, CurChapter, FCurVerseNumber, 0, newstring]));
  end;
end;

function TBookFrame.GetCurrentBookPassage(): String;
begin
  with BookTabInfo.Bible do
    Result := ShortName + ' ' + FullPassageSignature(CurBook, CurChapter, FCurFromVerse, FCurToVerse);
end;

procedure TBookFrame.GoPrevChapter;
var
  cmd: string;
  PrevBook, PrevChapter: Integer;
begin
  FMainView.mScrollAcc := 0;
  if FMainView.sbxPreview.Visible then
  begin
    if FMainView.CurPreviewPage > 0 then
      FMainView.CurPreviewPage := FMainView.CurPreviewPage - 1;
    Exit;
  end;

  if not tbtnPrevChapter.Enabled then
    Exit;

  if not Assigned(BookTabInfo) then
    Exit;

  with BookTabInfo.Bible do
  begin
    GetPrevChapterNumber(CurBook, CurChapter, PrevBook, PrevChapter);
    cmd := Format('go %s %d %d', [ShortPath, PrevBook, PrevChapter])
  end;

  ProcessCommand(BookTabInfo, cmd, hlFalse, true);
  Winapi.Windows.SetFocus(FWorkspace.Browser.Handle);
end;

procedure TBookFrame.GoNextChapter;
var
  cmd: string;
  NextBook, NextChapter: Integer;
begin
  FMainView.mScrollAcc := 0;
  if FMainView.sbxPreview.Visible then
  begin
    if FMainView.CurPreviewPage < MFPrinter.LastAvailablePage - 1 then
      FMainView.CurPreviewPage := FMainView.CurPreviewPage + 1;
    Exit;
  end;

  if not tbtnNextChapter.Enabled then
    Exit;

  if not Assigned(BookTabInfo) then
    Exit;

  with BookTabInfo.Bible do
  begin
    GetNextChapterNumber(CurBook, CurChapter, NextBook, NextChapter);
    cmd := Format('go %s %d %d', [ShortPath, NextBook, NextChapter])
  end;

  ProcessCommand(BookTabInfo, cmd, hlFalse, true);
  Winapi.Windows.SetFocus(FWorkspace.Browser.Handle);
end;

procedure TBookFrame.CopyVerse();
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      Clipboard.AsText := CopyPassage(FCurVerseNumber, FCurVerseNumber);
      ConvertClipboard;
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TBookFrame.CopyPassageToClipboard();
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      Clipboard.AsText := CopyPassage(FCurSelStart, FCurSelEnd);
      ConvertClipboard;
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TBookFrame.CompareTranslations();
var
  book, chapter, verse, ib, ic, iv: integer;
  openSuccess: Boolean;
  s: string;
  dBrowserSource: string;
  fontFound: Boolean;
  fontName: string;
  bibleModuleEntry: TModuleEntry;
  bible, secBible: TBible;
label LoopTail;
begin
  if not Assigned(bookTabInfo) then
    Exit;

  bible := bookTabInfo.Bible;
  if not bible.isBible then
    Exit;

  if (FWorkspace.ChromeTabs.ActiveTabIndex < 0) then
    Exit;

  secBible := bookTabInfo.SecondBible;

  // try
  dBrowserSource := '<font size=+1><table>';
  FWorkspace.Browser.DefFontName := AppConfig.DefFontName;
  bible.OpenChapter(bible.CurBook, bible.CurChapter);
  s := bible.Verses[FCurVerseNumber - 1];
  StrDeleteFirstNumber(s);

  if not (vtisShowStrongs in bookTabInfo.State) then
    s := DeleteStrongNumbers(s);

  AddLine(dBrowserSource,
    Format
    ('<tr><td valign=top><a href="go %s %d %d %d 0">%s&nbsp;%s</a>&nbsp;</td><td valign=top><font face="%s">%s</font></td>'#13#10,
    [bible.ShortPath, bible.CurBook, bible.CurChapter, FCurVerseNumber,
    bible.ShortName, bible.ShortPassageSignature(bible.CurBook,
    bible.CurChapter, FCurVerseNumber, FCurVerseNumber),
    bible.fontName, s]));

  AddLine(dBrowserSource, '<tr><td></td><td><hr width=100%></td></tr>'#13#10);
  bibleModuleEntry := FMainView.mModules.ModTypedAsFirst(modtypeBible);
  while Assigned(bibleModuleEntry) do
  begin
    s := bibleModuleEntry.GetInfoPath();
    secBible.SetInfoSource(s);

    // don't display New Testament mixed with Old Testament...
    if (bible.CurBook < 40) and (bible.Trait[bqmtOldCovenant]) and (not secBible.Trait[bqmtOldCovenant]) then
      goto LoopTail;

    if (bible.CurBook > 39) and (bible.Trait[bqmtNewCovenant]) and (not secBible.Trait[bqmtNewCovenant]) then
      goto LoopTail;

    with bible do
      ReferenceToInternal(CurBook, CurChapter, FCurVerseNumber, book, chapter, verse);

    secBible.InternalToReference(book, chapter, verse, ib, ic, iv);

    try
      openSuccess := secBible.OpenChapter(ib, ic);
    except
      openSuccess := false

    end;
    if not openSuccess then
      goto LoopTail;
    if iv > secBible.verseCount() then
      goto LoopTail;

    s := secBible.Verses[iv - 1];
    StrDeleteFirstNumber(s);

    if not (vtisShowStrongs in bookTabInfo.State) then
      s := DeleteStrongNumbers(s);

    if Length(secBible.fontName) > 0 then
    begin
      fontFound := FontManager.PrepareFont(secBible.fontName, secBible.path);
      fontName := secBible.fontName;
    end
    else
      fontFound := false;
    // if there is no preferred font or it is not found and the encoding is specified
    if not fontFound and (secBible.desiredCharset >= 2) then
    begin
      // find the font with the desired encoding
      if Length(secBible.fontName) > 0 then
        fontName := secBible.fontName
      else
        fontName := AppConfig.DefFontName;
      fontName := FontFromCharset(secBible.desiredCharset, fontName);
    end;

    AddLine(dBrowserSource,
      Format('<tr><td valign=top><a href="go %s %d %d %d 0">%s&nbsp;%s</a>&nbsp;' +
      '<BR><SPAN STYLE="font-size:67%%">%s</SPAN></td><td valign=top><font face="%s">%s</font></td></tr>'#13#10,
      [secBible.ShortPath, ib, ic, iv, secBible.ShortName,
      secBible.ShortPassageSignature(ib, ic, iv, iv), secBible.Name,
      fontName, s]));
  LoopTail:
    bibleModuleEntry := FMainView.mModules.ModTypedAsNext(modtypeBible);
  end;

  AddLine(dBrowserSource, '</table>');
  FWorkspace.Browser.LoadFromString(dBrowserSource);

  bookTabInfo.IsCompareTranslation := true;
  bookTabInfo.CompareTranslationText := dBrowserSource;
end;

function TBookFrame.AddMemo(caption: string): Boolean;
var
  newstring, signature: string;
  i: integer;
  inputForm: TInputForm;
begin
  Result := false;

  with BookTabInfo.Bible do
    signature := ShortPassageSignature(CurBook, CurChapter, FCurVerseNumber, FCurVerseNumber) + ' ' + ShortName + ' $$$';

  // search for 'Быт.1:1 RST $$$' in Memos.
  i := FindString(AppState.Memos, signature);

  if i > -1 then // found memo
    newstring := Comment(AppState.Memos[i])
  else
    newstring := '';

  inputForm := TInputForm.CreateMemo(caption, newstring);

  if inputForm.ShowModal = mrOk then
  begin
    newstring := inputForm.GetValue;
    StrReplace(newstring, #13#10, ' ', true);

    if i > -1 then
      AppState.Memos.Delete(i); // for SORTED WideString, first delete it...

    if Trim(newstring) <> '' then
      AppState.Memos.Add(signature + newstring);

    Result := true;
  end;
end;

function TBookFrame.CopyPassage(fromverse, toverse: integer): string;
var
  i: integer;
  s: string;
  shiftDown: Boolean;
  bible: TBible;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  bible := bookTabInfo.Bible;

  Result := '';
  for i := fromverse to toverse do
  begin
    s := bible.Verses[i - 1];
    StrDeleteFirstNumber(s);

    if bible.Trait[bqmtStrongs] and not (vtisShowStrongs in bookTabInfo.State) then
      s := DeleteStrongNumbers(s);

    if (AppConfig.AddVerseNumbers xor (IsDown(VK_CONTROL))) and
      (fromverse > 0) and (fromverse <> toverse) then
    begin
      if AppConfig.AddReference and (AppConfig.AddReferenceChoice = 0) then
      begin
        with bible do
          s := ShortPassageSignature(CurBook, CurChapter, i, i) + ' ' + s;

        if AppConfig.AddModuleName then
          s := bible.ShortName + ' ' + s;
      end
      else
      begin
        if not IsSpaceEndedString(s) then
          s := s + ' ';

        s := IntToStr(i) + ' ' + s;
      end;
    end;

    if AppConfig.AddLineBreaks then
    begin
      shiftDown := IsDown(VK_SHIFT);
      if (AppConfig.AddFontParams xor shiftDown) then
      begin
        s := s + '<br>'#13#10;
      end
      else
        s := s + #13#10;
      Result := Result + s;
    end
    else
      Result := Result + ' ' + s;
  end;

  if AppConfig.AddReference and (AppConfig.AddReferenceChoice > 0) then
  begin
    if not AppConfig.AddLineBreaks then
      Result := Result + ' ('
    else
      Result := Result + '(';

    if AppConfig.AddModuleName then
      Result := Result + bible.ShortName + ' ';

    with bible do
      if AppConfig.AddReferenceChoice = 1 then
        Result := Result + ShortPassageSignature(CurBook, CurChapter, fromverse, toverse) + ')'
      else
        Result := Result + FullPassageSignature(CurBook, CurChapter, fromverse, toverse) + ')';
  end;

  s := ParseHTML(Result, '');

  if not AppConfig.AddLineBreaks then
    StrReplace(s, #13#10, ' ', true);

  StrReplace(s, '  ', ' ', true);
  StrReplace(s, '  ', ' ', true);
  StrReplace(s, '  ', ' ', true);
  if (AppConfig.AddFontParams xor IsDown(VK_SHIFT)) then
  begin
    FHTMLSelection := Result;
    InsertDefaultFontInfo(FHTMLSelection, AppConfig.DefFontName, AppConfig.DefFontSize);
  end
  else
    FHTMLSelection := '';

  Result := s;
end;

procedure TBookFrame.ConvertClipboard;
var
  bible: TBible;
  reClipboard: TRichEdit;
begin
  if not Assigned(BookTabInfo) then
    Exit;

  bible := BookTabInfo.Bible;

  if not (AppConfig.AddFontParams xor IsDown(VK_SHIFT)) then
    Exit;

  if Length(FHTMLSelection) > 0 then
    CopyHTMLToClipBoard('', FHTMLSelection)
  else
  begin
    reClipboard := TRichEdit.Create(Self);

    try
      if bible.fontName <> '' then
        reClipboard.Font.Name := bible.fontName
      else
        reClipboard.Font.Name := AppConfig.DefFontName;

      reClipboard.Font.Size := AppConfig.DefFontSize;
      reClipboard.Lines.Add(Clipboard.AsText);

      reClipboard.SelectAll;
      reClipboard.SelAttributes.CharSet := bwrHtml.CharSet;
      reClipboard.SelAttributes.Name := reClipboard.Font.Name;
      reClipboard.CopyToClipboard;
    finally
      reClipboard.Free;
    end;
  end;
end;

procedure TBookFrame.FocusQuickNav();
begin
  try
    if Self.Visible then
      tedtReference.SetFocus;
  except
    // do nothing
  end;
end;

end.
