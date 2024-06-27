.section .data
input_file:    .asciz "input.txt"    // Nombre del archivo de entrada
mode:          .asciz "r"            // Modo de apertura del archivo (lectura)
buffer:        .space 1000           // Espacio para leer el contenido del archivo
result_msg:    .asciz "Suma total: %d\n"  // Mensaje para mostrar la suma
actual_msg:    .asciz "Actual: %d\n"  // Mensaje para mostrar la suma
next_msg:    .asciz "Siguiente: %d\n"  // Mensaje para mostrar la suma
count_msg:     .asciz "Cantidad de números: %d\n"  // Mensaje para mostrar el conteo
prom_msg:     .asciz "Promedio: %.2f\n" // Mensaje para mostrar el conteo
error_msg:     .asciz "Error al abrir el archivo\n" // Mensaje de error al abrir el archivo

.section .text
.global _start

.extern fopen
.extern fread
.extern fclose
.extern printf


_start:
    //Abrir el archivo
    ldr x0, =input_file  //Colocamos en x0 la direccion nombre del archivo
    ldr x1, =mode        //Aqui colocamos el modo de apertura del archivo
    bl fopen             //Llamamos a la libreria fopen
    cbz x0, file_error   
    mov x19, x0          //Puntero del archivo de que se abrio

    //Leer el archivo
    ldr x0, =buffer      //Pasamos la direccion del buffer
    mov x1, 1            //Tamaño de lectura en este caso un 1 byte
    mov x2, 1000         //Numero de elementos maximos a leer
    mov x3, x19          //Colocamos el apuntado del archivo que queremos leer
    bl fread

    //Cerrar el archivo 
    mov x0, x19          //Coloca el apuntador del archivo a cerrar
    bl fclose

    //Inicializamos vairables
    mov x20, #0          //Registro que llevara la suma de los elementos
    mov x27, #1          //Inicializamos el valor de los numeros encontrados

    //Obtener el buffer
    ldr x1, =buffer      //Obtenemos la direccion del buffer

parse_loop:
    ldrb w2, [x1], #1    //Leemos el actual y dejamos el apuntador de x1 en el siguiente
    cmp w2, #','         //Comparacion con coma
    beq parse_next       //Si es equivalente que analice el siguiente

    cmp w2, #0           // Comparar el fin de cadena
    beq parse_end        // Salir de analizar 

    cbnz w2, parse_number //Analisis del numero

parse_number:
    sub x1, x1, #1
    mov x0, x1
    bl atoi

    //Guardamos x0
    mov x21, x0

    //Guardamos x1
    mov x22, x1

    //Imprimir 
    ldr x0, =actual_msg         // Poner la direccion de result_msg en x0
    mov x1, x21                 // Poner total_sum en x1
    bl printf                   // Llamamos a printf para imprimir el numero actual

    mov x1, x22

    //Sumar el numero
    add x20,x20, x21            //Sumamos el total
    ldr x0, =buffer             //restauramos la direccion del buffer
    mov x1, x22                 //Restauramos la posicion actual

    //Saltamos la coma
    add x1, x1, #1

    //Analizamos el siguiente caracter
    ldrb w2, [x1], #1           //Analisis del siguiente caracter
    cmp w2, #0                  //Comparamos que no sea fin de cadena
    beq parse_end               //Si es fin de cadena que termine

    cmp w2, #','                //Comparamos que se coma
    beq parse_next              //Si es coma que analice el siguiente

    cbnz w2, parse_number       //Si no es 0 el registro que convierta el numero

parse_next:
    //Aumentamos el numero de numeros identificados
    add x27,x27, #1             //Agrega un a contador de numeros
    cbz x1, parse_end           //Comparamos que la direccion del buffer no sea 0
    b parse_loop                //Seguimos analizando

parse_end:
    ldr x0, =result_msg         //Recuperamos el mensaje de resultado
    mov x1, x20                 //Agregamos como parametro el resultado total
    bl printf

    //Contador de numeros encontrados
    ldr x0, =count_msg          //Imprimir el numero de numeros encontrados
    mov x1, x27                 //Colocamos el registro como parametro
    bl printf

    //Ahora realizamos los calculos
    fmov d0, x20                //Colocamos la sumatoria total en registro decimal
    fmov d2, x27                //Colocamos el numero de elementos en registro decimal
    fdiv d0, d0, d2             //Realizamos el promedio diviendo el total dentro de el numero de elementos

    ldr x0, =prom_msg           //Direccion de memoria del rotulo de promedio
    fmov w1, s0                 //Colocamos en s0 que es el resultado de d0 en w1 para imprimirlo
    bl printf                   //Imprimimos el valor decimal

    // Salir del programa
    mov x8, 93                       // syscall: exit
    svc 0                            // Llamada al sistema para salir


file_error:
    ldr x0, =error_msg   //Colocamos en x0 la direccion del mensaje de error
    bl printf            //Imprimimos el mensaje
    b parse_end

// Función atoi (convertir cadena a número)
atoi:
    // Guardar registros de retorno
    stp x29, x30, [sp, #-16]!   // Guardar x29 y x30 en la pila
    mov x29, sp                 // Actualizar el puntero de marco de pila

    // Inicialización
    mov x2, #0                  // resultado = 0

atoi_loop:
    ldrb w3, [x0], #1           // Leer un byte de x0 y postincrementar
    sub w3, w3, #'0'            // Convertir carácter a dígito
    cmp w3, #9                  // Comparar si el dígito está en el rango 0-9
    bhi atoi_end                // Si no está en el rango, terminar
    mov x4, #10
    mul x2, x2, x4              // resultado *= 10
    add x2, x2, x3              // resultado += dígito
    b atoi_loop                 // Repetir el ciclo

atoi_end:
    mov x0, x2                  // Poner el resultado en x0

    // Restaurar registros de retorno
    ldp x29, x30, [sp], #16     // Restaurar x29 y x30 desde la pila
    ret                         // Retornar de la función







