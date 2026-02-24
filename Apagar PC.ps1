# Create 2 scheduled tasks to shut down the PC even if the user has not logged in to Windows.

 # Nombre de la tarea
$taskName  = "ApagadoProgramadoDiario"
$taskDescr = "Apaga el equipo diariamente a las 14:45 y 21:35 (espera 60 segundos)."

# Acción: ejecutar shutdown con retardo de 60 segundos
$action = New-ScheduledTaskAction -Execute "shutdown.exe" -Argument "/s /t 60 /f"

# Disparadores diarios para las 14:45 y las 21:35
$trigger1 = New-ScheduledTaskTrigger -Daily -At 14:45
$trigger2 = New-ScheduledTaskTrigger -Daily -At 21:35

# Registrar directamente la tarea SIN usar New-ScheduledTask ni -InputObject
Register-ScheduledTask `
  -TaskName $taskName `
  -Description $taskDescr `
  -Action $action `
  -Trigger @($trigger1, $trigger2) `
  -User "SYSTEM" `
  -RunLevel Highest `
  -Force
