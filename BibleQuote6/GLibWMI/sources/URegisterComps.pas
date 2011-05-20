unit URegisterComps;


//=========================================================================
//
// I N T E R F A C E
//
//=========================================================================
interface

// Procedimiento de REGISTRO
procedure Register();                           

//=========================================================================
//
// I M P L E M E N T A T I O N
//
//=========================================================================
implementation

uses
  Classes, DesignIntf,
  {GLibWMI} UConstantes,
  {GLibWMI Components}
    CBIOSInfo, CDisplayInfo, CDiskDriveInfo, CProcessorInfo, CCDROMDriveInfo,
    CKeyboardInfo, CPrinterInfo, CBatteryInfo, CSoundDeviceInfo,
    COperatingSystemInfo, CPointingDeviceInfo, CPhysicalMemoryInfo,
    CProcessInfo, CServiceInfo, CDesktopMonitorInfo, CComputerSystemInfo,
    CStartupCommandInfo, CNetworkAdapterInfo, CUserAccountInfo, CShareInfo,
    CPrintJobInfo, CUSBControllerInfo, CDiskPartitionInfo,
    CEnvironmentInfo,
    FormAbout, UTAboutProp;


// Procedimiento de REGISTRO
procedure Register();
begin
  RegisterComponents(GLIB_PACKAGE_WMI, [
    TBiosInfo, TDisplayInfo, TDiskDriveInfo, TDiskPArtitionInfo,
    TProcessorInfo, TDisplayInfo,
    TCDROMDriveInfo, TKeyboardInfo, TPrinterInfo, TPrintJobInfo,
    TBatteryInfo, TNetworkAdapterInfo,
    TSoundDeviceInfo, TPointingDeviceInfo, TUSBControllerInfo,
    TPhysicalMemoryInfo,
    TOperatingSystemInfo, TProcessInfo, TServiceInfo, TDesktopMonitorInfo,
    TEnvironmentInfo,
    TComputerSystemInfo, TStartupCommandInfo,
    TUserAccountInfo, TShareInfo]);
  RegisterPropertyEditor(TypeInfo(TFAbout),nil,'',TAboutGlibWMIProp);
end;

end.
