unit ZipUtils;

interface

uses Classes, System.Zip;

procedure ExtractZipToStream(const aZipFile, aExtractedFile: String; aOutStream: TStream);

implementation

procedure ExtractZipToStream(const aZipFile,
  aExtractedFile: String; aOutStream: TStream);
var
  Zip: TZipFile;
  LocalHeader: TZipHeader;
  TempStream: TStream;
begin

  Zip := TZipFile.Create;
  Zip.Open(aZipFile, zmRead);
  try

    Zip.Read(aExtractedFile, TempStream, LocalHeader);
    aOutStream.CopyFrom(TempStream,TempStream.Size);

  finally
    Zip.Close;
    Zip.Free;
  end;
end;

end.
