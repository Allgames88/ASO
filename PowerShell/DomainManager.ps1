# Funcion principal, se ejecuta una vez, a no ser que sea llamada de nuevo.
function App.main(){

    $equipo = $env:COMPUTERNAME;
    $activeDirectory = (Get-WindowsFeature -Name "AD-Domain-Services").Installed
    $domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain
    $wkGroup = (Get-WmiObject -Class Win32_ComputerSystem).Domain

    clear
    write-host "Ha comenzado el programa de configuración de Nombres y Dominios de Powershell."
    write-host " "
    Write-Host "El nombre del equipo es: " $equipo
    write-host "Active Directory instalado: " $activeDirectory
    write-host "Dominio Actual: " $domain
    write-host "Grupo de Trabajo: " $wkGroup
    write-host " "
    write-host "Seleccione: "
    write-host "0) Instrucciones de Uso."
    write-host "1) Cambiar nombre del equipo."
    write-host "2) Trabajar sobre el Dominio actual del Equipo."
    write-host "[ INTRO ] Salir."


    $userInput = read-host "Esperando instrucciones "


    if($userInput -eq 1){
        App.ChangeName
    }elseif($userInput -eq 2){
        App.DomainMenu
    }elseif($userInput -eq 0){
        App.AppInfo
    }
}

#Nuevo menú para trabajar sobre el dominio
function App.DomainMenu(){

    clear
    $equipo = $env:COMPUTERNAME;
    $activeDirectory = (Get-WindowsFeature -Name "AD-Domain-Services").Installed
    $domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain
    $wkGroup = (Get-WmiObject -Class Win32_ComputerSystem).Domain
    
  
    write-host "Bienvenido al apartado de COnfiguración de Dominios del equipo."
    write-host "¿En que podriamos ayudarle hoy?"

    write-host " "
    Write-Host "El nombre del equipo es: " $equipo
    write-host "Active Directory instalado: " $activeDirectory
    write-host "Dominio Actual: " $domain
    write-host " "
    write-host "Seleccione: "
    write-host "1) Unirse a un Dominio."
    if($wkGroup -ne "" ){
        write-host "2) Crear un Dominio."
    }
    
    
    write-host "[ INTRO ] Salir."


    $userInput = read-host "Esperando instrucciones "


    if($userInput -eq 1){
        App.joinDomain
    }elseif($userInput -eq 2){
        if($wkGroup -ne "" ){
            App.newDomain
        }else{
            App.main
        }
        
    }


}

function App.reset(){
    
    $goOff = read-host "¿Desea reiniciar el equipo ahora? (Yes/No)"

    if($goOff -eq "Yes" -or $goOff -eq "y" -or $goOff -eq "Y"){
    
        Restart-Computer

    }
}

#funcion para unirse a un dominio existente:
function App.joinDomain(){

    $Name = newDomainName
    $cred = Get-Credential

    Add-Computer -DomainName $Name -Credential $cred

    Write-Host "Para confirmar los cambios, debe de reiniciar el equipo."
    App.reset

}

#funcion para crear un nuevo Dominio:
function App.newDomain(){
    clear
    $Name = newDomainName
    write-host $Name

    Install-ADDSForest -DomainName $Name -InstallDns

    $newDomain = Get-ADDomain $Name 

    Write-Host "Se ha instalado el nuevo Dominio " $newDomain
 

}


#Comprueba si la variable pasada es un nombre de Dominio adecuado.
function newDomainName(){

    $Name = Read-Host "Introduzca el nombre de Dominio"

    $parts = $Name -split '\.'

    if($parts.Count -gt 1 -and $parts.Count -lt 4){
        return $Name
    }else{
        Write-Host "Nombre de Dominio no permitido"
        return checkDomainName
    }

}


#Cambia el Nombre del equipo al nuevo Nombre deseado.
function App.ChangeName(){

    $input = read-host "Introduzca el nuevo nombre para el equipo"

    Rename-Computer -NewName $input

    Write-Host "El nombre del ordenador ha sido procesado, es necesario que reinicie el equipo para que el cambio sea completado"

    App.reset
    App.Main



}


#Actualiza las variables globales
function App.update(){

    $equipo = $env:COMPUTERNAME;
    $activeDirectory = (Get-WindowsFeature -Name "AD-Domain-Services").Installed

}

#Devuelve al usuario una serie de instrucciones sobre como utilizar este script.
function App.AppInfo(){

    clear
    write-host "################# Manual de uso de script ##############"
    write-host ""
    write-host "Para utilizar este script, es necesario que trabaje siempre bajo uno de los sub-menús que se le ofrecen.."
    write-host "De esa manera será capáz de trabajar libremente con las opciones del equipo, y por otro lado con las opciones del dominio."

    write-host ""
    write-host "En caso de que sea necesaria una lista de instrucciones más clara:"
    write-host ""

    write-host "1) Seleccione 1 para modificar el nombre por el que su equipo se ve identificado:"
    write-host "2) Seleccione opción 2 para trabajar en el menú de configuración del Dominio.."
    write-host ""
    write-host "Esperamos que este manual improvisado le haya sido de ayuda, no dude en contactar al desarrollador en caso de atasque o problema."
    read-host "[ INTRO ] Continuar"

    App.main
}



App.Main