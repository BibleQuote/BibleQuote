unit MultiLanguage;

interface

uses
  Windows, Messages, SysUtils, Classes, IOProcs,
  Graphics, Controls,
  Forms, Dialogs,

  TypInfo, StringProcs;

type
  TMultiLanguage = class(TComponent)
  private
    FLines: TStrings;
    FIniFile: string;
    FSeparator: string;

  protected
    procedure _LoadIniFile(value: string);
    procedure SetProperty(AComponent: TComponent; sProperty, sValue: string);
    procedure SetStringsProperty(AComponent: TComponent; PropInfo: PPropInfo; sValues: string);

  public
    class function IsStringProperty(PropInfo: PPropInfo): Boolean;
    class function IsIntegerProperty(PropInfo: PPropInfo): Boolean;
    function LoadIniFile(value: string): Boolean;

    property IniFile: string read FIniFile write _LoadIniFile;
    procedure SaveToFile;

    function Say(s: string): string; // default = s
    function SayDefault(s, def: string): string; // default = def
    function GetIntDefault(valueTag: string; defValue: integer = 0): integer;
    function ReadString(section, s, def: string): string;
    function Learn(s, value: string): Boolean; overload;
    function Learn(s: string; val: integer): Boolean; overload;
    procedure TranslateControl(ctrl: TWinControl; fname: string = '');

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Separator: string read FSeparator write FSeparator;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TMultiLanguage]);
end;

constructor TMultiLanguage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines := TStringList.Create;
  FIniFile := '';
  FSeparator := ',';
end;

destructor TMultiLanguage.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

function TMultiLanguage.GetIntDefault(valueTag: string;
  defValue: integer): integer;
var
  val: string;
begin
  val := Say(valueTag);
  result := StrToIntDef(val, defValue);
end;

procedure TMultiLanguage._LoadIniFile(value: string);
begin
  LoadIniFile(value)
end;

procedure TMultiLanguage.SaveToFile;
begin
  WriteTextFile(FIniFile, FLines);
end;

function TMultiLanguage.Learn(s, value: string): Boolean;
var
  i: integer;
  tmp: string;
begin
  result := false;

  for i := 0 to FLines.Count - 1 do
  begin
    tmp := IniStringFirstPart(FLines[i]);
    if tmp = s then
    begin
      result := true;
      FLines[i] := tmp + ' = ' + value;
      break;
    end;
  end;

  if not result then
    FLines.Add(s + ' = ' + value);
end;

function TMultiLanguage.Learn(s: string; val: integer): Boolean;
begin
  result := Learn(s, inttostr(val));
end;

function TMultiLanguage.LoadIniFile(value: string): Boolean;
begin
  FIniFile := value;
  result := false;
  if not FileExists(value) then
    exit;
  try
    FLines.Free;
    FLines := ReadTextFileLines(value, TEncoding.UTF8);
  except
    raise Exception.CreateFmt
      ('TMultiLanguage.LoadIniFile: Error loading file %s', [value]);
  end;
  result := true;
end;

function TMultiLanguage.Say(s: string): string;
var
  i, j: integer;
  tmp: string;
begin
  result := s;

  for i := 0 to FLines.Count - 1 do
    if IniStringFirstPart(FLines[i]) = s then
    begin
      tmp := IniStringSecondPart(FLines[i]);

      for j := i + 1 to FLines.Count - 1 do
      begin
        if FirstWord(FLines[j]) = '=' then
          tmp := tmp + ' ' + IniStringSecondPart(FLines[j])
        else
          break;
      end;

      result := tmp;
      break;
    end;
end;

function TMultiLanguage.ReadString(section, s, def: string): string;
var
  cnt, i, j, lineCount: integer;
  tmp: string;
begin
  result := def;
  lineCount := FLines.Count;

  // find section
  cnt := 0;
  while (cnt < lineCount) and (Trim(FLines[cnt]) <> ('[' + section + ']')) do
    Inc(cnt);

  if cnt = lineCount then
    exit;

  for i := cnt + 1 to FLines.Count - 1 do
  begin
    if IniStringFirstPart(FLines[i]) = s then
    begin
      tmp := IniStringSecondPart(FLines[i]);

      for j := i + 1 to FLines.Count - 1 do
      begin
        if FirstWord(FLines[j]) = '=' then
          tmp := tmp + ' ' + IniStringSecondPart(FLines[j])
        else
          break;
      end;

      result := tmp;
      break;
    end;

    if Copy(FLines[i], 1, 1) = '[' then
      break; // new section;
  end;
end;

function TMultiLanguage.SayDefault(s, def: string): string;
var
  i, j: integer;
  tmp: string;
begin
  result := def;

  for i := 0 to FLines.Count - 1 do
    if IniStringFirstPart(FLines[i]) = s then
    begin
      tmp := IniStringSecondPart(FLines[i]);

      for j := i + 1 to FLines.Count - 1 do
      begin
        if FirstWord(FLines[j]) = '=' then
          tmp := tmp + ' ' + IniStringSecondPart(FLines[j])
        else
          break;
      end;

      result := tmp;
      break;
    end;
end;

class function TMultiLanguage.IsStringProperty(PropInfo: PPropInfo): Boolean;
var
  aPropInfo: TPropInfo;
  ppType: PPTypeInfo;
  pType: PTypeInfo;
  TypeInfo: TTypeInfo;
begin
  aPropInfo := PropInfo^;
  ppType := aPropInfo.PropType;
  pType := ppType^;
  TypeInfo := pType^;
  if (TypeInfo.Kind = tkString) or (TypeInfo.Kind = tkLString) or
    (TypeInfo.Kind = tkWString) or (TypeInfo.Kind = tkUString) then
    result := true
  else
    result := false;
end;

class function TMultiLanguage.IsIntegerProperty(PropInfo: PPropInfo): Boolean;
var
  aPropInfo: TPropInfo;
  ppType: PPTypeInfo;
  pType: PTypeInfo;
  TypeInfo: TTypeInfo;
begin
  aPropInfo := PropInfo^;
  ppType := aPropInfo.PropType;
  pType := ppType^;
  TypeInfo := pType^;
  result := (TypeInfo.Kind = tkInteger);
end;

procedure TMultiLanguage.SetStringsProperty(AComponent: TComponent; PropInfo: PPropInfo; sValues: string);
var
  AStrings: TStringList;
  sBuffer: string;
begin
  AStrings := TStringList.Create;

  while (Pos(FSeparator, sValues) > 0) do
  begin
    sBuffer := Copy(sValues, 1, Pos(FSeparator, sValues) - 1);
    Delete(sValues, 1, Pos(FSeparator, sValues) - 1 + Length(FSeparator));
    AStrings.Add(Trim(sBuffer));
  end;

  if (Length(Trim(sValues)) > 0) then
    AStrings.Add(Trim(sValues));

  SetOrdProp(AComponent, PropInfo, LongInt(Pointer(AStrings)));

  AStrings.Free;
end;

procedure TMultiLanguage.SetProperty(AComponent: TComponent; sProperty, sValue: string);
var
  PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo(AComponent.ClassInfo, sProperty);

  if (PropInfo <> Nil) then
  begin
    if (IsStringProperty(PropInfo)) then
      SetStrProp(AComponent, PropInfo, sValue)
    else if (IsIntegerProperty(PropInfo)) then
      SetOrdProp(AComponent, PropInfo, StrToInt(sValue))
    else
      SetStringsProperty(AComponent, PropInfo, sValue);
  end;
end;

procedure TMultiLanguage.TranslateControl(ctrl: TWinControl; fname: string = '');
var
  i: integer;
  s, sname: string;
begin
  with ctrl do
    for i := 0 to ComponentCount - 1 do
    begin
      if (Length(fname) = 0) then
        fname := ctrl.Name;

      sname := fname + '.' + (Components[i]).Name;

      if (Components[i]).Name = 'miActions' then
        s := s;

      s := Say(sname + '.Caption');
      if s <> sname + '.Caption' then
        SetProperty(Components[i], 'Caption', s);

      s := Say(sname + '.Hint');
      if s <> sname + '.Hint' then
        SetProperty(Components[i], 'Hint', s);

      s := Say(sname + '.TabHint');
      if s <> sname + '.TabHint' then
        SetProperty(Components[i], 'TabHint', s);

      s := Say(sname + '.Items');
      if s <> sname + '.Items' then
        SetProperty(Components[i], 'Items', s);

    end;

  if (ctrl is TForm) then
  begin
    sname := fname;
    s := Say(sname + '.Caption');
    if s <> sname + '.Caption' then
      (ctrl as TForm).Caption := s;
  end;
end;

end.
