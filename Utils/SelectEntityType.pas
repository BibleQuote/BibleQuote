unit SelectEntityType;

interface

type

  TDictTypes = (
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
    class function IsMyBibleFileEntry(aFileEntryPath: String): Boolean;
  public
    class function SelectDictType(aFileEntryPath: String): TDictTypes;
    class function SelectInfoSourceType(aFileEntryPath: String): TInfoSourceTypes;
    class function FormBibleqtIniPath(aFileEntryPath: String): String;
  end;

implementation

uses SysUtils, RegularExpressions, IOUtils;

class function TSelectEntityType.FormBibleqtIniPath(aFileEntryPath: String): String;
var
  BibleqtIniPath: String;
begin
  BibleqtIniPath := aFileEntryPath;

  if DirectoryExists(BibleqtIniPath) then
    BibleqtIniPath := TPath.Combine(aFileEntryPath, 'bibleqt.ini');

  Result := BibleqtIniPath;
end;

class function TSelectEntityType.IsMyBibleFileEntry(
  aFileEntryPath: String): Boolean;
begin
  Result := FileExists(aFileEntryPath) and TRegEx.IsMatch(aFileEntryPath.ToLower(), '^.*\.dictionary\.sqlite3$')
end;

class function TSelectEntityType.IsNativeFileEntry(
  aFileEntryPath: String): Boolean;
begin
  Result := DirectoryExists(aFileEntryPath);
end;

class function TSelectEntityType.IsNativeInfoSource(
  aFileEntryPath: String): Boolean;
begin
  Result := FileExists(FormBibleqtIniPath(aFileEntryPath));
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

  raise Exception.Create('Missing type of file entry: '+aFileEntryPath);

end;

class function TSelectEntityType.SelectInfoSourceType(aFileEntryPath: String): TInfoSourceTypes;
begin

  if IsMyBibleFileEntry(aFileEntryPath) then
  begin
    Result := isMyBible;
    exit;
  end;

  if IsNativeInfoSource(aFileEntryPath) then
  begin
    Result := isNative;
    exit;
  end;

  Result := isNone;

end;


end.
