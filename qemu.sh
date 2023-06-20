#!/bin/bash

qemu-system-x86_64 -kernel src/archlinux-linux/arch/x86/boot/bzImage -hda debootstrap.img -append "root=/dev/sda console=ttyS0" -serial stdio

