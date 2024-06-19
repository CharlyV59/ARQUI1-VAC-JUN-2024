# Registros utilizados para llamadas del sistema
Los registros utilizados dependiendo de la arquitectura

|  arch  | syscall NR | return |  arg0  |  arg1  |  arg2  |  arg3  |  arg4  |  arg5  |
|:------|:----------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|
|  arm   |     r7     |   r0   |   r0   |   r1   |   r2   |   r3   |   r4   |   r5   |
| arm64  |     x8     |   x0   |   x0   |   x1   |   x2   |   x3   |   x4   |   x5   |
|  x86   |    eax     |  eax   |  ebx   |  ecx   |  edx   |  esi   |  edi   |  ebp   |
| x86_64 |    rax     |  rax   |  rdi   |  rsi   |  rdx   |  r10   |   r8   |   r9   |

# Lista de los distintas llamadas del sistema 
Lista de las distintas llamadas del sistema ordenadas por numero de codigo y el llamado
| NR | syscall name | references | %x8 | arg0 (%x0) | arg1 (%x1) | arg2 (%x2) | arg3 (%x3) | arg4 (%x4) | arg5 (%x5) | Descripción |
|----|--------------|------------|-----|-------------|-------------|-------------|-------------|-------------|-------------|-------------|
| 0  | io_setup     | man/ cs/ | 0x00 | unsigned nr_reqs | aio_context_t *ctx | - | - | - | - | Configura un contexto de E/S asíncrona (AIO). |
| 1  | io_destroy   | man/ cs/ | 0x01 | aio_context_t ctx | - | - | - | - | - | Destruye un contexto de E/S asíncrona (AIO). |
| 2  | io_submit    | man/ cs/ | 0x02 | aio_context_t | long | struct iocb * * | - | - | - | Envía solicitudes de E/S asíncrona al kernel. |
| 3  | io_cancel    | man/ cs/ | 0x03 | aio_context_t ctx_id | struct iocb *iocb | struct io_event *result | - | - | - | Cancela solicitudes de E/S asíncrona pendientes. |
| 4  | io_getevents | man/ cs/ | 0x04 | aio_context_t ctx_id | long min_nr | long nr | struct io_event *events | struct __kernel_timespec *timeout | - | Obtiene eventos de E/S asíncrona completados. |
| 5  | setxattr     | man/ cs/ | 0x05 | const char *path | const char *name | const void *value | size_t size | int flags | - | Establece atributos extendidos en un archivo o directorio. |
| 6  | lsetxattr    | man/ cs/ | 0x06 | const char *path | const char *name | const void *value | size_t size | int flags | - | Establece atributos extendidos en un enlace simbólico. |
