## intended supported targets
Bootloaders/OSs to chainload:
* GRUB/2
* syslinux
* esx-boot
* Windows7/10; Windows Server 2016/2019

### OS heuristics

#### esxi
`/s.v00`

#### Debian generic
`/etc/debian_version`

#### Ubuntu
`/etc/apt/apt.conf.d/01-vendor-ubuntu`

#### Arch
`/etc/arch-release`

#### xcp-ng
`/opt/xensource/`
`etc/centos-release`

#### CentOS
`etc/centos-release`

#### XenServer
`/opt/xensource/`

#### Windows Server
`/Windows/System32/Licenses/neutral/_Default/ServerDatacenter/`
`/Windows/System32/Licenses/neutral/Eval/ServerDatacenterEval/`

#### Windows 10
`/Windows/SystemApps/`
*could detect flavour in `/Windows/System32/Licenses/neutral/_Default/<flavour>/`*

#### Windows 8
`/Windows/ImmersiveControlPanel/`

#### Windows NT + (likely 7)
`/Windows/System32/ntoskrnl.exe`


### Boot candidate heuristics
exists:
* `/boot/grub/`
* `/grub/`
* `/boot/grub2/`
* `/grub2/`
* `/boot/syslinux/`
* `/syslinux/`
* `/loader/`
* `/*vmlinuz*`
* `/*initr*`
* `/Boot/`
* `/Windows/System32/`
* `/Windows/system32/`
* `/windows/System32/`
* `/windows/system32/`


## chainloading
* get disk-number from partition UUID
* swap disk as hd0 `drivemap (hdX) (hd0)`
* try `chainloader (hdX)+1`
* find bootable image file on partition and chainload file

#### lvm os-detection support
try loading a grubenv and get lvm-root from `root=<path>` in `kernelopts`-envvar. grubenv searchpaths:
* `/boot/grub/grubenv`
* `/grub/grubenv`
* `/boot/grub2/grubenv`
* `/grub2/grubenv`
