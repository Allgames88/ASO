# Funcion principal, se ejecuta una vez, a no ser que sea llamada de nuevo.
function App.main(){
    param(
        [switch]$clear
    )

    if($clear){
        clear
    }

    write-host "Ha comenzado el programa de administración de Procesos de Powershell."
    write-host " "
    write-host " "
    write-host "Seleccione: "
    write-host "0) Instrucciones de Uso."
    write-host "1) Obtener lista de procesos."
    write-host "2) Buscar proceso por Nombre."
    write-host "[ INTRO ] Salir."


    $userInput = read-host "Esperando instrucciones "


    if($userInput -eq 1){
        App.listServices
    }elseif($userInput -eq 2){
        App.openService -Search
    }elseif($userInput -eq 0){
        App.AppInfo
    }
}

function App.listServices(){
    $services = Get-Service

    foreach($el in $services){
        
        Write-Host "------------------------"
        Write-Host "Nombre: $($el.Name)"
        Write-Host "Descripcion: $($el.DisplayName)"
        Write-Host "Estado: $($el.Status)"
        Write-Host "Tipo de Inicio: $($el.StartType)"
    
    }

    $save = Read-Host "Desea guardar la lista de Servicios en su carpeta Home?(Yes/No)"

    if($save -eq "Yes"){
    
        $dir = $env:USERPROFILE
        $date = Get-Date
        $fileName = "ServiceList_" +$date.ToString("yyyyMMdd_HHmm") + ".txt"
        $path = Join-Path -Path $dir -ChildPath $fileName
        $services | Out-File $path
        Write-Host "La lista de servicios ha sido guardada en " $path
    
    }else{
    
        App.main

    }

}


function App.openService{
[CmdletBinding()]
param (
    [Parameter()]
    [Switch]$Search,
    [Parameter()]
    [Switch]$Clear
)


    if($search){
        $searchName = Read-Host "Introduzca el nombre del servicio que desea buscar"
        $service = Get-Service -Name $searchName
    }

    if($clear){
        clear
    }

    if($service){
        write-host "----------------------" 
        write-host "Nombre: " $service.Name
        write-host "Estado: " $service.Status
        write-host "ID: " $service.ProccessID
        write-host "Tipo de Inicio: " $service.StartType
        write-host "Descripcion: " $service.Description
        write-host "Ruta: " $service.PathName
        write-host "----------------------" 

    }
    

        
    
    write-host ""
    write-host "Opciones disponibles para este servicio:"
    write-host "1) Apagar/Encender"
    write-host "2) Cambiar modo de Arranque"
    write-host "3) Volver al Menú Principal."
    $input = Read-Host "Esperando instrucciones"
    
    if($input -eq 1){
    
        if($service.Status -eq "Running"){
            Stop-Service -Name $service.Name
        }elseif($service.Status -eq "Stopped"){
            Start-Service -Name $service.Name
        }

    }elseif($input -eq 2){
    
        $mode = Read-Host "En que modo desea ponerlo?"

        if($mode -eq "Automatic" -or $mode -eq "Disabledd" -or $mode -eq "Manual"){
        
            Set-Service -Name $service.Name -StartupType $mode
        
        }else{

            clear
            Write-Host " "
            Write-Host "Ese modo no es válido para este servicio!"
            Write-Host " "
            App.openService
        
        }


    }elseif($input -eq 3){
        App.main -clear
    }else{
        App.openService -Clear
    }

    

}


#Devuelve al usuario una serie de instrucciones sobre como utilizar este script.
function App.AppInfo(){

    clear
    write-host "################# Manual de uso de script ##############"
    write-host ""
    write-host "Este script permite administrar los servicios activos e inactivos"
    write-host ""
    write-host "En caso de que sea necesaria una lista de instrucciones más clara:"
    write-host ""

    write-host "1) Seleccione 1 para modificar el nombre por el que su equipo se ve identificado:"
    write-host "2) Una vez accedida a la lista de procesos, puede elegir si exportar la lista a un archivo independiente en su HOME"
    write-host "3) Seleccione opción 2 para acceder a la información detallada de un proceso. Esto abrirá un sub-menú con diferentes opciones que ejecutar sobre el servicio."
    write-host "4) Seleccione opción A) para encender/apagar el servicio"
    write-host "5) Seleccione opción B) para cambiar el modo de inicio del servicio, de Automático a Manual, y viceversa"
    write-host ""
    write-host "Esperamos que este manual improvisado le haya sido de ayuda, no dude en contactar al desarrollador en caso de atasque o problema."
    read-host "[ INTRO ] Continuar"

    App.main -clear $true
}


App.main -clear true