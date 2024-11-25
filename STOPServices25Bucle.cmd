@echo off
setlocal

rem Lista de procesos a finalizar
set processes=(
    GameBar.exe
    GoogleUpdate.exe
    GoogleCrashHandler.exe
    GoogleCrashHandler64.exe
    HelpPane.exe
    LockApp.exe
    MSOSYNC.EXE
    msedge.exe
    MicrosoftEdgeUpdate.exe
    Microsoft.Photos.exe
    Microsoft.Windows.Search_cw5n1h2txyewy
    OneApp.IGCC.WinService.exe
    OneDriveStandaloneUpdater.exe
    OneDrive*
    PhoneExperienceHost.exe
    runtimebroker.exe
    StartMenuExperienceHost.exe
    SystemSettingsBroker
    SearchApp.exe
    SgrmBroker.exe
    TiWorker.exe
    YourPhone.exe
    Widgets.exe  
    Widgetservice.exe
)

rem Iterar sobre cada proceso y finalizarlo
for %%pro in %processes% do (
    taskkill /f /im %%pro
)

endlocal
