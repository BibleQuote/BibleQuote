unit bqServices;

interface
uses FasterTCP, SysUtils;
type TbqHelperServices=class(TObject)
mSockCli:TFasterTCPClient;
constructor Create();
destructor Destroy();virtual;
procedure Connect();
procedure Disconnect();
end;

implementation

{ TbqHelperServices }

procedure TbqHelperServices.Connect;
begin
mSockCli.Connected:=true;
//if not mSockCli.Connected then ra

end;

constructor TbqHelperServices.Create;
begin
  mSockCli:=TFasterTCPClient.Create(nil);
  mSockCli.Host:='127.0.0.1';
  mSockCli.Port:=54753;
  mSockCli.UserName:='GPL_BibleQuote_6';
  mSockCli.Room:='GeneralServices';
end;


destructor TbqHelperServices.Destroy;
begin
FreeAndNil(mSockCli);
end;

procedure TbqHelperServices.Disconnect;
begin
mSockCli.Connected:=false;
end;

end.
