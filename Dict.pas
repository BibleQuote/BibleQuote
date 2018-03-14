unit Dict;

interface

uses Windows, Classes, SysUtils, IOProcs,
  WCharWindows;

type TDict = class(TObject)
  private
    FIndex: string;
    FDict: string;
    FWords: TStrings;
    FName: string;
    FPath: string;
    FiLines: TStrings;
    Fii: integer;
    Filinecount:integer;
    FInitialized:boolean;
  public
    constructor Create;
    destructor Destroy(); override;
    function Initialize(IndexFile, DictFile: string; background:boolean=false): boolean;
    function Lookup(wrd: string): string; // lookup a word in dictionary...

    property Initialized:boolean read FInitialized;
    property Words: TStrings read FWords;
    property Name: string read FName;
    property Path: string read FPath;
  end;

implementation
uses BibleQuoteUtils, ExceptionFrm;



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

function TDict.Initialize(IndexFile, DictFile: string; background:boolean=false): boolean;


begin
try

  if IndexFile=FIndex then begin
  result:=true; exit
  end;

//if not assigned(FiLines) then begin
  if (FileExistsEx(IndexFile)<0) or (FileExistsEx(DictFile)<0) then
  begin
    Result := false;
    Exit;
  end;

  FIndex := IndexFile;
  FDict := DictFile;
//  if IndexFile[1]='?' then IndexFile:=GetArchiveFromSpecial(IndexFile);
  FPath := ExtractFileName(IndexFile);
  FPath := Copy(FPath,1,Length(FPath)-3);

  FiLines := ReadTextFileLines(FIndex, TEncoding.GetEncoding(1251));

  FName := FiLines[0]; FiLines.Delete(0);
  FWords.Clear;
  Filinecount:=(FiLines.Count div 2 )-1;
  FWords.Capacity:=Filinecount;
  FIi:=0;
  if background then exit;
  //end;

  if (not background) or (Fii<=Filinecount) then
  repeat
//  for i:=0 to linecount{(Lines.Count div 2 - 1)} do
//  begin
   // FWords.AddObject(Lines[2*i], Pointer (StrToInt (Trim (Lines[2*i+1]))));
   FWords.InsertObject(Fii,Trim(FiLines[2*Fii]),
       Pointer ( StrToInt (Trim (FiLines[2*Fii+1]))) );
  Inc(Fii);
  until (Fii>Filinecount) or (background and ((FiI and $3FF)=$3FF));


  result:= Fii>Filinecount;
  if not result then exit;
  FInitialized:=true;
  Result := (FWords.Count > 0);
//  MessageBeep(MB_ICONEXCLAMATION);
  FreeandNil(FiLines);
  Fii:=0;
except
on e:Exception do begin

BqShowException(e);
end;
end;
end;

function TDict.Lookup(wrd: string): string;
var
  dDictSize: Integer;
  dOffset: Integer;
  dCount: Integer;
  dExcludeWord: string;
  i: Integer;

begin
  i := FWords.IndexOf(wrd);

  if i = -1 then
  begin
    Result := '';

  end else
  begin
    dDictSize := ReadFileSize (FDict);
    dOffset := Integer (FWords.Objects [i]);

    if i < FWords.Count - 1 then
      dCount := Integer (FWords.Objects[i+1]) - dOffset
    else
      dCount := dDictSize - dOffset;

    Result := ReadDictFragment(FDict, dOffset, dCount, TEncoding.GetEncoding(1251));

  end;

  dExcludeWord := LowerCase ('<h4>' + wrd + '</h4>');
  if LowerCase (Copy (Result, 1, Length (dExcludeWord))) = dExcludeWord then
    Result := Copy (Result, Length (dExcludeWord) + 1, Length (Result));

end;

end.
