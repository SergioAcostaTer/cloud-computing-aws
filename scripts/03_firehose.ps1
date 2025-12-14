. "$PSScriptRoot/config/variables.ps1"

Write-Host "Creating Firehose Delivery Stream..."

# 1. Wait for Kinesis propagation (Safety pause)
Write-Host "Waiting 15s for Kinesis propagation..."
Start-Sleep -Seconds 15

# 2. Create Firehose (Connects Kinesis -> S3)
aws firehose create-delivery-stream `
    --delivery-stream-name "consumo-energetico-firehose" `
    --delivery-stream-type KinesisStreamAsSource `
    --kinesis-stream-source-configuration "KinesisStreamARN=arn:aws:kinesis:$($env:AWS_REGION):$($env:ACCOUNT_ID):stream/consumo-energetico-stream,RoleARN=$env:ROLE_ARN" `
    --extended-s3-destination-configuration "BucketARN=arn:aws:s3:::$($env:BUCKET_NAME),RoleARN=$env:ROLE_ARN,Prefix=raw/,ErrorOutputPrefix=errors/,BufferingHints={SizeInMBs=1,IntervalInSeconds=60}"