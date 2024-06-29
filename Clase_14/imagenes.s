    .section .data
header:
    .ascii "P1\n1920 1080\n"  // Encabezado PBM para imagen 1920x1080

// Línea de espacio vacío
line_empty:
    .rept 1919                // Repite la instrucción siguiente 1919 veces
    .ascii "0 "               // Cada repetición escribe "0 " (píxel vacío)
    .endr
    .ascii "0\n"              // Termina la línea con "0\n"

    .section .text
    .global _start

_start:
    // Escribir el encabezado PBM
    ldr x0, =1                  // Descriptor de archivo (stdout)
    ldr x1, =header             // Puntero al encabezado PBM en memoria
    mov x2, #16                 // Longitud del encabezado
    mov x8, #64                 // Syscall número 64 (write)
    svc #0                      // Llamada al sistema para escribir

    // Inicializar variables
    mov x20, #1080              // Número total de líneas a escribir
    mov x21, #0                 // Línea actual (inicio en 0)

write_lines:
    subs x20, x20, #1           // Decrementar el contador de líneas
    b.lt exit                   // Salir si el contador es menor que 0

    // Preparar la línea de píxeles
    ldr x1, =line_empty         // Usar línea vacía como base
    mov x2, #0                  // Inicializar contador de píxeles
    mov x4, x21                 // Línea actual para las diagonales

generate_pattern:
    cmp x2, #1920               // Comparar con el ancho de la imagen (1920)
    b.ge write_line             // Escribir la línea si se alcanza el final

    // Calcular posiciones para líneas diagonales
    add x3, x21, x2             // Calcular x + y (primera diagonal)
    sub x5, x21, x2             // Calcular x - y (segunda diagonal)

    // Generar grosor en la primera diagonal
    cmp x3, #1920               // Comparar con el ancho de la imagen
    b.ge skip_diagonal1         // Saltar si está fuera de los límites
    add x6, x3, #0              // Inicializar inicio del grosor
    add x7, x3, #5              // Final del grosor (5 píxeles)
generate_diagonal1:
    cmp x6, #1920               // Comparar el inicio del grosor con el ancho
    b.ge skip_diagonal1         // Saltar si el grosor está fuera de los límites
    strb w1, [x1, x6]           // Escribir "1" para hacer el píxel visible
    add x6, x6, #1              // Avanzar el grosor
    b generate_diagonal1        // Repetir para el siguiente píxel de grosor

skip_diagonal1:

    // Generar grosor en la segunda diagonal
    cmp x5, #0                  // Comparar con el inicio de la imagen
    b.lt skip_diagonal2         // Saltar si está fuera de los límites
    add x6, x5, #0              // Inicializar inicio del grosor
    add x7, x5, #5              // Final del grosor (5 píxeles)
generate_diagonal2:
    cmp x6, #1920               // Comparar el inicio del grosor con el ancho
    b.ge skip_diagonal2         // Saltar si el grosor está fuera de los límites
    strb w1, [x1, x6]           // Escribir "1" para hacer el píxel visible
    add x6, x6, #1              // Avanzar el grosor
    b generate_diagonal2        // Repetir para el siguiente píxel de grosor

skip_diagonal2:
    add x2, x2, #1              // Avanzar al siguiente píxel horizontal
    b generate_pattern          // Repetir para el siguiente píxel

write_line:
    ldr x0, =1                  // Descriptor de archivo (stdout)
    mov x2, #3841               // Longitud de la línea en bytes (1920 * 2 + 1)
    mov x8, #64                 // Syscall número 64 (write)
    svc #0                      // Llamada al sistema para escribir la línea

    add x21, x21, #1            // Incrementar el contador de líneas actuales
    b write_lines               // Volver a escribir la siguiente línea

exit:
    // Salir del programa
    mov x8, #93                 // Syscall número 93 (exit)
    mov x0, #0                  // Estado de salida 0
    svc #0                      // Llamada al sistema para salir
