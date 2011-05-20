unit bqICommandProcessor;

interface
type
 IBibleQuoteCommandProcessor=interface
  ['{14ED0EC0-45FE-1FD6-F1F0-42A45DE18B64}']
  function GetAutoTxt(const cmd: WideString;maxWords:integer;
    out fnt: WideString; out passageSignature:WideString): WideString;
 end;
implementation

end.
