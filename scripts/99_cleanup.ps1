. "$PSScriptRoot/config/variables.ps1"

Write-Host "STARTING FULL RESOURCE CLEANUP FOR ACCOUNT $env:ACCOUNT_ID..." -ForegroundColor Red

# --- 1. GLUE CLEANUP ---
Write-Host "1. Deleting Glue resources..."

# 1.1 Delete Crawler
Write-Host "   - Deleting Crawler 'energy_temp_crawler'..."
aws glue delete-crawler --name energy_temp_crawler 2>$null

# 1.2 Delete Database
Write-Host "   - Deleting Database 'energy_db'..."
aws glue delete-database --name energy_db 2>$null


# --- 2. INFRA CLEANUP ---
Write-Host "2. Deleting Ingestion infrastructure..."

# 2.1 Delete Firehose
Write-Host "   - Deleting Firehose Delivery Stream..."
aws firehose delete-delivery-stream --delivery-stream-name "consumo-energetico-firehose" 2>$null

# 2.2 Delete Kinesis Stream
Write-Host "   - Deleting Kinesis Data Stream..."
aws kinesis delete-stream --stream-name "consumo-energetico-stream" 2>$null


# --- 3. STORAGE CLEANUP ---
Write-Host "3. Deleting Storage (S3)..."

# 3.1 Delete Bucket (Force delete contents)
Write-Host "   - Deleting S3 Bucket ($env:BUCKET_NAME)..."
aws s3 rb "s3://$env:BUCKET_NAME" --force 2>$null

Write-Host "Cleanup finished." -ForegroundColor Green