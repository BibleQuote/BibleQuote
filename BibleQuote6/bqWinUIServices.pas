unit bqWinUIServices;

interface
uses TntControls,TntForms, HTMLEmbedInterfaces, Htmlsubs;
type
 IBibleWinUIServices=interface
   ['{14ED0EC0-45FE-1FD6-F1F0-54CC12E47A77}']
  function GetMainWindow(): TTntForm;
  function GetIViewerBase():IHtmlViewerBase;
  function InstallFont(const specialPath:WideString):HRESULT;

 end;

implementation

end.
