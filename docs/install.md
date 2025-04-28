# Manually install released binary

## Full demo

Below is the full process of upgrading an 0.1.0 debug build to 0.1.1-1 release build.

Ventoy were used and HDMI display were connected. The actual process happened over serial.

[![asciicast](https://asciinema.org/a/O7YsPjUyLIa2174oFgPPdGKyt.svg)](https://asciinema.org/a/O7YsPjUyLIa2174oFgPPdGKyt)

---

## Where to find releases?

You can find all released Debian packages under GitHub [Release](https://github.com/radxa-pkg/edk2-cix/releases) page.

Similar to our other firmware packages, each release contains both the binary package as well as the metapackages.

Taking release [0.1.1-1](https://github.com/radxa-pkg/edk2-cix/releases/tag/0.1.1-1) as an example, you can see 2 packages:

| Name | Size| Type |
| ---- | ---- | ---- |
| edk2-cix_0.1.1-1_all.deb | 4.79 MB | Binary package |
| edk2-orion-o6_0.1.1-1_all.deb | 2.09 KB | Metapackage |

As usual, the binary package is the one with a large size, and the metapackage is usually only a few KB.

Also, the binary package will usually share the name with the code repository, while metapackages will usually named after a specific product.

## Download and extrace the release

To prepare a BIOS update disk, first, download and extract the package:

```bash
mkdir extract
cd extract
wget https://github.com/radxa-pkg/edk2-cix/releases/download/0.1.1-1/edk2-cix_0.1.1-1_all.deb
ar vx *.deb
tar xvf data.tar.xz
```

## Create the BIOS update disk

You should now have BIOS for all supported platforms, as well as some supporting files

```bash
$ find usr/share/edk2/
usr/share/edk2/
usr/share/edk2/cix
usr/share/edk2/cix/merak
usr/share/edk2/cix/merak/BuildOptions
usr/share/edk2/cix/merak/BurnImage.efi
usr/share/edk2/cix/merak/FlashUpdate.efi
usr/share/edk2/cix/merak/Shell.efi
usr/share/edk2/cix/merak/VariableInfo.efi
usr/share/edk2/cix/merak/cix_flash.bin
usr/share/edk2/cix/merak/startup.nsh
usr/share/edk2/radxa
usr/share/edk2/radxa/orion-o6
usr/share/edk2/radxa/orion-o6/BuildOptions
usr/share/edk2/radxa/orion-o6/BurnImage.efi
usr/share/edk2/radxa/orion-o6/FlashUpdate.efi
usr/share/edk2/radxa/orion-o6/Shell.efi
usr/share/edk2/radxa/orion-o6/VariableInfo.efi
usr/share/edk2/radxa/orion-o6/cix_flash.bin
usr/share/edk2/radxa/orion-o6/startup.nsh
```

Copy them to a USB disk formatted in FAT file system, and connect them to the target board.

Optionally, you can use `Ventoy` to create a BIOS update disk that can also be used to load Linux ISOs, as long as the size is under 4 GiB (due to FAT32 limitation).

[`Ventoy`](https://www.ventoy.net/) is a popular ISO multi-boot tool. It also supports booting EFI applications and ARM64 architecture.

First, use `Ventoy` to create a bootable USB disk. Make sure you select GPT partition table in the option.

You will then reformat the first partition with FAT file system, as the default file system exFAT is not supported by EDK2.

You can copy the EDK2 build artifacts to the first partition as usual. 

## Enter UEFI Shell

You will need to enter UEFI Shell to run the script to update the BIOS. There are 2 ways to achieve that:

### Via UEFI Setup

Press `Escape` key when prompted on the console. Then enter `Boot Manager` menu and select `UEFI Shell`.

### Via `Ventoy`

When you boot the system and missed the `Escape` prmopt, if there is no other bootable media, EDK2 should boot into `Ventoy`.

```admonish caution
If screen is connected, Ventoy will boot into graphical mode. Under this mode you will have no output on UART2, but you can still control the menu with it.

You can enable [`Force Text Mode`](https://github.com/ventoy/Ventoy/issues/2983#issuecomment-2367411817) under the display menu to allow output on UART2.
```

Inside `Ventoy` UI you should have `Shell.efi` listed as an option if you copied everything. Run it to enter UEFI Shell.

```admonish caution
If you built for multiple EDK2 variants you may have multiple `Shell.efi` listed in `Ventoy`. They are generally compatible with different platforms, but when in doubt, only use the one come with your target platform, and only copy the EDK2 variant for your platform.
```

## Update BIOS from UEFI Shell

Once inside the UEFI Shell, you should first be greeted by a list of available storage devices and their physical paths.

If you only have the USB disk connected, it should be listed as `fs0`.

You can rescan the storage device with `map -r` command, which will reprint the available devices as well.

You can run BIOS flash script from UEFI Shell now. It uses Windows convention, so an example command would be:

```cmd
fs0:\radxa\orion-o6\startup.nsh
```

The first backslash is not mandatory:

```cmd
fs0:radxa\orion-o6\startup.nsh
```

There is limited auto completion in the UEFI Shell when pressing `Tab` key.

Running this command will flash your BIOS. Follow its prompt to complete the process.
