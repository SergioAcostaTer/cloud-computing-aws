Write-Host "=== PIPELINE DEPLOYMENT ===" -ForegroundColor Cyan

# 1. Load variables
. "$PSScriptRoot/config/variables.ps1"

# 2. Storage (S3)
Write-Host "`n[1/4] Setting up S3..." -ForegroundColor Yellow
. "$PSScriptRoot/01_s3.ps1"

# 3. Kinesis Stream
Write-Host "`n[2/4] Setting up Kinesis..." -ForegroundColor Yellow
. "$PSScriptRoot/02_kinesis.ps1"

# 4. Firehose Delivery
Write-Host "`n[3/4] Setting up Firehose..." -ForegroundColor Yellow
. "$PSScriptRoot/03_firehose.ps1"

# 5. Glue Catalog
Write-Host "`n[4/4] Setting up Glue..." -ForegroundColor Yellow
. "$PSScriptRoot/04_glue.ps1"

Write-Host "`nPipeline deployed successfully." -ForegroundColor Green
Write-Host "You can now run the Python producer." -ForegroundColor Green