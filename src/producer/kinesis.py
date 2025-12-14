import boto3
from loguru import logger
import time
import json

# Constants
STREAM_NAME = 'consumo-energetico-stream'
INPUT_FILE = '../data/datos.json'

# Initialize Kinesis client
kinesis = boto3.client('kinesis')

def load_data(path: str):
    """
    Read JSON file from path.
    """
    with open(path, 'r') as f:
        return json.load(f)

def run_producer():
    """
    Main function to process data and send to Kinesis.
    """
    # Load data
    data = load_data(INPUT_FILE)
    records_sent = 0 

    # Get list of series
    series_list = data.get('included', [])

    logger.info(f"Starting transmission to {STREAM_NAME}")

    # Loop through data series
    for serie in series_list:
        # Extract title (demand type) and values
        tipo_demanda = serie['attributes']['title']
        valores = serie['attributes']['values']

        # Loop through records in the series
        for registro in valores:
            
            # Build payload
            payload = {
                'tipo': tipo_demanda,
                'valor': registro['value'],
                'timestamp_origen': registro['datetime'],
                'porcentaje': registro['percentage'],
            }

            # Send record to Kinesis
            response = kinesis.put_record(
                StreamName=STREAM_NAME,
                Data=json.dumps(payload) + '\n',  # Newline for Firehose compatibility
                PartitionKey=tipo_demanda # Use type as partition key
            )
            
            # Update counter and log
            records_sent += 1
            logger.info(f"Sent record {records_sent} data with {response=}")
            
            # Short sleep to prevent saturation (10ms)
            time.sleep(0.01)

if __name__ == "__main__":
    run_producer()