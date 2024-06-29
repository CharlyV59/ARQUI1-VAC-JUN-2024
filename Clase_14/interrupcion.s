.section .text      // Define la seccion de codigo ejecutable
.global _start      // Declara la etiqueta _start para iniciar

_start:
    ldr x0, =0xDEADBFFF     //Carga una direccion de memoria no valida en registro x0
    ldr x1, [x0]            //Intenta leer la direccion no valida y provoca una interrupcion asincrona

    b _start

.section .sync_handler, "ax" //Definir la seccion de codigo para manejar la interrupcion
.global sync_handler

sync_handler:
    //Colocan el codigo para recuperse de la interrupcion
    eret
