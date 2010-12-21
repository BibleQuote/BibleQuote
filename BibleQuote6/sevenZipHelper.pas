unit sevenZipHelper;
interface
uses SevenZipVCL;
function getSevenZ():TSevenZip;inline;
var   _S_SevenZip: TSevenZip;
implementation

function getSevenZ():TSevenZip;inline;
begin
if not Assigned(_S_SevenZip) then _S_SevenZip:=TSevenZip.Create(nil);
result:=_S_SevenZip;
end;

initialization

finalization

end.
