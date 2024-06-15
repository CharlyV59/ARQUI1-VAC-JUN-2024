        .section .bss
        .lcomm base, 4        // Reserva 4 bytes para almacenar el número base
        .lcomm exponent, 4    // Reserva 4 bytes para almacenar el exponente
        .lcomm result_value, 4// Reserva 4 bytes para almacenar el resultado de la potencia
        .lcomm input_buffer, 12 // Reserva 12 bytes para el buffer de entrada

        .section .text
        .global main        // Marca _start como símbolo global, punto de entrada del programa
.func main
main:
        // Imprimir prompt1
        ldr r0, =prompt1      // Carga la dirección de prompt1 en el registro r0
        bl print_string       // Llama a la función print_string para imprimir la cadena en r0

        // Leer el número base
        bl read_int           // Llama a la función read_int para leer un entero de la entrada estándar
        ldr r1, =base         // Carga la dirección de base en r1
        str r0, [r1]          // Almacena el entero leído (en r0) en la dirección de base

        // Imprimir prompt2
        ldr r0, =prompt2      // Carga la dirección de prompt2 en el registro r0
        bl print_string       // Llama a la función print_string para imprimir la cadena en r0

        // Leer el exponente
        bl read_int           // Llama a la función read_int para leer otro entero de la entrada estándar
        ldr r1, =exponent     // Carga la dirección de exponent en r1
        str r0, [r1]          // Almacena el entero leído (en r0) en la dirección de exponent

        // Calcular la potencia
        ldr r1, =base         // Carga la dirección de base en r1
        ldr r1, [r1]          // Carga el valor de base en r1
        ldr r2, =exponent     // Carga la dirección de exponent en r2
        ldr r2, [r2]          // Carga el valor de exponent en r2
        bl power              // Llama a la función power para calcular la potencia
        ldr r1, =result_value // Carga la dirección de result_value en r1
        str r0, [r1]          // Almacena el resultado de la potencia (en r0) en result_value

        // Imprimir resultado
        ldr r0, =result       // Carga la dirección de result en el registro r0
        ldr r1, =result_value // Carga la dirección de result_value en r1
        ldr r1, [r1]          // Carga el valor de result_value en r1
        bl printf             // Llama a printf para imprimir la cadena de resultado con el valor en r1

        // Salir
        mov r7, #1            // Carga 1 en r7 para el syscall de exit
        svc #0                // Genera la llamada al sistema para salir

// Función para leer un número entero de la entrada estándar
read_int:
        // Syscall para leer (sys_read)
        mov r7, #3            // Carga 3 en r7 para el syscall de read
        mov r0, #0            // Carga 0 en r0 para leer desde la entrada estándar (stdin)
        ldr r1, =input_buffer // Carga la dirección de input_buffer en r1
        mov r2, #12           // Carga 12 en r2 para leer hasta 12 bytes
        svc #0                // Genera la llamada al sistema para leer
        ldr r0, =input_buffer // Carga la dirección de input_buffer en r0
        bl atoi               // Convierte la cadena en r0 a un entero en r0
        bx lr                 // Retorna al llamador

// Función para imprimir una cadena
print_string:
        // Syscall para escribir (sys_write)
        mov r7, #4            // Carga 4 en r7 para el syscall de write
        mov r1, r0            // Mueve el contenido de r0 a r1 (dirección de la cadena)
        bl string_length      // Llama a string_length para obtener la longitud de la cadena en r2
        mov r0, #1            // Carga 1 en r0 para escribir en la salida estándar (stdout)
        svc #0                // Genera la llamada al sistema para escribir
        bx lr                 // Retorna al llamador

// Función para calcular la potencia (base ^ exponente)
power:
        mov r0, #1            // Inicializa r0 con 1 (resultado inicial)
power_loop:
        cmp r2, #0            // Compara el exponente (r2) con 0
        beq power_end         // Si el exponente es 0, salta al final
        mov r3, r0            // Copia r0 a r3 para usar r3 en la multiplicación
        mul r0, r3, r1        // Multiplica r3 (resultado anterior) por r1 (base), y guarda el resultado en r0
        sub r2, r2, #1        // Decrementa el exponente (r2) en 1
        b power_loop          // Salta al inicio del bucle para repetir
power_end:
        bx lr                 // Retorna al llamador

// Función para calcular la longitud de una cadena
string_length:
        mov r2, #0            // Inicializa r2 con 0 (contador de longitud)
length_loop:
        ldrb r3, [r1, r2]     // Carga un byte de la cadena en r3
        cmp r3, #0            // Compara el byte con 0 (fin de la cadena)
        beq length_end        // Si es 0, salta al final
        add r2, r2, #1        // Incrementa r2 (contador)
        b length_loop         // Repite el bucle
length_end:
        bx lr                 // Retorna al llamador, r2 tiene la longitud de la cadena

// Función para convertir una cadena a entero
atoi:
        mov r1, r0            // Guarda la dirección de la cadena en r1
        mov r0, #0            // Inicializa r0 con 0 (resultado)
        mov r2, #10           // Inicializa r2 con 10 (base decimal)
atoi_loop:
        ldrb r3, [r1], #1     // Carga el siguiente byte de la cadena en r3 y avanza r1
        cmp r3, #0            // Compara el byte con 0 (fin de la cadena)
        beq atoi_end          // Si es 0, salta al final
        sub r3, r3, #48       // Convierte el carácter de '0'-'9' a valor numérico
        mul r0, r0, r2        // Multiplica el resultado actual por 10
        add r0, r0, r3        // Añade el valor del carácter
        b atoi_loop           // Repite el bucle
atoi_end:
        bx lr                 // Retorna al llamador, r0 tiene el entero convertido
        .section .data
prompt1: .asciz "Ingrese el numero base: " // Cadena que solicita al usuario ingresar el número base
prompt2: .asciz "Ingrese el exponente: "   // Cadena que solicita al usuario ingresar el exponente
result:  .asciz "El resultado es: %d\n"    // Cadena para mostrar el resultado formateado