# fix-signal-oneplus13

Fix signal and bootloop for OnePlus 13 CN on OxygenOS 15.

[Download](https://github.com/K58/fix-signal-oneplus13/releases)

## Tutorial

### How to fix signal

Download and install this module in Magisk (or other root manager).

### How to fix bootloop

1. Finish an OTA System Update, but DO NOT click reboot.

2. Press "Action" button below the module name in Magisk (or other root manager), make sure the patch is succeed.

3. You MUST also Install Magisk (or other root manager) to Inactive slot.
    - For Magisk: Magisk Manager -> Home -> Magisk (Install) -> Install to Inactive Slot (After OTA)

4. Reboot in System Update

----

> [!WARNING]  
> This module will patch `dtbo` partition to fix bootloop.<br>
> DO NOT lock the bootloader with modified dtbo (or other partition) in **any** slot.