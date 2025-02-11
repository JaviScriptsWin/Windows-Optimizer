

function Show-Banner {
    Write-Host ""
    Write-Host " +--------------------------  "
    Write-Host " |                           |"
    Write-Host " | WINDOWS 10 SCRIPT TWEAKER |"
    Write-Host " | by AikonCWD               |"
    Write-Host " |           v2.2 (12/2022)  |"
    Write-Host " |  $(Get-Date -Format 'd')               |"
    Write-Host " | Modified by: Javier Gonzalez|"
    Write-Host " +--------------------------    "
    Write-Host ""
    Write-Host " Comprobando requisitos del sistema..."
}

function Check-Windows10 {
    $ntVersion = (Get-CimInstance Win32_OperatingSystem).Version.Split('.')[0]
    
    if ([int]$ntVersion -lt 10) {
        Write-Host " ERROR: Necesitas ejecutar este script bajo Windows 10"
        Write-Host " >>> Tu Windows es version:  >>>" ([int]$ntVersion + 1)
        Write-Host ""
        Write-Host " Presiona <Enter> para salir"
        Read-Host
        exit
    }
}


