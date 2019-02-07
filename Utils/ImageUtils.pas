unit ImageUtils;

interface
uses
  Windows, Vcl.Graphics, Classes, Jpeg, PngImage, Math, Wincodec;

procedure SmoothResize(srcBitmap: TBitmap; destBitmap: TBitmap);
function StretchImage(srcPicture: TPicture; width, heigth: integer): TPicture;
function LoadResourceImage(resourceName: string): TPicture;
function LoadResourceWICImage(resourceName: string): TWICImage;
function CreateThumbnail(image: TWICImage; thumbnailWidth, thumbnailHeight: Integer): TWICImage;
function CreateThumbnailFromFile(path: string; thumbnailWidth, thumbnailHeight: Integer): TWICImage;

implementation

function CreateThumbnailFromFile(path: string; thumbnailWidth, thumbnailHeight: Integer): TWICImage;
var
  sourceImage: TWICImage;
begin
  sourceImage := TWicImage.Create;
  sourceImage.LoadFromFile(path);

  Result := CreateThumbnail(sourceImage, thumbnailWidth, thumbnailHeight);
end;

function CreateThumbnail(image: TWICImage; thumbnailWidth, thumbnailHeight: Integer): TWICImage;
var
  srcBitmap, thumbnailBitmap: TBitmap;
  resImage: TWICImage;
  scale, scaleX, scaleY: Double;
  png: TPngImage;
  x, y, w, h: Integer;
  memory: TMemoryStream;
begin
  memory := TMemoryStream.Create;
  srcBitmap := TBitmap.Create;
  thumbnailBitmap := TBitmap.Create;

  try
    scaleX := thumbnailWidth / image.Width;
    scaleY := thumbnailHeight / image.Height;

    scale := Math.Min(scaleX, scaleY);

    // draw wic image to bitmap
    srcBitmap.SetSize(image.Width, image.Height);
    srcBitmap.Canvas.StretchDraw(srcBitmap.Canvas.ClipRect, image);

    // create thumbnail bitmap
    thumbnailBitmap.AlphaFormat := afDefined;
    thumbnailBitmap.Canvas.Brush.Color := clWebMagenta;
    thumbnailBitmap.Transparent := true;
    thumbnailBitmap.TransparentMode := tmFixed;
    thumbnailBitmap.TransparentColor := clWebMagenta;
    thumbnailBitmap.PixelFormat := pf32bit;
    thumbnailBitmap.SetSize(thumbnailWidth, thumbnailHeight);

    // fit source image to thumbnail bitmap, keeping aspect ratio
    SetStretchBltMode(thumbnailBitmap.Canvas.Handle, HALFTONE);
    x := Round(thumbnailWidth - image.Width * scale) div 2;
    y := Round(thumbnailHeight - image.Height * scale) div 2;
    w := thumbnailWidth - 2 * x;
    h := thumbnailHeight - 2 * y;
    StretchBlt(thumbnailBitmap.Canvas.Handle, x, y, w, h, srcBitmap.Canvas.Handle, 0, 0, image.Width, image.Height, SRCCOPY);

    // convert thumbnail bitmap to png
    png := TPngImage.Create;
    png.Assign(thumbnailBitmap);

    // save png to memory
    png.SaveToStream(memory);
    memory.Position := 0;

    // load png as wic image from memory
    resImage := TWICImage.Create;
    resImage.LoadFromStream(memory);
    result := resImage;
  finally
    srcBitmap.Free;
    thumbnailBitmap.Free;
    memory.Free;
  end;
end;

procedure SmoothResize(srcBitmap: TBitmap; destBitmap: TBitmap);
var pt:TPoint;
    h: HDC;
begin
  h := destBitmap.Canvas.Handle;

  GetBrushOrgEx(h, pt);
  SetStretchBltMode(h, HALFTONE);
  SetBrushOrgEx(h, pt.x, pt.y, @pt);
  StretchBlt(h, 0, 0, destBitmap.Width-1,
    destBitmap.Height-1, srcBitmap.Canvas.Handle,
    0, 0, srcBitmap.Width-1, srcBitmap.Height-1,SRCCOPY);
end;

function StretchImage(srcPicture: TPicture; width, heigth: integer): TPicture;
var
  resPicture: TPicture;
  rect: TRect;
  Bitmap: TBitmap;
begin
  rect.Left := 0;
  rect.Top := 0;

  //proportional resize
  if srcPicture.Width > srcPicture.Height then
  begin
    rect.Right := width;
    rect.Bottom := (width * srcPicture.Height) div srcPicture.Width;
  end
  else
  begin
    rect.Bottom := heigth;
    rect.Right := (heigth * srcPicture.Width) div srcPicture.Height;
  end;

  Bitmap := TBitmap.Create;
  Bitmap.Assign(srcPicture.Graphic);
  try

    resPicture := TPicture.Create;

    resPicture.Bitmap.Width := rect.Right;
    resPicture.Bitmap.Height := rect.Bottom;
    SmoothResize(Bitmap, resPicture.Bitmap);
  finally
    Bitmap.Free;
  end;

  Result := resPicture;
end;

function LoadResourceImage(resourceName: string): TPicture;
var
 picture : TPicture;
 resStream : TResourceStream;
begin
  resStream := nil;
  try
    picture := TPicture.Create;
    resStream := TResourceStream.Create(HInstance, resourceName, RT_RCDATA);
    picture.LoadFromStream(resStream);

    Result := picture;
  finally
    if Assigned(resStream) then
      resStream.Free;
  end;
end;

function LoadResourceWICImage(resourceName: string): TWICImage;
var
 image : TWICImage;
 resStream : TResourceStream;
begin
  resStream := nil;
  try
    image := TWICImage.Create;
    resStream := TResourceStream.Create(HInstance, resourceName, RT_RCDATA);
    image.LoadFromStream(resStream);

    Result := image;
  finally
    if Assigned(resStream) then
      resStream.Free;
  end;
end;

end.
