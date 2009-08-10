
{ *********************************************************************** }
{                                                                         }
{ Delphi Runtime Library                                                  }
{                                                                         }
{ Copyright (c) 1995-2005 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit WideStrings;

interface

uses Classes, SysUtils;

type
  TWideStrings = class;

{ IWideStringsAdapter interface }
{ Maintains link between TWideStrings and IWideStrings implementations }

  IWideStringsAdapter = interface
    ['{25FE0E3B-66CB-48AA-B23B-BCFA67E8F5DA}']
    procedure ReferenceStrings(S: TWideStrings);
    procedure ReleaseStrings;
  end;

{ TWideStrings class }

  TWideStringsEnumerator = class
  private
    FIndex: Integer;
    FStrings: TWideStrings;
  public
    constructor Create(AStrings: TWideStrings);
    function GetCurrent: WideString;
    function MoveNext: Boolean;
    property Current: WideString read GetCurrent;
  end;

  TWideStrings = class(TPersistent)
  private
    FDefined: TStringsDefined;
    FDelimiter: WideChar;
    FLineBreak: WideString;
    FQuoteChar: WideChar;
    FNameValueSeparator: WideChar;
    FStrictDelimiter: Boolean;
    FUpdateCount: Integer;
    FAdapter: IWideStringsAdapter;
    function GetCommaText: WideString;
    function GetDelimitedText: WideString;
    function GetName(Index: Integer): WideString;
    function GetValue(const Name: WideString): WideString;
    procedure ReadData(Reader: TReader);
    procedure SetCommaText(const Value: WideString);
    procedure SetDelimitedText(const Value: WideString);
    procedure SetStringsAdapter(const Value: IWideStringsAdapter);
    procedure SetValue(const Name, Value: WideString);
    procedure WriteData(Writer: TWriter);
    function GetDelimiter: WideChar;
    procedure SetDelimiter(const Value: WideChar);
    function GetLineBreak: WideString;
    procedure SetLineBreak(const Value: WideString);
    function GetQuoteChar: WideChar;
    procedure SetQuoteChar(const Value: WideChar);
    function GetNameValueSeparator: WideChar;
    procedure SetNameValueSeparator(const Value: WideChar);
    function GetStrictDelimiter: Boolean;
    procedure SetStrictDelimiter(const Value: Boolean);
    function GetValueFromIndex(Index: Integer): WideString;
    procedure SetValueFromIndex(Index: Integer; const Value: WideString);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Error(const Msg: WideString; Data: Integer); overload;
    procedure Error(Msg: PResStringRec; Data: Integer); overload;
    function ExtractName(const S: WideString): WideString;
    function Get(Index: Integer): WideString; virtual; abstract;
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual; abstract;
    function GetObject(Index: Integer): TObject; virtual;
    function GetTextStr: WideString; virtual;
    procedure Put(Index: Integer; const S: WideString); virtual;
    procedure PutObject(Index: Integer; AObject: TObject); virtual;
    procedure SetCapacity(NewCapacity: Integer); virtual;
    procedure SetTextStr(const Value: WideString); virtual;
    procedure SetUpdateState(Updating: Boolean); virtual;
    property UpdateCount: Integer read FUpdateCount;
    function CompareStrings(const S1, S2: WideString): Integer; virtual;
  public
    destructor Destroy; override;
    function Add(const S: WideString): Integer; virtual;
    function AddObject(const S: WideString; AObject: TObject): Integer; virtual;
    procedure Append(const S: WideString);
    procedure AddStrings(Strings: TStrings); overload; virtual;
    procedure AddStrings(Strings: TWideStrings); overload; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure Clear; virtual; abstract;
    procedure Delete(Index: Integer); virtual; abstract;
    procedure EndUpdate;
    function Equals(Strings: TWideStrings): Boolean;
    procedure Exchange(Index1, Index2: Integer); virtual;
    function GetEnumerator: TWideStringsEnumerator;
    function GetText: PwideChar; virtual;
    function IndexOf(const S: WideString): Integer; virtual;
    function IndexOfName(const Name: WideString): Integer; virtual;
    function IndexOfObject(AObject: TObject): Integer; virtual;
    procedure Insert(Index: Integer; const S: WideString); virtual; abstract;
    procedure InsertObject(Index: Integer; const S: WideString;
      AObject: TObject); virtual;
    procedure LoadFromFile(const FileName: WideString); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure Move(CurIndex, NewIndex: Integer); virtual;
    procedure SaveToFile(const FileName: WideString); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SetText(Text: PwideChar); virtual;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property CommaText: WideString read GetCommaText write SetCommaText;
    property Count: Integer read GetCount;
    property Delimiter: WideChar read GetDelimiter write SetDelimiter;
    property DelimitedText: WideString read GetDelimitedText write SetDelimitedText;
    property LineBreak: WideString read GetLineBreak write SetLineBreak;
    property Names[Index: Integer]: WideString read GetName;
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
    property QuoteChar: WideChar read GetQuoteChar write SetQuoteChar;
    property Values[const Name: WideString]: WideString read GetValue write SetValue;
    property ValueFromIndex[Index: Integer]: WideString read GetValueFromIndex write SetValueFromIndex;
    property NameValueSeparator: WideChar read GetNameValueSeparator write SetNameValueSeparator;
    property StrictDelimiter: Boolean read GetStrictDelimiter write SetStrictDelimiter;
    property Strings[Index: Integer]: WideString read Get write Put; default;
    property Text: WideString read GetTextStr write SetTextStr;
    property StringsAdapter: IWideStringsAdapter read FAdapter write SetStringsAdapter;
  end;

{ TWideStringList class }

  TWideStringList = class;

  PWideStringItem = ^TWideStringItem;
  TWideStringItem = record
    FString: WideString;
    FObject: TObject;
  end;

  PWideStringItemList = ^TWideStringItemList;
  TWideStringItemList = array[0..MaxListSize] of TWideStringItem;
  TWideStringListSortCompare = function(List: TWideStringList; Index1, Index2: Integer): Integer;

  TWideStringList = class(TWideStrings)
  private
    FList: PWideStringItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FCaseSensitive: Boolean;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure Grow;
    procedure QuickSort(L, R: Integer; SCompare: TWideStringListSortCompare);
    procedure SetSorted(Value: Boolean);
    procedure SetCaseSensitive(const Value: Boolean);
  protected
    procedure Changed; virtual;
    procedure Changing; virtual;
    function Get(Index: Integer): WideString; override;
    function GetCapacity: Integer; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
    procedure Put(Index: Integer; const S: WideString); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure SetCapacity(NewCapacity: Integer); override;
    procedure SetUpdateState(Updating: Boolean); override;
    function CompareStrings(const S1, S2: WideString): Integer; override;
    procedure InsertItem(Index: Integer; const S: WideString; AObject: TObject); virtual;
  public
    destructor Destroy; override;
    function Add(const S: WideString): Integer; override;
    function AddObject(const S: WideString; AObject: TObject): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    function Find(const S: WideString; var Index: Integer): Boolean; virtual;
    function IndexOf(const S: WideString): Integer; override;
    procedure Insert(Index: Integer; const S: WideString); override;
    procedure InsertObject(Index: Integer; const S: WideString;
      AObject: TObject); override;
    procedure Sort; virtual;
    procedure CustomSort(Compare: TWideStringListSortCompare); virtual;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Sorted: Boolean read FSorted write SetSorted;
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
  end;

implementation

uses Windows, RTLConsts, WideStrUtils, Math;

{ CharNextW is not existed on Win9X platform. }

type
  CharNextWFunc = function (lpsz: PWideChar): PWideChar; stdcall;

var
  CharNextW : CharNextWFunc;

function CharNextW95(lpsz: PWideChar): PWideChar; stdcall;
begin
  Result := lpsz + 1;
end;

procedure InitCharNextWFunc;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
    CharNextW := @Windows.CharNextW
  else
    CharNextW := @CharNextW95;
end;

{ TWideStringsEnumerator }

constructor TWideStringsEnumerator.Create(AStrings: TWideStrings);
begin
  inherited Create;
  FIndex := -1;
  FStrings := AStrings;
end;

function TWideStringsEnumerator.GetCurrent: WideString;
begin
  Result := FStrings[FIndex];
end;

function TWideStringsEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FStrings.Count - 1;
  if Result then
    Inc(FIndex);
end;

{ TWideStrings }

destructor TWideStrings.Destroy;
begin
  StringsAdapter := nil;
  inherited Destroy;
end;

function TWideStrings.Add(const S: WideString): Integer;
begin
  Result := GetCount;
  Insert(Result, S);
end;

function TWideStrings.AddObject(const S: WideString; AObject: TObject): Integer;
begin
  Result := Add(S);
  PutObject(Result, AObject);
end;

procedure TWideStrings.Append(const S: WideString);
begin
  Add(S);
end;

procedure TWideStrings.AddStrings(Strings: TStrings);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do
      AddObject(Strings[I], Strings.Objects[I]);
  finally
    EndUpdate;
  end;
end;

procedure TWideStrings.AddStrings(Strings: TWideStrings);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do
      AddObject(Strings[I], Strings.Objects[I]);
  finally
    EndUpdate;
  end;
end;

procedure TWideStrings.Assign(Source: TPersistent);

  function CharToWideChar(const c: AnsiChar): WideChar;
  var
    W: WideString;
  begin
    w := WideString(AnsiString(c));
    if length(W) = 1 then Result := W[1]
    else Result := '?';
  end;

begin
  if Source is TWideStrings then
  begin
    BeginUpdate;
    try
      Clear;
      FDefined := TWideStrings(Source).FDefined;
      FNameValueSeparator := TWideStrings(Source).FNameValueSeparator;
      FQuoteChar := TWideStrings(Source).FQuoteChar;
      FDelimiter := TWideStrings(Source).FDelimiter;
      FLineBreak := TWideStrings(Source).FLineBreak;
      FStrictDelimiter := TWideStrings(Source).FStrictDelimiter;
      AddStrings(TWideStrings(Source));
    finally
      EndUpdate;
    end;
  end
  else if Source is TStrings then
  begin
    BeginUpdate;
    try
      Clear;
      FNameValueSeparator := WideChar(TStrings(Source).NameValueSeparator);
      FQuoteChar := CharToWideChar(TStrings(Source).QuoteChar);
      FDelimiter := CharToWideChar(TStrings(Source).Delimiter);
      FLineBreak := TStrings(Source).LineBreak;
      FStrictDelimiter := TStrings(Source).StrictDelimiter;
      AddStrings(TStrings(Source));
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TWideStrings.AssignTo(Dest: TPersistent);

  function WideCharToChar(const c: WideChar): AnsiChar;
  var
    A: AnsiString;
  begin
    a := AnsiString(WideString(c));
    if length(a) = 1 then Result := a[1]
    else Result := '?';
  end;

var
  I: Integer;
begin
  if Dest is TWideStrings then Dest.Assign(Self)
  else if Dest is TStrings then
  begin
    TStrings(Dest).BeginUpdate;
    try
      TStrings(Dest).Clear;
      TStrings(Dest).NameValueSeparator := WideCharToChar(NameValueSeparator);
      TStrings(Dest).QuoteChar := WideCharToChar(QuoteChar);
      TStrings(Dest).Delimiter := WideCharToChar(Delimiter);
      TStrings(Dest).LineBreak := LineBreak;
      TStrings(Dest).StrictDelimiter := StrictDelimiter;
      for I := 0 to Count - 1 do
        TStrings(Dest).AddObject(Strings[I], Objects[I]);
    finally
      TStrings(Dest).EndUpdate;
    end;
  end
  else
    inherited AssignTo(Dest);
end;

procedure TWideStrings.BeginUpdate;
begin
  if FUpdateCount = 0 then SetUpdateState(True);
  Inc(FUpdateCount);
end;

procedure TWideStrings.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then
    begin
      Result := True;
      if Filer.Ancestor is TWideStrings then
        Result := not Equals(TWideStrings(Filer.Ancestor))
    end
    else Result := Count > 0;
  end;

begin
  Filer.DefineProperty('Strings', ReadData, WriteData, DoWrite);
end;

procedure TWideStrings.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then SetUpdateState(False);
end;

function TWideStrings.Equals(Strings: TWideStrings): Boolean;
var
  I, Count: Integer;
begin
  Result := False;
  Count := GetCount;
  if Count <> Strings.GetCount then Exit;
  for I := 0 to Count - 1 do if Get(I) <> Strings.Get(I) then Exit;
  Result := True;
end;

procedure TWideStrings.Error(const Msg: WideString; Data: Integer);

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure TWideStrings.Error(Msg: PResStringRec; Data: Integer);
begin
  Error(LoadResString(Msg), Data);
end;

procedure TWideStrings.Exchange(Index1, Index2: Integer);
var
  TempObject: TObject;
  TempString: WideString;
begin
  BeginUpdate;
  try
    TempString := Strings[Index1];
    TempObject := Objects[Index1];
    Strings[Index1] := Strings[Index2];
    Objects[Index1] := Objects[Index2];
    Strings[Index2] := TempString;
    Objects[Index2] := TempObject;
  finally
    EndUpdate;
  end;
end;

function TWideStrings.ExtractName(const S: WideString): WideString;
var
  P: Integer;
begin
  Result := S;
  P := Pos(NameValueSeparator, Result);
  if P <> 0 then
    SetLength(Result, P-1) else
    SetLength(Result, 0);
end;

function TWideStrings.GetCapacity: Integer;
begin  // descendents may optionally override/replace this default implementation
  Result := Count;
end;

function TWideStrings.GetCommaText: WideString;
var
  LOldDefined: TStringsDefined;
  LOldDelimiter: WideChar;
  LOldQuoteChar: WideChar;
begin
  LOldDefined := FDefined;
  LOldDelimiter := FDelimiter;
  LOldQuoteChar := FQuoteChar;
  Delimiter := ',';
  QuoteChar := '"';
  try
    Result := GetDelimitedText;
  finally
    FDelimiter := LOldDelimiter;
    FQuoteChar := LOldQuoteChar;
    FDefined := LOldDefined;
  end;
end;

function TWideStrings.GetDelimitedText: WideString;

  function IsDelimiter(const ch: WideChar): boolean;
  begin
    Result := true;
    if not StrictDelimiter and (ch <= ' ') then exit
    else if ch = QuoteChar then exit
    else if ch = Delimiter then exit
    else if ch = #$00 then exit;
    Result := False;
  end;

var
  S: WideString;
  P: PwideChar;
  I, Count: Integer;
begin
  Count := GetCount;                                                        
  if (Count = 1) and (Get(0) = '') then
    Result := WideString(QuoteChar) + WideString(QuoteChar)                                                   
  else
  begin
    Result := '';
    for I := 0 to Count - 1 do
    begin
      S := Get(I);
      P := PwideChar(S);
      while not IsDelimiter(P^) do
        P := CharNextW(P); // for UTF16
      if (P^ <> #0) then S := WideQuotedStr(S, QuoteChar);
      Result := Result + S + Delimiter;
    end;
    System.Delete(Result, Length(Result), 1);
  end;
end;

function TWideStrings.GetEnumerator: TWideStringsEnumerator;
begin
  Result := TWideStringsEnumerator.Create(Self);
end;

function TWideStrings.GetName(Index: Integer): WideString;
begin
  Result := ExtractName(Get(Index));
end;

function TWideStrings.GetObject(Index: Integer): TObject;
begin
  Result := nil;
end;

function TWideStrings.GetText: PwideChar;
begin
  Result := WStrNew(PwideChar(GetTextStr));
end;

function TWideStrings.GetTextStr: WideString;
var
  I, L, Size, Count: Integer;
  P: PwideChar;
  S, LB: WideString;
begin
  Count := GetCount;
  Size := 0;
  LB := sLineBreak;
  for I := 0 to Count - 1 do Inc(Size, Length(Get(I)) + Length(LB));
  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := Get(I);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L*SizeOf(WideChar));
      Inc(P, L);
    end;
    L := Length(LB);
    if L <> 0 then
    begin
      System.Move(Pointer(LB)^, P^, L*SizeOf(WideChar));
      Inc(P, L);
    end;
  end;
end;

function TWideStrings.GetValue(const Name: WideString): WideString;
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if I >= 0 then
    Result := Copy(Get(I), Length(Name) + 2, MaxInt) else
    Result := '';
end;

function TWideStrings.IndexOf(const S: WideString): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if CompareStrings(Get(Result), S) = 0 then Exit;
  Result := -1;
end;

function TWideStrings.IndexOfName(const Name: WideString): Integer;
var
  P: Integer;
  S: WideString;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    P := Pos(NameValueSeparator, S);
    if (P <> 0) and (CompareStrings(Copy(S, 1, P - 1), Name) = 0) then Exit;
  end;
  Result := -1;
end;

function TWideStrings.IndexOfObject(AObject: TObject): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if GetObject(Result) = AObject then Exit;
  Result := -1;
end;

procedure TWideStrings.InsertObject(Index: Integer; const S: WideString;
  AObject: TObject);
begin
  Insert(Index, S);
  PutObject(Index, AObject);
end;

procedure TWideStrings.LoadFromFile(const FileName: WideString);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TWideStrings.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  S: WideString;
begin
  BeginUpdate;
  try
    Size := Stream.Size - Stream.Position;
    SetString(S, nil, (Size div 2) + (Size mod 2) );
    Stream.Read(Pointer(S)^, Size);
    SetTextStr(S);
  finally
    EndUpdate;
  end;
end;

procedure TWideStrings.Move(CurIndex, NewIndex: Integer);
var
  TempObject: TObject;
  TempString: WideString;
begin
  if CurIndex <> NewIndex then
  begin
    BeginUpdate;
    try
      TempString := Get(CurIndex);
      TempObject := GetObject(CurIndex);
      Delete(CurIndex);
      InsertObject(NewIndex, TempString, TempObject);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TWideStrings.Put(Index: Integer; const S: WideString);
var
  TempObject: TObject;
begin
  TempObject := GetObject(Index);
  Delete(Index);
  InsertObject(Index, S, TempObject);
end;

procedure TWideStrings.PutObject(Index: Integer; AObject: TObject);
begin
end;

procedure TWideStrings.ReadData(Reader: TReader);
begin
  Reader.ReadListBegin;
  BeginUpdate;
  try
    Clear;
    while not Reader.EndOfList do Add(Reader.ReadWideString);
  finally
    EndUpdate;
  end;
  Reader.ReadListEnd;
end;

procedure TWideStrings.SaveToFile(const FileName: WideString);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TWideStrings.SaveToStream(Stream: TStream);
var
  S: WideString;
begin
  S := GetTextStr;
  Stream.WriteBuffer(Pointer(S)^, Length(S) * SizeOf(WideChar));
end;

procedure TWideStrings.SetCapacity(NewCapacity: Integer);
begin
  // do nothing - descendents may optionally implement this method
end;

procedure TWideStrings.SetCommaText(const Value: WideString);
begin
  Delimiter := ',';
  QuoteChar := '"';
  SetDelimitedText(Value);
end;

procedure TWideStrings.SetStringsAdapter(const Value: IWideStringsAdapter);
begin
  if FAdapter <> nil then FAdapter.ReleaseStrings;
  FAdapter := Value;
  if FAdapter <> nil then FAdapter.ReferenceStrings(Self);
end;

procedure TWideStrings.SetText(Text: PWideChar);
begin
  SetTextStr(Text);
end;

procedure TWideStrings.SetTextStr(const Value: WideString);
var
  P, Start: PwideChar;
  S: WideString;
begin
  BeginUpdate;
  try
    Clear;
    P := Pointer(Value);
    if P <> nil then
      while P^ <> #0 do
      begin
        Start := P;
        while not InOpSet(P^, [#0, #10, #13]) do Inc(P);
        SetString(S, Start, P - Start);
        Add(S);
        if P^ = #13 then Inc(P);
        if P^ = #10 then Inc(P);
      end;
  finally
    EndUpdate;
  end;
end;

procedure TWideStrings.SetUpdateState(Updating: Boolean);
begin
end;

procedure TWideStrings.SetValue(const Name, Value: WideString);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    Put(I, Name + NameValueSeparator + Value);
  end else
  begin
    if I >= 0 then Delete(I);
  end;
end;

procedure TWideStrings.WriteData(Writer: TWriter);
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do Writer.WriteWideString(Get(I));
  Writer.WriteListEnd;
end;

procedure TWideStrings.SetDelimitedText(const Value: WideString);
var
  P, P1: PwideChar;
  S: WideString;
begin
  BeginUpdate;
  try
    Clear;
    P := PwideChar(Value);
    if not StrictDelimiter then
      while inOpSet(P^, [#1..' ']) do
        P := CharNextW(P);
    while P^ <> #0 do
    begin
      if P^ = WideChar(QuoteChar) then
        S := WideExtractQuotedStr(P, WideChar(QuoteChar))
      else
      begin
        P1 := P;
        while ((not FStrictDelimiter and (P^ > ' ')) or
              (FStrictDelimiter and (P^ <> #0))) and (P^ <> WideChar(Delimiter)) do
          P := CharNextW(P);
        SetString(S, P1, P - P1);
      end;
      Add(S);
      if not FStrictDelimiter then
        while inOpSet(P^, [#1..' ']) do
          P := CharNextW(P);

      if P^ = WideChar(Delimiter) then
      begin
        P1 := P;
        if CharNextW(P1)^ = #0 then
          Add('');
        repeat
          P := CharNextW(P);
        until not (not FStrictDelimiter and inOpSet(P^, [#1..' ']));
      end;
    end;
  finally
    EndUpdate;
  end;
end;

function TWideStrings.GetDelimiter: WideChar;
begin
  if not (sdDelimiter in FDefined) then
    Delimiter := ',';
  Result := FDelimiter;
end;

function TWideStrings.GetLineBreak: WideString;
begin
  if not (sdLineBreak in FDefined) then
    LineBreak := sLineBreak;
  Result := FLineBreak;
end;

function TWideStrings.GetQuoteChar: WideChar;
begin
  if not (sdQuoteChar in FDefined) then
    QuoteChar := '"';
  Result := FQuoteChar;
end;

function TWideStrings.GetStrictDelimiter: Boolean;
begin
  if not (sdStrictDelimiter in FDefined) then
    StrictDelimiter := False;
  Result := FStrictDelimiter;
end;

procedure TWideStrings.SetDelimiter(const Value: WideChar);
begin
  if (FDelimiter <> Value) or not (sdDelimiter in FDefined) then
  begin
    Include(FDefined, sdDelimiter);
    FDelimiter := Value;
  end
end;

procedure TWideStrings.SetLineBreak(const Value: WideString);
begin
  if (FLineBreak <> Value) or not (sdLineBreak in FDefined) then
  begin
    Include(FDefined, sdLineBreak);
    FLineBreak := Value;
  end
end;

procedure TWideStrings.SetQuoteChar(const Value: WideChar);
begin
  if (FQuoteChar <> Value) or not (sdQuoteChar in FDefined) then
  begin
    Include(FDefined, sdQuoteChar);
    FQuoteChar := Value;
  end
end;

procedure TWideStrings.SetStrictDelimiter(const Value: Boolean);
begin
  if (FStrictDelimiter <> Value) or not (sdStrictDelimiter in FDefined) then
  begin
    Include(FDefined, sdStrictDelimiter);
    FStrictDelimiter := Value;
  end
end;

function TWideStrings.CompareStrings(const S1, S2: WideString): Integer;
begin
  Result := WideCompareText(S1, S2);
end;

function TWideStrings.GetNameValueSeparator: WideChar;
begin
  if not (sdNameValueSeparator in FDefined) then
    NameValueSeparator := '=';
  Result := FNameValueSeparator;
end;

procedure TWideStrings.SetNameValueSeparator(const Value: WideChar);
begin
  if (FNameValueSeparator <> Value) or not (sdNameValueSeparator in FDefined) then
  begin
    Include(FDefined, sdNameValueSeparator);
    FNameValueSeparator := Value;
  end
end;

function TWideStrings.GetValueFromIndex(Index: Integer): WideString;
begin
  if Index >= 0 then
    Result := Copy(Get(Index), Length(Names[Index]) + 2, MaxInt) else
    Result := '';
end;

procedure TWideStrings.SetValueFromIndex(Index: Integer; const Value: WideString);
begin
  if Value <> '' then
  begin
    if Index < 0 then Index := Add('');
    Put(Index, Names[Index] + NameValueSeparator + Value);
  end
  else
    if Index >= 0 then Delete(Index);
end;

{ TWideStringList }

destructor TWideStringList.Destroy;
begin
  FOnChange := nil;
  FOnChanging := nil;
  inherited Destroy;
  if FCount <> 0 then Finalize(FList^[0], FCount);
  FCount := 0;
  SetCapacity(0);
end;

function TWideStringList.Add(const S: WideString): Integer;
begin
  Result := AddObject(S, nil);
end;

function TWideStringList.AddObject(const S: WideString; AObject: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    if Find(S, Result) then
      case Duplicates of
        dupIgnore: Exit;
        dupError: Error(@SDuplicateString, 0);
      end;
  InsertItem(Result, S, AObject);
end;

procedure TWideStringList.Changed;
begin
  if (FUpdateCount = 0) and Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TWideStringList.Changing;
begin
  if (FUpdateCount = 0) and Assigned(FOnChanging) then
    FOnChanging(Self);
end;

procedure TWideStringList.Clear;
begin
  if FCount <> 0 then
  begin
    Changing;
    Finalize(FList^[0], FCount);
    FCount := 0;
    SetCapacity(0);
    Changed;
  end;
end;

procedure TWideStringList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Changing;
  Finalize(FList^[Index]);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TStringItem));
  Changed;
end;

procedure TWideStringList.Exchange(Index1, Index2: Integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) then Error(@SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then Error(@SListIndexError, Index2);
  Changing;
  ExchangeItems(Index1, Index2);
  Changed;
end;

procedure TWideStringList.ExchangeItems(Index1, Index2: Integer);
var
  Temp: Integer;
  Item1, Item2: PStringItem;
begin
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  Temp := Integer(Item1^.FString);
  Integer(Item1^.FString) := Integer(Item2^.FString);
  Integer(Item2^.FString) := Temp;
  Temp := Integer(Item1^.FObject);
  Integer(Item1^.FObject) := Integer(Item2^.FObject);
  Integer(Item2^.FObject) := Temp;
end;

function TWideStringList.Find(const S: WideString; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareStrings(FList^[I].FString, S);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function TWideStringList.Get(Index: Integer): WideString;
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Result := FList^[Index].FString;
end;

function TWideStringList.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function TWideStringList.GetCount: Integer;
begin
  Result := FCount;
end;

function TWideStringList.GetObject(Index: Integer): TObject;
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Result := FList^[Index].FObject;
end;

procedure TWideStringList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TWideStringList.IndexOf(const S: WideString): Integer;
begin
  if not Sorted then Result := inherited IndexOf(S) else
    if not Find(S, Result) then Result := -1;
end;

procedure TWideStringList.Insert(Index: Integer; const S: WideString);
begin
  InsertObject(Index, S, nil);
end;

procedure TWideStringList.InsertObject(Index: Integer; const S: WideString;
  AObject: TObject);
begin
  if Sorted then Error(@SSortedListError, 0);
  if (Index < 0) or (Index > FCount) then Error(@SListIndexError, Index);
  InsertItem(Index, S, AObject);
end;

procedure TWideStringList.InsertItem(Index: Integer; const S: WideString; AObject: TObject);
begin
  Changing;
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TStringItem));
  with FList^[Index] do
  begin
    Pointer(FString) := nil;
    FObject := AObject;
    FString := S;
  end;
  Inc(FCount);
  Changed;
end;

procedure TWideStringList.Put(Index: Integer; const S: WideString);
begin
  if Sorted then Error(@SSortedListError, 0);
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Changing;
  FList^[Index].FString := S;
  Changed;
end;

procedure TWideStringList.PutObject(Index: Integer; AObject: TObject);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Changing;
  FList^[Index].FObject := AObject;
  Changed;
end;

procedure TWideStringList.QuickSort(L, R: Integer; SCompare: TWideStringListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do Inc(I);
      while SCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TWideStringList.SetCapacity(NewCapacity: Integer);
begin
  ReallocMem(FList, NewCapacity * SizeOf(TStringItem));
  FCapacity := NewCapacity;
end;

procedure TWideStringList.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TWideStringList.SetUpdateState(Updating: Boolean);
begin
  if Updating then Changing else Changed;
end;

function StringListCompareStrings(List: TWideStringList; Index1, Index2: Integer): Integer;
begin
  Result := List.CompareStrings(List.FList^[Index1].FString,
                                List.FList^[Index2].FString);
end;

procedure TWideStringList.Sort;
begin
  CustomSort(StringListCompareStrings);
end;

procedure TWideStringList.CustomSort(Compare: TWideStringListSortCompare);
begin
  if not Sorted and (FCount > 1) then
  begin
    Changing;
    QuickSort(0, FCount - 1, Compare);
    Changed;
  end;
end;

function TWideStringList.CompareStrings(const S1, S2: WideString): Integer;
begin
  if CaseSensitive then
    Result := WideCompareStr(S1, S2)
  else
    Result := WideCompareText(S1, S2);
end;

procedure TWideStringList.SetCaseSensitive(const Value: Boolean);
begin
  if Value <> FCaseSensitive then
  begin
    FCaseSensitive := Value;
    if Sorted then Sort;
  end;
end;

initialization
  InitCharNextWFunc;
end.
