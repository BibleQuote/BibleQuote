unit MyBibleDict;

interface

uses DictInterface;

type
  TMyBibleDict = class(TInterfacedObject, IDict)
  private
  public
    constructor Create;
    destructor Destroy(); override;

    function GetWordCount(): Cardinal;
    function GetWord(aIndex: Cardinal): String;
    function GetName(): String;
    function Lookup(aWord: String): String;
    function GetDictPath(): String;

  end;

implementation

{ TMyBibleDict }

constructor TMyBibleDict.Create;
begin

end;

destructor TMyBibleDict.Destroy;
begin

  inherited;
end;

function TMyBibleDict.GetDictPath: String;
begin
  Result := 'c:\';
end;

function TMyBibleDict.GetName: String;
begin
  Result := 'MyBible some dictionary';
end;

function TMyBibleDict.GetWord(aIndex: Cardinal): String;
begin

end;

function TMyBibleDict.GetWordCount: Cardinal;
begin

end;

function TMyBibleDict.Lookup(aWord: String): String;
begin
  Result := 'some word description';
end;

end.
