unit StrongsConcordance;

interface

uses Windows, Classes, SysUtils, IOUtils, IOProcs, Dict, AppPaths, StrUtils,
     SyncObjs;

type
  TStrongsConcordance = class
  private
    FStrongHebrew, FStrongGreek: TDict;
    FLock: TCriticalSection;
    FHebrewLoaded, FGreekLoaded: boolean;
    function InitializeDictionary(dict: TDict; idxFilename: string; htmFilename: string): boolean;
  public
    constructor Create;
    destructor Destroy(); override;

    function Initialize: boolean;
    function EnsureStrongHebrewLoaded(): boolean;
    function EnsureStrongGreekLoaded(): boolean;
    function GetStrongWordByIndex(ix: Integer): string;
    function GetTotalWords(): integer;
    function Lookup(stext: string): string;

    property Hebrew: TDict read FStrongHebrew;
    property Greek: TDict read FStrongGreek;
    property TotalWords: integer read GetTotalWords;
  end;

implementation

constructor TStrongsConcordance.Create;
begin
  inherited Create;

  FLock := TCriticalSection.Create;

  FStrongHebrew := TDict.Create;
  FStrongGreek := TDict.Create;
end;

destructor TStrongsConcordance.Destroy;
begin
  FreeAndNil(FLock);
  FreeAndNil(FStrongHebrew);
  FreeAndNil(FStrongGreek);

  inherited;
end;

function TStrongsConcordance.Initialize: boolean;
begin
  inherited Create;
  Result := EnsureStrongHebrewLoaded() and EnsureStrongGreekLoaded();
end;

function TStrongsConcordance.EnsureStrongHebrewLoaded(): boolean;
begin
  if not FHebrewLoaded then
    FHebrewLoaded := InitializeDictionary(Hebrew, 'hebrew.idx', 'hebrew.htm');

  Result := FHebrewLoaded;
end;

function TStrongsConcordance.EnsureStrongGreekLoaded(): boolean;
begin
  if not FGreekLoaded then
    FGreekLoaded := InitializeDictionary(Greek, 'greek.idx', 'greek.htm');

  Result := FGreekLoaded;
end;

function TStrongsConcordance.InitializeDictionary(dict: TDict; idxFilename: string; htmFilename: string): boolean;
var
  idxFilePath: string;
  htmFilePath: string;
begin
  idxFilePath := TPath.Combine(TLibraryDirectories.Strong, idxFilename);
  htmFilePath := TPath.Combine(TLibraryDirectories.Strong, htmFilename);

  FLock.Acquire;
  try
    Result := dict.Initialize(idxFilePath, htmFilePath);
  finally
    FLock.Release;
  end;
end;

function TStrongsConcordance.GetStrongWordByIndex(ix: Integer): string;
var
  isHebrew: Boolean;
  num: Integer;
  word: string;
begin
  FLock.Acquire;
  try
    if (ix < Hebrew.Words.Count) then
    begin
      word := Hebrew.Words[ix];
      isHebrew := true;
    end
    else
    begin
      ix := ix - Hebrew.Words.Count;
      word := Greek.Words[ix];
      isHebrew := false;
    end;
  finally
    FLock.Release;
  end;

  num := StrToInt(word);
  Result := IfThen(isHebrew, 'H', 'G') + IntToStr(num);
end;

function TStrongsConcordance.GetTotalWords(): integer;
begin
  FLock.Acquire;
  try
    Result := Hebrew.Words.Count + Greek.Words.Count;
  finally
    FLock.Release;
  end;
end;

function TStrongsConcordance.Lookup(stext: string): string;
var
  isHebrew: Boolean;
  i, num, code: Integer;
  s: string;
begin
  if Copy(stext, 1, 1) = '0' then
    isHebrew := true
  else if Copy(stext, 1, 1) = 'H' then
  begin
    isHebrew := true;
    stext := Copy(stext, 2, Length(stext) - 1);
  end
  else if Copy(stext, 1, 1) = 'G' then
  begin
    isHebrew := false;
    stext := Copy(stext, 2, Length(stext) - 1);
  end
  else
    isHebrew := false;

  try
    Val(Trim(stext), num, code);
  finally
  end;

  if code = 0 then
  begin
    s := IntToStr(num);
    for i := Length(s) to 4 do
      s := '0' + s;

    if isHebrew or (num = 0) then
    begin
      if EnsureStrongHebrewLoaded() then
        Result := Hebrew.Lookup(s);
    end
    else
    begin
      if EnsureStrongGreekLoaded() then
        Result := Greek.Lookup(s);
    end;
  end;
end;

end.
