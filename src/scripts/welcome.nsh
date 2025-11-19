#!/usr/bin/env -S echo "This script is for UEFI Shell only:"

@echo -off

for %q in 0 1 2 3 4 5 6 7 8 9 A B C D E F then
    if "FS%q:\edk2\radxa\startup.nsh" == "%0" then
        FS%q:
        cd "%0\..\"
        goto main
    endif
endfor

echo "Failed to locate %0."
goto EOF

:main
echo "************************************************************************"
echo "                       Radxa BIOS Update Console"
echo "************************************************************************"
echo " "
echo "You are now about to update the BIOS for your machine."
echo " "
echo "Updating BIOS incorrectly can cause boot issue."
echo "Radxa recommends to have external SPI flasher at hand for recovery purpose."
echo " "
echo "If you decide to cancel BIOS update, you can run following commands:"
echo "    reset     to reboot the system"
echo "    reset -s  to shutdown the system"
pause

echo "Except the first startup.nsh, following products are currently supported:"
echo " "

ls -b -r -a startup.nsh

echo " "
echo "To update the BIOS, please run '<product name>\startup.nsh' to start."
echo " "
echo "You can now start updating your BIOS."

:EOF
