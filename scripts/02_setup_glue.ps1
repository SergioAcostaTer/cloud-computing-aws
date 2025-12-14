. "$PSScriptRoot/config/variables.ps1"

# 1. Crear Base de Datos de Glue
# Es como crear una base de datos vacía en SQL, un contenedor lógico.
Write-Host "Creando Base de Datos 'energy_db'..."
# Usamos '2>$null' para silenciar el error si ya existe, y comprobamos el código de salida.
aws glue create-database --database-input "{\`"Name\`":\`"energy_db\`"}" 2>$null
if ($LASTEXITCODE -ne 0) { Write-Host "Nota: La base de datos 'energy_db' ya existe o hubo un error menor. Continuando..." -ForegroundColor Yellow }

# 2. Crear el Crawler (Rastreador)
# Primero intentamos borrarlo por si ya existe y quedó mal configurado (limpieza preventiva)
aws glue delete-crawler --name energy_temp_crawler 2>$null

Write-Host "Creando Crawler 'energy_temp_crawler'..."

# CORRECCIÓN: Construimos el JSON escapando explícitamente las comillas dobles (\")
# Esto evita que PowerShell elimine las comillas al pasar el argumento a AWS CLI.
$TARGETS_JSON = '{\"S3Targets\": [{\"Path\": \"s3://' + $env:BUCKET_NAME + '/raw/\"}]}'

aws glue create-crawler `
    --name energy_temp_crawler `
    --role $env:ROLE_ARN `
    --database-name energy_db `
    --targets $TARGETS_JSON

# 3. (Opcional) Iniciar el Crawler
# Esto ejecuta el robot inmediatamente para que descubra los datos que ya subiste.
Write-Host "Iniciando el Crawler..."
aws glue start-crawler --name energy_temp_crawler

Write-Host "Configuración completada. El crawler está analizando tus datos en S3." -ForegroundColor Green