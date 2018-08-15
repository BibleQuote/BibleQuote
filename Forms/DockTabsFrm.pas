unit DockTabsFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Tabs, Vcl.DockTabSet, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ToolWin, Htmlview, System.Generics.Collections,
  System.ImageList, Vcl.ImgList, Vcl.Menus, TabData, BibleQuoteUtils,
  ExceptionFrm, Math, MainFrm,
  ChromeTabs, ChromeTabsTypes, ChromeTabsUtils, ChromeTabsControls, ChromeTabsClasses,
  ChromeTabsLog, BookFra, TagsFra;

const
  bsText = 0;
  bsFile = 1;
  bsBookmark = 2;
  bsMemo = 3;
  bsHistory = 4;
  bsSearch = 5;

type
  TDockTabsForm = class(TForm, ITabsView)
    ilImages: TImageList;
    pnlMain: TPanel;
    mViewTabsPopup: TPopupMenu;
    miNewViewTab: TMenuItem;
    miCloseViewTab: TMenuItem;
    miCloseAllOtherTabs: TMenuItem;
    ctViewTabs: TChromeTabs;

    procedure miNewViewTabClick(Sender: TObject);
    procedure miCloseViewTabClick(Sender: TObject);
    procedure miCloseAllOtherTabsClick(Sender: TObject);

    function GetActiveTabInfo(): IViewTabInfo;
    procedure FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    procedure ctViewTabsActiveTabChanged(Sender: TObject; ATab: TChromeTab);
    procedure ctViewTabsActiveTabChanging(Sender: TObject; AOldTab, ANewTab: TChromeTab; var Allow: Boolean);
    procedure ctViewTabsButtonAddClick(Sender: TObject; var Handled: Boolean);
    procedure ctViewTabsButtonCloseTabClick(Sender: TObject; ATab: TChromeTab; var Close: Boolean);
    procedure ctViewTabsTabDblClick(Sender: TObject; ATab: TChromeTab);
    procedure ctViewTabsTabDragDropped(Sender: TObject; DragTabObject: IDragTabObject; NewTab: TChromeTab);
    procedure ctViewTabsTabDragDrop(Sender: TObject; X, Y: Integer; DragTabObject: IDragTabObject; Cancelled: Boolean; var TabDropOptions: TTabDropOptions);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    mMainView: TMainForm;
    mBookView: TBookFrame;
    mTagsView: TTagsFrame;
    mViewTabs: TList<IViewTabInfo>;

    procedure ShowFrame(frame: TFrame);
    procedure HideFrame(frame: TFrame);
    procedure UpdateTabContent(ATab: TChromeTab);
  public
    { Public declarations }

    constructor Create(AOwner: TComponent; mainView: TMainForm); reintroduce;

    procedure CloseActiveTab();
    procedure UpdateBookView();
    function AddBookTab(newTabInfo: TBookTabInfo; const title: string): TChromeTab;
    function AddTagsTab(newTabInfo: TTagsTabInfo): TChromeTab;
    procedure MakeActive();

    // getters
    function GetBrowser: THTMLViewer;
    function GetBookView: IBookView;
    function GetChromeTabs: TChromeTabs;
    function GetBibleTabs: TDockTabSet;
    function GetViewName: string;
    function GetTabInfo(tabIndex: integer): IViewTabInfo; overload;
    function GetTabInfo(data: Pointer): IViewTabInfo; overload;

    // setters
    procedure SetViewName(viewName: string);

    // properties
    property ChromeTabs: TChromeTabs read GetChromeTabs;
    property Browser: THTMLViewer read GetBrowser;
    property BookView: IBookView read GetBookView;
    property BibleTabs: TDockTabSet read GetBibleTabs;
    property ViewName: string read GetViewName write SetViewName;
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

function TDockTabsForm.GetTabInfo(tabIndex: integer): IViewTabInfo;
begin
  Result := nil;
  try
    if (tabIndex >= 0) and (tabIndex < ctViewTabs.Tabs.Count) then
    begin
      Result := GetTabInfo(ctViewTabs.ActiveTab.Data);
    end;
  except on e: Exception do
    // just eat everything wrong
  end;
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
  mMainView := mainView;
end;

procedure TDockTabsForm.ctViewTabsActiveTabChanged(Sender: TObject; ATab: TChromeTab);
begin
  UpdateTabContent(ATab);
end;

procedure TDockTabsForm.UpdateTabContent(ATab: TChromeTab);
var
  tabInfo: IViewTabInfo;
begin
  tabInfo := GetTabInfo(ATab.Data);
  if not Assigned(tabInfo) then
    Exit;

  if (tabInfo.GetViewType = vttBook) then
  begin
    HideFrame(mTagsView);
    ShowFrame(mBookView);

    UpdateBookView();
  end;

  if (tabInfo.GetViewType = vttTags) then
  begin
    HideFrame(mBookView);
    ShowFrame(mTagsView);
  end;
end;

procedure TDockTabsForm.ShowFrame(frame: TFrame);
begin
  frame.Show;
  frame.BringToFront;
end;

procedure TDockTabsForm.HideFrame(frame: TFrame);
begin
  frame.Hide;
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
    begin
      bookTabInfo := TBookTabInfo(tabInfo);
      mMainView.NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, '', bookTabInfo.State, '', true);
      Handled := true;
    end;
  end;
end;

procedure TDockTabsForm.ctViewTabsButtonCloseTabClick(Sender: TObject; ATab: TChromeTab; var Close: Boolean);
begin
  if ctViewTabs.Tabs.Count <= 1 then
    self.Close; // close form when all tabs are closed
end;

procedure TDockTabsForm.ctViewTabsTabDblClick(Sender: TObject; ATab: TChromeTab);
var
  tabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
begin
  tabInfo := GetTabInfo(ATab.Data);
  if (tabInfo.GetViewType = vttBook) then
  begin
    bookTabInfo := TBookTabInfo(tabInfo);
    mMainView.NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, '', bookTabInfo.State, '', true);
  end;
end;

procedure TDockTabsForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i, C: integer;
  data: TObject;
begin
  C := mViewTabs.Count - 1;
  for i := 0 to C do
  begin
    data := TObject(mViewTabs[i]);
    if Assigned(data) then
      data.Free();
  end;
end;

procedure TDockTabsForm.FormCreate(Sender: TObject);
begin
  mTagsView := TTagsFrame.Create(nil);
  mTagsView.Parent := pnlMain;
  mTagsView.Align := alClient;

  mBookView := TBookFrame.Create(nil, mMainView, self);
  mBookView.Parent := pnlMain;
  mBookView.Align := alClient;
  mBookView.Show;
  mBookView.BringToFront;
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
  curTab: TObject;
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
          curTab := TObject(ctViewTabs.Tabs[C].Data);
          ctViewTabs.Tabs.Delete(C);
          mViewTabs.Delete(C);
          Dec(C);
          curTab.Free();
        end;

        C := 0;
        while C < saveTabIndex do
        begin
          curTab := TObject(ctViewTabs.Tabs[0].Data);
          ctViewTabs.Tabs.Delete(0);
          mViewTabs.Delete(0);
          Inc(C);
          curTab.Free();
        end;

      finally
        ctViewTabs.ActiveTabIndex := 0;
        UpdateBookView();
        ctViewTabs.Refresh;
      end;
    end;
  except
    on E: Exception do
      BqShowException(E, Format('ctViewTabs.ActiveTabIndex:%d', [ctViewTabs.ActiveTabIndex]));
  end; // except
end;

procedure TDockTabsForm.CloseActiveTab();
var
  tabInfo: TBookTabInfo;
  tabIndex: integer;
begin
  tabIndex := ctViewTabs.ActiveTabIndex;
  if (tabIndex >= 0) and (tabIndex < ctViewTabs.Tabs.Count) then
  begin
    tabInfo := TBookTabInfo(ctViewTabs.Tabs[tabIndex].Data);

    ctViewTabs.Tabs.Delete(tabIndex);
    mViewTabs.Delete(tabIndex);
    ctViewTabs.ActiveTabIndex := IfThen(tabIndex = ctViewTabs.Tabs.Count, tabIndex - 1, tabIndex);

    tabInfo.Free();

    if ctViewTabs.Tabs.Count = 0 then
      self.Close; // close form when all tabs are closed
  end;
end;

procedure TDockTabsForm.miCloseViewTabClick(Sender: TObject);
begin
  CloseActiveTab;
end;

procedure TDockTabsForm.miNewViewTabClick(Sender: TObject);
var
  activeTabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
begin
  activeTabInfo := GetActiveTabInfo();
  if (activeTabInfo is TBookTabInfo) then
  begin
    bookTabInfo := activeTabInfo as TBookTabInfo;
    mMainView.NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, '', bookTabInfo.State, '', true);
  end;
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

    try
      mBookView.bwrHtml.NoScollJump := true;
      mMainView.UpdateUI();

      if (bookTabInfo.IsCompareTranslation) then
      begin
        mBookView.bwrHtml.LoadFromString(bookTabInfo.CompareTranslationText);
      end
      else
      begin
        mBookView.ProcessCommand(bookTabInfo.Location, TbqHLVerseOption(ord(bookTabInfo[vtisHighLightVerses])));
      end;

      bookTabInfo.RestoreState(self);
    finally
      mBookView.bwrHtml.NoScollJump := false;
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

function TDockTabsForm.GetActiveTabInfo(): IViewTabInfo;
begin
  Result := GetTabInfo(ctViewTabs.ActiveTabIndex);
end;

function TDockTabsForm.AddBookTab(newTabInfo: TBookTabInfo; const title: string): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := title;
  newTab.Data := newTabInfo;

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

function TDockTabsForm.AddTagsTab(newTabInfo: TTagsTabInfo): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ctViewTabs.Tabs.Add;
  newTab.Caption := 'Zakladki';
  newTab.Data := newTabInfo;

  mViewTabs.Add(newTabInfo);
  UpdateTabContent(newTab);

  Result := newTab;
end;

end.
