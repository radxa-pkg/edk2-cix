#!/usr/bin/env -S echo "This script is for UEFI Shell only:"

@echo -off

set product .

echo "************************************************************************"
echo "                       Radxa BIOS Update Utility"
echo "************************************************************************"
echo " "
echo "You are about to update the BIOS%product%"
echo "Please make sure the power stays on during the operation."
echo " "
echo "We strongly recommend to perform this operation locally, as the updated"
echo "system should be power cycled to ensure new code to be loaded."
echo "If you are performing this operation remotely, please make sure you have"
echo "means to also power cycle the system in case of issue."
echo " "
echo "If you decide to cancel BIOS update, you can run following commands:"
echo "    reset     to reboot the system"
echo "    reset -s  to shutdown the system"
echo " "
pause

echo "************************************************************************"
echo "                            Updating BIOS..."
echo "************************************************************************"
echo " "

"%0\..\FlashUpdate.efi" -f "%0\..\cix_flash_all.bin" -n

echo " "
echo "************************************************************************"
echo "                         BIOS Update completed!"
echo "************************************************************************"
echo "System will now power off."
echo "You MUST fully remove all connected power source before connecting them."
echo "Failure to do so may prevent some components to use the updated code."
echo " "
pause

reset -s "BIOS Update"

:EOF
