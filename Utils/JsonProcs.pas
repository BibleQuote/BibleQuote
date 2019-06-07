unit JsonProcs;

interface

uses System.Json;

type
  TJsonObjectHelper = class helper for TJsonObject
    private
    public
      function ReadString(aKey: String): String; overload;
      function ReadString(aKey: String; aDefault: String): String; overload;
      function ReadStringArray(aKey: String): TArray<String>;
      function GetArray(aKey: String): TJsonArray;
  end;

implementation

{ TJsonObjectHelper }

function TJsonObjectHelper.ReadString(aKey: String): String;
begin
  Result := Self.Get(aKey).JsonValue.Value;
end;

function TJsonObjectHelper.ReadString(aKey: String; aDefault: String): String;
var
  Pair: TJSONPair;
begin
  Pair := Self.Get(aKey);
  if (not Assigned(Pair)) then
    Result := aDefault
  else
    Result := Self.Get(aKey).JsonValue.Value;
end;

function TJsonObjectHelper.ReadStringArray(aKey: String): TArray<String>;
var
  ArrayNode: TJsonArray;
  Node: TJsonValue;
  index: Integer;
begin

  ArrayNode := Self.GetArray(aKey);
  SetLength(Result, ArrayNode.Count);

  index:= 0;
  for Node in ArrayNode do
  begin
    Result[index] := (Node as TJsonValue).Value;
    index := index + 1;
  end;

end;

function TJsonObjectHelper.GetArray(aKey: String): TJsonArray;
begin
  Result := Self.Get(aKey).JsonValue as TJSONArray;
end;



end.
