{*****************************************************************}
{ The CoolTrayIcon and TextTrayIcon components are freeware.      }
{                                                                 }
{ Feel free to use and improve them. I would be pleased to hear   }
{ what you think.                                                 }
{                                                                 }
{ Troels Jakobsen - delphiuser@get2net.dk                         }
{ Copyright (c) 2002                                              }
{                                                                 }
{ This unit by Jouni Airaksinen - mintus@codefield.com            }
{*****************************************************************}

unit RegisterTrayIcons;

interface

procedure Register;

implementation

uses
  Classes, CoolTrayIcon, TextTrayIcon;

procedure Register;
begin
  RegisterComponents('Tray Icons', [TCoolTrayIcon, TTextTrayIcon]);
end;

end.

