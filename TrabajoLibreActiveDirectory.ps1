Clear-Host



function App-Menu {
    Clear-Host
    $fecha = get-date
    write-host Día actual: $fecha
    Write-Host "1: Control de Versiones de PS."
    Write-Host "2: Mostrar servicios activos."
    Write-Host "3: Menú de usuarios."
    Write-Host "4: Menú de instalaciones Software."

    $active = Get-WindowsFeature AD-Domain-Services
    if($active){
        Write-Host "5: Menú de Active Directory."
        Import-Module ActiveDirectory
    }

    $order = Read-Host "Que acción quiere realizar?"

    if( $order -eq 1){
        App-GetVersion
    }elseif ($order -eq 2){
        App-GetServices
    }elseif ( $order -eq 3){
        App-GetUsers
    }elseif ( $order -eq 4){
        App-InstallMenu
    }elseif ( $active ){
        if ($order -eq 5){
            App-ActiveMenu
        }
    }else{
        App-Menu
    }

}

function App-GetVersion {
    Clear-Host
    write-host "La versión actual es " $PSVersionTable.PSVersion
    Write-host "[ INTRO ]: Volver"
    $versionOrder = Read-Host ¿Que desea hacer ahora?
        App-Menu

    
}

function App-GetServices {
Clear-Host
    Get-WmiObject -Query "select * from win32_service where processID != 0" | Format-list -Property Name, ProcessID
    Get-WmiObject -Query "select * from win32_service where processID != 0" | Format-list -Property PSComputername, Name, ExitCode, ProcessID, State > ./foundServices.txt
    Write-host " Una copia detallada de todos los servicios localizados ha sido almacenada en el archivo ./foundServices.txt, desde tu directorio actual."
    Write-host "1: Terminar servicio."
    Write-host "[ INTRO ]: Volver"
    Write-host " "
    $programsOrder = Read-Host ¿Que desea hacer ahora?

    if($programsOrder -eq 1){
        App-KillService
    }else{
        App-Menu
    }
       
}

function App-KillService{
    Clear-Host 
    Write-Host "Introduzca el PID del servicio a matarrr."
    [int]$PID = read-host

    $Service = Get-Process | Where-Object {$_.Id -eq $PID}
    if ($Service.Id -eq $PID){
        taskkill /PID $PID
        write-host "La tarea ha sido terminada adecuadamente."
        read-host "[ INTRO ]"
            App-Menu

    }else{
        write-host "[Error] La tarea no ha sido encontrada, pruebe una vez más con otro poroceso."
        read-host "[ INTRO ]"
            App-Menu
    }
    

}

function App-GetUsers{
    Clear-Host
    write-host "Mostrando usuarios del sistema"
    write-host " "
    Get-LocalUser
    write-host " "
    write-host "1: Crear nuevo usuario Local"
    write-host "2: Eliminar usuario Local"
    write-host "3: Re-Listar usuarios"
    write-host "4: Instalar característica de Windows"
    write-host "[ INTRO ]: Volver"

    $userInput = read-host ¿Que desea hacer ahora?

    if ($userInput -eq 1){
        App-newLocalUser
    }elseif($userInput -eq 2){
        App-eraseLocalUser
    }elseif($userInput -eq 3){
        Get-LocalUser
        App-GetUsers
    }else{
        App-Menu
    }
}

function App-newLocalUser{
    Clear-host
    $name = read-host Introduzca el nombre de usuario.
    $passwd = read-host Introduzca la nueva contraseña. -AsSecureString
    $fullName = Read-Host Introduzca el nombre completo.
    $desc = read-host "Introduzca una descripción (Opcional)"

    New-LocalUser $name -Password $passwd -FullName $fullName -Description $desc

    write-host Nuevo usuario $name creado!
    read-host "[ INTRO ]: Volver"
        App-Menu
}

function App-eraseLocalUser{
    $difunto = read-host "Introduzca el nombre del usuario a elminiar"
    
    $user = Get-LocalUser -Name $difunto

    if($user){
        Remove-LocalUser $difunto
        write-host "El usuario ha sido eliminado sin fallos"
    }else{
        write-host "El usuario no existe localmente."
    }

    Read-Host "[ INTRO ] Volver"
    App-Menu

    
}

function App-InstallMenu{
    Clear-Host
    write-host "Estas son algunas de las características que puedes instalar:"
    write-host " "
    read-host [ INTRO ] Continuar
    Get-WindowsFeature | where InstallState -eq Available
    Get-WindowsFeature | where InstallState -eq Available >> ./featuresAviable.txt
    write-host "Se ha guardado un archivo con información detallada de las posibles instalaciones en ./featuresAviable.txt"
    write-host " "
    write-host "1: Listar Características ya instaladas"
    write-host "2: Re-listar características no instaladas"
    write-host "3: Instalar nueva característica"
    write-host "4: Instalar Active Directory"
    write-Host "[ INTRO ] Volver"

    $installOrder = read-host "¿Que desea hacer ahora?"

    if($installOrder -eq 1){
        Get-WindowsFeature | where InstallState -eq Installed
        Get-WindowsFeature | where InstallState -eq Installed >> ./featuresInstalled.txt 
        write-host "Se ha guardado un archivo con información detallada de las características instaladas en ./featuresInstalled.txt"
        read-host
        App-InstallMenu
    }elseif($installOrder -eq 2){
           App-InstallMenu
    }elseif($installOrder -eq 3){
           App-newInstall
    }elseif($installOrder -eq 4){
           Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
           Read-Host "Active Directory Instalado de manera adecuada"
           App-Menu
    }else{
        App-Menu
    }


}

function App-newInstall{
    $featureName = read-host Introduzca el nombre de la característica instalada.

    Install-WindowsFeature -Name $featureName -IncludeAllSubFeature -WhatIf >> ./installationLog.txt
    write-host "Se ha guardado un archivo con información detallada de la instalación en ./featuresInstalled.txt"
    read-Host "[ INTRO ] Volver"
    App-InstallMenu

}

function App-ActiveMenu{
    clear-Host
    write-host "Bienbenido al menú de configuración de Active Directory."
    write-host "1: Instalar un nuevo Bosque"
    write-host "2: Listar Bosques de Active Directory"
    write-Host "[ INTRO ] Volver"

    $activeOrder = read-host ¿Que desea hacer aquí?

    if ( $activeOrder -eq 1 ){
        App-NewForest
    } elseif ($activeOrder -eq 2){
        App-ShowForest
    } elseif ($activeOrder -eq 3){
        App-NewActiveUsers
    }else{
    App-Menu
    }

}

function App-NewForest{
    $forestName = read-host "Inserte el nombre del bosque a crear."
    $forestExtension = read-host "Inserte la extensión del bosque."

    if($forestName){
        if($forestExtension){
                Install-ADDSForest -DomainName $forestName.$forestExtension -InstallDns
                App-ActiveMenu
        }else{
            Write-Host El bosque debe tener una extensión.
            Read-Host
            App-ActiveMenu
        }
    }else{
        Write-Host El nombre del bosque no se puede encontrar vacío.
        read-host
        App-ActiveMenu
    }

}

function App-ShowForest{
    Get-ADDomain
    Get-ADDomain >> ./dominios.txt

    write-host "Se ha guardado un archivo con información detallada de los dominios en ./dominios.txt"
    read-Host "[ INTRO ] Volver"
    read-host
    App-ActiveMenu
}


App-Menu

