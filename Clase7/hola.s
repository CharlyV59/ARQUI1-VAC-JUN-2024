@
@ Assembler program to print "Hello World!"
@ to stdout.
@
@ R0-R2 - parameters to linux function services
@ R7 - linux function number
@
.global main @ Provide program starting
.func main

@ address to linker
@ Set up the parameters to print hello world
@ and then call Linux to do it.
main: mov R0, #1 @ 1 = StdOut
 ldr R1, =helloworld @ string to print R1 = obtenerDireccion(helloworld)
 mov R2, #13 @ length of our string
 mov R7, #4 @ linux write system call
 svc 0 @ Call linux to print
@ Set up the parameters to exit the program
@ and then call Linux to do it.
 mov R0, #0 @ Use 0 return code
 mov R7, #1 @ Service command code 1
 @ terminates this program
 svc 0 @ Call linux to terminate
 .data
helloworld: .ascii "Hello World!\n"