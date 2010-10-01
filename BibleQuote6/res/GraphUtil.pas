
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1995-2005 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit GraphUtil;

interface

{$IFDEF MSWINDOWS}
uses Windows, Graphics, Classes;
{$ENDIF}
{$IFDEF LINUX}
uses Types, QGraphics, Classes;
{$ENDIF}

type
  TColorArray = array of TIdentMapEntry;

const
  WebNamedColorsCount = 138;
  WebNamedColors: array[0..WebNamedColorsCount - 1] of TIdentMapEntry = (
    // light colors snow -> tan
    (Value: clWebSnow; Name: 'clWebSnow'),                                { do not localize }
    (Value: clWebFloralWhite; Name: 'clWebFloralWhite'),                  { do not localize }
    (Value: clWebLavenderBlush; Name: 'clWebLavenderBlush'),              { do not localize }
    (Value: clWebOldLace; Name: 'clWebOldLace'),                          { do not localize }
    (Value: clWebIvory; Name: 'clWebIvory'),                              { do not localize }
    (Value: clWebCornSilk; Name: 'clWebCornSilk'),                        { do not localize }
    (Value: clWebBeige; Name: 'clWebBeige'),                              { do not localize }
    (Value: clWebAntiqueWhite; Name: 'clWebAntiqueWhite'),                { do not localize }
    (Value: clWebWheat; Name: 'clWebWheat'),                              { do not localize }
    (Value: clWebAliceBlue; Name: 'clWebAliceBlue'),                      { do not localize }
    (Value: clWebGhostWhite; Name: 'clWebGhostWhite'),                    { do not localize }
    (Value: clWebLavender; Name: 'clWebLavender'),                        { do not localize }
    (Value: clWebSeashell; Name: 'clWebSeashell'),                        { do not localize }
    (Value: clWebLightYellow; Name: 'clWebLightYellow'),                  { do not localize }
    (Value: clWebPapayaWhip; Name: 'clWebPapayaWhip'),                    { do not localize }
    (Value: clWebNavajoWhite; Name: 'clWebNavajoWhite'),                  { do not localize }
    (Value: clWebMoccasin; Name: 'clWebMoccasin'),                        { do not localize }
    (Value: clWebBurlywood; Name: 'clWebBurlywood'),                      { do not localize }
    (Value: clWebAzure; Name: 'clWebAzure'),                              { do not localize }
    (Value: clWebMintcream; Name: 'clWebMintcream'),                      { do not localize }
    (Value: clWebHoneydew; Name: 'clWebHoneydew'),                        { do not localize }
    (Value: clWebLinen; Name: 'clWebLinen'),                              { do not localize }
    (Value: clWebLemonChiffon; Name: 'clWebLemonChiffon'),                { do not localize }
    (Value: clWebBlanchedAlmond; Name: 'clWebBlanchedAlmond'),            { do not localize }
    (Value: clWebBisque; Name: 'clWebBisque'),                            { do not localize }
    (Value: clWebPeachPuff; Name: 'clWebPeachPuff'),                      { do not localize }
    (Value: clWebTan; Name: 'clWebTan'),                                  { do not localize }
  // yellows/reds yellow -> rosybrown
    (Value: clWebYellow; Name: 'clWebYellow'),                            { do not localize }
    (Value: clWebDarkOrange; Name: 'clWebDarkOrange'),                    { do not localize }
    (Value: clWebRed; Name: 'clWebRed'),                                  { do not localize }
    (Value: clWebDarkRed; Name: 'clWebDarkRed'),                          { do not localize }
    (Value: clWebMaroon; Name: 'clWebMaroon'),                            { do not localize }
    (Value: clWebIndianRed; Name: 'clWebIndianRed'),                      { do not localize }
    (Value: clWebSalmon; Name: 'clWebSalmon'),                            { do not localize }
    (Value: clWebCoral; Name: 'clWebCoral'),                              { do not localize }
    (Value: clWebGold; Name: 'clWebGold'),                                { do not localize }
    (Value: clWebTomato; Name: 'clWebTomato'),                            { do not localize }
    (Value: clWebCrimson; Name: 'clWebCrimson'),                          { do not localize }
    (Value: clWebBrown; Name: 'clWebBrown'),                              { do not localize }
    (Value: clWebChocolate; Name: 'clWebChocolate'),                      { do not localize }
    (Value: clWebSandyBrown; Name: 'clWebSandyBrown'),                    { do not localize }
    (Value: clWebLightSalmon; Name: 'clWebLightSalmon'),                  { do not localize }
    (Value: clWebLightCoral; Name: 'clWebLightCoral'),                    { do not localize }
    (Value: clWebOrange; Name: 'clWebOrange'),                            { do not localize }
    (Value: clWebOrangeRed; Name: 'clWebOrangeRed'),                      { do not localize }
    (Value: clWebFirebrick; Name: 'clWebFirebrick'),                      { do not localize }
    (Value: clWebSaddleBrown; Name: 'clWebSaddleBrown'),                  { do not localize }
    (Value: clWebSienna; Name: 'clWebSienna'),                            { do not localize }
    (Value: clWebPeru; Name: 'clWebPeru'),                                { do not localize }
    (Value: clWebDarkSalmon; Name: 'clWebDarkSalmon'),                    { do not localize }
    (Value: clWebRosyBrown; Name: 'clWebRosyBrown'),                      { do not localize }
  // greens palegoldenrod -> darkseagreen
    (Value: clWebPaleGoldenrod; Name: 'clWebPaleGoldenrod'),              { do not localize }
    (Value: clWebLightGoldenrodYellow; Name: 'clWebLightGoldenrodYellow'),{ do not localize }
    (Value: clWebOlive; Name: 'clWebOlive'),                              { do not localize }
    (Value: clWebForestGreen; Name: 'clWebForestGreen'),                  { do not localize }
    (Value: clWebGreenYellow; Name: 'clWebGreenYellow'),                  { do not localize }
    (Value: clWebChartreuse; Name: 'clWebChartreuse'),                    { do not localize }
    (Value: clWebLightGreen; Name: 'clWebLightGreen'),                    { do not localize }
    (Value: clWebAquamarine; Name: 'clWebAquamarine'),                    { do not localize }
    (Value: clWebSeaGreen; Name: 'clWebSeaGreen'),                        { do not localize }
    (Value: clWebGoldenRod; Name: 'clWebGoldenRod'),                      { do not localize }
    (Value: clWebKhaki; Name: 'clWebKhaki'),                              { do not localize }
    (Value: clWebOliveDrab; Name: 'clWebOliveDrab'),                      { do not localize }
    (Value: clWebGreen; Name: 'clWebGreen'),                              { do not localize }
    (Value: clWebYellowGreen; Name: 'clWebYellowGreen'),                  { do not localize }
    (Value: clWebLawnGreen; Name: 'clWebLawnGreen'),                      { do not localize }
    (Value: clWebPaleGreen; Name: 'clWebPaleGreen'),                      { do not localize }
    (Value: clWebMediumAquamarine; Name: 'clWebMediumAquamarine'),        { do not localize }
    (Value: clWebMediumSeaGreen; Name: 'clWebMediumSeaGreen'),            { do not localize }
    (Value: clWebDarkGoldenRod; Name: 'clWebDarkGoldenRod'),              { do not localize }
    (Value: clWebDarkKhaki; Name: 'clWebDarkKhaki'),                      { do not localize }
    (Value: clWebDarkOliveGreen; Name: 'clWebDarkOliveGreen'),            { do not localize }
    (Value: clWebDarkgreen; Name: 'clWebDarkgreen'),                      { do not localize }
    (Value: clWebLimeGreen; Name: 'clWebLimeGreen'),                      { do not localize }
    (Value: clWebLime; Name: 'clWebLime'),                                { do not localize }
    (Value: clWebSpringGreen; Name: 'clWebSpringGreen'),                  { do not localize }
    (Value: clWebMediumSpringGreen; Name: 'clWebMediumSpringGreen'),      { do not localize }
    (Value: clWebDarkSeaGreen; Name: 'clWebDarkSeaGreen'),                { do not localize }
  // greens/blues lightseagreen -> navy
    (Value: clWebLightSeaGreen; Name: 'clWebLightSeaGreen'),              { do not localize }
    (Value: clWebPaleTurquoise; Name: 'clWebPaleTurquoise'),              { do not localize }
    (Value: clWebLightCyan; Name: 'clWebLightCyan'),                      { do not localize }
    (Value: clWebLightBlue; Name: 'clWebLightBlue'),                      { do not localize }
    (Value: clWebLightSkyBlue; Name: 'clWebLightSkyBlue'),                { do not localize }
    (Value: clWebCornFlowerBlue; Name: 'clWebCornFlowerBlue'),            { do not localize }
    (Value: clWebDarkBlue; Name: 'clWebDarkBlue'),                        { do not localize }
    (Value: clWebIndigo; Name: 'clWebIndigo'),                            { do not localize }
    (Value: clWebMediumTurquoise; Name: 'clWebMediumTurquoise'),          { do not localize }
    (Value: clWebTurquoise; Name: 'clWebTurquoise'),                      { do not localize }
    (Value: clWebCyan; Name: 'clWebCyan'),                                { do not localize }
//    (Value: clWebAqua; Name: 'clWebAqua'),                                { do not localize }
    (Value: clWebPowderBlue; Name: 'clWebPowderBlue'),                    { do not localize }
    (Value: clWebSkyBlue; Name: 'clWebSkyBlue'),                          { do not localize }
    (Value: clWebRoyalBlue; Name: 'clWebRoyalBlue'),                      { do not localize }
    (Value: clWebMediumBlue; Name: 'clWebMediumBlue'),                    { do not localize }
    (Value: clWebMidnightBlue; Name: 'clWebMidnightBlue'),                { do not localize }
    (Value: clWebDarkTurquoise; Name: 'clWebDarkTurquoise'),              { do not localize }
    (Value: clWebCadetBlue; Name: 'clWebCadetBlue'),                      { do not localize }
    (Value: clWebDarkCyan; Name: 'clWebDarkCyan'),                        { do not localize }
    (Value: clWebTeal; Name: 'clWebTeal'),                                { do not localize }
    (Value: clWebDeepSkyBlue; Name: 'clWebDeepskyBlue'),                  { do not localize }
    (Value: clWebDodgerBlue; Name: 'clWebDodgerBlue'),                    { do not localize }
    (Value: clWebBlue; Name: 'clWebBlue'),                                { do not localize }
    (Value: clWebNavy; Name: 'clWebNavy'),                                { do not localize }
  // violets/pinks darkviolet -> pink
    (Value: clWebDarkViolet; Name: 'clWebDarkViolet'),                    { do not localize }
    (Value: clWebDarkOrchid; Name: 'clWebDarkOrchid'),                    { do not localize }
    (Value: clWebMagenta; Name: 'clWebMagenta'),                          { do not localize }
//    (Value: clWebFuchsia; Name: 'clWebFuchsia'),                          { do not localize }
    (Value: clWebDarkMagenta; Name: 'clWebDarkMagenta'),                  { do not localize }
    (Value: clWebMediumVioletRed; Name: 'clWebMediumVioletRed'),          { do not localize }
    (Value: clWebPaleVioletRed; Name: 'clWebPaleVioletRed'),              { do not localize }
    (Value: clWebBlueViolet; Name: 'clWebBlueViolet'),                    { do not localize }
    (Value: clWebMediumOrchid; Name: 'clWebMediumOrchid'),                { do not localize }
    (Value: clWebMediumPurple; Name: 'clWebMediumPurple'),                { do not localize }
    (Value: clWebPurple; Name: 'clWebPurple'),                            { do not localize }
    (Value: clWebDeepPink; Name: 'clWebDeepPink'),                        { do not localize }
    (Value: clWebLightPink; Name: 'clWebLightPink'),                      { do not localize }
    (Value: clWebViolet; Name: 'clWebViolet'),                            { do not localize }
    (Value: clWebOrchid; Name: 'clWebOrchid'),                            { do not localize }
    (Value: clWebPlum; Name: 'clWebPlum'),                                { do not localize }
    (Value: clWebThistle; Name: 'clWebThistle'),                          { do not localize }
    (Value: clWebHotPink; Name: 'clWebHotPink'),                          { do not localize }
    (Value: clWebPink; Name: 'clWebPink'),                                { do not localize }
  // blue/gray/black lightsteelblue -> black
    (Value: clWebLightSteelBlue; Name: 'clWebLightSteelBlue'),            { do not localize }
    (Value: clWebMediumSlateBlue; Name: 'clWebMediumSlateBlue'),          { do not localize }
    (Value: clWebLightSlateGray; Name: 'clWebLightSlateGray'),            { do not localize }
    (Value: clWebWhite; Name: 'clWebWhite'),                              { do not localize }
    (Value: clWebLightgrey; Name: 'clWebLightgrey'),                      { do not localize }
    (Value: clWebGray; Name: 'clWebGray'),                                { do not localize }
    (Value: clWebSteelBlue; Name: 'clWebSteelBlue'),                      { do not localize }
    (Value: clWebSlateBlue; Name: 'clWebSlateBlue'),                      { do not localize }
    (Value: clWebSlateGray; Name: 'clWebSlateGray'),                      { do not localize }
    (Value: clWebWhiteSmoke; Name: 'clWebWhiteSmoke'),                    { do not localize }
    (Value: clWebSilver; Name: 'clWebSilver'),                            { do not localize }
    (Value: clWebDimGray; Name: 'clWebDimGray'),                          { do not localize }
    (Value: clWebMistyRose; Name: 'clWebMistyRose'),                      { do not localize }
    (Value: clWebDarkSlateBlue; Name: 'clWebDarkSlateBlue'),              { do not localize }
    (Value: clWebDarkSlategray; Name: 'clWebDarkSlategray'),              { do not localize }
    (Value: clWebGainsboro; Name: 'clWebGainsboro'),                      { do not localize }
    (Value: clWebDarkGray; Name: 'clWebDarkGray'),                        { do not localize }
    (Value: clWebBlack; Name: 'clWebBlack'));                             { do not localize }

type
  TScrollDirection = (sdLeft, sdRight, sdUp, sdDown);
  TArrowType = (atSolid, atArrows);

{ GetHighLightColor and GetShadowColor take a Color and calculate an
  "appropriate" highlight/shadow color for that value.  If the color's
  saturation is beyond 220 then it's lumination is decreased rather than
  increased.  Since these routines may be called repeatedly for (potentially)
  the same color value they cache the results of the previous call. }

function GetHighLightColor(const Color: TColor; Luminance: Integer = 19): TColor;
function GetShadowColor(const Color: TColor; Luminance: Integer = -50): TColor;

{ Draws checkmarks of any Size at Location with/out a shadow. }

procedure DrawCheck(ACanvas: TCanvas; Location: TPoint; Size: Integer;
  Shadow: Boolean = True);

{ Draws arrows that look like ">" which can point in any TScrollDirection }

procedure DrawChevron(ACanvas: TCanvas; Direction: TScrollDirection;
  Location: TPoint; Size: Integer);

{ Draws a solid triangular arrow that can point in any TScrollDirection }

procedure DrawArrow(ACanvas: TCanvas; Direction: TScrollDirection;
  Location: TPoint; Size: Integer);

{ The following routines mimic the like named routines from Shlwapi.dll except
  these routines do not rely on any specific version of IE being installed. }

{ Calculates Hue, Luminance and Saturation for the clrRGB value }

procedure ColorRGBToHLS(clrRGB: TColorRef; var Hue, Luminance, Saturation: Word);

{ Calculates a color given Hue, Luminance and Saturation values }

function ColorHLSToRGB(Hue, Luminance, Saturation: Word): TColorRef;

{ Given a color and a luminance change "n" this routine returns a color whose
  luminace has been changed accordingly. }

function ColorAdjustLuma(clrRGB: TColor; n: Integer; fScale: BOOL): TColor;

{ GradientFill in AGradientDirection using the given colors in the given rect.
  GradientFill requires Windows 98, NT4 or better. }
type
  TGradientDirection = (gdHorizontal, gdVertical);

procedure GradientFillCanvas(const ACanvas: TCanvas;
  const AStartColor, AEndColor: TColor; const ARect: TRect;
  const Direction: TGradientDirection);

{ ScaleImage scales SourceBitmap into ResizedBitmap by
  ScaleAmount. A ScalAmount of 1 does nothing, < 0 shrinks, and
  > 0 enlarges }
procedure ScaleImage(const SourceBitmap, ResizedBitmap: TBitmap;
  const ScaleAmount: Double);

{ Converts a TColor to a Web color constant like #FFFFFF }
function ColorToWebColorStr(Color: TColor): string;

{ Converts a TColor to a Web color name, returns a Web color value if the color is not a match. }
function ColorToWebColorName(Color: TColor): string;
function WebColorToRGB(WebColor: Integer): Integer;
function RGBToWebColorStr(RGB: Integer): string;
function RGBToWebColorName(RGB: Integer): string;

{ Converts a Web color name to its TColor equivalent, returns clNone if no match }
function WebColorNameToColor(WebColorName: string): TColor;

{ Converts a web style color string (#FFFFFF or FFFFFF) to a TColor }
function WebColorStrToColor(WebColor: string): TColor;

type
  TColorArraySortType = (stHue, stSaturation, stLuminance, stRed, stGreen, stBlue, stCombo);

{ Performs a quicksort on ColorArray according to the SortType } 
procedure SortColorArray(ColorArray: TColorArray; L, R: Integer;
  SortType: TColorArraySortType; Reverse: Boolean = False);

implementation

uses SysUtils, Math, Consts;

const
  ArrowPts: array[TScrollDirection, 0..2] of TPoint =
    (((X:1; Y:0), (X:0; Y:1), (X:1; Y:2)),
     ((X:0; Y:0), (X:1; Y:1), (X:0; Y:2)),
     ((X:0; Y:1), (X:1; Y:0), (X:2; Y:1)),
     ((X:0; Y:0), (X:1; Y:1), (X:2; Y:0)));

threadvar
  CachedRGBToHLSclrRGB: TColorRef;
  CachedRGBToHLSHue: WORD;
  CachedRGBToHLSLum: WORD;
  CachedRGBToHLSSat: WORD;

{-----------------------------------------------------------------------
References:

1) J. Foley and a.van Dam, "Fundamentals of Interactive Computer Graphics",
   Addison-Wesley (IBM Systems Programming Series), Reading, MA, 664 pp., 1982.
2) MSDN online HOWTO: Converting Colors Between RGB and HLS (HBS)
   http://support.microsoft.com/support/kb/articles/Q29/2/40.ASP

  SUMMARY
  The code fragment below converts colors between RGB (Red, Green, Blue) and
  HLS/HBS (Hue, Lightness, Saturation/Hue, Brightness, Saturation).


  http://lists.w3.org/Archives/Public/www-style/1997Dec/0182.html
  http://www.math.clemson.edu/~rsimms/neat/math/hlsrgb.pas

-----------------------------------------------------------------------}

const
  HLSMAX = 240;            // H,L, and S vary over 0-HLSMAX
  RGBMAX = 255;            // R,G, and B vary over 0-RGBMAX
                           // HLSMAX BEST IF DIVISIBLE BY 6
                           // RGBMAX, HLSMAX must each fit in a byte.

  { Hue is undefined if Saturation is 0 (grey-scale)
    This value determines where the Hue scrollbar is
    initially set for achromatic colors }
  HLSUndefined = (HLSMAX*2/3);

procedure ColorRGBToHLS(clrRGB: TColorRef; var Hue, Luminance, Saturation: Word);
var
  H, L, S: Double;
  R, G, B: Word;
  cMax, cMin: Double;
  Rdelta, Gdelta, Bdelta: Extended; { intermediate value: % of spread from max }
begin
  if clrRGB = CachedRGBToHLSclrRGB then
  begin
    Hue := CachedRGBToHLSHue;
    Luminance := CachedRGBToHLSLum;
    Saturation := CachedRGBToHLSSat;
    exit;
  end;
  R := GetRValue(clrRGB);
  G := GetGValue(clrRGB);
  B := GetBValue(clrRGB);

  { calculate lightness }
  cMax := Math.Max(Math.Max(R, G), B);
  cMin := Math.Min(Math.Min(R, G), B);
  L := ( ((cMax + cMin) * HLSMAX) + RGBMAX ) / ( 2 * RGBMAX);
  if cMax = cMin then  { r=g=b --> achromatic case }
  begin                { saturation }
    Hue := Round(HLSUndefined);
//    pwHue := 160;      { MS's ColorRGBToHLS always defaults to 160 in this case }
    Luminance := Round(L);
    Saturation := 0;
  end
  else                 { chromatic case }
  begin
    { saturation }
    if L <= HLSMAX/2 then
      S := ( ((cMax-cMin)*HLSMAX) + ((cMax+cMin)/2) ) / (cMax+cMin)
    else
      S := ( ((cMax-cMin)*HLSMAX) + ((2*RGBMAX-cMax-cMin)/2) ) / (2*RGBMAX-cMax-cMin);

    { hue }
    Rdelta := ( ((cMax-R)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
    Gdelta := ( ((cMax-G)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
    Bdelta := ( ((cMax-B)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);

    if (R = cMax) then
      H := Bdelta - Gdelta
    else if (G = cMax) then
      H := (HLSMAX/3) + Rdelta - Bdelta
    else // B == cMax
      H := ((2 * HLSMAX) / 3) + Gdelta - Rdelta;

    if (H < 0) then
      H := H + HLSMAX;
    if (H > HLSMAX) then
      H := H - HLSMAX;
    Hue := Round(H);
    Luminance := Round(L);
    Saturation := Round(S);
  end;
  CachedRGBToHLSclrRGB := clrRGB;
  CachedRGBToHLSHue := Hue;
  CachedRGBToHLSLum := Luminance;
  CachedRGBToHLSSat := Saturation;
end;

function HueToRGB(Lum, Sat, Hue: Double): Integer;
var
  ResultEx: Double;
begin
  { range check: note values passed add/subtract thirds of range }
  if (hue < 0) then
     hue := hue + HLSMAX;

  if (hue > HLSMAX) then
     hue := hue - HLSMAX;

  { return r,g, or b value from this tridrant }
  if (hue < (HLSMAX/6)) then
    ResultEx := Lum + (((Sat-Lum)*hue+(HLSMAX/12))/(HLSMAX/6))
  else if (hue < (HLSMAX/2)) then
    ResultEx := Sat
  else if (hue < ((HLSMAX*2)/3)) then
    ResultEx := Lum + (((Sat-Lum)*(((HLSMAX*2)/3)-hue)+(HLSMAX/12))/(HLSMAX/6))
  else
    ResultEx := Lum;
  Result := Round(ResultEx);
end;

function ColorHLSToRGB(Hue, Luminance, Saturation: Word): TColorRef;

  function RoundColor(Value: Double): Integer;
  begin
    if Value > 255 then
      Result := 255
    else
      Result := Round(Value);
  end;

var
  R,G,B: Double;               { RGB component values }
  Magic1,Magic2: Double;       { calculated magic numbers (really!) }
begin
  if (Saturation = 0) then
  begin            { achromatic case }
     R := (Luminance * RGBMAX)/HLSMAX;
     G := R;
     B := R;
     if (Hue <> HLSUndefined) then
       ;{ ERROR }
  end
  else
  begin            { chromatic case }
     { set up magic numbers }
     if (Luminance <= (HLSMAX/2)) then
        Magic2 := (Luminance * (HLSMAX + Saturation) + (HLSMAX/2)) / HLSMAX
     else
        Magic2 := Luminance + Saturation - ((Luminance * Saturation) + (HLSMAX/2)) / HLSMAX;
     Magic1 := 2 * Luminance - Magic2;

     { get RGB, change units from HLSMAX to RGBMAX }
     R := (HueToRGB(Magic1,Magic2,Hue+(HLSMAX/3))*RGBMAX + (HLSMAX/2))/HLSMAX;
     G := (HueToRGB(Magic1,Magic2,Hue)*RGBMAX + (HLSMAX/2)) / HLSMAX;
     B := (HueToRGB(Magic1,Magic2,Hue-(HLSMAX/3))*RGBMAX + (HLSMAX/2))/HLSMAX;
  end;
  Result := RGB(RoundColor(R), RoundColor(G), RoundColor(B));
end;

threadvar
  CachedHighlightLum: Integer;
  CachedHighlightColor,
  CachedHighlight: TColor;
  CachedShadowLum: Integer;
  CachedShadowColor,
  CachedShadow: TColor;
  CachedColorValue: Integer;
  CachedLumValue: Integer;
  CachedColorAdjustLuma: TColor;

function ColorAdjustLuma(clrRGB: TColor; n: Integer; fScale: BOOL): TColor;
var
  H, L, S: Word;
begin
  if (clrRGB = CachedColorValue) and (n = CachedLumValue) then
    Result := CachedColorAdjustLuma
  else
  begin
    ColorRGBToHLS(ColorToRGB(clrRGB), H, L, S);
    Result := TColor(ColorHLSToRGB(H, L + n, S));
    CachedColorValue := clrRGB;
    CachedLumValue := n;
    CachedColorAdjustLuma := Result;
  end;
end;

function GetHighLightColor(const Color: TColor; Luminance: Integer): TColor;
var
  H, L, S: Word;
  Clr: Cardinal;
begin
  if (Color = CachedHighlightColor) and (Luminance = CachedHighlightLum) then
    Result := CachedHighlight
  else
  begin
    // Case for default luminance
    if (Color = clBtnFace) and (Luminance = 19) then
      Result := clBtnHighlight
    else
    begin
      Clr := ColorToRGB(Color);
      ColorRGBToHLS(Clr, H, L, S);
      if S > 220 then
        Result := ColorHLSToRGB(H, L - Luminance, S)
      else
        Result := TColor(ColorAdjustLuma(Clr, Luminance, False));
      CachedHighlightLum := Luminance;
      CachedHighlightColor := Color;
      CachedHighlight := Result;
    end;
  end;
end;

function GetShadowColor(const Color: TColor; Luminance: Integer): TColor;
var
  H, L, S: Word;
  Clr: Cardinal;
begin
  if (Color = CachedShadowColor) and (Luminance = CachedShadowLum) then
    Result := CachedShadow
  else
  begin
    // Case for default luminance
    if (Color = clBtnFace) and (Luminance = -50) then
      Result := clBtnShadow
    else
    begin
      Clr := ColorToRGB(Color);
      ColorRGBToHLS(Clr, H, L, S);
      if S >= 160 then
        Result := ColorHLSToRGB(H, L + Luminance, S)
      else
        Result := TColor(ColorAdjustLuma(Clr, Luminance, False));
    end;
    CachedShadowLum := Luminance;
    CachedShadowColor := Color;
    CachedShadow := Result;
  end;
end;

{ Utility Drawing Routines }

procedure DrawArrow(ACanvas: TCanvas; Direction: TScrollDirection;
  Location: TPoint; Size: Integer);
var
  I: Integer;
  Pts: array[0..2] of TPoint;
  OldWidth: Integer;
  OldColor: TColor;
begin
  if ACanvas = nil then exit;
  OldColor := ACanvas.Brush.Color;
  ACanvas.Brush.Color := ACanvas.Pen.Color;
  Move(ArrowPts[Direction], Pts, SizeOf(Pts));
  for I := 0 to 2 do
    Pts[I] := Point(Pts[I].x * Size + Location.X, Pts[I].y * Size + Location.Y);
  with ACanvas do
  begin
    OldWidth := Pen.Width;
    Pen.Width := 1;
    Polygon(Pts);
    Pen.Width := OldWidth;
    Brush.Color := OldColor;
  end;
end;

procedure DrawChevron(ACanvas: TCanvas; Direction: TScrollDirection;
  Location: TPoint; Size: Integer);

  procedure DrawLine;
  var
    I: Integer;
    Pts: array[0..2] of TPoint;
  begin
    Move(ArrowPts[Direction], Pts, SizeOf(Pts));
    // Scale to the correct size
    for I := 0 to 2 do
      Pts[I] := Point(Pts[I].X * Size + Location.X, Pts[I].Y * Size + Location.Y);
    case Direction of
      sdDown : Pts[2] := Point(Pts[2].X + 1, Pts[2].Y - 1);
      sdRight: Pts[2] := Point(Pts[2].X - 1, Pts[2].Y + 1);
      sdUp,
      sdLeft : Pts[2] := Point(Pts[2].X + 1, Pts[2].Y + 1);
    end;
    ACanvas.PolyLine(Pts);
  end;

var
  OldWidth: Integer;
begin
  if ACanvas = nil then exit;
  OldWidth := ACanvas.Pen.Width;
  ACanvas.Pen.Width := 1;
  case Direction of
    sdLeft, sdRight:
      begin
        Dec(Location.x, Size);
        DrawLine;
        Inc(Location.x);
        DrawLine;
        Inc(Location.x, 3);
        DrawLine;
        Inc(Location.x);
        DrawLine;
      end;
    sdUp, sdDown:
      begin
        Dec(Location.y, Size);
        DrawLine;
        Inc(Location.y);
        DrawLine;
        Inc(Location.y, 3);
        DrawLine;
        Inc(Location.y);
        DrawLine;
      end;
  end;
  ACanvas.Pen.Width := OldWidth;
end;

procedure DrawCheck(ACanvas: TCanvas; Location: TPoint; Size: Integer;
  Shadow: Boolean = True);
var
  PR: TPenRecall;
begin
  if ACanvas = nil then exit;
  PR := TPenRecall.Create(ACanvas.Pen);
  try
    ACanvas.Pen.Width := 1;
    ACanvas.PolyLine([
      Point(Location.X, Location.Y),
      Point(Location.X + Size, Location.Y + Size),
      Point(Location.X + Size * 2 + Size, Location.Y - Size),
      Point(Location.X + Size * 2 + Size, Location.Y - Size - 1),
      Point(Location.X + Size, Location.Y + Size - 1),
      Point(Location.X - 1, Location.Y - 2)]);
    if Shadow then
    begin
      ACanvas.Pen.Color := clWhite;
      ACanvas.PolyLine([
        Point(Location.X - 1, Location.Y - 1),
        Point(Location.X - 1, Location.Y),
        Point(Location.X, Location.Y + 1),
        Point(Location.X + Size, Location.Y + Size + 1),
        Point(Location.X + Size * 2 + Size + 1, Location.Y - Size),
        Point(Location.X + Size * 2 + Size + 1, Location.Y - Size - 1),
        Point(Location.X + Size * 2 + Size + 1, Location.Y - Size - 2)]);
    end;
  finally
    PR.Free;
  end;
end;

function FillGradient(DC: HDC; ARect: TRect; ColorCount: Integer;
  StartColor, EndColor: TColor; ADirection: TGradientDirection): Boolean;
var
  StartRGB: array [0..2] of Byte;
  RGBKoef: array [0..2] of Double;
  Brush: HBRUSH;
  AreaWidth, AreaHeight, I: Integer;
  ColorRect: TRect;
  RectOffset: Double;
begin
  RectOffset := 0;
  Result := False;
  if ColorCount < 1 then
    Exit;
  StartColor := ColorToRGB(StartColor);
  EndColor := ColorToRGB(EndColor);
  StartRGB[0] := GetRValue(StartColor);
  StartRGB[1] := GetGValue(StartColor);
  StartRGB[2] := GetBValue(StartColor);
  RGBKoef[0] := (GetRValue(EndColor) - StartRGB[0]) / ColorCount;
  RGBKoef[1] := (GetGValue(EndColor) - StartRGB[1]) / ColorCount;
  RGBKoef[2] := (GetBValue(EndColor) - StartRGB[2]) / ColorCount;
  AreaWidth := ARect.Right - ARect.Left;
  AreaHeight :=  ARect.Bottom - ARect.Top;
  case ADirection of
    gdHorizontal:
      RectOffset := AreaWidth / ColorCount;
    gdVertical:
      RectOffset := AreaHeight / ColorCount;
  end;
  for I := 0 to ColorCount - 1 do
  begin
    Brush := CreateSolidBrush(RGB(
      StartRGB[0] + Round((I + 1) * RGBKoef[0]),
      StartRGB[1] + Round((I + 1) * RGBKoef[1]),
      StartRGB[2] + Round((I + 1) * RGBKoef[2])));
    case ADirection of
      gdHorizontal:
        SetRect(ColorRect, Round(RectOffset * I), 0, Round(RectOffset * (I + 1)), AreaHeight);
      gdVertical:
        SetRect(ColorRect, 0, Round(RectOffset * I), AreaWidth, Round(RectOffset * (I + 1)));
    end;
    OffsetRect(ColorRect, ARect.Left, ARect.Top);
    FillRect(DC, ColorRect, Brush);
    DeleteObject(Brush);
  end;
  Result := True;
end;



procedure GradientFillCanvas(const ACanvas: TCanvas;
  const AStartColor, AEndColor: TColor; const ARect: TRect;
  const Direction: TGradientDirection);
const
  cGradientDirections: array[TGradientDirection] of Cardinal =
    (GRADIENT_FILL_RECT_H, GRADIENT_FILL_RECT_V);
var
  StartColor, EndColor: Cardinal;
  Vertexes: array[0..1] of TTriVertex;
  GradientRect: TGradientRect;
begin
  StartColor := ColorToRGB(AStartColor);
  EndColor := ColorToRGB(AEndColor);
  FillGradient(ACanvas.Handle, ARect, 8, AStartColor, AEndColor, Direction);
  Vertexes[0].x := ARect.Left;
  Vertexes[0].y := ARect.Top;
  Vertexes[0].Red := GetRValue(StartColor) shl 8;
  Vertexes[0].Blue := GetBValue(StartColor) shl 8;
  Vertexes[0].Green := GetGValue(StartColor) shl 8;
  Vertexes[0].Alpha := 0;

  Vertexes[1].x := ARect.Right;
  Vertexes[1].y := ARect.Bottom;
  Vertexes[1].Red := GetRValue(EndColor) shl 8;
  Vertexes[1].Blue := GetBValue(EndColor) shl 8;
  Vertexes[1].Green := GetGValue(EndColor) shl 8;
  Vertexes[1].Alpha := 0;

  GradientRect.UpperLeft := 0;
  GradientRect.LowerRight := 1;

//  GradientFill(ACanvas.Handle, @Vertexes[0], 2, @GradientRect, 1,
//    cGradientDirections[Direction]);
end;


procedure ShrinkImage(const SourceBitmap, StretchedBitmap: TBitmap;
  Scale: Double);
var
  ScanLines: array of PByteArray;
  DestLine: PByteArray;
  DestX, DestY: Integer;
  DestR, DestB, DestG: Integer;
  SourceYStart, SourceXStart: Integer;
  SourceYEnd, SourceXEnd: Integer;
  AvgX, AvgY: Integer;
  ActualX: Integer;
  CurrentLine: PByteArray;
  PixelsUsed: Integer;
  DestWidth, DestHeight: Integer;
begin
  DestWidth := StretchedBitmap.Width;
  DestHeight := StretchedBitmap.Height;
  SetLength(ScanLines, SourceBitmap.Height);
  for DestY := 0 to DestHeight - 1 do
  begin
    SourceYStart := Round(DestY / Scale);
    SourceYEnd := Round((DestY + 1) / Scale) - 1;

    if SourceYEnd >= SourceBitmap.Height then
      SourceYEnd := SourceBitmap.Height - 1;

    { Grab the destination pixels }
    DestLine := StretchedBitmap.ScanLine[DestY];
    for DestX := 0 to DestWidth - 1 do
    begin
      { Calculate the RGB value at this destination pixel }
      SourceXStart := Round(DestX / Scale);
      SourceXEnd := Round((DestX + 1) / Scale) - 1;

      DestR := 0;
      DestB := 0;
      DestG := 0;
      PixelsUsed := 0;
      if SourceXEnd >= SourceBitmap.Width then
        SourceXEnd := SourceBitmap.Width - 1;
      for AvgY := SourceYStart to SourceYEnd do
      begin
        if ScanLines[AvgY] = nil then
          ScanLines[AvgY] := SourceBitmap.ScanLine[AvgY];
        CurrentLine := ScanLines[AvgY];
        for AvgX := SourceXStart to SourceXEnd do
        begin
          ActualX := AvgX*3; { 3 bytes per pixel }
          DestR := DestR + CurrentLine[ActualX];
          DestB := DestB + CurrentLine[ActualX+1];
          DestG := DestG + CurrentLine[ActualX+2];
          Inc(PixelsUsed);
        end;
      end;

      { pf24bit = 3 bytes per pixel }
      ActualX := DestX*3;
      DestLine[ActualX] := Round(DestR / PixelsUsed);
      DestLine[ActualX+1] := Round(DestB / PixelsUsed);
      DestLine[ActualX+2] := Round(DestG / PixelsUsed);
    end;
  end;
end;


procedure EnlargeImage(const SourceBitmap, StretchedBitmap: TBitmap;
  Scale: Double);
var
  ScanLines: array of PByteArray;
  DestLine: PByteArray;
  DestX, DestY: Integer;
  DestR, DestB, DestG: Double;
  SourceYStart, SourceXStart: Integer;
  SourceYPos: Integer;
  AvgX, AvgY: Integer;
  ActualX: Integer;
  CurrentLine: PByteArray;
  { Use a 4 pixels for enlarging }
  XWeights, YWeights: array[0..1] of Double;
  PixelWeight: Double;
  DistFromStart: Double;
  DestWidth, DestHeight: Integer;
begin
  DestWidth := StretchedBitmap.Width;
  DestHeight := StretchedBitmap.Height;
  Scale := StretchedBitmap.Width / SourceBitmap.Width;
  SetLength(ScanLines, SourceBitmap.Height);
  for DestY := 0 to DestHeight - 1 do
  begin
    DistFromStart := DestY / Scale;
    SourceYStart := Round(DistFromSTart);
    YWeights[1] := DistFromStart - SourceYStart;
    if YWeights[1] < 0 then
      YWeights[1] := 0;
    YWeights[0] := 1 - YWeights[1];

    DestLine := StretchedBitmap.ScanLine[DestY];
    for DestX := 0 to DestWidth - 1 do
    begin
      { Calculate the RGB value at this destination pixel }
      DistFromStart := DestX / Scale;
      if DistFromStart > (SourceBitmap.Width - 1) then
        DistFromStart := SourceBitmap.Width - 1;
      SourceXStart := Round(DistFromStart);
      XWeights[1] := DistFromStart - SourceXStart;
      if XWeights[1] < 0 then
        XWeights[1] := 0;
      XWeights[0] := 1 - XWeights[1];

      { Average the four nearest pixels from the source mapped point }
      DestR := 0;
      DestB := 0;
      DestG := 0;
      for AvgY := 0 to 1 do
      begin
        SourceYPos := SourceYStart + AvgY;
        if SourceYPos >= SourceBitmap.Height then
          SourceYPos := SourceBitmap.Height - 1;
        if ScanLines[SourceYPos] = nil then
          ScanLines[SourceYPos] := SourceBitmap.ScanLine[SourceYPos];
            CurrentLine := ScanLines[SourceYPos];

        for AvgX := 0 to 1 do
        begin
          if SourceXStart + AvgX >= SourceBitmap.Width then
            SourceXStart := SourceBitmap.Width - 1;

          ActualX := (SourceXStart + AvgX) * 3; { 3 bytes per pixel }

          { Calculate how heavy this pixel is based on how far away
            it is from the mapped pixel }
          PixelWeight := XWeights[AvgX] * YWeights[AvgY];
          DestR := DestR + CurrentLine[ActualX] * PixelWeight;
          DestB := DestB + CurrentLine[ActualX+1] * PixelWeight;
          DestG := DestG + CurrentLine[ActualX+2] * PixelWeight;
        end;
      end;

      ActualX := DestX * 3;
      DestLine[ActualX] := Round(DestR);
      DestLine[ActualX+1] := Round(DestB);
      DestLine[ActualX+2] := Round(DestG);
    end;
  end;
end;

procedure ScaleImage(const SourceBitmap, ResizedBitmap: TBitmap;
  const ScaleAmount: Double);
var
  DestWidth, DestHeight: Integer;
begin
  DestWidth := Round(SourceBitmap.Width * ScaleAmount);
  DestHeight := Round(SourceBitmap.Height * ScaleAmount);
  { We must work in 24-bit to insure the pixel layout for
    scanline is correct }
  SourceBitmap.PixelFormat := pf24bit;

  ResizedBitmap.Width := DestWidth;
  ResizedBitmap.Height := DestHeight;
  ResizedBitmap.Canvas.Brush.Color := clNone;
  ResizedBitmap.Canvas.FillRect(Rect(0, 0, DestWidth, DestHeight));
  ResizedBitmap.PixelFormat := pf24bit;

  if ResizedBitmap.Width < SourceBitmap.Width then
    ShrinkImage(SourceBitmap, ResizedBitmap, ScaleAmount)
  else
    EnlargeImage(SourceBitmap, ResizedBitmap, ScaleAmount);
end;

function ColorToWebColorStr(Color: TColor): string;
var
  RGB: Integer;
begin
  RGB := ColorToRGB(Color);
  Result := UpperCase(Format('#%.2x%.2x%.2x', [GetRValue(RGB),
    GetGValue(RGB), GetBValue(RGB)]));  { do not localize }
end;

function ColorToWebColorName(Color: TColor): string;
begin
  Result := RGBToWebColorName(ColorToRGB(Color));
end;

function WebColorToRGB(WebColor: Integer): Integer;
begin
  Result := StrToInt(Format('$%.2x%.2x%.2x', [GetRValue(WebColor),
    GetGValue(WebColor), GetBValue(WebColor)]));  { do not localize }
end;

function RGBToWebColorStr(RGB: Integer): string;
begin
  Result := UpperCase(Format('#%.2x%.2x%.2x', [GetRValue(RGB),
    GetGValue(RGB), GetBValue(RGB)]));  { do not localize }
end;

function RGBToWebColorName(RGB: Integer): string;
var
  I: Integer;
begin
  Result := RGBToWebColorStr(RGB);
  for I := 0 to Length(WebNamedColors) - 1 do
    if RGB = WebNamedColors[I].Value then
    begin
      Result := WebNamedColors[I].Name;
      exit;
    end;
end;

function WebColorNameToColor(WebColorName: string): TColor;
var
  I: Integer;
begin
  for I := 0 to Length(WebNamedColors) - 1 do
    if CompareText(WebColorName, WebNamedColors[I].Name) = 0 then
    begin
      Result := WebNamedColors[I].Value;
      exit;
    end;
  raise Exception.Create(SInvalidColorString);
end;

function WebColorStrToColor(WebColor: string): TColor;
const
  OffsetValue: array[Boolean] of Integer = (0,1);
var
  I: Integer;
  Offset: Integer;
begin
  if (Length(WebColor) < 6) or (Length(WebColor) > 7) then
    raise Exception.Create(SInvalidColorString);
  for I := 1 to Length(WebColor) do
    if not (WebColor[I] in ['#', 'a'..'f', 'A'..'F', '0'..'9']) then              { do not localize }
      raise Exception.Create(SInvalidColorString);
  Offset := OffsetValue[Pos('#', WebColor) = 1];
  Result := RGB(StrToInt('$' + Copy(WebColor, 1 + Offset, 2)),                    { do not localize }
    StrToInt('$' + Copy(WebColor, 3 + Offset, 2)), StrToInt('$' + Copy(WebColor, 5 + Offset, 2)));  { do not localize }
end;

procedure SortColorArray(ColorArray: TColorArray; L, R: Integer; SortType: TColorArraySortType;
  Reverse: Boolean);

  function Compare(A, B: Integer): Integer;
  var
    H1, L1, S1: Word;
    H2, L2, S2: Word;
    R1, G1, B1: Word;
    R2, G2, B2: Word;
  begin
    Result := 0;
    if SortType in [stHue, stSaturation, stLuminance] then
    begin
      if Reverse then
      begin
        ColorRGBToHLS(ColorArray[A].Value, H1, L1, S1);
        ColorRGBToHLS(ColorArray[B].Value, H2, L2, S2);
      end
      else
      begin
        ColorRGBToHLS(ColorArray[A].Value, H2, L2, S2);
        ColorRGBToHLS(ColorArray[B].Value, H1, L1, S1);
      end;
      case SortType of
        stHue: Result := H2 - H1;
        stSaturation: Result := H2 - H1;
        stLuminance: Result := L2 - L1;
      end;
    end
    else
    begin
      if Reverse then
      begin
        R1 := GetRValue(ColorArray[A].Value);
        G1 := GetGValue(ColorArray[A].Value);
        B1 := GetBValue(ColorArray[A].Value);
        R2 := GetRValue(ColorArray[B].Value);
        G2 := GetGValue(ColorArray[B].Value);
        B2 := GetBValue(ColorArray[B].Value);
      end
      else
      begin
        R2 := GetRValue(ColorArray[A].Value);
        G2 := GetGValue(ColorArray[A].Value);
        B2 := GetBValue(ColorArray[A].Value);
        R1 := GetRValue(ColorArray[B].Value);
        G1 := GetGValue(ColorArray[B].Value);
        B1 := GetBValue(ColorArray[B].Value);
      end;
      case SortType of
        stRed: Result := R2 - R1;
        stGreen: Result := G2 - G1;
        stBlue: Result := B2 - B1;
        stCombo: Result := (R2 + G2 + B2) - (R1 + G1 + B1);
      end;
    end;
  end;

var
  I, J, P: Integer;
  WebColor: TIdentMapEntry;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while Compare(I, P) < 0 do Inc(I);
      while Compare(J, P) > 0 do Dec(J);
      if I <= J then
      begin
        WebColor := ColorArray[I];
        ColorArray[I] := ColorArray[J];
        ColorArray[J] := WebColor;
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then SortColorArray(ColorArray, L, J, SortType);
    L := I;
  until I >= R;
end;

initialization
  CachedHighlightLum := 0;
  CachedHighlightColor := 0;
  CachedHighlight := 0;
  CachedShadowLum := 0;
  CachedShadowColor := 0;
  CachedShadow := 0;
  CachedColorValue := 0;
  CachedLumValue := 0;
  CachedColorAdjustLuma := 0;
end.
