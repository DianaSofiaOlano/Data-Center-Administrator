function Show-Menu
{
     param (
           [string]$Title = ‘Herramienta de Administración del Data Center’
     )

     cls
     Write-Host “================ $Title ================”
    
     Write-Host "1. Top 5 procesos por CPU"
     Write-Host "2. Filesystems y discos"
     Write-Host "3. Archivo más grande"
     Write-Host "4. Memoria y swap"
     Write-Host "5. Conexiones de red"
     Write-Host "0. Salir"
}