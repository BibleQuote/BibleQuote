unit DockTabsFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Tabs, Vcl.DockTabSet, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ToolWin, Htmlview,
  System.ImageList, Vcl.ImgList, Vcl.Menus, TabData, BibleQuoteUtils,
  ExceptionFrm, Math, ViewIntf, MainFrm,
  ChromeTabs, ChromeTabsTypes, ChromeTabsUtils, ChromeTabsControls, ChromeTabsClasses,
  ChromeTabsLog, BookFra;

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

    function GetActiveTabInfo(): TViewTabInfo;
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
  private
    { Private declarations }
    mMainView: TMainForm;
    mBookView: TBookFrame;
  public
    { Public declarations }

    constructor Create(AOwner: TComponent; mainView: TMainForm); reintroduce;

    procedure CloseActiveTab();
    procedure UpdateViewTabs();
    function AddBookTab(newTabInfo: TViewTabInfo; const title: string): TChromeTab;
    procedure MakeActive();

    // getters
    function GetBrowser: THTMLViewer;
    function GetBookView: IBookView;
    function GetViewTabs: TChromeTabs;
    function GetBibleTabs: TDockTabSet;
    function GetViewName: string;

    // setters
    procedure SetViewName(viewName: string);

    // properties
    property ViewTabs: TChromeTabs read GetViewTabs;
    property Browser: THTMLViewer read GetBrowser;
    property BookView: IBookView read GetBookView;
    property BibleTabs: TDockTabSet read GetBibleTabs;
    property ViewName: string read GetViewName write SetViewName;
  end;

implementation

{$R *.dfm}

function TDockTabsForm.GetViewTabs(): TChromeTabs;
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

constructor TDockTabsForm.Create(AOwner: TComponent; mainView: TMainForm);
begin
  inherited Create(AOwner);
  mMainView := mainView;
end;

procedure TDockTabsForm.ctViewTabsActiveTabChanged(Sender: TObject; ATab: TChromeTab);
begin
  UpdateViewTabs();
end;

procedure TDockTabsForm.ctViewTabsActiveTabChanging(Sender: TObject; AOldTab, ANewTab: TChromeTab; var Allow: Boolean);
var
  tabInfo: TViewTabInfo;
begin
  if (ctViewTabs.ActiveTabIndex >= 0) then
  begin
    tabInfo := TViewTabInfo(ctViewTabs.ActiveTab.Data);
    if not Assigned(tabInfo) then
      Exit;

    tabInfo.SaveBrowserState(mBookView.bwrHtml);
  end;
end;

procedure TDockTabsForm.ctViewTabsButtonAddClick(Sender: TObject; var Handled: Boolean);
var
  ti: TViewTabInfo;
  sourceTab: TChromeTab;
begin
  sourceTab := ctViewTabs.ActiveTab;
  if not Assigned(sourceTab) then
    sourceTab := ctViewTabs.Tabs[0];

  ti := TViewTabInfo(sourceTab.Data);
  if not Assigned(ti) then
    Exit;
  mMainView.NewViewTab(ti.Location, ti.SatelliteName, '', ti.State, '', true);
  Handled := true;
end;

procedure TDockTabsForm.ctViewTabsButtonCloseTabClick(Sender: TObject; ATab: TChromeTab; var Close: Boolean);
begin
  if ctViewTabs.Tabs.Count <= 1 then
    self.Close; // close form when all tabs are closed
end;

procedure TDockTabsForm.ctViewTabsTabDblClick(Sender: TObject; ATab: TChromeTab);
var
  ti: TViewTabInfo;
begin
  ti := TViewTabInfo(ATab.Data);
  if not Assigned(ti) then
    Exit;
  mMainView.NewViewTab(ti.Location, ti.SatelliteName, '', ti.State, '', true);
end;

procedure TDockTabsForm.FormCreate(Sender: TObject);
begin
  mBookView := TBookFrame.Create(nil, mMainView, self);
  mBookView.Parent := pnlMain;
  mBookView.Align := alClient;
  mBookView.Show;
  mBookView.BringToFront;
end;

procedure TDockTabsForm.FormDeactivate(Sender: TObject);
var
  tabInfo: TViewTabInfo;
begin
    // save active tab state
    tabInfo := GetActiveTabInfo();
    if Assigned(tabInfo) then
      tabInfo.SaveBrowserState(mBookView.bwrHtml);
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
  curTab: TViewTabInfo;
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
          curTab := TViewTabInfo(ctViewTabs.Tabs[C].Data);
          ctViewTabs.Tabs.Delete(C);
          Dec(C);
          curTab.Free();
        end;

        C := 0;
        while C < saveTabIndex do
        begin
          curTab := TViewTabInfo(ctViewTabs.Tabs[0].Data);
          ctViewTabs.Tabs.Delete(0);
          Inc(C);
          curTab.Free();
        end;

      finally
        ctViewTabs.ActiveTabIndex := 0;
        UpdateViewTabs();
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
  tabInfo: TViewTabInfo;
  tabIndex: integer;
begin
  tabIndex := ctViewTabs.ActiveTabIndex;
  if (tabIndex >= 0) and (tabIndex < ctViewTabs.Tabs.Count) then
  begin
    tabInfo := TViewTabInfo(ctViewTabs.Tabs[tabIndex].Data);

    ctViewTabs.Tabs.Delete(tabIndex);

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
  activeTabInfo: TViewTabInfo;
begin
  activeTabInfo := GetActiveTabInfo();
  if (activeTabInfo <> nil) then
  begin
    mMainView.NewViewTab(activeTabInfo.Location, activeTabInfo.SatelliteName, '', activeTabInfo.State, '', true);
  end;
end;

procedure TDockTabsForm.UpdateViewTabs();
var
  tabInfo: TViewTabInfo;
begin
  try
    tabInfo := GetActiveTabInfo();
    if not Assigned(tabInfo) then
      Exit;

    try
      mBookView.bwrHtml.NoScollJump := true;
      mMainView.UpdateUI();

      if (tabInfo.IsCompareTranslation) then
      begin
        mBookView.bwrHtml.LoadFromString(tabInfo.CompareTranslationText);
      end
      else
      begin
        mMainView.ProcessCommand(tabInfo.Location, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
      end;

      tabInfo.RestoreBrowserState(mBookView.bwrHtml);
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

function TDockTabsForm.GetActiveTabInfo(): TViewTabInfo;
var
  tabIndex: integer;
begin
  Result := nil;
  tabIndex := ctViewTabs.ActiveTabIndex;
  try
    if (tabIndex >= 0) and (tabIndex < ctViewTabs.Tabs.Count) then
    begin
      Result := TViewTabInfo(ctViewTabs.ActiveTab.Data);
    end;
  except
    // just eat everything wrong
  end;
end;

function TDockTabsForm.AddBookTab(newTabInfo: TViewTabInfo; const title: string): TChromeTab;
var
  newTab: TChromeTab;
begin
  newTab := ViewTabs.Tabs.Add;
  newTab.Caption := title;
  newTab.Data := newTabInfo;

  Result := newTab;
end;

end.
