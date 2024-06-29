After doing the resize, boot it up
Create this file (in raspbian): /etc/udev/rules.d/90-qemu.rules
Put this in the file:
Code: Select all

KERNEL=="sda", SYMLINK+="mmcblk0"
KERNEL=="sda?", SYMLINK+="mmcblk0p%n",

Now reboot qemu, and you should be able to run 'sudo raspi-config' and select the expand fs option to fix everything up.