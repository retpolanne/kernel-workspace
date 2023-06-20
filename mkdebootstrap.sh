#!/bin/bash

qemu-img create debootstrap.img 1g
mkfs.ext2 debootstrap.img
mkdir tmp-mount
sudo mount -o loop debootstrap.img tmp-mount
sudo debootstrap --arch amd64 buster tmp-mount
sudo umount tmp-mount
rmdir tmp-mount
