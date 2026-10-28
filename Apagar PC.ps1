
# ============================================================
# Apagado programado para Windows 10 y Windows 11
# Ejecutar PowerShell como administrador
# ============================================================

$taskName  = "ApagadoProgramadoDiario"
$taskDescr = "Apaga el equipo diariamente a las 14:45 y 21:35, con aviso de 60 segundos."

# Comprobar privilegios de administrador
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    throw "Ejecuta PowerShell como administrador."
}

# Acción de apagado con cuenta atrás de 60 segundos
$action = New-ScheduledTaskAction `
    -Execute "$env:SystemRoot\System32\shutdown.exe" `
    -Argument "/s /t 60 /f"

# Horarios diarios
$trigger1 = New-ScheduledTaskTrigger -Daily -At "14:45"
$trigger2 = New-ScheduledTaskTrigger -Daily -At "21:35"

# Configuración general
$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -MultipleInstances IgnoreNew

# Crear la definición de la tarea
$task = New-ScheduledTask `
    -Action $action `
    -Trigger @($trigger1, $trigger2) `
    -Settings $settings `
    -Description $taskDescr

# Registrar la tarea como SYSTEM con privilegios máximos
Register-ScheduledTask `
    -TaskName $taskName `
    -InputObject $task `
    -User "SYSTEM" `
    -RunLevel Highest `
    -Force

Write-Host ""
Write-Host "Tarea '$taskName' creada o actualizada." -ForegroundColor Green
Write-Host "Compatibilidad: Windows 10 / Windows 11"
Write-Host "Ejecución: SYSTEM, privilegios máximos"
Write-Host "Horarios: 14:45 y 21:35"
Write-Host "Cuenta atrás: 60 segundos"
