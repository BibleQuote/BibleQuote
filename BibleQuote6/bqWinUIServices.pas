unit bqWinUIServices;

interface
uses TntControls,TntForms, HTMLEmbedInterfaces, Htmlsubs;
type
 IBibleWinUIServices=interface
  function GetMainWindow(): TTntForm;
  function GetIViewerBase():IHtmlViewerBase;

 end;

implementation

end.
