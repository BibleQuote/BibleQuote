unit Types.Extensions;

interface

uses
  System.TypInfo, System.SysUtils;

type
  TExtensions = class(TObject)
  private
  public
    class function EnumToInt<T>(const EnumValue: T): Integer;
    class function EnumToString<T>(EnumValue: T): string;
    class function StringToEnum<T>(const Str: string): T; overload;
    class function StringToEnum<T>(const Str: string; default: T): T; overload;
  end;

implementation

{ TExtensions }

class function TExtensions.EnumToInt<T>(const EnumValue: T): Integer;
begin
  Result := 0;
  Move(EnumValue, Result, sizeOf(EnumValue));
end;

class function TExtensions.EnumToString<T>(EnumValue: T): string;
begin
  Result := GetEnumName(TypeInfo(T), EnumToInt(EnumValue));
end;

class function TExtensions.StringToEnum<T>(const Str: string): T;
var
  TypeInf: PTypeInfo;
  Value:   Integer;
  PValue:  Pointer;
begin
  typeInf := PTypeInfo(TypeInfo(T));
  if typeInf^.Kind <> tkEnumeration then
    raise Exception.Create('Invalid cast');

  Value  := GetEnumValue(TypeInfo(T), Str);

  if Value = -1 then
    raise Exception.CreateFmt('Enum %s not found', [Str]);

  PValue := @Value;
  Result := T(PValue^);
end;

class function TExtensions.StringToEnum<T>(const Str: string; default: T): T;
var
  TypeInf: PTypeInfo;
  Value:   Integer;
  PValue:  Pointer;
begin
  Result := default;

  typeInf := PTypeInfo(TypeInfo(T));
  if typeInf^.Kind = tkEnumeration then
  begin
    Value  := GetEnumValue(TypeInfo(T), Str);

    if Value = -1 then
      Exit;

    PValue := @Value;
    Result := T(PValue^);
  end;
end;

end.
