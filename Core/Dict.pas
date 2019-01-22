unit Dict;

interface

uses Windows, Classes, SysUtils, IOProcs;

type
  TDict = class(TObject)
  private
    FIndex: string;
    FDict: string;
    FWords: TStrings;
    FName: string;
    FPath: string;
    FiLines: TStrings;
    Fii: integer;
    Filinecount: integer;
    FInitialized: boolean;
  public
    constructor Create;
    destructor Destroy(); override;
    function Initialize(IndexFile, DictFile: string; background: boolean = false): boolean;
    function Lookup(wrd: string): string; // lookup a word in dictionary...

    property Initialized: boolean read FInitialized;
    property Words: TStrings read FWords;
    property Name: string read FName;
    property Path: string read FPath;
    property Dict: string read FDict;
  end;

implementation

uses BibleQuoteUtils;

constructor TDict.Create;
begin
  inherited Create;

  FName := '';
  FIndex := '';
  FDict := '';

  FWords := TStringList.Create;
end;

destructor TDict.Destroy;
begin
  FWords.Free();
  inherited;
end;

function TDict.Initialize(IndexFile, DictFile: string; background: boolean = false): boolean;
begin
  if IndexFile = FIndex then
  begin
    result := true;
    exit
  end;

  result := false;
  // if not assigned(FiLines) then begin
  if (FileExistsEx(IndexFile) < 0) or (FileExistsEx(DictFile) < 0) then
  begin
    exit;
  end;

  FIndex := IndexFile;
  FDict := DictFile;
  FPath := ExtractFileName(IndexFile);
  FPath := Copy(FPath, 1, Length(FPath) - 3);

  FiLines := ReadTextFileLines(FIndex, TEncoding.GetEncoding(1251));

  FName := FiLines[0];
  FiLines.Delete(0);
  FWords.Clear;
  Filinecount := (FiLines.Count div 2) - 1;
  FWords.Capacity := Filinecount;
  Fii := 0;
  if background then
    exit;

  if (not background) or (Fii <= Filinecount) then
    repeat
      FWords.InsertObject(Fii, Trim(FiLines[2 * Fii]), Pointer(StrToIntDef(Trim(FiLines[2 * Fii + 1]), 0)));
      Inc(Fii);
    until (Fii > Filinecount) or (background and ((Fii and $3FF) = $3FF));

  result := Fii > Filinecount;
  if not result then
    exit;
  FInitialized := true;
  result := (FWords.Count > 0);
  FreeandNil(FiLines);
  Fii := 0;
end;

function TDict.Lookup(wrd: string): string;
var
  dDictSize: integer;
  dOffset: integer;
  dCount: integer;
  dExcludeWord: string;
  i: integer;

begin
  i := FWords.IndexOf(wrd);

  if i = -1 then
    result := ''
  else
  begin
    dDictSize := ReadFileSize(FDict);
    dOffset := integer(FWords.Objects[i]);

    if i < FWords.Count - 1 then
      dCount := integer(FWords.Objects[i + 1]) - dOffset
    else
      dCount := dDictSize - dOffset;

    result := ReadDictFragment(FDict, dOffset, dCount, TEncoding.GetEncoding(1251));
  end;

  dExcludeWord := LowerCase('<h4>' + wrd + '</h4>');
  if LowerCase(Copy(result, 1, Length(dExcludeWord))) = dExcludeWord then
    result := Copy(result, Length(dExcludeWord) + 1, Length(result));

end;

end.
