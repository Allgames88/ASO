#!/bin/bash

##
#   Script para administrar las redes Yuju!
#   Voy a hacerlo igual que la de Powershell
##
##
$iface = ""

iMenu(){
    clear
    echo ""

        echo "Interfaz Seleccionada:" $iface
        echo "IP: "$IP
        echo "DNSs: "$DNSs
        echo "Gateway: "$Gateway

    echo ""
    echo "Bienvenido al programa de interfaces del equipo"
    echo "¿En que podemos ayudarle hoy?"
       echo "0) Salir"
    echo "1) Listar y seleccionar interfaces"
    echo "2) Cambiar dirección IP de la interfaz seleccionada"
    echo "3) Cambiar los DNS de la interfaz seleccionada"
 

    read input

    if [ $input -eq "1" ];then

        listIfaces

    elif [ $input -eq "2" ]; then
        modifyIface ip

    elif [ $input -eq "3" ]; then

        modifyIface dns

    elif [ $input -eq "0" ]; then
        exit 0
    fi



    iMenu
}

listIfaces(){

    ifaces=$(ip a | awk '/^[0-9]+:/ {gsub(/:/,"",$2); print $2}')

    # Imprimir la lista de interfaces
    echo "Interfaces de red disponibles:"
    echo "$ifaces"
    
    echo ¿Cual quiere seleccionar?
    read iface

    if ip a show $iface >/dev/null 2>&1; then
        echo "Interfaz seleccionada: $iface"

        # Obtener la dirección IP, máscara y puerta de enlace de la interfaz
        IP=$(ip a show dev $iface | awk '/inet / {print $2}')
        Gateway=$(ip r show dev $iface | awk '/default/ {print $3}')
        DNSs=$(nmcli dev show $iface | awk '/IP4.DNS/ {print $2}')

        echo "-------------"
        echo "Desea exportar la configuración de esta Interfaz a un archivo?(y/n)"

        read input

        if [ $input = y ];then

            exportIface $iface

        fi

        

    else
        echo "La interfaz $iface no existe"
        echo "Le pedimos que seleccione una interfaz que séa válida en el contexto"
        read a
        listIfaces
    fi


}

exportIface(){

    ip a show dev $1 > ./$1.iconf

    echo "Se ha exportado a la hubicación ./$1.iconf"
    read a


}

modifyIface() {
    if [ "$1" = "ip" ]; then
        clear
        echo "Introduzca una nueva IP: DDD.DDD.DDD.DDD/MM"
        read newIP

        # Remove all IP addresses from the interface
        ip addr flush $iface

        # Set the new IP
        ip addr change $newIP dev "$iface"

        # Show the interface information
        ip addr show dev "$iface"

          # Obtener la dirección IP, máscara y puerta de enlace de la interfaz
        IP=$(ip a show dev $iface | awk '/inet / {print $2}')
        Gateway=$(ip r show dev $iface | awk '/default/ {print $3}')
        DNSs=$(nmcli dev show $iface | awk '/IP4.DNS/ {print $2}')
        
        read -r a
    
    elif [ "$1" = "dns" ]; then

        # Solicita los nuevos servidores DNS al usuario
        echo "Introduce los nuevos servidores DNS (separados por espacios):"
        read -r newDNS

        # 
        ifaceName=$(nmcli -g connection device show  "$iface")
        nmcli connection modify "$ifaceName" ipv4.dns "$newDNS"

        nmcli connection down "$ifaceName"
        nmcli connection up "$ifaceName"

        read a

    else

        echo "Nada se cumple"
        read a

    fi
}

# newMaskedIP() {
#     echo "Introduzca una nueva IP: DDD.DDD.DDD.DDD/MM"
#     read -r newIP
#     patron="^([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}$"

#     if [[ "$newIP" =~ $patron ]]; then
#         echo "Dirección IP válida"
#     else
#         echo "Dirección IP no válida, introduzca una válida"
#         newMaskedIP
#     fi
# }


iMenu