# Update BIOS from RadxaOS

Since 0.3.0-1, `edk2-cix` now integrates with RadxaOS to provide an easy to use
BIOS update entry. This makes updating BIOS easier to operate, while also allow
a given image to ship its own matching BIOS.

## How to start BIOS update?

Restart the system, and choose `Install EDK2` option for your product.

Below is the complete process of upgrading BIOS from 0.2.2-1 to 0.3.0-1:

[![asciicast](https://asciinema.org/a/9uKAUpFuZu2ggUhOXaw4Rf2S2.svg)](https://asciinema.org/a/9uKAUpFuZu2ggUhOXaw4Rf2S2)

## Install a different version of BIOS

Like other system components in RadxaOS, `edk2-cix` are regularly released and
published in Radxa maintained apt archives. Users can use `rsetup` to perform
system update to acquire the latest version of `edk2-cix`.

Installing a new version of `edk2-cix` package will update the bootloader entry
to that specific version. User still needs to explicitly launch it during boot
up to actually have BIOS updated.

If user wants to install a different version of BIOS, they can simply install
the `edk2-cix` package of that version, and perform installation after reboot.

In some cases, the system will be unbootable due to mismatched kernel and BIOS.
This can happen after a system update. The user can either use the bootloader
menu to select an previously installed kernel, or update the matching BIOS for
the latest kernel.

In rare cases, when neither of the above methods are available, user can try to
[manually install the BIOS](./install.md).
