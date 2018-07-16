unit ModuleViewIntf;

interface

  uses System.UITypes, System.Classes, Winapi.Windows,
       Vcl.Controls, Vcl.Graphics, TabData, Bible, HtmlView,
       Vcl.Tabs, Vcl.DockTabSet, ChromeTabs, ChromeTabsTypes, ChromeTabsUtils,
       ChromeTabsControls, ChromeTabsClasses, ChromeTabsLog;

  type IModuleView = interface
  ['{DEADBEEF-31AB-4F3A-B16F-57B47258402A}']

    procedure BrowserHotSpotCovered(viewer: THTMLViewer; src: string);
    procedure CloseCurrentTab();
    procedure CopyBrowserSelectionToClipboard();
    function GetActiveTabInfo(): TViewTabInfo;
    procedure UpdateViewTabs();
    procedure ToggleStrongNumbers();

    // getters
    function GetBrowser: THTMLViewer;
    function GetViewTabs: TChromeTabs;
    function GetBibleTabs: TDockTabSet;
    function GetViewName: string;

    // setters
    procedure SetViewName(viewName: string);

    // properties
    property ViewTabs: TChromeTabs read GetViewTabs;
    property Browser: THTMLViewer read GetBrowser;
    property BibleTabs: TDockTabSet read GetBibleTabs;
    property ViewName: string read GetViewName write SetViewName;
  end;
implementation

end.
