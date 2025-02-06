REM < Script honek Windows 1x zerbitzu eta prozesu beharrezkoak ez direnak baina energia, CPU eta RAM baliabideak kontsumitzen dituztenak gelditzen ditu.
REM < CMD komando-lerrotik deskargatu dezakezu exekutatu eta gero STOPServices24.cmd batch fitxategia exekutatu.
REM < Edo kopiatu eta itsatsi hurrengo komando-lerroa.
REM Exekutatu: ->> curl -LJO https://raw.githubusercontent.com/JaviScriptsWin/Windows-Optimizer/main/STOPServices25.cmd && stopservices25.cmd <<- @echo off
sc stop PimIndexMaintenanceSvc_8b178
rem sc config NPSMSvc start=disabled
REM -----Office 201x -----
sc stop ClickToRunSvc
taskkill /f /IM OfficeClickToRun.exe
sc config ClickToRunSvc start=demand

text
  REM  ----- Adobe Reader -------

sc stop AdobeARMservice
sc stop AGMService
sc stop AGSService
taskkill /f /im armsvc*
taskkill /f /im AdobeA*
sc config adobearmservice start=demand
sc config AGMService start=demand
sc config AGSService start=demand

text
REM ---banaketaren optimizazioa---

sc stop DoSvc

text
REM --- NetBios zerbitzua

sc stop lmhosts

text
REM Egoera-biltegiaren zerbitzua 2 zerbitzu ditu, bat izen ausazkoarekin adib.: OneSyncSvc_jdu59okw (OneSyncSvc ukituz besteari eragiten dio)

sc stop StateRepository
sc config OneSyncSvc start=demand

text
REM -- Windows sare birtualak 

sc stop hns
sc stop nvagent
rem IP laguntzaile aplikazioa
sc stop iphlpsvc
rem PolicyAgent
sc stop PolicyAgent
rem NETBIOS TCP/IP gainean
sc stop lmhosts sc stop TokenBroker
taskkill /IM UserOOBEBroker.exe /F sc stop appxsvc
REM ----- CTFMON Zerbitzua (Eskuz idazteko eta ukimen-pantailarako)
sc stop tabletinputservice
taskkill /f /IM ctfmon.exe
REM sc config tabletinputservices start=demand
REM Windows 11n
REM REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TextInputManagementService" /v Start /t REG_DWORD /d 3 /f REM CTFMON abiarazten duen ataza ezabatzen du baina Windows batzuetan bilaketa-koadroa desagertzen da
REM schtasks /change /TN "\microsoft\windows\textservicesframework\msctfmonitor" /Disable sc stop msiservice

text
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

text
REM --- Inprimagailu Ilara Ezabatu inprimatu edo PDFak egin nahi badira

sc stop spooler
sc stop mdm rem -----eguneratzeak--------
sc stop wuauserv
REM eguneratzeen orkestatzailea
sc stop UsoSvc
REM Microsoft Update Health Service
sc stop WaaSMedicSvc
rem banaketa optimizazio zerbitzua
sc stop DoSvc
sc stop uhssvc
rem Equipo\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\uhssvc
rem ----Eguneratzeak ------- rem geolokalizazioa
sc stop lfsvc
rem irrati modua eta hegazkin modua
sc stop RmSvc
REM Datu erabilera
sc stop DusmSvc sc stop RasMan rem arbela
sc stop cbdhsvc_5d99e
rem Espioia
sc stop sysmain
sc stop DiagTrack
rem kontaktuak sinkronizatzen ditu rem Kontaktuen datuak indexatzen ditu kontaktuak azkar bilatzeko. Baliteke kontaktu guztiak ez agertzea bilaketa-emaitzetan.
sc stop PimIndexMaintenanceSvc_5d99e
rem Aplikazioei erabiltzaile-datu egituratuetarako sarbidea ematen die, kontaktu-informazioa, egutegiak, mezuak eta abar barne
sc stop UserDataSvc_5d99e
REM zaborra
sc stop UdkUserSvc_5d99e
rem proba komertziala
sc stop RetailDemo
rem irrati modua eta hegazkin modua
sc stop RmSvc
sc stop WSearch
rem zerbitzu biometrikoa
sc stop WbioSrvc
rem Ordainketen eta NFC/SE kudeatzailea
sc stop SEMgrSvc
rem Urruneko sarbideko konexioen kudeatzailea
sc stop rasman
rem Web kontuen kudeatzailea
sc stop tokenbroker sc stop XblAuthManager
sc config XblAuthManager start=demmand rem Nola desgaitu eguneratze ergel hau, nire ordenagailua esna mantentzen du eta elektrizitatea xahutzen du
rem Nire Windows ezin zen lo geratu MoUsoCoreWorker.exe-ren ondorioz
rem MoUsoCoreWorker.exe, Mo USO Core Worker programa izenez ere ezaguna, Microsoft-en fitxategi bat da
rem Windows Update-rekin lotuta dagoena. Zure ordenagailua etengabe esnatzen bada lotik, programa hau izan daiteke erantzulea. Honekin batera, badira zenbait m Rem Windows-en push jakinarazpenen sistemaren zerbitzua (Windows store aplikazio batzuk eguneratzeko)
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

taskkill  /f /IM PhoneExperienceHost.exe 

taskkill  /f /IM runtimebroker.exe
taskkill  /f /im StartMenuExperienceHost.exe 
taskkill  /f /IM SystemSettingsBroker 
taskkill  /F /IM Microsoft.Windows.Search_cw5n1h2txyewy
taskkill  /f /IM SearchApp.exe 
taskkill  /f /IM SgrmBroker.exe 
taskkill  /f /IM TiWorker.exe

taskkill  /f /IM YourPhone.exe

taskkill /f /IM  Widgets.exe  
taskkill /f /IM  Widgetservice.exe  

reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\sysmain" /v Start /t REG_DWORD /d 4 /f

REM --------Deshabilitar servicios actualizaciones
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
REM >>>>> TELEMETRIA eta habar : https://pcseguro.es/preguntenos/como-deshabilitar-microsoft-compatibility-telemetry-compattelrunner-exe/
REM Servicios W10 & W11  a deshabilitar   https://gist.github.com/Aldaviva/0eb62993639da319dc456cc01efa3fe5
