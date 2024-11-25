REM < This script specifically stop Windows 1x services and processes that are unnecessary and consume CPU and RAM resources
REM < You can download from CMD command line running and then execute the batch file STOPServices24.cmd
REM < Or  copy and paste the next command line.
REM Run: ->>  curl -LJO https://raw.githubusercontent.com/JaviScriptsWin/Windows-Optimizer/main/STOPServices25.cmd && stopservices25.cmd     <<-

@echo off
sc stop PimIndexMaintenanceSvc_8b178

REM -----Office 2019 -----
sc stop ClickToRunSvc
taskkill /f /IM OfficeClickToRun.exe

REM  ----- Adobe Reader -------
sc stop AdobeARMservice 
taskkill /f /im armsvc*
taskkill /f /im AdobeA*

REM ---optimizacion de la distribucion---
sc stop DoSvc

REM -- redes virtuales Windows 
sc stop hns
sc stop nvagent

taskkill  /f /im GameBar.exe   
taskkill  /f /IM GoogleUpdate.exe 
taskkill  /f /IM GoogleCrashHandler.exe 
taskkill  /f /IM GoogleCrashHandler64.exe 
taskkill  /F /IM HelpPane.exe
taskkill  /F  IM LockApp.exe
taskkill  /f /im MSOSYNC.EXE 
taskkill  /f /IM msedge.exe
taskkill  /f /IM MicrosoftEdgeUpdate.exe 
taskkill  /f /IM Microsoft.Photos.exe  
taskkill  /F /IM Microsoft.Windows.Search_cw5n1h2txyewy
taskkill  /f /IM OneApp.IGCC.WinService.exe 
taskkill  /f /IM OneDriveStandaloneUpdater.exe
taskkill  /f /IM OneDrive*
taskkill  /f /IM PhoneExperienceHost.exe 

taskkill  /f /IM runtimebroker.exe
taskkill  /f /im StartMenuExperienceHost.exe 
taskkill  /f /IM SystemSettingsBroker 
taskkill  /f /IM SearchApp.exe 
taskkill  /f /IM SgrmBroker.exe 
taskkill  /f /IM TiWorker.exe
taskkill  /f /IM TiWorker.exe
taskkill  /f /IM YourPhone.exe

taskkill /f /IM  Widgets.exe  
taskkill /f /IM  Widgetservice.exe  

sc stop TokenBroker   
taskkill /IM UserOOBEBroker.exe /F

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

	REM Cola de Impresoras eliminar si se quiere imprimir
sc stop spooler	

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

sc stop RasMan

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

Rem Servicio del sistema de notificaciones de inserción de Windows (para que ciertas aplicaciones de Windwows store se actualicen)
sc stop WpnService

reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\sysmain" /v Start /t REG_DWORD /d 4 /f

REM Deshabilitar servicios actualizaciones
REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\wuaserv" /v Start /t REG_DWORD /d 4 /f
REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\uhssvc" /v Start /t REG_DWORD /d 4 /f
REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\usosvc" /v Start /t REG_DWORD /d 4 /f
REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\waasMedicSvc" /v Start /t REG_DWORD /d 4 /f


REM reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\wsearch" /v Start /t REG_DWORD /d 4 /f
REM ----------------------------------------------------------------------------------------------------------------

sc stop MySQL80
sc stop wercplsupport

REM ++++++++++++++More and better: +++++++++++++++++++++++++++++++++++++
REM https://christitus.com/debloat-windows-10/
REM https://gist.github.com/Brandonbr1/e93fc0219ba68fa0ed37a5f1e4717c1d
REM https://superuser.com/questions/1609004/windows-10-which-services-and-windows-features-and-so-on-are-unnecesary-and-ca
 rem Para Activity History Permanently 
 rem https://www.majorgeeks.com/content/page/how_to_disable_windows_10_activity_history_permanently.html
 REM How to Disable All Advertising and Sponsored Apps in Windows 10 
 REM https://www.majorgeeks.com/content/page/how_to_disable_all_advertising_and_sponsored_apps_in_windows_10.html
 REM >>>>> TELEMETRIA Y DEMAS : https://pcseguro.es/preguntenos/como-deshabilitar-microsoft-compatibility-telemetry-compattelrunner-exe/
