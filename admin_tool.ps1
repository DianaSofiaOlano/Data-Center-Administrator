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