unit SevenZipHelper;

interface

uses Classes, SevenZipVCL;
function getSevenZ(): TSevenZip;
procedure ExtractZipToStream(const aZipFile, aExtractedFile: String; aOutStream: TStream);


var
  _S_SevenZipGetPasswordProc: T7zGetPassword;

implementation

uses SysUtils, System.Zip;

var
  _S_SevenZip: TSevenZip;

function getSevenZ(): TSevenZip;
begin
  if not Assigned(_S_SevenZip) then
  begin
    _S_SevenZip := TSevenZip.Create(nil);
    _S_SevenZip.OnGetPassword := _S_SevenZipGetPasswordProc;
  end;
  result := _S_SevenZip;
end;

procedure ExtractZipToStream(const aZipFile,
  aExtractedFile: String; aOutStream: TStream);
var
  ix, sz: Integer;
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

initialization

finalization

FreeAndNil(_S_SevenZip);

end.
