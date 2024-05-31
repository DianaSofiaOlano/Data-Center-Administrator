function Show-Menu
{
     param (
           [string]$Title = 'Herramienta de Administración del Data Center'
     )

     cls
     Write-Host "================================================="
     Write-Host "  $Title  "
     Write-Host "================================================="
     Write-Host ""
     Write-Host "1. Mostrar los cinco procesos de mayor consumo de CPU"
     Write-Host "2. Mostrar discos y sus tamaños, incluyendo espacio libre"
     Write-Host "3. Mostrar nombre, tamaño y trayectoria del archivo más grande"
     Write-Host "4. Mostrar memoria libre y uso de swap"
     Write-Host "5. Mostrar conexiones de red activas (ESTABLISHED)"
     Write-Host "0. Salir"
     Write-Host ""
}

do {
    Show-Menu
    $option = Read-Host "Seleccione una opción"
    Write-Host ""

    switch ($option) {
        1 {
            cls
            Write-Host "=========Top 5 procesos por CPU========="
            Write-Host ""
            break
        }
        2 {
            cls
            Write-Host "=========Filesystems y discos========="
            Write-Host ""
            break
        }
        3 {
            cls
            Write-Host "=========Archivo más grande========="
            Write-Host ""
            break
        }
        4 {
            cls
            Write-Host "=========Memoria y swap========="
            Write-Host ""
            break
        }
        5 {
            cls
            Write-Host "=========Conexiones de red========="
            Write-Host ""
            break
        }
        0 {
            cls
            Write-Host "=========Saliendo========="
            Write-Host ""
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
} while ($option -ne 0)