# Consumo Energético – AWS Streaming Pipeline

Pipeline de ingestión y análisis de datos energéticos usando:
- Amazon Kinesis
- Amazon Firehose
- Amazon S3
- AWS Glue
- Python (boto3)

## Arquitectura
Kinesis → Firehose → S3 (raw) → Glue Crawler → Glue Data Catalog

## Requisitos
- AWS CLI configurado
- PowerShell
- Python 3.9+

## Despliegue de infraestructura
```powershell
cd infrastructure/scripts
.\setup.ps1
.\glue.ps1
```

## Envío de datos

```bash
cd src/producer
python kinesis.py
```

## Limpieza de recursos

```powershell
.\cleanup.ps1
```