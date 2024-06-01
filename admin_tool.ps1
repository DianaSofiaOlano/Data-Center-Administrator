
<#
.SYNOPSIS
Muestra un menú de opciones para la administración del data center.

.DESCRIPTION
Este script muestra un menú interactivo que permite al usuario seleccionar diferentes opciones para administrar el data center.

.PARAMETER Title
Título para el menú. Por defecto es 'ADMINISTRACIÓN DEL DATA CENTER'.
#>
function Show-Menu {
     param (
        [string]$Title = 'ADMINISTRACIÓN DEL DATA CENTER'
     )

     cls
     Write-Host "==================================" -ForegroundColor Magenta
     Write-Host "  $Title  " -ForegroundColor Cyan
     Write-Host "==================================" -ForegroundColor Magenta
     Write-Host ""
     Write-Host "1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento"
     Write-Host "2. Desplegar los filesystems o discos conectados a la máquina"
     Write-Host "3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem"
     Write-Host "4. Cantidad de memoria libre y cantidad del espacio de swap en uso"
     Write-Host "5. Número de conexiones de red activas actualmente (en estado ESTABLISHED)"
     Write-Host "0. Salir"
     Write-Host ""
}

<#
.SYNOPSIS
Obtiene los cinco procesos que más CPU están consumiendo en ese momento.

.DESCRIPTION
Get-TopCPUProcesses utiliza el cmdlet Get-Process para obtener una lista de procesos en el sistema, 
luego los ordena según el uso de CPU en orden descendente y selecciona los primeros cinco procesos. 
A continuación, muestra información detallada sobre estos procesos, incluyendo el ID del proceso, 
el nombre del proceso y el porcentaje de uso de CPU.
#>
function Get-TopCPUProcesses {
   Get-Process | Sort-Object -Property CPU -desc | Select-Object -First 5 | 
   Select-Object -Property Id, ProcessName, CPU
}

<#
.SYNOPSIS
Obtiene información sobre los filesystems o discos conectados a la máquina.

.DESCRIPTION
Get-FileSystemsDisk utiliza WMI para consultar las instancias Win32_LogicalDisk en una máquina especificada por el parámetro ComputerName. 
Filtra los resultados para incluir solo los discos duros y unidades de red (DriveType 2 o 3). 
Luego, muestra el ID del dispositivo, el tamaño total del disco y el espacio libre en bytes.

.PARAMETER ComputerName
Nombre del computador del cual se desea obtener la información de los discos. 
El valor predeterminado es 'localhost'.

.EXAMPLE
Get-FileSystemsDisk -ComputerName server1
#>
function Get-FileSystemsDisk {
    param (
        $ComputerName = 'localhost'
    )

    Get-WmiObject -Class Win32_logicaldisk -ComputerName $ComputerName |
    Where-Object {$_.DriveType -eq 2 -or $_.DriveType -eq 3} |
    Select-Object -Property DeviceID, @{n='Tamaño(Bytes)'; e={$_.Size / 1 -as [int64]}}, 
    @{n='Espacio Libre(Bytes)'; e={$_.FreeSpace / 1 -as [int64]}}
}

<#
.SYNOPSIS
Obtiene el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem.

.DESCRIPTION
Get-LargestFile busca en un directorio especificado y sus subdirectorios para encontrar el archivo más grande. 
Si el directorio especificado no existe o no contiene archivos, muestra un mensaje de error.
Muestra el nombre del archivo, el tamaño en bytes y la ruta completa.

.PARAMETER Path
Ruta del directorio en el cual se desea buscar el archivo más grande. Este parámetro es obligatorio.

.EXAMPLE
Get-LargestFile -Path C:\Users\Documents
#>
function Get-LargestFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [string]$Path
    )

    #El Test-Path cmdlet determina si existen todos los elementos de la ruta de acceso.
    if (Test-Path $Path) {
        # Obtener todos los archivos en el directorio y subdirectorios
        $Files = Get-ChildItem -Path $Path -Recurse -File

        # Verificar si hay archivos en el directorio
        if ($Files.Count -ne 0) {
            # Encontrar el archivo más grande
            $LargestFile = $Files | Sort-Object -Property Length -desc | Select-Object -First 1
            $LargestFile | Select-Object Name, @{n='Tamaño(Bytes)';e={$_.Length / 1 -as [int64]}}, FullName
        }
        else{
            Write-Host ""
            Write-Host "No se encontraron archivos en el directorio especificado." -ForegroundColor Red -BackgroundColor Black
            return
        }
    }
    else {
        Write-Host ""
        Write-Host "El directorio especificado no existe." -ForegroundColor Red -BackgroundColor Black
        return
    }
}


<#
.SYNOPSIS
Obtiene la cantidad de memoria libre y la cantidad de espacio de swap en uso.

.DESCRIPTION
Get-MemorySwapInfo utiliza WMI para obtener información sobre la memoria física libre y el uso del espacio de swap en el sistema. 
Calcula tanto la cantidad como el porcentaje de memoria libre y espacio de swap en uso, 
y devuelve esta información en un objeto personalizado.
#>
function Get-MemorySwapInfo {
    $SystemInformation = Get-WmiObject -Class Win32_OperatingSystem
    $SwapInformation = Get-WmiObject -Class Win32_PageFileUsage

    #Obtener información de memoria
    $FreeMemory = $SystemInformation.FreePhysicalMemory / 1 -as [int64]
    $FreeMemoryPercentage = (($SystemInformation.FreePhysicalMemory / $SystemInformation.TotalVisibleMemorySize) * 100 -as [int])

    #Obtener información de swap
    $SwapUsage = $SwapInformation.CurrentUsage / 1 -as [int64]
    $SwapUsagePercentage = (($SwapInformation.CurrentUsage / $SwapInformation.AllocatedBaseSize) * 100 -as [int])

    # Crear un objeto personalizado
    $MemoryInfo = [PSCustomObject]@{
        FreeMemory = $FreeMemory
        FreeMemoryPercentage = "$FreeMemoryPercentage%"
        SwapUsage = $SwapUsage
        SwapUsagePercentage = "$SwapUsagePercentage%"
    }
    return $MemoryInfo
}


<#
.SYNOPSIS
Obtiene el número de conexiones de red activas actualmente en estado ESTABLISHED.

.DESCRIPTION
Get-NetworkConnections utiliza el cmdlet Get-NetTCPConnection para obtener todas las conexiones TCP en el sistema 
y filtra aquellas que están en estado ESTABLISHED. Luego, cuenta el número de estas conexiones y devuelve el resultado.
#>
function Get-NetworkConnections {
    Get-NetTCPConnection | Where-Object {$_.State -eq "Established"} | Measure-Object | 
    Select-Object -Property @{n="Número de Conexiones con estado ESTABLISHED"; e={$_.Count}}
}

<#
.SYNOPSIS
Proporciona un menú interactivo para ejecutar varios scripts de administración del data center.

.DESCRIPTION
Este script muestra un menú de opciones para realizar diferentes tareas de administración del data center.
El usuario puede seleccionar una opción y el script ejecutará la tarea correspondiente. 
El menú se repetirá hasta que el usuario seleccione la opción de salir.
#>
do {
    Show-Menu
    $option = Read-Host "Seleccione una opción"
    Write-Host ""

    switch ($option) {
        1 {
            cls
            Write-Host "=========Top 5 procesos por CPU=========" -ForegroundColor Yellow
            Get-TopCPUProcesses | Format-Table -AutoSize
            break
        }
        2 {
            cls
            Write-Host "=========Filesystems y discos=========" -ForegroundColor Yellow
            Get-FileSystemsDisk | Format-Table -AutoSize
            break
        }
        3 {
            cls
            Write-Host "=========Archivo más grande=========" -ForegroundColor Yellow
            Get-LargestFile | Format-List
            break
        }
        4 {
            cls
            Write-Host "=========Memoria y swap=========" -ForegroundColor Yellow
            Get-MemorySwapInfo | Format-List
            break
        }
        5 {
            cls
            Write-Host "=========Conexiones de red=========" -ForegroundColor Yellow
            Get-NetworkConnections | Format-List
            break
        }
        0 {
            cls
            Write-Host "==================================" -ForegroundColor Magenta
            Write-Host "            Saliendo              " -ForegroundColor Cyan
            Write-Host "==================================" -ForegroundColor Magenta
            break
        }
        default {
            Write-Host "Opción no válida. Intente de nuevo." -ForegroundColor Red -BackgroundColor Black
            break
        }
    }
    #Esto permite al usuario ver la salida en la consola antes de que el script vuelva a mostrar el menú y solicite otra entrada.
    Write-Host ""
    pause
    Write-Host ""
    cls
} while ($option -ne 0)