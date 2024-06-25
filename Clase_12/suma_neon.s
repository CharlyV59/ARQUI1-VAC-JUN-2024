.global _start
.section .data
num1: .word 15 //Primer numero
num2:  .word 30 //Segundo numero
fmt: .asciz "Resultado %d\n"

.section .bss
.comm result, 4  //Espacio para el resultado

.section .text
_start:
    //carga de numeros
    ldr x0, =num1
    ldr w1, [x0]
    ldr x0, =num2
    ldr w2, [x0]

    // Configuracion de Neon
    dup v0.4s, w1   // Duplicar num1 en todos los elementos de v0.4s
    dup v1.4s, w2   // Duplicar num2 en todos los elementos de v1.4s

    //Sumamos los datos
    add v2.4s, v0.4s, v1.4s

    //Movemos los resultados de neon a un registro general
    mov w0, v2.s[0]

    // Guardar el resultado en la memoria
    ldr x1, =result
    str w0, [x1]

    // Preparar la llamada al sistema para imprimir el resultado
    ldr x0, =fmt       // Dirección de la cadena de formato
    ldr w1, [x1]       // Cargar el resultado en w1
    bl printf          // Llamar a printf

    // Salir del programa
    mov x8, #93        // syscall number for exit
    mov x0, #0         // Exit code
    svc #0             // Hacer syscall

// Incluir printf para la impresión
.extern printf


