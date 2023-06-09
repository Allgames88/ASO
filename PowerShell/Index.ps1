function App.main(){
    clear
    write-host "Bienvenido al Programa de Administración e Información sobre el equipo y su dominio."
    write-host "En que podemos ayudarle hoy?"
    write-host " "
    write-host "Seleccione: "
    write-host "1) Instrucciones de uso del programa."
    write-host "1) Obtener Información del Hardware."
    write-host "2) Gestionar la Red del equipo."
    write-host "3) Trabajar sobre el Dominio actual del Equipo."
    write-host "4) Abrir el Observador de Procesos."
    write-host "5) Seleccionar el Administrador de Servicios"
    write-host "6) Abrir el Controlador de Usuarios."
    write-host "7) Comprobar última actualización de Seguridad."
    write-host "8) Buscar intentos de Login erroneos y e intentos de acceso a archivos no permitidos."
    write-host "9) Salir."


    $userInput = read-host "Esperando instrucciones "


    if($userInput -eq 1){
        App.callMenu -fileName "GetHardwareData.ps1"
    }elseif($userInput -eq 2){
        App.callMenu -fileName "AdminNetIfaces.ps1"
    }elseif($userInput -eq 3){
        App.callMenu -fileName "DomainManager.ps1"
    }elseif($userInput -eq 4){
        App.callMenu -fileName "ProccessSeeker.ps1"
    }elseif($userInput -eq 5){
        App.callMenu -fileName "ServiceAdmin.ps1"
    }elseif($userInput -eq 6){
        App.callMenu -fileName "UserController.ps1"
    }elseif($userInput -eq 7){
        App.callMenu -fileName "SecurityChecker.ps1"
    }elseif($userInput -eq 8){
        App.callMenu -fileName "SecurityRexer.ps1"
    }elseif($userInput -eq 9){
        exit
    }elseif($userInput -eq 0){
        App.AppInfo
    }

    App.main
}

function App.callMenu(){

    Param(
        [Parameter(Mandatory=$true)]
        [string]$fileName
    )


    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

    $filePath = "Assets\" + $fileName
    $path = Join-Path -Path $PSScriptRoot -ChildPath $filePath

    Write-Host $path
    Read-Host

    Invoke-Expression -Command $path
}



function App.AppInfo{

    clear
    write-host "################# Manual de uso de script ##############"
    write-host ""
    write-host "El objetivo de este script es conectar otros diversos scripts, de manera que muchas y variadas opciones"
    write-host "Le sean presentes al usuario, encontrará información más detallada sobre como utilizar estos diversos scripts"
    write-host "En los diversos apartados del menú principal"

    write-host ""
    write-host ""

    write-host ""
    write-host "Esperamos que este manual improvisado le haya sido de ayuda, no dude en contactar al desarrollador en caso de atasque o problema."
    read-host "[ INTRO ] Continuar"

    App.main

}

App.main