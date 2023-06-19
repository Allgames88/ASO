#!/bin/bash

#Main Menu
##
#   Debo de decir que este me ha resultado dificil, linux ofrece demasiados resultados en cuanto a la búsqueda de inforación.
#   Por ejemplo, al utilizar el dmidecode, la cantidad de resultados nulos al utilizar el awk, y el jq, es ridicula, pero meh, que le vamos a hacer
##
##


hardwareMenu(){

    #Clear
    clear 
    echo "Bienvenido al script de información de Hardware del Equipo"
    echo "En este caso no le ofreceremos un menu, sin embargo, tendrá acceso a toda la información necesaria para administrar le Hardware del ordenador."

        #Function to Get the RAM
        getRAM

        #Function to Get the Processor
        getProcessor

        #Function to Get the Disk
        getDisk
        
        echo " ------------------------------------ "
        echo " -- RAM -- "
        echo "Capacidad: ${memTotal}"
        echo "Memoria Utilizada: ${memUsed}"
        echo ""


        echo " ------------------------------------ "
        echo " -- Procesador -- "
        echo "Nombre: ${prName}"
        echo "Nucleos: ${cores}"
        echo ""

        echo " ------------------------------------ "
        echo " -- Discos Duros -- "
        echo "Discos: "
        echo "${disks}"

        for disco in $disks; do

            echo "---"
            echo "Disco: ${disco}"

            disk_info=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT $disco --noheadings)
            echo "Tamaño: $(echo $disk_info | awk '{print $2}')"
            echo "Tipo: $(echo $disk_info | awk '{print $3}')"
            echo "Punto de Montaje: $(echo $disk_info | awk '{print $4}')"
                disk_free=$(df -h $disco --output=avail | tail -n 1)
            echo "Espacio Libre: $disk_free GB"

        done
        echo ""


        read a
}

#Obtiene la informacion de la RAM
getRAM(){
    GB=$(sudo dmidecode -t 17 | awk '/Size: [0-9]+/{sum+=$2} END{print sum}')

    memTotal=$(free -h | awk '/^Memoria:/ {print $2}')
    memUsed=$(free -h | awk '/^Memoria:/ {print $3}')

    echo $memoria_total
}

#Obtiene la información del procesador
getProcessor(){
    model=$(lscpu | grep "Nombre del modelo:" | sed -e 's/Nombre del modelo://')
    prName=$(echo $model | sed 's/^ *//')
    cores=$(lscpu | grep "CPU(s):" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
}

#Obtiene los discos, no su información.
getDisk(){

    disks=`ls /dev/sd*`
    echo $disks
}

hardwareMenu