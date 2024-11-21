REM This script specifically stop Windows services and processes that are unnecessary and consume CPU and RAM resources
REM You can download from CMD command line running, and then execute the batch file STOPServices24.cmd

REM Run:   curl -LJO https://github.com/JaviScriptsWin/Windows-Optimizer/blob/main/STOPServices24.cmd & STOPServices24.cmd

@echo off
sc stop PimIndexMaintenanceSvc_8b178
REM FALTAN LOS DE ORACLE 

REM -----Office 2019 -----
sc stop ClickToRunSvc
taskkill /f /IM OfficeClickToRun.exe

REM powershell stop-service ClickToRunSvc*

REM  ----- Adobe Reader -------
taskkill /f /im AdobeA*
sc stop AdobeARMservice 
taskkill /f /im armsvc*

REM taskkill  Finaliza procesos 
taskkill /f /IM  runtimebroker.exe
taskkill /f /IM  PhoneExperienceHost.exe
taskkill /f /IM  SystemSettingsBroker 
taskkill /f /im StartMenuExperienceHost.exe 
taskkill /f /IM  Widgets.exe  
taskkill /f /IM  Widgetservice.exe  
taskkill /F  /IM Microsoft.Windows.Search_cw5n1h2txyewy
taskkill /F  /IM HelpPane.exe
taskkill /F  /IM LockApp.exe

REM ---optimizacion de la distribucion---
sc stop DoSvc

REM -- redes virtuales Windows 
sc stop hns
sc stop nvagent



taskkill /IM msedge.exe /F
taskkill /IM GoogleUpdate.exe /F
taskkill /IM GoogleCrashHandler.exe /F
taskkill /IM GoogleCrashHandler64.exe /F
taskkill /IM OneApp.IGCC.WinService.exe /F
taskkill /IM MicrosoftEdgeUpdate.exe /F
taskkill /IM SearchApp.exe /F
taskkill /IM PhoneExperienceHost.exe /F
taskkill /IM Microsoft.Photos.exe  /F
taskkill /IM SgrmBroker.exe /F
taskkill /f /IM TiWorker.exe

sc stop TokenBroker   
taskkill /IM UserOOBEBroker.exe /F

taskkill /f /IM YourPhone.exe
taskkill /f /IM OneDriveStandaloneUpdater.exe
taskkill /f /IM OneDrive*

sc stop appxsvc
sc stop edgeupdate
rem sc stop tabletinputservice
sc stop msiservice



rem ---Hyper-V----------
sc stop vmms
sc stop hvhost
sc stop vmickvpexchange
sc stop vmicheartbeat
sc stop vmicrdv
sc stop UevAgentService
sc stop vmictimesync
sc stop vmicheartbeat
sc stop vmickvpexchange
sc stop vmicshutdown
sc stop vmicrdv
sc stop vmicvmsession
sc stop vmicvss
sc stop vmicguestinterface
rem ----------------------
sc stop mdm

rem -----actualizaciones--------
sc stop wuauserv
	REM orquestador de actualizaciones
sc stop UsoSvc
	REM Microsoft Update Health Service
sc stop WaaSMedicSvc
sc stop uhssvc
rem Equipo\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\uhssvc
 
rem ----Actualizaciones -------

	rem geolocalizacion
sc stop lfsvc 
 	rem modo radio y modo avion
sc stop RmSvc
	rem servicio optimizacion de distribucion
sc stop DoSvc
sc stop MDM

sc stop AdobeARMservice
sc stop RasMan
	REM Cola de Impresoras
sc stop spooler	

	rem portapapeles
sc stop cbdhsvc_5d99e
	rem Espia
sc stop sysmain
sc stop DiagTrack
	rem sincroniza contactos
sc stop OneSyncSvc_5d99e
	rem Indexa los datos de contacto para buscar contactos rápidamente. Si detienes o deshabilitas este servicio, puede que no aparezcan todos los contactos en los resultados de la búsqueda.
sc stop PimIndexMaintenanceSvc_5d99e
	rem Proporciona a las aplicaciones acceso a datos de usuario estructurados, incluida información de contacto,calendarios,mensajes etc
sc stop UserDataSvc_5d99e
	REM basura
sc stop UdkUserSvc_5d99e
	rem prueba comercial
sc stop RetailDemo
	rem modo radio y modo avion
sc stop RmSvc
sc stop WSearch
	rem servicio biometrico
sc stop WbioSrvc
	rem servicio optimizacion de distribucion ¿?
sc stop DoSvc
	rem Administrador de pagos y NFC/SE
sc stop SEMgrSvc
	rem Administrador de conexiones de acceso remoto
sc stop rasman
	rem Administrador de cuentas web
sc stop tokenbroker

rem How to turn off this stupid update, keeps my computer awake and wastes electricity
rem My windows wasn't able to go sleep because of MoUsoCoreWorker.exe
rem MoUsoCoreWorker.exe, also known as Mo USO Core Worker program, is a file from Microsoft
rem  which is related to Windows Update. If your computer continually wakes from sleep, then this program could be responsible for it. Along with this, there are a few m
rem sc stop
	rem Servicio del sistema de notificaciones de inserción de Windows (para que ciertas aplicaciones de Windwows store se actualicen)
sc stop WpnService

reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\sysmain" /v Start /t REG_DWORD /d 4 /f

REM Deshabilitar servicios actualizaciones
REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\wuaserv" /v Start /t REG_DWORD /d 4 /f
REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\uhssvc" /v Start /t REG_DWORD /d 4 /f
REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\usosvc" /v Start /t REG_DWORD /d 4 /f
REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\waasMedicSvc" /v Start /t REG_DWORD /d 4 /f

REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\wsearch" /v Start /t REG_DWORD /d 4 /f
REM *********########################################----------------------------
@echo off

taskkill /f /IM TiWorker.exe
taskkill /f /IM YourPhone.exe
taskkill /f /IM OneDriveStandaloneUpdater.exe
taskkill /f /IM OneDrive*

sc stop MySQL80
sc stop wercplsupport



