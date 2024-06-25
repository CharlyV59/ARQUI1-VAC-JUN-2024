.section .data
fmt: .asciz "%.2f\n"

.section .text
.global _start

_start: 
    //Inicializamos los registros de punto flotante
    fmov d0, #2.5       //Inicializacion del registros d0 a 2.5
    fmov d1, #2.75      //Inicializacion del registro d1 con 2.75

    // Suma de d0 y d1 y lo almacenamos en d0
    fadd d0,d0,d1       //Realizamos la suma

    //Llamado a la biblioteca estandar de C
    ldr x0, =fmt        //Extraemos la direccion del cartel de resultado
    fmov w1, s0         //Movemos el resultado a w1

    // Llamado a la subrutina printf de la libreria estandar de C
    bl printf

    //Llamada al sistema para salir
    mov x8, 93          //Codigo syscall para salir
    mov x0, 0           //Codigo de salida
    svc #0              //Ejecucion de llamada de sistema


.extern printf






