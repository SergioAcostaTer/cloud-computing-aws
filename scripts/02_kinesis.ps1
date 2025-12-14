. "$PSScriptRoot/config/variables.ps1"

Write-Host "Creating Kinesis Data Stream..."

# 1. Create Stream
aws kinesis create-stream --stream-name "consumo-energetico-stream" --shard-count 1