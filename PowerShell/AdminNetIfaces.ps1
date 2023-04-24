
$Iface = ""

# Funcion principal, se ejecuta una vez, a no ser que sea llamada de nuevo.
function App.main(){
    clear
    write-host "Ha comenzado el programa de administración de las Interfaces de Red."
    write-host " "
    write-host "Interfaz seleccionada: " $Iface.Name
    write-host "Status: " $Iface.Status
    write-host " "
    write-host "Seleccione: "
    write-host "0) Instrucciones de Uso."
    write-host "1) Listar Interfaces."
    write-host "2) Seleccionar Interfaz para trabajar sobre ella."
    write-host "3) Obtener información sobre interfaz."
    write-host "4) Renombrar Interfaz."
    write-host "5) Habilitar/Deshabilitar Interfaz."
    write-host "6) Seleccionar IP para interfaz."
    write-host "7) Seleccionar Puerta de Enlace para interfaz."
    write-host "8) Seleccionar Servidores DNS para interfaz."
    write-host "9) Reiniciar Interfaz."
    write-host "[ INTRO ] Salir."


    $userInput = read-host "Esperando instrucciones "


    if($userInput -eq 1){
        App.ListIface
    }elseif($userInput -eq 2){
        App.SelectIface
    }elseif($userInput -eq 3){
        App.GetIface
    }elseif($userInput -eq 4){
        App.RenameIface
    }elseif($userInput -eq 5){
        App.SwitchIface
    }elseif($userInput -eq 6){
        App.SetIP
    }elseif($userInput -eq 7){
        App.SetRouter
    }elseif($userInput -eq 8){
        App.SetDNS
    }elseif($userInput -eq 9){
        App.ResetIface
    }elseif($userInput -eq 0){
        App.IfaceInfo
    }
}

#Devuelve al usuario una lista de las diferentes interfaces.
function App.ListIface(){
    clear
    write-host "Ha seleccionado 'Listar Interfaces', aquí tiene una lista con las diferentes interfaces del dispositivo:"

    Get-NetAdapter | Select-Object Name, Status, MacAddress, LinkSpeed | Format-Table -AutoSize

    read-host "[ INTRO ] Continuar"

    App.main
}

#Devuelve al usuario una lista de las diferentes interfaces, pero sin más texto, ni limpiar la pantalla
function App.ListIfaceNoText(){

    Get-NetAdapter | Select-Object Name, Status, MacAddress, LinkSpeed | Format-Table -AutoSize
}

#Devuelve al usuario una serie de instrucciones sobre como utilizar este script.
function App.IfaceInfo(){

    clear
    write-host "################# Manual de uso de script ##############"
    write-host ""
    write-host "Para utilizar este script, es necesario que utilice la opción 2."
    write-host "Eso seleccionará una interfaz y usted podrá trabajar sobre ella, de esa manera, será innecesario estar eligiendo interfaces una y otra vez."

    write-host ""
    write-host "En caso de que sea necesaria una lista de instrucciones más clara:"
    write-host ""

    write-host "0) [ OPCIONAL ] Seleccione 1 para ver una lista con las diferentes interfaces del equipo:"
    write-host "1) Seleccione opción 2 para seleccionar una interfaz sobre la que trabajar."
    write-host "2) Seleccione 3 para listar una serie de datos sobre la interfaz seleccionada, podrá elegir sobre si guardar esa información en un archivo txt independiente, o no."
    write-host "3) Seleccione 4 para renombar la interfaz."
    write-host "4) Seleccione 5 para habilitar la interfaz si está deshabilitada."
    write-host "5) Seleccione 5 para deshabilitar la interfaz si está habilitada."
    write-host "6) Seleccione 6 para cambiar la IP asignada a la interfaz"
    write-host "7) Selecione 7 para cambiar la puerta de enlace asignada a la interfaz"
    write-host "8) Seleccione 8 para cambiar los servidores DNS asignados a la interfaz"
    write-host "9) Seleccione 9 para reiniciar una interfaz (Apagado/Encendido)"
    write-host ""
    write-host "Esperamos que este manual improvisado le haya sido de ayuda, no dude en contactar al desarrollador en caso de atasque o problema."
    read-host "[ INTRO ] Continuar"

    App.main
}


function App.SelectIface(){

    clear
    App.ListIfaceNoText

    write-host "Se le ha proporcionado una lista de las diferentes interfaces en el sistema."
    $input = read-host "Seleccione una interfaz "
    $Iface = Get-NetAdapter -Name $input

    App.main

}

function App.GetIface(){

    clear 
    write-host "Aquí tiene una serie de Característicass sobre la Interfaz Seleccionada:"
    write-host "Es posible que esto tome un rato..."
    write-host ""
    write-host "[Interface]: " $Iface.Name
    write-host ""
    $alias = Get-NetIPAddress -InterfaceAlias $Iface.Name
    write-host "[Interface IP]: " $alias
    $gate = (Get-NetIPConfiguration -InterfaceAlias $Iface.Name ).IPv4DefaultGateway.NextHop
    write-host ""
    write-host "[Interface Gateway]: " $gate
    $dns = (Get-DnsClientServerAddress -InterfaceAlias $Iface.Name ).ServerAddresses
    write-host ""
    write-host "[Interface DNS Servers]: " $dns

    write-host ""
    write-host "[Interface Config]: " $Iface | Get-NetIPAddress
    write-host ""
    read-host "[ INTRO ] Volver al Menú"
    App.main
}

function App.RenameIface(){

    clear

    write-host "Se le ha proporcionado una lista de las diferentes interfaces en el sistema."
    $newName = read-host "Escriba un nuevo nombre para la Interfaz"
    $Iface | Rename-NetAdapter -NewName $newName
    write-host "El nombre de la interfaz ha sido actualizado."
    $Iface = Get-NetAdapter -Name $newName
    read-host "[ INTRO ] Volver al Menú"

    App.main

}

function App.SwitchIface(){
    clear
    if($Iface.Status -eq "Up"){
    
        write-host "La interfaz " $Iface.Name "Se encuentra activa al momento."
        write-host "Desea desactivarla? (y/n)"

        $tInput = read-host

        if($tInput -eq "y"){
            $Iface | Disable-NetAdapter
            write-host "La interfaz ha sido desactivada"
        }

    }elseif($Iface.Status -eq "Disabled"){
        write-host "La interfaz " $Iface.Name "Se encuentra inactiva al momento."
        write-host "Desea activarla? (y/n)"

        $tInput = read-host

        if($tInput -eq "y"){
            $Iface | Enable-NetAdapter
            write-host "La interfaz ha sido activada"
        }
    }
    $Iface = Get-NetAdapter -Name $Iface.Name
    read-host "[ INTRO ] Volver al Menú"
    App.main

}

function App.SetIP(){

    clear
    write-host "La IP de la interfaz actualmente es: "
    $alias = Get-NetIPAddress -InterfaceAlias $Iface.Name
    write-host $alias
    
    write-host ""
    $newIP = read-host "Introduzca la nueva IP a asignar"
    write-host ""
    $newMas = read-host "Introduzca la máscara de la red a asignar (8/16/24/other)."

    Remove-NetIPAddress -InterfaceAlias $Iface.Name
    New-NetIPAddress -InterfaceAlias $Iface.Name -IPAddress $newIP
    Set-NetIPAddress -InterfaceAlias $Iface.Name -IPAddress $newIP -PrefixLength $newMas
    $Iface = Get-NetAdapter -Name $Iface.Name
    write-host "Nueva IP asignada"
    read-host "[ INTRO ] Volver al Menú"
    App.main
}

function App.SetRouter(){

    write-host "Ha seleccionado cambio de Punto de Acceso:"
    write-host ""
    $newIP = read-host "Introduzca la nueva IP a asignar al punto de acceso"
    $Iface | Set-NetIPInterface -DefaultGateway $newIP
    $Iface = Get-NetAdapter -Name $Iface.Name
    write-host "El punto de acceso ha sido cambiado"
    read-host "[ INTRO ] Volver al Menú"

}

function App.SetDNS(){

    write-host "Ha seleccionado cambio de DNS:"
    write-host ""
    $primary = read-host "Introduzca la nueva IP a asignar al servidor DNS PRIMARIO"
    $second = read-host "Introduzca la nueva IP a asignar al servidor DNS SECUNDARIO"
    $arr = $primary, $second


    Set-DnsClientServerAddress -InterfaceAlias $Iface.Name -ServerAddresses $arr

    $Iface = Get-NetAdapter -Name $Iface.Name
    write-host "El DNS ha sido actualizado"
    read-host "[ INTRO ] Volver al Menú"
    App.main

}

function App.ResetIface(){

    $Iface | Restart-NetAdapter
    write-host "El Adaptador ha sido reiniciado"
    read-host "[ INTRO ] Volver al Menú"
    App.main

}



App.main