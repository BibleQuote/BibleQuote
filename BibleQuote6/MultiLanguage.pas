unit MultiLanguage;

interface

uses
  Windows, Messages, SysUtils, Classes, 
  Graphics, Controls,
  Forms, TntForms, Dialogs, 
  
  
  TypInfo,
  string_procs, WCharReader,WideStrings;

type
  TMultiLanguage = class (TComponent)
  private
    { Private declarations }
    FLines: TWideStrings;
    FIniFile: WideString;
    FSeparator: WideString;
  protected
    { Protected declarations }
    procedure _LoadIniFile(value: WideString);
    procedure SetProperty (AComponent : TComponent; sProperty, sValue : WideString);
    procedure SetStringsProperty (
      AComponent : TComponent;
      PropInfo   : PPropInfo;
      sValues    : WideString
    );
  public
    { Public declarations }
    class function IsStringProperty (PropInfo : PPropInfo) : Boolean;
    class function IsIntegerProperty (PropInfo : PPropInfo) : Boolean;
    function LoadIniFile (value: WideString):boolean;

    property IniFile: WideString read FIniFile write _LoadIniFile;
    procedure SaveToFile;

    function Say(s: WideString): WideString; // default = s
    function SayDefault(s,def: WideString): WideString; // default = def
    function GetIntDefault(valueTag:WideString; defValue:integer=0):integer;
    function ReadString(section,s,def: WideString): WideString;
    function Learn(s, value: WideString): boolean;overload;
    function Learn(s:WideString; val:integer):boolean;overload;
    procedure TranslateForm(form: TTntForm);

    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Separator: WideString read FSeparator write FSeparator;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TMultiLanguage]);
end;

constructor TMultiLanguage.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines := TWideStringList.Create;
  FIniFile := '';
  FSeparator := ',';
end;

destructor TMultiLanguage.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

function TMultiLanguage.GetIntDefault(valueTag: WideString;
  defValue: integer): integer;
  var val:AnsiString;
begin
val:=Say(valueTag);
result:=StrToIntDef(val, defValue);
end;

procedure TMultiLanguage._LoadIniFile(value: WideString);
begin
LoadIniFile(value)
end;

procedure TMultiLanguage.SaveToFile;
begin
  WChar_WriteTextFile (FIniFile, FLines);
end;

function TMultiLanguage.Learn(s, value: WideString): boolean;
var
  i: integer;
  tmp: WideString;
begin
  Result := false;

  for i:=0 to FLines.Count-1 do
  begin
    tmp := IniStringFirstPart(FLines[i]);
    if tmp = s then
    begin
      Result := true;
      FLines[i] := tmp + ' = ' + value;
      break;
    end;
  end;

  if not Result then FLines.Add(s + ' = ' + value);
end;

function TMultiLanguage.Learn(s: WideString; val: integer): boolean;
begin
result:=Learn(s, inttostr(val));
end;

function TMultiLanguage.LoadIniFile(value: WideString): boolean;
begin
//  FIniFile := StrReplace (value, '&', '');
  FIniFile := value;
  result:=false;
  if not FileExists(value) then exit;
  try
    FLines.Free;
    FLines := WChar_ReadTextFileToTWideStrings (value);
  except
    raise Exception.CreateFmt('TMultiLanguage.LoadIniFile: Error loading file %s',
      [value]);
  end;
  result:=true;
end;

function TMultiLanguage.Say(s: WideString): WideString;
var
  i,j: integer;
  tmp: WideString;
begin
  Result := s;

  for i:=0 to FLines.Count-1 do
  if IniStringFirstPart(FLines[i]) = s then
  begin
    tmp := IniStringSecondPart(FLines[i]);

    for j:=i+1 to FLines.Count-1 do
    begin
      if FirstWord(FLines[j]) = '='
      then tmp := tmp + ' ' + IniStringSecondPart(FLines[j])
      else break;
    end;

    Result := tmp;
    break;
  end;
end;

function TMultiLanguage.ReadString(section,s,def: WideString): WideString;
var
  cnt,i,j, lineCount: integer;
  tmp: WideString;
begin
  Result := def;
  lineCount:=FLines.Count;
  // find section
  cnt := 0;
  while (cnt<lineCount) and (Trim(FLines[cnt]) <> ('[' + section + ']')) do Inc(cnt);
  if cnt=lineCount then exit;
  for i:=cnt+1 to FLines.Count-1 do
  begin
    if IniStringFirstPart(FLines[i]) = s then
    begin
      tmp := IniStringSecondPart(FLines[i]);

      for j:=i+1 to FLines.Count-1 do
      begin
        if FirstWord(FLines[j]) = '='
        then tmp := tmp + ' ' + IniStringSecondPart(FLines[j])
        else break;
      end;

      Result := tmp;
      break;
    end;

    if Copy(FLines[i],1,1) = '[' then break; // new section;
  end;
end;

function TMultiLanguage.SayDefault(s,def: WideString): WideString;
var
  i,j: integer;
  tmp: WideString;
begin
  Result := def;

  for i:=0 to FLines.Count-1 do
  if IniStringFirstPart(FLines[i]) = s then
  begin
    tmp := IniStringSecondPart(FLines[i]);

    for j:=i+1 to FLines.Count-1 do
    begin
      if FirstWord(FLines[j]) = '='
      then tmp := tmp + ' ' + IniStringSecondPart(FLines[j])
      else break;
    end;

    Result := tmp;
    break;
  end;
end;

class function TMultiLanguage.IsStringProperty(PropInfo : PPropInfo) : Boolean;
var aPropInfo : TPropInfo;
    ppType    : PPTypeInfo;
    pType     : PTypeInfo;
    TypeInfo  : TTypeInfo;
begin
  aPropInfo   := PropInfo^;
  ppType      := aPropInfo.PropType;
  pType       := ppType^;
  TypeInfo    := pType^;
  if (TypeInfo.Kind = tkString) or
     (TypeInfo.Kind = tkLString) or
     (TypeInfo.Kind = tkWString)
  then
    Result := True
  else
    Result := False;
end;

class function TMultiLanguage.IsIntegerProperty(PropInfo : PPropInfo) : Boolean;
var aPropInfo : TPropInfo;
    ppType    : PPTypeInfo;
    pType     : PTypeInfo;
    TypeInfo  : TTypeInfo;
begin
  aPropInfo   := PropInfo^;
  ppType      := aPropInfo.PropType;
  pType       := ppType^;
  TypeInfo    := pType^;
  Result      :=(TypeInfo.Kind = tkInteger);
end;

// ??? Нужна ли здесь замена на TWideStringList?
procedure TMultiLanguage.SetStringsProperty (
  AComponent : TComponent;
  PropInfo   : PPropInfo;
  sValues    : WideString
);
var AStrings : TWideStringList;
    sBuffer  : WideString;
begin
  AStrings := TWideStringList.Create;

  while (Pos(FSeparator, sValues) > 0) do
  begin
    sBuffer := Copy (sValues, 1, Pos (FSeparator, sValues)-1);
    Delete (sValues, 1, Pos (FSeparator, sValues) - 1 + Length (FSeparator));
    AStrings.Add (Trim (sBuffer));
  end;
  
  if (Length (Trim (sValues)) > 0) then
    AStrings.Add (Trim (sValues));

  SetOrdProp (AComponent, PropInfo, LongInt (Pointer (AStrings)));

  AStrings.Free;
end;

procedure TMultiLanguage.SetProperty(AComponent: TComponent; sProperty, sValue: WideString);
var
  PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo(AComponent.ClassInfo, sProperty);

  if (PropInfo <> Nil) then
  begin
    if (IsStringProperty(PropInfo)) then
      SetWideStrProp(AComponent, PropInfo, sValue)
    else if (IsIntegerProperty(PropInfo)) then
      SetOrdProp(AComponent, PropInfo, StrToInt(sValue))
    else
      SetStringsProperty(AComponent, PropInfo, sValue);
  end;
end;

procedure TMultiLanguage.TranslateForm(form: TTntForm);
var
  i: integer;
  s, sname: WideString;
begin
  with form do
  for i:=0 to ComponentCount-1 do
  begin
    sname := form.Name + '.' + (Components[i]).Name;

    if (Components[i]).Name = 'miActions' then
      s := s;

    s := Say(sname + '.Caption');
    if s <> sname + '.Caption' then
      SetProperty(Components[i], 'Caption', s);

    s := Say(sname + '.Hint');
    if s <> sname + '.Hint' then
      SetProperty(Components[i], 'Hint', s);

   s:=Say(sname+'.TabHint');
   if s <> sname + '.TabHint' then
      SetProperty(Components[i], 'TabHint', s);

    s := Say(sname + '.Items');
    if s <> sname + '.Items' then
      SetProperty(Components[i], 'Items', s);

  end;

  sname := form.Name;
  s := Say (sname + '.Caption');
  if s <> sname + '.Caption' then
    form.Caption := s;
end;

end.
