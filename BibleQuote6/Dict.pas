unit Dict;

interface

uses
  Windows, Classes, SysUtils, WideStrings,
  WCharReader, WCharWindows;

type TDict = class(TObject)
  private
    FIndex: WideString;
    FDict: WideString;
    FWords: TWideStrings;
    FName: WideString;
    FPath: WideString;
  public
    constructor Create;
    function Initialize(IndexFile, DictFile: WideString): boolean;
    function Lookup(wrd: WideString): WideString; // lookup a word in dictionary...
  published
    property Words: TWideStrings read FWords;
    property Name: WideString read FName;
    property Path: WideString read FPath;
  end;

implementation
uses BibleQuoteUtils;



constructor TDict.Create;
begin
  inherited Create;

  FName := '';
  FWords := TWideStringList.Create;
end;



function TDict.Initialize(IndexFile, DictFile: WideString): boolean;
var
  Lines: TWideStrings;
  i: integer;
  linecount:integer;
begin
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
  
  Lines := WChar_ReadTextFileToTWideStrings (FIndex);
  FName := Lines[0]; Lines.Delete(0);
  FWords.Clear;
  linecount:=(Lines.Count div 2 - 1);
  FWords.Capacity:=linecount;
  for i:=0 to linecount{(Lines.Count div 2 - 1)} do
  begin
   // FWords.AddObject(Lines[2*i], Pointer (StrToInt (Trim (Lines[2*i+1]))));
   FWords.InsertObject(i,Lines[2*i], Pointer ( StrToInt (Trim (Lines[2*i+1]))) );
  end;
  Result := (FWords.Count > 0);
  Lines.Free;
end;

function TDict.Lookup(wrd: WideString): WideString;
var
  dDictSize: Integer;
  dOffset: Integer;
  dCount: Integer;
  dExcludeWord: WideString;
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

    Result := WChar_ReadDictFragment (FDict, dOffset, dCount);

  end;

  dExcludeWord := WideLowerCase ('<h4>' + wrd + '</h4>');
  if WideLowerCase (Copy (Result, 1, Length (dExcludeWord))) = dExcludeWord then
    Result := Copy (Result, Length (dExcludeWord) + 1, Length (Result));

end;

end.
