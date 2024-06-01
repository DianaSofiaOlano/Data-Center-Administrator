function Show-Menu
{
     param (
        [string]$Title = 'Administración del Data Center'
     )

     cls
     Write-Host "=================================="
     Write-Host "  $Title  "
     Write-Host "=================================="
     Write-Host ""
     Write-Host "1. Mostrar los cinco procesos de mayor consumo de CPU"
     Write-Host "2. Mostrar discos y sus tamaños, incluyendo espacio libre"
     Write-Host "3. Mostrar nombre, tamaño y trayectoria del archivo más grande"
     Write-Host "4. Mostrar memoria libre y uso de swap"
     Write-Host "5. Mostrar conexiones de red activas (ESTABLISHED)"
     Write-Host "0. Salir"
     Write-Host ""
}

function Get-Top-CPU-Processes
{
   Get-Process | Sort-Object -Property CPU -desc | Select-Object -First 5 | Format-Table -Property Id, ProcessName, CPU
}

function Get-FileSystems-Disk {
    param (
        $ComputerName = 'localhost'
    )

    Get-WmiObject -Class Win32_logicaldisk -ComputerName $ComputerName |
    Where-Object {$_.DriveType -eq 2 -or $_.DriveType -eq 3} |
    Select-Object -Property DeviceID, @{n='Tamaño (Bytes)'; e={$_.Size}}, 
    @{n='Espacio Libre (Bytes)'; e={$_.FreeSpace}} | Format-Table
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
            Write-Host "Tamaño (Bytes): $($LargestFile.Length)"
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


do {
    Show-Menu
    $option = Read-Host "Seleccione una opción"
    Write-Host ""

    switch ($option) {
        1 {
            cls
            Write-Host "=========Top 5 procesos por CPU========="
            Get-Top-CPU-Processes #-AutoSize
            break
        }
        2 {
            cls
            Write-Host "=========Filesystems y discos========="
            Get-FileSystems-Disk #-AutoSize
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
            break
        }
        5 {
            cls
            Write-Host "=========Conexiones de red========="
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