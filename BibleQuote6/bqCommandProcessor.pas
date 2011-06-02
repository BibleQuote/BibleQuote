unit bqCommandProcessor;

interface
type TbqCommandType=(bqctInvalid, bqctGoCommand);
function GetCommandType(const cmd:WideString):TbqCommandType;  overload;
function GetCommandType( cmd:UTF8String):TbqCommandType;  overload;
implementation
uses WideStringsMod,JclWideStrings,sysutils;

function GetCommandType(cmd:UTF8String):TbqCommandType;
begin
cmd:=LowerCase(cmd);
if pos('go ', cmd)=1 then begin
  result:=bqctGoCommand;
  exit;
end;
result:=bqctInvalid;
end;


function GetCommandType(const cmd:WideString):TbqCommandType;
var ansicmd:UTF8String;
begin
result:=GetCommandType(UTF8String(cmd));

end;

end.
