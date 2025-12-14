$env:AWS_REGION = "us-east-1"
$env:ACCOUNT_ID = (aws sts get-caller-identity --query Account --output text).Trim()
$env:ROLE_ARN = (aws iam get-role --role-name LabRole --query 'Role.Arn' --output text).Trim()
$env:BUCKET_NAME = "datalake-energy-consumption-$($env:ACCOUNT_ID)"

Write-Host "Config: Account $env:ACCOUNT_ID | Bucket $env:BUCKET_NAME"