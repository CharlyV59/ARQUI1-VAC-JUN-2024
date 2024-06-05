#Este libreria de controlar los GPIO
import RPi.GPIO as GPIO
#Libreria que se encarga de realizar pausa 
from time import sleep

#Colocar modo de los pines
GPIO.setmode(GPIO.BOARD)

#Seleccionamos en numero de puerto
LED1 = 35

#Seleccionar salida
GPIO.setup(LED1, GPIO.OUT)

#Configuracion Serial

try:
   while True:
      print("Encendido")
      GPIO.output(LED1, GPIO.HIGH)
      sleep(3)
      GPIO.output(LED1, GPIO.LOW)
      print("Apagado")
      sleep(3)
      
	
except KeyboardInterrupt:
      GPIO.cleanup()