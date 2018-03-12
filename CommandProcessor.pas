unit CommandProcessor;

interface

type
  TbqCommandType = (bqctInvalid, bqctGoCommand);
function GetCommandType(const cmd: string): TbqCommandType;

implementation

uses sysutils;

function GetCommandType(const cmd: string): TbqCommandType;
var lowerCommand: string;
begin
  lowerCommand := LowerCase(cmd);
  if pos('go ', lowerCommand) = 1 then
  begin
    result := bqctGoCommand;
    exit;
  end;
  result := bqctInvalid;
end;

end.
