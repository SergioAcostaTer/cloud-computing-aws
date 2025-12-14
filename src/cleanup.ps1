# --- VARIABLES ---
# Re-establishing variables to find the correct resources to delete
$env:AWS_REGION = "us-east-1"
$env:ACCOUNT_ID = (aws sts get-caller-identity --query Account --output text).Trim()
$env:BUCKET_NAME = "datalake-consumo-energetico-$($env:ACCOUNT_ID)"

Write-Host "Iniciando limpieza de recursos para la cuenta $env:ACCOUNT_ID..." -ForegroundColor Yellow

# 1. Eliminar Firehose (Debe eliminarse antes que el Stream de Kinesis si hay dependencias, aunque aquí son independientes)
Write-Host "Eliminando Firehose Delivery Stream..."
aws firehose delete-delivery-stream --delivery-stream-name "consumo-energetico-firehose"

# 2. Eliminar Kinesis Stream
Write-Host "Eliminando Kinesis Data Stream..."
aws kinesis delete-stream --stream-name "consumo-energetico-stream"

# 3. Eliminar Bucket S3
Write-Host "Eliminando S3 Bucket ($env:BUCKET_NAME)..."
aws s3 rb "s3://$env:BUCKET_NAME" --force

Write-Host "Limpieza completada." -ForegroundColor Green