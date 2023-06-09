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
        App.listProccess
    }elseif($userInput -eq 2){
        App.getProccesByName
    }elseif($userInput -eq 0){
        App.AppInfo
    }
}

function App.listProccess(){
    $proccess = Get-Process | Sort-Object -Property WorkingSet -Descending

    foreach($proc in $proccess){
    
        Write-Host "Nombre: $($proc.Name), ID: $($proc.Id)"
    
    }

    $save = Read-Host "Desea guardar la lista de procesos en su carpeta Home?(Yes/No)"

    if($save -eq "Yes"){
    
        $dir = $env:USERPROFILE
        $date = Get-Date
        $fileName = "ProccessList_" +$date.ToString("yyyyMMdd_HHmm") + ".txt"
        $path = Join-Path -Path $dir -ChildPath $fileName
        $proccess | Out-File $path
        Write-Host "La lista de procesos ha sido guardada en " $path
    
    }else{
    
        App.main

    }

}


function App.getProccesByName(){

    $prodName = Read-Host "Introduzca el nombre del proceso que desea buscar"

    $Processes = Get-Process | Where-Object { $_.Name -like "*$prodName*" }

    foreach($prod in $Processes){
        write-host "----------------------" 
        write-host "Nombre: " $prod.Name
        write-host "PID: " $prod.Id
        write-host "Uso de CPU (%): " $prod.CPU
        write-host "Uso de Memoria (MB): " ("{0:N2}" -f ($prod.WorkingSet / 1MB)) "MB"
        write-host "Ruta: " $prod.Path
        write-host "Tiempo de Inicio: " $prod.StartTime
        write-host "----------------------" 
    
    }
    read-host "[ INTRO ] Continuar"
    App.main -clear $true

}


#Devuelve al usuario una serie de instrucciones sobre como utilizar este script.
function App.AppInfo(){

    clear
    write-host "################# Manual de uso de script ##############"
    write-host ""
    write-host "Este script permite acceder en modo de Lectura solo, a todos los procesos en ejecución del ordenador"
    write-host ""
    write-host "En caso de que sea necesaria una lista de instrucciones más clara:"
    write-host ""

    write-host "1) Seleccione 1 para modificar el nombre por el que su equipo se ve identificado:"
    write-host "2) Una vez accedida a la lista de procesos, puede elegir si exportar la lista a un archivo independiente en su HOME"
    write-host "3) Seleccione opción 2 para acceder a la información detallada de un proceso"
    write-host ""
    write-host "Esperamos que este manual improvisado le haya sido de ayuda, no dude en contactar al desarrollador en caso de atasque o problema."
    read-host "[ INTRO ] Continuar"

    App.main -clear true
}


App.main -clear true