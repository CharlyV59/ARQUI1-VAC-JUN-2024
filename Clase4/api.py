from flask import Flask, request, jsonify
import RPi.GPIO as GPIO
import sys
import time
import threading

#Inicializar flask
app = Flask(__name__)

# Lista para almacenar el estado de los LEDs
leds = []

# Variable para almacenar el estado del motor
estado_motor = None

# Tipo de configuracion de los puertos
GPIO.setmode(GPIO.BOARD)

# Desactivamos alertas de GPIO
GPIO.setwarnings(False)

#Declaracion de puerto GPIO
LED1 = 11
MOTOR = 13
PIN_IN1_STEPPER = 31
PIN_IN2_STEPPER = 33
PIN_IN3_STEPPER = 35
PIN_IN4_STEPPER = 37


#Numero de puertos motor stepper utilizados para su programacion
StepPins = [PIN_IN1_STEPPER,PIN_IN2_STEPPER,PIN_IN3_STEPPER,PIN_IN4_STEPPER]

#Secuencia de movimiento stepper
Seq = [[1,0,0,1],
       [1,0,0,0],
       [1,1,0,0],
       [0,1,0,0],
       [0,1,1,0],
       [0,0,1,0],
       [0,0,1,1],
       [0,0,0,1]]

StepCount = len(Seq)
StepDir = 1 # Colocar 1 o 2 para sentido horario
            # Colocar -1 o -2 para sentido antihorario

# Initialise variables
StepCounter = 0

# Read wait time from command line
if len(sys.argv)>1:
  WaitTime = int(sys.argv[1])/float(1000)
else:
  WaitTime = 10/float(1000)

# Control de los hilos
running = False
pause = threading.Event()
pause.set()
iniciar_stepper = True

# Control creacion de api
crear = True

#Funcion para activar el puerto especifico y en un estado especifico
def controlar_gpio(puerto,estado):
    if puerto == 1:
        GPIO.output(LED1, estado)
    elif puerto == 2:
        GPIO.output(MOTOR, estado)
    else:
        print("No existe el puerto para activarlo.")  

def activar_motor_stepper():
    global StepCount
    global StepCounter
    while running:
        pause.wait()  # Pausar el hilo si se desactiva el evento
        #print(StepCounter)
        #print(Seq[StepCounter])

        for pin in range(0, 4):
            xpin = StepPins[pin]
            if Seq[StepCounter][pin] != 0:
                #print("Enable GPIO %i" % xpin)
                GPIO.output(xpin, True)
            else:
                GPIO.output(xpin, False)

        StepCounter += StepDir

        # Si llegamos al final de la secuencia, empezar de nuevo
        if StepCounter >= StepCount:
            StepCounter = 0
        if StepCounter < 0:
            StepCounter = StepCount + StepDir

        time.sleep(WaitTime)

def start_motor():
    global running
    if not running:
        running = True
        threading.Thread(target=activar_motor_stepper, daemon=True).start()
        print("Motor iniciado")

def stop_motor():
    global running
    running = False
    print("Motor detenido")

def pause_motor():
    pause.clear()
    print("Motor pausado")

def resume_motor():
    pause.set()
    print("Motor reanudado")

@app.route('/activarLed', methods=['POST'])
def activar_led():
    global leds
    data = request.json
    cuarto = data.get('cuarto')
    estado = data.get('estado')

    if not isinstance(cuarto, int) or not isinstance(estado, int):
        return jsonify({"error": "Los parámetros 'cuarto' y 'estado' deben ser numéricos"}), 400

    # Buscar si el cuarto ya existe en la lista
    found = False
    for led in leds:
        if led['cuarto'] == cuarto:
            led['estado'] = estado
            found = True
            break
    
    if not found:
        leds.append({"cuarto": cuarto, "estado": estado})

    controlar_gpio(cuarto,estado)
    
    return jsonify({"mensaje": "Estado del LED actualizado correctamente"}), 200

@app.route('/verEstadoLED', methods=['GET'])
def ver_estado_led():
    global leds
    cuarto = request.args.get('cuarto', type=int)

    if cuarto is None:
        return jsonify({"error": "El parámetro 'cuarto' es necesario y debe ser numérico"}), 400

    for led in leds:
        if led['cuarto'] == cuarto:
            return jsonify({"cuarto": cuarto, "estado": led['estado']}), 200
    
    return jsonify({"error": "Cuarto no encontrado"}), 404

@app.route('/activarMotor', methods=['POST'])
def activar_motor():
    global estado_motor
    global iniciar_stepper
    data = request.json
    estado = data.get('estado')

    if not isinstance(estado, int):
        return jsonify({"error": "El parámetro 'estado' debe ser numérico"}), 400

    estado_motor = estado
     #Codigo para activar motor
    if estado_motor == 1:
        start_motor()
        print("Motor activado")
    else:
        stop_motor()
        print("Motor detenido")
    
        
    #Tambien la opcion de detener totalmente el motor pero hay que inicializar de nuevo
    #Es con la siguiente linea
    #stop_motor()
    
    return jsonify({"mensaje": "Estado del motor actualizado correctamente"}), 200

@app.route('/verEstadoMotor', methods=['GET'])
def ver_estado_motor():
    global estado_motor

    if estado_motor is None:
        return jsonify({"error": "El estado del motor no ha sido configurado aún"}), 404
    
    return jsonify({"estado_motor": estado_motor}), 200

#Codigo que se ejecuta solo una vez
def setup():
    #Declaracion de GPIO input o output
    GPIO.setup(LED1, GPIO.OUT)
    GPIO.setup(MOTOR, GPIO.OUT)
    GPIO.setup(PIN_IN1_STEPPER,GPIO.OUT)
    GPIO.setup(PIN_IN2_STEPPER,GPIO.OUT)
    GPIO.setup(PIN_IN3_STEPPER,GPIO.OUT)
    GPIO.setup(PIN_IN4_STEPPER,GPIO.OUT)

    #Iniciar apagados los puertos
    GPIO.output(LED1, 0)
    GPIO.output(MOTOR, 0)
    GPIO.output(PIN_IN1_STEPPER,0)
    GPIO.output(PIN_IN2_STEPPER,0)
    GPIO.output(PIN_IN3_STEPPER,0)
    GPIO.output(PIN_IN4_STEPPER,0)

try:
    while True:
        time.sleep(1)  # Mantener el hilo principal dormido

        if crear == True:
            if __name__ == '__main__':
                setup()
                crear = False
                app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=False)
        
except KeyboardInterrupt:
        running = False
        GPIO.cleanup()
