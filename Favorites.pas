unit Favorites;

interface

uses System.Classes, SysUtils, Controls, Bible, Htmlview, BibleQuoteUtils,
     Vcl.Dialogs, System.Contnrs, ExceptionFrm;

type
  TFavoriteAdd = function(const modEntry: TModuleEntry; tag: integer = -1; addBibleTab: Boolean = true): integer of object;
  TFavoriteDelete = function(const modEntry: TModuleEntry): Boolean of object;
  TFavoriteReplace = function(const oldMod, newMod: TModuleEntry): Boolean of object;
  TFavoriteInsert = function(newMe: TModuleEntry; ix: integer): integer of object;
  TForceLoadModules = procedure of object;

  TFavoriteModules = class
    mModuleEntries: TCachedModules;
    mExpectedCnt: integer;
    mLst: TStringList;
    mfnAddtoIface: TFavoriteAdd;
    mfnDelFromIface: TFavoriteDelete;
    mfnReplaceInIFace: TFavoriteReplace;
    mfnInsertIface: TFavoriteInsert;
    mfnForceLoadMods: TForceLoadModules;

    procedure SaveModules(const savePath: string);
    procedure LoadModules(modEntries: TCachedModules; const modulePath: string);
    procedure v2Load(modEntries: TCachedModules; const lst: TStringList);
    procedure v1Load(modEntries: TCachedModules; const lst: TStringList);

    function ReadPrefix(const lst: TStringList): integer;

    constructor Create(
      fnAddToIface: TFavoriteAdd;
      fnDelFromIFace: TFavoriteDelete;
      fnReplaceInIface: TFavoriteReplace;
      fnInsertIface: TFavoriteInsert;
      forceLoadModules: TForceLoadModules);

    destructor Destroy(); override;

    function AddModule(me: TModuleEntry): Boolean;
    function DeleteModule(me: TModuleEntry): Boolean;
    procedure Clear();
    function ReplaceModule(oldMe, newMe: TModuleEntry): Boolean;
    procedure xChg(me1, me2: TModuleEntry);
    function MoveItem(me: TModuleEntry; ix: integer): Boolean;
  end;

implementation

{ TBQFavoriteModules }

function TFavoriteModules.AddModule(me: TModuleEntry): Boolean;
var
  foundIx: integer;
  newMod: TModuleEntry;
begin
  Result := false;
  foundIx := mModuleEntries.FindByFolder(me.mShortPath);
  if foundIx >= 0 then
    Exit;
  newMod := TModuleEntry.Create(me);
  mModuleEntries.Add(newMod);
  mfnAddtoIface(newMod, integer(newMod), true);
  Result := true;
end;

function TFavoriteModules.DeleteModule(me: TModuleEntry): Boolean;
var
  foundIx: integer;
begin
  Result := false;
  foundIx := mModuleEntries.IndexOf(me);
  if foundIx < 0 then
    Exit;
  mfnDelFromIface(me);
  mModuleEntries.Delete(foundIx);
end;

procedure TFavoriteModules.Clear;
var
  i, C: integer;
begin
  C := mModuleEntries.Count - 1;
  try
    for i := 0 to C do
      mfnDelFromIface(TModuleEntry(mModuleEntries.Items[i]));
  except
    on E: Exception do
      BqShowException(E)
  end;
  mModuleEntries.Clear();
end;

constructor TFavoriteModules.Create(
  fnAddToIface: TFavoriteAdd;
  fnDelFromIFace: TFavoriteDelete;
  fnReplaceInIface: TFavoriteReplace;
  fnInsertIface: TFavoriteInsert;
  forceLoadModules: TForceLoadModules);
begin
  mfnAddtoIface := fnAddToIface;
  mfnDelFromIface := fnDelFromIFace;
  mfnReplaceInIFace := fnReplaceInIface;
  mfnInsertIface := fnInsertIface;
  mModuleEntries := TCachedModules.Create(true);
  mfnForceLoadMods := forceLoadModules;
end;

destructor TFavoriteModules.Destroy;
begin
  try
    FreeAndNil(mModuleEntries);
    FreeAndNil(mLst);
  except
    on E: Exception do
      BqShowException(E);
  end;
  inherited;
end;

procedure TFavoriteModules.LoadModules(modEntries: TCachedModules; const modulePath: string);
var
  vrs: integer;
  doload: Boolean;
begin
  if not Assigned(mLst) then
  begin
    mLst := TStringList.Create();
    doload := true
  end
  else
    doload := false;
  try
    Clear();
    if doload then
    begin
      mExpectedCnt := 0;
      mLst.LoadFromFile(modulePath);
    end;
    if mLst.Count <= 0 then
      Exit;
    vrs := ReadPrefix(mLst);
    if vrs = 2 then
      v2Load(modEntries, mLst)
    else
    begin
      v1Load(modEntries, mLst);
    end;

  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;

end;

function TFavoriteModules.MoveItem(me: TModuleEntry; ix: integer): Boolean;
var
  si: integer;
begin
  Result := false;
  try
    si := mModuleEntries.IndexOf(me);
    if si < 0 then
      Exit;
    mModuleEntries.Move(si, ix);

    mfnDelFromIface(me);
    mfnInsertIface(me, ix);
  except
    on E: Exception do
      BqShowException(E);
  end;
end;

function TFavoriteModules.ReadPrefix(const lst: TStringList): integer;
var
  ws: string;
begin
  ws := lst[0];
  if (ws <> 'v2.0') or (lst.Count < 2) then
  begin
    Result := 0;
    mExpectedCnt := 0;
  end
  else
  begin
    mExpectedCnt := StrToIntDef(lst[1], 0);
    Result := 2;
  end;
end;

function TFavoriteModules.ReplaceModule(oldMe, newMe: TModuleEntry): Boolean;
var
  ix: integer;
begin
  ix := mModuleEntries.IndexOf(oldMe);
  if ix < 0 then
  begin
    Result := false;
    Exit
  end;
  mfnReplaceInIFace(oldMe, newMe);
  mModuleEntries.Items[ix] := newMe;
  Result := true;
end;

procedure TFavoriteModules.SaveModules(const savePath: string);
var
  i, C: integer;
  me: TModuleEntry;
  lst: TStringList;
begin
  C := mModuleEntries.Count - 1;
  lst := TStringList.Create;
  try
    lst.Add('v2.0');
    lst.Add(IntToStr(C));

    for i := 0 to C do
    begin
      try

        me := TModuleEntry(mModuleEntries.Items[i]);
        lst.Add('***');
        lst.Add(me.mFullName);
        lst.Add(me.mShortName);
      except
        on E: Exception do
          BqShowException(E);
      end;

    end;
  except
  end;
  lst.SaveToFile(savePath, TEncoding.UTF8);
  lst.Free();
end;

procedure TFavoriteModules.v1Load(modEntries: TCachedModules; const lst: TStringList);
var
  i, C: integer;
  wsModName, wsModShortName: string;
  me: TModuleEntry;
begin
  C := lst.Count - 1;
  for i := 0 to C do
  begin
    try
      me := modEntries.ResolveModuleByNames(lst[i], '');
      if not Assigned(me) then
      begin
        ShowMessageFmt('Can''t resolve favourite module:'#13#10' %s(%s)', [wsModName, wsModShortName]);
      end
      else
        AddModule(me);
    except
      on E: Exception do
      begin
        BqShowException(E, 'lst[i]=' + lst[i]);
      end;
    end;
  end;
end;

procedure TFavoriteModules.v2Load(modEntries: TCachedModules; const lst: TStringList);
var
  i, C, prevI: integer;
  modName, modShortName: string;
  me: TModuleEntry;
  modsLoaded: Boolean;
begin
  C := lst.Count - 1;
  i := 3;
  modsLoaded := false;
  while i <= C do
  begin
    modName := lst[i];
    prevI := i;
    inc(i);
    if (i <= C) then
    begin
      modShortName := lst[i];
      inc(i);
    end
    else
      modShortName := '';
    if modShortName = '***' then
    begin
      modShortName := '';
    end;
    try
      me := modEntries.ResolveModuleByNames(modName, modShortName);

      if not Assigned(me) then
      begin
        if not modsLoaded then
        begin
          mfnForceLoadMods();
          i := prevI;
          modsLoaded := true;
          continue
        end
        else
          ShowMessageFmt('Can''t resolve favourite module:'#13#10' %s(%s)', [modName, modShortName]);
      end
      else
        AddModule(me);

      if (i <= C) and (lst[i] <> '***') then
        repeat
          inc(i);
        until (i > C) or (lst[i] = '***');

      inc(i);
      if i > C then
        break;
    except
      on E: Exception do
      begin
        BqShowException(E, 'wsModName=' + modName);
      end;
    end;
  end; // line iteration loop

end;

procedure TFavoriteModules.xChg(me1, me2: TModuleEntry);
begin
  mfnReplaceInIFace(me2, me1);
  mfnReplaceInIFace(me1, me2);

  mModuleEntries.Exchange(mModuleEntries.IndexOf(me1), mModuleEntries.IndexOf(me2));
end;

end.
