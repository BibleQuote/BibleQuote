unit DockTabsFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Tabs, Vcl.DockTabSet, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ToolWin, Htmlview, System.Generics.Collections,
  System.ImageList, Vcl.ImgList, Vcl.Menus, TabData, BibleQuoteUtils,
  ExceptionFrm, Math, MainFrm,
  ChromeTabs, ChromeTabsTypes, ChromeTabsUtils, ChromeTabsControls, ChromeTabsClasses,
  ChromeTabsLog, BookFra, MemoFra, LibraryFra, LayoutConfig, BookmarksFra,
  SearchFra, TSKFra, TagsVersesFra, DictionaryFra, StrongFra, AppIni,
  JclNotify, NotifyMessages, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, IOUtils, ImageUtils, CommentsFra;

const
  bsText = 0;
  bsFile = 1;
  bsBookmark = 2;
  bsMemo = 3;
  bsHistory = 4;
  bsSearch = 5;

type
  TDockTabsForm = class(TForm, IWorkspace, IJclListener)
    pnlMain: TPanel;
    pmTabs: TPopupMenu;
    miCloseTab: TMenuItem;
    miCloseAllOtherTabs: TMenuItem;
    ctViewTabs: TChromeTabs;
    imgIcons: TImageCollection;
    vImgIcons: TVirtualImageList;
    miSeparator: TMenuItem;
    miCloseAllTabs: TMenuItem;

    procedure miCloseTabClick(Sender: TObject);
    procedure miCloseAllOtherTabsClick(Sender: TObject);

    function GetActiveTabInfo(): IViewTabInfo;
    procedure FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    procedure ctViewTabsActiveTabChanged(Sender: TObject; ATab: TChromeTab);
    procedure ctViewTabsActiveTabChanging(Sender: TObject; AOldTab, ANewTab: TChromeTab; var Allow: Boolean);
    procedure ctViewTabsButtonAddClick(Sender: TObject; var Handled: Boolean);
    procedure ctViewTabsButtonCloseTabClick(Sender: TObject; ATab: TChromeTab; var Close: Boolean);
    procedure ctViewTabsTabDragDropped(Sender: TObject; DragTabObject: IDragTabObject; NewTab: TChromeTab);
    procedure ctViewTabsTabDragDrop(Sender: TObject; X, Y: Integer; DragTabObject: IDragTabObject; Cancelled: Boolean; var TabDropOptions: TTabDropOptions);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure mViewTabsOnPopup(Sender: TObject);
    procedure miCloseAllTabsClick(Sender: TObject);
  private
    { Private declarations }
    mMainView: TMainForm;
    mBookView: TBookFrame;
    mMemoView: TMemoFrame;
    mLibraryView: TLibraryFrame;
    mBookmarksView: TBookmarksFrame;
    mSearchView: TSearchFrame;
    mTSKView: TTSKFrame;
    mTagsVersesView: TTagsVersesFrame;
    mDictionaryView: TDictionaryFrame;
    mStrongView: TStrongFrame;
    mCommentsView: TCommentsFrame;

    mNotifier: IJclNotifier;

    mUpdateOnTabChange: boolean;

    mViewTabs: TList<IViewTabInfo>;
    mFrames: TList<TFrame>;

    mContextMenuStaticItems: integer;

    procedure ActivateFrame(frameToActivate: TFrame);
    procedure UpdateTabContent(ATab: TChromeTab; restoreState: boolean = true);
    procedure Notification(Msg: IJclNotificationMessage); stdcall;
    procedure PopupChangeTab(Sender: TObject);
    procedure ApplyConfigFont(appConfig: TAppConfig);
    function GetImageCacheIndex(newTabInfo: TBookTabInfo): integer;
    function CacheImage(name: string; thumbnailImage: TWICImage): integer;
    procedure ClearViewTabs();
  public
    { Public declarations }

    constructor Create(AOwner: TComponent; mainView: TMainForm); reintroduce;
    destructor Destroy; override;

    procedure CloseActiveTab();
    procedure UpdateCurrentTabContent(restoreState: boolean);
    procedure UpdateBookView();
    procedure UpdateViewAs(tabType: TViewTabType);

    function AddBookTab(newTabInfo: TBookTabInfo): TChromeTab;
    function AddMemoTab(newTabInfo: TMemoTabInfo): TChromeTab;
    function AddLibraryTab(newTabInfo: TLibraryTabInfo): TChromeTab;
    function AddBookmarksTab(newTabInfo: TBookmarksTabInfo): TChromeTab;
    function AddSearchTab(newTabInfo: TSearchTabInfo): TChromeTab;
    function AddTSKTab(newTabInfo: TTSKTabInfo): TChromeTab;
    function AddTagsVersesTab(newTabInfo: TTagsVersesTabInfo): TChromeTab;
    function AddDictionaryTab(newTabInfo: TDictionaryTabInfo): TChromeTab;
    function AddStrongTab(newTabInfo: TStrongTabInfo): TChromeTab;
    function AddCommentsTab(newTabInfo: TCommentsTabInfo): TChromeTab;

    procedure UpdateBookTabHeader();
    procedure OnSelectModule(Sender: TObject; modEntry: TModuleEntry);

    procedure CreateNewBookTab();

    procedure MakeActive();
    procedure Translate();
    procedure ApplyConfig(appConfig: TAppConfig);

    // getters
    function GetBrowser: THTMLViewer;
    function GetBookView: IBookView;
    function GetMemoView: IMemoView;
    function GetLibraryView: ILibraryView;
    function GetBookmarksView: IBookmarksView;
    function GetSearchView: ISearchView;
    function GetTSKView: ITSKView;
    function GetTagsVersesView: ITagsVersesView;
    function GetDictionaryView: IDictionaryView;
    function GetStrongView: IStrongView;
    function GetCommentsView: ICommentsView;
    function GetChromeTabs: TChromeTabs;
    function GetBibleTabs: TDockTabSet;
    function GetViewName: string;
    function GetTabInfo(tabIndex: integer): IViewTabInfo; overload;
    function GetTabInfo(data: Pointer): IViewTabInfo; overload;
    function GetUpdateOnTabChange: boolean;
    procedure SetUpdateOnTabChange(b: boolean);

    // setters
    procedure SetViewName(viewName: string);

    // properties
    property ChromeTabs: TChromeTabs read GetChromeTabs;
    property Browser: THTMLViewer read GetBrowser;
    property BookView: IBookView read GetBookView;
    property MemoView: IMemoView read GetMemoView;
    property LibraryView: ILibraryView read GetLibraryView;
    property BookmarksView: IBookmarksView read GetBookmarksView;
    property SearchView: ISearchView read GetSearchView;
    property CommentsView: ICommentsView read GetCommentsView;
    property BibleTabs: TDockTabSet read GetBibleTabs;
    property ViewName: string read GetViewName write SetViewName;
    property UpdateOnTabChange: boolean read GetUpdateOnTabChange write SetUpdateOnTabChange;
  end;

implementation

{$R *.dfm}

function TDockTabsForm.GetChromeTabs(): TChromeTabs;
begin
  Result := ctViewTabs;
end;

function TDockTabsForm.GetBrowser(): THTMLViewer;
begin
  Result := mBookView.bwrHtml;
end;

function TDockTabsForm.GetBookView(): IBookView;
begin
  Result := mBookView as IBookView;
end;

function TDockTabsForm.GetMemoView(): IMemoView;
begin
  Result := mMemoView as IMemoView;
end;

function TDockTabsForm.GetLibraryView(): ILibraryView;
begin
  Result := mLibraryView as ILibraryView;
end;

function TDockTabsForm.GetSearchView(): ISearchView;
begin
  Result := mSearchView as ISearchView;
end;

function TDockTabsForm.GetBookmarksView(): IBookmarksView;
begin
  Result := mBookmarksView as IBookmarksView;
end;

function TDockTabsForm.GetTSKView(): ITSKView;
begin
  Result := mTSKView as ITSKView;
end;

function TDockTabsForm.GetTagsVersesView(): ITagsVersesView;
begin
  Result := mTagsVersesView as ITagsVersesView;
end;

function TDockTabsForm.GetDictionaryView(): IDictionaryView;
begin
  Result := mDictionaryView as IDictionaryView;
end;

function TDockTabsForm.GetStrongView(): IStrongView;
begin
  Result := mStrongView as IStrongView;
end;

function TDockTabsForm.GetCommentsView(): ICommentsView;
begin
  Result := mCommentsView as ICommentsView;
end;

function TDockTabsForm.GetBibleTabs(): TDockTabSet;
begin
  Result := mBookView.dtsBible;
end;

function TDockTabsForm.GetViewName(): string;
begin
  Result := Name;
end;

procedure TDockTabsForm.SetViewName(viewName: string);
begin
  Name := viewName;
end;

function TDockTabsForm.CacheImage(name: string; thumbnailImage: TWICImage): integer;
var
  imageItem: TImageCollectionItem;
  thumbnailSource: TImageCollectionSourceItem;
  imageIndex: integer;
begin
  imageItem := imgIcons.Images.Add;
  thumbnailSource := imageItem.SourceImages.Add;
  thumbnailSource.Image := thumbnailImage;
  imageIndex := imgIcons.Count - 1;

  // add it to image list
  vImgIcons.Add(name, imageIndex);

  Result := imageIndex;
end;

function TDockTabsForm.GetImageCacheIndex(newTabInfo: TBookTabInfo): integer;
var
  coverImagePath: string;
  coverName: string;
  thumbnailImage: TWICImage;
  imageIndex: integer;
  defCoverImage: TWICImage;
begin
  imageIndex := -1;

  // check if book has cover image
  if (newTabInfo.Bible.ModuleImage <> '') then
  begin
    coverImagePath := TPath.Combine(newTabInfo.Bible.ShortPath, newTabInfo.Bible.ModuleImage);
    coverName := coverImagePath;
    try
      // check if image already cached
      imageIndex := vImgIcons.GetIndexByName(coverName);
      if (imageIndex < 0) and (FileExists(coverImagePath)) then
      begin
        // create thumbnail from cover image and cache it
        thumbnailImage := CreateThumbnailFromFile(coverImagePath, 64, 64);
        imageIndex := CacheImage(coverName, thumbnailImage);
      end;
    except
      on Exception do imageIndex := -1;
    end;
  end;

  if (imageIndex < 0) then
  begin
    // book doesn't have cover image, apply default cover
    coverName := 'CoverDefault';
    try
      // check if image already cached
      imageIndex := vImgIcons.GetIndexByName(coverName);
      if (imageIndex < 0) then
      begin
        // create thumbnail from default cover image and cache it
        defCoverImage := nil;
        try
          defCoverImage := LoadResourceWICImage('CoverDefault');
          thumbnailImage := CreateThumbnail(defCoverImage, 64, 64);
          imageIndex := CacheImage(coverName, thumbnailImage);
        finally
          if Assigned(defCoverImage) then
            defCoverImage.Free;
        end;
      end;
    except
      on Exception do imageIndex := -1;
    end;
  end;

  result := imageIndex;
end;

procedure TDockTabsForm.ApplyConfigFont(appConfig: TAppConfig);
begin
  if (appConfig.MainFormFontName <> Font.Name) then
  begin
    Font.Name := appConfig.MainFormFontName;
    ctViewTabs.LookAndFeel.Tabs.NotActive.Font.Name := appConfig.MainFormFontName;
    ctViewTabs.LookAndFeel.Tabs.Active.Font.Name := appConfig.MainFormFontName;
    ctViewTabs.LookAndFeel.Tabs.Hot.Font.Name := appConfig.MainFormFontName;
    ctViewTabs.LookAndFeel.Tabs.DefaultFont.Name := appConfig.MainFormFontName;
  end;

  if (appConfig.MainFormFontSize <> Font.Size) then
  begin
    Font.Size := appConfig.MainFormFontSize;
    ctViewTabs.LookAndFeel.Tabs.NotActive.Font.Size := appConfig.MainFormFontSize;
    ctViewTabs.LookAndFeel.Tabs.Active.Font.Size := appConfig.MainFormFontSize;
    ctViewTabs.LookAndFeel.Tabs.Hot.Font.Size := appConfig.MainFormFontSize;
    ctViewTabs.LookAndFeel.Tabs.DefaultFont.Size := appConfig.MainFormFontSize;
  end;
end;

function TDockTabsForm.GetTabInfo(tabIndex: integer): IViewTabInfo;
begin
  Result := nil;
  try
    if (tabIndex >= 0) and (tabIndex < ctViewTabs.Tabs.Count) then
    begin
      Result := GetTabInfo(ctViewTabs.Tabs[tabIndex].Data);
    end;
  except on e: Exception do
    // just eat everything wrong
  end;
end;

function TDockTabsForm.GetUpdateOnTabChange: boolean;
begin
  Result := mUpdateOnTabChange;
end;

procedure TDockTabsForm.SetUpdateOnTabChange(b: boolean);
begin
  mUpdateOnTabChange := b;
end;

function TDockTabsForm.GetTabInfo(data: Pointer): IViewTabInfo;
var
  obj: TObject;
  intf: IViewTabInfo;
begin
  Result := nil;
  try
    obj := TObject(data);
    if Assigned(obj) then
    begin
      if Supports(obj, IViewTabInfo, intf) then
        Result := intf;
    end;
  except on e: Exception do
    // just eat everything wrong
  end;
end;

constructor TDockTabsForm.Create(AOwner: TComponent; mainView: TMainForm);
begin
  inherited Create(AOwner);
  mViewTabs := TList<IViewTabInfo>.Create();

  mFrames := TList<TFrame>.Create();

  mMainView := mainView;
  mUpdateOnTabChange := true;

  mNotifier := mainView.mNotifier;
  mNotifier.Add(self);

  mContextMenuStaticItems := pmTabs.Items.Count;

  ApplyConfigFont(AppConfig);
end;

procedure TDockTabsForm.ctViewTabsActiveTabChanged(Sender: TObject; ATab: TChromeTab);
begin
  if (mUpdateOnTabChange) then
    UpdateTabContent(ATab);
end;

procedure TDockTabsForm.UpdateCurrentTabContent(restoreState: boolean);
begin
  UpdateTabContent(ctViewTabs.Tabs.ActiveTab, restoreState);
end;

procedure TDockTabsForm.UpdateTabContent(ATab: TChromeTab; restoreState: boolean);
var
  tabInfo: IViewTabInfo;
begin
  tabInfo := GetTabInfo(ATab.Data);
  if not Assigned(tabInfo) then
    Exit;

  mMainView.UpdateUIForType(tabInfo.GetViewType);
  if (tabInfo.GetViewType = vttBook) then
  begin
    ActivateFrame(mBookView);
    if (restoreState) then
      UpdateBookView();
  end;

  if (tabInfo.GetViewType = vttMemo) then
  begin
    ActivateFrame(mMemoView);
    mMainView.ClearCopyrights();
  end;

  if (tabInfo.GetViewType = vttLibrary) then
  begin
    ActivateFrame(mLibraryView);
    mLibraryView.SetModules(mMainView.mModules);
    mMainView.ClearCopyrights();
  end;

  if (tabInfo.GetViewType = vttBookmarks) then
  begin
    ActivateFrame(mBookmarksView);
    mMainView.ClearCopyrights();
  end;

  if (tabInfo.GetViewType = vttSearch) then
  begin
    ActivateFrame(mSearchView);
    mMainView.ClearCopyrights();
    if (restoreState) then
      UpdateViewAs(vttSearch);
  end;

  if (tabInfo.GetViewType = vttTSK) then
  begin
    ActivateFrame(mTSKView);
    mMainView.ClearCopyrights();
    if (restoreState) then
      UpdateViewAs(vttTSK);
  end;

  if (tabInfo.GetViewType = vttTagsVerses) then
  begin
    ActivateFrame(mTagsVersesView);
    mMainView.ClearCopyrights();
    if (restoreState) then
      UpdateViewAs(vttTagsVerses);
  end;

  if (tabInfo.GetViewType = vttDictionary) then
  begin
    ActivateFrame(mDictionaryView);
    mMainView.ClearCopyrights();
    if (restoreState) then
      UpdateViewAs(vttDictionary);
  end;

  if (tabInfo.GetViewType = vttStrong) then
  begin
    ActivateFrame(mStrongView);
    mMainView.ClearCopyrights();
    if (restoreState) then
      UpdateViewAs(vttStrong);
  end;

  if (tabInfo.GetViewType = vttComments) then
  begin
    ActivateFrame(mCommentsView);
    mMainView.ClearCopyrights();
    if (restoreState) then
      UpdateViewAs(vttComments);
  end;
end;

procedure TDockTabsForm.ActivateFrame(frameToActivate: TFrame);
var
  frame: TFrame;
begin
  if not Assigned(frameToActivate) then
    Exit;

  frameToActivate.Show;
  frameToActivate.BringToFront;

  for frame in mFrames do
  begin
    if (frame <> frameToActivate) then
      frame.Hide;
  end;
end;

procedure TDockTabsForm.ctViewTabsActiveTabChanging(Sender: TObject; AOldTab, ANewTab: TChromeTab; var Allow: Boolean);
var
  tabInfo: IViewTabInfo;
begin
  if (ctViewTabs.ActiveTabIndex >= 0) then
  begin
    tabInfo := GetTabInfo(ctViewTabs.ActiveTabIndex);

    if not Assigned(tabInfo) then
      Exit;

    tabInfo.SaveState(self);
  end;
end;

procedure TDockTabsForm.ctViewTabsButtonAddClick(Sender: TObject; var Handled: Boolean);
var
  index: integer;
  tabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
begin
  index := ctViewTabs.ActiveTabIndex;
  if (index >= 0) and (index < ctViewTabs.Tabs.Count) then
  begin
    tabInfo := GetTabInfo(index);
    if (tabInfo.GetViewType = vttBook) then
      bookTabInfo := TBookTabInfo(tabInfo)
    else
      bookTabInfo := mMainView.CreateNewBookTabInfo();

    mMainView.NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, bookTabInfo.State, '', true);
    Handled := true;
  end;
end;

procedure TDockTabsForm.ctViewTabsButtonCloseTabClick(Sender: TObject; ATab: TChromeTab; var Close: Boolean);
begin
  if ctViewTabs.Tabs.Count <= 1 then
    self.Close; // close form when all tabs are closed
end;

procedure TDockTabsForm.FormCreate(Sender: TObject);
begin
  mMemoView := TMemoFrame.Create(nil);
  mMemoView.Parent := pnlMain;
  mMemoView.Align := alClient;

  mLibraryView := TLibraryFrame.Create(nil);
  mLibraryView.Parent := pnlMain;
  mLibraryView.Align := alClient;
  mLibraryView.OnSelectModule := OnSelectModule;

  mSearchView := TSearchFrame.Create(nil, mMainView, self);
  mSearchView.Parent := pnlMain;
  mSearchView.Align := alClient;

  mBookmarksView := TBookmarksFrame.Create(nil, mMainView, self, mMainView.Bookmarks);
  mBookmarksView.Parent := pnlMain;
  mBookmarksView.Align := alClient;

  mBookView := TBookFrame.Create(nil, mMainView, self);
  mBookView.Parent := pnlMain;
  mBookView.Align := alClient;
  mBookView.Show;
  mBookView.BringToFront;

  mTSKView := TTSKFrame.Create(nil, mMainView, self);
  mTSKView.Parent := pnlMain;
  mTSKView.Align := alClient;

  mTagsVersesView := TTagsVersesFrame.Create(nil, mMainView, self);
  mTagsVersesView.Parent := pnlMain;
  mTagsVersesView.Align := alClient;

  mDictionaryView := TDictionaryFrame.Create(nil, mMainView, self);
  mDictionaryView.Parent := pnlMain;
  mDictionaryView.Align := alClient;

  mStrongView := TStrongFrame.Create(nil, mMainView, self);
  mStrongView.Hide;
  mStrongView.Parent := pnlMain;
  mStrongView.Align := alClient;

  mCommentsView := TCommentsFrame.Create(nil, mMainView, self);
  mCommentsView.Hide;
  mCommentsView.Parent := pnlMain;
  mCommentsView.Align := alClient;

  mFrames.AddRange([
    mBookView,
    mMemoView,
    mLibraryView,
    mBookmarksView,
    mSearchView,
    mTSKView,
    mTagsVersesView,
    mDictionaryView,
    mStrongView,
    mCommentsView]);
end;

procedure TDockTabsForm.FormDeactivate(Sender: TObject);
var
  tabInfo: IViewTabInfo;
begin
  // save active tab state
  tabInfo := GetActiveTabInfo();
  if Assigned(tabInfo) then
    tabInfo.SaveState(self);
end;

procedure TDockTabsForm.OnSelectModule(Sender: TObject; modEntry: TModuleEntry);
begin
  mMainView.ActivateModuleView(modEntry);
end;

procedure TDockTabsForm.UpdateBookTabHeader();
var
  activeTabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
begin
  activeTabInfo := GetActiveTabInfo();
  if (activeTabInfo is TBookTabInfo) then
  begin
    bookTabInfo := activeTabInfo as TBookTabInfo;

    ChromeTabs.ActiveTab.ImageIndex := GetImageCacheIndex(bookTabInfo);
    ChromeTabs.ActiveTab.Caption := bookTabInfo.Title;
  end;
end;

procedure TDockTabsForm.MakeActive();
begin
  // activate form when any of its control is clicked
  if (not Active) then
  begin
    Activate();
  end;
end;

procedure TDockTabsForm.FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
begin
  MakeActive;
end;

procedure TDockTabsForm.miCloseAllOtherTabsClick(Sender: TObject);
var
  saveTabIndex: integer;
  C: integer;
begin
  try
    if (ctViewTabs.Tabs.Count <= 1) then
    begin
      MessageBeep(MB_ICONEXCLAMATION);
      Exit;
    end;

    saveTabIndex := ctViewTabs.ActiveTabIndex;
    if (saveTabIndex >= 0) and (saveTabIndex < ctViewTabs.Tabs.Count) then
    begin
      C := ctViewTabs.Tabs.Count - 1;
      try
        while C > saveTabIndex do
        begin
          ctViewTabs.Tabs.Delete(C);
          mViewTabs.Delete(C);
          Dec(C);
        end;

        C := 0;
        while C < saveTabIndex do
        begin
          ctViewTabs.Tabs.Delete(0);
          mViewTabs.Delete(0);
          Inc(C);
        end;

      finally
        ctViewTabs.ActiveTabIndex := 0;
        UpdateTabContent(ctViewTabs.ActiveTab);
        ctViewTabs.Refresh;
      end;
    end;
  except
    on E: Exception do
      BqShowException(E, Format('ctViewTabs.ActiveTabIndex:%d', [ctViewTabs.ActiveTabIndex]));
  end; // except
end;

procedure TDockTabsForm.miCloseAllTabsClick(Sender: TObject);
begin
  ctViewTabs.Tabs.Clear;
  mViewTabs.Clear;

  Close;
end;

procedure TDockTabsForm.ClearViewTabs;
begin
  mViewTabs.Clear;
end;

procedure TDockTabsForm.CloseActiveTab();
var
  tabIndex: integer;
begin
  tabIndex := ctViewTabs.ActiveTabIndex;
  if (tabIndex >= 0) and (tabIndex < ctViewTabs.Tabs.Count) then
  begin
    ctViewTabs.Tabs.Delete(tabIndex);
    mViewTabs.Delete(tabIndex);
    ctViewTabs.ActiveTabIndex := IfThen(tabIndex = ctViewTabs.Tabs.Count, tabIndex - 1, tabIndex);

    if ctViewTabs.Tabs.Count = 0 then
      self.Close; // close form when all tabs are closed
  end;
end;

procedure TDockTabsForm.miCloseTabClick(Sender: TObject);
begin
  CloseActiveTab;
end;

procedure TDockTabsForm.mViewTabsOnPopup(Sender: TObject);
var
  i: integer;
  tabMenu: TMenuItem;
  tab: TChromeTab;
begin
  // remove all dynamic menu items
  while pmTabs.Items.Count > mContextMenuStaticItems do
    pmTabs.Items[0].Free;

  try
    for i := 0 to ctViewTabs.Tabs.Count - 1 do
    begin
      tabMenu := TMenuItem.Create(pmTabs);

      tab := ctViewTabs.Tabs.Items[i];
      tabMenu.Tag := i;
      tabMenu.Caption := tab.Caption;
      tabMenu.ImageIndex := tab.ImageIndex;
      tabMenu.Checked := i = ctViewTabs.ActiveTabIndex;
      tabMenu.OnClick := PopupChangeTab;

      pmTabs.Items.Insert(i, tabMenu);
    end;
  except
    // skip error
  end;
end;

procedure TDockTabsForm.PopupChangeTab(Sender: TObject);
var
  menuItem: TMenuItem;
begin
  menuItem := TMenuItem(Sender);
  if Assigned(menuItem) and (menuItem.Tag >= 0) then
    ctViewTabs.ActiveTabIndex := menuItem.Tag;
end;

procedure TDockTabsForm.CreateNewBookTab();
var
  activeTabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
begin
  activeTabInfo := GetActiveTabInfo();
  if (activeTabInfo is TBookTabInfo) then
  begin
    bookTabInfo := activeTabInfo as TBookTabInfo;
  end
  else
  begin
    bookTabInfo := mMainView.CreateNewBookTabInfo();
  end;

  mMainView.NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, bookTabInfo.State, '', true);
end;

procedure TDockTabsForm.UpdateViewAs(tabType: TViewTabType);
var
  tabInfo: IViewTabInfo;
begin
  tabInfo := GetActiveTabInfo();
  if (not Assigned(tabInfo)) or (not (tabInfo.GetViewType = tabType)) then
    Exit;

  tabInfo.RestoreState(self);
end;

procedure TDockTabsForm.UpdateBookView();
var
  tabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
begin
  try
    tabInfo := GetActiveTabInfo();
    if (not Assigned(tabInfo)) or (not (tabInfo is TBookTabInfo)) then
      Exit;

    bookTabInfo := tabInfo as TBookTabInfo;
    mBookView.HistoryOn := false;
    try
      mBookView.bwrHtml.NoScollJump := true;
      mMainView.UpdateBookView();

      if (bookTabInfo.IsCompareTranslation) then
        mBookView.bwrHtml.LoadFromString(bookTabInfo.CompareTranslationText)
      else
        mBookView.ProcessCommand(bookTabInfo, bookTabInfo.Location, TbqHLVerseOption(ord(bookTabInfo[vtisHighLightVerses])));

      bookTabInfo.RestoreState(self);
    finally
      mBookView.bwrHtml.NoScollJump := false;
      mBookView.HistoryOn := true;
    end;
  except
    on E: Exception do
      BqShowException(E) { just eat everything wrong }
  end;
end;

procedure TDockTabsForm.ctViewTabsTabDragDrop(Sender: TObject; X, Y: Integer; DragTabObject: IDragTabObject; Cancelled: Boolean; var TabDropOptions: TTabDropOptions);
var
  srcTabs: TChromeTabs;
  dstTabs: TChromeTabs;
  dstContrl: IChromeTabDockControl;
begin
  srcTabs := DragTabObject.SourceControl.GetControl as TChromeTabs;
  dstContrl := DragTabObject.DockControl;

  if (not Assigned(dstContrl)) then
  begin
    exclude(TabDropOptions, tdDeleteDraggedTab);
    exit;
  end;

  dstTabs := dstContrl.GetControl as TChromeTabs;
  if (dstTabs = srcTabs) then
    exclude(TabDropOptions, tdDeleteDraggedTab);
end;

procedure TDockTabsForm.ctViewTabsTabDragDropped(Sender: TObject; DragTabObject: IDragTabObject; NewTab: TChromeTab);
var
  srcTabs: TChromeTabs;
  dstTabs: TChromeTabs;
  dstForm: TDockTabsForm;
begin
  srcTabs := DragTabObject.SourceControl.GetControl as TChromeTabs;
  dstTabs := DragTabObject.DockControl.GetControl as TChromeTabs;

  // We've dropped the tab on another tab control
  if (dstTabs <> srcTabs) then
  begin
    if ((srcTabs = ctViewTabs) and (srcTabs.Tabs.Count <= 1)) then
    begin
      self.Close;
    end
    else
    begin
      dstForm := dstTabs.Owner as TDockTabsForm;
      if Assigned(dstForm) then
      begin
        dstForm.Activate();
        dstForm.OnActivate(self);
      end;
    end;
  end;
end;

destructor TDockTabsForm.Destroy;
begin

  ClearViewTabs();

  inherited;
end;

function TDockTabsForm.GetActiveTabInfo(): IViewTabInfo;
begin
  Result := GetTabInfo(ctViewTabs.ActiveTabIndex);
end;

function TDockTabsForm.AddBookTab(newTabInfo: TBookTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := newTabInfo.Title;
  newTab.Data := newTabInfo;

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  newTab.ImageIndex := GetImageCacheIndex(newTabInfo);
  Result := newTab;
end;

function TDockTabsForm.AddMemoTab(newTabInfo: TMemoTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabMemos', 'Memos');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('memoTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddBookmarksTab(newTabInfo: TBookmarksTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabBookmarks', 'Bookmarks');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('bookmarksTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddSearchTab(newTabInfo: TSearchTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabSearch', 'Search');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('searchTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddLibraryTab(newTabInfo: TLibraryTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabLibrary', 'My Library');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('libraryTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddTSKTab(newTabInfo: TTSKTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabTSK', 'TSK');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('tskTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddTagsVersesTab(newTabInfo: TTagsVersesTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabTagsVerses', 'Themed Bookmarks');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('themedBookmarksTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddDictionaryTab(newTabInfo: TDictionaryTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabDictionary', 'Dictionary');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('dictionaryTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddStrongTab(newTabInfo: TStrongTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabStrong', 'Strong');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('strongTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddCommentsTab(newTabInfo: TCommentsTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := Lang.SayDefault('TabCommentaries', 'Commentaries');
  newTab.Data := newTabInfo;
  newTab.ImageIndex := vImgIcons.GetIndexByName('commentsTab');

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

procedure TDockTabsForm.Notification(Msg: IJclNotificationMessage);
var
  MsgAppConfigChanged: IAppConfigChangedMessage;
  MsgActiveBookChanged: IActiveBookChangedMessage;
  ActiveTabInfo: IViewTabInfo;
  CommentsTabInfo: TCommentsTabInfo;
begin
  if Supports(Msg, IAppConfigChangedMessage, MsgAppConfigChanged) then
  begin
    ApplyConfig(AppConfig);
  end;

  if Supports(Msg, IActiveBookChangedMessage, MsgActiveBookChanged) then
  begin
    ActiveTabInfo := GetActiveTabInfo();
    if (ActiveTabInfo is TCommentsTabInfo) then
    begin
      mCommentsView.SetSourceBook(MsgActiveBookChanged.GetActiveBook);
      ActiveTabInfo.SaveState(Self);
    end;
  end;
end;

procedure TDockTabsForm.ApplyConfig(appConfig: TAppConfig);
begin
  try
    mBookView.ApplyConfig(appConfig);
    mMemoView.ApplyConfig(appConfig);
    mLibraryView.ApplyConfig(appConfig);
    mBookmarksView.ApplyConfig(appConfig);
    mSearchView.ApplyConfig(appConfig);
    mTagsVersesView.ApplyConfig(appConfig);
    mDictionaryView.ApplyConfig(appConfig);
    mStrongView.ApplyConfig(appConfig);
    mTSKView.ApplyConfig(appConfig);
    mCommentsView.ApplyConfig(appConfig);
  except
    on E: Exception do
    begin
      // Failed to translate exception form
      // Suppress the exception
    end;
  end;

  ApplyConfigFont(appConfig);
end;

procedure TDockTabsForm.Translate();
var
  chromeTab: TChromeTab;
  tabInfo: IViewTabInfo;
  i: integer;
begin
  try
      Lang.TranslateControl(self, 'DockTabsForm');
      mBookView.Translate();
      mMemoView.Translate();
      mLibraryView.Translate();
      mBookmarksView.Translate();
      mSearchView.Translate();
      mTagsVersesView.Translate();
      mDictionaryView.Translate();
      mStrongView.Translate();
      mTSKView.Translate();
      mCommentsView.Translate();

      for i := 0 to ctViewTabs.Tabs.Count - 1 do
      begin
        chromeTab := ctViewTabs.Tabs[i];
        tabInfo := GetTabInfo(chromeTab.Data);
        chromeTab.Caption := tabInfo.GetCaption();
      end;
  except
    on E: Exception do
    begin
      // Failed to translate exception form
      // Suppress the exception
    end;
  end;
end;

end.
