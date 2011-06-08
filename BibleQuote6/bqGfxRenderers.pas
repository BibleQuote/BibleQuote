unit bqGfxRenderers;

interface
uses VersesDB,Graphics,Windows, bqICommandProcessor,bqWinUIServices, Htmlsubs;
type TbqTagVersesContent=(tvcTag, tvcPlainTxt, tvcLink);
TbqTagsRenderer=class(TObject)
private
class var miCommandProcessor:IBibleQuoteCommandProcessor;
class var miUIServices:IBibleWinUIServices;
class var mCurrentRenderer:TSectionList;
class var mVmargin,mHmargin:integer;
class var mSaveBrush:TBrush;
class var mTagFont,mDefaultVerseFont:TFont;
class function EffectiveGetVerseNodeText(var nd:TVersesNodeData;var usedFnt:WideString):UTF8String;static;
class function RenderTagNode(canvas:TCanvas;var nodeData:TVersesNodeData;calcOnly:boolean; var rect:TRect):Integer; static;
class function RenderVerseNode(canvas:TCanvas;var nodeData:TVersesNodeData;calcOnly:boolean; var rect:TRect):Integer; static;
class function GetHTMLRenderer(id:int64; out match:boolean):TSectionList;static;
class procedure ResetRendererStyles(renderer:TSectionList; prefFnt:Widestring);
class function BuildVerseHTML(const verseTxt:WideString;const verseCommand:WideString;
                                   const verseSignature:WideString): UTF8String;static;
class procedure SetVMargin( value:integer); static;
class procedure SetHMargin( value:integer); static;
public
 class procedure Init(iCommandProcessor:IBibleQuoteCommandProcessor; iUIServices:IBibleWinUIServices; tagFont, verseFont:TFont);
 class function RenderNode(canvas:TCanvas;var nodeData:TVersesNodeData;calcOnly:boolean; var rect:TRect):Integer; static;
 class function CurrentRenderer():TSectionList;static;
 class procedure InvalidateRenderers();static;
 class function GetContentTypeAt(x,y:integer;canvas:TCanvas; var nodeData:TVersesNodeData; rect:TRect):TbqTagVersesContent; static;
 class property VMargin:integer read mVmargin write SetVMargin;
 class property HMargin:integer read mHmargin write SetHMargin;
 class property  TagFont:TFont read mTagFont write mTagFont;
 class property  DefaultVerseFont:TFont read mDefaultVerseFont write mDefaultVerseFont;
end;
implementation
 uses bqPlainUtils,Readhtml,SysUtils,bqCommandProcessor,HTMLUn2,HTMLEmbedInterfaces,bqHTMLViewerSite;
 type TRendererPair=record
  id:int64;
  renderer:TSectionList;
 end;

{ TbqTagsRenderer }
var _rendererPair:TRendererPair;
class function TbqTagsRenderer.BuildVerseHTML(const verseTxt:WideString;
const verseCommand:WideString; const verseSignature:WideString): UTF8String;
var txt:WideString;
begin
txt:=WideFormat('<HTML><BODY><a href="%s">%s</a> %s</BODY></HTML>',
  [verseCommand, verseSignature, verseTxt]);
result:=WideStringToUtfBOMString(txt);
end;

class function TbqTagsRenderer.CurrentRenderer: TSectionList;
begin
result:=mCurrentRenderer
end;

class function TbqTagsRenderer.EffectiveGetVerseNodeText(
  var nd: TVersesNodeData;var usedFnt:WideString): UTF8String;
  var cmd, verseSig,  verseText:WideString;
       commandType:TbqCommandType;
       hr:HRESULT;

begin
 cmd:=nd.getText();

 commandType:=GetCommandType(cmd);
 if commandType=bqctInvalid then begin
   hr:=nd.unpackCached(cmd, verseSig, usedFnt,versetext);
 end
 else hr:=0;
 if (commandType<>bqctInvalid) or (hr<>0) then begin
  if hr<>0 then begin

     nd.cachedTxt:=''; //clear txt so that initialize to cmd
     cmd:=nd.getText();//rebuild cmd from db values
   end;
 verseText:=miCommandProcessor.GetAutoTxt(cmd, 20,usedFnt,verseSig);
 nd.packCached(verseSig,verseText, usedFnt);
 end;
 result:=BuildVerseHTML(verseText,cmd,verseSig);
end;

class function TbqTagsRenderer.GetContentTypeAt(x, y: integer; canvas:TCanvas;
  var nodeData: TVersesNodeData; rect:TRect): TbqTagVersesContent;
  var renderer:TSectionList;
      match:boolean;
      txt:UTF8String;
      usedFnt:WideString;
      sw,cur:integer;
      UrlTarget : TUrlTarget;
      formControl:TIDObject;
      title:string;

      gur:guResultType;
begin

if nodeData.nodeType=bqvntTag then begin result:=tvcTag; exit; end;
renderer:=GetHTMLRenderer(nodeData.SelfId,match);
try
 mCurrentRenderer:=renderer;
if not match then begin
txt:=EffectiveGetVerseNodeText(nodeData,usedFnt);
ResetRendererStyles(renderer, usedFnt);
ParseHTMLString(txt,renderer , nil, nil, nil, nil );
renderer.DoLogic(canvas, rect.Top+vMargin, rect.Right-rect.Left-hMargin-hMargin, 500,0,sw,cur);
end;
UrlTarget:=nil; formControl:=nil;
gur:=renderer.GetURL(canvas, x-hmargin, y+renderer.YOff,
          UrlTarget, FormControl, title);
if guUrl in gur then result:=tvcLink
else result:=tvcPlainTxt;
finally  mCurrentRenderer:=nil; end;
end;

class function TbqTagsRenderer.GetHTMLRenderer(id:int64; out match:boolean): TSectionList;
var// iviewer:IViewerBase;
    ihtmlViewer:IHtmlViewerBase;
    isite:IHTMLViewerSite;
    r:HRESULT;
begin
if not assigned(_rendererPair.renderer) then begin
ihtmlViewer:=miUIServices.GetIViewerBase();
 _rendererPair.renderer:=TSectionList.Create( ihtmlViewer,  miUIServices.GetMainWindow());
r:=ihtmlViewer.QueryInterface(IHTMLViewerSite,isite);
if r<>S_OK then raise Exception.Create('Wrong ihtmlviewersite passed');
isite.Init(_rendererPair.renderer);
  match:=false;
end
else begin
  if _rendererPair.id<>id then begin _rendererPair.renderer.Clear(); match:=false; end
  else match:=true;
end;
result:=_rendererPair.renderer;
_rendererPair.id:=id;
end;

class procedure TbqTagsRenderer.Init(
  iCommandProcessor: IBibleQuoteCommandProcessor; iUIServices:IBibleWinUIServices; tagFont, verseFont:TFont);
begin
miCommandProcessor:=iCommandProcessor;
miUIServices:=iUIServices;
mSaveBrush:=TBrush.Create();
mTagFont:=tagFont; mDefaultVerseFont:=verseFont;
end;

class procedure TbqTagsRenderer.InvalidateRenderers;
begin
_rendererPair.id:=-1;
if assigned(_rendererPair.renderer) then _rendererPair.renderer.Clear();
end;

class function TbqTagsRenderer.RenderNode(canvas: TCanvas;
  var nodeData: TVersesNodeData; calcOnly: boolean; var rect: TRect): Integer;
begin
case nodeData.nodeType of
bqvntTag:result:=RenderTagNode(canvas,nodeData,calcOnly, rect);
bqvntVerse:result:=RenderVerseNode(canvas,nodeData,calcOnly, rect);
end;//case
end;

class function TbqTagsRenderer.RenderTagNode(canvas: TCanvas;
  var nodeData: TVersesNodeData; calcOnly: boolean; var rect: TRect): Integer;
begin

end;

class function TbqTagsRenderer.RenderVerseNode(canvas: TCanvas;
  var nodeData: TVersesNodeData; calcOnly: boolean; var rect: TRect): Integer;
var  cmd, usedFont:WideString;
txt:UTF8String;
    scrollWidth, scrollHeight, curs:integer;
    renderer:TSectionList;
    match:boolean;
begin
 txt:=EffectiveGetVerseNodeText(nodeData,usedFont);
 renderer:=GetHTMLRenderer(nodeData.SelfId,match);
 try
 mCurrentRenderer:=renderer;
//  if nodeData.SelfId=4 then begin
//  TraceFmt('match %d, calcOnly:%d rect.l:%d rect.r:%d;scrollWidth:%d',[ord(match),ord(calcOnly),
//    rect.Left, rect.Right,scrollWidth ]);
//  end;

 if calcOnly or (not match) then begin
  if not match then  begin
   ResetRendererStyles(renderer, usedFont);

    ParseHTMLString(txt,renderer , nil, nil, nil, nil );
  end;
  scrollHeight:= renderer.DoLogic(canvas,vMargin,rect.Right-rect.Left-hMargin-hMargin, rect.Bottom,0,scrollWidth,curs);
  result:=scrollHeight+vMargin+vMargin;
  end;                                         
  if not calcOnly then begin

//dec(rect.bottom,10);
//  renderer.SetYOffset(40);
  mSaveBrush.Assign( canvas.Brush);
//  savePen:=TPen.Create();
//  savePen.Assign( canvas.Pen);
   canvas.Brush.Color:=clWhite;
   renderer.Draw(Canvas, rect, rect.Right-rect.Left,rect.Left+HMargin,0,0,0);
   canvas.Brush.Assign(mSaveBrush);
//   canvas.Pen.Assign(savepen);

  end;


 finally
 mCurrentRenderer:=nil;
 end;
end;

class procedure TbqTagsRenderer.ResetRendererStyles(renderer:TSectionList; prefFnt:Widestring);

begin
renderer.Clear();
if length(prefFnt)<=0 then begin
prefFnt:=mDefaultVerseFont.Name;
end;
renderer.SetFonts(prefFnt, prefFnt, mDefaultVerseFont.Size, $0,  $5122A3,  $0,
    $0,$00,true, false, 0, 10,10);

end;

class procedure TbqTagsRenderer.SetHMargin(value: integer);
begin
mHmargin:=value;
InvalidateRenderers();
end;

class procedure TbqTagsRenderer.SetVMargin(value: integer);
begin
mVmargin:=value;
InvalidateRenderers();
end;

end.
