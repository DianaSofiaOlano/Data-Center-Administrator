function Show-Menu {
     param (
        [string]$Title = 'ADMINISTRACIÓN DEL DATA CENTER'
     )

     cls
     Write-Host "=================================="
     Write-Host "  $Title  " -ForegroundColor Cyan
     Write-Host "=================================="
     Write-Host ""
     Write-Host "1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento"
     Write-Host "2. Desplegar los filesystems o discos conectados a la máquina"
     Write-Host "3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem"
     Write-Host "4. Cantidad de memoria libre y cantidad del espacio de swap en uso"
     Write-Host "5. Número de conexiones de red activas actualmente (en estado ESTABLISHED)"
     Write-Host "0. Salir"
     Write-Host ""
}

function Get-Top-CPU-Processes {
   Get-Process | Sort-Object -Property CPU -desc | Select-Object -First 5 | 
   Format-Table -Property Id, ProcessName, CPU -AutoSize

}

function Get-FileSystems-Disk {
    param (
        $ComputerName = 'localhost'
    )

    Get-WmiObject -Class Win32_logicaldisk -ComputerName $ComputerName |
    Where-Object {$_.DriveType -eq 2 -or $_.DriveType -eq 3} |
    Format-Table -Property DeviceID, @{n='Tamaño (Bytes)'; e={$_.Size / 1 -as [int64]}}, 
    @{n='Espacio Libre (Bytes)'; e={$_.FreeSpace / 1 -as [int64]}} -AutoSize
}

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

            Write-Host ""
            Write-Host "Nombre: $($LargestFile.Name)"
            Write-Host "Tamaño (Bytes): $($LargestFile.Length / 1 -as [int64])"
            Write-Host "Ruta: $($LargestFile.FullName)"
        }
        else{
            Write-Host ""
            Write-Host "No se encontraron archivos en el directorio especificado."
            return
        }
    }
    else {
        Write-Host ""
        Write-Host "El directorio especificado no existe."
        return
    }
}

function Get-Memory-Swap-Info {
    $SystemInformation = Get-WmiObject -Class Win32_OperatingSystem
    $SwapInformation = Get-WmiObject -Class Win32_PageFileUsage

    #Obtener información de memoria
    $TotalMemory = $SystemInformation.TotalVisibleMemorySize
    $FreeMemory = $SystemInformation.FreePhysicalMemory / 1 -as [int64]
    $FreeMemoryPercentage = [Math]::Round(($FreeMemory / $TotalMemory) * 100, 2)

    #Obtener información de swap
    $TotalSwap = $SwapInformation.AllocatedBaseSize
    $SwapUsage = $SwapInformation.CurrentUsage / 1 -as [int64]
    $SwapUsagePercentage = [Math]::Round(($SwapUsage / $TotalSwap) * 100, 2)

    Write-Host ""
    Write-Host "Memoria libre: $($FreeMemory)"
    Write-Host "Porcentaje de Memoria libre: $($FreeMemoryPercentage.ToString("F2"))%"
    Write-Host "Espacio de Swap en uso: $($SwapUsage)"
    Write-Host "Porcentaje de espacio de Swap en uso: $($SwapUsagePercentage.ToString("F2"))%"
}

function Get-NetworkConnections {
    Get-NetTCPConnection | Where-Object {$_.State -eq "Established"} | Measure-Object | 
    Format-Table -Property @{n="Número de Conexiones con estado ESTABLISHED"; e={$_.Count};Alignment="Center"} -AutoSize
}

do {
    Show-Menu
    $option = Read-Host "Seleccione una opción"
    Write-Host ""

    switch ($option) {
        1 {
            cls
            Write-Host "=========Top 5 procesos por CPU========="
            Get-Top-CPU-Processes
            break
        }
        2 {
            cls
            Write-Host "=========Filesystems y discos========="
            Get-FileSystems-Disk
            break
        }
        3 {
            cls
            Write-Host "=========Archivo más grande========="
            Get-LargestFile
            break
        }
        4 {
            cls
            Write-Host "=========Memoria y swap========="
            Get-Memory-Swap-Info
            break
        }
        5 {
            cls
            Write-Host "=========Conexiones de red========="
            Get-NetworkConnections
            break
        }
        0 {
            cls
            Write-Host "=========Saliendo========="
            break
        }
        default {
            Write-Host "Opción no válida. Intente de nuevo."
            break
        }
    }
    #Esto permite al usuario ver la salida en la consola antes de que el script vuelva a mostrar el menú y solicite otra entrada.
    Write-Host ""
    pause
    Write-Host ""
    cls
} while ($option -ne 0)