@echo off

rem This batch file reinstalls the CoolTrayService, then starts it.

rem Change this path:
set SERVICEPATH=C:\Troels\Delphi\TrayIconTest\CoolService

%SERVICEPATH%\CoolService.exe /uninstall /silent
%SERVICEPATH%\CoolService.exe /install /silent
net start CoolTrayService

rem %SystemRoot%\system32\services.msc /s

