# Corregir el tamaño de la imagen de rasperry con qemu
Despues de cambiar el tamaño del archivo de qemu dentro de la raspberry realizar lo siguiente

Crear este archivo en raspbian con nano: 
```sh
/etc/udev/rules.d/90-qemu.rules
```
Colocar en el archivo lo siguiente:
```sh
KERNEL=="sda", SYMLINK+="mmcblk0"
KERNEL=="sda?", SYMLINK+="mmcblk0p%n",
```
Reiniciar qemu, ejecutar ahora 'sudo raspi-config' y en opciones avanzadas seleccionar al expansion del sistemas de archivo, esperar a que termine y reiniciar.
