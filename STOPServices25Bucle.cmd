@echo off
setlocal

rem Lista de procesos a finalizar
s@echo off
setlocal enabledelayedexpansion

:: Kill processes
set "processes=OfficeClickToRun.exe armsvc* AdobeA* ctfmon.exe UserOOBEBroker.exe GameBar.exe GoogleUpdate.exe GoogleCrashHandler.exe GoogleCrashHandler64.exe HelpPane.exe LockApp.exe MSOSYNC.EXE msedge.exe MicrosoftEdgeUpdate.exe Microsoft.Photos.exe PhoneExperienceHost.exe runtimebroker.exe StartMenuExperienceHost.exe SystemSettingsBroker Microsoft.Windows.Search_cw5n1h2txyewy SearchApp.exe SgrmBroker.exe TiWorker.exe YourPhone.exe Widgets.exe Widgetservice.exe"

for %%p in (%processes%) do (
    taskkill /f /im %%p >nul 2>&1
)

:: List of services to stop
set "services=PimIndexMaintenanceSvc_8b178 ClickToRunSvc AdobeARMservice AGMService AGSService DoSvc lmhosts StateRepository OneSyncSvc hns nvagent iphlpsvc PolicyAgent TokenBroker appxsvc tabletinputservice msiservice vmms hvhost vmickvpexchange vmicheartbeat vmicrdv UevAgentService vmictimesync vmicshutdown vmicvmsession vmicvss vmicguestinterface spooler mdm wuauserv UsoSvc WaaSMedicSvc uhssvc lfsvc RmSvc DusmSvc RasMan cbdhsvc_5d99e sysmain DiagTrack PimIndexMaintenanceSvc_5d99e UserDataSvc_5d99e UdkUserSvc_5d99e RetailDemo WSearch WbioSrvc SEMgrSvc rasman tokenbroker XblAuthManager WpnService edgeupdate MicrosoftEdgeElevationService"

:: Stop services
for %%s in (%services%) do (
    sc stop %%s >nul 2>&1
)

:: Configure specific services as manual
sc config ClickToRunSvc start=demand >nul 2>&1
sc config OneSyncSvc start=demand >nul 2>&1
sc config XblAuthManager start=demand >nul 2>&1

:: Disable SuperFetch
reg add "HKLM\SYSTEM\CurrentControlSet\Services\sysmain" /v Start /t REG_DWORD /d 4 /f >nul 2>&1

echo Script execution completed.

endlocal
