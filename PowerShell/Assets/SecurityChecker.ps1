function App.computerLatest{

    param(
        [Parameter(Mandatory=$true)]
        [string]$computer
    )

    $update = Invoke-Command -ComputerName $computer -ScriptBlock {
        Get-HotFix | Where-Object {$_.Description -like "*Security Update*"} | Sort-Object InstalledOn -Descending | Select-Object -First 1
    }

    #$JSON = $update | ConvertTo-Json

    return $update



}


function App.checkForUpdates{

    clear


    $equipos = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
    $updates = New-Object System.Collections.ArrayList
    foreach($eq in $equipos){
    $res = App.computerLatest -computer $eq

        $updates.Add("-----------------------------------------")
        $updates.Add("Nombre equipo: " + $eq)
        $updates.Add("ID de Instalación: " + $res.HotFixID)
        $updates.Add("Fecha de Instalación: " + $res.InstalledON)
        $updates.Add("Descripción: " + $res.Description)
        $updates.Add("Instalada por: " + $res.InstalledBy)
        $updates.Add("Está Instalada: " + $res.IsInstalled)
        $updates.Add("Obligatoria?: " + $res.IsMandatory)
        $updates.Add("Link de Soporte: " + $res.SupportUrl)
    }

    $updates

    $save = Read-Host "Desea guardar la lista en un archivo externo?(Yes/No)"

    if($save -eq "Yes"){
    
        $dir = $env:USERPROFILE
        $date = Get-Date
        $fileName = "ComputerUpdates_Latest_" +$date.ToString("yyyyMMdd_HHmm") + ".txt"
        $path = Join-Path -Path $dir -ChildPath $fileName
        $updates | Out-File $path
        Write-Host "La lista con las últimas actualizaciones de seguridad ha sido guardada en " $path
    
    }


    $updates
    

}



App.checkForUpdates



#{
#    "InstalledOn":  "\/Date(1567807200000)\/",
#    "PSComputerName":  "PWSH-BD",
#    "RunspaceId":  "197cb0c0-0b33-42f9-be3b-7c14ae5214bf",
#    "PSShowComputerName":  true,
#    "__GENUS":  2,
#    "__CLASS":  "Win32_QuickFixEngineering",
#    "__SUPERCLASS":  "CIM_LogicalElement",
#    "__DYNASTY":  "CIM_ManagedSystemElement",
#    "__RELPATH":  "Win32_QuickFixEngineering.HotFixID=\"KB4512578\",ServicePackInEffect=\"\"",
#    "__PROPERTY_COUNT":  11,
#    "__DERIVATION":  [
#                         "CIM_LogicalElement",
#                         "CIM_ManagedSystemElement"
#                     ],
#    "__SERVER":  "PWSH-BD",
#    "__NAMESPACE":  "root\\cimv2",
#    "__PATH":  "\\\\PWSH-BD\\root\\cimv2:Win32_QuickFixEngineering.HotFixID=\"KB4512578\",ServicePackInEffect=\"\"",
#    "Caption":  "http://support.microsoft.com/?kbid=4512578",
#    "CSName":  "PWSH-BD",
#    "Description":  "Security Update",
#    "FixComments":  "",
#    "HotFixID":  "KB4512578",
#    "InstallDate":  null,
#    "InstalledBy":  "",
#    "Name":  null,
#    "ServicePackInEffect":  "",
#    "Status":  null
#}