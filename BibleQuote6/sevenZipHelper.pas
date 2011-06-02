unit sevenZipHelper;
interface
uses SevenZipVCL;
function getSevenZ():TSevenZip;
var
      _S_SevenZipGetPasswordProc:T7zGetPassword;
implementation
uses SysUtils;
var _S_SevenZip: TSevenZip;

function getSevenZ():TSevenZip;
begin
if not Assigned(_S_SevenZip) then begin
  _S_SevenZip:=TSevenZip.Create(nil);
  _S_SevenZip.OnGetPassword:=_S_SevenZipGetPasswordProc;
end;
result:=_S_SevenZip;
end;

initialization

finalization
  FreeAndNil(_S_SevenZip);
end.
