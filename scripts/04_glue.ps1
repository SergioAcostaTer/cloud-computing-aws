. "$PSScriptRoot/config/variables.ps1"

# 1. Create Database
Write-Host "Creating Glue Database 'energy_db'..."
# Suppress error if DB exists using 2>$null
aws glue create-database --database-input "{\`"Name\`":\`"energy_db\`"}" 2>$null
if ($LASTEXITCODE -ne 0) { Write-Host "Note: Database exists or minor error. Continuing..." -ForegroundColor Yellow }

# 2. Create Crawler
# Cleanup existing crawler first
aws glue delete-crawler --name energy_temp_crawler 2>$null

Write-Host "Creating Crawler 'energy_temp_crawler'..."

# Construct JSON target string (escaping quotes for PowerShell)
$TARGETS_JSON = '{\"S3Targets\": [{\"Path\": \"s3://' + $env:BUCKET_NAME + '/raw/\"}]}'

aws glue create-crawler `
    --name energy_temp_crawler `
    --role $env:ROLE_ARN `
    --database-name energy_db `
    --targets $TARGETS_JSON

# 3. Start Crawler
Write-Host "Starting Crawler..."
aws glue start-crawler --name energy_temp_crawler

Write-Host "Glue setup complete. Crawler is analyzing S3 data." -ForegroundColor Green