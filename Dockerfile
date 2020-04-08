FROM ubuntu:eoan

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install grub-common grub-pc-bin grub-efi grub-efi-amd64 grub-efi-amd64-signed shim-signed mtools xorriso gdisk kpartx dosfstools qemu-utils console-common syslinux-common
