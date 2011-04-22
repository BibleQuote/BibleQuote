unit bqICommandProcessor;

interface
type
 IBibleQuoteCommandProcessor=interface
  function GetAutoTxt(const cmd: WideString;maxWords:integer;
    out fnt: WideString; out passageSignature:WideString): WideString;
 end;
implementation

end.
