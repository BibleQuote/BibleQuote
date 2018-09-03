unit ImageUtils;

interface
uses
  Graphics, Windows, Classes;

function StretchImage(srcPicture: TPicture; width, heigth: integer): TPicture;
function LoadImage(resourceName: string): TPicture;

implementation

function StretchImage(srcPicture: TPicture; width, heigth: integer): TPicture;
var
  resPicture: TPicture;
  rect: TRect;
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

  resPicture := TPicture.Create;
  resPicture.Bitmap.Assign(srcPicture.Graphic);

  resPicture.Bitmap.Canvas.StretchDraw(rect, srcPicture.Graphic);
  resPicture.Bitmap.Width := rect.Right;
  resPicture.Bitmap.Height := rect.Bottom;

  Result := resPicture;
end;

function LoadImage(resourceName: string): TPicture;
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

end.
