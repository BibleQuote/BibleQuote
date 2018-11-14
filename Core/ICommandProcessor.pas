unit ICommandProcessor;

interface
uses TabData;

type
  IBibleQuoteCommandProcessor = interface
    ['{14ED0EC0-45FE-1FD6-F1F0-42A45DE18B64}']
    function GetAutoTxt(
      btinfo: TBookTabInfo;
      const cmd: string;
      maxWords: integer;
      out fnt: string;
      out passageSignature: string): string;
  end;

implementation

end.
