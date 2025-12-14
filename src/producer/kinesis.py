import boto3
from loguru import logger
import time
import json

# Configuración de constantes
STREAM_NAME = 'consumo-energetico-stream'
INPUT_FILE = 'datos.json'

# Inicializamos el cliente de Kinesis usando boto3
kinesis = boto3.client('kinesis')

def load_data(path: str):
    """
    Lee el archivo JSON desde la ruta especificada.
    """
    with open(path, 'r') as f:
        return json.load(f)

def run_producer():
    """
    Función principal que procesa los datos y los envía a Kinesis.
    """
    # Cargamos los datos del archivo
    data = load_data(INPUT_FILE)
    records_sent = 0 # Contador de registros enviados

    # Obtenemos la lista de series (o lista vacía si no existe)
    series_list = data.get('included', [])

    logger.info(f"Iniciando transmision de {STREAM_NAME}")

    # Iteramos sobre cada serie de datos
    for serie in series_list:
        # Extraemos el título (tipo de demanda) y los valores
        tipo_demanda = serie['attributes']['title']
        valores = serie['attributes']['values']

        # Iteramos sobre cada registro individual dentro de la serie
        for registro in valores:
            
            # Construimos el diccionario de datos (payload) que enviaremos
            payload = {
                'tipo': tipo_demanda,
                'valor': registro['value'],
                'timestamp_origen': registro['datetime'],
                'porcentaje': registro['percentage'],
            }

            # Enviamos el registro al stream de Kinesis
            response = kinesis.put_record(
                StreamName=STREAM_NAME,
                Data=json.dumps(payload), # Convertimos el dict a string JSON
                PartitionKey=tipo_demanda  # Usamos el tipo como clave de partición
            )
            
            # Actualizamos el contador e imprimimos el log de éxito
            records_sent += 1
            logger.info(f"Sent record {records_sent} data with {response=}")
            
            # Pequeña pausa para no saturar el envío (10ms)
            time.sleep(0.01)

# Punto de entrada del script
if __name__ == "__main__":
    run_producer()