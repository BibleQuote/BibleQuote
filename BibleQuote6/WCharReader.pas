unit WCharReader;

interface

uses
  Windows, Classes, SysUtils, StrUtils, WideStrings, string_procs;

const
  cRussianCodePage = 1251;

// Чтение html-файла, с автоматическим распознаванием кодировки.
procedure WChar_ReadHtmlFileTo(const aFileName: WideString; var rResult: TWideStrings; aDefaultByteEncoding: Integer = cRussianCodePage); overload;
procedure WChar_ReadHtmlFileTo(const aFileName: WideString; var rResult: WideString; aDefaultByteEncoding: Integer = cRussianCodePage); overload;
function WChar_ReadHtmlFile(const aFileName: WideString; aDefaultByteEncoding: Integer = cRussianCodePage): TWideStrings;

// Запись html-файла в кодировке 1251 (если возможно) или в utf-8.
procedure WChar_WriteHtmlFile(const aFileName: WideString; const aContent: WideString);

// Чтение текстового файла, с автоматическим распознаванием кодировки.
function WChar_ReadTextFileToTWideStrings(const aFileName: WideString; aDefaultByteEncoding: Integer = cRussianCodePage): TWideStrings;
function WChar_ReadTextFileToWideString(const aFileName: WideString; aDefaultByteEncoding: Integer = cRussianCodePage): WideString;

// Запись текстового файла, с автоматическим принятием решения, в какой кодировке записывать..
procedure WChar_WriteTextFile(const aFileName: WideString; aContent: TWideStrings); overload;
procedure WChar_WriteTextFile(const aFileName: WideString; const aContent: WideString); overload;

// Чтение фрагмента словаря, с автоматическим распознаванием кодировки.
function WChar_ReadDictFragment(const aFileName: WideString; aOffset: Integer; aCount: Integer; aDefaultByteEncoding: Integer = cRussianCodePage): WideString;

function TextFromFile(filename: WideString): WideString;

// Получение ID кодировки по ее html-названию
// (скажем, 'win-1251' -> 1251, 'utf-8' -> CP_UTF8).
function GetEncodingByName(const aName: WideString): Integer;

// Получение ID кодировки по внутреннему виндовому набору символов
// (скажем, 204 -> 1251).
function GetEncodingByWinCharSet(aCharSet: Integer): Integer;

function LoadBibleqtIniFileEncoding( const  aFileName: WideString; aDefault: Integer = cRussianCodePage ): Integer;

implementation
uses SevenZipVCL, BibleQuoteUtils;

const
  cEncUnicode = 1;
  cEncUnicode_BigEndian = 2;

var
  fUnicodeToRussianXLAT: array[0..65535] of AnsiChar;

function ParseArchived(fileName: WideString; out fileIx, fileSz: integer): boolean;
var
  fn: WideString;
  filenameEndPos: integer;
begin
 if (length(fileName)<=0) or (fileName[1] <> '?') then begin
    result := false; exit; end;
  filenameEndPos := Pos('??', fileName);
  if filenameEndPos <= 0 then raise Exception.Create('Неверый путь к архиву');
  fn := Copy(fileName, 2, filenameEndPos - 2);
  if S_SevenZip.SZFileName<>fn then
  S_SevenZip.SZFileName := fn;
  fn := Copy(fileName, filenameEndPos + 2, $FFFFFF);
  fileIx := S_SevenZip.GetIndexByFilename(fn, @fileSz);
  result := true;
end;

procedure ReadFileContent(aFileName: WideString; var rBuffer: AnsiString);
var
  dFile: TFileStream;
  dSize, indexOfFile: Integer;
begin
  rBuffer := '';
  dFile := nil;
  if not ParseArchived(aFileName, indexOfFile, dSize) then begin
    try
      dFile := TFileStream.Create(aFileName, fmOpenRead);
      dSize := dFile.Size;

      if dSize > 0 then begin
        SetLength(rBuffer, dSize);
        dFile.ReadBuffer(rBuffer[1], dSize);
      end;

    finally
      dFile.Free;
    end;
  end //если несжатый
  else begin
    if dSize < 0 then raise Exception.CreateFmt('Не найден в архиве: %s', [aFileName]);
    SetLength(rBuffer, dSize);
    S_SevenZip.ExtracttoMem(indexofFile, Pointer(rBuffer), dSize);
    if S_SevenZip.ErrCode <> 0 then begin
      if (S_SevenZip.mPasswordProtected) and (S_SevenZip.ErrCode=2) then begin
      aFileName := Copy(GetArchiveFromSpecial(aFileName), 2, $FFFF);
      raise TBQPasswordException.CreateFmt(S_SevenZip.Password, aFileName, '#1%s', [aFileName]);
      end
      else abort;
    end;
  end;

end;

function IsContentUnicode(var aBuffer: AnsiString): Boolean;
begin
  Result :=
    (Length(aBuffer) >= 2) and (
    (aBuffer[1] = #255) and (aBuffer[2] = #254)
    ) or (
    (aBuffer[1] = #254) and (aBuffer[2] = #255)
    );
end;

procedure ReadUtf16ContentToStrings(var aBuffer: AnsiString; var rStrings: TWideStrings);
var
  dPos: Integer;
  dLength: Integer;
  dCurString: WideString;
  dCurLength: Integer;
  dChar: WideChar;
  dIsMSL: Boolean; //True: Most Significal Last order.
  dPrevCR: Boolean;
begin
  dPos := 1;
  dLength := Length(aBuffer);
  if (dLength mod 2) <> 0 then
    dLength := dLength - 1;

  if rStrings = nil then
    rStrings := TWideStringList.Create
  else
    rStrings.Clear;

  if (dLength >= 2) and (aBuffer[1] = #255) and (aBuffer[2] = #254) then begin
    dPos := 3;
    dIsMSL := true;
  end else
    if (dLength >= 2) and (aBuffer[1] = #254) and (aBuffer[2] = #255) then begin
    dPos := 3;
    dIsMSL := false;
  end else begin
    dIsMSL := true;
  end;

  dCurLength := 0;
  SetLength(dCurString, 1024);
  dPrevCR := false;

  while dPos + 1 <= dLength do begin
    if dIsMSL then
      dChar := WideChar(Integer(aBuffer[dPos]) + 256 * Integer(aBuffer[dPos + 1]))
    else
      dChar := WideChar(Integer(aBuffer[dPos + 1]) + 256 * Integer(aBuffer[dPos]));

    if (dChar = #13) or ((dChar = #10) and not dPrevCR) then begin
      rStrings.Add(Copy(dCurString, 1, dCurLength));
      dCurLength := 0;
      dPrevCR := (dChar = #13);
    end else
      if dChar = #10 {and dPrevCR, всегда} then begin
      dPrevCR := false;
    end else begin
      dCurLength := dCurLength + 1;
      if dCurLength > Length(dCurString) then
        SetLength(dCurString, 2 * Length(dCurString));
      dCurString[dCurLength] := dChar;
      dPrevCR := false;
    end;

    dPos := dPos + 2;

  end;

  if dCurLength <> 0 then
    rStrings.Add(Copy(dCurString, 1, dCurLength));

end;

procedure ReadWCharContentToStrings(var aBuffer: WideString; var rStrings: TWideStrings);
var
  dPos: Integer;
  dLength: Integer;
  dCurString: WideString;
  dCurLength: Integer;
  dChar: WideChar;
  dPrevCR: Boolean;
begin
  dPos := 1;
  dLength := Length(aBuffer);

  if rStrings = nil then
    rStrings := TWideStringList.Create
  else
    rStrings.Clear;

  dCurLength := 0;
  dCurString := '';
  SetLength(dCurString, 1024);
  dPrevCR := false;

  while dPos <= dLength do begin
    dChar := aBuffer[dPos];

    if (dChar = #13) or ((dChar = #10) and not dPrevCR) then begin
      rStrings.Add(Copy(dCurString, 1, dCurLength));
      dCurLength := 0;
      dPrevCR := (dChar = #13);
    end else
      if dChar = #10 {and dPrevCR, всегда} then begin
      dPrevCR := false;
    end else begin
      dCurLength := dCurLength + 1;
      if dCurLength > Length(dCurString) then
        SetLength(dCurString, 2 * Length(dCurString));
      dCurString[dCurLength] := dChar;
      dPrevCR := false;
    end;

    dPos := dPos + 1;

  end;

  if dCurLength <> 0 then
    rStrings.Add(Copy(dCurString, 1, dCurLength));

end;

procedure ChangeByteOrderInWideString(var aString: WideString);
var
  dPtr: PAnsiChar;
  dCount: Integer;
  i: Integer;
  dTemp: AnsiChar;
begin
  dCount := Length(aString);
  if dCount = 0 then
    Exit;

  dPtr := PAnsiChar(@(aString[1]));
  for i := 1 to dCount do begin
    dTemp := dPtr[1];
    dPtr[1] := dPtr[2];
    dPtr[2] := dTemp;
    Inc(dPtr, 2);
  end;

end;

procedure ChangeByteOrderInWideStringIfNeed(var aString: WideString);
begin
  if Length(aString) >= 1 then
    if Integer(aString[1]) = $FFFE then
      ChangeByteOrderInWideString(aString);
end;

function GetLexem(var aBuffer: AnsiString; var rPos: Integer): AnsiString;
var
  dLength: Integer;
  dChar: AnsiChar;
  dBeginPos: Integer;
begin
  dLength := Length(aBuffer);
  Result := '';

  while (rPos <= dLength) and (aBuffer[rPos] in [' ', #9]) do
    rPos := rPos + 1;

  if rPos > {=} dLength then //AlekId:!!BUG!!
    Exit;

  dBeginPos := rPos;

  dChar := aBuffer[rPos];
  if dChar in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-', '+'] then begin
    rPos := rPos + 1;

    while (rPos <= dLength) and
      (aBuffer[rPos] in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-', '+', '.', '%']) do
      rPos := rPos + 1;

  end else
    if dChar in ['''', '"'] then begin
    rPos := rPos + 1;

    while (rPos <= dLength) and (aBuffer[rPos] <> dChar) do
      rPos := rPos + 1;

    if rPos <= dLength then
      rPos := rPos + 1;

  end else begin
    rPos := rPos + 1;

  end;

  Result := Copy(aBuffer, dBeginPos, rPos - dBeginPos);

end;

function GetEncodingByName(const aName: WideString): Integer;
var
  dName: WideString;
begin
  dName := WideLowerCase(aName);

    if dName = 'windows-1251' then Result := 1251 else
    if dName = 'windows-1252' then Result := 1252 else
    if dName = 'windows-1253' then Result := 1253 else
    if dName = 'utf-8' then Result := CP_UTF8 else
    if dName = 'utf-16' then Result := cEncUnicode else
    if dName = 'windows-1250' then Result := 1250 else
    if dName = 'dos-866' then Result := 866 else
    if dName = 'koi8-r' then Result := 20866 else
    if dName = 'koi8-u' then Result := 21866 else
    if dName = 'iso-8859-1' then Result := 28591 else
    if dName = 'iso-8859-2' then Result := 28592 else
    if dName = 'iso-8859-3' then Result := 28593 else
    if dName = 'iso-8859-4' then Result := 28594 else
    if dName = 'iso-8859-5' then Result := 28595 else
    if dName = 'iso-8859-6' then Result := 28596 else
    if dName = 'iso-8859-7' then Result := 28597 else
    if dName = 'iso-8859-8' then Result := 28598 else
    if dName = 'iso-8859-9' then Result := 28599 else
    if dName = 'iso-8859-15' then Result := 28605 else
    Result := -1;

end;

function GetNameOfEncoding(aEncoding: Integer): WideSTring;
begin
  case aEncoding of
    1251: Result := 'windows-1251';
    1250: Result := 'windows-1250';
    1252: Result := 'windows-1252';
    1253: Result := 'windows-1253';
    CP_UTF8: Result := 'utf-8';
    cEncUnicode: Result := 'utf-16';
    20866: Result := 'koi8-r';
    21866: Result := 'koi8-u';
    28591: Result := 'iso-8859-1';
    28592: Result := 'iso-8859-2';
    28593: Result := 'iso-8859-3';
    28594: Result := 'iso-8859-4';
    28595: Result := 'iso-8859-5';
    28596: Result := 'iso-8859-6';
    28597: Result := 'iso-8859-7';
    28598: Result := 'iso-8859-8';
    28599: Result := 'iso-8859-9';
    28605: Result := 'iso-8859-15';
  else Result := '';
  end;

end;

function GetEncodingByWinCharSet(aCharSet: Integer): Integer;
begin
  Result := cRussianCodePage;

  case aCharSet of
    EASTEUROPE_CHARSET: Result := 1250;
    ANSI_CHARSET: Result := 1251;
    1: Result := 1251;
    RUSSIAN_CHARSET: Result := 1251;
    201: Result := 1252;
    GREEK_CHARSET: Result := 1253;
    TURKISH_CHARSET: Result := 1254;
    HEBREW_CHARSET: Result := 1255;
    ARABIC_CHARSET: Result := 1256;
    BALTIC_CHARSET: Result := 1257;
    VIETNAMESE_CHARSET: Result := 1258;
    239: Result := 1252;
    SHIFTJIS_CHARSET: Result := 932;
    HANGEUL_CHARSET: Result := 949;
    GB2312_CHARSET: Result := 936;
    CHINESEBIG5_CHARSET: Result := 950;
    THAI_CHARSET: Result := 874;
    JOHAB_CHARSET: Result := 1361;
    OEM_CHARSET: Result := 866;
  end;

end;

function IntMultiByteToWideChar(
  CodePage: UINT; dwFlags: DWORD;
  const lpMultiByteStr: LPCSTR; cchMultiByte: Integer;
  lpWideCharStr: LPWSTR; cchWideChar: Integer
  ): Integer;
var
  i: Integer;
begin
  if CodePage = 1252 then begin // Хак от традиционных для русских ОС редиректов 1252 -> 1251
    if cchMultiByte = -1 then
      cchMultiByte := Length(lpMultiByteStr);

    if lpWideCharStr = nil then begin
      Result := cchMultiByte;
      Exit;
    end;

    if cchWideChar < cchMultiByte then
      cchMultiByte := cchWideChar;

    for i := 0 to cchMultiByte - 1 do begin
      lpWideCharStr[i] := WideChar(Integer(lpMultiByteStr[i]));
    end;

    Result := cchMultiByte;

  end else begin
    Result := Windows.MultiByteToWideChar(CodePage, dwFlags, lpMultiByteStr, cchMultiByte, lpWideCharStr, cchWideChar);
  end;
end;

function IntWideCharToMultiByte(
  CodePage: UINT; dwFlags: DWORD;
  lpWideCharStr: LPWSTR; cchWideChar: Integer;
  lpMultiByteStr: LPSTR; cchMultiByte: Integer;
  lpDefaultChar: LPCSTR; lpUsedDefaultChar: PBOOL
  ): Integer;
begin
  // Заглушка
  Result := 0;
end;

procedure ConvertFromByteToWideChar(const aABuffer: AnsiString; aEncoding: Integer; var rWBuffer: WideString; aABufferLength: Integer = -1);
var
  dResLength: Integer;
begin
  if aABufferLength = -1 then
    aABufferLength := Length(aABuffer);

  dResLength := IntMultiByteToWideChar(
    aEncoding,
    0,
    PChar(aABuffer),
    aABufferLength,
    nil,
    0
    );

  if dResLength > 0 then begin
    SetLength(rWBuffer, dResLength);
    IntMultiByteToWideChar(
      aEncoding,
      0,
      PChar(aABuffer),
      aABufferLength,
      PWideChar(rWBuffer),
      dResLength
      );
  end else begin
    rWBuffer := '';
  end;

end;

procedure ConvertFromWideCharToByte(const aWBuffer: WideString; aEncoding: Integer; var rABuffer: AnsiString; aWBufferLength: Integer = -1);
var
  dResLength: Integer;
begin
  if aWBufferLength = -1 then
    aWBufferLength := Length(aWBuffer);

  dResLength := Windows.WideCharToMultiByte(
    aEncoding,
    0,
    PWideChar(aWBuffer),
    aWBufferLength,
    nil,
    0,
    nil,
    nil
    );

  if dResLength > 0 then begin
    SetLength(rABuffer, dResLength);
    Windows.WideCharToMultiByte(
      aEncoding,
      0,
      PWideChar(aWBuffer),
      aWBufferLength,
      PChar(rABuffer),
      Length(rABuffer),
      nil,
      nil
      );
  end else begin
    rABuffer := '';
  end;

end;

// Возвращает codepage и границы кодировочного метатэга.
// Код жадноватый, но рефакторить лень.

function FindContentTypeMetatag(
  const aBuffer: AnsiString;
  out rBeginPos: Integer;
  out rLength: Integer
  ): Integer; overload;
var
  dHeaderEndPos: Integer;
  dPos: Integer;
  dPos2: Integer;
  dLCBuffer: AnsiString;
  dLength: Integer;
  dLexem: AnsiString;
  dResBeginPos: Integer;
  dResLength: Integer;

  dContentTypeValue: AnsiString;
  dCharSet: AnsiString;

label
  SkipThisTag;

begin
  Result := -1;
  rBeginPos := 0;
  rLength := 0;
  dResBeginPos := 0;
  dResLength := 0;

  { Ограничиваем зону поиска метатэгов заголовком.
  После заголовка могут быть довольно сложные структуры,
  простой парсер с ними не справится.
  }

  dHeaderEndPos := PosCIL('</head>', aBuffer);
  if dHeaderEndPos <= 0 then
    dHeaderEndPos := Pos('<body>', aBuffer);
  if dHeaderEndPos <= 0 then
    Exit;

  dLCBuffer := Copy(aBuffer, 1, dHeaderEndPos - 1);

  { Отыскиваем тэг <meta http-equiv="Content-Type" content="...">,
    получаем значение content.
  }

  dContentTypeValue := '';
  dPos := 1;
  dLength := Length(dLCBuffer);

  while dPos <= dLength do begin
    dPos2 := PosEx('<meta ', dLCBuffer, dPos);
    if dPos2 <= 0 then
      dPos2 := PosEx('<meta'#9, dLCBuffer, dPos);

    if dPos2 <= 0 then begin
      dPos := dLength + 1;
      Break;
    end;

    dResBeginPos := dPos2;
    dPos := dPos2 + 6; // Length ('<meta ')

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem <> 'http-equiv' then goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem <> '=' then goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if (dLexem <> '''content-type''') and
      (dLexem <> '"content-type"') and
      (dLexem <> 'content-type') then goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem <> 'content' then goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem <> '=' then goto SkipThisTag;

    dLexem := GetLexem(dLCBuffer, dPos);
    if dLexem = '' then goto SkipThisTag;
    if (dLexem[1] <> '''') and (dLexem[1] <> '"') then goto SkipThisTag;
    if dLexem[Length(dLexem)] <> dLexem[1] then goto SkipThisTag;

    dContentTypeValue := Copy(dLexem, 2, Length(dLexem) - 2);

    while (dPos <= dLength) and (dLexem <> '') and (dLexem <> '>') do
      dLexem := GetLexem(dLCBuffer, dPos);

    if dLexem <> '>' then
      Exit;

    dResLength := dPos - dResBeginPos;

    Break;

    SkipThisTag:
    while (dPos <= dLength) and (dLexem <> '') and (dLexem <> '>') do
      dLexem := GetLexem(dLCBuffer, dPos);

  end;

  if dContentTypeValue = '' then
    Exit;

  // Разбираем значение Content-Type, выделяя из него charset.

  dPos := 1;
  dLength := Length(dContentTypeValue);
  dCharSet := '';

  while (dPos <= dLength) do begin
    dLexem := GetLexem(dContentTypeValue, dPos);
    if dLexem <> 'charset' then Continue;

    dLexem := GetLexem(dContentTypeValue, dPos);
    if dLexem <> '=' then Break;

    dLexem := GetLexem(dContentTypeValue, dPos);
    if dLexem = '' then Break;

    dCharSet := dLexem;
    Break;

  end;

  if dCharSet = '' then
    Exit;

  Result := GetEncodingByName(dCharSet);
  rBeginPos := dResBeginPos;
  rLength := dResLength;

end;

function FindContentTypeMetatag(
  const aBuffer: WideString;
  out rBeginPos: Integer;
  out rLength: Integer
  ): Integer; overload;
var
  dHeaderEndPos: Integer;
  dHeader: AnsiString;

begin
  Result := -1;
  rBeginPos := 0;
  rLength := 0;

  { Ограничиваем зону поиска метатэгов заголовком.
  После заголовка могут быть довольно сложные структуры,
  простой парсер с ними не справится.
  }

  dHeaderEndPos := PosCIL('</head>', aBuffer);
  if dHeaderEndPos <= 0 then
    dHeaderEndPos := Pos('<body>', aBuffer);
  if dHeaderEndPos <= 0 then
    Exit;

  { Для дальнейшего парсинга важна только латинская часть,
    так что можно не заботиться, к какой кодировке
    будет приведена строка при преобразовании.
  }

  dHeader := Copy(aBuffer, 1, dHeaderEndPos - 1);
  Result := FindContentTypeMetatag(dHeader, rBeginPos, rLength);

end;

function ReadEncodingMetatag(const aBuffer: AnsiString): Integer;
var
  dTempBeginPos: Integer;
  dTempLength: Integer;
begin
  Result := FindContentTypeMetatag(aBuffer, dTempBeginPos, dTempLength);
end;

procedure WriteEncodingMetatagToHtml(var aBuffer: WideString; aEncoding: Integer);
var
  dBeginPos: Integer;
  dLength: Integer;
  dMetatag: WideString;
begin
  dMetatag := GetNameOfEncoding(aEncoding);
  if dMetatag = '' then Exit; // Unknown encoding
  dMetatag := '<meta http-equiv="Content-Type" content="text/html; charset=' +
    dMetatag +
    '">';

  FindContentTypeMetatag(aBuffer, dBeginPos, dLength);
  if dBeginPos <> 0 then begin
    // Есть метатэг. Меняем его на наш.
    aBuffer := Copy(aBuffer, 1, dBeginPos - 1) +
      dMetatag +
      Copy(aBuffer, dBeginPos + dLength, Length(aBuffer));

  end else begin
    dBeginPos := PosCIL('<head>', aBuffer);
    if dBeginPos <> 0 then begin
      // Нет метатэга, но есть <head>. Вставляем после него наш метатэг.
      aBuffer := Copy(aBuffer, 1, dBeginPos + 6 {Length ('<head>')} - 1) + #13#10 +
        dMetatag + #13#10 +
        Copy(aBuffer, dBeginPos + 6, Length(aBuffer));

    end else begin
      dBeginPos := PosCIL('<html>', aBuffer);
      if dBeginPos <> 0 then begin
        // Нет метатэга, нет <head>, но есть <html>.
        // Вставляем после него <head> и наш метатэг.

        aBuffer := Copy(aBuffer, 1, dBeginPos + 6 {Length ('<html>')} - 1) + #13#10 +
          '<head>' + dMetatag + '</head>' + #13#10 +
          Copy(aBuffer, dBeginPos + 6, Length(aBuffer));

      end else begin
        // Вообще ничего нет.

        aBuffer := '<html>' + #13#10 +
          '<head>' + #13#10 +
          dMetatag + #13#10 +
          '</head>' + #13#10 +
          '<body>' + #13#10 +
          aBuffer + #13#10 +
          '</body>' + #13#10 +
          '</html>';

      end;
    end;
  end;

end;

function IsContainsNonRussianChars(const aString: WideString): Boolean; overload;
var
  dLength: Integer;
  i: Integer;
begin
  dLength := Length(aString);
  for i := 1 to dLength do begin
    if aString[i] <> #0 then begin
      if fUnicodeToRussianXLAT[Integer(aString[i])] = #0 then begin
        Result := true;
        Exit;
      end;
    end;
  end;

  Result := false;

end;

function IsContainsNonRussianChars(aStrings: TWideStrings): Boolean; overload;
var
  dCount: Integer;
  i: Integer;
begin
  dCount := aStrings.Count;
  for i := 0 to dCount - 1 do begin
    if IsContainsNonRussianChars(aStrings.Strings[i]) then begin
      Result := true;
      Exit;
    end;
  end;

  Result := false;

end;

function ReadEncodingFromDictFile(aFile: TFileStream): Integer;
const
  cEncTagBeginning: AnsiString = '<!-- #enc="';
var
  dBuffer: AnsiString;
  dBufferLength: Integer;
  dPos: Integer;
  dCharSet: AnsiString;
begin
  Result := -1;

  SetLength(dBuffer, 128);
  aFile.Seek(0, soFromBeginning);
  dBufferLength := aFile.Read(dBuffer[1], 128);
  SetLength(dBuffer, dBufferLength);

  if dBufferLength < 2 then
    Exit;

  if (dBuffer[1] = #255) and (dBuffer[2] = #254) then begin
    Result := cEncUnicode;
    Exit;
  end else
    if (dBuffer[1] = #254) and (dBuffer[2] = #255) then begin
    Result := cEncUnicode_BigEndian;
    Exit;
  end;

  dBuffer := WideLowerCase(dBuffer);
  dPos := Pos(cEncTagBeginning, dBuffer);
  if dPos <= 0 then
    Exit;

  dPos := dPos + Length(cEncTagBeginning);
  dCharSet := '';

  while (dPos <= dBufferLength) and (dBuffer[dPos] <> '"') do begin
    dCharSet := dCharSet + dBuffer[dPos];
    dPos := dPos + 1;
  end;

  if dPos > dBufferLength then
    Exit;

  Result := GetEncodingByName(dCharSet);

end;

function WChar_ReadHtmlFile(const aFileName: WideString; aDefaultByteEncoding: Integer): TWideStrings;
var
  dRes: TWideStrings;
  dSuccess: Boolean;
begin
  dSuccess := false;

  try
    dRes := TWideStringList.Create;
    WChar_ReadHtmlFileTo(aFileName, dRes, aDefaultByteEncoding);
    Result := dRes;

    dSuccess := true;

  finally
    if not dSuccess then
      dRes.Free;
  end;

end;

procedure WChar_ReadHtmlFileTo(const aFileName: WideString; var rResult: TWideStrings; aDefaultByteEncoding: Integer); overload;
var
  dBuffer: AnsiString;
  dEncoding: Integer;
  dWBuffer: WideString;
begin
  if rResult = nil then
    rResult := TWideStringList.Create
  else
    rResult.Clear;

  ReadFileContent(aFileName, dBuffer);

  if IsContentUnicode(dBuffer) then begin
    ReadUtf16ContentToStrings(dBuffer, rResult);

  end else begin
    dEncoding := ReadEncodingMetatag(dBuffer);
    if dEncoding = -1 then
      dEncoding := aDefaultByteEncoding;

    ConvertFromByteToWideChar(dBuffer, dEncoding, dWBuffer);
    ReadWCharContentToStrings(dWBuffer, rResult);

  end;

end;

procedure WChar_ReadHtmlFileTo(const aFileName: WideString; var rResult: WideString; aDefaultByteEncoding: Integer); overload;
var
  dBuffer: AnsiString;
  dEncoding: Integer;
begin
  rResult := '';

  ReadFileContent(aFileName, dBuffer);

  if IsContentUnicode(dBuffer) then begin
    if Length(dBuffer) < 4 then
      Exit;

    SetLength(rResult, Length(dBuffer) div 2 - 1);
    CopyMemory(@(rResult[1]), @(dBuffer[3]), Length(rResult) * 2);

  end else begin
    dEncoding := ReadEncodingMetatag(dBuffer);
    if dEncoding = -1 then
      dEncoding := aDefaultByteEncoding;

    ConvertFromByteToWideChar(dBuffer, dEncoding, rResult);

  end;

end;

function WChar_ReadTextFileToTWideStrings(const aFileName: WideString; aDefaultByteEncoding: Integer): TWideStrings;
var
  dBuffer: AnsiString;
  dRes: TWideStrings;
  dWBuffer: WideString;
begin
  dBuffer := '';
  ReadFileContent(aFileName, dBuffer);
  dRes := TWideStringList.Create;

  if IsContentUnicode(dBuffer) then begin
    ReadUtf16ContentToStrings(dBuffer, dRes);
  end else begin
    ConvertFromByteToWideChar(dBuffer, aDefaultByteEncoding, dWBuffer);
    ReadWCharContentToStrings(dWBuffer, dRes);
  end;

  Result := dRes;

end;

function WChar_ReadTextFileToWideString(const aFileName: WideString; aDefaultByteEncoding: Integer): WideString;
var
  dBuffer: AnsiString;
begin
  dBuffer := '';
  Result := '';
  ReadFileContent(aFileName, dBuffer);

  if IsContentUnicode(dBuffer) then begin
    if Length(dBuffer) < 4 then
      Exit;

    SetLength(Result, Length(dBuffer) div 2 - 1);
    CopyMemory(@(Result[1]), @(dBuffer[3]), Length(Result) * 2);

  end else begin
    ConvertFromByteToWideChar(dBuffer, aDefaultByteEncoding, Result);
  end;

end;

procedure WChar_WriteTextFile(const aFileName: WideString; aContent: TWideStrings); overload;
var
  dFile: TFileStream;
  dCount: Integer;
  i: Integer;

  dWString: WideString;
  dWEol: WideString;

  dAString: AnsiString;
  dAEol: AnsiString;

begin
  dFile := nil;

  try
    dFile := TFileStream.Create(aFileName, fmCreate);

    if IsContainsNonRussianChars(aContent) then begin
      // Writing in UTF-16 format.

      dAEol := #255#254;
      dFile.WriteBuffer(dAEol[1], 2);

      dWEol := #13#10;
      dCount := aContent.Count;

      for i := 0 to dCount - 1 do begin
        dWString := aContent.Strings[i];
        dFile.WriteBuffer(dWString[1], Length(dWString) * 2);
        if i <> dCount - 1 then
          dFile.WriteBuffer(dWEol[1], Length(dWEol) * 2);
      end;

    end else begin
      // Writing in ANSI format.

      dAEol := #13#10;
      dCount := aContent.Count;

      for i := 0 to dCount - 1 do begin
        dAString := aContent.Strings[i];
        dFile.WriteBuffer(dAString[1], Length(dAString));
        if i <> dCount - 1 then
          dFile.WriteBuffer(dAEol[1], Length(dAEol));
      end;

    end;

  finally
    dFile.Free;
  end;
end;

procedure WChar_WriteTextFile(const aFileName: WideString; const aContent: WideString); overload;
var
  dFile: TFileStream;
  dAString: AnsiString;

begin
  dFile := nil;

  try
    dFile := TFileStream.Create(aFileName, fmCreate);

    if IsContainsNonRussianChars(aContent) then begin
      // Writing in UTF-16 format.

      dAString := #255#254;
      dFile.WriteBuffer(dAString[1], 2);

      dFile.WriteBuffer(aContent[1], Length(aContent) * 2);

    end else begin
      // Writing in ANSI format.

      ConvertFromWideCharToByte(aContent, cRussianCodePage, dAString);
      dFile.WriteBuffer(dAString[1], Length(dAString));

    end;

  finally
    dFile.Free;
  end;
end;

procedure WChar_WriteHtmlFile(const aFileName: WideString; const aContent: WideString);
var
  dWContent: WideString;
  dAContent: AnsiString;
  dEncoding: Integer;
  dFile: TFileStream;

begin
  if IsContainsNonRussianChars(aContent) then
    dEncoding := CP_UTF8
  else
    dEncoding := cRussianCodePage;

  dWContent := aContent;
  WriteEncodingMetatagToHtml(dWContent, dEncoding);
  ConvertFromWideCharToByte(dWContent, dEncoding, dAContent);

  dFile := nil;
  try
    dFile := TFileStream.Create(aFileName, fmCreate);
    dFile.WriteBuffer(dAContent[1], Length(dAContent));
  finally
    dFile.Free;
  end;

end;

function WChar_ReadDictFragment(const aFileName: WideString; aOffset: Integer; aCount: Integer; aDefaultByteEncoding: Integer): WideString;
var
  dFile: TFileStream;
  dEncoding: Integer;
  dRes: WideString;
  dResLength: Integer;
  dReadedCount: Integer;
  dABuffer: AnsiString;
begin
  Result := '';
  dFile := nil;

  if aCount <= 0 then
    Exit;

  try
    dFile := TFileStream.Create(aFileName, fmOpenRead);
    if aOffset >= dFile.Size then
      Exit;

    dEncoding := ReadEncodingFromDictFile(dFile);
    dFile.Seek(aOffset, soFromBeginning);

    if dEncoding = -1 then
      dEncoding := aDefaultByteEncoding;

    if (dEncoding = cEncUnicode) or (dEncoding = cEncUnicode_BigEndian) then begin
      dResLength := aCount div 2;
      SetLength(dRes, dResLength);

      dReadedCount := dFile.Read(dRes[1], dResLength * 2);
      SetLength(dRes, dReadedCount div 2);

      if dEncoding = cEncUnicode_BigEndian then
        ChangeByteOrderInWideString(dRes);

    end else begin
      SetLength(dABuffer, aCount);
      dReadedCount := dFile.Read(dABuffer[1], aCount);
      if Length(dABuffer) <> dReadedCount then
        SetLength(dABuffer, dReadedCount);

      ConvertFromByteToWideChar(dABuffer, dEncoding, dRes);

    end;

    Result := dRes;

  finally
    dFile.Free;
  end;
end;

function LoadBibleqtIniFileEncoding(
  const aFileName: WideString;
  aDefault: Integer
  ): Integer;
var
  dLines: TWideStrings;
  i: Integer;
  dName: WideString;
  dValue: WideString;
begin
  dLines := WChar_ReadTextFileToTWideStrings(aFileName);
  Result := aDefault;

  try
    for i := 0 to dLines.Count - 1 do begin
      dName := IniStringFirstPart(dLines[i]);
      dValue := IniStringSecondPart(dLines[i]);

      if dValue = '' then Continue;

      if dValue = 'DefaultEncoding' then begin
        Result := GetEncodingByName(dValue);
        if Result = -1 then
          Result := aDefault;

        Exit;

      end else
        if dName = 'DesiredFontCharset' then begin
        Result := StrToInt(dValue);
        Result := GetEncodingByWinCharSet(Result);
        if Result <= 0 then
          Result := aDefault;

        Exit;

      end;

    end;

  finally
    dLines.Free;

  end;

end;

procedure InitializeXLAT;
var
  dABuffer: AnsiString;
  dWBuffer: WideString;
  i: Integer;
begin
  for i := 0 to 65535 do
    fUnicodeToRussianXLAT[i] := #0;

  SetLength(dABuffer, 255);
  for i := 1 to 255 do
    dABuffer[i] := AnsiChar(i);

  ConvertFromByteToWideChar(dABuffer, cRussianCodePage, dWBuffer);
  for i := 1 to 255 do begin
    fUnicodeToRussianXLAT[Integer(dWBuffer[i])] := AnsiChar(i);
  end;

end;

function TextFromFile(filename: WideString): WideString;
var
  lines: TWideStrings;
begin
  try
    lines := WChar_ReadTextFileToTWideStrings(filename);
    Result := lines.Text;
    lines.Free;
  except
    Result := '';
  end;
end;

initialization
  InitializeXLAT;

end.

