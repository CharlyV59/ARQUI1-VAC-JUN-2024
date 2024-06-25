.section .data
fmt_float_add: .asciz "Resultado suma: %.2f\n"
fmt_float_pot: .asciz "Resultado potencia: %.2f\n"
fmt_float_sqr: .asciz "Resultado raiz cuadrada: %.2f\n"


.section .text
.global _start
_start:
    //Incializar los numeros de registros
    fmov d0, #2.5
    fmov d1, #2.75

    // Suma d0 y d1, y almacena el resultado en d0
    fadd d0, d0, d1

    ldr x0, =fmt_float_add         // Dirección de la cadena de formato
    fmov w1, s0          // Mueve el resultado a w1 (utilizando la parte simple precisión de d0)

    // Llámalo con la ABI de AArch64
    bl printf  

    // Multiplica el resultado por potencia especificada (por ejemplo, 3 veces)
    mov w2, #7            // Número de veces a multiplicar (potencia)
    fmov d0, #2.5        // Carga 2.5 en el registro d0
    fmov d2, d0
    
potencia_loop:
    fmul d0, d0, d2       // Multiplica d2 por d0
    subs w2, w2, #1       // Decrementa contador
    cmp  w2, #1
    bne potencia_loop     // Repite hasta que w2 sea 0

    //Imprimimos la potencia
    ldr x0, =fmt_float_pot     // Dirección de la cadena de formato
    fmov w1, s0            // Mueve el resultado a s0 (parte simple precisión de d2)

    // Llama a printf con la ABI de AArch64
    bl printf

    fmov d0, #4.5

    //Calcular la raiz cuadrada del registro d0
    fsqrt d0, d0

    // Prepara los argumentos para printf
    ldr x0, =fmt_float_sqr     // Dirección de la cadena de formato
    fmov w1, s0           // Mueve el resultado a s0 (parte simple precisión de d2)

    // Llama a printf con la ABI de AArch64
    bl printf


    // Llamada al sistema para salir
    mov x8, #93            // syscall número para exit
    mov x0, #0             // Código de salida 0
    svc #0                 // Llama al sistema para salir

