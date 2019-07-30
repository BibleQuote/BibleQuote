unit Sets;

interface

uses Generics.Collections;

type
  TSet<T> = class
  protected
    FDict: TDictionary<T, Byte>;
  public
    constructor Create;
    destructor Destroy; override;
    function Contains(const Value: T): Boolean;
    procedure Include(const Value: T);
    procedure Exclude(const Value: T);
    procedure IncludeSet(const ASet: TSet<T>);
    procedure IncludeList(const AList: TList<T>);
    procedure Clear();
    function HasAny(): Boolean;
  end;

  TIntSet = TSet<Integer>;

implementation

constructor TSet<T>.Create;
begin
  inherited;
  FDict := TDictionary<T, Byte>.Create;
end;

destructor TSet<T>.Destroy;
begin
  FDict.Free;
  inherited;
end;

function TSet<T>.Contains(const Value: T): Boolean;
begin
  Result := FDict.ContainsKey(Value);
end;

function TSet<T>.HasAny(): Boolean;
begin
  Result := FDict.Count > 0;
end;

procedure TSet<T>.Include(const Value: T);
begin
  FDict.AddOrSetValue(Value, 0);
end;

procedure TSet<T>.IncludeSet(const ASet: TSet<T>);
var
  Key: T;
begin
  for Key in ASet.FDict.Keys do
    Include(Key);
end;

procedure TSet<T>.IncludeList(const AList: TList<T>);
var
  Item: T;
begin
  for Item in AList do
    Include(Item);
end;

procedure TSet<T>.Exclude(const Value: T);
begin
  FDict.Remove(Value);
end;

procedure TSet<T>.Clear();
begin
  FDict.Clear;
end;

end.
