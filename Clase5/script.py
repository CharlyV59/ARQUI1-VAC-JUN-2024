import RPi.GPIO as GPIO
import time
from LCD import LCD

lcd = LCD(2, 0x21)


def colocar_angulo(angulo):
    if angulo > 180 or angulo < 0:
        return False
    # Ciclo de trabajo( En porcentaje) correspodiente a 0
    comienza = 4
    # Ciclo de trabajo (En porcetaje) correspondiente a 180
    termina = 12.5
    # calcular la proporcion
    razon = (termina - comienza) / 180

    porcentaje_angulo = angulo * razon

    porcentaje_angulo = angulo * razon

    # Retornamos el ciclo de trabajo correspondiente al angulo
    return comienza + porcentaje_angulo


GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

# Variables del servo
pwm_gpio = 26
frequence = 50
GPIO.setup(pwm_gpio, GPIO.OUT)
pwm = GPIO .PWM(pwm_gpio, frequence)

# LEDs variables
DECODER1 = 7  # Menos significativo
DECODER2 = 29
DECODER3 = 31  # Mas significativo

dec = [[0, 0, 0],  # LED 1 = 0
       [0, 0, 1],  # LED 2= 1
       [0, 1, 0],  # LED 3= 2
       [0, 1, 1],  # LED 4 = 3
       [1, 0, 0],  # LED 5 = 4
       [1, 0, 1],  # LED 6 = 5
       [1, 1, 0],  # LED 7 = 6
       [1, 1, 1]  # LED 8 = 7
       ]

# Motor DC
MOTOR = 24

# Configuracion motor DC
GPIO.setup(MOTOR, GPIO.OUT)

# Variables taranquela
estado_taranquela = 21
GPIO.setup( estado_taranquela , GPIO.IN , pull_up_down=GPIO.PUD_DOWN)

def encender_led(numero_led):
    global dec
    combinacion = dec[numero_led]
    print(combinacion)
    GPIO.output(DECODER1, combinacion[2])
    GPIO.output(DECODER2,  combinacion[1])
    GPIO.output(DECODER3,  combinacion[0])


def desactivar_led():
    GPIO.setup(DECODER1, GPIO.IN, pull_up_down=GPIO.PUD_OFF)
    GPIO.setup(DECODER2, GPIO.IN, pull_up_down=GPIO.PUD_OFF)
    GPIO.setup(DECODER3, GPIO.IN, pull_up_down=GPIO.PUD_OFF)


def activar_led():
    GPIO.setup(DECODER1, GPIO.OUT)  # Configuracion tipo salida
    GPIO.setup(DECODER2, GPIO.OUT)  # Configuracion tipo salida
    GPIO.setup(DECODER3, GPIO.OUT)  # Configuracion tipo salida
    
def taranquela():
    global lcd
    pwm.start(colocar_angulo(0))
    time.sleep(1)
    lcd.clear()
    if GPIO.input(estado_taranquela) == GPIO.HIGH:
        pwm.ChangeDutyCycle(colocar_angulo(90))
        time.sleep(1)
        encender_led(6)
        lcd.message("Abriendo:", 1)
        time.sleep(6)
        lcd.clear()
    else:
        pwm.ChangeDutyCycle(colocar_angulo(0))
        time.sleep(1)
        encender_led(7)
        lcd.message("Cerrando:", 1)
        time.sleep(6)
        lcd.clear()

    pwm.stop()



def puerto_motor(estado):
    GPIO.output(MOTOR, estado)

def setup():
      print("Solo una vez")
    
try:
    while True:

        activar_led()
        """
      
      #Desactivar el motor DC
      
      puerto_motor(0)
      time.sleep(1)
      
      #Activacion motor
      puerto_motor(1)
      time.sleep(4)
      
       #Desactivar el motor DC
      puerto_motor(0)
      time.sleep(1)
      
      
      #Iniciar con el angulo 0
      pwm.start(colocar_angulo(0))
      time.sleep(1)
      
      #Colocar el servo a 90 grados
      pwm.ChangeDutyCycle(colocar_angulo(90))
      time.sleep(1)
      
      #Colocar el servo 180 grados
      pwm.ChangeDutyCycle(colocar_angulo(180))
      time.sleep(1)
      
      
      pwm.stop()
      
      numero_led = 0
      #Encender led por seleccion 0
      encender_led(numero_led)
      lcd.message("LED No. : " + str(numero_led))
      
      numero_led = numero_led + 1
      time.sleep(2) 
      
      lcd.clear()
      
      #Encender led por seleccion 1
      encender_led(numero_led)
      lcd.message("LED No. : " + str(numero_led))
      
      numero_led = numero_led + 1
      time.sleep(2) 
      
      lcd.clear()
      
      #Encender led por seleccion 2
      encender_led(numero_led)
      lcd.message("LED No. : " + str(numero_led))
      
      numero_led = numero_led + 1
      time.sleep(2) 
      
      lcd.clear()
      
      #Encender led por seleccion 3
      encender_led(numero_led)
      lcd.message("LED No. : " + str(numero_led))
      
      numero_led = numero_led + 1
      time.sleep(2) 
      
      lcd.clear()
      
      #Encender led por seleccion 4
      encender_led(numero_led)
      lcd.message("LED No. : " + str(numero_led))
      
      numero_led = numero_led + 1
      time.sleep(2) 
      
      lcd.clear()
      
      #Encender led por seleccion 5
      encender_led(numero_led)
      lcd.message("LED No. : " + str(numero_led))
      
      numero_led = numero_led + 1
      time.sleep(2) 
      
      lcd.clear()
      
      #Encender led por seleccion 6
      encender_led(numero_led)
      lcd.message("LED No. : " + str(numero_led))
      
      numero_led = numero_led + 1
      time.sleep(2) 
      
      lcd.clear()
      
      
      #Encender led por seleccion 7
      encender_led(numero_led)
      lcd.message("LED No. : " + str(numero_led))
      
      numero_led = numero_led + 1
      time.sleep(2) 
      
      lcd.clear()
      
      desactivar_led()
      """
        # Iniciar con el angulo 0

        taranquela()

        desactivar_led()

   
except KeyboardInterrupt:
    running=False
    cleanup_gpio()