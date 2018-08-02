unit LayoutConfig;

interface
uses
  XMLDoc, XMLIntf, Classes, SysUtils, Generics.Collections, Rest.Json, IOUtils;

type
  TTabSettings = class
  private
    FLocation: string;
    FSecondBible: string;
    FStrongNotesCode: UInt64;
    FTitle: string;
    FActive: boolean;
  public
    property Location: string read FLocation write FLocation;
    property SecondBible: string read FSecondBible write FSecondBible;
    property StrongNotesCode: UInt64 read FStrongNotesCode write FStrongNotesCode;
    property Title: string read FTitle write FTitle;
    property Active: boolean read FActive write FActive;
  end;

type
  TTabsViewSettings = class
  private
    FTabSettingsList: TList<TTabSettings>;
    FActive: boolean;
    FViewName: string;
    FDocked: boolean;
    FLeft, FTop: integer;
    FWidth, FHeight: integer;
  public
    property TabSettingsList: TList<TTabSettings> read FTabSettingsList write FTabSettingsList;
    property Active: boolean read FActive write FActive;
    property ViewName: string read FViewName write FViewName;
    property Docked: boolean read FDocked write FDocked;
    property Left: integer read FLeft write FLeft;
    property Top: integer read FTop write FTop;
    property Width: integer read FWidth write FWidth;
    property Height: integer read FHeight write FHeight;
    constructor Create();
  end;

type
  TLayoutConfig = class
  private
    FTabsViewList: TList<TTabsViewSettings>;
  public
    property TabsViewList: TList<TTabsViewSettings> read FTabsViewList write FTabsViewList;

    constructor Create();

    procedure Save(fileName: string);
    class function Load(fileName: string) : TLayoutConfig;
  end;

implementation

constructor TTabsViewSettings.Create();
begin
  TabSettingsList := TList<TTabSettings>.Create();
  Active := false;
end;

constructor TLayoutConfig.Create();
begin
  TabsViewList := TList<TTabsViewSettings>.Create();
end;

class function TLayoutConfig.Load(fileName: string): TLayoutConfig;
var
  json: string;
begin
  json := TFile.ReadAllText(fileName);
  Result := TJson.JsonToObject<TLayoutConfig>(json);
end;

procedure TLayoutConfig.Save(fileName: string);
var
  json: string;
begin
  json := TJson.ObjectToJsonString(self);
  TFile.WriteAllText(fileName, json);
end;

end.
