import threading
import time
import RPi.GPIO as GPIO
import sys

# Tipo de configuracion de los puertos
GPIO.setmode(GPIO.BOARD)

PIN_IN1_STEPPER = 31
PIN_IN2_STEPPER = 33
PIN_IN3_STEPPER = 35
PIN_IN4_STEPPER = 37


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

# Read wait time from command line
if len(sys.argv)>1:
  WaitTime = int(sys.argv[1])/float(1000)
else:
  WaitTime = 10/float(1000)

# Control de hilos
running = False
pause = threading.Event()
pause.set()

# Initialise variables
StepCounter = 0

def activar_motor():
    global StepCount
    global StepCounter
    while running:
        pause.wait()  # Pausar el hilo si se desactiva el evento
        print(StepCounter)
        print(Seq[StepCounter])

        for pin in range(0, 4):
            xpin = StepPins[pin]
            if Seq[StepCounter][pin] != 0:
                print("Enable GPIO %i" % xpin)
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
        threading.Thread(target=activar_motor).start()
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

def cleanup_gpio():
    GPIO.cleanup()

def setup():
    #Declaracion de GPIO input o output
    
    GPIO.setup(PIN_IN1_STEPPER,GPIO.OUT)
    GPIO.setup(PIN_IN2_STEPPER,GPIO.OUT)
    GPIO.setup(PIN_IN3_STEPPER,GPIO.OUT)
    GPIO.setup(PIN_IN4_STEPPER,GPIO.OUT)

    #Iniciar apagados los puertos
    
    GPIO.output(PIN_IN1_STEPPER,0)
    GPIO.output(PIN_IN2_STEPPER,0)
    GPIO.output(PIN_IN3_STEPPER,0)
    GPIO.output(PIN_IN4_STEPPER,0)

setup()
# Uso:
# Iniciar el motor
start_motor()

# Mantener el programa principal corriendo para que el hilo no se detenga
try:
    while True:
        time.sleep(1)  # Mantener el hilo principal dormido
except KeyboardInterrupt:
    running = False
    cleanup_gpio()
    print("Motor detenido y GPIO limpiado")
