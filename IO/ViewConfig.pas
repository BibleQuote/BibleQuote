unit ViewConfig;

interface
uses
  XMLDoc, XMLIntf, Classes, SysUtils, Generics.Collections, Rest.Json, IOUtils;
type
  TModuleViewSettings = class
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

  TViewConfig = class
  private
    FModuleViews: TList<TModuleViewSettings>;
  public
    property ModuleViews: TList<TModuleViewSettings> read FModuleViews write FModuleViews;

    constructor Create();

    procedure Save(fileName: string);
    class function Load(fileName: string) : TViewConfig;
  end;

implementation

constructor TViewConfig.Create();
begin
  ModuleViews := TList<TModuleViewSettings>.Create();
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
