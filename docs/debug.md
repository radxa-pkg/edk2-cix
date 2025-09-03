# Debug

## Serial connection

The following UARTs can be used to debug EDK2 on Radxa Orion O6:

* UART1: EC
* UART2: AP
* UART3: Debug
* UART4: PM
* UART5: SE

UART2 is the default management console for EDK2 and the operationg system.

UART3 is only available when EDK2 is build as DEBUG image.

All UARTs use 115200 baud.

````admonish info

If you use version 1.0.0-1 or earlier, EC UART can be viewed with the following command:

```bash
picocom -b 460800 --imap lfcrlf /dev/ttyX
```

````

In general, the log output order after power is connected is as follow:

```
EC ---Power On---> SE ---> AP ---> Debug
```

If you enable `devenv`, then you can run `edk2-console` to launch above 4 UART consoles at once.
Please first create a local `devenv.local.nix` based on `devenv.local.nix.example` to define the local UART devices before using this command.

## Installation

Once build completes, you can find the complete set of artifacts under `debian/edk2-cix/usr/share/edk2/`.

Follow [Installation guide](install.md#create-the-bios-update-disk) to continue.

If you enable `devenv`, then you can run `edk2-install </dev/data_partition>` from the project root as a faster method to copy those files to a prepared USB disk.
