unit ViewConfig;

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
  TModuleViewSettings = class
  private
    FTabSettingsList: TList<TTabSettings>;
    FActive: boolean;
    FViewIndex: integer;
    FDocked: boolean;
    FLeft, FTop: integer;
    FWidth, FHeight: integer;
  public
    property TabSettingsList: TList<TTabSettings> read FTabSettingsList write FTabSettingsList;
    property Active: boolean read FActive write FActive;
    property ViewIndex: integer read FViewIndex write FViewIndex;
    property Docked: boolean read FDocked write FDocked;
    property Left: integer read FLeft write FLeft;
    property Top: integer read FTop write FTop;
    property Width: integer read FWidth write FWidth;
    property Height: integer read FHeight write FHeight;
    constructor Create();
  end;

type
  TViewConfig = class
  private
    FModuleViews: TList<TModuleViewSettings>;
    FLastViewIndex: integer;
  public
    property ModuleViews: TList<TModuleViewSettings> read FModuleViews write FModuleViews;
    property LastViewIndex: integer read FLastViewIndex write FLastViewIndex;

    constructor Create();

    procedure Save(fileName: string);
    class function Load(fileName: string) : TViewConfig;
  end;

implementation

constructor TModuleViewSettings.Create();
begin
  TabSettingsList := TList<TTabSettings>.Create();
  Active := false;
end;

constructor TViewConfig.Create();
begin
  ModuleViews := TList<TModuleViewSettings>.Create();
  LastViewIndex := 1;
end;

class function TViewConfig.Load(fileName: string): TViewConfig;
var
  json: string;
begin
  json := TFile.ReadAllText(fileName);
  Result := TJson.JsonToObject<TViewConfig>(json);
end;

procedure TViewConfig.Save(fileName: string);
var
  json: string;
begin
  json := TJson.ObjectToJsonString(self);
  TFile.WriteAllText(fileName, json);
end;

end.
