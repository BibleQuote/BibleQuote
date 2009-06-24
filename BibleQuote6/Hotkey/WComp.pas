unit WComp;

interface

{ Some methods have moved to the Classes unit in D6 and are thus deprecated.
  Using the following compiler directives we handle that situation. }

{$IFDEF VER140}
  {$DEFINE DELPHI_6}
{$ENDIF}
{$IFDEF VER180}
  {$DEFINE DELPHI_6_UP}
{$ENDIF}
{$IFDEF DELPHI_6}
  {$DEFINE DELPHI_6_UP}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms;

type
  TWindowedComponent = class(TComponent)
  private
    FHandle : THandle;
    function GetHandle: THandle;
    { Private declarations }
  protected
    procedure WndProc(var Msg : TMessage); virtual;
    { Protected declarations }
  public
    function HandleAllocated: Boolean;
    procedure HandleNeeded;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property Handle: THandle read GetHandle;
  end;


implementation

{ TWindowedComponent }

constructor TWindowedComponent.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FHandle := 0;
end;

destructor TWindowedComponent.Destroy;
begin
  if HandleAllocated then
{$IFDEF DELPHI_6_UP}
    Classes.DeallocateHWnd(FHandle);
{$ELSE}
    DeallocateHWnd(FHandle);
{$ENDIF}
  inherited Destroy;
end;

function TWindowedComponent.HandleAllocated: Boolean;
begin
  Result := FHandle<>0;
end;

procedure TWindowedComponent.HandleNeeded;
begin
  if not HandleAllocated then
{$IFDEF DELPHI_6_UP}
    FHandle := Classes.AllocateHWnd(WndProc);
{$ELSE}
    FHandle := AllocateHWnd(WndProc);
{$ENDIF}
end;

function TWindowedComponent.GetHandle: THandle;
begin
  HandleNeeded;
  Result := FHandle;
end;

procedure TWindowedComponent.WndProc(var Msg : TMessage);
begin
  Dispatch(Msg);
end;

end.
