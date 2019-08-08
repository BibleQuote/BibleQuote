﻿unit MainFrm;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, Classes,
  ShlObj, contnrs, Clipbrd,
  Graphics, Controls,
  Forms, System.UITypes,
  ComCtrls, Generics.Collections,
  Menus, IOUtils, Math, SystemInfo,
  ExtCtrls, AppEvnts, ImgList, CoolTrayIcon, Dialogs,
  VirtualTrees, ToolWin, StdCtrls, IOProcs,
  Buttons, DockTabSet, Htmlview, SysUtils, SysHot, HTMLViewerSite,
  Bible, BibleQuoteUtils, ICommandProcessor, WinUIServices, TagsDb,
  VdtEditlink, bqGradientPanel, MultiLanguage, LinksParserIntf, HTMLEmbedInterfaces,
  NativeDict, Vcl.Tabs, System.ImageList, HTMLUn2, FireDAC.DatS,
  TabData, Favorites, ThinCaptionedDockTree,
  Vcl.CaptionedDockTree, LayoutConfig,
  ChromeTabs, ChromeTabsTypes, ChromeTabsUtils, ChromeTabsControls, ChromeTabsClasses,
  ChromeTabsLog, ManageFonts, BroadcastList, JclNotify, NotifyMessages,
  AppIni, Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  StrongsConcordance, DataScanning, AppStates, DictInterface, DataServices,
  InfoSource, PreviewUtils;

const

  MAXHISTORY = 100;
  {
    такие увеличенные размеры позволяют сохранять ПРОПОРЦИИ окна
    координаты окна программы вычисляются в относительных единицах
  }
  MAXWIDTH = 25600; // 25600 делится на 640, 800 и 1024
  MAXHEIGHT = 218400; // делится на 480, 600 и 728

  bsText = 0;
  bsFile = 1;
  bsBookmark = 2;
  bsMemo = 3;
  bsHistory = 4;
  bsSearch = 5;

  Skips20 = '<A NAME="#endofchapterNMFHJAHSTDGF123">' +
    '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>';

  DefaultTextTemplate = '<h1>%HEAD%</h1>' + #13#10#13#10 + '<font size=+1>' +
    #13#10 + '%TEXT%' + #13#10 + '</font>' + #13#10#13#10 + Skips20;

  DefaultSelTextColor = '#FF0000';

type
  TControlProc = reference to procedure (const AControl: TControl);
  TBookNodeType = (btChapter, btBook);
  PBookNodeData = ^TBookNodeData;

  TBookNodeData = record
    Caption: string;
    NodeType: TBookNodeType;
    BookNumber: Integer;
    ChapterNumber: Integer;
  end;

  TNavigateResult = (
    nrSuccess,
    nrEndVerseErr,
    nrStartVerseErr,
    nrChapterErr,
    nrBookErr,
    nrModuleFail);

  TgmtOption = (gmtBulletDelimited, gmtEffectiveAddress, gmtLookupRefBibles);
  TgmtOptions = set of TgmtOption;

type
  TMainForm = class(TForm, IBibleQuoteCommandProcessor, IBibleWinUIServices)
    OpenDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    pnlModules: TPanel;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    pmRef: TPopupMenu;
    miRefCopy: TMenuItem;
    miRefPrint: TMenuItem;
    pmEmpty: TPopupMenu;
    trayIcon: TCoolTrayIcon;
    ilImages: TImageList;
    tlbPanel: TGradientPanel;
    tlbMain: TToolBar;
    tbtnLastSeparator: TToolButton;
    cbLinks: TComboBox;
    miDeteleBibleTab: TMenuItem;
    tbLinksToolBar: TToolBar;
    lblTitle: TLabel;
    miOpenNewView: TMenuItem;
    appEvents: TApplicationEvents;
    reClipboard: TRichEdit;
    tbtnDownloadModules: TToolButton;
    pnlStatusBar: TPanel;
    imgLoadProgress: TImage;
    tbtnNewForm: TToolButton;
    tbtnAddMemoTab: TToolButton;
    tbtnAddLibraryTab: TToolButton;
    tbtnAddBookmarksTab: TToolButton;
    tbtnAddSearchTab: TToolButton;
    tbtnAddTagsVersesTab: TToolButton;
    tbtnAddDictionaryTab: TToolButton;
    tbtnAddStrongTab: TToolButton;
    imgCollection: TImageCollection;
    vimgIcons: TVirtualImageList;
    tbtnAddCommentsTab: TToolButton;
    tbtnOptions: TToolButton;
    tbtnPreviewPrint: TToolButton;
    tbtnAbout: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure FormShow(Sender: TObject);
    procedure cbLinksChange(Sender: TObject);
    procedure bwrDicHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure miRefPrintClick(Sender: TObject);
    procedure miRefCopyClick(Sender: TObject);
    procedure trayIconClick(Sender: TObject);
    procedure SysHotKeyHotKey(Sender: TObject; Index: integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miDeteleBibleTabClick(Sender: TObject);

    procedure FormDeactivate(Sender: TObject);
    procedure cbModulesCloseUp(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LoadFontFromFolder(awsFolder: string);
    procedure miOpenNewViewClick(Sender: TObject);
    procedure pmRefPopup(Sender: TObject);
    procedure appEventsException(Sender: TObject; E: Exception);

    function LoadAnchor(wb: THTMLViewer; SRC, current, loc: string): Boolean;
    procedure pmRecLinksOptionsChange(Sender: TObject; Source: TMenuItem; Rebuild: Boolean);
    procedure imgLoadProgressClick(Sender: TObject);

    function CreateNewBookTabInfo(): TBookTabInfo;
    function CreateWorkspace(viewName: string): IWorkspace;
    procedure CreateInitialWorkspace();
    function GenerateWorkspaceName(): string;
    procedure OnTabsFormActivate(Sender: TObject);
    procedure OnTabsFormClose(Sender: TObject; var Action: TCloseAction);


    procedure bwrDicHotSpotCovered(Sender: TObject; const SRC: string);
    procedure tbtnNewFormClick(Sender: TObject);

    procedure BookChangeModule(Sender: TObject);
    procedure tbtnAddMemoTabClick(Sender: TObject);
    procedure tbtnAddBookmarksTabClick(Sender: TObject);
    procedure tbtnAddSearchTabClick(Sender: TObject);
    procedure tbtnAddTagsVersesTabClick(Sender: TObject);
    procedure tbtnAddDictionaryTabClick(Sender: TObject);
    procedure tbtnAddStrongTabClick(Sender: TObject);
    procedure tbtnAddLibraryTabClick(Sender: TObject);
    procedure tbtnAddCommentsTabClick(Sender: TObject);
    procedure tbtnDownloadModulesClick(Sender: TObject);
    procedure tbtnOptionsClick(Sender: TObject);
    procedure tbtnPreviewPrintClick(Sender: TObject);
    procedure tbtnAboutClick(Sender: TObject);
  private
    FStrongsConcordance: TStrongsConcordance;

    procedure NavigeTSKTab;
    procedure ActivateTargetWorkspace();
    procedure AddNewWorkspace;
    procedure OpenNewWorkspace;
    procedure PassKeyToActiveLibrary(var Key: Char);
    function CreateBookTabInfo(book: TBible): TBookTabInfo;
    procedure InitModuleScanner();
    procedure InitHtmlTemplate;
    procedure ShowCurrentModulePrintPreview();

    procedure OnDictsLoaded(var Msg: TMessage); message PROCESS_DICTS_LOADED;
    procedure OnModulesLoaded(var Msg: TMessage); message PROCESS_MODULES_LOADED;
  public
    SysHotKey: TSysHotKey;

    mTaggedBookmarksLoaded: Boolean;
    mDefaultLocation: string;
    mBibleTabsInCtrlKeyDownState: Boolean;

    mIcn: TIcon;
    mFavorites: TFavoriteModules;
    mInterfaceLock: Boolean;
    hint_expanded: integer; // 0 -not set, 1-short , 2-expanded

    msbPosition: integer;
    mScrollAcc: integer;
    mscrollbarX: integer;
    mHTMLViewerSite: THTMLViewerSite;

    mScanner: TModulesScanner;
    mDictScanner: TDictScanner;

    mTranslated: Boolean;

    mWorkspace: IWorkspace;
    mWorkspaces: TList<IWorkspace>;

    mNotifier: IJclNotifier;

    DataService: TDataService;
    BrowserPosition: Longint; // this helps PgUp, PgDn to scroll chapters...

    FRunOnce: Boolean; // for only one entrance into .FormShow

    TemplatePath: string;
    TextTemplate: string; // displaying passages

    LastLink: TBibleLink;
    LastBibleLink: TBibleLink;
    LastIsBible: Boolean;
    LastBiblePath: String;

    G_XRefVerseCmd: string;

    procedure WMQueryEndSession(var Message: TWMQueryEndSession); message WM_QUERYENDSESSION;

    function CreateNewBibleInstance(): TBible;

    procedure UpdateBookView();
    procedure ClearCopyrights();

    procedure SetFirstTabInitialLocation(
      wsCommand, wsSecondaryView: string;
      const Title: string;
      state: TBookTabInfoState;
      visual: Boolean);

    procedure SaveWorkspaces();
    procedure LoadWorkspaces();

    function NewBookTab(
      const command: string;
      const satellite: string;
      state: TBookTabInfoState;
      const Title: string;
      activate: Boolean;
      changeWorkspace: Boolean = false;
      history: TStrings = nil;
      historyIndex: integer = -1): Boolean;

    procedure OpenOrCreateTSKTab(bookTabInfo: TBookTabInfo; goverse: integer = 0);
    procedure OpenOrCreateBookTab(const command: string; const satellite: string; state: TBookTabInfoState; processCommand: boolean = true);
    procedure OpenOrCreateDictionaryTab(const searchText: string; aActiveDictName: String = '');
    procedure OpenOrCreateStrongTab(bookTabInfo: TBookTabInfo; number: Integer; isHebrew: Boolean);
    procedure OpenOrCreateSearchTab(bookPath: string; searchText: string; bookTypeIndex: integer = -1; SearchOptions: TSearchOptions = []);

    procedure StartScanModules();
    function LoadHotModulesConfig(): Boolean;
    procedure SaveHotModulesConfig();
    function AddHotModule(const modEntry: TModuleEntry; tag: integer; addBibleTab: Boolean = true): integer;
    function FavoriteTabFromModEntry(workspace: IWorkspace; const me: TModuleEntry): integer;
    procedure DeleteHotModule(moduleTabIx: integer); overload;
    function DeleteHotModule(const me: TModuleEntry): Boolean; overload;
    function ReplaceHotModule(const oldMe, newMe: TModuleEntry): Boolean;
    function InsertHotModule(newMe: TModuleEntry; ix: integer): integer;

    procedure SaveMru();
    procedure LoadMru();
    procedure ForceForegroundLoad();
    function DefaultLocation(): string;

    function RefBiblesCount(): integer;
    procedure FontChanged(delta: integer);

    procedure Translate();
    function TranslateInterface(locFile: string): Boolean;
    function LoadLocalizationFile(locFile: string): boolean;
    function LoadLocalization(): boolean;

    procedure LoadConfiguration;
    procedure SaveConfiguration;
    procedure SetBibleTabsHintsState(showHints: Boolean = true);
    procedure InitModules(updateCache: Boolean);
    procedure ActivateModuleView(aModuleEntry: TModuleEntry);

    function ChooseColor(color: TColor): TColor;

    procedure OnHotModuleClick(Sender: TObject);

    procedure ShowSearchTab();
    procedure UpdateUIForType(tabType: TViewTabType);
    procedure EnableBookTools(enable: boolean);

    procedure ModifyControl(const AControl: TControl; const ARef: TControlProc);
    procedure SyncChildrenEnabled(const AControl: TControl);

    procedure ShowConfigDialog;
    procedure ShowQuickSearch;

    procedure SetVScrollTracker(aBrwsr: THTMLViewer);
    procedure VSCrollTracker(Sender: TObject);
    procedure EnableToolbarMenus(aEnabled: Boolean);
    procedure EnableToolbars(aEnabled: Boolean);
    procedure EnableToolbarButtons(aToolBar: TToolBar; aEnabled: Boolean);

    procedure DeferredReloadViewPages();
    procedure AppOnHintHandler(Sender: TObject);
    function GetMainWindow(): TForm; // IbibleQuoteWinUIServices
    function GetIViewerBase(): IHtmlViewerBase; // IbibleQuoteWinUIServices
    function GetNotifier: IJclNotifier;

    procedure InitializeTaggedBookMarks();
    procedure InitHotkeysSupport();
    procedure CheckModuleInstall();
    procedure TranslateConfigForm;
    procedure TranslateControl(form: TWinControl; fname: string = '');
    procedure GoReference();
    function DefaultBookTabState(): TBookTabInfoState;

    property StrongsConcordance: TStrongsConcordance read FStrongsConcordance;
  public
    mHandCur: TCursor;

    procedure MouseWheelHandler(var Message: TMessage); override;
    function PassWordFormShowModal(const aModule: WideString; out Pwd: WideString; out savePwd: Boolean): integer;

    function GetAutoTxt(
      btInfo: TBookTabInfo;
      const cmd: string;
      maxWords: integer;
      out fnt: string;
      out passageSignature: string): string;
  end;

var
  MainForm: TMainForm;
  G_ControlKeyDown: Boolean;

implementation

uses InputFrm, ConfigFrm, PasswordDlg,
  BibleQuoteConfig, ExceptionFrm, AboutFrm, ShellAPI, StrUtils, CommCtrl,
  DockTabsFrm, HintTools, BookFra, TSKFra, DictionaryFra,
  Types, BibleLinkParser, IniFiles, PlainUtils, GfxRenderers, CommandProcessor,
  StringProcs, LinksParser, StrongFra, SearchFra, AppPaths,
  DownloadModulesFrm, ScriptureProvider;

{$R *.DFM}

function GetDockWorkspace(mainForm: TMainForm): TDockTabsForm;
begin
  if not Assigned(mainForm.mWorkspace) then
    Result := nil
  else
    Result := mainForm.mWorkspace as TDockTabsForm;
end;

function GetBookView(mainForm: TMainForm): TBookFrame;
var dockView: TDockTabsForm;
begin
  dockView := GetDockWorkspace(mainForm);
  if not Assigned(dockView) then
    Result := nil
  else
    Result := dockView.BookView as TBookFrame;
end;

procedure ClearVolatileStateData(var state: TBookTabInfoState);
begin
  state := state * [vtisShowNotes, vtisShowStrongs, vtisResolveLinks, vtisFuzzyResolveLinks];
end;

function TMainForm.DefaultBookTabState(): TBookTabInfoState;
begin
  Result := [vtisShowNotes, vtisResolveLinks];
end;

procedure TMainForm.OnHotModuleClick(Sender: TObject);
var
  bookView: TBookFrame;
begin
  bookView := GetBookView(self);
  if Assigned(bookView) then
    bookView.OpenModule((Sender as TMenuItem).Caption);
end;

procedure TMainForm.LoadConfiguration;
var
  fnt: TFont;
begin
  try
    try
      AppConfig.Load;
    except
      on E: Exception do
        BqShowException(E, 'Cannot Load Configuration file!');
    end;

    fnt := TFont.Create;
    fnt.Name := AppConfig.MainFormFontName;
    fnt.Size := AppConfig.MainFormFontSize;

    MainForm.Font := fnt;

    Screen.HintFont.Assign(fnt);
    Screen.HintFont.Height := Screen.HintFont.Height * 5 div 4;
    Application.HintColor := $FDF9F4;

    MainForm.Update;
    fnt.Free;

    Prepare(ExtractFilePath(Application.ExeName) + 'biblebooks.cfg', Output);

    mFavorites := TFavoriteModules.Create(AddHotModule, DeleteHotModule, ReplaceHotModule, InsertHotModule, ForceForegroundLoad);

    SaveFileDialog.InitialDir := AppConfig.SaveDirectory;

    AppState.Load();

    LoadMru();

    trayIcon.MinimizeToTray := AppConfig.MinimizeToTray;
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

function TMainForm.GetAutoTxt(
  btInfo: TBookTabInfo;
  const cmd: string;
  maxWords: integer;
  out fnt: string;
  out passageSignature: string): string;
var
  bookView: TBookFrame;
begin
  Result := '';
  bookView := GetBookView(self);
  if Assigned(bookView) then
    Result := bookView.GetAutoTxt(btInfo, cmd, maxWords, fnt, passageSignature);
end;

procedure TMainForm.InitHtmlTemplate;
var
  TemplateFile: String;
begin
  // load HTML template from file, if exists
  TemplatePath := TPath.Combine(TAppDirectories.Root, 'templates\default\');

  TemplateFile := TPath.Combine(TemplatePath, 'text.htm');
  if FileExists(TemplateFile) then
    TextTemplate := TextFromFile(TemplateFile)
  else
    TextTemplate := DefaultTextTemplate;

  if not StrReplace(TextTemplate, 'background="', 'background="' + TemplatePath, false) then
    StrReplace(TextTemplate, 'background=', 'background=' + TemplatePath, false);

  if not StrReplace(TextTemplate, 'src="', 'src="' + TemplatePath, false) then
    StrReplace(TextTemplate, 'src=', 'src=' + TemplatePath, false);
end;

function TMainForm.CreateBookTabInfo(book: TBible): TBookTabInfo;
var
  tabInfo: TBookTabInfo;
begin
  tabInfo := TBookTabInfo.Create(book, '', '', '', DefaultBookTabState);
  tabInfo.SecondBible := TBible.Create();
  Result := tabInfo;
end;

procedure TMainForm.OpenNewWorkspace;
var
  tabsForm: TDockTabsForm;
  I: Integer;
begin
  tabsForm := CreateWorkspace(GenerateWorkspaceName) as TDockTabsForm;

  mWorkspace := tabsForm;

  tabsForm.BibleTabs.Tabs.Clear;
  tabsForm.BibleTabs.Tabs.Add('***');

  for I := 0 to mFavorites.mModuleEntries.Count - 1 do
  begin
    tabsForm.BibleTabs.Tabs.Insert(I, mFavorites.mModuleEntries[I].VisualSignature);
    tabsForm.BibleTabs.Tabs.Objects[I] := mFavorites.mModuleEntries[I];
  end;

  tabsForm.Translate;
  tabsForm.ManualDock(pnlModules);
  tabsForm.Show;

  Windows.SetFocus(tabsForm.Handle);
end;

procedure TMainForm.AddNewWorkspace;
var
  bookView: TBookFrame;
  bookTabInfo: TBookTabInfo;
begin
  OpenNewWorkspace();

  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;

  if not Assigned(bookTabInfo) then
  begin
    bookTabInfo := CreateNewBookTabInfo;
  end;
  if Assigned(bookTabInfo) then
  begin
    NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, bookTabInfo.State, '', true);
  end;
end;

procedure TMainForm.NavigeTSKTab;
var
  bookView: TBookFrame;
  bookTabInfo: TBookTabInfo;
begin
  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;

  if Assigned(bookTabInfo) then
    OpenOrCreateTSKTab(bookTabInfo, 1);
end;

function TMainForm.CreateWorkspace(viewName: string): IWorkspace;
var
  tabsForm: TDockTabsForm;
  h: Integer;
begin
  tabsForm := TDockTabsForm.Create(self, self);
  tabsForm.SetViewName(viewName);

  SetVScrollTracker(tabsForm.Browser);

  (tabsForm.BookView as TBookFrame).miMemosToggle.Checked := AppState.MemosOn;
  tabsForm.BibleTabs.Font.Assign(self.Font);

  h := self.Font.Height;
  if h < 0 then
    h := -h;

  tabsForm.BibleTabs.Height := h + 13;
  tabsForm.Caption := '';
  tabsForm.OnActivate := self.OnTabsFormActivate;
  tabsForm.OnClose := self.OnTabsFormClose;

  mWorkspaces.Add(tabsForm as IWorkspace);

  Result := tabsForm;
end;

function TMainForm.GenerateWorkspaceName(): string;
var guid: TGUID;
begin
  CreateGUID(guid);
  Result := 'DockTabsForm_' + Format('%0.8X%0.4X%0.4X%0.2X%0.2X%0.2X%0.2X%0.2X%0.2X%0.2X%0.2X',
       [guid.D1, guid.D2, guid.D3,
       guid.D4[0], guid.D4[1], guid.D4[2], guid.D4[3],
       guid.D4[4], guid.D4[5], guid.D4[6], guid.D4[7]]);
end;

procedure TMainForm.CreateInitialWorkspace();
var
  tabsForm: TDockTabsForm;
  tabInfo: TBookTabInfo;
begin
  tabsForm := CreateWorkspace(GenerateWorkspaceName()) as TDockTabsForm;

  tabInfo := CreateNewBookTabInfo();

  mWorkspace := tabsForm;
  tabsForm.AddBookTab(tabInfo);

  tabsForm.ManualDock(pnlModules);
  tabsForm.Show;
end;

procedure TMainForm.OnTabsFormClose(Sender: TObject; var Action: TCloseAction);
var
  workspace: TDockTabsForm;
begin
  if (Sender is TDockTabsForm) then
  begin
    workspace := Sender as TDockTabsForm;
    mWorkspaces.Remove(workspace as IWorkspace);

    if (mWorkspaces.Count > 0) then
    begin
      if (mWorkspaces[0] is TDockTabsForm) then
        OnTabsFormActivate(mWorkspaces[0] as TDockTabsForm);
    end
    else
      mWorkspace := nil;

  end;
end;

procedure TMainForm.OnTabsFormActivate(Sender: TObject);
var
  tabsForm: TDockTabsForm;
  tabInfo: IViewTabInfo;
begin
  tabsForm := Sender as TDockTabsForm;

  if Assigned(tabsForm) then
  begin
    if (mWorkspace <> tabsForm as IWorkspace) then
    begin
      mWorkspace := tabsForm;

      // restore active tab state
      tabInfo := tabsForm.GetActiveTabInfo();
      if Assigned(tabInfo) then
        tabInfo.RestoreState(tabsForm);

      UpdateUIForType(tabInfo.GetViewType);
    end;
  end;
end;

procedure TMainForm.OnDictsLoaded(var Msg: TMessage);
begin
  mNotifier.Notify(TDictionariesLoadedMessage.Create);
end;

procedure TMainForm.OnModulesLoaded(var Msg: TMessage);
var
  WarnMessage: String;
  I: Integer;
begin
  UpdateBookView();

  imgLoadProgress.Hide();
  if (DataService.BrokenModules.Count > 0) then
  begin
    WarnMessage := Lang.SayDefault('bqBrokenModulesFound', 'Следующие модули не могут быть загружены, так как повреждены или не соответствуют формату:');
    AddLine(WarnMessage, '');

    for I := 0 to DataService.BrokenModules.Count - 1 do
      AddLine(WarnMessage, ExtractFileName(DataService.BrokenModules[I]));

    MessageBox(
        Self.Handle,
        Pointer(WarnMessage),
        Pointer(Lang.SayDefault('bqBrokenModulesFoundTitle', 'Предупреждение')),
        MB_OK or MB_ICONWARNING);
  end;

  mNotifier.Notify(TModulesLoadedMessage.Create);
end;

procedure TMainForm.LoadFontFromFolder(awsFolder: string);
var
  sr: TSearchRec;
  R: integer;
  searchPath: string;
begin
  try
    searchPath := TPath.Combine(awsFolder, '*.ttf');
    R := FindFirst(searchPath, faArchive or faReadOnly or faHidden, sr);
    if R <> 0 then
      Exit; // abort;
    repeat
      FontManager.PrepareFont(FileRemoveExtension(sr.Name), awsFolder);
      R := FindNext(sr);
    until R <> 0;

  finally
    FindClose(sr);
  end;

end;

function TMainForm.LoadHotModulesConfig(): Boolean;
var
  fn1, fn2: string;
  f1Exists, f2Exists: Boolean;
  workspace: IWorkspace;
begin
  try

    Result := false;
    for workspace in mWorkspaces do
    begin
        workspace.BibleTabs.Tabs.Clear();
        workspace.BibleTabs.Tabs.Add('***');
    end;

    fn1 := TPath.Combine(TAppDirectories.UserSettings, C_HotModulessFileName);
    f1Exists := FileExists(fn1);
    if f1Exists then
    begin
      mFavorites.LoadModules(DataService.Modules, fn1)
    end
    else
    begin
      fn2 := TPath.Combine(TAppDirectories.UserSettings, 'hotlist.txt');
      f2Exists := FileExists(fn2);
      if f2Exists then
      begin
        mFavorites.LoadModules(DataService.Modules, fn2)
      end
    end;

  except
    on E: Exception do
    begin
      BqShowException(E);
      Result := false;
    end
  end;

end;

procedure TMainForm.SaveHotModulesConfig();
begin
  mFavorites.SaveModules(TPath.Combine(TAppDirectories.UserSettings, C_HotModulessFileName));
end;

procedure TMainForm.StartScanModules();
var
  icn: TIcon;
begin
  try
    icn := TIcon.Create;
    ilImages.GetIcon(33, icn);
    imgLoadProgress.Picture.Graphic := icn;
    imgLoadProgress.Show();

    DataService.ScanModulesAsync;
    DataService.ScanDictsAsync;

  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure TMainForm.SaveMru;
var
  mi: TMemIniFile;

  procedure WriteLst(lst: TStrings; const section: string);
  var
    i, C: integer;
    sc: string;

  begin
    try
      C := lst.Count - 1;
      sc := section;

      for i := 0 to C do
      begin
        mi.WriteString(sc, Format('Item%.3d', [i]), lst[i]);
      end;
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
  end;

begin
  mi := nil;

  // TODO: Save search requests
//  mi := TMemIniFile.Create(UserDir + 'mru.lst', TEncoding.UTF8);
//  mi.Clear();
//  try
//
//    WriteLst(cbSearch.Items, cbSearch.Name);
//    WriteLst(mslSearchBooksCache, 'SearchBooks');
//    mi.UpdateFile();
//  finally
//    mi.Free();
//  end;

end;

procedure TMainForm.LoadMru;
var
  mi: TMemIniFile;
  sl: TStringList;
  sectionVals: TStringList;

  procedure LoadLst(lst: TStrings; const section: string);
  var
    i, C: integer;
    sc: string;
    Val: string;
  begin
    try
      lst.Clear();
      sc := section;
      mi.ReadSectionValues(sc, sectionVals);
      C := sectionVals.Count - 1;
      if C > 400 then
        C := 400;

      for i := 0 to C do
      begin
        Val := sectionVals.ValueFromIndex[i];
        if lst.IndexOf(Val) < 0 then
          lst.Add(Val);
      end;

    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
  end;

begin
  mi := nil;
  // TODO: Load search requests
//  mi := TMemIniFile.Create(UserDir + 'mru.lst', TEncoding.UTF8);
//  sl := TStringList.Create();
//  sectionVals := TStringList.Create();
//  try
//
//    LoadLst(cbSearch.Items, cbSearch.Name);
//    LoadLst(mslSearchBooksCache, 'SearchBooks');
//
//  finally
//    mi.Free();
//    sl.Free();
//    sectionVals.Free();
//  end;

end;

function DecodeBookTabState(Val: UInt64): TBookTabInfoState;
var
  trimmed: UInt64;
begin
  if Val > 1000 then
    Result := [vtisFuzzyResolveLinks]
  else
    Result := [];
  trimmed := (Val mod 1000); // effectively extract fist 3 digits
  if (trimmed > 100) then
    Include(Result, vtisResolveLinks);
  if (trimmed mod 100) >= 10 then
    Include(Result, vtisShowStrongs);
  if odd(trimmed) then
    Include(Result, vtisShowNotes);
end;

procedure TMainForm.LoadWorkspaces();
var
  tabIx, i, activeTabIx: integer;
  location, secondBible, Title: string;
  addTabResult, firstTabInitialized: Boolean;
  tabViewState: TBookTabInfoState;
  layoutConfig: TLayoutConfig;
  tabSettings: TTabSettings;
  workspaceSettings: TWorkspaceSettings;
  tabsForm: TDockTabsForm;
  fileStream: TFileStream;
  tabsConfigPath, layoutConfigPath: string;
  tabState: UInt64;
  bookTabSettings: TBookTabSettings;
  history: TStrings;
  tabsConfigOk: boolean;
begin
  tabsConfigPath := TPath.Combine(TAppDirectories.UserSettings, 'tabs_config.json');
  layoutConfigPath := TPath.Combine(TAppDirectories.UserSettings, 'layout_forms.dat');

  firstTabInitialized := false;
  try
    tabsConfigOk := true;
    if (not FileExists(tabsConfigPath)) then
      tabsConfigOk := false;

    layoutConfig := nil;
    if (tabsConfigOk) then
      layoutConfig := TLayoutConfig.Load(tabsConfigPath);

    if not Assigned(layoutConfig) then
      tabsConfigOk := false;

    if not (tabsConfigOk) then
    begin
      CreateInitialWorkspace();
      SetFirstTabInitialLocation(AppConfig.LastCommand, '', '', DefaultBookTabState(), true);
      Exit;
    end;

    for workspaceSettings in layoutConfig.WorkspaceSettingsList do
    begin
      activeTabIx := -1;
      tabIx := 0;
      i := 0;

      tabsForm := CreateWorkspace(workspaceSettings.ViewName) as TDockTabsForm;

      if (workspaceSettings.Docked) then
        tabsForm.ManualDock(pnlModules)
      else
      begin
        tabsForm.Left := workspaceSettings.Left;
        tabsForm.Top := workspaceSettings.Top;
        tabsForm.Height := workspaceSettings.Height;
        tabsForm.Width := workspaceSettings.Width;
      end;

      tabsForm.Show;
      mWorkspace := tabsForm;

      for tabSettings in workspaceSettings.GetOrderedTabSettings() do
      begin
        if (tabSettings.Active) then
          activeTabIx := i;

        addTabResult := false;
        if (tabSettings is TBookTabSettings) then
        begin
          bookTabSettings := TBookTabSettings(tabSettings);

          secondBible := bookTabSettings.SecondBible;
          Title := bookTabSettings.Title;
          tabState := bookTabSettings.OptionsState;
          if (tabState <= 0) then
            tabState := 101;

          tabViewState := DecodeBookTabState(tabState);

          location := bookTabSettings.Location;
          history := TStringList.Create;

          if (bookTabSettings.History.Length > 0) then
          begin
            history.Delimiter := '|';
            history.DelimitedText := bookTabSettings.History;
          end;

          addTabResult := NewBookTab(location, secondBible, tabViewState, Title, (tabIx = activeTabIx) or ((Length(Title) = 0)), false, history, bookTabSettings.HistoryIndex);
        end
        else if (tabSettings is TMemoTabSettings) then
        begin
          mWorkspace.AddMemoTab(TMemoTabInfo.Create());
          addTabResult := true;
        end
        else if (tabSettings is TLibraryTabSettings) then
        begin
          mWorkspace.AddLibraryTab(TLibraryTabInfo.Create(TLibraryTabSettings(tabSettings)));
          addTabResult := true;
        end
        else if (tabSettings is TBookmarksTabSettings) then
        begin
          mWorkspace.AddBookmarksTab(TBookmarksTabInfo.Create());
          addTabResult := true;
        end
        else if (tabSettings is TSearchTabSettings) then
        begin
          mWorkspace.AddSearchTab(TSearchTabInfo.Create(TSearchTabSettings(tabSettings)));
          addTabResult := true;
        end
        else if (tabSettings is TTSKTabSettings) then
        begin
          mWorkspace.AddTSKTab(TTSKTabInfo.Create(TTSKTabSettings(tabSettings)));
          addTabResult := true;
        end
        else if (tabSettings is TTagsVersesTabSettings) then
        begin
          mWorkspace.AddTagsVersesTab(TTagsVersesTabInfo.Create(TTagsVersesTabSettings(tabSettings)));
          addTabResult := true;
        end
        else if (tabSettings is TDictionaryTabSettings) then
        begin
          mWorkspace.AddDictionaryTab(TDictionaryTabInfo.Create(TDictionaryTabSettings(tabSettings)));
          addTabResult := true;
        end
        else if (tabSettings is TStrongTabSettings) then
        begin
          mWorkspace.AddStrongTab(TStrongTabInfo.Create(TStrongTabSettings(tabSettings)));
          addTabResult := true;
        end
        else if (tabSettings is TCommentsTabSettings) then
        begin
          mWorkspace.AddCommentsTab(TCommentsTabInfo.Create(TCommentsTabSettings(tabSettings)));
          addTabResult := true;
        end;

        firstTabInitialized := true;
        if (addTabResult) then
          inc(tabIx);

        inc(i);
      end;

      if (activeTabIx < 0) or (activeTabIx >= mWorkspace.ChromeTabs.Tabs.Count) then
          activeTabIx := 0;

      mWorkspace.ChromeTabs.ActiveTabIndex := activeTabIx;
      mWorkspace.UpdateBookView();
    end;

    if (firstTabInitialized and TFile.Exists(layoutConfigPath)) then
    begin
        fileStream := TFileStream.Create(layoutConfigPath, fmOpenRead);
        pnlModules.DockManager.LoadFromStream(fileStream);
        fileStream.Free;
    end;

  except
    on E: Exception do
      BqShowException(E);
  end;

  if not firstTabInitialized then
  begin
    CreateInitialWorkspace();
    SetFirstTabInitialLocation(AppConfig.LastCommand, '', '', DefaultBookTabState(), true);
  end;
end;

function TMainForm.CreateNewBookTabInfo(): TBookTabInfo;
begin
  Result := CreateBookTabInfo(CreateNewBibleInstance());
end;

procedure TMainForm.SaveConfiguration;
begin
  try
    writeln(NowDateTimeString(), ':SaveConfiguration, userdir:', TAppDirectories.UserSettings);

    SaveWorkspaces();
    try
      DataService.Modules.SaveToFile(TPath.Combine(TAppDirectories.UserSettings, C_CachedModsFileName));
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;

    if MainForm.WindowState = wsMaximized then
      AppConfig.MainFormMaximized := true
    else
    begin
      AppConfig.MainFormMaximized := false;
      AppConfig.MainFormWidth := MainForm.Width;
      AppConfig.MainFormHeight := MainForm.Height;
      AppConfig.MainFormLeft := MainForm.Left;
      AppConfig.MainFormTop := MainForm.Top;
    end;

    try
      SaveHotModulesConfig();
    except
      on E: Exception do
        BqShowException(E)
    end;

    AppConfig.AddVerseNumbers := ConfigForm.chkCopyVerseNumbers.Checked;
    AppConfig.AddFontParams := ConfigForm.chkCopyFontParams.Checked;
    AppConfig.AddReference := ConfigForm.chkCopyFontParams.Checked;
    AppConfig.AddReferenceChoice := ConfigForm.rgAddReference.ItemIndex;
    AppConfig.AddLineBreaks := ConfigForm.chkAddLineBreaks.Checked;
    AppConfig.AddModuleName := ConfigForm.chkAddModuleName.Checked;
    AppConfig.ShowVerseSignatures := ConfigForm.chkShowVerseSignatures.Checked;

    AppConfig.MinimizeToTray := trayIcon.MinimizeToTray;
    AppConfig.SaveDirectory := SaveFileDialog.InitialDir;

    AppConfig.Save;

    AppState.Save;

    try
      SaveMru();
    except
      on E: Exception do
        BqShowException(E)
    end;
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TMainForm.SaveWorkspaces();
var
  tabCount, i: integer;
  tabInfo, activeTabInfo: IViewTabInfo;
  layoutConfig: TLayoutConfig;
  workspaceSettings: TWorkspaceSettings;
  tabSettings: TTabSettings;
  tabsForm: TDockTabsForm;
  workspace: IWorkspace;
  fileStream: TFileStream;
  data: TObject;
begin
  try
    layoutConfig := TLayoutConfig.Create;
    for workspace in mWorkspaces do
    begin
      tabsForm := workspace as TDockTabsForm;
      workspaceSettings := TWorkspaceSettings.Create;

      if (workspace.ChromeTabs.Tabs.Count = 0) then
        continue;

      tabCount := workspace.ChromeTabs.Tabs.Count;

      if (workspace = mWorkspace) then
        workspaceSettings.Active := true;

      workspaceSettings.ViewName := tabsForm.ViewName;
      workspaceSettings.Docked := not tabsForm.Floating;
      if not (workspaceSettings.Docked) then
      begin
        workspaceSettings.Left := tabsForm.Left;
        workspaceSettings.Top := tabsForm.Top;
        workspaceSettings.Width := tabsForm.Width;
        workspaceSettings.Height := tabsForm.Height;
      end;

      activeTabInfo := workspace.GetActiveTabInfo();
      activeTabInfo.SaveState(workspace);
      for i := 0 to tabCount - 1 do
      begin
        try
          data := workspace.ChromeTabs.Tabs[i].Data;
          if not Supports(data, IViewTabInfo, tabInfo) then
            continue;

          tabSettings := tabInfo.GetSettings;

          if tabInfo = activeTabInfo then
          begin
            tabSettings.Active := true;
          end;
          tabSettings.Index := i;
          workspaceSettings.AddTabSettings(tabSettings);
        except
        end;
      end; // for
      layoutConfig.WorkspaceSettingsList.Add(workspaceSettings);
    end;

    layoutConfig.Save(TPath.Combine(TAppDirectories.UserSettings, 'tabs_config.json'));

    fileStream := TFileStream.Create(TPath.Combine(TAppDirectories.UserSettings, 'layout_forms.dat'), fmCreate);
    pnlModules.DockManager.SaveToStream(fileStream);
    fileStream.Free;

  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FStrongsConcordance := TStrongsConcordance.CreateDefault();

  mNotifier := TJclBaseNotifier.Create;

  FRunOnce := false; // prohibit re-entry into FormShow
  mWorkspaces := TList<IWorkspace>.Create;

  CheckModuleInstall();

  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Application.HintHidePause := 1000 * 60;
  Application.OnHint := AppOnHintHandler;

  HintWindowClass := HintTools.TbqHintWindow;

  Lang := TMultiLanguage.Create(self);

  LoadConfiguration;

  InitHotkeysSupport();
  InitializeTaggedBookMarks();

  if AppConfig.MainFormWidth = 0 then
  begin
    Self.WindowState := wsMaximized;
    Self.Position := poScreenCenter;
  end
  else
  begin
    Self.Position := poDefault;
    Self.Width := AppConfig.MainFormWidth;
    Self.Height := AppConfig.MainFormHeight;
    Self.Left := AppConfig.MainFormLeft;
    Self.Top := AppConfig.MainFormTop;

    if AppConfig.MainFormMaximized then
      Self.WindowState := wsMaximized
    else
      Self.WindowState := wsNormal;
  end;

  InitHtmlTemplate();

  LoadLocalization();

  InitModuleScanner();
  InitModules(false);

  LoadWorkspaces();
  LoadHotModulesConfig();

  LoadFontFromFolder(TLibraryDirectories.Strong);

  mTranslated := TranslateInterface(AppConfig.LocalizationFile);

  Application.OnActivate := self.OnActivate;
  Application.OnDeactivate := self.OnDeactivate;
end;

procedure TMainForm.InitModuleScanner();
var
  scanBook: TBible;
begin
  scanBook := TBible.Create();

  mScanner := TModulesScanner.Create(scanBook);
  mScanner.SecondDirectory := AppConfig.SecondPath;

  mDictScanner := TDictScanner.Create();

  DataService := TDataService.Create(mScanner, mDictScanner, Self.Handle);
end;

function TMainForm.GetIViewerBase(): IHtmlViewerBase;
begin
  if not Assigned(mHTMLViewerSite) then
    mHTMLViewerSite := THTMLViewerSite.Create(self, self);

  Result := mHTMLViewerSite;
end;

function TMainForm.GetNotifier: IJclNotifier;
begin
  Result := mNotifier;
end;

function TMainForm.GetMainWindow: TForm;
begin
  Result := self;
end;

function TMainForm.AddHotModule(const modEntry: TModuleEntry; tag: integer; addBibleTab: Boolean = true): integer;
var
  ix: integer;
  workspace: IWorkspace;
begin
  Result := -1;
  try
    if not addBibleTab then
      Exit;

    for workspace in mWorkspaces do
    begin
      ix := workspace.BibleTabs.Tabs.Count - 1;

      workspace.BibleTabs.Tabs.Insert(ix, modEntry.VisualSignature());
      workspace.BibleTabs.Tabs.Objects[ix] := modEntry;
    end;
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure SetButtonHint(aButton: TToolButton; aMenuItem: TMenuItem);
begin
  aButton.Hint := aMenuItem.Caption + ' (' + ShortCutToText(aMenuItem.ShortCut) + ')';
end;

function TMainForm.LoadLocalization(): boolean;
var
  locDirectory: string;
  locFilePath: string;
  loaded: Boolean;
  F: TSearchRec;
  langPattern, langFile: string;
  langFiles: TStrings;
begin
  loaded := false;

  locDirectory := TAppDirectories.Localization;
  locFilePath := TPath.Combine(locDirectory, AppConfig.LocalizationFile);

  // try to apply localization file from app config
  if (AppConfig.LocalizationFile <> '') and (TFile.Exists(locFilePath)) then
    loaded := LoadLocalizationFile(AppConfig.LocalizationFile);

  if not loaded then
  begin
    langPattern := TPath.Combine(locDirectory, '*.lng');

    // get all localization files
    langFiles := TStringList.Create;
    try

      if FindFirst(langPattern, faAnyFile, F) = 0 then
      begin
        repeat
          langFile := F.Name;
          langFiles.Add(F.Name);

          // check if file is default localization file
          if (langFile = C_DefaultLanguageFile) then
          begin
            // try to apply it
            loaded := LoadLocalizationFile(langFile);
            if (loaded) then
              AppConfig.LocalizationFile := C_DefaultLanguageFile;

            break;
          end;

        until FindNext(F) <> 0;
        FindClose(F);
      end;

      if (not loaded) and (langFiles.Count > 0) then
      begin
        // try to apply the first found localization file
        loaded := LoadLocalizationFile(langFiles[0]);
        if (loaded) then
          AppConfig.LocalizationFile := langFiles[0];
      end;
    finally
      langFiles.Free;
    end;
  end;

  Result := loaded;
end;

function TMainForm.LoadLocalizationFile(locFile: string): boolean;
var
  locDirectory: string;
  locFilePath: string;
begin
  Result := false;
  locDirectory := TAppDirectories.Localization;
  locFilePath := TPath.Combine(locDirectory, locFile);
  try
    Result := Lang.LoadIniFile(locFilePath);
  except
    on E: Exception do
    begin
      BqShowException(E, 'In translate interface hard error');
      Exit;
    end
  end;
end;

procedure TMainForm.Translate();
var
  s: string;
  workspace: IWorkspace;
  tabsForm: TDockTabsForm;
  bookView: TBookFrame;
  InfoSource: TInfoSource;
begin
  TranslateControl(ExceptionForm);
  TranslateControl(AboutForm);

  for workspace in mWorkspaces do
  begin
    if (workspace is TDockTabsForm) then
    begin
      tabsForm := workspace as TDockTabsForm;
      tabsForm.Translate;
    end;
  end;

  TranslateConfigForm;

  LockWindowUpdate(self.Handle);

  try
    Lang.TranslateControl(MainForm);
  finally
    LockWindowUpdate(0);
  end;

  bookView := GetBookView(self);

  if Assigned(bookView) then
    bookView.tbtnMemos.Hint := bookView.miMemosToggle.Caption + ' (' + ShortCutToText(bookView.miMemosToggle.ShortCut) + ')';

  Application.Title := MainForm.Caption;
  trayIcon.Hint := MainForm.Caption;

  if Assigned(bookView.BookTabInfo) then
  begin
    InfoSource := bookView.BookTabInfo.Bible.Info;
    if Assigned(InfoSource) then
    begin
      try
        with bookView.BookTabInfo.Bible do
          s := bookView.GetCurrentBookPassage;

        if InfoSource.Copyright <> '' then
          s := s + '; © ' + InfoSource.Copyright
        else
          s := s + '; ' + Lang.Say('PublicDomainText');

        lblTitle.Hint := s + '   ';

        if Length(lblTitle.Hint) < 83 then
          lblTitle.Caption := lblTitle.Hint
        else
          lblTitle.Caption := Copy(lblTitle.Hint, 1, 80) + '...';
      except
        // skip error
      end;

      bookView.UpdateModuleTree(bookView.BookTabInfo.Bible);
    end;
  end;

  Update;

end;

function TMainForm.TranslateInterface(locFile: string): Boolean;
begin
  result := LoadLocalizationFile(locFile);

  if not result then
    Exit;

  Translate();
end;

procedure TMainForm.EnableToolbarMenus(aEnabled: Boolean);
var
  i: integer;
begin
  for i := 0 to MainForm.ComponentCount - 1 do
  begin
    if MainForm.Components[i] is TMenuItem then
      (MainForm.Components[i] as TMenuItem).Enabled := aEnabled;
  end;
end;

procedure TMainForm.EnableToolbars(aEnabled: Boolean);
begin
  EnableToolbarButtons(tlbMain, aEnabled);
  EnableToolbarButtons(tbLinksToolBar, aEnabled);
end;

procedure TMainForm.EnableToolbarButtons(aToolBar: TToolBar; aEnabled: Boolean);
var
  i: integer;
begin
  for i := 0 to aToolBar.ButtonCount - 1 do
  begin
    aToolBar.Buttons[i].Enabled := aEnabled;
  end;
end;

procedure TMainForm.SetBibleTabsHintsState(showHints: Boolean);
var
  i, num, bibleTabsCount, curItem: integer;
  s: string;
  saveOnChange: TTabChangeEvent;
  workspace: IWorkspace;
begin
  for workspace in mWorkspaces do
  begin
    bibleTabsCount := workspace.BibleTabs.Tabs.Count - 1;
    curItem := workspace.BibleTabs.TabIndex;
    if bibleTabsCount > 9 then
      bibleTabsCount := 9
    else
      Dec(bibleTabsCount);
    for i := 0 to bibleTabsCount do
    begin
      s := workspace.BibleTabs.Tabs[i];
      if showHints then
      begin
        if (i < 9) then
          num := i + 1
        else
          num := 0;
        workspace.BibleTabs.Tabs[i] := Format('%d-%s', [num, s]);
      end
      else
      begin
        if (s[2] <> '-') or (not CharInSet(Char(s[1]), ['0' .. '9'])) then
          break;
        workspace.BibleTabs.Tabs[i] := Copy(s, 3, $FFFFFF);
      end;
    end; // for

    if showHints then
    begin
      workspace.BibleTabs.FirstIndex := 0;
      workspace.BibleTabs.TabIndex := curItem;
    end
    else
    begin
      saveOnChange := workspace.BibleTabs.OnChange;
      workspace.BibleTabs.OnChange := nil;
      if curItem > 0 then
        workspace.BibleTabs.TabIndex := curItem - 1;
      workspace.BibleTabs.TabIndex := curItem;
      workspace.BibleTabs.OnChange := saveOnChange;
    end;

  end;

  mBibleTabsInCtrlKeyDownState := showHints;
end;

procedure TMainForm.SetFirstTabInitialLocation(
  wsCommand, wsSecondaryView: string;
  const Title: string;
  state: TBookTabInfoState;
  visual: Boolean);
var
  vti: TBookTabInfo;
  bookView: TBookFrame;
begin
  if Length(wsCommand) > 0 then
    AppConfig.LastCommand := wsCommand;

  bookView := GetBookView(self);

  ClearVolatileStateData(state);

  vti := bookView.BookTabInfo;
  vti.SatelliteName := wsSecondaryView;
  vti.State := state;
  vti.Title := Title;
  vti.Location := AppConfig.LastCommand;

  vti.Bible.RecognizeBibleLinks := vtisResolveLinks in state;
  vti.Bible.FuzzyResolve := vtisFuzzyResolveLinks in state;

  mWorkspace.ChromeTabs.Tabs[0].Caption := Title;

  if visual then
  begin
    AppState.MemosOn := vtisShowNotes in state;
    bookView.SafeProcessCommand(vti, AppConfig.LastCommand, hlDefault);
    UpdateBookView();
  end
  else
  begin
    vti.StateEntryStatus[vtisPendingReload] := true;
  end;

end;

procedure TMainForm.SetVScrollTracker(aBrwsr: THTMLViewer);
begin
  try
    aBrwsr.VScrollBar.OnChange := self.VSCrollTracker;
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TMainForm.pmRecLinksOptionsChange(Sender: TObject; Source: TMenuItem; Rebuild: Boolean);
begin
  //
end;

procedure TMainForm.PassKeyToActiveLibrary(var Key: Char);
begin
  if mWorkspaces.Count > 0 then
  begin
    if (mWorkspace.GetActiveTabInfo().GetViewType() <> vttLibrary) then exit;

    mWorkspace.LibraryView.EventFrameKeyDown(Key);

  end;
  
end;

function TMainForm.PassWordFormShowModal(const aModule: WideString; out Pwd: WideString; out savePwd: Boolean): integer;
var
  modName: string;
  i: integer;
  modShortPath: string;
begin
  Result := mrCancel;
  try
    modShortPath := (ExtractFileName(aModule));
    modShortPath := Copy(modShortPath, 1, Length(modShortPath) - 4);
    i := DataService.Modules.FindByFolder(modShortPath);
    if (i < 0) then
      modName := ' '
    else
      modName := DataService.Modules[i].FullName;
    if not Assigned(PasswordBox) then
      PasswordBox := TPasswordBox.Create(self);
    with PasswordBox do
    begin
      Font.Assign(self.Font);
      lblPasswordNeeded.Caption :=
        Format(Lang.SayDefault('lblPasswordNeeded', 'Для открытия модуля нужно ввести пароль (%s)'), [modName]);

      lblEnterPassword.Caption := Lang.SayDefault('lblPassword', 'Пароль:');
      chkSavePwd.Caption := Lang.SayDefault('chkSavePwd', 'Сохранить пароль');
      btnCancel.Caption := Lang.SayDefault('btnCancel', 'Отмена');
      edtPwd.Text := '';
      chkSavePwd.Checked := false;
      Result := PasswordBox.ShowModal();
      if Result = mrOk then
      begin
        Pwd := edtPwd.Text;
        savePwd := chkSavePwd.Checked;
      end;
    end;

  except
  end;

end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  OldKey: Word;
  hotMenuItem: TMenuItem;
label
  exitlabel;
begin
  hotMenuItem := nil;

  if Key = VK_CONTROL then
  begin
    if not G_ControlKeyDown then
    begin
      G_ControlKeyDown := true;
      SetBibleTabsHintsState(true);
    end
  end;

  if Shift = [ssShift] then
  begin
    OldKey := Key;
    Key := 0;

    case OldKey of
      VK_F5:
        begin
          ConfigForm.pgcOptions.ActivePageIndex := 0;
          ShowConfigDialog;
        end;
    else
      Key := OldKey;
    end;

    if Key = 0 then
      goto exitlabel;
  end;

  if (Shift = [ssCtrl]) and (Key <> VK_CONTROL) then
  begin
    OldKey := Key;
    Key := 0;

    case OldKey of
      ord('Z'):
        if (GetBookView(Self) <> nil) then
          GetBookView(Self).GoPrevChapter;
      ord('X'):
        if (GetBookView(Self) <> nil) then
          GetBookView(Self).GoNextChapter;
      ord('C'), VK_INSERT:
        begin
          if GetDockWorkspace(self).ActiveControl = mWorkspace.Browser then
            GetBookView(self).tbtnCopy.Click
          else if ActiveControl is THTMLViewer then
            (ActiveControl as THTMLViewer).CopyToClipboard
          else if GetDockWorkspace(self).ActiveControl is THTMLViewer then
          begin
            (GetDockWorkspace(self).ActiveControl as THTMLViewer).CopyToClipboard;
          end; // if webbr
        end;
      ord('P'):
        ShowCurrentModulePrintPreview();
      ord('R'):
        GetBookView(self).GoRandomPlace;
      ord('F'):
        ShowQuickSearch();
      ord('M'):
        GetBookView(self).miMemosToggle.Click;
      ord('L'):
        if GetBookView(self) <> nil then
          GetBookView(self).PlaySound;
      ord('G'), VK_F2:
        if GetBookView(self) <> nil then
          GetBookView(self).FocusQuickNav;
      VK_F3:
        if GetBookView(self) <> nil then
          GetBookView(self).OpenQuickSearch();
      VK_F5:
        if Assigned(GetBookView(self)) then
          GetBookView(self).CopyBrowserSelectionToClipboard();
      VK_F10:
        if GetBookView(self) <> nil then
          GetBookView(self).PlaySound;
      VK_F11:
        ShowCurrentModulePrintPreview();
//      ord('0'):
// Navigate to favorite tab
//        begin
//          if mFavorites.mModuleEntries.Count > 9 then
//            hotMenuItem := FavoriteItemFromModEntry(TModuleEntry(mFavorites.mModuleEntries[10]));
//          if Assigned(hotMenuItem) then
//            hotMenuItem.Click();
//        end;

//      ord('1') .. ord('9'):
// Navigate to favorite tab
//        begin
//          if mFavorites.mModuleEntries.Count >= (ord(OldKey) - ord('0')) then
//            hotMenuItem := FavoriteItemFromModEntry(TModuleEntry(mFavorites.mModuleEntries[ord(OldKey) - ord('0') - 1]));
//
//          if Assigned(hotMenuItem) then
//            hotMenuItem.Click();
//        end;
    else
      Key := OldKey;
    end;

    if Key = 0 then
      goto exitlabel;
  end; // if control pressed

  OldKey := Key;
  case OldKey of

//    VK_F1:
//      miHelp.Click;
    VK_F3:
      ShowSearchTab;
    VK_F4:
       OpenOrCreateDictionaryTab('');
    VK_F5:
      GetBookView(self).ToggleStrongNumbers();
    VK_F7:
      NavigeTSKTab;
    VK_F8:
      tbtnAddMemoTab.Click;
    //VK_F9:
      // TODO: Open favorites dialog
      //miHotKey.Click;
    VK_F10:
      tbtnOptions.Click;
    VK_F11:
      ShowCurrentModulePrintPreview();

  end;

exitlabel:
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  // pass a key to active Library
  PassKeyToActiveLibrary(Key);
end;

function TMainForm.FavoriteTabFromModEntry(workspace: IWorkspace; const me: TModuleEntry): integer;
var
  i, cnt: integer;
begin
  Result := -1;
  cnt := workspace.BibleTabs.Tabs.Count - 1;
  i := 0;
  while i <= cnt do
  begin
    if workspace.BibleTabs.Tabs.Objects[i] = me then
      break;
    inc(i);
  end;
  if i <= cnt then
    Result := i;
end;

procedure TMainForm.FontChanged(delta: integer);
var
  defFontSz, browserpos: integer;
begin
  if not Assigned(mWorkspace) then
    Exit;

  defFontSz := mWorkspace.Browser.DefFontSize;
  if ((delta > 0) and (defFontSz > 48)) or ((delta < 0) and (defFontSz < 6))
  then
    Exit;
  inc(defFontSz, delta);
  Screen.Cursor := crHourGlass;
  try
    mWorkspace.Browser.DefFontSize := defFontSz;
    browserpos := mWorkspace.Browser.Position and $FFFF0000;

    mWorkspace.Browser.LoadFromString(mWorkspace.Browser.DocumentSource);
    mWorkspace.Browser.Position := browserpos;
  except
  end;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.ForceForegroundLoad;
begin
  DataService.ScanModulesAndWait;
  DataService.ScanDictsAndWait;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  workspace: IWorkspace;
begin
  if MainForm.Height < 100 then
    MainForm.Height := 420;

  writeln(NowDateTimeString(), 'FormClose entered');

  SaveConfiguration;

  for workspace in mWorkspaces do
  begin
    if (workspace is TDockTabsForm) then
      (workspace as TDockTabsForm).Close;
  end;

  Flush(Output);
  BibleLinkParser.FinalizeParser();
  try
    GfxRenderers.TbqTagsRenderer.Done();

    FreeAndNil(mFavorites);

    cleanUpInstalledFonts();

    if Assigned(SysHotKey) then
      SysHotKey.Active := false;
    FreeAndNil(SysHotKey);
  except
  end;
end;

procedure TMainForm.imgLoadProgressClick(Sender: TObject);
begin
  //
end;

procedure TMainForm.InitHotkeysSupport;
begin
  SysHotKey := TSysHotKey.Create(self);
  SysHotKey.OnHotKey := SysHotKeyHotKey;
  if AppConfig.HotKeyChoice = 0 then
    SysHotKey.AddHotKey(vkQ, [hkExt])
  else
    SysHotKey.AddHotKey(vkB, [hkCtrl, hkAlt]);
  SysHotKey.Active := true;
end;

procedure TMainForm.InitializeTaggedBookMarks;
begin
  TbqTagsRenderer.Init(self, self);
  TbqTagsRenderer.SetVerseFont(appConfig.DefFontName, appConfig.DefFontSize);

  TbqTagsRenderer.VMargin := 4;
  TbqTagsRenderer.hMargin := 4;
  TbqTagsRenderer.CurveRadius := 7;
end;

function TMainForm.InsertHotModule(newMe: TModuleEntry; ix: integer): integer;
var
  workspace: IWorkspace;
begin
  Result := -1;
  try
    for workspace in mWorkspaces do
    begin
      workspace.BibleTabs.Tabs.Insert(ix, newMe.VisualSignature());
      workspace.BibleTabs.Tabs.Objects[ix] := newMe;
      Result := ix;
      workspace.BibleTabs.Repaint();
    end;
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

function TMainForm.LoadAnchor(wb: THTMLViewer; SRC, current, loc: string): Boolean;
var
  i: integer;
  dest: string;
  ext: string;
  wstrings: TStrings;
  wsResolvedTxt: string;
  ti: TBookTabInfo;
begin
  Result := false;

  try
    i := Pos('#', SRC);
    ti := GetBookView(self).BookTabInfo;
    if i = 1 then
      loc := current + SRC;
    if i >= 1 then
    begin // found anchor
      i := Pos('#', loc);
      dest := System.Copy(loc, i, Length(loc) - i + 1); { local destination }
      SRC := System.Copy(loc, 1, i - 1); { the file name }
    end // found anchor
    else // no achor
      dest := ''; { no local destination }
    if (wb.CurrentFile = SRC) and (Assigned(ti) and not ti[vtisPendingReload])
    then
      wb.PositionTo(dest)
    else
    begin
      ext := UpperCase(ExtractFileExt(SRC));
      if (ext = '.HTM') or (ext = '.HTML') then
      begin { an html file }
        if Assigned(ti) and ti[vtisResolveLinks] then
        begin
          if not FileExists(SRC) then
            Exit;
          try

            wstrings := ReadHtml(SRC, ti.Bible.DefaultEncoding);

            wsResolvedTxt := ResolveLinks(wstrings.Text, ti[vtisFuzzyResolveLinks]);
            wb.LoadFromString(wsResolvedTxt);
            wb.PositionTo(dest);
            wb.__SetFileName(SRC);

          finally
            FreeAndNil(wstrings);
            wsResolvedTxt := '';
          end;
        end
        else
          wb.LoadFromFile(SRC + dest);
      end

      else if (ext = '.BMP') or (ext = '.GIF') or (ext = '.JPG') or (ext = '.JPEG') or (ext = '.PNG') then
        wb.LoadImageFile(SRC);
    end;
    Result := true;
  except
    on E: Exception do
    begin
      BqShowException(E);
    end
  end;
end;

procedure TMainForm.InitModules(updateCache: Boolean);
var
  Loaded: Boolean;
begin
  if updateCache then
    DataService.ScanFirstModules()
  else
  begin
    Loaded := DataService.LoadCachedModules();

    if not Loaded then
      DataService.ScanFirstModules();
  end;
  mDefaultLocation := DefaultLocation();

  StartScanModules();
  DataService.LoadTagsAsync();
end;

procedure TMainForm.ActivateModuleView(aModuleEntry: TModuleEntry);
var
  Command, DstPath: string;
  BibleLink, Link: TBibleLink;
  DestBook: TBible;
  I: Integer;
  tabInfo: IViewTabInfo;
  bookTabInfo, curTabInfo, newTabInfo: TBookTabInfo;
  bookView: TBookFrame;
  state: TBookTabInfoState;
begin
  case aModuleEntry.modType of modtypeDictionary:
    OpenOrCreateDictionaryTab('', aModuleEntry.FullName);
  else
    DestBook := CreateNewBibleInstance();
    DestBook.SetInfoSource(aModuleEntry.ShortPath);
    if (DestBook.InternalToReference(LastLink, BibleLink) >= 0) then
      Command := BibleLink.ToCommand(aModuleEntry.ShortPath)
    else
      Command := 'go ' + aModuleEntry.ShortPath + ' 1 1 0';

    ActivateTargetWorkspace;

    if not Assigned(mWorkspace) then
      Exit;

    for i := 0 to mWorkspace.ChromeTabs.Tabs.Count - 1 do
    begin
      tabInfo := mWorkspace.GetTabInfo(i);
      if not (tabInfo is TBookTabInfo) then
        continue;

      bookTabInfo := TBookTabInfo(tabInfo);

      // get module path from the tab's command
      if (link.FromBqStringLocation(bookTabInfo.Location, DstPath)) then
      begin
        // compare if tab's module path matches to target module path
        if (CompareText(aModuleEntry.ShortPath, dstPath) <> 0) then
          continue; // paths are not equal, skip the tab
      end;

      bookView := GetBookView(self);
      mWorkspace.ChangeTabIndex(i);

      bookView.SafeProcessCommand(bookTabInfo, command, hlDefault);

      mWorkspace.UpdateCurrentTabContent;
      Exit;
    end;

    // no matching tab found, open new tab
    try
      bookView := GetBookView(self);
      if (mWorkspace.ChromeTabs.ActiveTabIndex >= 0) then
      begin
        // save current tab state
        curTabInfo := bookView.BookTabInfo;
        if (Assigned(curTabInfo)) then
        begin
           curTabInfo.SaveState(mWorkspace);
        end;
      end;

      state := DefaultBookTabState;
      newTabInfo := TBookTabInfo.Create(DestBook, command, '', '', state);

      newTabInfo.SecondBible := TBible.Create();
      newTabInfo.Bible.RecognizeBibleLinks := vtisResolveLinks in state;
      newTabInfo.Bible.FuzzyResolve := vtisFuzzyResolveLinks in state;

      mWorkspace.AddBookTab(newTabInfo, False);
      mWorkspace.ChromeTabs.ActiveTabIndex := mWorkspace.ChromeTabs.Tabs.Count - 1;

      AppState.MemosOn := vtisShowNotes in state;

      bookView.SafeProcessCommand(newTabInfo, Command, hlDefault);
      mWorkspace.UpdateCurrentTabContent;
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
  end;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_CONTROL) then
  begin
    if G_ControlKeyDown then
      SetBibleTabsHintsState(false);
    G_ControlKeyDown := false;
  end;

  if (Shift = [ssCtrl]) and (not(ActiveControl is TCustomEdit)) and (not(ActiveControl is TCustomCombo))
  then
    case Key of
      ord('H'):
        if GetBookView(self) <> nil then
          GetBookView(self).FocusQuickNav;
    end;
end;

function TMainForm.ChooseColor(color: TColor): TColor;
begin
  Result := color;
  ColorDialog.color := color;

  if ColorDialog.Execute then
    Result := ColorDialog.color;
end;

function CustomControlAtPos(
  ParentControl: TWinControl;
  const Pos: TPoint;
  AllowDisabled, AllowWinControls, AllLevels: Boolean): TControl;
var
  p: TPoint;
  C: TControl;
  c2: TControl;
begin
  p := Pos;
  C := ParentControl.ControlAtPos(p, AllowDisabled, AllowWinControls, false);

  if C <> nil then
  begin
    if AllLevels and (C is TWinControl) then
    begin
      repeat
        p := C.ParentToClient(p);
        c2 := TWinControl(C).ControlAtPos(p, AllowDisabled, AllowWinControls, false);

        if c2 <> nil then
          C := c2;
      until c2 = nil;
    end;
  end;

  Result := C;
end;

procedure TMainForm.MouseWheelHandler(var Message: TMessage);
var
  mwm: ^TWMMouseWheel; // absolute message;
  pt, screenPt: TPoint;
  ctrl: TControl;
  focusHwnd: HWND;
{$J+}
const
  oneEntry: Boolean = false;
{$J-}
label tail;
begin
  if oneEntry then
  begin
    Exit;
  end;
  oneEntry := true;
  mwm := @message;
  screenPt.X := mwm^.XPos;
  screenPt.Y := mwm^.YPos;
  pt := ScreenToClient(screenPt);
  ctrl := CustomControlAtPos(self, pt, false, true, true);
  if not Assigned(ctrl) then
  begin
    inherited MouseWheelHandler(Message);
    goto tail;
  end;

  if ctrl is TWinControl then
  begin
    focusHwnd := WindowFromPoint(screenPt);
    if (focusHwnd <> 0) and (focusHwnd <> TWinControl(ctrl).Handle) then
    begin

      inherited MouseWheelHandler(Message);
      goto tail;
    end;

    if not TWinControl(ctrl).Focused then
    begin
      try
        FocusControl(TWinControl(ctrl));
      except
      end;
      message.Result := 1;
      goto tail;
    end;
  end;

  inherited;
tail:
  oneEntry := false;
end;

procedure TMainForm.tbtnAddSearchTabClick(Sender: TObject);
var
  newTabInfo: TSearchTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TSearchTabInfo.Create();
  mWorkspace.AddSearchTab(newTabInfo);
end;

procedure TMainForm.tbtnAddStrongTabClick(Sender: TObject);
var
  newTabInfo: TStrongTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TStrongTabInfo.Create();
  mWorkspace.AddStrongTab(newTabInfo);
end;

procedure TMainForm.miDeteleBibleTabClick(Sender: TObject);
var
  me: TModuleEntry;
begin
  if miDeteleBibleTab.tag < 0 then
    Exit;

  if not Assigned(mWorkspace) then
    Exit;

  try
    me := (mWorkspace.BibleTabs.Tabs.Objects[miDeteleBibleTab.tag]) as TModuleEntry;
    mFavorites.DeleteModule(me);
  except
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  workspace: IWorkspace;
  tabsForm: TDockTabsForm;
begin
  if FRunOnce then
    Exit; // run only once...

  FRunOnce := True;

  if (not mTranslated) then
  begin
    MessageDlg('No localization file.', mtWarning, [mbOk], 0);
  end;

  tbLinksToolBar.Visible := false;

  TranslateControl(ExceptionForm);
  TranslateControl(AboutForm);
  TranslateConfigForm;

  for workspace in mWorkspaces do
  begin
    if (workspace is TDockTabsForm) then
    begin
      tabsForm := workspace as TDockTabsForm;
      tabsForm.BringToFront;
    end;
  end;

  if not (FStrongsConcordance.IsAvailable) then
  begin
    tbtnAddStrongTab.Enabled := False;
    tbtnAddStrongTab.Hint := Lang.SayDefault('bqStrongDictNotAvailable', '');
  end;
end;

procedure TMainForm.cbLinksChange(Sender: TObject);
var
  book, chapter, fromverse, toverse: integer;
  bookView: TBookFrame;
  bible: TBible;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  bible := bookView.BookTabInfo.Bible;
  bookView.tedtReference.Text := cbLinks.Items[cbLinks.ItemIndex];

  if bible.OpenReference(bookView.tedtReference.Text, book, chapter, fromverse, toverse) then
    bookView.ProcessCommand(bookView.BookTabInfo, Format('go %s %d %d %d %d', [bible.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
  else
    bookView.ProcessCommand(bookView.BookTabInfo, bookView.tedtReference.Text, hlDefault);
end;

function TMainForm.DefaultLocation: string;
var
  i, fc: integer;
  bibleModuleEntry: TModuleEntry;
begin
  Result := '';
  try
    bibleModuleEntry := nil;
    fc := mFavorites.mModuleEntries.Count - 1;
    for i := 0 to fc do
    begin
      if mFavorites.mModuleEntries[i].modType = modtypeBible then
      begin
        bibleModuleEntry := mFavorites.mModuleEntries[i];
        break;
      end;
    end;

    if not Assigned(bibleModuleEntry) then
    begin
      bibleModuleEntry := DataService.Modules.ModTypedAsFirst(modtypeBible);
    end;
    if not Assigned(bibleModuleEntry) then
      raise Exception.Create
        ('Модули не найдены! Проверьте наличие директории Library в корневой директории BibleQuote.');

    Result := bibleModuleEntry.ShortPath;
  except
    on E: Exception do
    begin
      BqShowException(E, 'Error calculating Default Location:');
      Result := 'rststrong';
    end;
  end;
end;

procedure TMainForm.DeferredReloadViewPages;
var
  i, C: integer;
  bookView: TBookFrame;
  cti: IViewTabInfo;
  bookTabInfo, bti: TBookTabInfo;
begin
  if not Assigned(mWorkspace) then
    Exit;

  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;
  C := mWorkspace.ChromeTabs.Tabs.Count - 1;
  for i := 0 to C do
  begin
    try
      cti := mWorkspace.GetTabInfo(i);
      if not (cti is TBookTabInfo) then
        continue;

      bti := cti as TBookTabInfo;
      if bookTabInfo <> bti then
        bti[vtisPendingReload] := true;
    except
    end;
  end;
  if not Assigned(bookView) then
    Exit;

  bookView.ProcessCommand(bookTabInfo, bookTabInfo.Location, TbqHLVerseOption(ord(bookTabInfo[vtisHighLightVerses])));
end;

procedure TMainForm.DeleteHotModule(moduleTabIx: integer);
var
  workspace: IWorkspace;
  bookView: TBookFrame;
begin
  if not Assigned(mWorkspace) then
    Exit;

  try
    bookView := GetBookView(self);

    for workspace in mWorkspaces do
    begin
      workspace.BibleTabs.Tabs.Delete(moduleTabIx);
    end;

    bookView.AdjustBibleTabs(bookView.BookTabInfo.Bible.Info.BibleShortName);
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure TMainForm.bwrDicHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  cmd, prefBible, ConcreteCmd: string;
  autoCmd: Boolean;
  bookView: TBookFrame;
  bible: TBible;
  status: integer;
  ScriptProvider: TScriptureProvider;
begin
  prefBible := '';
  bookView := GetBookView(self);
  if Assigned(bookView) and Assigned(bookView.BookTabInfo) then
  begin
    bible := bookView.BookTabInfo.Bible;
    if bible.isBible then
      prefBible := bible.ShortPath
    else
      prefBible := '';
  end;

  cmd := SRC;
  Handled := true;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autoCmd then
  begin
    ScriptProvider := TScriptureProvider.Create(Self);
    try
      status := ScriptProvider.PreProcessAutoCommand(cmd, prefBible, ConcreteCmd);
      if status <= -2 then
        Exit;
    finally
      ScriptProvider.Free;
    end;
  end;

  if not IsDown(VK_CONTROL) then
  begin
    if autoCmd then
      G_XRefVerseCmd := ConcreteCmd
    else
      G_XRefVerseCmd := SRC;
    miOpenNewViewClick(Sender);
  end
  else
  begin
    if autoCmd then
      bookView.ProcessCommand(bookView.BookTabInfo, ConcreteCmd, hlDefault)
    else
    begin
      bookView.tedtReference.Text := SRC;
      GoReference();
    end
  end;
end;

procedure TMainForm.bwrDicHotSpotCovered(Sender: TObject; const SRC: string);
begin
  GetBookView(self).BrowserHotSpotCovered(Sender as THTMLViewer, SRC);
end;

procedure TMainForm.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
  inherited;
  writeln(NowDateTimeString(), ': Close Query-WMQueryEndSession');
  Flush(Output);
  MainForm.Close();
  Message.Result := 1;
end;

procedure TMainForm.FormActivate(Sender: TObject);
var
  ctrlIsDown: Boolean;
begin
  ctrlIsDown := IsDown(VK_CONTROL);
  if ctrlIsDown = G_ControlKeyDown then
    Exit;
  G_ControlKeyDown := ctrlIsDown;
  SetBibleTabsHintsState(ctrlIsDown);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := true;
end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  if G_ControlKeyDown then
  begin
    SetBibleTabsHintsState(false);
    G_ControlKeyDown := false;
  end
end;

procedure TMainForm.tbtnAddTagsVersesTabClick(Sender: TObject);
var
  newTabInfo: TTagsVersesTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TTagsVersesTabInfo.Create();
  mWorkspace.AddTagsVersesTab(newTabInfo);
end;

procedure TMainForm.tbtnDownloadModulesClick(Sender: TObject);
var
  DownloadModules: TDownloadModulesForm;
begin
  DownloadModules := TDownloadModulesForm.Create(Self);
  try
    DownloadModules.ShowModal;

    StartScanModules;
  finally
    DownloadModules.Free;
  end;
end;

procedure TMainForm.cbModulesCloseUp(Sender: TObject);
begin
  if not Assigned(mWorkspace) then
    Exit;

  try
    MainForm.FocusControl(mWorkspace.Browser);
  except
  end;
end;

procedure TMainForm.AppOnHintHandler(Sender: TObject);
begin
  //
end;

procedure TMainForm.appEventsException(Sender: TObject; E: Exception);
begin
  BqShowException(E);
end;

procedure TMainForm.GoReference();
  var
  book, chapter, fromverse, toverse: integer;
  linktxt: string;
  Links: TStrings;
  i, fc: integer;
  openSuccess: Boolean;
  modName, modPath: string;
  moduleEntry: TModuleEntry;
  bookView: TBookFrame;
  bible, tempBook: TBible;
label lblTail;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  if Trim(bookView.tedtReference.Text) = '' then
    Exit;

  bible := bookView.BookTabInfo.Bible;

  linktxt := bookView.tedtReference.Text;
  StrReplace(linktxt, '(', '', true);
  StrReplace(linktxt, ')', '', true);
  StrReplace(linktxt, '[', '', true);
  StrReplace(linktxt, ']', '', true);
  StrReplace(linktxt, '!', '', true);

  Links := TStringList.Create;
  try
    StrToLinks(linktxt, Links);

    if Links.Count <= 0 then
    begin
      MessageBeep(MB_ICONERROR);
      goto lblTail
    end
    else if Links.Count > 1 then
    begin

      cbLinks.Items.Clear;
      for i := 0 to Links.Count - 1 do
        cbLinks.Items.Add(Links[i]);
      cbLinks.ItemIndex := 0;
    end;

    tbLinksToolBar.Visible := (Links.Count > 1);
    bookView.tedtReference.Text := Links[0];
    openSuccess := bible.OpenReference(bookView.tedtReference.Text, book, chapter, fromverse, toverse);

    if not openSuccess then
    begin
      fc := mFavorites.mModuleEntries.Count - 1;

      tempBook := TBible.Create();

      for i := 0 to fc do
      begin
        try
          tempBook.SetInfoSource(
            ResolveFullPath(TPath.Combine(mFavorites.mModuleEntries[i].ShortPath, 'bibleqt.ini')));

          openSuccess := tempBook.OpenReference(bookView.tedtReference.Text, book, chapter, fromverse, toverse);

          if openSuccess then
          begin
            bible.SetInfoSource(tempBook.Info);
            break;
          end;
        except
        end;

      end;
      if not openSuccess then
      begin
        moduleEntry := DataService.Modules.ModTypedAsFirst(modtypeBible);
        while Assigned(moduleEntry) do
        begin
          try

            modName := moduleEntry.FullName;

            modPath := moduleEntry.ShortPath;
            tempBook.SetInfoSource(ResolveFullPath(TPath.Combine(modPath, 'bibleqt.ini')));
            openSuccess := tempBook.OpenReference(bookView.tedtReference.Text, book, chapter, fromverse, toverse);
            if openSuccess then
            begin
              bible.SetInfoSource(tempBook.Info);
              break;
            end;
          except
          end;
          moduleEntry := DataService.Modules.ModTypedAsNext(modtypeBible);
        end;

      end;
    end;
    if openSuccess then
      bookView.SafeProcessCommand(bookView.BookTabInfo, Format('go %s %d %d %d %d', [bible.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
    else
      bookView.SafeProcessCommand(bookView.BookTabInfo, bookView.tedtReference.Text, hlDefault);
  lblTail:
  finally
    Links.Free;
  end;
end;

procedure TMainForm.TranslateControl(form: TWinControl; fname: string = '');
begin
  try
    if Assigned(form) then
      Lang.TranslateControl(form, fname);
  except
    on E: Exception do
    begin
      // Failed to translate exception form
      // Suppress the exception
    end;
  end;
end;


procedure TMainForm.TranslateConfigForm;
begin
  if Assigned(ConfigForm) then
  begin
    Lang.TranslateControl(ConfigForm);

    ConfigForm.rgAddReference.Items[0] := Lang.Say('CopyOptionsAddReference_ShortAtBeginning');
    ConfigForm.rgAddReference.Items[1] := Lang.Say('CopyOptionsAddReference_ShortAtEnd');
    ConfigForm.rgAddReference.Items[2] := Lang.Say('CopyOptionsAddReference_FullAtEnd');
  end;
end;

procedure TMainForm.miRefPrintClick(Sender: TObject);
begin
  ShowCurrentModulePrintPreview;
end;

procedure TMainForm.miRefCopyClick(Sender: TObject);
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

procedure TMainForm.ActivateTargetWorkspace();
var
  workspace: IWorkspace;
begin
  for workspace in mWorkspaces do
  begin
    if (workspace <> mWorkspace) then
    begin
      mWorkspace := workspace;
      Windows.SetFocus(TDockTabsForm(workspace).Handle);
      Exit;
    end;
  end;

  OpenNewWorkspace();
end;

procedure TMainForm.tbtnAddBookmarksTabClick(Sender: TObject);
var
  newTabInfo: TBookmarksTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TBookmarksTabInfo.Create();
  mWorkspace.AddBookmarksTab(newTabInfo);
end;

procedure TMainForm.tbtnAddCommentsTabClick(Sender: TObject);
var
  newTabInfo: TCommentsTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TCommentsTabInfo.Create();
  mWorkspace.AddCommentsTab(newTabInfo);
end;

procedure TMainForm.tbtnAddDictionaryTabClick(Sender: TObject);
var
  newTabInfo: TDictionaryTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TDictionaryTabInfo.Create();
  mWorkspace.AddDictionaryTab(newTabInfo);
end;

procedure TMainForm.tbtnAddLibraryTabClick(Sender: TObject);
var
  newTabInfo: TLibraryTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TLibraryTabInfo.Create();
  mWorkspace.AddLibraryTab(newTabInfo);
end;

procedure TMainForm.tbtnNewFormClick(Sender: TObject);
begin
  AddNewWorkspace;
end;

procedure TMainForm.tbtnOptionsClick(Sender: TObject);
begin
  ConfigForm.pgcOptions.ActivePageIndex := 0;
  ShowConfigDialog;
end;

procedure TMainForm.tbtnPreviewPrintClick(Sender: TObject);
begin
  ShowCurrentModulePrintPreview();
end;

procedure TMainForm.ShowCurrentModulePrintPreview();
begin
  if Assigned(mWorkspace) and Assigned(mWorkspace.Browser) then
    ShowPrintPreview(Self, mWorkspace.Browser);
end;

procedure TMainForm.tbtnAboutClick(Sender: TObject);
begin
  if not Assigned(AboutForm) then
    AboutForm := TAboutForm.Create(self);

  AboutForm.Position := poScreenCenter;
  AboutForm.ShowModal();
end;

procedure TMainForm.tbtnAddMemoTabClick(Sender: TObject);
var
  newTabInfo: TMemoTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TMemoTabInfo.Create();
  mWorkspace.AddMemoTab(newTabInfo);
end;

procedure TMainForm.ClearCopyrights();
begin
  lblTitle.Caption := '';
end;

procedure TMainForm.UpdateBookView();
var
  tabInfo: TBookTabInfo;
  bookView: TBookFrame;
begin
  mInterfaceLock := true;
  mScrollAcc := 0;
  try
    bookView := GetBookView(self);
    if not Assigned(bookView) then
      Exit;

    tabInfo := bookView.BookTabInfo;
    if not Assigned(tabInfo) then
      Exit;

    bookView.AdjustBibleTabs(tabInfo.Bible.Info.BibleShortName);
    bookView.tbtnStrongNumbers.Down := tabInfo[vtisShowStrongs];
    bookView.tbtnSatellite.Down := (Length(tabInfo.SatelliteName) > 0) and (tabInfo.SatelliteName <> '------');

    bookView.tbtnStrongNumbers.Enabled := tabInfo.Bible.Trait[bqmtStrongs];
    AppState.MemosOn := tabInfo[vtisShowNotes];
    bookView.SyncView();

    // todo: it's unclear while trying to load Satellite for Commentary
    if not tabInfo.Bible.isBible then
    begin
      try
        bookView.LoadSecondBookByName(tabInfo.SatelliteName);
      except
        on E: Exception do
          BqShowException(E);
      end;
    end;

    bookView.UpdateModuleTree(tabInfo.Bible); // fill lists
    bookView.HistoryClear();
    bookView.UpdateHistory();

    lblTitle.Font.Name := tabInfo.TitleFont;
    lblTitle.Caption := tabInfo.TitleLocation;

    if tabInfo[vtisPendingReload] then
    begin
      tabInfo[vtisPendingReload] := false;
      bookView.SafeProcessCommand(tabInfo, tabInfo.Location, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
    end;
  finally
    mInterfaceLock := false;
  end;
end;

procedure TMainForm.VSCrollTracker(Sender: TObject);
var
  sectionIx, sectionCnt, sourcePos, scrollPos, BottomPos, vn, ch, ve, delta: integer;
  sct: TSectionBase;
  positionLst: TList;
  ds: string;

  bl: TBibleLink;
  path: string;
  scte: TSectionBase;
  bookView: TBookFrame;
  bookTabInfo: TBookTabInfo;
  bible: TBible;

  function find_verse(sp: integer): integer;
  var
    pfind: PChar;
    i: integer;
  begin

    Result := -1;
    pfind := searchbuf(PChar(Pointer(ds)), sourcePos - 1, sourcePos - 1, 0, '<a name="bqverse', [soMatchCase]);

    if not Assigned(pfind) then
      Exit;
    i := Length('<a name="bqverse');
    Result := 0;
    repeat
      ch := ord((pfind + i)^) - ord('0');
      if (ch < 0) or (ch > 9) then
        break;
      Result := Result * 10 + ch;
      inc(i);
    until false;
  end;

begin
  if not Assigned(mWorkspace) then
    Exit;

  try
    vn := -1;
    ve := vn;
    scrollPos := integer(mWorkspace.Browser.VScrollBar.Position);
    msbPosition := scrollPos;
    if scrollPos = 0 then
      vn := 1;

    sct := mWorkspace.Browser.SectionList.FindSectionAtPosition(scrollPos, vn, ch);

    BottomPos := scrollPos + mWorkspace.Browser.__PaintPanel.Height;
    scte := mWorkspace.Browser.SectionList.FindSectionAtPosition(BottomPos, ve, ch);
    ds := mWorkspace.Browser.DocumentSource;
    if Assigned(sct) and (sct is TSectionBase) then
    begin
      delta := sct.DrawHeight div 2;
      positionLst := mWorkspace.Browser.SectionList.PositionList;
      if sct.YPosition + delta < scrollPos then
      begin
        // try to find first fully visible section
        sectionIx := positionLst.IndexOf(sct);
        sectionCnt := positionLst.Count - 1;
        repeat
          inc(sectionIx);
        until (sectionIx >= sectionCnt) or
          (TSectionBase(positionLst[sectionIx]).YPosition +
          (TSectionBase(positionLst[sectionIx]).DrawHeight div 2) > scrollPos);

        if sectionIx < sectionCnt then
          sct := TSectionBase(positionLst[sectionIx]);
      end;
      if scte.YPosition + (scte.DrawHeight div 2) > BottomPos then
      begin
        // try to find first fully visible section

        sectionIx := positionLst.IndexOf(scte);
        repeat
          Dec(sectionIx);
        until (sectionIx < 0) or (TSectionBase(positionLst[sectionIx]).YPosition
          + (TSectionBase(positionLst[sectionIx]).DrawHeight div 2) <
          BottomPos);
        if sectionIx >= 0 then
          scte := TSectionBase(positionLst[sectionIx]);
      end;

      sourcePos := sct.FindSourcePos(sct.StartCurs);
      vn := -1;
      if sourcePos >= 0 then
      begin
        vn := find_verse(sourcePos);
      end;
    end;
    if Assigned(scte) and (scte is TSectionBase) then
    begin
      sourcePos := scte.FindSourcePos(scte.StartCurs);
      ve := -1;
      if sourcePos >= 0 then
      begin
        ve := find_verse(sourcePos);
      end;
    end;

    // TSection(sct).
    bookView := GetBookView(self);
    bookTabInfo := bookView.BookTabInfo;
    if not Assigned(bookTabInfo) then
      Exit;

    bible := bookTabInfo.Bible;
    if not Assigned(bible) then
      Exit;

    if vn > 0 then
    begin
      bookTabInfo.FirstVisiblePara := vn;
      if bl.FromBqStringLocation(bookTabInfo.Location, path) then
      begin
        bl.vstart := vn;
      end;
    end;
    if (ve > 0) and (ve >= vn) then
      bookTabInfo.LastVisiblePara := ve
    else
    begin
      bookTabInfo.LastVisiblePara := -1;
      ve := 0;
    end;
    if (vn > 0) and (ve > 0) then
      bible := bookTabInfo.Bible;
      lblTitle.Caption := bible.Info.BibleShortName + ' ' + bible.FullPassageSignature(bible.CurBook, bible.CurChapter, vn, ve);

  except
    on E: EAccessViolation do
    begin
      BqShowException(E);
    end
  end;
end;

procedure TMainForm.OpenOrCreateStrongTab(bookTabInfo: TBookTabInfo; number: Integer; isHebrew: Boolean);
var
  i: integer;
  tabInfo: IViewTabInfo;
  strongTabInfo: TStrongTabInfo;
  strongView: TStrongFrame;
begin
  if not (FStrongsConcordance.IsAvailable) then
    Exit;

  strongTabInfo := nil;
  ActivateTargetWorkspace();

  if not Assigned(mWorkspace) then
    Exit;

  for i := 0 to mWorkspace.ChromeTabs.Tabs.Count - 1 do
  begin
    tabInfo := mWorkspace.GetTabInfo(i);
    if not (tabInfo is TStrongTabInfo) then
      continue;

    strongTabInfo := TStrongTabInfo(tabInfo);
    mWorkspace.ChangeTabIndex(i);
  end;

  if not Assigned(strongTabInfo) then
  begin
    strongTabInfo := TStrongTabInfo.Create();
    mWorkspace.AddStrongTab(strongTabInfo);
  end;

  strongView := mWorkspace.StrongView as TStrongFrame;
  if Assigned(bookTabInfo) then
  begin
    strongView.SetCurrentBook(bookTabInfo.Bible.ShortPath);
    strongView.DisplayStrongs(number, isHebrew);
    mWorkspace.UpdateCurrentTabContent(false);
  end
  else
    mWorkspace.UpdateCurrentTabContent(true);
end;

procedure TMainForm.OpenOrCreateSearchTab(bookPath: string; searchText: string; bookTypeIndex: integer = -1; SearchOptions: TSearchOptions = []);
var
  i: integer;
  tabInfo: IViewTabInfo;
  searchTabInfo: TSearchTabInfo;
  searchView: TSearchFrame;
begin
  searchTabInfo := nil;
  ActivateTargetWorkspace;

  if not Assigned(mWorkspace) then
    Exit;

  for i := 0 to mWorkspace.ChromeTabs.Tabs.Count - 1 do
  begin
    tabInfo := mWorkspace.GetTabInfo(i);
    if not (tabInfo is TSearchTabInfo) then
      continue;

    searchTabInfo := TSearchTabInfo(tabInfo);

    mWorkspace.ChangeTabIndex(i);
  end;

  if not Assigned(searchTabInfo) then
  begin
    searchTabInfo := TSearchTabInfo.Create();
    mWorkspace.AddSearchTab(searchTabInfo);
  end;

  searchView := mWorkspace.SearchView as TSearchFrame;
  mWorkspace.UpdateCurrentTabContent;

  searchView.SetCurrentBook(bookPath);
  if (bookTypeIndex >= 0) then
    searchView.cbList.ItemIndex := bookTypeIndex;

  searchView.cbSearch.Text := Trim(searchText);

  if (SearchOptions <> []) then
  begin
    searchView.chkParts.Checked := not (soWordParts in SearchOptions);
    searchView.chkAll.Checked := not (soContainAll in SearchOptions);
    searchView.chkPhrase.Checked := not (soFreeOrder in SearchOptions);
    searchView.chkCase.Checked := not (soIgnoreCase in SearchOptions);
    searchView.chkExactPhrase.Checked := soExactPhrase in SearchOptions;
  end;

  searchView.btnFindClick(Self);
end;

procedure TMainForm.OpenOrCreateTSKTab(bookTabInfo: TBookTabInfo; goverse: integer = 0);
var
  i: integer;
  tabInfo: IViewTabInfo;
  tskTabInfo: TTSKTabInfo;
  tskView: TTSKFrame;
  InfoPath: string;
begin
  tskTabInfo := nil;
  ActivateTargetWorkspace();

  if not Assigned(mWorkspace) then
    Exit;

  for i := 0 to mWorkspace.ChromeTabs.Tabs.Count - 1 do
  begin
    tabInfo := mWorkspace.GetTabInfo(i);
    if not (tabInfo is TTSKTabInfo) then
      continue;

    tskTabInfo := TTSKTabInfo(tabInfo);

    mWorkspace.ChangeTabIndex(i);
  end;

  if not Assigned(tskTabInfo) then
  begin
    tskTabInfo := TTSKTabInfo.Create();
    mWorkspace.AddTSKTab(tskTabInfo);
  end;

  tskView := mWorkspace.TSKView as TTSKFrame;
  if Assigned(bookTabInfo) then
  begin
    InfoPath := bookTabInfo.Bible.Info.FileName;

    tskView.ShowXref(InfoPath, bookTabInfo.Bible.CurBook, bookTabInfo.Bible.CurChapter, goverse);
    mWorkspace.UpdateCurrentTabContent(false);
  end
  else
    mWorkspace.UpdateCurrentTabContent(true);
end;

procedure TMainForm.OpenOrCreateBookTab(const command: string; const satellite: string; state: TBookTabInfoState; processCommand: boolean = true);
var
  i: integer;
  tabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
  bookView: TBookFrame;
  srcPath, dstPath: string;
  link: TBibleLink;
begin
  ClearVolatileStateData(state);
  // get module path from the target command
  link.FromBqStringLocation(command, srcPath);

  ActivateTargetWorkspace;

  if not Assigned(mWorkspace) then
    Exit;

  for i := 0 to mWorkspace.ChromeTabs.Tabs.Count - 1 do
  begin
    tabInfo := mWorkspace.GetTabInfo(i);
    if not (tabInfo is TBookTabInfo) then
      continue;

    bookTabInfo := TBookTabInfo(tabInfo);

    // get module path from the tab's command
    if (link.FromBqStringLocation(bookTabInfo.Location, dstPath)) then
    begin
      // compare if tab's module path matches to target module path
      if (CompareText(srcPath, dstPath) <> 0) then
        continue; // paths are not equal, skip the tab
    end;

    bookView := GetBookView(self);
    mWorkspace.ChangeTabIndex(i);

    if (processCommand) then
      bookView.SafeProcessCommand(bookTabInfo, command, hlDefault);

    mWorkspace.UpdateCurrentTabContent;
    Exit;
  end;

  // no matching tab found, open new tab
  NewBookTab(command, satellite, state, '', true);
end;

procedure TMainForm.OpenOrCreateDictionaryTab(const searchText: string; aActiveDictName: String);
var
  i: integer;
  tabInfo: IViewTabInfo;
  dicTabInfo: TDictionaryTabInfo;
  dictionaryView: TDictionaryFrame;
  newTab: boolean;
begin
  newTab := false;
  dicTabInfo := nil;

  ActivateTargetWorkspace();

  if not Assigned(mWorkspace) then
    Exit;

  for i := 0 to mWorkspace.ChromeTabs.Tabs.Count - 1 do
  begin
    tabInfo := mWorkspace.GetTabInfo(i);
    if not (tabInfo is TDictionaryTabInfo) then
      continue;

    dicTabInfo := TDictionaryTabInfo(tabInfo);

    mWorkspace.ChangeTabIndex(i);
  end;

  if not Assigned(dicTabInfo) then
  begin
    dicTabInfo := TDictionaryTabInfo.Create();
    mWorkspace.AddDictionaryTab(dicTabInfo);
    newTab := true;
  end;

  dictionaryView := mWorkspace.DictionaryView as TDictionaryFrame;
  if (newTab) then
    dictionaryView.DisplayDictionaries;

  if not aActiveDictName.IsEmpty then
  begin
    dictionaryView.SetActiveDictionary(aActiveDictName);
  end;


  if (searchText.Length > 0) then
    dictionaryView.UpdateSearch(searchText);

  mWorkspace.UpdateCurrentTabContent(false);
end;

function TMainForm.NewBookTab(
  const command: string;
  const satellite: string;
  state: TBookTabInfoState;
  const Title: string;
  activate: Boolean;
  changeWorkspace: Boolean = false;
  history: TStrings = nil;
  historyIndex: integer = -1): Boolean;
var
  curTabInfo, newTabInfo: TBookTabInfo;
  newBible: TBible;
  bookView: TBookFrame;
  cmd: string;
begin
  newBible := nil;
  ClearVolatileStateData(state);
  Result := true;

  if (changeWorkspace) then
    ActivateTargetWorkspace;

  if not Assigned(mWorkspace) then
    Exit;

  try
    newBible := CreateNewBibleInstance();
    if not Assigned(newBible) then
      abort;

    bookView := GetBookView(self);
    if (mWorkspace.ChromeTabs.ActiveTabIndex >= 0) then
    begin
      // save current tab state
      curTabInfo := bookView.BookTabInfo;
      if (Assigned(curTabInfo)) then
      begin
         curTabInfo.SaveState(GetDockWorkspace(self));
      end;
    end;

    newTabInfo := TBookTabInfo.Create(newBible, command, satellite, Title, state);

    newTabInfo.SecondBible := TBible.Create();
    newTabInfo.Bible.RecognizeBibleLinks := vtisResolveLinks in state;
    newTabInfo.Bible.FuzzyResolve := vtisFuzzyResolveLinks in state;

    if Assigned(history) then
      newTabInfo.History.AddStrings(history);

    mWorkspace.AddBookTab(newTabInfo);

    if activate then
    begin
      mWorkspace.ChromeTabs.ActiveTabIndex := mWorkspace.ChromeTabs.Tabs.Count - 1;

      AppState.MemosOn := vtisShowNotes in state;
      cmd := command;
      if ((newTabInfo.History.Count > historyIndex) and (historyIndex >= 0)) then
        cmd := newTabInfo.History[historyIndex];

      bookView.SafeProcessCommand(newTabInfo, cmd, hlDefault);
    end
    else
    begin
      newTabInfo.StateEntryStatus[vtisPendingReload] := true;
    end;
  except
    on E: Exception do
    begin
      BqShowException(E);
      Result := false;
      newBible.Free();
    end;
  end;

end;

function FindPageforTabIndex(PageControl: TPageControl; TabIndex: integer): TTabSheet;
var
  i: integer;
begin
  Assert(Assigned(PageControl));
  Assert((TabIndex >= 0) and (TabIndex < PageControl.PageCount));
  Result := nil;
  for i := 0 to PageControl.PageCount - 1 do
    if PageControl.Pages[i].tabVisible then
    begin
      Dec(TabIndex);
      if TabIndex < 0 then
      begin
        Result := PageControl.Pages[i];
        break;
      end;
    end;
end;

function TMainForm.CreateNewBibleInstance(): TBible;
begin
  Result := nil;
  try
    Result := TBible.Create();
    with Result do
    begin
      OnChangeModule := BookChangeModule;
    end;
  except
    Result.Free();
  end;
end;

procedure TMainForm.CheckModuleInstall;
var
  pCommandLine, pCurrent: PChar;
  len: integer;
  cChar, saveChar: Char;
  ws: string;
  blQuoted: Boolean;
begin
  pCommandLine := GetCommandLineW();
  pCurrent := pCommandLine;

  pCurrent := GetTokenFromString(pCurrent, ' ', len);
  while pCurrent <> nil do
  begin
    cChar := pCurrent^;
    blQuoted := (cChar = '"') or (cChar = '''');
    if blQuoted then
    begin
      inc(pCurrent);
      pCurrent := GetTokenFromString(pCurrent, cChar, len);
      if pCurrent = nil then
        break;
    end;
    saveChar := (pCurrent + len)^;
    (pCurrent + len)^ := #0;
    ws := pCurrent;
    (pCurrent + len)^ := saveChar;

    inc(pCurrent, len + ord(blQuoted));

    pCurrent := GetTokenFromString(pCurrent, ' ', len)
  end;

end;

function TMainForm.DeleteHotModule(const me: TModuleEntry): Boolean;
var
  i: integer;
  workspace: IWorkspace;
  bookView: TBookFrame;
begin

  try
    for workspace in mWorkspaces do
    begin
      i := FavoriteTabFromModEntry(workspace, me);
      if i >= 0 then
        workspace.BibleTabs.Tabs.Delete(i);
      bookView := GetBookView(self);
      if Assigned(bookView.BookTabInfo) then
        bookView.AdjustBibleTabs(bookView.BookTabInfo.Bible.Info.BibleShortName);
    end;
  except
    on E: Exception do
      BqShowException(E);
  end;
  Result := true;
end;

procedure TMainForm.miOpenNewViewClick(Sender: TObject);
var
  addr: string;
  ti: TBookTabInfo;
  state: TBookTabInfoState;
  satBible: string;
begin
  G_XRefVerseCmd := Trim(G_XRefVerseCmd);
  addr := G_XRefVerseCmd;
  if Length(addr) <= 0 then
    Exit;
  ti := GetBookView(self).BookTabInfo;
  if Assigned(ti) then
  begin
    satBible := ti.SatelliteName;
    state := ti.State;
  end
  else
  begin
    satBible := '------';
    state := DefaultBookTabState;
  end;

  NewBookTab(addr, satBible, state, '', true);
  if GetCommandType(G_XRefVerseCmd) = bqctInvalid then
  begin
    GetBookView(self).tedtReference.Text := addr;
    GoReference();
  end;

end;

procedure TMainForm.ShowConfigDialog;
var
  i, moduleCount, langIdx: integer;
  reload: Boolean;
  defBible, defStrongBible: string;
  locFile: string;
  bookView: TBookFrame;
  bible: TBible;
  fnt: TFont;
  OldConfig: TAppConfig;
begin
  reload := false;

  mDefaultLocation := DefaultLocation();
  ForceForegroundLoad();

  ConfigForm.SetModules(DataService.Modules, mFavorites);

  if ConfigForm.ShowModal = mrCancel then
    Exit;

  OldConfig := AppConfig.Clone();
  langIdx := ConfigForm.cbLanguage.ItemIndex;
  if (langIdx >= 0) then
  begin
    locFile := ConfigForm.cbLanguage.Items[langIdx] + '.lng';
    if (AppConfig.LocalizationFile <> locFile) then
    begin
      AppConfig.LocalizationFile := locFile;
      TranslateInterface(AppConfig.LocalizationFile);
    end;
  end;

  moduleCount := ConfigForm.lbFavourites.Count - 1;
  mFavorites.Clear();

  for i := 0 to moduleCount do
  begin
    try
      mFavorites.AddModule(DataService.Modules.ResolveModuleByNames(ConfigForm.lbFavourites.Items[i], ''));
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
  end;

  if (ConfigForm.cbDefaultBible.ItemIndex >= 0) then
  begin
    defBible := ConfigForm.cbDefaultBible.Items[ConfigForm.cbDefaultBible.ItemIndex];
    if (defBible <> '') and (DataService.Modules.ResolveModuleByNames(defBible, '') <> nil) then
      AppConfig.DefaultBible := defBible
    else
      AppConfig.DefaultBible := '';

    mNotifier.Notify(TDefaultBibleChangedMessage.Create(AppConfig.DefaultBible));
  end;

  if (ConfigForm.cbDefaultStrongBible.ItemIndex >= 0) then
  begin
    defStrongBible := ConfigForm.cbDefaultStrongBible.Items[ConfigForm.cbDefaultStrongBible.ItemIndex];
    if (defStrongBible <> '') and (DataService.Modules.ResolveModuleByNames(defStrongBible, '') <> nil) then
      AppConfig.DefaultStrongBible := defStrongBible
    else
      AppConfig.DefaultStrongBible := '';
  end;

  bookView := GetBookView(self);
  if Assigned(bookView.BookTabInfo) then
  begin
    bible := bookView.BookTabInfo.Bible;
    bookView.AdjustBibleTabs(bible.Info.BibleShortName);
  end;

  if Assigned(ConfigForm.PrimaryFont) then
  begin
    AppConfig.DefFontName := ConfigForm.PrimaryFont.Name;
    AppConfig.DefFontColor := ConfigForm.PrimaryFont.Color;
    AppConfig.DefFontSize := ConfigForm.PrimaryFont.Size;
  end;

  if Assigned(ConfigForm.SecondaryFont) then
  begin
    AppConfig.RefFontName := ConfigForm.SecondaryFont.Name;
    AppConfig.RefFontColor := ConfigForm.SecondaryFont.Color;
    AppConfig.RefFontSize := ConfigForm.SecondaryFont.Size;
  end;

  if Assigned(ConfigForm.DialogsFont) then
  begin
    AppConfig.MainFormFontName := ConfigForm.DialogsFont.Name;
    AppConfig.MainFormFontSize := ConfigForm.DialogsFont.Size;
  end;

  AppConfig.BackgroundColor := ConfigForm.clrBackground.Selected;
  AppConfig.HotSpotColor := ConfigForm.clrHyperlinks.Selected;
  AppConfig.VerseHighlightColor := ConfigForm.clrVerseHighlight.Selected;
  AppConfig.SelTextColor := ConfigForm.clrSearchText.Selected;

  AppConfig.AddVerseNumbers := ConfigForm.chkCopyVerseNumbers.Checked;
  AppConfig.AddFontParams := ConfigForm.chkCopyFontParams.Checked;
  AppConfig.AddReference := ConfigForm.chkAddReference.Checked;
  AppConfig.AddReferenceChoice := ConfigForm.rgAddReference.ItemIndex;
  AppConfig.AddLineBreaks := ConfigForm.chkAddLineBreaks.Checked;
  AppConfig.AddModuleName := ConfigForm.chkAddModuleName.Checked;
  AppConfig.ShowVerseSignatures := ConfigForm.chkShowVerseSignatures.Checked;

  AppConfig.HotKeyChoice := ConfigForm.rgHotKeyChoice.ItemIndex;
  trayIcon.MinimizeToTray := ConfigForm.chkMinimizeToTray.Checked;
  if AppConfig.FullContextLinks <> ConfigForm.chkFullContextOnRestrictedLinks.Checked
  then
  begin
    AppConfig.FullContextLinks := ConfigForm.chkFullContextOnRestrictedLinks.Checked;
    reload := true;
  end;
  if AppConfig.HighlightVerseHits <> ConfigForm.chkHighlightVerseHits.Checked then
  begin
    AppConfig.HighlightVerseHits := ConfigForm.chkHighlightVerseHits.Checked;
    reload := true;
  end;
  if ConfigForm.edtSelectPath.Text <> AppConfig.SecondPath then
  begin
    AppConfig.SecondPath := ConfigForm.edtSelectPath.Text;
    mScanner.SecondDirectory := AppConfig.SecondPath;
    InitModuleScanner();
    InitModules(true);
  end;

  fnt := TFont.Create;
  try
    fnt.Name := AppConfig.MainFormFontName;
    fnt.Size := AppConfig.MainFormFontSize;

    self.Font.Assign(fnt);
    Screen.HintFont.Assign(fnt);

    Update;
    lblTitle.Font.Assign(fnt);
  finally
    fnt.Free;
  end;

  mNotifier.Notify(TAppConfigChangedMessage.Create(OldConfig, AppConfig));

  if reload then
    DeferredReloadViewPages();
end;

procedure TMainForm.ShowQuickSearch;
var bookView: TBookFrame;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  bookView.ToggleQuickSearchPanel(true);
  try
    FocusControl(bookView.tedtQuickSearch);
  except
  end;
  if Length(bookView.tedtQuickSearch.Text) > 0 then
    bookView.tedtQuickSearch.SelectAll();
end;

procedure TMainForm.ShowSearchTab;
var
  newTabInfo: TSearchTabInfo;
begin
  if not Assigned(mWorkspace) then
    OpenNewWorkspace;

  newTabInfo := TSearchTabInfo.Create();
  mWorkspace.AddSearchTab(newTabInfo);
end;

procedure TMainForm.trayIconClick(Sender: TObject);
begin
  if MainForm.Visible then
    trayIcon.HideMainForm
  else
    trayIcon.ShowMainForm;
end;

procedure TMainForm.SysHotKeyHotKey(Sender: TObject; Index: integer);
begin
  if trayIcon.MinimizeToTray then
  begin
    if MainForm.Visible then
    begin
      if Application.Active then
        Application.Minimize
      else
        Application.BringToFront;
    end
    else
      trayIcon.ShowMainForm;
  end
  else
  begin // if not minimizing to tray, hot key only activates or minimizes the app
    if Application.Active then
      Application.Minimize
    else
    begin
      Application.Restore;
      Application.BringToFront;
    end;
  end;
end;

function TMainForm.RefBiblesCount: integer;
var
  i, cnt: integer;
begin
  cnt := mFavorites.mModuleEntries.Count - 1;
  Result := 0;
  for i := 0 to cnt do
    if mFavorites.mModuleEntries[i].modType = modtypeBible then
      inc(Result);
end;

procedure TMainForm.pmRefPopup(Sender: TObject);
begin
  miOpenNewView.Visible := false;
end;

function TMainForm.ReplaceHotModule(const oldMe, newMe: TModuleEntry): Boolean;
var
  hotMi: TMenuItem;
  ix: integer;
  workspace: IWorkspace;
begin
  Result := true;

  for workspace in mWorkspaces do
  begin
    ix := FavoriteTabFromModEntry(workspace, oldMe);
    if ix >= 0 then
    begin
      workspace.BibleTabs.Tabs[ix] := newMe.VisualSignature();
      workspace.BibleTabs.Tabs.Objects[ix] := newMe;
    end;
  end;
end;

procedure TMainForm.BookChangeModule(Sender: TObject);
var
  book: TBible;
  bookView: TBookFrame;
begin
  book := Sender as TBible;
  if Assigned(book) then
  begin
    bookView := GetBookView(self);
    bookView.UpdateModuleTree(book);

    bookView.tbtnStrongNumbers.Enabled := book.Trait[bqmtStrongs];
  end;
end;

procedure TMainForm.UpdateUIForType(tabType: TViewTabType);
begin
  case tabType of
    vttBook: EnableBookTools(true);
    else EnableBookTools(false);
  end;
end;

procedure TMainForm.EnableBookTools(enable: boolean);
begin
  // TODO: enable/disable print menu items
  //miPrint.Enabled := enable;
  //miPrintPreview.Enabled := enable;
end;

procedure TMainForm.ModifyControl(const AControl: TControl; const ARef: TControlProc);
var
  i : Integer;
begin
  if AControl = nil then
    Exit;

  if AControl is TWinControl then begin
    for i := 0 to TWinControl(AControl).ControlCount - 1 do
      ModifyControl(TWinControl(AControl).Controls[i], ARef);
  end;
  ARef(AControl);
end;

procedure TMainForm.SyncChildrenEnabled(const AControl: TControl);
begin
  ModifyControl(AControl,
    procedure (const AChildControl: TControl)
    begin
      AChildControl.Enabled := AControl.Enabled;
    end
  );
end;

initialization

DefaultDockTreeClass := TThinCaptionedDockTree;

finalization

end.
