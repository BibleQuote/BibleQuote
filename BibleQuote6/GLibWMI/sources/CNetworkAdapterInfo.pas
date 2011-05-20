{ 
TNetworkAdapterInfo  Component Version 1.6b - Suite GLib 
Copyright (©) 2009,  by Germán Estévez (Neftalí) 
 
  Representa conexiones de red activas en un entorno windows.
 
Utilización/Usage: 
  Basta con "soltar" el componente y activarlo. 
 
  Place the component in the form and active it. 
 
  MSDN Info: 
  http://msdn.microsoft.com/en-us/library/aa394220(VS.85).aspx 
 
========================================================================= 
IMPORTANTE PROGRAMADORES: Por favor, si tienes comentarios, mejoras, ampliaciones, 
  errores y/o cualquier otro tipo de sugerencia envíame un mail a: 
  german_ral@hotmail.com 
 
IMPORTANT PROGRAMMERS: please, if you have comments, improvements, enlargements, 
errors and/or any another type of suggestion send a mail to: 
german_ral@hotmail.com 
========================================================================= 
 
@author Germán Estévez (Neftalí) 
@web  http://neftali.clubDelphi.com   -  http://neftali-mirror.site11.com/
@cat Package GLib 
} 
unit CNetworkAdapterInfo; 
 
{ 
========================================================================= 
 
  TNetworkAdapterInfo.pas 
 
  Componente 
 
======================================================================== 
  Historia de las Versiones 
------------------------------------------------------------------------ 
 
  19/01/2010    * Creación. 
 
========================================================================= 
 
  Errores detectados no corregidos 
 
========================================================================= 
} 
 
//========================================================================= 
// 
// I N T E R F A C E 
// 
//========================================================================= 
interface 
 
uses 
  Classes, Controls, CWMIBase; 
 
type 
  //: Clase para definir las propiedades del componente.
  TNetworkAdapterProperties = class(TPersistent)
  private
    FAccessMask:Longword;
    FCaption:string;
    FComment:string;
    FConnectionState:string;
    FConnectionType:string;
    FDescription:string;
    FDisplayType:string;
    FInstallDate:TDateTime;
    FLocalName:string;
    FName:string;
    FPersistent:boolean;
    FProviderName:string;
    FRemoteName:string;
    FRemotePath:string;
    FResourceType:string;
    FStatus:string;
    FUserName:string;
  private
  public

// {GET_ENUM}

  published
    property AccessMask:Longword read FAccessMask write FAccessMask stored False;
    property Caption:string read FCaption write FCaption stored False;
    property Comment:string read FComment write FComment stored False;
    property ConnectionState:string read FConnectionState write FConnectionState stored False;
    property ConnectionType:string read FConnectionType write FConnectionType stored False;
    property Description:string read FDescription write FDescription stored False;
    property DisplayType:string read FDisplayType write FDisplayType stored False;
    property InstallDate:TDateTime read FInstallDate write FInstallDate stored False;
    property LocalName:string read FLocalName write FLocalName stored False;
    property Name:string read FName write FName stored False;
    property Persistent:boolean read FPersistent write FPersistent stored False;
    property ProviderName:string read FProviderName write FProviderName stored False;
    property RemoteName:string read FRemoteName write FRemoteName stored False;
    property RemotePath:string read FRemotePath write FRemotePath stored False;
    property ResourceType:string read FResourceType write FResourceType stored False;
    property Status:string read FStatus write FStatus stored False;
    property UserName:string read FUserName write FUserName stored False;
  end;

  //: Implementación para el acceso vía WMI a la clase Win32_NetworkAdapter
  TNetworkAdapterInfo = class(TWMIBase)
  private
    fConnected:boolean;
    FNetworkAdapterProperties: TNetworkAdapterProperties;
  protected
    //: Rellenar las propiedades.
    procedure FillProperties(AIndex:integer); override;
    // propiedad Active
    procedure SetActive(const Value: Boolean); override;
    //: Clase para el componente.
    function GetWMIClass():string; override;
    //: Obtener el root.
    function GetWMIRoot():string; override;
    //: Limpiar las propiedades
    procedure ClearProps(); override;
  public
    // redefinido el constructor
    constructor Create(AOwner: TComponent); override;
    //: destructor
    destructor Destroy; override;
  published
    // propiedades de la NetworkAdapter
    property NetworkAdapterProperties:TNetworkAdapterProperties read FNetworkAdapterProperties
      write FNetworkAdapterProperties;
  end;

// {CONST_ENUM}

    
//========================================================================= 
// 
// I M P L E M E N T A T I O N 
// 
//========================================================================= 
implementation 
  
uses 
  {Generales} Forms, Types, Windows, SysUtils, 
  {GLib} UProcedures, UConstantes, Dialogs; 
 
  
{ TNetworkAdapter } 
{-------------------------------------------------------------------------------} 
// Limpiar las propiedades
procedure TNetworkAdapterInfo.ClearProps;
begin

  Self.NetworkAdapterProperties.FAccessMask := 0;
  Self.NetworkAdapterProperties.FCaption := STR_EMPTY;
  Self.NetworkAdapterProperties.FComment := STR_EMPTY;
  Self.NetworkAdapterProperties.FConnectionState := STR_EMPTY;
  Self.NetworkAdapterProperties.FConnectionType := STR_EMPTY;
  Self.NetworkAdapterProperties.FDescription := STR_EMPTY;
  Self.NetworkAdapterProperties.FDisplayType := STR_EMPTY;
  Self.NetworkAdapterProperties.FInstallDate := 0;
  Self.NetworkAdapterProperties.FLocalName := STR_EMPTY;
  Self.NetworkAdapterProperties.FName := STR_EMPTY;
  Self.NetworkAdapterProperties.FPersistent := False;
  Self.NetworkAdapterProperties.FProviderName := STR_EMPTY;
  Self.NetworkAdapterProperties.FRemoteName := STR_EMPTY;
  Self.NetworkAdapterProperties.FRemotePath := STR_EMPTY;
  Self.NetworkAdapterProperties.FResourceType := STR_EMPTY;
  Self.NetworkAdapterProperties.FStatus := STR_EMPTY;
  Self.NetworkAdapterProperties.FUserName := STR_EMPTY;

end;
//: Constructor del componente 
constructor TNetworkAdapterInfo.Create(AOwner: TComponent); 
begin 
  inherited; 
 
  Self.FNetworkAdapterProperties := TNetworkAdapterProperties.Create(); 
  Self.MSDNHelp := 'http://msdn.microsoft.com/en-us/library/aa394220(VS.85).aspx';
end; 
 
// destructor del componente 
destructor TNetworkAdapterInfo.Destroy(); 
begin 
 
  // liberar 
  FreeAndNil(Self.FNetworkAdapterProperties); 
 
  inherited; 
end; 
 
// Obtener la clase 
function TNetworkAdapterInfo.GetWMIClass(): string; 
begin 
  Result := 'Win32_NetworkAdapter'
end; 
 
// Obtener Root 
function TNetworkAdapterInfo.GetWMIRoot(): string; 
begin 
  Result := STR_CIM2_ROOT; 
end; 
 
// Active 
procedure TNetworkAdapterInfo.SetActive(const Value: Boolean); 
begin 
  // método heredado 
  inherited; 
end; 
//: Rellenar las propiedades del componente.
procedure TNetworkAdapterInfo.FillProperties(AIndex: integer);
var
  s:string;
  i:Integer;
  d:TDateTime;
  v:variant;
  vType:TWMIGenericPropType;
  vArr:TArrVariant;
  vNull:boolean;
  vp:TNetworkAdapterProperties;
begin

  // Llamar al heredado (importante)
  inherited;

  // Rellenar propiedades...
  vp := Self.NetworkAdapterProperties;

  GetWMIPropertyValue(Self, 'AccessMask', v, vNull);
  vp.FAccessMask := VariantIntegerValue(v, vNull);

  GetWMIPropertyValue(Self, 'Caption', v, vNull);
  vp.FCaption := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'Comment', v, vNull);
  vp.FComment := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'ConnectionState', v, vNull);
  vp.FConnectionState := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'ConnectionType', v, vNull);
  vp.FConnectionType := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'Description', v, vNull);
  vp.FDescription := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'DisplayType', v, vNull);
  vp.FDisplayType := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'InstallDate', v, vNull);
  if not vNull then begin
    vp.FInstallDate := EncodeDate(StrToInt(Copy(v, 1, 4)),StrToInt(Copy(v, 5, 2)),StrToInt(Copy(v, 7, 2)));
  end;

  GetWMIPropertyValue(Self, 'LocalName', v, vNull);
  vp.FLocalName := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'Name', v, vNull);
  vp.FName := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'Persistent', v, vNull);
  vp.FPersistent := VariantBooleanValue(v, vNull);

  GetWMIPropertyValue(Self, 'ProviderName', v, vNull);
  vp.FProviderName := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'RemoteName', v, vNull);
  vp.FRemoteName := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'RemotePath', v, vNull);
  vp.FRemotePath := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'ResourceType', v, vNull);
  vp.FResourceType := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'Status', v, vNull);
  vp.FStatus := VariantStrValue(v, vNull);

  GetWMIPropertyValue(Self, 'UserName', v, vNull);
  vp.FUserName := VariantStrValue(v, vNull);

end;

// {IMPL_ENUM}

end.
