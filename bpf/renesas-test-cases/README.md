# Renesas test cases

> Dump flash before booting
> Erase flash completely?

## Upstream code

### Freshly booted, timeout 10000

#### Tests: 

- dmesg
- bpftrace
- flashdump

### After timeout

## Adding the erase ROM debugfs command

### Freshly booted with firmware flashed to the ROM through flashrom

Scenario: ROM was erased through debugfs command, then FW was flashed to the ROM directly using flashrom. The code to erase the ROM on module bootstrap was **kept**.

### After timeout

## Increasing timeout

### Freshly booted, timeout 30000

### Module reinit

### Freshly booted, timeout 30000, erase ROM debugfs

Scenario: `RENESAS_RETRY` was increased to 30000 and the debugfs command for ROM erase was added. 

FW download succeeded (slowly due to the step-34 problem). ROM erase was really quick.

```
[Thu Jun 29 18:38:36 2023] xhci_hcd 0000:06:00.0: External ROM exists
[Thu Jun 29 18:38:36 2023] xhci_hcd 0000:06:00.0: Found ROM version: 2026
[Thu Jun 29 18:38:36 2023] xhci_hcd 0000:06:00.0: ROM exists
[Thu Jun 29 18:38:36 2023] xhci_hcd 0000:06:00.0: Unknown ROM status ...
[Thu Jun 29 18:38:36 2023] xhci_hcd 0000:06:00.0: FW is not ready/loaded yet.
[Thu Jun 29 18:38:36 2023] xhci_hcd 0000:06:00.0: External ROM exists
[Thu Jun 29 18:38:36 2023] xhci_hcd 0000:06:00.0: Performing ROM Erase...
[Thu Jun 29 18:38:36 2023] xhci_hcd 0000:06:00.0: ROM Erase... Done success
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: Download ROM success
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: Download to external ROM succeeded
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: ROM load success
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: xHCI Host Controller
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 3
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: Zeroing 64bit base registers, expecting fault
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: hcc params 0x014051cf hci version 0x100 quirks 0x0000001100000410
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: Got SBRN 48
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: MWI active
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: Finished xhci_pci_reinit
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: xHCI Host Controller
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 4
[Thu Jun 29 18:39:04 2023] xhci_hcd 0000:06:00.0: Host supports USB 3.0 SuperSpeed
[Thu Jun 29 18:39:04 2023] usb usb3: SerialNumber: 0000:06:00.0
[Thu Jun 29 18:39:04 2023] usb usb4: SerialNumber: 0000:06:00.0
[Thu Jun 29 18:39:10 2023] xhci_hcd 0000:06:00.0: Userspace requested ROM erase
[Thu Jun 29 18:39:10 2023] xhci_hcd 0000:06:00.0: Performing ROM Erase...
[Thu Jun 29 18:39:10 2023] xhci_hcd 0000:06:00.0: ROM Erase... Done success
```

Flash dump shows that ROM erase is working properly.

```
xxd renesas-dump-after-successful-flash-erased.bin| head
00000000: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000010: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000020: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000030: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000040: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000050: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000060: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000070: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000080: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00000090: ffff ffff ffff ffff ffff ffff ffff ffff  ................
```

## Without the erase ROM function

### Freshly booted

### Freshly booted with firmware flashed to the ROM through flashrom

Scenario: ROM was erased through debugfs command, then FW was flashed to the ROM directly using flashrom. The code to erase the ROM on module bootstrap was **removed**.

Padded the firmware from [here](https://www.startech.com/en-de/cards-adapters/pciusb3s22) with FF at the end, then flashed it:

```sh
head -c 511276 /dev/zero | tr "\000" "\377" >> K2026090-padded.mem
sudo ./flashrom --programmer ch341a_spi -w ~/Dev/kernel-workspace/bpf/renesas-test-cases/K2026090-padded.mem 

flashrom 1.4.0-devel (git:) on Linux 6.3.8-arch1-1-renesas-bpf (x86_64)
flashrom is free software, get the source code at https://flashrom.org

Using clock_gettime for delay loops (clk_id: 1, resolution: 1ns).
Found PUYA flash chip "P25Q40H" (512 kB, SPI) on ch341a_spi.
===
This flash part has status UNTESTED for operations: WP
The test status of this chip may have been updated in the latest development
version of flashrom. If you are running the latest development version,
please email a report to flashrom@flashrom.org if any of the above operations
work correctly for you with this flash chip. Please include the flashrom log
file for all operations you tested (see the man page for details), and mention
which mainboard or programmer you tested in the subject line.
Thanks for your help!
Reading old flash chip contents... done.
Erase/write done from 0 to 7ffff
Verifying flash... VERIFIED.
```

It seems to have loaded just fine! 

```sh
[Thu Jun 29 19:29:49 2023] xhci_hcd 0000:06:00.0: External ROM exists
[Thu Jun 29 19:29:49 2023] xhci_hcd 0000:06:00.0: Found ROM version: 2026
[Thu Jun 29 19:29:49 2023] xhci_hcd 0000:06:00.0: ROM exists
[Thu Jun 29 19:29:49 2023] xhci_hcd 0000:06:00.0: Unknown ROM status ...
[Thu Jun 29 19:29:49 2023] xhci_hcd 0000:06:00.0: FW is not ready/loaded yet.
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: xHCI Host Controller
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 3
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: Zeroing 64bit base registers, expecting fault
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: hcc params 0x014051cf hci version 0x100 quirks 0x0000001100000410
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: Got SBRN 48
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: MWI active
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: Finished xhci_pci_reinit
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: xHCI Host Controller
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 4
[Thu Jun 29 19:29:50 2023] xhci_hcd 0000:06:00.0: Host supports USB 3.0 SuperSpeed
[Thu Jun 29 19:29:50 2023] usb usb3: SerialNumber: 0000:06:00.0
[Thu Jun 29 19:29:50 2023] usb usb4: SerialNumber: 0000:06:00.0
[Thu Jun 29 19:30:38 2023] input: Yubico YubiKey OTP+FIDO+CCID
```

### Module reinit

### After ROM erase
