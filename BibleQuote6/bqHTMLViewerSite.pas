unit bqHTMLViewerSite;

interface
uses HTMLEmbedInterfaces, controls, classes,Htmlsubs;
type
  IHTMLViewerSite =interface
 ['{14ED0EC0-45FE-1FD6-F1F0-41345DE47A64}']  
  procedure Init(sectionList:TSectionList);
  end;

  THTMLViewerSite=class(THtmlViewerBase,IViewerBase, IHTMLViewerBase,IHTMLViewerSite )
  protected
  mSectionList:TSectionList;
  mSite:TWinControl;
  public
    function getMarginHeight():integer;override;
    function getMarginWidth():integer;override;
    function GetLinkList(): TList;override;
    procedure htProgress(Percent: Integer);override;
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); override;
    function HtmlExpandFilename(const Filename: string): string; override;
    function ShowFocusRect(): Boolean;  override;
    function GetComponent():TComponent;override;
    function GetControl():TControl;override;
    procedure Init(sectionList:TSectionList);
    constructor Create(aOwner:TComponent;site:TWinControl);reintroduce;
  end;

implementation

{ THTMLViewerSite }

procedure THTMLViewerSite.ControlMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  // nothing

end;

constructor THTMLViewerSite.Create(aOwner: TComponent; site:TWinControl);
begin
inherited Create(aOwner);
mSite:=site;
end;

function THTMLViewerSite.GetComponent: TComponent;
begin
result:=mSite;
end;

function THTMLViewerSite.GetControl: TControl;
begin
result:=mSite;
end;

function THTMLViewerSite.GetLinkList: TList;
begin
Result := mSectionList.LinkList;
end;

function THTMLViewerSite.getMarginHeight: integer;
begin
result:=0;
end;

function THTMLViewerSite.getMarginWidth: integer;
begin
result:=0;
end;

function THTMLViewerSite.HtmlExpandFilename(const Filename: string): string;
begin
result:=filename;
end;

procedure THTMLViewerSite.htProgress(Percent: Integer);
begin
  //

end;

procedure THTMLViewerSite.Init(sectionList: TSectionList);
begin
  mSectionList:=sectionList;
end;

function THTMLViewerSite.ShowFocusRect: Boolean;
begin
   result:=false;
end;

end.
