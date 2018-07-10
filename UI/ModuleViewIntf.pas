unit ModuleViewIntf;

interface

  uses System.UITypes, System.Classes, Winapi.Windows,
       Vcl.Controls, Vcl.Graphics, TabData, Bible, HtmlView,
       Vcl.Tabs, Vcl.DockTabSet, bqClosableTabControl;

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
    function GetViewTabs: TClosableTabControl;
    function GetBibleTabs: TDockTabSet;
    function GetViewIndex: integer;

    // setters
    procedure SetViewIndex(index: integer);

    // properties
    property ViewTabs: TClosableTabControl read GetViewTabs;
    property Browser: THTMLViewer read GetBrowser;
    property BibleTabs: TDockTabSet read GetBibleTabs;
    property ViewIndex: integer read GetViewIndex write SetViewIndex;
  end;
implementation

end.
