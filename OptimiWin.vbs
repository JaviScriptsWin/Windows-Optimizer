'Creado a partir del Script del usuario Aikon
'	https://github.com/aikoncwd/win10script

' Creando los objetos del programa
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oWSH = CreateObject("WScript.Shell")
Set oNET = CreateObject("WScript.Network")
Set oAPP = CreateObject("Shell.Application")
Set oWMI = GetObject("winmgmts:\\.\root\CIMV2")
Set oARG = WScript.Arguments
Set oWEB = CreateObject("MSXML2.ServerXMLHTTP")
Set oVOZ = CreateObject("SAPI.SpVoice")

' - - - - - - - - Se llama a las siguientes funciones - - - - - - - - - - - 
'###### PROGRAMA  ########
Call ForceConsole()		' Call llama a una función llamada "ForceConsole", que se ejecutará y volverá
Call showBanner()
' Call checkW10()		' Comprueba la version de Windows,  sólo te deja seguir si es Windows 10
Call runElevated()		' Pide permiso para lanzar el programa como Administrador
Call printf(" Requisitos OK...")
Call showMenu()			' Si llega hasta aquí, muestra el Menú de Opciones disponibles
'####### FIN DEL PROGRAMA. ###### Sólo que Showmenu tiene un bucle que finaliza solo al pulsar  0

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
' el nombre de la funcion es "printf"-------------------------------------------------importante
' a la función se pasa el parámetro llamado "txt" y lo visualiza en pantalla
' además salta de línea
Function printf(txt)
        WScript.StdOut.WriteLine txt
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
' Similar a "printf" sin saltar de linea
Function printl(txt)
        WScript.StdOut.Write txt
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
' la funcion "scanf" lee una cadena de caracteres hasta que pulses ENTER
Function scanf()
        scanf = LCase(WScript.StdIn.ReadLine) 
        'LCase Devuelve una cadena o un carácter convertidos en minúsculas.
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function Wait(n)
        WScript.Sleep Int(n * 1000)  ' Espera el numero de milisegundos que se indique
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
' Abre una ventana de comandos
Function ForceConsole()
        If InStr(LCase(WScript.FullName), "cscript.exe") = 0 Then
                oWSH.Run "cscript //NoLogo " & Chr(34) & WScript.ScriptFullName & Chr(34)
                WScript.Quit
        End If
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function showBanner()
         WScript.StdOut.WriteLine ""	  	'llama a la función "printf"
         WScript.echo " +--------------------------  "
         WScript.StdOut.WriteLine " ¦                           	¦"
         WScript.StdOut.WriteLine " ¦ WINDOWS 10 SCRIPT TWEAKER 	¦"
         WScript.StdOut.WriteLine " ¦ by AikonCWD               	¦"
         WScript.StdOut.WriteLine " ¦           v2.4 (05/2025)  	¦"
         WScript.StdOut.WriteLine " ¦  "  & Date()& "               	¦"
         WScript.StdOut.WriteLine " ¦ Modified by: Javier Gonzalez	¦"
         WScript.StdOut.WriteLine " +--------------------------    "
         WScript.StdOut.WriteLine ""
         WScript.echo " Comprobando requisitos del sistema..."
End Function
'' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
' Comprueba si la version de Windows es menos que Windows 10 (no se emplear actualmente)
Function checkW10()    ' No se usa para poder usarlo en W7 y W8
        If getNTversion < 10 Then ' "getNTversion" devuelve la versión que tienes de Windows.
                printf " ERROR: Necesitas ejecutar este script bajo Windows 10"
                printf " >>> Tu Windows es version:  >>>" & getNTversion +1
                printf ""
                printf " Press <enter> to quit"
                scanf
                WScript.Quit   ' ¡ finaliza el programa !
        End IF
End Function
'' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'  NO Comprueba si eres administrador y te pide permiso para ejecutarlo como Administrador
Function runElevated()  '  No estudiar
	'Set usuario = 
        If isUACRequired Then
                If Not isElevated Then RunAsUAC    ' Si no eres Asministrador ejecuta "RunAsUAC" para serlo
        Else
                If Not isAdmin Then
                     printf " ERROR: Necesitas ejecutar este script como Administrador!"
                     printf ""
                     printf " Press <enter> to quit"
                     scanf
                     WScript.Quit    ' Finaliza el Script pq no eres Administrador ni puedes lanzar el UAC
                End If
        End If
End Function
'' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function isUACRequired()
        r = isUAC()
        If r Then
                intUAC = oWSH.RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA")
                r = 1 = intUAC ' ¿?
        End If
        isUACRequired = r
End Function
'' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function isElevated()
        isElevated = CheckCredential("S-1-16-12288")
End Function
'' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function isAdmin()
        isAdmin = CheckCredential("S-1-5-32-544")
End Function
'' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function CheckCredential(p)   
        Set oWhoAmI = oWSH.Exec("whoami /groups")
        Set WhoAmIO = oWhoAmI.StdOut
        WhoAmIO = WhoAmIO.ReadAll
        CheckCredential = InStr(WhoAmIO, p) > 0
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function RunAsUAC()    '   no estudiar
        If isUAC Then
                printf ""
                printf " El script necesita ejecutarse con permisos elevados..."
                printf " acepta el siguiente mensaje:"
                Wait(2)
                oAPP.ShellExecute "cscript", "//NoLogo " & Chr(34) & WScript.ScriptFullName & Chr(34), "", "runas", 1
                WScript.Quit
        End If
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function isUAC()   '   no estudiar
        Set cWin = oWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")
        r = False
        For Each OS In cWin
                If Split(OS.Version,".")(0) > 5 Then
                        r = True
                Else
                        r = False
                End If
        Next
        isUAC = r
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function getNTversion()  '   no estudiar
        Set cWin = oWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")
        For Each OS In cWin
                getNTversion = Split(OS.Version,".")(0)
        Next
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
'--NO
Function cls() 				' función que deja en blanco la pantalla metiendo 100 lineas en blanco
        For i = 1 To 100	' realiza 100 veces las instrucciones de antes del NEXT
                printf " "
        Next
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			
Function menuCortana()' función que mostrará las operaciones con Cortana
	cls
	On Error Resume Next
	printf " _____ _                     ___ _      _____         _               "
	printf "|     |_|___ ___ ___ ___ ___|  _| |_   |     |___ ___| |_ ___ ___ ___ "
	printf "| | | | |  _|  _| . |_ -| . |  _|  _|  |   --| . |  _|  _| .'|   | .'|"
	printf "|_|_|_|_|___|_| |___|___|___|_| |_|    |_____|___|_| |_| |_|_|_|_|_|_|"                                                                  
	printf ""
	printf " Selecciona una opcion:"
	printf ""
	printf "  1 = Deshabilitar Microsoft Cortana"
	printf "  2 = Habilitar Microsoft Cortana"
	printf "  3 = Desinstalar Microsoft Cortana (!)(Necesita conectarse a Internet )="  
	printf "  4 = Reinstalar Microsoft Cortana  (!)"
	printf ""
	printf "  0 = Volver al menu principal"
	printf ""
	printl "  > "
	Select Case scanf
		Case "1"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search\AllowCortana", 0, "REG_DWORD"
			oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\CortanaEnabled", 0, "REG_DWORD"
			oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\SearchboxTaskbarMode", 0, "REG_DWORD"
			oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\BingSearchEnabled", 0, "REG_DWORD"
			printf ""
			printf " >> Reiniciando el explorador de Windows... espera 5 segundos!"
			oWSH.Run "taskkill.exe /F /IM explorer.exe"
			wait(5)
			oWSH.Run "explorer.exe"
		Case "2"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search\AllowCortana", 1, "REG_DWORD"
			oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\CortanaEnabled", 1, "REG_DWORD"
			oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\SearchboxTaskbarMode", 1, "REG_DWORD"
			oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\BingSearchEnabled", 1, "REG_DWORD"
			printf ""
			printf " >> Reiniciando el explorador de Windows... espera 5 segundos!"
			oWSH.Run "taskkill.exe /F /IM explorer.exe"
			wait(5)
			oWSH.Run "explorer.exe"
		Case "3"     
			printf ""
			printf "  >> Perderas la opcion de usar el buscador del menu inicio"
			printl "  >> Desinstalar definitivamente Cortana. Continuar? (s/n) > "
			If scanf = "s" Then
				oWEB.Open "GET", "https://raw.githubusercontent.com/aikoncwd/win10script/master/dependencias/deleteCortana.bat", False
				oWEB.Send
				wait(1)
				Set F = oFSO.CreateTextFile(currentFolder & "\deleteCortana.bat")
					F.Write oWEB.ResponseText
				F.Close
				oWSH.Run currentFolder & "\deleteCortana.bat"			
			End If
		Case "4"
			printf ""
			printf "  >> Utiliza esta opcion SOLO si has desinstalado Cortana usando la opcion (3)"
			printl "  >> El proceso de reinstalacion de Cortana es lento..."
			printl "  >> Una vez finalizado el proceso, reinicia el PC. Continuar? (s/n) > "
			If scanf = "s" Then
				oWSH.Run "sfc /scannow"
			End If
		Case "0"
			Call showMenu()
		Case Else
			Call menuCortana()    ' Si el numero es incorrecto Vuelve a llamarse a si mismo
	End Select
    'Call menuCortana()
End Function

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function showMenu()
         WScript.Sleep (500)	' espera 1 segundo   (1000 milisegundos)
        'Wait(2)				' función que espera el número de segundos indicado
        cls					    ' función que deja en blnco la pantalla metiendo 100 lineas en blanco
        WScript.StdOut.WriteLine " #############################"
        printf " #                           #"
        printf " # WINDOWS 10 SCRIPT TWEAKER #"
        printf " # by AikonCWD               #"
        printf " #                      v2.0 #"
        WScript.StdOut.WriteLine " ¦ " & Date()& "                   ¦"
        WScript.StdOut.WriteLine " ¦ Modified by: Javier Gonzalez    ¦"
        printf " #############################"
        printf ""
        printf ""
        printf " Selecciona una opcion:"
        printf ""
        printf "   1 = Habilitar icono en escritorio: Modo Dios"
        printf "   2 = Deshabilitar Control de Cuentas de Usuario (UAC)"
        printf "   3 = Ejecutar limpiador de Windows. Libera espacio y borrar Windows.old"
        printf "   4 = Habilitar/Deshabilitar inicio de sesion sin password"
        printf "   5 = Mostrar web con combinacion de teclas utiles en Win10"
        printf "   6 = Instalar/Desinstalar caracteristicas de Windows"
        printf ""
        printf "   7 = Impedir que Microsoft recopile informacion de este equipo"
        printf "   8 = Desinstalar Metro Apps pre-instaladas en Windows 10"
        printf "   9 = Deshabilitar OneDrive"
        printf "  10 = Deshabilitar Windows Defender"
        printf ""
        printf "  11 = Optimizar y prolongar la vida de tu disco duro SSD"
        printf ""
        printf "  12 = Mostrar estado de la activacion de Windows 10"
        printf "  13 = Activar Windows 10: Ejecutar slmgr /ato 30 veces seguidas"
        printf "  14 = Deshabilitar Programador de Tareas "
        printf "  15 = Deshabilitar IPv6 "
        printf "  16 = Deshabilitar Servicios Basura: SSDP,uPnP,Reg. Remoto, Geoloc ...." 
        printf "  17 = Reserva de Ancho de Banda" 
        printf "  18 = Subir número de conexiones TCP" 
        printf "  19 = Eliminar todos los autoruns de Windows" 
    WScript.StdOut.WriteLine "  20 = Eliminar Cortana W10 (quizá no funcione en tu versión)"
    WScript.StdOut.WriteLine "  21 = Eliminar archivos temporales de Firefox, Chrome y reducir carpeta WinSxS "
    WScript.StdOut.WriteLine "  22 = Deshabilitar Actualizaciones de Windows (Windows Update) "   'PENDIENTE
    WScript.StdOut.WriteLine "  23 = Deshabilitar historial de actividad "
    WScript.StdOut.WriteLine "  24 = Reducir Carpeta WinSxS  "
    WScript.StdOut.WriteLine "  25 = Deshabilitar Mantenimiento Programado (encender de madrugada)  "
	WScript.StdOut.WriteLine "  26 = Ver si alguna Tarea Programada va a Encender Windows  "
	WScript.StdOut.WriteLine "  27 = Comprobar si tienes Bitlocker en alguna partición del disco duro"
	WScript.StdOut.WriteLine "  28 = Win 11 --> Eliminar Menú botón derecho "
	WScript.StdOut.WriteLine "  29 = Eliminar Muchas tareas Programadas ¡Cuidado!"
	WScript.StdOut.WriteLine "  30 = Desinstala Office Preinstalado"   	
	WScript.StdOut.WriteLine  "  <33> = Optimizar >>  7, 8, 9, 11, 15, 16, 19 "
    printf "   0 = Salir"
    printf ""
    printl " > "
        
    Opcion = scanf		' leemos la opción introducida por el usuario
        ' Igual que Opcion = LCase(WScript.StdIn.ReadLine) 
        
    If Not isNumeric(Opcion) = True Then
        printf ""
        printf " ERROR: Opcion invalida, solo se permiten numeros..."
        WScript.Sleep (1000)
        Call showMenu()    	' si opcion no es numérica vuelve a mostrar el Menú
        Exit Function		' finaliza la función showmenu, para que no vuelva 
    End If
        ' Cuando se introduzca un número sigue por aquí
    Select Case Opcion
        Case 1		Call createGodMode()   :	Call showMenu
			
        Case 2   	Call disableUAC()	:	Call showMenu
			
        Case 3		Call cleanSO()   	:	Call showMenu
			
        Case 4		Call noPWD()  		:	Call showMenu
			
        Case 5      Call showKeyboardTips()   :	Call showMenu
                
		Case 6		Call optionalFeatures()   :	Call showMenu
                
		Case 7		Call disableSpyware()	:	Call showMenu
                
		Case 8    	Call cleanApps()   	:	Call showMenu
                
		Case 9		Call disableOneDrive()   :	Call showMenu
        Case 10		Call disableDefender()   :	Call showMenu
        Case 11	
                	Call powerSSD()  
					Call Comp_Bitlocker() 	:	Call showMenu
        Case 12
                    Call showActivation()   :	Call showMenu
        Case 13
                    Call activate30()   	:	Call showMenu
        Case 14
                    Call disableScheduler()   :	Call showMenu
        Case 15
                    Call disableIPv6()   	:	Call showMenu
        Case 16 
                	Call DisableWasteServices()     :	Call showMenu
        Case 17 
                	Call AnchoBanda_QoS()     :	Call showMenu
        Case 18
                	Call Subir_conexiones_TCP()   :	Call showMenu
        Case 19
                	Call Quitar_Autoruns()   :	Call showMenu
        Case 20 
                	' Quitamos  Cortana
                	WScript.StdOut.WriteLine  " ¡¡¡¡¡¡¡¡¡¡¡Pulsada la opcion 20 !!!!!!!!"
                		'-------Instrucciones para deshabilitar Cortana
        			Call MenuCortana()                		                		
        			Call showMenu()
                	Exit Function
        Case 21
					Call BorraTempFirefoxChrome ()  :	Call showMenu
			
        Case 22 	Call DisableWindowsUpdate ()   	:	Call showMenu
               		
		Case 23 Call DisableActivityHistory ()  :	Call showMenu
                       
        Case 24	Call CarpetaWinSxS ()   	:	Call showMenu
                 
		Case 25	Call MaintenanceScheduled()   	:	Call showMenu
      			
		Case 26	call TareasProgamadasEnciendenPC()	   :	Call showMenu
               		
		case 27	call Comp_Bitlocker()   	:	Call showMenu
		
		case 28	call MenuDerechoW11()   		:	Call showMenu

		case 29	call BorraTareaProgramadas()   		:	Call showMenu
		
		case 30	call DesinstalaOffice()   		:	Call showMenu
						
        Case 33  '  Llamo a las funciones de las opciones: 7 , 8, 9, 11, 15, 16, 19 
               		Call disableSpyware()
               		Call cleanApps()
                     Call disableOneDrive()
               		Call powerSSD()
                	Call disableIPv6()   
               		Call DisableWasteServices()  
					Call Quitar_Autoruns()
					Call showMenu()
        Case 0
                    printf ""
                    printf " Gracias por utilizar mi script"
                    printf " AikonCWD dice adios!! ;D"
                    wait(2)    ' llama a la función de espera, idem a WScript.Sleep (2000)
                    WScript.Quit  ' FIN DEL PROGRAMA
        Case Else           ' Necesario por si se ha introducido un valor que no esté en las opciones
               		printf ""
               		printf " INFO: Opción inválida, ese número no está disponible"
               		Call showMenu()
               		Exit Function
        End Select
End Function     'FINAL DE SHOWMENU ()
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function createGodMode()
        godFolder = oWSH.SpecialFolders("Desktop") & "\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
        If oFSO.FolderExists(godFolder) = False Then
                oFSO.CreateFolder(godFolder)
                printf ""
                printf " INFO: Se ha creado un acceso directo en tu escritorio"
                Call showMenu
        Else
                printf ""
                printf " INFO: Ya existe el modo dios, ejecutalo desde tu Escritorio"
                call showMenu
        End If
End Function
'' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function disableUAC()
        printf ""
        printf " Ahora se ejecutara una ventana..."
        printf " Mueve la barra vertical hasta el nivel mas bajo"
        printf " Acepta los cambios y reinicia el ordenador"
        wait(2)
        printf ""
        printf " INFO: Executing UserAccountControlSettings.exe"
        oWSH.Run "UserAccountControlSettings.exe"
End Function
'' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function cleanSO()
     	printf " "
        printf " Ahora se ejecutará una ventana..."
        printf " Marca las opciones deseadas de limpieza"
        printf " Acepta los cambios y reinicia el ordenador"
        printf " "
        ' --- BORRAREMOS LOS ARCHIVOS TEMPORALES DE LA CARPETA  %temp% esquivando los mensaje de error que se produzcan  -----
         oWSH.Run "powershell Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue"
         'Opción 21 (Fucnión borrar temporales de Firefox y Chrome)
        Call BorraTempFirefoxChrome

       printf " INFO: Ejecutando cleanmgr.exe"
       oWSH.Run "cleanmgr.exe cleanmgr /lowdisk/dc"
		' esta opción elige C: y D: y selecciona todo
       wait(2)
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function noPWD()
        printf ""
        printf " Ahora se ejecutara una ventana..."
        printf " Desmarca la opcion: Los usuarios deben escribir su nombre y password para usar el equipo"
        printf " Acepta los cambios y reinicia el ordenador"
        wait(2)
        printf ""
        printf " INFO: Executing control userpasswords2"
        oWSH.Run "control userpasswords2"
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function optionalFeatures()
        printf ""
        printf " Ahora se ejecutara una ventana..."
        printf " Marca/Desmarca las opciones deseadas"
        printf " Acepta los cambios y reinicia el ordenador"
        wait(2)
        printf ""
        printf " INFO: Executing optionalfeatures.exe"
        oWSH.Run "optionalfeatures.exe"
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function showKeyboardTips()
        printf ""
        printf " Ahora se ejecutara una pagina web..."
        printf " En ella encontraras todas las combinaciones de teclas utiles en Win10"
        wait(2)
        printf ""
        printf " INFO: Executing web-browser"
        oWSH.Run "http://reviews.gizmodo.com/the-ultimate-guide-to-windows-10-keyboard-shortcuts-1720656591"
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function disableSpyware()
'ver https://www.fayerwayer.com/2015/11/microsoft-se-aseguro-de-camuflar-el-espionaje-en-windows-10/
        printf ""
        printf " Deshabilitando Telemetry usando el registro..."
        wait(1)
                oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\AllowTelemetry", 0, "REG_DWORD"
                oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection\AllowTelemetry", 0, "REG_DWORD"

        printf ""
        printf " INFO: Telemetry deshabilitado correctamente"
 
        pathLOG = oWSH.ExpandEnvironmentStrings("ProgramData") & "\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
        printf ""
        printf " Borrando DiagTrack Log..."
        wait(1)
                If oFSO.FileExists(pathLOG) Then oFSO.DeleteFile(pathLOG)
        printf ""
        printf " INFO: DiagTrack Log borrado correctamente"
 
        printf ""
        printf " Deshabilitando servicios de seguimiento..."
        wait(1)
                oWSH.Run "sc stop DiagTrack"
                oWSH.Run "sc stop RetailDemo"
                oWSH.Run "sc stop dmwappushservice"
                oWSH.Run "sc config DiagTrack start=disabled"
                oWSH.Run "sc config RetailDemo start=disabled"
                oWSH.Run "sc config dmwappushservice start=disabled"
        printf ""
        printf " INFO: Servicios de seguimiento deshabilitados"
 
        printf ""
        printf " Deshabilitando tareas programadas que envian datos a Microsoft..."    
        oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" & chr(34) & " /DISABLE"
        oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Application Experience\ProgramDataUpdater" & chr(34) & " /DISABLE"
        oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" & chr(34) & " /DISABLE"
        oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" & chr(34) & " /DISABLE"
        oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" & chr(34) & " /DISABLE"
        oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" & chr(34) & " /DISABLE"
        printf ""
        printf " INFO: Tareas programadas de seguimiento deshabilitadas"
 
        printf ""
        printf " Deshabilitando acceso a los servidores de publicidad de Microsoft..."
        wait(1)
        Set F = oFSO.CreateTextFIle("C:\Windows\System32\drivers\etc\hosts", True)
	' Aqui tenemos muchos dominios mas 2021  https://gist.github.com/tildebyte/b70ea62e38832197c07ac046899f25c8
                F.WriteLine "127.0.0.1  localhost"
                F.WriteLine "127.0.0.1  localhost.localdomain"
                F.WriteLine "255.255.255.255    broadcasthost"
                F.WriteLine "::1                localhost"
                F.WriteLine "127.0.0.1  local"
                F.WriteLine "0.0.0.0 vortex.data.microsoft.com"
                F.WriteLine "0.0.0.0 vortex-win.data.microsoft.com"
                F.WriteLine "0.0.0.0 telecommand.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 telecommand.telemetry.microsoft.com.nsatc.net"
                F.WriteLine "0.0.0.0 oca.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 oca.telemetry.microsoft.com.nsatc.net"
                F.WriteLine "0.0.0.0 sqm.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 sqm.telemetry.microsoft.com.nsatc.net"
                F.WriteLine "0.0.0.0 watson.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 watson.telemetry.microsoft.com.nsatc.net"
                F.WriteLine "0.0.0.0 redir.metaservices.microsoft.com"
                F.WriteLine "0.0.0.0 choice.microsoft.com"
                F.WriteLine "0.0.0.0 choice.microsoft.com.nsatc.net"
                F.WriteLine "0.0.0.0 df.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 reports.wes.df.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 wes.df.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 services.wes.df.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 sqm.df.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 watson.ppe.telemetry.microsoft.com"
                F.WriteLine "0.0.0.0 telemetry.appex.bing.net"
                F.WriteLine "0.0.0.0 telemetry.urs.microsoft.com"
                F.WriteLine "0.0.0.0 telemetry.appex.bing.net:443"
                F.WriteLine "0.0.0.0 settings-sandbox.data.microsoft.com"
                F.WriteLine "0.0.0.0 vortex-sandbox.data.microsoft.com"
                F.WriteLine "0.0.0.0 survey.watson.microsoft.com"
                F.WriteLine "0.0.0.0 watson.live.com"
                F.WriteLine "0.0.0.0 watson.microsoft.com"
                F.WriteLine "0.0.0.0 statsfe2.ws.microsoft.com"
                F.WriteLine "0.0.0.0 corpext.msitadfs.glbdns2.microsoft.com"
                F.WriteLine "0.0.0.0 compatexchange.cloudapp.net"
                F.WriteLine "0.0.0.0 cs1.wpc.v0cdn.net"
                F.WriteLine "0.0.0.0 a-0001.a-msedge.net"
                F.WriteLine "0.0.0.0 statsfe2.update.microsoft.com.akadns.net"
                F.WriteLine "0.0.0.0 sls.update.microsoft.com.akadns.net"
                F.WriteLine "0.0.0.0 fe2.update.microsoft.com.akadns.net"
                F.WriteLine "0.0.0.0 65.55.108.23 "
                F.WriteLine "0.0.0.0 65.39.117.230"
                F.WriteLine "0.0.0.0 23.218.212.69 "
                F.WriteLine "0.0.0.0 134.170.30.202"
                F.WriteLine "0.0.0.0 137.116.81.24"
                F.WriteLine "0.0.0.0 diagnostics.support.microsoft.com"
                F.WriteLine "0.0.0.0 corp.sts.microsoft.com"
                F.WriteLine "0.0.0.0 statsfe1.ws.microsoft.com"
                F.WriteLine "0.0.0.0 pre.footprintpredict.com"
                F.WriteLine "0.0.0.0 204.79.197.200"
                F.WriteLine "0.0.0.0 23.218.212.69"
                F.WriteLine "0.0.0.0 i1.services.social.microsoft.com"
                F.WriteLine "0.0.0.0 i1.services.social.microsoft.com.nsatc.net"
                F.WriteLine "0.0.0.0 feedback.windows.com"
                F.WriteLine "0.0.0.0 feedback.microsoft-hohm.com"
                F.WriteLine "0.0.0.0 feedback.search.microsoft.com"
        F.Close
        printf ""
        printf " INFO: Fichero HOSTS escrito correctamente"
       
        'Call showMenu      

	'Nota: La entrada siguiente almacena rutas que se pueden editar
	'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\PersistentRoutes
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function disableOneDrive()
        printf ""
        printf " Deshabilitando OneDrive usando el registro..."
        wait(1)
                oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive\DisableFileSyncNGSC", 1, "REG_DWORD"
                oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive\DisableFileSyncNGSC", 1, "REG_DWORD"
        printf ""
        printf " INFO: OneDrive deshabilitado correctamente"
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function disableDefender()
        printf ""
        printf " Deshabilitando Windows Defender usando el registro..."
        wait(1)
                oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\DisableAntiSpyware", 1, "REG_DWORD"
                oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\DisableAntiSpyware", 1, "REG_DWORD"
        printf ""
        printf " INFO: Windows Defender deshabilitado correctamente"
        printf " WARNING: Si no tienes antivirus, te recomiendo 360 Total Security: www.360totalsecurity.com  o Sophos"
        wait(1)
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function showActivation()
        printf ""
        printf " En unos segundos aparecera el estado de tu activacion..."
        wait(1)
                oWSH.Run "slmgr.vbs /dlv"
                oWSH.Run "slmgr.vbs /xpr"
        printf ""
        printf " INFO: Script slmgr ejecutado correctamente"
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Function activate30()
        printf ""
        printf " Esta funcion sirve para forzar la activacion de Windows 10"
        printf " solo se debe utilizar si tienes problemas para validar la licencia"
        printf ""
        printl " El proceso demora varios minutos. Deseas continuar? (s/n) "
       
        If scanf <> "s" Then
                printf ""
                printf " INFO: Proceso cancelado por el usuario"
                wait(1)
                Call showMenu
                Exit Function
        End If
       
        printf " Se va a ejecutar slmgr /ato 30 veces, sea paciente..."
        wait(1)
                For i = 1 To 30
                        printf "  > (" & i & ") Ejecutando slmgr.vbs /ato"
                        oWSH.Run "slmgr.vbs /ato"
                Next
        printf ""
        printf " INFO: Script slmgr ejecutado correctamente"
        printf " INFO: El resultado tarda unos segundos en aparecer, espere..."
        wait(1)
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Function cleanApps()
        printf ""
        printf " Este script va a desinstalar el siguiente listado de Apps:"
        printf ""
        printf "  > Bing"
        printf "  > Zune"
        printf "  > (no)Skype"
        printf "  > XboxApp"
        printf "  > OneNote"
        printf "  > 3DBuilder"
        printf "  > Getstarted"
        printf "  > Windows Maps"
        printf "  > Windows Phone"
        printf "  > (no)Windows Camera"
        printf "  > Windows Alarms"
        printf "  > (no)Windows Sound Recorder"
        printf "  > Windows Communications Apps"
        printf "  > Microsoft People"
        printf "  > Microsoft Office Hub"
        printf "  > Microsoft Solitaire Collection"
        printf "  > ...y otros muchos más"
        printf " Obtenido de https://www.tenforums.com/tutorials/4689-uninstall-apps-windows-10-a.html"
        printf ""
        printf " La opcion no es reversible. Deseas continuar? (s/n) "
     
        If scanf = "s" Then
                  ' oWSH.Run "powershell get-appxpackage -AllUsers -Name  *SkypeApp* | Remove-AppxPackage", 1, True
		  'oWSH.Run "powershell get-appxpackage -Name *WindowsSoundRecorder* | Remove-AppxPackage", 1, True
                  'oWSH.Run "powershell get-appxpackage -Name *WindowsCamera* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -AllUsers -Name *Bing* 	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -AllUsers -Name  *Zune*	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -AllUsers -Name *OneNote* 	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *3DBuilder*      	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *Getstarted*     	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *Microsoft.People* 	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *MicrosoftOfficeHub* | Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *MicrosoftSolitaireCollection* | Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *WindowsAlarms*  	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *WindowsMaps*    	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *WindowsPhone*   	| Remove-AppxPackage", 1, True
                oWSH.Run "powershell get-appxpackage -Name *windowscommunicationsapps* | Remove-AppxPackage", 1, True
                    ' ---- Javier     2019 ---
		 	'oWSH.Run "powershell Get-AppxPackage *Photos* 				| Remove-AppxPackage", 1, True
		 	'oWSH.Run "powershell Get-AppxPackage *WindowsStore* 			| Remove-AppxPackage", 1, True
			' oWSH.Run "powershell Get-AppxPackage *Microsoft3DViewer* 		| Remove-AppxPackage", 1, True
		 	'oWSH.Run "powershell Get-AppxPackage *Microsoft.WindowsCalculator* 	| Remove-AppxPackage", 1, True
		 	oWSH.Run "powershell Get-AppxPackage *Microsoft.Appconnector* 		| Remove-AppxPackage", 1, True
		 	oWSH.Run "powershell Get-AppxPackage *Microsoft.Asphalt8Airborne* 	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *king.com.CandyCrushSodaSaga* 	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Microsoft.DrawboardPDF* 		| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Facebook* 			| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage -AllUsers -Name *BethesdaSoftworks.FalloutShelter* | Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage -AllUsers -Name *FarmVille2CountryEscape* 	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage -AllUsers -Name *Microsoft.WindowsFeedbackHub* 	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage -AllUsers -Name *Microsoft.GetHelp* 		| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *officehub* 			| Remove-AppxPackage", 1, True			
			oWSH.Run "powershell Get-AppxPackage *Microsoft.Getstarted* 		| Remove-AppxPackage", 1, True				 
			oWSH.Run "powershell Get-AppxPackage *windowscommunicationsapps* 	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Microsoft.Messaging* 		| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Wallet* 				| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *ConnectivityStore* 		| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *MinecraftUWP* 			| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Microsoft.BingFinance*   	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Microsoft.ZuneVideo*     	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Netflix* 			| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Microsoft.BingNews*      	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *OneNote* 			| Remove-AppxPackage", 1, True
                         oWSH.Run "powershell Get-AppxPackage *Microsoft.OneConnect*    | Remove-AppxPackage", 1, True		
			oWSH.Run "powershell Get-AppxPackage *PandoraMediaInc* 		| Remove-AppxPackage", 1, True									
			oWSH.Run "powershell Get-AppxPackage *CommsPhone* 		| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *flaregamesGmbH.RoyalRevolt2* | Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *WindowsScan* 		| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *AutodeskSketchBook* 	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *bingsports* 		| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Office.Sway* 		| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Microsoft.Getstarted*    	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Twitter* 			| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage *Microsoft.BingWeather*   	| Remove-AppxPackage", 1, True
				 
			oWSH.Run "powershell Get-AppxPackage *Microsoft.XboxSpeechToTextOverlay* | Remove-AppxPackage", 1, True    

		        oWSH.Run "powershell get-appxpackage -AllUsers -Name *XboxApp* 	| Remove-AppxPackage", 1, True 
 			oWSH.Run "powershell Get-AppxPackage -AllUsers -Name *XboxOneSmartGlass* 	| Remove-AppxPackage", 1, True
			oWSH.Run "powershell Get-AppxPackage -AllUsers Microsoft.Xbox.TCUI 		| Remove-AppxPackage", 1, True  
			oWSH.Run "powershell Get-AppxPackage -AllUsers Microsoft.XboxGameOverlay 	| Remove-AppxPackage", 1, True  
			oWSH.Run "powershell Get-AppxPackage -AllUsers Microsoft.XboxGamingOverlay 	| Remove-AppxPackage", 1, True  
			oWSH.Run "powershell Get-AppxPackage -AllUsers Microsoft.XboxIdentityProvider 	| Remove-AppxPackage", 1, True  
			oWSH.Run "powershell Get-AppxPackage -AllUsers Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage", 1, True  
                '----------------------
                printf ""
                printf " INFO: Las Apps se han desinstalado correctamente..."
        Else
                printf ""
                printf " INFO: Operacion cancelada por el usuario"
        End If
        wait(1)
End Function
 
Function powerSSD()
        printf ""
        printf " Este script va a modificar las siguientes configuraciones:"
        printf ""
        printf "  > Habilitar TRIM"
        printf "  > Deshabilitar VSS (Shadow Copy)"
        printf "  > Deshabilitar Windows Search + Indexing Service"
        printf "  > Deshabilitar defragmentador de discos"
        printf "  > Deshabilitar hibernacion del sistema"
        printf "  > Deshabilitar Prefetcher + Superfetch"
        printf "  > Deshabilitar ClearPageFileAtShutdown + LargeSystemCache"
        printf ""
        printl " Deseas continuar? (s/n) "
       
        If scanf = "s" Then
                printf ""
                oWSH.Run "fsutil behavior set disabledeletenotify 0"
                printf " # TRIM habilitado"
                wait(1)
                oWSH.Run "vssadmin Delete Shadows /All /Quiet"
                oWSH.Run "sc stop VSS"
                oWSH.Run "sc config VSS start=disabled"
                printf " # Shadow Copy eliminada y deshabilitada"
                wait(1)
                oWSH.Run "sc stop WSearch"
                oWSH.Run "sc config WSearch start=disabled"
                printf " # Windows Search + Indexing Service deshabilitados"
                wait(1)
                oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Defrag\ScheduledDefrag" & chr(34) & " /DISABLE"
                printf " # Defragmentador de disco deshabilitado"
                wait(1)
                oWSH.Run "powercfg -h off"
                printf " # Hibernacion deshabilitada"
                wait(1)
                oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnablePrefetcher", 0, "REG_DWORD"
                oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnableSuperfetch", 0, "REG_DWORD"
                oWSH.Run "sc stop SysMain"
                oWSH.Run "sc config SysMain start=disabled"
                printf " # Prefetcher + Superfetch deshabilitados"
                wait(1)
                oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\ClearPageFileAtShutdown", 0, "REG_DWORD"
                oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\LargeSystemCache", 0, "REG_DWORD"
                printf " # ClearPageFileAtShutdown + LargeSystemCache deshabilitados"
                wait(1)
                printf ""
                printf " INFO: Felicidades, acabas de prolongar la vida y el rendimiento de tu SSD"    
        Else
                printf ""
                printf " INFO: Operacion cancelada por el usuario"
        End If
        wait(1)

End Function
' - - - - - - - - - - - - - - - - - - - - - - - - 
Function disableScheduler()
	Wait(1)
	oWSH.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Schedule\start", 4, "REG_DWORD"
	MsgBox "Se ha deshabilitado el programador de tareas"
	Call showMenu
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - 
Function disableIPv6()
	Wait(1)
		oWSH.Run "powershell -noexit Disable-NetAdapterbinding -name "*"  -componentID ms_tcpip6 ", 1, False	
		MsgBox "IPV6 deshabilitado"
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - 
Function DisableWasteServices()  
' Deshabilitar servicios SSDP, uPnP, Windows Search, SysMain RemoteRegistry, rasauto, rasman, SessionEnv, XboxGipSvc
' para acelerar Windows 

	    oWSH.Run "sc stop 	WSearch"
            oWSH.Run "sc config WSearch start=disabled"
            printf " # Windows Search + Indexing Service deshabilitados"
            
            oWSH.Run "sc stop 	sysmain"
            oWSH.Run "sc config sysmain start=disabled"
            printf " # Windows Search + Indexing Service deshabilitados"
                
            oWSH.Run "sc stop 	SSDPSRV"
            oWSH.Run "sc config SSDPSRV start=disabled"
            printf " # SERVICIO SSDP deshabilitado"
                
            oWSH.Run "sc stop 	upnphost"
            oWSH.Run "sc config upnphost start=disabled"
            printf " # SERVICIO uPnP deshabilitado"
                
            oWSH.Run "sc stop RemoteRegistry"
            oWSH.Run "sc config RemoteRegistry start=disabled"
            printf " # SERVICIO RemoteRegistry   manual"
                
            'oWSH.Run "sc stop rasman"
            'oWSH.Run "sc config rasman start=manual"
            printf " # SERVICIO rasman   manual"
                
            oWSH.Run "sc stop rasauto"
            oWSH.Run "sc config rasman start=manual"
            printf " # SERVICIO rasauto   manual"
                
            oWSH.Run "sc stop 	SessionEnv"
            oWSH.Run "sc config SessionEnv start=manual"
            printf " # SERVICIO SessionEnv   manual"

            oWSH.Run "sc stop 	lfsvc"
            oWSH.Run "sc config lfsvc start=disabled"
            printf " # SERVICIO Geolocalizacion deshabilitado   "
            
            WSH.Run "sc stop 	XboxGipSvc"
            oWSH.Run "sc config XboxGipSvc  start=disabled"
            printf " # SERVICIO Xbox Accessory Management Service deshabilitado   "
           
            
            oWSH.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPSvc\start",   4 ,"REG_DWORD"
            oWSH.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPUserSvc\start", 4, "REG_DWORD"
            printf " # SERVICIO Connected Devices Platform Service (Servicio de plataforma de dispositivos conectados) deshabilitado   "
            ' Ver estado de este sesrvicio en diferentes Windows 10 http://batcmd.com/windows/10/services/cdpsvc/
            	'Use following values of your choice and click “OK”:
	            '0 = Boot    '1 = System    '2 = Automatic   3 = Manual   4 = Disabled

End Function
' - - - - - - - - - - - - - - - - - - - - - - - - 
Function AnchoBanda_QoS()  
	' Pedimos al usuarios el ancho de banda que quiere reservar para Windows
	' Le recomendaremos en el mensaje un valor minimo de 8 (8% de reserva de ancho de banda)
	
	RESERVA = oWSH.RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PSched\NonBestEffortLimit")
	RESERVA = InputBox ("Introduce el porcentaje de ancho de banda que quieres reservar (Recomendado 8)", "Valor QoS", RESERVA)
	oWSH.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PSched\NonBestEffortLimit", RESERVA, "REG_DWORD"

	'Reg Add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PSched\NonBestEffortLimit /T  /D" & RESERVA & "/F"
	printf " INFO: REservado el " & RESERVA & " % de ancho de banda"
End Function
'---------------------------------------------------

Function Subir_conexiones_TCP()  
' Ponemos numero de conexiones a infinitas (por defecto es 10)
	oWSH.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\EnableConnectionRateLimiting", 0, "REG_DWORD"
	printf " INFO: Operacion realizada "
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - 

Function Quitar_Autoruns()
Rem DESHABiLITAMOS LOS AUTORUN DE TODAS LAS UNIDADES DE DISCO Y PENDRIVES PARA EVITAR VIRUS AUTORUN.INF.

	Set variable =CreateObject("Wscript.Shell")
	MsgBox "opcion 19 en la funcion"
	variable.RegWrite  "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun"	, 255, "REG_DWORD"
	variable.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveAutoRun"      	, 262143, "REG_DWORD"
	variable.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutoRun"           	, 1     , "REG_DWORD"
	variable.RegWrite "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\HonorAutoRunSetting" 	, 1     , "REG_DWORD"
	variable.RegWrite "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun"  	, 255   , "REG_DWORD"
	variable.RegWrite "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveAutoRun"  		, 262143, "REG_DWORD"
	variable.RegWrite "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutoRun"  		, 1 , "REG_DWORD"
	variable.RegWrite "HKLM\SYSTEM\CurrentControlSet\Services\Cdrom\AutoRun" 					, 0	, "REG_DWORD"	
	variable.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping\Autorun.inf" , "@SYS:DoesNotExist" , "REG_SZ"
End Function
' - - - - - - - - - - - - - - - - - - - - - - - - 

Function  BorraTempFirefoxChrome ()	'Borra los temporales de Chrome y Firefox BorraTempFirefoxChrome

	'---Temporales Chrome--- Creamos un script PS1 mediante el lenguaje VBS que borre los temporales de Chrome
	Const ForReading = 1, ForWriting = 2, ForAppending = 8
	Dim fs, f

	Set fs = CreateObject("Scripting.FileSystemObject")
   
	Set f = fs.createTextFile("c:\windows\temp\t3.ps1", True)    'Creo un archivo PS1 con las instrucciones para borrar temporales de Chrome

	f.Write "$tempchrome = " & """" & "$env:userprofile\AppData\Local\Google\Chrome\User Data\Default\Cache\*"
	f.Writeline """"   
    			' necesitamos cerrar la cadena en el archivo y no se puede poner en la línea anterior
	f.Writeline "Remove-Item -path  $tempchrome  -Recurse -Force -EA SilentlyContinue -Verbose"
	f.WriteLine "echo $tempchrome"
	f.Close
	oWSH.Run "powershell  c:\windows\temp\t3.ps1"  	'ejecutamos el archivo t3.ps1 creado
    	' -------Fin temp Chrome----------------------------
	'------Temporales Firefox
'	'-----  Borra temporales e FIREFOX creando un script PS1 y ejecutándolo----------------------------

   	 Set f = fs.createTextFile("c:\windows\temp\t4.ps1", , True)
   	f.Write "$firetemp= " & """" & "$env:userprofile" & "\appdata\local\mozilla\firefox\profiles\"  
    	f.WriteLine """"   							' se necesita añadir una " y pone salto de linea
 	
    	f.WriteLine "$CarpFirefox = ls $firetemp"	' $CarpFirefox tiene la carpeta de firefox diferente en cada PC  por ej:  345qwerqw.default
   	
    	f.Write 	"$firetemp= " & """" & "$env:userprofile" & "\appdata\local\mozilla\firefox\profiles\"  & "$CarpFirefox" & "\cache2"
   	f.WriteLine """"
    	f.WriteLine "echo $firetemp"
    	f.Writeline "Remove-Item -path  $firetemp  -Recurse -Force -EA SilentlyContinue -Verbose"	'Borramos todos los archivos
    	f.Close
    	oWSH.Run "powershell c:\windows\temp\t4.ps1" 
		'---fin temp Firefox

	CarpTemp = oFSo.GetSpecialFolder (2) & "\*.*"     'CarpTemp es la carpeta Temporal de Windows (al final la borramos)
	' -----  Reduce tamaño de la carpeta WinSxS
    	msgbox " El proceso puede tardar varios minutos--"
    	oWSH.Run " Dism.exe /online /Cleanup-Image /StartComponentCleanup"
End Function 
'----------------------------------------------
Function DisableWindowsUpdate ()
	' Para los servicios
	oWSH.Run "sc stop WaasMedicSvc"  ' Windows Update Medic Service 
	oWSH.Run "sc stop wuauserv" 	 ' Servicio Windows Update 
	oWSH.Run "sc stop UsoSvc"  	 'servicio Orchestrator 

	' deshabilitará los servicios de Windows Update

	oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Services\WaasMedicSvc\start", 4, "REG_DWORD"
	oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv\Start" ,   3 , "REG_DWORD"
 	oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc\Start" ,     4, "REG_DWORD"

'0 = Boot  '1 = System  '2 = Automatic  3 = Manual  4 = Disabled

	' Otra manera: oWSH.Run "REG ADD HKLM\SYSTEM\CurrentControlSet\Services\WaasMedicSvc /v Start /f /t REG_DWORD /d 4"
	'escribe un valor 4 en la variable start de esa rama del Registro, 4 = servicio deshabilitado.
	'Deshabilitar la tarea que ejecuta Windows Update
	
	oWSH.run "cmd /K schtasks.exe /change /tn  ""\Microsoft\Windows\WindowsUpdate\scheduled start"" /disable"
End Function 
'----------------------------------------------
Function DisableActivityHistory ()
    msgbox "pasa al 23 abajo (DisableActivityHistory) "
    oWSH.RegWrite  "HKLM\SOFTWARE\Policies\Microsoft\Windows\System\PublishUserActivities",0,"REG_DWORD"
    oWSH.RegWrite  "HKLM\SOFTWARE\Policies\Microsoft\Windows\System\EnableActivityFeed",   0,"REG_DWORD"
    oWSH.RegWrite  "HKLM\SOFTWARE\Policies\Microsoft\Windows\System\UploadUserActivities", 0,"REG_DWORD"
    ' lo siguiente es similar a la opcion 7 de seguimiento
    oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\AllowTelemetry", 0, "REG_DWORD"
    oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection\AllowTelemetry", 0, "REG_DWORD"
 
 	'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\PublishUserActivities
End Function
'----------------------------------------------
Function MaintenanceScheduled()
	' Microsoft recomienda activarlo pero  provoca encendidos nocturnos que luego dejan el PC encendido.	 
	' actualizan Windows, App, Antivirus ...
		'Deshabilitar el inicio del PC desde tareas programadas de mantenimiento
	oWSH.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance\MaintenanceDisabled", 1, "REG_DWORD"
		'Deshabilitar el inicio del PC desde tareas de mantenimiento (Updates, Escaneos etc)
	oWSH.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance\WakeUp", 0, "REG_DWORD"
		'Deshabilitar los Wake Timers del modo suspensión (ratón, teclado ...)
	oWSH.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\BD3B718A-0680-4D9D-8AB2-E1D2B4AC806D\Attributes", 0, "REG_DWORD"
	MsgBox "Se ha deshabilitado Tareas y Temporizadores de encendido del PC"
End Function
'----------------------------------------------
Function TareasProgamadasEnciendenPC()      'info: https://winaero.com/find-scheduled-tasks-which-wake-up-your-windows-10-pc/
	oWSH.Run "powershell -noexit  Get-ScheduledTask | where {$_.Settings.WakeToRun -eq $true -and $_.State -ne $disabled}", 1, False
	'	wait (3)
	msgbox "Si hay tareas Enabled o Queued, recomendamos deshabilitarlas con la opción 25 del script"
	'Muestra todas la tareas que encienden Windows: Get-ScheduledTask | where {$_.settings.waketorun}
End Function 
'----------------------------------------------
Function Comp_Bitlocker() 	'mas info: https://4sysops.com/archives/enable-bitlocker-with-powershell/
'Esta función puede ser interesante para un portatil por si se extravia pero castiga los discos SSD
	oWSH.Run "powershell -noexit Get-BitLockerVolume ",1,true
	WScript.StdOut.WriteLine " "
	WScript.StdOut.WriteLine " Mira el Volume Status  y Protection Status"
	WScript.StdOut.WriteLine " ¡¡ Si tienes un cifrado activo  entonces tienes BitLocker activado!! "
		wait(3)
	'oWSH.run "cmd /k manage-bde -status  "
	'wait(2)
End function
'----------------------------------------------
Function MenuDerechoW11()
		' Establecer el menú contextual del "viejo" Explorador como predeterminado
	'reg add "HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f
			
	oWSH.RegWrite "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32\", "", "REG_SZ"
		' Eliminar la "barra de comandos" del Explorador
	  	' Reiniciar el Explorador de Windows para aplicar los cambios
    	oWSH.Run "taskkill /f /im explorer.exe", 1, True
    	oWSH.Run "explorer.exe", 1, False
End function
'-----------------------------------------------
Function  BorraTareaProgramadas()
    		' Hacer backup de Tareas
    	oWSH.Run "cmd /c schtasks /query /fo csv > C:\TareasBackup.csv", 0, True
    	WScript.StdOut.WriteLine "Backup de tareas realizado en C:\TareasBackup.csv"
	'oWSH.Run "curl -LJO https://raw.githubusercontent.com/JaviScriptsWin/Windows-Optimizer/main/STOPServices25.cmd", 1, True

    WScript.StdOut.WriteLine "¡¡Pendiente de implementar!! "
    WScript.StdOut.WriteLine " Selecciona una opcion: "
    WScript.StdOut.WriteLine "  1 = ELIMINAR TAREAS PROGRAMADAS ¡No reversible!"
    WScript.StdOut.WriteLine "  2 = DESHABILITAR TAREAS PROGRAMADAS (no críticas)"
    WScript.StdOut.WriteLine ""
    WScript.StdOut.WriteLine "  0 = Volver al menu principal"
    WScript.StdOut.Write ""
    WScript.StdOut.Write "  > "
    opcion = WScript.StdIn.ReadLine

    WScript.Sleep 3000
End Function
'---------------------------------------------------------------------------
Function DesinstalaOffice()
   
	wscript.echo  "pendiente de implementar"

End Function
		
