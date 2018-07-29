unit ModuleViewIntf;

interface

  uses System.UITypes, System.Classes, Winapi.Windows,
       Vcl.Controls, Vcl.Graphics, TabData, Bible, HtmlView,
       Vcl.Tabs, Vcl.DockTabSet, ChromeTabs, ChromeTabsTypes, ChromeTabsUtils,
       ChromeTabsControls, ChromeTabsClasses, ChromeTabsLog;

  type IBookView = interface
  ['{8015DBB1-AC95-49F3-9E00-B49BEF9A60F6}']
  end;

  type IModuleView = interface
  ['{DEADBEEF-31AB-4F3A-B16F-57B47258402A}']

    procedure CloseActiveTab();
    function GetActiveTabInfo(): TViewTabInfo;
    procedure UpdateViewTabs();
    function AddBookTab(newTabInfo: TViewTabInfo; const title: string): TChromeTab;

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
    property BookView: IBookView read GetBookView;
    property Browser: THTMLViewer read GetBrowser;
    property BibleTabs: TDockTabSet read GetBibleTabs;
    property ViewName: string read GetViewName write SetViewName;
  end;
implementation

end.
