# Descripción
Repositorio sobre el laboratorio de arquitectura de computadores y ensambladores 1 vacaciones de junio 2024.

# Instalar emulador de raspberry pi armv8 en windows con MSY2S

1. Instalar MSY2S la mas reciente (msys2-x86_64-20240507.exe)
Link: [MSY2S](https://repo.msys2.org/distrib/x86_64/) 
2. Instalar qemu dentro de MSYS2 (Ejecutando el programa llamado: MSYS2 MINGW64)
```sh
pacman -S mingw-w64-x86_64-qemu
```
3. Dirigirse donde instalaron msy2 generalmente en:
```
C:\msys64\
```
4. Crear una carpeta ahi adentro llamada raspberry, aqui ingresan todos los archivos necesarios para que funcione
  - **4.1 Kernel:** [Kernel](https://farabimahmud.github.io/emulate-raspberry-pi3-in-qemu/kernel8.img)
  - **4.2 BCM:** [BCM2710](https://farabimahmud.github.io/emulate-raspberry-pi3-in-qemu/bcm2710-rpi-3-b-plus.dtb)
  - **4.3 Imagen del sistema operativo:** raspberry pi os lite de 64 bits, extraer imagen con winrar. [Raspbian](https://www.raspberrypi.com/software/operating-systems/) 
  - **4.4 script.sh** para que funcione (cambiar nombre a la imagen descargada de raspberry con raspios para que funcione)
```sh
#!/bin/bash

qemu-system-aarch64 \
  -M raspi3b \
  -cpu cortex-a53 \
  -m 1G -smp 4 \
  -kernel kernel8.img \
  -sd raspios.img  \
  -dtb bcm2710-rpi-3-b-plus.dtb \
  -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200
  dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
  -serial stdio \
  -usb -device usb-mouse -device usb-kbd \
  -device usb-net,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::5555-:22


```
4.1.1 Script alternativo windows
```bat
"C:\Program Files\qemu\qemu-system-aarch64.exe" ^
 -M raspi3b ^
  -cpu cortex-a53 ^
  -m 1G -smp 4 ^
  -kernel kernel8.img ^
  -drive file=raspios.img,format=raw,if=sd,index=0 ^
  -dtb bcm2710-rpi-3-b-plus.dtb ^
  -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" ^
  -serial stdio ^
  -usb -device usb-mouse -device usb-kbd ^
  -device usb-net,netdev=net0 ^
  -netdev user,id=net0,hostfwd=tcp::5555-:22
echo QEMU is finished
pause

```

5. Ya dentro de MSY2S ejecutar:
```sh
cd /raspberry/
```
6. Colocarle permisos de ejecucion
```sh
chmod +x script.sh
```
7. Cambiarle tamaño a la imagen 4G
```sh
qemu-img resize -f raw raspios.img 4G
```
8. Ejecutar el archivo .sh
./script.sh
9. Esperar a que termine todo el proceso y hacer las configuraciones pertinentes.
