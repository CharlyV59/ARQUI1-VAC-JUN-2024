.section .data
msg:    .asciz "Resultados:\n"

.section .bss
    .lcomm buffer, 12 // Buffer para almacenar el resultado

.section .text
.global _start

_start:
    // Imprimir mensaje de cabecera
    LDR r0, =1         // File descriptor 1 (stdout)
    LDR r1, =msg       // Dirección del mensaje
    MOV r2, #12        // Longitud del mensaje ("Resultados:\n")
    MOV r7, #4         // sys_write
    SWI 0              // Llamada al sistema

    // Variables
    MOV r4, #10        // Primer operando
    MOV r5, #2         // Segundo operando

    // Suma: r4 + r5
    ADD r6, r4, r5     // r6 = r4 + r5
    BL print_result    // Imprimir resultado

    // Resta: r4 - r5
    SUB r6, r4, r5     // r6 = r4 - r5
    BL print_result    // Imprimir resultado

    // Multiplicación: r4 * r5
    MUL r6, r4, r5     // r6 = r4 * r5
    BL print_result    // Imprimir resultado

    // División: r4 / r5
    MOV r0, r4         // r0 = r4 (dividendo)
    MOV r1, r5         // r1 = r5 (divisor)
    BL divide          // Llamada a la función de división (retorna en r0)
    MOV r6, r0         // r6 = r0 (resultado de la división)
    BL print_result    // Imprimir resultado

    // Terminar el programa
    MOV r0, #0         // Código de salida
    MOV r7, #1         // sys_exit
    SWI 0              // Llamada al sistema

print_result:
    // Convertir entero en r6 a cadena de texto
    LDR r1, =buffer    // Dirección del buffer
    BL int_to_str      // Convertir entero a cadena
    LDR r0, =1         // File descriptor 1 (stdout)
    LDR r1, =buffer    // Dirección del buffer
    MOV r2, #4         // Longitud de la cadena (asumimos longitud máxima de 4 para simplicidad)
    MOV r7, #4         // sys_write
    SWI 0              // Llamada al sistema
    BX lr              // Regresar

// Subrutina para dividir dos enteros
divide:
    CMP r1, #0         // Comparar divisor con 0
    BEQ divide_by_zero // Si divisor es 0, manejar error
    MOV r2, #0         // r2 = cociente
    MOV r3, r0         // r3 = dividendo (valor temporal)
div_loop:
    CMP r3, r1         // Comparar dividendo temporal con divisor
    BLT end_division   // Si el dividendo es menor, terminar
    SUB r3, r3, r1     // r3 -= r1
    ADD r2, r2, #1     // Incrementar cociente
    B div_loop         // Repetir el bucle
end_division:
    MOV r0, r2         // Colocar cociente en r0
    BX lr              // Regresar

divide_by_zero:
    MOV r0, #0         // Si divisor es 0, retornar 0 (evitar división por cero)
    BX lr              // Regresar

// Subrutina para convertir entero a cadena
int_to_str:
    PUSH {r4-r5, lr}   // Guardar registros
    MOV r3, #10        // Base 10
    LDR r1, =buffer+11 // Apuntar al final del buffer
    MOV r2, #0x30      // Offset ASCII para números ('0' = 0x30)
    MOV r4, r6         // Guardar valor original en r4
    MOV r5, #0         // Inicializar longitud del resultado
    CMP r4, #0         // Comparar valor con 0
    BNE not_zero       // Si no es cero, continuar
    MOV r0, #0x30      // Valor ASCII de '0'
    STRB r0, [r1, #-1]!// Guardar '0' en el buffer
    B done_conversion  // Saltar a final
not_zero:
    // Bucle para convertir cada dígito
conv_loop:
    MOV r0, r4         // Copiar valor
    BL divide_by_10    // Dividir por 10 (resto en r1)
    ADD r0, r1, r2     // Convertir dígito en ASCII
    STRB r0, [r1, #-1]!// Guardar en buffer
    ADD r5, r5, #1     // Incrementar longitud
    MOV r4, r0         // Actualizar valor
    CMP r4, #0         // Comparar con 0
    BNE conv_loop      // Repetir si no es 0
done_conversion:
    ADD r1, r1, r5     // Ajustar dirección al comienzo del número
    POP {r4-r5, lr}    // Restaurar registros
    BX lr              // Regresar

// Subrutina para dividir por 10 y retornar el resto
divide_by_10:
    MOV r1, #10        // Divisor
    BL divide          // Llamada a la función de división
    MOV r1, r3         // El resto (dividendo temporal)
    BX lr              // Regresar
