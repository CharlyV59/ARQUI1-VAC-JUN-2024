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
7.1 Cambiar tamaño en windows crear un archivo resize.bat e ingresar el comando (cambiar nombre de imagen):
```bat
"C:\Program Files\qemu\qemu-img.exe" resize -f raw raspios.img 4G
```
8. Ejecutar el archivo .sh
./script.sh
9. Esperar a que termine todo el proceso y hacer las configuraciones pertinentes.

## Alternativo con docker
1) Instalar docker ubuntu [Pasos](https://docs.docker.com/engine/install/ubuntu/)  
2) Copiar el siguiente script en una carpeta de linux con el nombre de Dockerfile
```Dockerfile
FROM ubuntu:20.04@sha256:ca5534a51dd04bbcebe9b23ba05f389466cf0c190f1f8f182d7eea92a9671d00

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get install -y qemu-system-aarch64 fdisk wget mtools xz-utils

WORKDIR /qemu

# Download the image
RUN wget https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2024-03-15/2024-03-15-raspios-bookworm-arm64-lite.img.xz
ENV IMAGE_FILE=2024-03-15-raspios-bookworm-arm64-lite.img

# Uncompress the image
RUN xz -d ${IMAGE_FILE}.xz

# Resize the image to next power of two
RUN CURRENT_SIZE=$(stat -c%s "${IMAGE_FILE}") && \
    NEXT_POWER_OF_TWO=$(python3 -c "import math; \
                                    print(2**(math.ceil(math.log(${CURRENT_SIZE}, 2))))") && \
    qemu-img resize "${IMAGE_FILE}" "${NEXT_POWER_OF_TWO}"

# Extract files from the image
# First, find the offset and size of the FAT32 partition
RUN OFFSET=$(fdisk -lu ${IMAGE_FILE} | awk '/^Sector size/ {sector_size=$4} /FAT32 \(LBA\)/ {print $2 * sector_size}') && \
    # Check that the offset is not empty
    if [ -z "$OFFSET" ]; then \
        echo "Error: FAT32 not found in disk image" && \
        exit 1; \
    fi && \
    # Setup mtools config to extract files from the partition
    echo "drive x: file=\"${IMAGE_FILE}\" offset=${OFFSET}" > ~/.mtoolsrc

# Copy out the kernel and device tree
RUN mcopy x:/bcm2710-rpi-3-b-plus.dtb . && \
    mcopy x:/kernel8.img .

# Set up SSH
# RPI changed default password policy, there is no longer default password
RUN mkdir -p /tmp && \
    # First create ssh file to enable ssh
    touch /tmp/ssh && \
    # Then create userconf file to set default password (raspberry)
    echo 'pi:$6$rBoByrWRKMY1EHFy$ho.LISnfm83CLBWBE/yqJ6Lq1TinRlxw/ImMTPcvvMuUfhQYcMmFnpFXUPowjy2br1NA0IACwF9JKugSNuHoe0' | tee /tmp/userconf

# Copy the files onto the image
RUN mcopy /tmp/ssh x:/ && \
    mcopy /tmp/userconf x:/

EXPOSE 2222

# Start qemu with SSH port forwarding
ENTRYPOINT qemu-system-aarch64 -machine raspi3b -cpu cortex-a53 -dtb bcm2710-rpi-3-b-plus.dtb -m 1G -smp 4 -kernel kernel8.img -sd ${IMAGE_FILE} -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22

```
3) Abrir una consola en la ubicacion del archivo y ejecutar el siguiente comando:
```sh
sudo docker build -t raspberry .
```
4) Ejecutar el siguiente comando para ejecutar el contenedor
```sh
sudo docker run -d -p 2222:22 --name qemu-raspberry raspberry
```
5) Verificar la ip del contenedor que esta corriendo mediante el siguiente comando
```sh
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <nombre_o_ID_del_contenedor_las_letras>
```
6) Conectarse con cualquier programa de ssh para acceder a la raspberry con los valores por defecto:
```sh
user: pi
password: raspberry
puerto: 2222
ip: la del paso anterior
```

