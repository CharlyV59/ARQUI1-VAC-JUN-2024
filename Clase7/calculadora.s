.global main /* Permisos para que main pueda ser invocado. */
.func main /* Se define la funcion main como una funcion. */
main: /* Etiqueta principal */
    mov r1, #7 /* Se asigna el r1 el numero 7 */
    mov r2, #4 /* Se asigna el r2 el numero 4 */
    mov r3, #10  /* Se asigna el r4 el numero 15 */
    mov r4, #15  /* Se asigna el r4 el numero 15 */
    /*add r0, r1, r2  Se puede interpretar como r0 = r1 + r2; */

    sub r0, r4,r3 /* Se puede interpretar como r0 = r4 - r3; */
    


    bx lr /*Cerrar el programa */


