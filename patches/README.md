# Tracking Patches

## xhci-pci-renesas

[Renesas USB 3.0 Controllers vs. Linux](https://mjott.de/blog/881-renesas-usb-3-0-controllers-vs-linux/)
[usb: host: xhci: parameterize Renesas delay/retry](https://patchwork.kernel.org/project/linux-usb/patch/20230618224656.2476-2-retpolanne@posteo.net/)
[uPD720201/uPD720202 User's Manual: Hardware](http://www.phasure.com/index.php?action=dlattach;topic=2784.0;attach=3281)

### Debug

TODO - write the patch to add this `debugfs_erase_rom` - don't forget to add the cleanup on exit
[usb: xhci: provide a debugfs hook for erasing rom](https://yhbt.net/lore/all/20200323170601.419809-6-vkoul@kernel.org/)

Also, add to the xhci-pci-renesas.c header:

```c
#define DEBUG 1
```

### Commands

Make only the usb host modules

```sh
make M=drivers/usb/host/
```

Removing the device and rescanning

```sh
echo 1 > /sys/devices/pci0000\:00/0000:00:01.2/0000:02:00.2/0000:03:08.0/0000:06:00.0/remove
echo 1 > /sys/devices/pci0000\:00/pci_bus/0000\:00/rescan
```
