import random
import time
import os
import subprocess
from flask import Flask, jsonify

# Configuracion del backend Flask
app = Flask(__name__)
sumatoria = 0  # Variable para almacenar la sumatoria acumulada

# Función para generar un número aleatorio entre 1 y 9 cada 10 segundos
def generar_numero_aleatorio():
    numero = random.randint(1, 9)
    return numero

# Función para escribir el número en el archivo input.txt
def escribir_en_archivo(numero):
    if os.path.exists('input.txt'):
        with open('input.txt', 'a') as f:
            f.write(f'{numero},')
    else:
        with open('input.txt', 'w') as f:
            f.write(f'{numero},')

# Función para ejecutar el comando ./suma cada 30 segundos
def ejecutar_comando_suma():
    # print('Suma!')
    subprocess.run(['./sumar'])

def obtener_sumatoria_desde_archivo():
    global sumatoria
    if os.path.exists('output'):
        with open('output', 'r') as f:
            contenido = f.read().strip()  # Lee y elimina espacios en blanco al inicio y final
            # Convierte el contenido directamente a entero
        print(contenido)
        sumatoria = int(contenido)


# Función para actualizar la sumatoria y retornar su valor
@app.route('/getsumatoria', methods=['GET'])
def get_sumatoria():
    global sumatoria
    return jsonify({'sumatoria': sumatoria})


# Función principal que ejecuta las tareas programadas
def main():
    while True:
        numero = generar_numero_aleatorio()
        escribir_en_archivo(numero)
        time.sleep(10)

        ejecutar_comando_suma()

        time.sleep(2)

        obtener_sumatoria_desde_archivo()
        print(sumatoria)
            

# Iniciar el servidor Flask en un hilo aparte para el endpoint
if __name__ == '__main__':
    import threading
    threading.Thread(target=app.run, kwargs={'port': 5000}).start()

    main()
