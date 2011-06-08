unit bqHistoryContainer;

interface
uses bqLinksParserIntf;

type

 TBQIntfHistoryContainer=class
protected
mContainer:array of TBibleLinkEx;
mMaxDepth:integer;
mCurPtr:integer;
mCurrentDepth:integer;
function GetV(ix:integer):PBibleLinkEx;
procedure SetV(ix:integer; val:PBibleLinkEx);
function ArrLen():integer; inline;
procedure IncArr(newLen:integer=0);
public
function push(const lnk:TBibleLinkEx):integer;
function pop:TBibleLinkEx;
function EffectiveDepth():integer; inline;
function IndexOf(const match:TBibleLinkEx;const matFlags:TBibleLinkExLikeness; fromIx:integer=0):integer;
constructor Create(max:integer=500;capacity:integer=100);
destructor Destroy();override;
property Item[ix:integer]:PBibleLinkEx read getV write setV;
procedure toFile(path:WideString);
procedure fromFile(path:WideString);
end;
implementation
uses SysUtils,Windows,JCLWin32, BQExceptionTracker;
{ TBQHistoryContainer }

function TBQIntfHistoryContainer.ArrLen(): integer;
begin
result:=length(mContainer);
end;

constructor TBQIntfHistoryContainer.Create(max:integer=500;capacity:integer=100);
begin
SetLength(mContainer,capacity);
mCurPtr:=-1;
mCurrentDepth:=0;
end;

destructor TBQIntfHistoryContainer.Destroy();
begin
SetLength(mContainer,0);
end;

function TBQIntfHistoryContainer.EffectiveDepth: integer;
begin
if mCurrentDepth<mMaxDepth then result:=mCurrentDepth else result:=mMaxDepth;
end;

procedure TBQIntfHistoryContainer.fromFile(path: WideString);
var fHandle:THandle;
    i,c, l, check:integer;
    w:WideString;
    pbl:PBibleLinkEx;
    buf:array[0..512] of WideChar;
begin
fHandle:= CreateFileW(PWideChar(Pointer(path)),FILE_READ_DATA or STANDARD_RIGHTS_READ,0,nil,
OPEN_EXISTING,0,0);
if fHandle=INVALID_HANDLE_VALUE then exit;
try
l:=GetFileSize(fHandle, nil);
check:=FileRead(fHandle, buf[0], 512);

c:=EffectiveDepth()-1;
for I := 0 to c do begin
pbl:=GetV(i);
w:=pbl^.ToCommand()+#13#10;
l:=length(w);
check:=FileWrite(fHandle, Pointer(w)^, l);
if l<>check then raise Exception.Create('Unexpected write history file error');
end;
except on e:Exception do BqShowException(e); end;
if fHandle<>INVALID_HANDLE_VALUE then CloseHandle(fHandle);

end;

function TBQIntfHistoryContainer.GetV(ix: integer): PBibleLinkEx;
begin
result:=nil;
if ix<ArrLen() then result:=@(mContainer[ix]);
end;

procedure TBQIntfHistoryContainer.IncArr(newLen: integer=0);
begin
if newLen=0 then begin
  newLen:=mCurPtr*2; if newLen>mMaxDepth then newLen:=mMaxDepth; end;
SetLength(mContainer, newLen);
end;

function TBQIntfHistoryContainer.IndexOf(const match: TBibleLinkEx;
  const matFlags: TBibleLinkExLikeness; fromIx: integer): integer;
  var i,last:integer;
      pbl:PBibleLinkEx;
      mt:TBibleLinkExLikeness;
label bingo;
begin
last:=EffectiveDepth();
i:=fromIx;
while i<last do begin
pbl:= GetV(i);
mt:=pbl^.GetLikeNess(match);
if (matFlags*mt)=matFlags then begin
goto bingo;
end;
inc(i);
end;
result:=-1;
exit;

bingo: result:=i;
end;

function TBQIntfHistoryContainer.pop: TBibleLinkEx;
begin
if mCurrentDepth<=0 then raise
    ERangeError.Create('TBQHistoryContainer underflow: pop from empty containter');
Dec(mCurrentDepth);
result:=GetV(mCurPtr)^;
dec(mCurPtr);
if mCurPtr<0 then mCurPtr:=mMaxDepth-mCurPtr;
end;

function TBQIntfHistoryContainer.push(const lnk: TBibleLinkEx): integer;
begin
Inc(mCurPtr);
if (mCurPtr>=ArrLen()) then begin
if (mCurPtr<mMaxDepth) then begin IncArr(); end
else Dec(mCurPtr,mMaxDepth);
end;
Inc(mCurrentDepth);
mContainer[mCurPtr]:=lnk;
result:=mCurPtr;
end;


procedure TBQIntfHistoryContainer.SetV(ix: integer; val: PBibleLinkEx);
var delta:integer;
begin
if (ix<0) or (ix>=ArrLen()) or (ix>=mCurrentDepth) then
 raise ERangeError.CreateFmt('TBQHistoryContainer overflow: ix %d from %d',[Ix,mMaxDepth]);
delta:= mCurPtr-ix;
if delta<0 then Inc(delta,mMaxDepth);
mContainer[delta]:=val^;
end;

procedure TBQIntfHistoryContainer.toFile(path: WideString);
var fHandle:THandle;
    i,c, l, check:integer;
    w:WideString;
    pbl:PBibleLinkEx;
begin
fHandle:= CreateFileW(PWideChar(Pointer(path)),FILE_WRITE_DATA or STANDARD_RIGHTS_WRITE,0,nil,
CREATE_ALWAYS,0,0);
try
if fHandle=INVALID_HANDLE_VALUE then raise
  Exception.Create('Cannot write history file');
c:=EffectiveDepth()-1;
for I := 0 to c do begin
pbl:=GetV(i);
w:=pbl^.ToCommand()+#13#10;
l:=length(w);
check:=FileWrite(fHandle, Pointer(w)^, l);
if l<>check then raise Exception.Create('Unexpected write history file error');
end;
except on e:Exception do BqShowException(e); end;
if fHandle<>INVALID_HANDLE_VALUE then CloseHandle(fHandle);

end;

end.
