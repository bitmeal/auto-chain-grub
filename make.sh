#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
# 
# Copyright (C) 2020, Arne Wendt
#

grub_root="disk/boot/grub"

rm -rf build/
mkdir build

cp -R disk/ build/
cd build


# make clean grubenv
grub-editenv ${grub_root}/grubenv create

# set default options
grub-editenv ${grub_root}/grubenv set __dt=5
grub-editenv ${grub_root}/grubenv set timeout=-1

grub-editenv ${grub_root}/grubenv set __pm=true
grub-editenv ${grub_root}/grubenv set __pg=true
grub-editenv ${grub_root}/grubenv set __pe=true
grub-editenv ${grub_root}/grubenv set __pn=true
grub-editenv ${grub_root}/grubenv set __px=true
grub-editenv ${grub_root}/grubenv set __pl=true

# show grubenv
echo "current grubenv:"
grub-editenv ${grub_root}/grubenv list

# build keymaps
keymaps="de us fr"
for lang in ${keymaps}; do
    echo "making keymap ${lang}"
    grub-kbdcomp -o ${grub_root}/keymaps/${lang}.gkb ${lang}
done

# copy memdisk binary
cp /usr/lib/memdisk ${grub_root}/


# make iso
../make-iso.sh

# make hybrid disk image
../make-image.sh

