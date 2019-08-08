unit PreviewUtils;

interface

uses PreviewFrm, Htmlview, Classes;

procedure ShowPrintPreview(AOwner: TComponent; AViewer: ThtmlViewer);

implementation

procedure ShowPrintPreview(AOwner: TComponent; AViewer: ThtmlViewer);
var
  pf: TPreviewForm;
  Abort: boolean;
begin
  pf := TPreviewForm.CreateIt(AOwner, AViewer, Abort);
  try
    if not Abort then
      pf.ShowModal;
  finally
    pf.Free;
  end;
end;

end.
