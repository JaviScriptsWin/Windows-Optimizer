REM < This script specifically stop Windows 1x services and processes that are unnecessary but consume Power, CPU and RAM resources.
REM < You can download from CMD command line running and then execute the batch file STOPServices24.cmd
REM < Or  copy and paste the next command line.
REM You can Download and Run last version   typping on CMD the command: " curl -LJO https://raw.githubusercontent.com/JaviScriptsWin/Windows-Optimizer/main/STOPServices25.cmd && stopservices25.cmd "

@echo off
	REM -----Office 201x -----
sc stop ClickToRunSvc 
taskkill /f /IM OfficeClickToRun.exe
sc config ClickToRunSvc start=demand

	  REM  ----- Adobe Reader -------
sc stop AdobeARMservice 
sc stop AGMService
sc stop AGSService
taskkill /f /im armsvc*
taskkill /f /im AdobeA*
sc config adobearmservice start=demand
sc config AGMService start=demand
sc config AGSService start=demand

	REM ---optimizacion de la distribucion---
sc stop DoSvc

  	REM Servicio de repositorio de estado Tiene 2 servicios, uno con un nombre aleatorio ej: OneSyncSvc_jdu59okw (tocando OneSyncSvc afecta al otro)
sc stop StateRepository
sc config OneSyncSvc start=demand

   	REM -- redes virtuales Windows 
sc stop hns
sc stop nvagent
	rem  Aplicación auxiliar IP
sc stop iphlpsvc
	rem PolicyAgent
sc stop PolicyAgent
	rem  servicio  NETBIOS sobre TCP/IP
sc stop lmhosts

sc stop TokenBroker   
taskkill /IM UserOOBEBroker.exe /F

sc stop appxsvc
	REM -----Pantallas tactiles Habilita la entrada de texto, la entrada expresiva, el teclado táctil, la escritura a mano y los IME.-----
sc stop TextInputManagementService

   	REM ----- Servicio CTFMON (de Escritura a mano y pantalla tactil)
sc stop tabletinputservice
taskkill  /f /IM ctfmon.exe 
REM sc config tabletinputservices start=demand
	REM en Windows 11
REM REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TextInputManagementService" /v Start /t REG_DWORD /d 3 /f

REM elimina la tarea que lanza CTFMON pero en algunos Windows desaparece el cuadro de busqueda 
REM schtasks /change /TN "\microsoft\windows\textservicesframework\msctfmonitor"  /Disable

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

	REM --- Cola de Impresoras. No usar si se quiere imprimir o hacer PDFs
sc stop spooler	
sc stop mdm
   rem -----Actualizaciones--------
sc stop wuauserv
   REM orquestador de actualizaciones
sc stop UsoSvc
   REM Microsoft Update Health Service
sc stop WaaSMedicSvc
   rem servicio optimizacion de distribucion
sc stop DoSvc
sc stop uhssvc
   rem Equipo\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\uhssvc
   rem ----Fin Actualizaciones -------

   rem geolocalizacion
sc stop lfsvc 
   rem modo radio y modo avion
sc stop RmSvc
   REM Uso de datos
sc stop DusmSvc
sc stop RasMan
   rem portapapeles
sc stop cbdhsvc_5d99e
   rem Espia
sc stop sysmain
sc stop DiagTrack
	rem sincroniza contactos.  Indexa los datos de contacto para buscar contactos rápidamente.Puede que no aparezcan todos los contactos en los resultados de la búsqueda.
sc stop PimIndexMaintenanceSvc_8b178
	rem sc config NPSMSvc start=disabled
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
   rem Administrador de pagos y NFC/SE
sc stop SEMgrSvc
   rem Administrador de conexiones de acceso remoto
sc stop rasman
   rem Administrador de cuentas web
	REM ---------------
sc stop tokenbroker
sc config  tokenbroker start=demmand
taskkill  /f /im   RuntimeBroker.exe
taskkill  /f /im searchhost.exe 
taskkill  /f /im StartMenuExperienceHost.exe 
taskkill  /f /IM SystemSettingsBroker 
taskkill  /F /IM Microsoft.Windows.Search_cw5n1h2txyewy
taskkill  /f /IM SearchApp.exe 
taskkill  /f /IM SgrmBroker.exe 
taskkill  /f /IM TiWorker.exe
	REM-------------
sc stop XblAuthManager
sc config XblAuthManager start= demand

rem How to turn off this stupid update, keeps my computer awake and wastes electricity
rem My windows wasn't able to go sleep because of MoUsoCoreWorker.exe
rem MoUsoCoreWorker.exe, also known as Mo USO Core Worker program, is a file from Microsoft
rem  which is related to Windows Update. If your computer continually wakes from sleep, then this program could be responsible for it. Along with this, there are a few m

   Rem Servicio del sistema de notificaciones de inserción de Windows (para que ciertas aplicaciones de Windwows store se actualicen)
sc stop WpnService

taskkill  /f /im GameBar.exe   
taskkill  /f /IM GoogleUpdate.exe 
taskkill  /f /IM GoogleCrashHandler.exe 
taskkill  /f /IM GoogleCrashHandler64.exe 
taskkill  /F /IM HelpPane.exe
taskkill  /F  IM LockApp.exe
taskkill  /f /im MSOSYNC.EXE 
sc stop edgeupdate
sc stop MicrosoftEdgeElevationService
taskkill  /f /IM msedge.exe
taskkill  /f /IM MicrosoftEdgeUpdate.exe 
taskkill  /f /IM Microsoft.Photos.exe  

	REM --------- Servicios de Telefono en Windows 1x
taskkill  /f /IM PhoneExperienceHost.exe 
taskkill  /f /IM YourPhone.exe
sc stop IpOverUsbSvc

taskkill /f /IM  Widgets.exe  
taskkill /f /IM  Widgetservice.exe  

reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\sysmain" /v Start /t REG_DWORD /d 4 /f

REM --------Deshabilitar servicios de actualizaciones
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
REM Para Activity History Permanently 
REM https://www.majorgeeks.com/content/page/how_to_disable_windows_10_activity_history_permanently.html
REM How to Disable All Advertising and Sponsored Apps in Windows 10 
REM https://www.majorgeeks.com/content/page/how_to_disable_all_advertising_and_sponsored_apps_in_windows_10.html
REM >>>>> TELEMETRIA Y DEMAS : https://pcseguro.es/preguntenos/como-deshabilitar-microsoft-compatibility-telemetry-compattelrunner-exe/
REM Servicios W10 & W11  a deshabilitar   https://gist.github.com/Aldaviva/0eb62993639da319dc456cc01efa3fe5
pause

