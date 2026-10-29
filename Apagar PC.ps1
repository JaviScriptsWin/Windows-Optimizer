# ============================================================
# Apagado programado para Windows 10 y Windows 11
# Ejecutar PowerShell como administrador
# ============================================================

# Comprobar privilegios de administrador
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Este script requiere permisos de administrador."
    return
}

$taskName  = "ApagadoProgramadoDiario"
$taskDescr = "Apaga el equipo diariamente a las 14:45 y 21:35, con aviso de 60 segundos."

# 1. Acción de apagado
$action = New-ScheduledTaskAction `
    -Execute "shutdown.exe" `
    -Argument "/s /t 60 /f"

# 2. Horarios diarios
$trigger1 = New-ScheduledTaskTrigger -Daily -At "14:45"
$trigger2 = New-ScheduledTaskTrigger -Daily -At "21:35"

# 3. Configuración general
$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1) `
    -MultipleInstances IgnoreNew

# 4. Definir que la tarea corra como SYSTEM con privilegios máximos
$principalTask = New-ScheduledTaskPrincipal `
    -UserId "NT AUTHORITY\SYSTEM" `
    -LogonType ServiceAccount `
    -RunLevel Highest

# 5. Crear el objeto de la tarea
$task = New-ScheduledTask `
    -Action $action `
    -Trigger @($trigger1, $trigger2) `
    -Settings $settings `
    -Principal $principalTask `
    -Description $taskDescr

# 6. Forzar compatibilidad para Windows 10 / Windows 8.1
$task.Settings.Compatibility = "Win8"

# 7. Registrar la tarea pasando únicamente el objeto $task
Register-ScheduledTask `
    -TaskName $taskName `
    -InputObject $task `
    -Force | Out-Null

Write-Host ""
Write-Host "Tarea '$taskName' creada correctamente." -ForegroundColor Green
Write-Host "Configurado para: Windows 10 / Windows 8.1" -ForegroundColor Cyan
Write-Host "Usuario: NT AUTHORITY\SYSTEM (Privilegios máximos)" -ForegroundColor Cyan
