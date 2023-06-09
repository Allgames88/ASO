Import-Module Active-Directory

#Función del menú principal.
function App.main(){

    param(
        [switch]$clear
    )

    if($clear){
        clear
    }

    write-host "Ha comenzado el programa de control de Usuarios de mi dominio."
    write-host " "

        if($usuario){
        
            write-host "-------------"
            write-host "Nombre: " $usuario.Name $usuario.Surname
            write-host "Habilitado: " $usuario.Enabled
            write-host "-------------"
        
        }

    write-host " "
    write-host "Seleccione: "
    write-host "1) Obtener lista de Usuarios."
    write-host "2) Seleccionar Usuarios."
    write-host "3) Crear nuevo Usuario."
    write-host "4) Modificar privilegios de Usuario."
    write-host "[ INTRO ] Salir."


    $userInput = read-host "Esperando instrucciones "


    if($userInput -eq 1){
        App.listUsers
    }elseif($userInput -eq 2){
        App.selectUser
    }elseif($userInput -eq 3){
        App.newUser
    }elseif($userInput -eq 4){
        App.modUser
    }
}

#Funcion echa para cambiar los privilegios de un usuario
function App.modUser{

    if($usuario){
        
            write-host "-------------"
            write-host "Nombre: " $usuario.Name $usuario.Surname
            write-host "Habilitado: " $usuario.Enabled
            write-host "-------------"

            write-host "¿Que privilegio debería asignar a este usuario?"
            write-host "A) Account Opperator (Operador de Cuenta)"
            write-host "B) Admin"
            write-host "C) Backup Operator (Operador de Copias de Seguridad)"
            write-host "D) Network Operator (Operador de configuración de Red)"
            write-host "E) Print Operator (Operador de la Impresora)"
            write-host "F) Non"
            write-host "G) Volver al Menú Principal"

            $let = read-host "Esperando instrucciones"

            if($let -eq "A" -or $let -eq "a"){

                if(Get-ADGroup -Filter {Name -eq "AccountOperator"}){
            
                    Add-ADGroupMember -Identity "AccountOperator" -Members $usuario.Name
                    App.modUser

                }else{
            
                    New-ADGroup -Name "AccountOperator" -GroupCategory Security -GroupScope Global
                    Add-ADGroupMember -Identity "AccountOperator" -Members $usuario.Name
                    App.modUser
            
                }

            }elseif($let -eq "B" -or $let -eq "b"){
            
                if(Get-ADGroup -Filter {Name -eq "Admin"}){
            
                    Add-ADGroupMember -Identity "Admin" -Members $usuario.Name
                    App.modUser

                }else{
            
                    New-ADGroup -Name "Admin" -GroupCategory Security -GroupScope Global
                    Add-ADGroupMember -Identity "Admin" -Members $usuario.Name
                    App.modUser
            
                }
            
            }elseif($let -eq "C" -or $let -eq "c"){
            
                if(Get-ADGroup -Filter {Name -eq "BackupOperator"}){
            
                    Add-ADGroupMember -Identity "BackupOperator" -Members $usuario.Name
                    App.modUser

                }else{
            
                    New-ADGroup -Name "BackupOperator" -GroupCategory Security -GroupScope Global
                    Add-ADGroupMember -Identity "BackupOperator" -Members $usuario.Name
                    App.modUser
            
                }
            
            }elseif($let -eq "D" -or $let -eq "d"){
            
                if(Get-ADGroup -Filter {Name -eq "NetworkOperator"}){
            
                    Add-ADGroupMember -Identity "NetworkOperator" -Members $usuario.Name
                    App.modUser

                }else{
            
                    New-ADGroup -Name "NetworkOperator" -GroupCategory Security -GroupScope Global
                    Add-ADGroupMember -Identity "NetworkOperator" -Members $usuario.Name
                    App.modUser
            
                }
            
            }elseif($let -eq "E" -or $let -eq "e"){
            
                if(Get-ADGroup -Filter {Name -eq "PrintOperator"}){
            
                    Add-ADGroupMember -Identity "PrintOperator" -Members $usuario.Name
                    App.modUser

                }else{
            
                    New-ADGroup -Name "PrintOperator" -GroupCategory Security -GroupScope Global
                    Add-ADGroupMember -Identity "PrintOperator" -Members $usuario.Name
                    App.modUser
            
                }
            
            }elseif($let -eq "F" -or $let -eq "f"){
                
                #Esta opcion no furula, y no se porque.
            
                $groups = $usuario | Get-ADGroup
                foreach($el in $groups){
                    
                    Write-Host "Removing from "$el
                    Remove-ADGroupMember -Identity $el.Name -Members $usuario.Name
                    
                
                }
                read-host
                App.modUser
            
            }elseif($let -eq "G" -or $let -eq "G"){
            
                App.main -clear
            
            }else{
            
                App.modUser
            }

            
        
    }

    

}


#Función que devuelve una lista de usuarios.
function App.listUsers{
    clear
    $usuarios = Get-ADUser -Filter * -Properties *
    foreach($usr in $usuarios){
        
        Write-Host "-------------------------"
        Write-Host "Nombre: "$usr.Name $usr.Surname
        Write-Host "Organizacion: " $usr.Organization
        Write-Host "Contraseña Nunca Expira: " $usr.PasswordNeverExpires
        Write-Host "Ultimo Inicio de Sesion: " $usr.LastLogonDate
        Write-Host "Correo: " $usr.EmailAddress
        Write-Host "Departamento: " $usr.Department
        Write-Host "Telefono: " $usr.PhoneNumber
    
    }

    App.main

}

#Funcion para seleccionar un usuario
function App.selectUser{
    clear
    $name = read-host "Introduzca el nombre del usuario que desea seleccionar"
    $usuario = Get-ADUser -Filter "Name -eq '$name'"

    App.main -clear


}


#funcion para crear un nuevo usuario dentro del dominio.
#Aviso para marco: No tengo ni idea de las propiedades que debería tener un usuario en una empresa
#asi que solo voy a poner los que pone en el ejercicio.
function App.newUser{

    $nombre = read-host "Introduzca nombre de usuario, NO apellido"
    $apellido = read-host "Introduzca apellido del usuario"
    $passwd = newPasswd
    $phone = read-host "Introduzca el telefono del usuario"
    $mail = read-host "Introduzca el correo del usuario"
    $departmento = read-host "Introduzca el departamento del usuario"
    $domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain
    

    $newUser = New-ADUser -Name $nombre -Surname $apellido -AccountPassword (ConvertTo-SecureString -AsPlainText $passwd -Force) -SamAccountName $nombre.$apellifo -UserPrincipalName ($nombre + "." + $apellifo + "@" + $domain + ".com") -Enabled $true -OfficePhone $phone -EmailAddress $mail -Department $departmento

    $newUser

    App.main

}

function newPasswd{

    $input = read-host "Introduzca la nueva contraseña"

    $patron = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@$%^&*(),.?:{}|<>]).{8,}$"

    if($input -match $patron){
    
        return $input
    
    }else{
    
        return newPasswd

    }

}



App.main -clear