#!/bin/bash

# Verifica si se ha pasado un nombre de archivo
if [ -z "$1" ]; then
    echo "Uso: $0 <nombre_salida>"
    exit 1
fi

# Nombre del archivo de salida
NOMBRE_SALIDA=$1

# Ensamblar
as -o ${NOMBRE_SALIDA}.o ${NOMBRE_SALIDA}.s 
if [ $? -ne 0 ]; then
    echo "Error al ensamblar ${NOMBRE_SALIDA}.s"
    exit 1
fi

# Enlazar
gcc -o ${NOMBRE_SALIDA} ${NOMBRE_SALIDA}.o -nostartfiles -lc -lgcc_s -L /usr/lib/aarch64-linux-gnu -L /lib/aarch64-linux-gnu
if [ $? -ne 0 ]; then
    echo "Error al enlazar ${NOMBRE_SALIDA}.o"
    exit 1
fi

echo "Compilación y enlace completados: ${NOMBRE_SALIDA}"
