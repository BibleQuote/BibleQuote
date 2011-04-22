unit HTMLEmbedInterfaces;
{copyright Alexander Snigerev}
{Licensed under GPL v3 for BibleQuote Developers}
interface
uses Controls,Classes, messages;
  type
   TIncludeType = procedure(Sender: TObject; const Command: string; Params: TStrings; var IString: string) of object;
   TLinkType = procedure(Sender: TObject; const Rel, Rev, Href: string) of object;
   TScriptEvent = procedure(Sender: TObject; const Name, ContentType, Src, Script: string) of object;
   TSoundType = procedure(Sender: TObject; const SRC: string; Loop: Integer; Terminate: boolean) of object;

  IViewerBase = interface
  ['{14ED0EC0-45FE-1FD6-F1F0-41345DE47460}']
    procedure SetOnInclude(Handler: TIncludeType);
    function  GetOnInclude():TIncludeType;
    procedure SetOnLink(Handler: TLinkType);
    function  GetOnLink():TLinkType;
    procedure SetOnScript(Handler: TScriptEvent);
    function  GetOnScript():TScriptEvent;
    procedure SetOnSoundRequest(Handler: TSoundType);
    function  GetOnSoundRequest():TSoundType;
    function GetComponent():TComponent;
    function GetControl():TControl;
    property OnInclude: TIncludeType read GetOnInclude write SetOnInclude;
    property OnLink: TLinkType read GetOnLink write SetOnLink;
    property OnScript: TScriptEvent read GetOnScript write SetOnScript;
    property OnSoundRequest: TSoundType read GetOnSoundRequest write SetOnSoundRequest;
  end;

  TablePartType = (Normal, DoHead, DoBody1, DoBody2, DoBody3, DoFoot);
  TTablePartRec = class
    TablePart: TablePartType;
    PartStart: Integer;
    PartHeight: Integer;
    FootHeight: Integer;
  end;

  IHtmlViewerBase = interface(IViewerBase)
  ['{14ED0EC0-45FE-1FD6-F1F0-41345DE47461}']
    procedure htProgress(Percent: Integer);
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    function HtmlExpandFilename(const Filename: string): string;
    function ShowFocusRect: Boolean;
    function GetComponent():TComponent;
    function GetControl():TControl;
    function get_TablePartRec():TTablePartRec;
    procedure set_TablePartRec(value:TTablePartRec);
    function getMarginHeight():integer;
    function getMarginWidth():integer;
    function GetLinkList(): TList;
    property TablePartRec:TTablePartRec read get_TablePartRec write set_TablePartRec;
  end;

  TViewerBase = class(TWinControl,IViewerBase)
  private
    FOnInclude: TIncludeType;
    FOnLink: TLinkType;
    FOnScript: TScriptEvent;
    FOnSoundRequest: TSoundType;
  protected
    procedure SetOnInclude(Handler: TIncludeType); virtual;
    function  GetOnInclude():TIncludeType;
    procedure SetOnLink(Handler: TLinkType); virtual;
    function  GetOnLink():TLinkType;
    procedure SetOnScript(Handler: TScriptEvent); virtual;
    function  GetOnScript():TScriptEvent;
    procedure SetOnSoundRequest(Handler: TSoundType); virtual;
    function  GetOnSoundRequest():TSoundType;
  public
    function GetComponent():TComponent;virtual;
    function GetControl():TControl;virtual;
    property OnInclude: TIncludeType read FOnInclude write SetOnInclude;
    property OnLink: TLinkType read FOnLink write SetOnLink;
    property OnScript: TScriptEvent read FOnScript write SetOnScript;
    property OnSoundRequest: TSoundType read FOnSoundRequest write SetOnSoundRequest;
  end;


  
  THtmlViewerBase = class(TViewerBase,IHtmlViewerBase)
  public
    mTablePartRec: TTablePartRec;
    procedure htProgress(Percent: Integer); virtual; abstract;
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    function HtmlExpandFilename(const Filename: string): string; virtual; abstract;
    function ShowFocusRect: Boolean; virtual; abstract;

    function get_TablePartRec():TTablePartRec;
    function getMarginHeight():integer;virtual;abstract;
    function getMarginWidth():integer; virtual;abstract;
    function GetLinkList(): TList;virtual;abstract;
    procedure set_TablePartRec(value:TTablePartRec);
    property TablePartRec:TTablePartRec read get_TablePartRec write set_TablePartRec;
  end;


implementation
  { TViewerBase }

//-- BG ---------------------------------------------------------- 05.01.2010 --
function TViewerBase.GetOnInclude: TIncludeType;
begin
result:=FOnInclude;
end;

function TViewerBase.GetOnLink: TLinkType;
begin
result:=FOnLink;
end;

function TViewerBase.GetOnScript: TScriptEvent;
begin
Result:=FOnScript;
end;

function TViewerBase.GetOnSoundRequest: TSoundType;
begin
Result:=FOnSoundRequest;
end;

procedure TViewerBase.SetOnInclude(Handler: TIncludeType);
begin
  FOnInclude := Handler;
end;

//-- BG ---------------------------------------------------------- 05.01.2010 --
procedure TViewerBase.SetOnLink(Handler: TLinkType);
begin
  FOnLink := Handler;
end;

//-- BG ---------------------------------------------------------- 05.01.2010 --
procedure TViewerBase.SetOnScript(Handler: TScriptEvent);
begin
  FOnScript := Handler;
end;

//-- BG ---------------------------------------------------------- 05.01.2010 --
procedure TViewerBase.SetOnSoundRequest(Handler: TSoundType);
begin
  FOnSoundRequest := Handler;
end;

//THtmlViewerBase = class(TViewerBase)
//public
//  TablePartRec: TTablePartRec;
//  procedure htProgress(Percent: Integer); virtual; abstract;
//  procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual; abstract;
//  procedure KeyDown(var Key: Word; Shift: TShiftState); override;
//  function HtmlExpandFilename(const Filename: string): string; virtual; abstract;
//  function ShowFocusRect: Boolean; virtual; abstract;
//end;

{ THtmlViewerBase }

function TViewerBase.GetComponent: TComponent;
begin
result:=self;
end;

function TViewerBase.GetControl: TControl;
begin
result:=self;
end;

function THtmlViewerBase.get_TablePartRec: TTablePartRec;
begin
result:=mTablePartRec;
end;

procedure THtmlViewerBase.set_TablePartRec(value: TTablePartRec);
begin
mTablePartRec:=value;
end;



end.
