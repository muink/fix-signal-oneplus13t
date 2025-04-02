# fix-signal-oneplus13

Fix signal and bootloop for OnePlus 13 CN on OxygenOS 15.

[Download](https://github.com/K58/fix-signal-oneplus13/releases)

## Tutorial

### How to fix signal

Download and install this module in Magisk (or other root manager).

### How to fix bootloop

Make sure you have this module installed before OTA updates.

1. Finish an OTA system update, but DO NOT click Restart.

2. Press the "Action" button under the module name in Magisk (or other root manager), make sure the patch is successful.

3. You MUST also install Magisk (or other root manager) to inactive slot.
    - For Magisk: Magisk Manager -> Home -> Magisk (Install) -> Install to Inactive Slot (After OTA)

4. Press "Restart" in System Update

> [!WARNING]  
> This module will patch `dtbo` partition to fix bootloop.<br>
> DO NOT lock the bootloader with modified `dtbo` (or any other partition) in **any** slot.

----

## Thanks to

- [@koaaN](https://xdaforums.com/m/koaan.3433581/)

- [@docnok63](https://xdaforums.com/m/docnok63.4967345/)

- [rapperskull](https://github.com/rapperskull)
