```
insmod iso9660
```

#### Ubuntu
##### best match
```
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile --
initrd (loop)/casper/initrd(.lz)
```
###### options
```
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile quiet splash --
initrd (loop)/casper/initrd(.lz)
```

#### Debian
```
linux (loop)/live/vmlinuz-4.9.0-7-amd64 boot=live findiso=$isofile
initrd (loop)/live/initrd.img-4.9.0-7-amd64
```

#### CentOS
##### best match
using vol: $isofile = $isolabel + ".iso"
```
linux (loop)/isolinux/vmlinuz0 iso-scan/filename=$isofile root=live:LABEL=$isolabel rootfstype=auto ro rd.live.image
initrd (loop)/isolinux/initrd0.img
```
using uuid
```
linux (loop)/isolinux/vmlinuz0 iso-scan/filename=$isofile root=live:UUID=$fsuuid rootfstype=auto ro rd.live.image
initrd (loop)/isolinux/initrd0.img
```

##### options
` inst.stage2=hd:/dev/vdb1:${__isopath}`
```
rd.live.overlay=UUID=393B-5FCF rd.live.overlay.overlayfs rd.live.check
```
```
linux (loop)/isolinux/vmlinuz0 boot=isolinux iso-scan/filename=$isofile root=live:LABEL=$isolabel ro rd.live.image quiet rhgb
initrd (loop)/isolinux/initrd0.img
```
```
linux (loop)/isolinux/vmlinuz noeject inst.stage2=hd:/dev/vdb1:$isofile
initrd (loop)/isolinux/initrd.img
```
```
set isolabel="CentOS-7-x86_64-GNOME-1603-02"
set isofile="/boot/iso/CentOS-7-x86_64-LiveGNOME-1603-02.iso"
linux (loop)/isolinux/vmlinuz0 root=live:CDLABEL=CentOS-7-x86_64-GNOME-1603-02 rootfstype=auto ro rd.live.image quiet rhgb rd.luks=0 rd.md=0 rd.dm=0 iso-scan/filename=${isofile} 
initrd (loop)/isolinux/initrd0.img
```
#### Fedora
##### best match
**as centos**
using vol: $isofile = $isolabel + ".iso"
```
linux (loop)/isolinux/vmlinuz iso-scan/filename=$isofile root=live:CDLABEL=$isolabel rd.live.image quiet
initrd (loop)/isolinux/initrd.img
```

#### arch
##### best match
```
linux (loop)/arch/boot/x86_64/vmlinuz img_dev=/dev/disk/by-uuid/$rootuuid img_loop=$isofile earlymodules=loop
initrd (loop)/arch/boot/intel_ucode.img (loop)/arch/boot/amd_ucode.img (loop)/arch/boot/x86_64/archiso.img
```
##### options
```
linux (loop)/arch/boot/x86_64/vmlinuz archisodevice=/dev/loop0 img_dev=/dev/disk/by-uuid/$rootuuid img_loop=$isofile
initrd (loop)/arch/boot/x86_64/archiso.img
```
```
linux (loop)/boot/vmlinuz_x86_64 iso_loop_dev=$imgdevpath iso_loop_path=$isofile
initrd (loop)/boot/initramfs_x86_64.img
```
```
linux (loop)/arch/boot/x86_64/vmlinuz img_dev=${ISOPATH} img_loop=${ISOFILE} earlymodules=loop
initrd (loop)/arch/boot/intel_ucode.img (loop)/arch/boot/x86_64/archiso.img
```
```
linux (loop)/arch/boot/x86_64/vmlinuz img_dev=$imgdevpath img_loop=$isofile earlymodules=loop
initrd (loop)/arch/boot/intel_ucode.img (loop)/arch/boot/amd_ucode.img (loop)/arch/boot/x86_64/archiso.img
```

#### ESXi
```
set isofile="/VMware-VMvisor-Installer-201912001-15160138.x86_64.iso"
loopback loop (hd2,msdos1)$isofile
linux   (loop)/mboot.c32 -c boot.cfg
```

##### options
```
loopback loop (hd0,msdos1)/Fedora-Workstation-Live-x86_64-27-1.6.iso
linux (loop)/isolinux/vmlinuz iso-scan/filename="/Fedora-Workstation-Live-x86_64-27-1.6.iso" root=live:CDLABEL=Fedora-WS-Live-27-1-6 rd.live.image quiet
initrd (loop)/isolinux/initrd.img
```
```
isolabel=Fedora-Live-KDE-x86_64-23_B-1
isofile=Fedora-Live-KDE-x86_64-23_Beta-1.iso
root=(loop)
linux /isolinux/vmlinuz0 iso-scan/filename=$isofile root=live:LABEL=$isolabel ro rd.live.image quiet rhgb
initrd /isolinux/initrd0.img
}
```

#### Alpine
??root=PARTUUID=
```
linux   /boot/$kernel modloop=/boot/$modloop modules=loop,squashfs,sd-mod,usb-storage
initrd  /boot/$initramfs
```
```
linux (loop)/boot/grsec initrd=/boot/grsec.gz iso-scan/filename=/alpine214.iso alpine_dev=usbdisk:vfat modules=loop,cramfs,sd-mod,usb-storage quiet
initrd (loop)/boot/grsec.gz
```
```
root (hd0,6)
kernel /boot/grsec alpine_dev=sdb7:ext2 modules=loop,squashfs,sd-mod,usb-storage,ext2 modloop=/boot/grsec.modloop.squashfs
initrd /boot/grsec.gz
```

#### xen example
```
menuentry 'Debian Installer w/Xen hypervisor' {
  echo  'Loading Xen xen ...'
  if [ "$grub_platform" = "pc" -o "$grub_platform" = "" ]; then
      xen_rm_opts=
  else
      xen_rm_opts="no-real-mode edd=off"
  fi
  set iso=/boot/mini.iso
  loopback loop ${iso}
  multiboot2  /boot/xen.gz placeholder   ${xen_rm_opts}
  echo  'Loading kernel...'
  module2  (loop)/linux nomodeset isoloop=${iso} rescue/enable=true
  echo  'Loading initial ramdisk ...'
  module2 (loop)/initrd.gz
  echo 'Starting xen...'
}
```

### LVM example
```
menuentry "Kali Live ISO - findiso" --class gnu-linux {
  insmod lvm
  insmod ext2
  set root="lvm/Fedora-root"
  search --no-floppy --fs-uuid --set=root --hint=${root} 29e2f518-5fad-49c9-90ef-966b0c033c5e
  set isofile="/ISO/kali-linux-2019.1a-amd64.iso"
  loopback loop $isofile
  linux (loop)/live/vmlinuz boot=live live-media=/dev/mapper/Fedora-root findiso=ISO/kali-linux-2019.1a-amd64.iso noconfig=sudo username=root hostname=kali
  initrd (loop)/live/initrd.img
}
```