#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
# 
# Copyright (C) 2020, Arne Wendt
#

img=grub.img
vhd=grub.vhd
block_size=2M
block_count=64

# empty image
dd if=/dev/zero bs=${block_size} count=${block_count} > ${img}

# init
sgdisk -z -g ${img}

# bios
sgdisk -n 1:2048:4095 -c 1:"BIOS Boot" -t 1:ef02 ${img}

# efi part
sgdisk -n 2:4096:+64M -c 2:"EFI" -t 2:ef00 ${img}

# boot data
pstart=$(sgdisk -F ${img} | grep -oP '\d*')
pend=$(sgdisk -E ${img} | grep -oP '\d*')
#sgdisk -n 3:$start:$end -c 3:"Linux /boot" -t 3:8300 ${img}
sgdisk -n 3:$start:$end -c 3:"Linux /boot" -t 3:0700 ${img}

# set bootable
sfdisk -A ${img} 3
# hybrid mbr
sgdisk -h 1:2:3 ${img}

# mount image
loops=$(ls /dev/mapper | grep -oP 'loop\d' | uniq | sort)
kpartx -a ${img}
imgloop=$(comm -23 <(ls /dev/mapper | grep -oP 'loop\d' | uniq | sort) <(echo "$loops"))

# format partitions
mkfs.fat -F 32 /dev/mapper/${imgloop}p2
mkfs.fat -F 32 /dev/mapper/${imgloop}p3

# mount partitions
mntefi="/mnt/gb-efi"
mntdata="/mnt/gb-data"
mkdir "${mntefi}"
mkdir "${mntdata}"
mount /dev/mapper/${imgloop}p2 "${mntefi}"
mount /dev/mapper/${imgloop}p3 "${mntdata}"

# install grub
grub-install --target=x86_64-efi --efi-directory="${mntefi}" --boot-directory="${mntdata}"/boot --removable --recheck --uefi-secure-boot
grub-install --target=i386-pc --recheck --boot-directory="${mntdata}"/boot ${img}

# copy custom files
cp -R disk/* "${mntdata}/"

# free the image
umount "${mntefi}"
rm -rf "${mntefi}"
umount "${mntdata}"
rm -rf "${mntdata}"
kpartx -d /dev/${imgloop}
losetup -D

# make .vdh image
qemu-img convert ${img} -O vpc -o subformat=fixed ${vhd}
qemu-img convert ${img} -O vhdx -o subformat=fixed ${vhd}x
