unit SysHot;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WComp;

type
  TWMHotKey = record
    Msg: Cardinal;
    idHotKey: Word;
    Modifiers: Integer;
    VirtKey : Integer;
  end;

  THKModifier = (hkShift, hkCtrl, hkAlt, hkExt);
  THKModifiers = set of THKModifier;

  TVirtKey =  (vkNone, vkCancel, vkBack, vkTab, vkClear, vkReturn, vkPause, vkCapital, vkEscape,
               vkSpace, vkPrior, vkNext, vkEnd, vkHome, vkLeft, vkUp, vkRight, vkDown,
               vkSelect, vkExecute, vkSnapshot, vkInsert, vkDelete, vkHelp,
               vk0, vk1, vk2, vk3, vk4, vk5, vk6, vk7, vk8, vk9,
               vkA, vkB, vkC, vkD, vkE, vkF, vkG, vkH, vkI, vkJ, vkK, vkL, vkM,
               vkN, vkO, vkP, vkQ, vkR, vkS, vkT, vkU, vkV, vkW, vkX, vkY, vkZ,
               vkNumpad0, vkNumpad1, vkNumpad2, vkNumpad3, vkNumpad4,
               vkNumpad5, vkNumpad6, vkNumpad7, vkNumpad8, vkNumpad9,
               vkMultiply, vkAdd, vkSeparator, vkSubtract, vkDecimal, vkDivide,
               vkF1, vkF2, vkF3, vkF4, vkF5, vkF6, vkF7, vkF8, vkF9, vkF10, vkF11, vkF12,
               vkF13, vkF14, vkF15, vkF16, vkF17, vkF18, vkF19, vkF20, vkF21, vkF22, vkF23, vkF24,
               vkNumlock, vkScroll);

  PHotKeyItem = ^THotKeyItem;
  THotKeyItem = record
    Modifiers : THKModifiers;
    VirtKey   : TVirtKey;
    Registered: Boolean;
  end;

  THotKeyEvent = procedure(Sender: TObject; Index: Integer) of object;

  TSysHotKey = class(TWindowedComponent)
  private
    { property variables }
    FActive  : Boolean;
    { event variables }
    FOnHotKey: THotKeyEvent;
    { private variables }
    FList    : TList;
    { property setting/getting routines }
    procedure SetActive(Value : Boolean);
    function  GetCount: Integer;
  protected
    { method overrides }
    procedure Loaded; override;
    { message handlers }
    procedure wmHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure wmDestroy(var Msg: TWMDestroy); message WM_DESTROY;
    { private routines }
    function  ModifiersToFlag(Modifiers : THKModifiers): UInt;
    procedure RegisterHotKeyNr(Index : Integer);
    procedure UnregisterHotKeyNr(Index : Integer);
    procedure RegisterHotKeys;
    procedure UnregisterHotKeys;
  public
    { constructor / destructor overrides }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { methods }
    procedure Add(Item: THotKeyItem);
    procedure AddHotKey(VirtKey: TVirtKey; Modifiers: THKModifiers);
    procedure Clear;
    procedure Delete(Index : Integer);
    function  Get(Index: Integer): THotKeyItem;
    procedure Put(Index: Integer; Item: THotKeyItem);
    { runtime only properties }
    property HotKeys[Index: Integer]: THotKeyItem read Get write Put; default;
    property HotKeyCount: integer read GetCount;
  published
    { properties }
    property Active: Boolean read FActive write SetActive;
    { events }
    property OnHotKey: THotKeyEvent read FOnHotKey write FOnHotKey;
  end;

function KeyToVirtKey(const Key: Char): TVirtKey;
function HotKeyItem(const VirtKey: TVirtKey; Modifiers: THKModifiers): THotKeyItem;

procedure Register;

implementation

var
  VirtKeys : array[TVirtKey] of UInt =
             ($00, $03, $08, $09, $0C, $0D, $13, $14, $1B,
              $20, $21, $22, $23, $24, $25, $26, $27, $28,
              $29, $2B, $2C, $2D, $2E, $2F,
              $30, $31, $32, $33, $34, $35, $36, $37, $38, $39,
              $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A,
              $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $53, $54,
              $55, $56, $57, $58, $59, $5A,
              $60, $61, $62, $63, $64, $65, $66, $67, $68, $69,
              $6A, $6B, $6C, $6D, $6E, $6F,
              $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B,
              $7C, $7D, $7E, $7F, $80, $81, $82, $83, $84, $85, $86, $87,
              $90, $91);

procedure Register;
begin
  RegisterComponents('Samples', [TSysHotkey]);
end;

function KeyToVirtKey(const Key: Char): TVirtKey;
var
  i     : TVirtKey;
  KeyVal: UInt;
begin
  Result := TVirtKey(0);
  KeyVal := Ord(UpperCase(Key)[1]);
  for i:= Low(TVirtKey) to High(TVirtKey) do
   if KeyVal = VirtKeys[i] then
    begin
      Result := TVirtKey(i);
      Exit;
    end;
end;

function HotKeyItem(const VirtKey: TVirtKey; Modifiers: THKModifiers): THotKeyItem;
begin
  Result.VirtKey := VirtKey;
  Result.Modifiers := Modifiers;
  Result.Registered := False;
end;

{ TSysHotKey }

constructor TSysHotKey.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FList := TList.Create;
end;

destructor TSysHotKey.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TSysHotKey.Loaded;
begin
  inherited Loaded;
  if Active then RegisterHotKeys;
end;

procedure TSysHotKey.SetActive(Value : Boolean);
begin
  if FActive<>Value then
   begin
     FActive := Value;
     if Active then RegisterHotKeys else UnregisterHotKeys;
   end;
end;

procedure TSysHotKey.wmHotKey(var Msg: TWMHotKey);
begin
  if Assigned(FOnHotKey) then FOnHotKey(Self, Msg.idHotKey);
end;

function TSysHotKey.ModifiersToFlag(Modifiers : THKModifiers): UInt;
begin
  Result := 0;
  if hkShift in Modifiers then Result := Result or MOD_SHIFT;
  if hkCtrl  in Modifiers then Result := Result or MOD_CONTROL;
  if hkAlt   in Modifiers then Result := Result or MOD_ALT;
  if hkExt   in Modifiers then Result := Result or MOD_WIN;
end;

procedure TSysHotKey.RegisterHotKeyNr(Index : Integer);
begin
  with PHotKeyItem(FList.Items[Index])^ do
    Registered := WordBool(RegisterHotKey(Handle, Index, ModifiersToFlag(Modifiers), VirtKeys[VirtKey]));
end;

procedure TSysHotKey.UnRegisterHotKeyNr(Index : Integer);
begin
  with PHotKeyItem(FList.Items[Index])^ do
   if Registered then
    begin
      UnregisterHotKey(Handle, Index);
      Registered := False;
    end;
end;

procedure TSysHotKey.RegisterHotKeys;
var
  I : integer;
begin
  for I:=0 to FList.Count-1 do
   RegisterHotKeyNr(I);
end;

procedure TSysHotKey.UnregisterHotKeys;
var
  I : integer;
begin
  for I:=0 to FList.Count-1 do
   UnregisterHotKeyNr(I);
end;

procedure TSysHotKey.wmDestroy(Var Msg : TWMDestroy);
begin
  Active := False;
  inherited;
end;

procedure TSysHotKey.Add(Item: THotKeyItem);
begin
  AddHotKey(Item.VirtKey, Item.Modifiers);
end;

procedure TSysHotKey.AddHotKey(VirtKey: TVirtKey; Modifiers: THKModifiers);
var
  p   : PHotKeyItem;
  Item: Integer;
begin
  p := PHotKeyItem(AllocMem(sizeof(THotKeyItem)));
  p^.VirtKey := VirtKey;
  p^.Modifiers := Modifiers;
  Item := FList.Add(p);
  if Active then RegisterHotKeyNr(Item);
end;

procedure TSysHotKey.Clear;
var
  I : integer;
begin
  if Active then UnregisterHotKeys;
  for I:=0 to FList.Count-1 do
   FreeMem(FList.Items[I]);
  FList.Clear;
end;

procedure TSysHotKey.Delete(Index : Integer);
begin
  if Active then UnregisterHotKeyNr(Index);
  FreeMem(FList.Items[Index]);
  FList.Delete(Index);
  FList.Pack;
end;

function TSysHotKey.Get(Index: Integer): THotKeyItem;
begin
  Result := THotKeyItem(FList.Items[Index]^);
end;

procedure TSysHotKey.Put(Index: Integer; Item: THotKeyItem);
begin
  if Active then UnregisterHotKeyNr(Index);
  with THotKeyItem(FList.Items[Index]^) do
   begin
     VirtKey := Item.VirtKey;
     Modifiers := Item.Modifiers;
   end;
  if Active then RegisterHotKeyNr(Index);
end;

function TSysHotKey.GetCount: integer;
begin
  Result := FList.Count;
end;

end.
