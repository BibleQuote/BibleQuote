unit bqContainers;

interface
type
  TBQHistoryContainer=object
  protected
  mContainer:array of PAnsiChar;
  mLength:Cardinal;
  mCurrentPtr:integer;
  mCurrentDepth:integer;
  function  GetValue(Index: Integer):PAnsiChar;
  procedure SetValue(Index: Integer; Value: PAnsiChar);
  public
  constructor Init(sz:cardinal);
  destructor Done();
  function Push(val:PAnsiChar):cardinal;
  function IsEmpty():boolean; inline;
  procedure Clear();
  function EffectiveDepth():integer;
  procedure OffsetTokens(delta:integer);
  property items[Index: Integer]:PAnsiChar read GetValue
                        write SetValue;default;
  property depth:integer read mCurrentDepth;
  property size:Cardinal read mLength;
  end;

implementation
uses SysUtils;
{ TBQHistoryContainer }

procedure TBQHistoryContainer.Clear;
begin
mCurrentPtr:=-1;
mCurrentDepth:=0;
end;

destructor TBQHistoryContainer.Done;
begin
mContainer:=nil;
end;

function TBQHistoryContainer.EffectiveDepth: integer;
begin
if mCurrentDepth<mLength then result:=mCurrentDepth else result:=mLength;
end;

function TBQHistoryContainer.GetValue(Index: Integer): PAnsiChar;
var delta:integer;
begin
if (Index<0) or (Index>=mLength) or (Index>=mCurrentDepth) then
 raise ERangeError.CreateFmt(
 'TBQHistoryContainer overflow: ix=%d from %d, %d valid values',[Index,mLength,mCurrentDepth]);
delta:= mCurrentPtr-Index;
if delta<0 then Inc(delta,mLength);
result:=mContainer[delta];
end;

constructor TBQHistoryContainer.Init(sz: cardinal);
begin
SetLength(mContainer, sz);
mLength:=(sz);
mCurrentPtr:=-1;
mCurrentDepth:=0;
end;

function TBQHistoryContainer.IsEmpty(): boolean;
begin
result:=mCurrentDepth=0;
end;

procedure TBQHistoryContainer.OffsetTokens(delta: integer);
var i,c:integer;
begin
c:=mLength-1;
for i:=0 to c do Inc(mContainer[i], delta);
end;

function TBQHistoryContainer.Push(val: PAnsiChar):Cardinal;
begin
Inc(mCurrentPtr);
if mCurrentPtr>=mLength then Dec(mCurrentPtr,mLength);
Inc(mCurrentDepth);
mContainer[mCurrentPtr]:=val;
result:=mCurrentPtr;
end;

procedure TBQHistoryContainer.SetValue(Index: Integer; Value: PAnsiChar);
var delta:integer;
begin
if (Index<0) or (Index>=mLength) then
 raise ERangeError.CreateFmt('TBQHistoryContainer overflow: ix %d from %d',[Index,mLength]);
delta:= mCurrentPtr-Index;
if delta<0 then Inc(delta,mLength);
mContainer[delta]:=Value;
end;


end.
