clear
write-host "Ha comenzado el programa de obtención de datos del equipo, por favor, espere por un momento..."
read-host "[ INTRO ] Continuar"
write-host "Seleccione: "
write-host "1) Información sobre los procesadores."
write-host "2) Información sobre la memoria RAM."
write-host "3) Información sobre los discos duros."
write-host "4) Información general."

$userInput = read-host "Esperando instrucciones: "

if($userInput -eq 1){
    App.GetProcessor
}elseif($userInput -eq 2){
    App.GetRAM
}elseif($userInput -eq 3){
    App.GetDrive
}elseif($userInput -eq 4){
    App.General
}


function App.GetProcessor(){
$prcs = Get-WmiObject -Class Win32_Processor | Select-Object Name, Manufacturer, MaxClockSpeed, NumberOfCores
    $prcs | Format-Table -AutoSize
}

function App.GetRAM(){
$RAM = Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object @{Name='Gs';Expression={$_.Sum / 1GB}}, Count
    $RAM | Format-Table -AutoSize
}

function App.GetDrive(){
$hd = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object DeviceID, MediaType, Size, FreeSpace
    $hd | Format-Table -AutoSize
}

function App.General(){
$gen = Get-ComputerInfo -Property "*Version"
    $gen
}