unit BaseDict;

interface

uses Classes, DictInterface;

type

  TBaseDict = class(TInterfacedObject, IDict)
  protected
    FWords : TStrings;
    FName: String;
    FDictDir: String;

  public
    constructor Create;
    destructor Destroy(); override;

    function GetWordCount(): Cardinal;
    function GetWord(aIndex: Cardinal): String;
    function GetName(): String;
    function Lookup(aWord: String): String; virtual; abstract;
    function GetDictDir(): String;

  end;

implementation

{ TBaseDict }
uses SysUtils;

constructor TBaseDict.Create;
begin
  FWords := TStringList.Create();
end;

destructor TBaseDict.Destroy;
begin

  FWords.Free();

  inherited;
end;

function TBaseDict.GetDictDir: String;
begin
  Result := FDictDir;
end;

function TBaseDict.GetName: String;
begin
  Result := FName;
end;

function TBaseDict.GetWord(aIndex: Cardinal): String;
begin
  Result := FWords[aIndex];
end;

function TBaseDict.GetWordCount: Cardinal;
begin
  Result := FWords.Count;
end;

end.
