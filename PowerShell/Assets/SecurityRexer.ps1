function App.getLoginErrors(){
    $eventLog = Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 4625}
    write-host "a"


    if ($eventLog) {
        Write-Host "Se han detectado fallas de inicio de sesi�n:"
        foreach ($event in $eventLog) {
            Write-Host "Fecha y hora: $($event.TimeCreated)"
            Write-Host "Usuario: $($event.Properties[5].Value)"
            Write-Host "Direcci�n IP: $($event.Properties[19].Value)"
            Write-Host "-----------------------------------------------------"
        }
    }
    else {
        Write-Host "No se han encontrado fallas de inicio de sesi�n."
    }

}

function App.getPermissionErrors(){

    $eventLog = Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 4663}
    

    if ($eventLog) {
        Write-Host "Se han detectado intentos de acceso sin permisos:"
        foreach ($event in $eventLog) {
            Write-Host "Fecha y hora: $($event.TimeCreated)"
            Write-Host "Usuario: $($event.Properties[1].Value)"
            Write-Host "Objeto: $($event.Properties[2].Value)"
            Write-Host "-----------------------------------------------------"
        }
    }
    else {
        Write-Host "No se han encontrado intentos de acceso sin permisos."
    }

}

clear
App.getLoginErrors
App.getPermissionErrors

#El tema es que se que esto est� bien, el problema es que se queda pillado, y no se porqu�.