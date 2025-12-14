Write-Host "=== EJECUCIÓN COMPLETA DEL PIPELINE ===" -ForegroundColor Cyan

# 1. Cargar variables
. "$PSScriptRoot/config/variables.ps1"

# 2. Infraestructura base
Write-Host "`n[1/2] Creando infraestructura..." -ForegroundColor Yellow
. "$PSScriptRoot/01_setup_infra.ps1"

# 3. Glue
Write-Host "`n[2/2] Configurando Glue..." -ForegroundColor Yellow
. "$PSScriptRoot/02_setup_glue.ps1"

Write-Host "`nPipeline desplegado correctamente." -ForegroundColor Green
Write-Host "Puedes ahora ejecutar el productor Python." -ForegroundColor Green
