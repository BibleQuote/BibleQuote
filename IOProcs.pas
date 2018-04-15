unit IOProcs;

interface

uses
  Windows, Classes, SysUtils, StrUtils, StringProcs, IOUtils, Types;

const
  cRussianCodePage = 1251;

  // Read html file with automatic encoding recognition
procedure ReadHtmlTo(const aFileName: string; var rResult: TStrings; defaultEncoding: TEncoding); overload;
procedure ReadHtmlTo(const aFileName: string; var rResult: string; defaultEncoding: TEncoding); overload;
function ReadHtml(const aFileName: string; defaultEncoding: TEncoding): TStrings;

// Write html file with utf-8 encoding
procedure WriteHtml(const aFileName: string; const aContent: string);

// Read text file with automatic encoding recognition
function ReadTextFileLines(const aFileName: string; defaultEncoding: TEncoding): TStrings;
function ReadTextFile(const aFileName: string; defaultEncoding: TEncoding): string;

// Write text file with utf-8 encoding
procedure WriteTextFile(const aFileName: string; aContent: TStrings); overload;
procedure WriteTextFile(const aFileName: string; const aContent: string); overload;

// Add or replace encoding metatag with utf-8
procedure WriteEncodingMetatagToHtml(var html: string);

// Read dictionary fragment with automatic encoding recognition
function ReadDictFragment(const aFileName: string; aOffset: Integer; aCount: Integer; defaultEncoding: TEncoding): string;

function TextFromFile(filename: string): string;

// Get encoding codepage by its name
// (e.g., 'win-1251' -> 1251, 'utf-8' -> CP_UTF8).
function GetEncodingByName(const aName: string): TEncoding;

// Get encoding codepage by windows charset
// (скажем, 204 -> 1251).
function GetEncodingByWinCharSet(aCharSet: Integer): Integer;

function FindEncodingMetatag(const ansiText: string; out rBeginPos: Integer; out rLength: Integer): TEncoding;

function LoadBibleqtIniFileEncoding(const aFileName: string;
  defaultEncoding: TEncoding): TEncoding;

implementation

uses SevenZipVCL, sevenZipHelper, BibleQuoteUtils;

function ParseArchived(filename: string; out fileIx, fileSz: Integer): boolean;
var
  fn: string;
  filenameEndPos: Integer;
begin
  if (length(filename) <= 0) or (filename[1] <> '?') then
  begin
    result := false;
    exit;
  end;
  filenameEndPos := Pos('??', filename);
  if filenameEndPos <= 0 then
    raise Exception.Create('Неверый путь к архиву');
  fn := Copy(filename, 2, filenameEndPos - 2);
  if getSevenZ().SZFileName <> fn then
    getSevenZ().SZFileName := fn;
  fn := Copy(filename, filenameEndPos + 2, $FFFFFF);
  fileIx := getSevenZ().GetIndexByFilename(fn, @fileSz);
  result := true;
end;

procedure ReadFileContent(aFileName: string; var rBuffer: TBytes);
var
  dFile: TFileStream;
  dSize, indexOfFile: Integer;
begin
  rBuffer := TBytes.Create();
  dFile := nil;
  if not ParseArchived(aFileName, indexOfFile, dSize) then
  begin
    try
      dFile := TFileStream.Create(aFileName, fmOpenRead);
      dSize := dFile.Size;

      if dSize > 0 then
      begin
        SetLength(rBuffer, dSize);
        dFile.ReadBuffer(Pointer(rBuffer)^, dSize);
      end;

    finally
      dFile.Free;
    end;
  end
  else
  begin
    // the file is an archive
    if dSize < 0 then
      raise Exception.CreateFmt('Не найден в архиве: %s', [aFileName]);

    SetLength(rBuffer, dSize);
    getSevenZ().ExtracttoMem(indexOfFile, Pointer(rBuffer), dSize);
    if getSevenZ().ErrCode <> 0 then
    begin
      if (getSevenZ().mPasswordProtected) and (getSevenZ().ErrCode = 2) then
      begin
        aFileName := Copy(GetArchiveFromSpecial(aFileName), 2, $FFFF);
        raise TBQPasswordException.CreateFmt(getSevenZ().Password, aFileName, '#1%s', [aFileName]);
      end
      else
        abort;
    end;
  end;

end;

function GetLexem(var ansiText: string; var rPos: Integer): string;
var
  dLength: Integer;
  dChar: Char;
  dBeginPos: Integer;
begin
  dLength := length(ansiText);
  result := '';

  while (rPos <= dLength) and (CharInSet(ansiText[rPos], [' ', #9])) do
    rPos := rPos + 1;

  if rPos > { = } dLength then // AlekId:!!BUG!!
    exit;

  dBeginPos := rPos;

  dChar := ansiText[rPos];
  if CharInSet(dChar, ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_', '-', '+']) then
  begin
    rPos := rPos + 1;

    while (rPos <= dLength) and
      CharInSet(ansiText[rPos], ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_', '-', '+', '.', '%']) do
      rPos := rPos + 1;

  end
  else if CharInSet(dChar, ['''', '"']) then
  begin
    rPos := rPos + 1;

    while (rPos <= dLength) and (ansiText[rPos] <> dChar) do
      rPos := rPos + 1;

    if rPos <= dLength then
      rPos := rPos + 1;

  end
  else
  begin
    rPos := rPos + 1;

  end;

  result := Copy(ansiText, dBeginPos, rPos - dBeginPos);

end;

function GetEncodingByName(const aName: string): TEncoding;
var
  dName: string;
  codePage: Integer;
begin
  result := nil;
  codePage := -1;

  dName := LowerCase(aName);

  if dName = 'utf-8'        then result := TEncoding.UTF8 else
  if dName = 'utf-16'       then result := TEncoding.Unicode else
  if dName = 'windows-1251' then codePage := 1251 else
  if dName = 'windows-1252' then codePage := 1252 else
  if dName = 'windows-1253' then codePage := 1253 else
  if dName = 'windows-1250' then codePage := 1250 else
  if dName = 'dos-866'      then codePage := 866 else
  if dName = 'koi8-r'       then codePage := 20866 else
  if dName = 'koi8-u'       then codePage := 21866 else
  if dName = 'iso-8859-1'   then codePage := 28591 else
  if dName = 'iso-8859-2'   then codePage := 28592 else
  if dName = 'iso-8859-3'   then codePage := 28593 else
  if dName = 'iso-8859-4'   then codePage := 28594 else
  if dName = 'iso-8859-5'   then codePage := 28595 else
  if dName = 'iso-8859-6'   then codePage := 28596 else
  if dName = 'iso-8859-7'   then codePage := 28597 else
  if dName = 'iso-8859-8'   then codePage := 28598 else
  if dName = 'iso-8859-9'   then codePage := 28599 else
  if dName = 'iso-8859-15'  then codePage := 28605 else
  result := nil;

  if result <> nil then
    exit;

  if codePage <> -1 then
    result := TEncoding.GetEncoding(codePage);
end;

function GetEncodingByWinCharSet(aCharSet: Integer): Integer;
begin
  result := cRussianCodePage;

  case aCharSet of
    EASTEUROPE_CHARSET:  result := 1250;
    ANSI_CHARSET:        result := 1251;
    1:                   result := 1251;
    RUSSIAN_CHARSET:     result := 1251;
    201:                 result := 1252;
    GREEK_CHARSET:       result := 1253;
    TURKISH_CHARSET:     result := 1254;
    HEBREW_CHARSET:      result := 1255;
    ARABIC_CHARSET:      result := 1256;
    BALTIC_CHARSET:      result := 1257;
    VIETNAMESE_CHARSET:  result := 1258;
    239:                 result := 1252;
    SHIFTJIS_CHARSET:    result := 932;
    HANGEUL_CHARSET:     result := 949;
    GB2312_CHARSET:      result := 936;
    CHINESEBIG5_CHARSET: result := 950;
    THAI_CHARSET:        result := 874;
    JOHAB_CHARSET:       result := 1361;
    OEM_CHARSET:         result := 866;
  end;

end;

// Find codepage and encoding meta tag boundary
function FindEncodingMetatag(const ansiText: string; out rBeginPos: Integer; out rLength: Integer): TEncoding;
var
  dHeaderEndPos: Integer;
  dPos: Integer;
  dPos2: Integer;
  dLCBuffer: string;
  dLength: Integer;
  dLexem: string;
  dResBeginPos: Integer;
  dResLength: Integer;

  dContentTypeValue: string;
  dCharSet: string;

label
  SkipThisTag;

begin
  result := nil;
  rBeginPos := 0;
  rLength := 0;
  dResBeginPos := 0;
  dResLength := 0;

  dHeaderEndPos := PosCIL('</head>', ansiText);
  if dHeaderEndPos <= 0 then
    dHeaderEndPos := Pos('<body>', ansiText);
  if dHeaderEndPos <= 0 then
    exit;

  dLCBuffer := Copy(ansiText, 0, dHeaderEndPos - 1);

  { Find tag <meta http-equiv="Content-Type" content="..."> and get content value. }

  dContentTypeValue := '';
  dPos := 1;
  dLength := length(dLCBuffer);

  while dPos <= dLength do
  begin
    dPos2 := PosEx('<meta ', dLCBuffer, dPos);
    if dPos2 <= 0 then
      dPos2 := PosEx('<meta'#9, dLCBuffer, dPos);

    if dPos2 <= 0 then
    begin
      dPos := dLength + 1;
      Break;
    end;

    dResBeginPos := dPos2;
    dPos := dPos2 + 6; // Length ('<meta ')

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem <> 'http-equiv' then
      goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem <> '=' then
      goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if (dLexem <> '''content-type''') and (dLexem <> '"content-type"') and
      (dLexem <> 'content-type') then
      goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem <> 'content' then
      goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem <> '=' then
      goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem = '' then
      goto SkipThisTag;
    if (dLexem[1] <> '''') and (dLexem[1] <> '"') then
      goto SkipThisTag;
    if dLexem[length(dLexem)] <> dLexem[1] then
      goto SkipThisTag;

    dContentTypeValue := Copy(dLexem, 2, length(dLexem) - 2);

    while (dPos <= dLength) and (dLexem <> '') and (dLexem <> '>') do
      dLexem := GetLexem(dLCBuffer, dPos);

    if dLexem <> '>' then
      exit;

    dResLength := dPos - dResBeginPos;

    Break;

  SkipThisTag:
    while (dPos <= dLength) and (dLexem <> '') and (dLexem <> '>') do
      dLexem := GetLexem(dLCBuffer, dPos);

  end;

  if dContentTypeValue = '' then
    exit;

  dPos := 1;
  dLength := length(dContentTypeValue);
  dCharSet := '';

  while (dPos <= dLength) do
  begin
    dLexem := GetLexem(dContentTypeValue, dPos);
    if dLexem <> 'charset' then
      Continue;

    dLexem := GetLexem(dContentTypeValue, dPos);
    if dLexem <> '=' then
      Break;

    dLexem := GetLexem(dContentTypeValue, dPos);
    if dLexem = '' then
      Break;

    dCharSet := dLexem;
    Break;

  end;

  if dCharSet = '' then
    exit;

  result := GetEncodingByName(dCharSet);
  rBeginPos := dResBeginPos;
  rLength := dResLength;

end;

function ReadEncodingMetatag(const aBuffer: TBytes): TEncoding;
var
  dTempBeginPos: Integer;
  dTempLength: Integer;
  ansiText: string;
begin
  ansiText := TEncoding.ANSI.GetString(aBuffer);

  result := FindEncodingMetatag(ansiText, dTempBeginPos, dTempLength);
end;

procedure WriteEncodingMetatagToHtml(var html: string);
var
  dBeginPos: Integer;
  dLength: Integer;
  dMetatag: string;
begin
  dMetatag :=
    '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';

  FindEncodingMetatag(html, dBeginPos, dLength);
  if dBeginPos <> 0 then
  begin
    // Есть метатэг. Меняем его на наш.
    html := Copy(html, 1, dBeginPos - 1) + dMetatag +
      Copy(html, dBeginPos + dLength, length(html));

  end
  else
  begin
    dBeginPos := PosCIL('<head>', html);
    if dBeginPos <> 0 then
    begin
      // Нет метатэга, но есть <head>. Вставляем после него наш метатэг.
      html := Copy(html, 1, dBeginPos + 6 { Length ('<head>') } - 1) + #13#10 +
        dMetatag + #13#10 + Copy(html, dBeginPos + 6, length(html));

    end
    else
    begin
      dBeginPos := PosCIL('<html>', html);
      if dBeginPos <> 0 then
      begin
        // Нет метатэга, нет <head>, но есть <html>.
        // Вставляем после него <head> и наш метатэг.

        html := Copy(html, 1, dBeginPos + 6 { Length ('<html>') } - 1) + #13#10
          + '<head>' + dMetatag + '</head>' + #13#10 + Copy(html, dBeginPos + 6,
          length(html));

      end
      else
      begin
        // Вообще ничего нет.

        html := '<html>' + #13#10 + '<head>' + #13#10 + dMetatag + #13#10 +
          '</head>' + #13#10 + '<body>' + #13#10 + html + #13#10 + '</body>' +
          #13#10 + '</html>';

      end;
    end;
  end;

end;

function ReadEncodingFromDictFile(aFile: TFileStream): TEncoding;
const
  cEncTagBeginning: string = '<!-- #enc="';
var
  dBuffer: TBytes;
  ansiText: string;
  dBufferLength: Integer;
  dPos: Integer;
  dCharSet: string;
  encoding: TEncoding;
begin
  result := nil;

  SetLength(dBuffer, 128);
  aFile.Seek(0, soFromBeginning);
  dBufferLength := aFile.Read(Pointer(dBuffer)^, 128);
  SetLength(dBuffer, dBufferLength);

  if dBufferLength < 2 then
    exit;

  encoding := nil;

  // Find the appropraite encoding by preamble
  TEncoding.GetBufferEncoding(dBuffer, encoding, nil);
  if (encoding <> nil) then
  begin
    result := encoding;
    exit;
  end;

  ansiText := TEncoding.ANSI.GetString(dBuffer);

  ansiText := LowerCase(ansiText);
  dPos := Pos(cEncTagBeginning, ansiText);
  if dPos <= 0 then
    exit;

  dPos := dPos + length(cEncTagBeginning);
  dCharSet := '';

  while (dPos <= dBufferLength) and (ansiText[dPos] <> '"') do
  begin
    dCharSet := dCharSet + ansiText[dPos];
    dPos := dPos + 1;
  end;

  if dPos > dBufferLength then
    exit;

  result := GetEncodingByName(dCharSet);

end;

function ReadHtml(const aFileName: string; defaultEncoding: TEncoding): TStrings;
var
  lines: TStrings;
begin
  Result := nil;
  try
    lines := TStringList.Create;
    ReadHtmlTo(aFileName, lines, defaultEncoding);
    Result := lines;
  except
    lines.Free;
  end;

end;

function StringListFromStrings(const strings: TArray<string>): TStrings;
var
  i: Integer;
begin
  result := TStringList.Create;
  for i := low(strings) to high(strings) do
    result.Add(strings[i]);
end;

procedure ReadHtmlTo(const aFileName: string; var rResult: TStrings; defaultEncoding: TEncoding); overload;
var
  fileText: string;
begin
  if rResult = nil then
    rResult := TStringList.Create
  else
    rResult.Clear;

  ReadHtmlTo(aFileName, fileText, defaultEncoding);
  rResult := StringListFromStrings(fileText.Split([#13#10, #10]));
end;

procedure ReadHtmlTo(const aFileName: string; var rResult: string; defaultEncoding: TEncoding); overload;
var
  dBuffer: TBytes;
  encoding: TEncoding;
begin

  ReadFileContent(aFileName, dBuffer);

  encoding := nil;

  // Find the appropraite encoding by preamble
  TEncoding.GetBufferEncoding(dBuffer, encoding, nil);

  if encoding = nil then
  begin
    // buffer doesn't contain any preamble
    // find encoding in html metatag
    encoding := ReadEncodingMetatag(dBuffer);
    if encoding = nil then
      encoding := defaultEncoding;
  end;

  rResult := encoding.GetString(dBuffer);

end;

function ReadTextFileLines(const aFileName: string; defaultEncoding: TEncoding) : TStrings;
var
  fileText: string;
begin

  fileText := ReadTextFile(aFileName, defaultEncoding);
  result := StringListFromStrings(fileText.Split([#13#10, #10]));

end;

function ReadTextFile(const aFileName: string; defaultEncoding: TEncoding): string;
var
  dBuffer: TBytes;
  encoding: TEncoding;
begin
  dBuffer := TBytes.Create();
  ReadFileContent(aFileName, dBuffer);

  encoding := nil;

  // Find the appropraite encoding by preamble
  TEncoding.GetBufferEncoding(dBuffer, encoding, nil);

  if encoding = nil then
  begin
    // buffer doesn't contain any preamble
    // apply default byte encoding
    encoding := defaultEncoding;
  end;

  result := encoding.GetString(dBuffer);
end;

function StringsToArray(const S: TStrings): TStringDynArray;
var
  i: Integer;
begin
  result := nil;
  SetLength(result, S.Count);
  for i := 0 to S.Count - 1 do
    result[i] := S[i]
end;

procedure WriteTextFile(const aFileName: string; aContent: TStrings); overload;
begin
  TFile.WriteAllLines(aFileName, StringsToArray(aContent), TEncoding.UTF8);
end;

procedure WriteTextFile(const aFileName: string;
  const aContent: string); overload;
begin
  TFile.WriteAllText(aFileName, aContent, TEncoding.UTF8);
end;

procedure WriteHtml(const aFileName: string; const aContent: string);
var
  htmlCopy: string;
begin
  htmlCopy := aContent;
  WriteEncodingMetatagToHtml(htmlCopy);
  TFile.WriteAllText(aFileName, htmlCopy, TEncoding.UTF8);
end;

function ReadDictFragment(const aFileName: string; aOffset: Integer; aCount: Integer; defaultEncoding: TEncoding): string;
var
  dFile: TFileStream;
  dReadedCount: Integer;
  dABuffer: TBytes;
  encoding: TEncoding;
begin
  result := '';
  dFile := nil;

  if aCount <= 0 then
    exit;

  try
    dFile := TFileStream.Create(aFileName, fmOpenRead);
    if aOffset >= dFile.Size then
      exit;

    encoding := ReadEncodingFromDictFile(dFile);
    dFile.Seek(aOffset, soFromBeginning);

    if encoding = nil then
      encoding := defaultEncoding;

    SetLength(dABuffer, aCount);
    dReadedCount := dFile.Read(dABuffer, aCount);
    if length(dABuffer) <> dReadedCount then
      SetLength(dABuffer, dReadedCount);

    result := encoding.GetString(dABuffer);

  finally
    dFile.Free;
  end;
end;

function LoadBibleqtIniFileEncoding(const aFileName: string; defaultEncoding: TEncoding): TEncoding;
var
  dLines: TStrings;
  i: Integer;
  dName: string;
  dValue: string;
  codePage: Integer;
  charset: Integer;
begin
  dLines := ReadTextFileLines(aFileName, defaultEncoding);
  result := defaultEncoding;

  try
    for i := 0 to dLines.Count - 1 do
    begin
      dName := IniStringFirstPart(dLines[i]);
      dValue := IniStringSecondPart(dLines[i]);

      if dValue = '' then
        Continue;

      if dName = 'DefaultEncoding' then
      begin
        result := GetEncodingByName(dValue);
        if result = nil then
          result := defaultEncoding;

        exit;

      end
      else if dName = 'DesiredFontCharset' then
      begin
        charset := StrToInt(dValue);
        codePage := GetEncodingByWinCharSet(charset);
        if codePage <= 0 then
        begin
          result := defaultEncoding;
        end
        else
        begin
          result := TEncoding.GetEncoding(codePage);
        end;

        exit;

      end;

    end;

  finally
    dLines.Free;

  end;

end;

function TextFromFile(filename: string): string;
var
  lines: TStrings;
begin
  try
    lines := ReadTextFileLines(filename, TEncoding.GetEncoding(1251));
    result := lines.Text;
    lines.Free;
  except
    result := '';
  end;
end;

end.
