GLibWMI Component Library 1.6beta
===========================================================
Copyright © Germán Estévez (Neftalí). Todos los derechos reservados.
German_ral@hotmail.com
Futuras versiones del componente en:
http://neftali-mirror.site11.com/
http://neftali.clubdelphi.com/


HISTORY
==============================

Version 1.6b  (22/01/2010)

* Added new components:
	+ CNetworkAdapterInfo:	Information about adapter installed on computer.
	+ CUserAccountInfo: 		Information about user account in the computer.
	+ CShareInfo:						Information about shared resources on the computer.
	
* Addded Methos to some components:
	+ CComputerSystemInfo:
		- Added méthod RENAME
	+ CProcessInfo:
		- Adeed methods Terminate, SetPriority, GetOwner, GetOwnerSID
	+ CServiceInfo:
		- Added methods InterrogateService, StartService, StopService, PauseService, ResumeService
		  ChangeStartModeService.
		  
* Corrected some bug on retry component properties (Access Violation on demo).

* Added demo to Test the ServiceInfo component; Access installed services on computer and
	charge properties, State,....



===========================================================================

version 1.6b  (11/01/2010)

* Corrected some bugs of Generic Demo application.

* Added new components:
	+ CProcessInfo:					Information about the process executing in system.
	+ CServiceInfo:					Information about the services in system
	+ CDesktopMonitorInfo:	Information about monitor or visualization device installed in system.
	+ CComputerSystemInfo:	Information about the computer running Windows based system.
	+ CStartupCommandInfo:	Información acerca de los procesos que se ejecutan automáticamente cuando 
													el usuario hace el Login en el sistema. 													
	


RESTRICCIONES/RESTRICTIONS
===============================
Estos componentes hacen uso de la WMI de Windows
(Windows Management Instrumentation).
Funciona con sistemas Windows 2000 y posteriores (W2k, WXP, W2003, Windows7,...).
Para más información consultar:
"Operating System Availability of WMI Components"
http://msdn.microsoft.com/en-us/library/aa392726%28VS.85%29.aspx

This library use the WMI (Windows Management Instrumentation).
It can be used on Windows 2000 and later versions.
More information on:
"Operating System Availability of WMI Components"
http://msdn.microsoft.com/en-us/library/aa392726%28VS.85%29.aspx



CONTACTO/CONTACT
=========================
  Por favor, si tienes sugerencias o errores sobre éste componente hazme llegar un
correo con la propuesta/explicación a la direccion:
  german_ral@hotmail.com
  Cuando los corrija o amplie te haré llegar un mensaje de actualización.
  
  IMPORTANTE: Para detectar errores puede ser de gran ayuda enviar en el correo
  el contenido de la propiedad AllProperties del componente afectado.
  
	IMPORTANT: To detect errors can be very helpful, send in the mail
  content of AllProperties property of the affected component.  
  
  
  Gracias/Thanks.
  

DESCRIPCION
=========================
  Permite obtener mediante WMI información de la BIOS del ordenador. Basta con 
  soltar el componente en el formulario y activarlo.
  

Utilización/Usage:
=========================
  Coloque el componente en el formulario y activelo. Consulte las propiedades.
  Place the component in the form and enable it. Read the properties with values.  
  
  
HISTORIAL
=========================           

  16/10/2009  * Creación. 


LICENSE
=========================
TBIOSInfo component is freeware. You may copy component's files AS
LONG AS YOU COPY ALL OF THEM. If you want to change the source code in
order to improve the component's features, performance, etc. please
send me the new source code so that I can have a look at it. The
changed source code should contain descriptions what you have changed,
and of course your name. The only thing you MAY NOT CHANGE is the
ORIGINAL COPYRIGHT INFORMATION.

ADVICE
==========================
TBIOSInfo is provided "AS IS" without any warranty of any kind,
either express or implied. The entire risk as to the quality and
performance of the software is with you. The author is NOT liable for
any DAMAGES resulting from the use and misuse of the component,
especially he is NOT liable for DAMAGES that were caused BY ANY
VERSION WHICH HAS NOT BEEN PROGRAMMED BY THE AUTHOR HIMSELF.