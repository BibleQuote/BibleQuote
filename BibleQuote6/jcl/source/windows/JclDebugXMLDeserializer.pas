{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL)                                                                  }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is JclDebugXMLDeserializer.pas.                                                }
{                                                                                                  }
{ The Initial Developer of the Original Code is Uwe Schuster.                                      }
{ Portions created by Uwe Schuster are Copyright (C) 2009 Uwe Schuster. All rights reserved.       }
{                                                                                                  }
{ Contributor(s):                                                                                  }
{   Uwe Schuster (uschuster)                                                                       }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Last modified: $Date:: 2009-08-10 20:10:24 +0200 (lun., 10 août 2009)                         $ }
{ Revision:      $Rev:: 2942                                                                     $ }
{ Author:        $Author:: outchy                                                                $ }
{                                                                                                  }
{**************************************************************************************************}

unit JclDebugXMLDeserializer;

{$I jcl.inc}

interface

uses
  SysUtils,
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  JclDebugSerialization, JclSimpleXml;

type
  TJclXMLDeserializer = class(TJclCustomSimpleSerializer)
  public
    procedure LoadFromString(const AValue: string);
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jcl.svn.sourceforge.net:443/svnroot/jcl/tags/JCL-2.2-Build3886/jcl/source/windows/JclDebugXMLDeserializer.pas $';
    Revision: '$Revision: 2942 $';
    Date: '$Date: 2009-08-10 20:10:24 +0200 (lun., 10 août 2009) $';
    LogPath: 'JCL\source\windows';
    Extra: '';
    Data: nil
    );
{$ENDIF UNITVERSIONING}

implementation

//=== { TJclXMLDeserializer } ================================================

procedure TJclXMLDeserializer.LoadFromString(const AValue: string);

  procedure AddItems(ASerializer: TJclCustomSimpleSerializer; AElem: TJclSimpleXMLElem);
  var
    I: Integer;
  begin
    for I := 0 to AElem.Properties.Count - 1 do
      ASerializer.Values.Add(Format('%s=%s', [AElem.Properties[I].Name, AElem.Properties[I].Value]));
    for I := 0 to AElem.Items.Count - 1 do
      AddItems(ASerializer.AddChild(nil, AElem.Items[I].Name), AElem.Items[I])
  end;

var
  XML: TJclSimpleXML;
begin
  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromString(AValue);
    Clear;
    AddItems(Self, XML.Root);
  finally
    XML.Free;
  end;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
