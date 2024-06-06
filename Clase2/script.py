import RPi.GPIO as GPIO
from time import sleep
import random

GPIO.setmode(GPIO.BOARD)

puerto1 = 7
puerto2 = 11
puerto3 = 12
puerto4 = 13
#Variables
Numero1 = random.randint(0,4)
Numero2  = random.randint(0,4)
Operador = "+"
numerosBinario = [  [0, 0, 0, 0],
			       [0, 0, 0, 1],
			       [0, 0, 1, 0],
			       [0, 0, 1, 1],
			       [0, 1, 0, 0],
			       [0, 1, 0, 1],
			       [0, 1, 1, 0],
			       [0, 1, 1, 1],
			       [1, 0, 0, 0],
			       [1, 0, 0, 1]]


GPIO.setup(puerto1, GPIO.OUT)
GPIO.setup(puerto2, GPIO.OUT)
GPIO.setup(puerto3, GPIO.OUT)
GPIO.setup(puerto4, GPIO.OUT)

def calcular(numero1, numero2, operacion):
    if operacion == "+":
        return numero1 + numero2
    elif operacion == "-":
        return numero1 - numero2
    elif operacion == "*":
        return numero1 * numero2
    elif operacion == "/":
        if numero2 != 0:
            return numero1 / numero2
        else:
            return "Error: Division por cero no permitida"
    else:
        return "Operacion no valida"
	
def conversorDecimalBinario(numero):
      return numerosBinario[numero]
      
def asignacion(binario):
      GPIO.output(puerto1, binario[0])
      GPIO.output(puerto2, binario[1])
      GPIO.output(puerto3, binario[2])
      GPIO.output(puerto4, binario[3])



try:
   while True:
      resultado = calcular(Numero1,Numero2,Operador)
      print(f"El resultado de la {Operador} es: {resultado}")
      
      cadenaBinario = conversorDecimalBinario(resultado)
      asignacion(cadenaBinario)
      sleep(3)
      Numero1 = random.randint(0,4)
      Numero2  = random.randint(0,4)
	
except KeyboardInterrupt:
      GPIO.cleanup()
