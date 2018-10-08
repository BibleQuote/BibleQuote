unit BroadcastList;

interface

uses
  System.SysUtils, System.Types, System.Math, System.UITypes,
  System.Generics.Collections, System.Classes, JclNotify;

type
  TBroadcastStringList = class(TStringList)
  private
    FOnChangeEventBroadcast: TJclNotifyEventBroadcast;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure Changed; override;

    procedure AddOnChange(ANotifyEvent: TNotifyEvent);
    procedure RemoveOnChange(ANotifyEvent: TNotifyEvent);
  end;

implementation

{ TMulticastStringList }

constructor TBroadcastStringList.Create;
begin
  inherited Create;
  FOnChangeEventBroadcast := TJclNotifyEventBroadcast.Create;
end;

procedure TBroadcastStringList.Changed;
begin
  inherited Changed;
  FOnChangeEventBroadcast.Notify(Self);
end;

destructor TBroadcastStringList.Destroy;
begin
  FreeAndNil(FOnChangeEventBroadcast);
  inherited;
end;

procedure TBroadcastStringList.RemoveOnChange(ANotifyEvent: TNotifyEvent);
begin
  if Assigned(FOnChangeEventBroadcast) then
    FOnChangeEventBroadcast.RemoveHandler(ANotifyEvent);
end;

procedure TBroadcastStringList.AddOnChange(ANotifyEvent: TNotifyEvent);
begin
  FOnChangeEventBroadcast.AddHandler(ANotifyEvent);
end;

end.
