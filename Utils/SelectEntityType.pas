unit SelectEntityType;

interface

type

  TDictTypes = (
    dtNone,
    dtNative,
    dtMyBible);

  TInfoSourceTypes = (
    isNone,
    isNative,
    isMyBible);

  TSelectEntityType = class
  protected
    class function IsNativeFileEntry(aFileEntryPath: String): Boolean;
    class function IsNativeInfoSource(aFileEntryPath: String): Boolean;
  public
    class function IsMyBibleFileEntry(aFileEntryPath: String): Boolean;
    class function IsMyBibleDictionary(aFileEntryPath: String): Boolean;
    class function IsMyBibleBible(aFileEntryPath: String): Boolean;
    class function IsMyBibleCommentary(aFileEntryPath: String): Boolean;

    class function SelectDictType(aFileEntryPath: String): TDictTypes;
    class function SelectInfoSourceType(aFileEntryPath: String): TInfoSourceTypes;
    class function FormNativeInfoPath(aFileEntryPath: String): String;
  end;

implementation

uses SysUtils, RegularExpressions, IOUtils;

class function TSelectEntityType.FormNativeInfoPath(aFileEntryPath: String): String;
const
  NATIVE_INFO_FILE = 'bibleqt.ini';
begin
  if FileExists(aFileEntryPath) and
     (CompareStr(ExtractFileName(aFileEntryPath), NATIVE_INFO_FILE) = 0) then
  begin
    Result := aFileEntryPath;
    exit;
  end;

  Result := TPath.Combine(aFileEntryPath, NATIVE_INFO_FILE);
end;

class function TSelectEntityType.IsMyBibleBible(
  aFileEntryPath: String): Boolean;
begin
  Result := TRegEx.IsMatch(aFileEntryPath.ToLower(), '^[^\.]*(\.sqlite3)?$')
end;

class function TSelectEntityType.IsMyBibleCommentary(
  aFileEntryPath: String): Boolean;
begin
  Result := TRegEx.IsMatch(aFileEntryPath.ToLower(), '^.*\.commentaries(\.sqlite3)?$')
end;

class function TSelectEntityType.IsMyBibleDictionary(
  aFileEntryPath: String): Boolean;
begin
  Result := TRegEx.IsMatch(aFileEntryPath.ToLower(), '^.*\.dictionary(\.sqlite3)?$')
end;

class function TSelectEntityType.IsMyBibleFileEntry(
  aFileEntryPath: String): Boolean;
begin
  Result := FileExists(aFileEntryPath) and (
      IsMyBibleDictionary(aFileEntryPath)
      or IsMyBibleCommentary(aFileEntryPath)
      or IsMyBibleBible(aFileEntryPath)
    );
end;

class function TSelectEntityType.IsNativeFileEntry(
  aFileEntryPath: String): Boolean;
begin
  Result :=
    DirectoryExists(aFileEntryPath) and
    (Length(TDirectory.GetFiles(aFileEntryPath, '*.idx')) > 0);
end;

class function TSelectEntityType.IsNativeInfoSource(
  aFileEntryPath: String): Boolean;
var
  EndPos: integer;
begin
  // check if module is archive
  if (aFileEntryPath.StartsWith('?')) then
  begin
    EndPos := Pos('??', aFileEntryPath);
    if (EndPos <= 0) then
      raise Exception.Create('Invalid archive path: ' + aFileEntryPath);

    Result := FileExists(Copy(aFileEntryPath, 2, EndPos - 2));
    Exit;
  end;

  Result := FileExists(FormNativeInfoPath(aFileEntryPath));
end;

class function TSelectEntityType.SelectDictType(aFileEntryPath: String): TDictTypes;
begin

  if IsMyBibleFileEntry(aFileEntryPath) then
  begin
    Result := dtMyBible;
    exit;
  end;

  if IsNativeFileEntry(aFileEntryPath) then
  begin
    Result := dtNative;
    exit;
  end;

  Result := dtNone;

end;

class function TSelectEntityType.SelectInfoSourceType(aFileEntryPath: String): TInfoSourceTypes;
begin
  if IsNativeInfoSource(aFileEntryPath) then
  begin
    Result := isNative;
    exit;
  end;

  if IsMyBibleFileEntry(aFileEntryPath) then
  begin
    Result := isMyBible;
    exit;
  end;

  Result := isNone;
end;


end.
