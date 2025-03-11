#!/system/bin/sh

MODDIR=${0%/*}

FILE="$MODDIR/dtbo.img"
PART="/dev/block/bootdevice/by-name/dtbo"

sleep_pause() {
    # APatch and KernelSU needs this
    # but not KSU_NEXT, MMRL
    if [ -z "$MMRL" ] && [ -z "$KSU_NEXT" ] && { [ "$KSU" = "true" ] || [ "$APATCH" = "true" ]; }; then
        sleep 6
    fi
}

# Get the active slot suffix (e.g., _a or _b)
ACT=$(getprop ro.boot.slot_suffix)

# Determine the non-active slot suffix
if [ "$ACT" = "_a" ]; then
    NONACT="_b"
else
    NONACT="_a"
fi

# Ensure the dtbo partition is read-only (blockdev --getro should return 1)
RO=$(blockdev --getro "${PART}${NONACT}")
if [ "$RO" -ne 1 ]; then
    echo "!!! Error: No pending OTA reboot."
    echo "!!! Please finish the OTA System Update"
    echo "!!! first (DO NOT click reboot)."
    echo "!!! Note: Fix is not needed for SOTA update."
    echo "> Aborting."
    sleep_pause
    exit 1
fi

echo "[+] Patching dtbo in Inactive Slot (${NONACT})..."
echo "[!] WARNING: This module will patch dtbo partition to fix bootloop."
echo "[!] DO NOT lock the bootloader with modified dtbo."

# Dump the dtbo from the non-active slot into the temporary file
dd if="${PART}${NONACT}" of="$FILE" bs=1M
if [ $? -ne 0 ]; then
    echo "!!! Error: Failed to dump dtbo from ${PART}${NONACT}."
    sleep_pause
    exit 1
fi

# Patch the image using sed
sed -i 's/hmbird/xxbird/g' "$FILE"
if [ $? -ne 0 ]; then
    echo "!!! Error: sed failed to patch the dtbo image."
    rm -f "$FILE"
    sleep_pause
    exit 1
fi

# Set the partition to read-write
blockdev --setrw "${PART}${NONACT}"
if [ $? -ne 0 ]; then
    echo "!!! Error: Failed to set ${PART}${NONACT} to read-write."
    rm -f "$FILE"
    sleep_pause
    exit 1
fi

# Flash the patched dtbo file back to the non-active slot
dd if="$FILE" of="${PART}${NONACT}" bs=1M
if [ $? -ne 0 ]; then
    echo "!!! Error: Failed to write patched dtbo to ${PART}${NONACT}."
    rm -f "$FILE"
    sleep_pause
    exit 1
fi

# Set the partition back to read-only
blockdev --setro "${PART}${NONACT}"
if [ $? -ne 0 ]; then
    echo "!!! Error: Failed to set ${PART}${NONACT} back to read-only."
    rm -f "$FILE"
    sleep_pause
    exit 1
fi

# Clean up the temporary file
rm -f "$FILE"

echo "[+] Successfully modified dtbo in inactive slot."
echo "******************************************************"
echo "[!] You MUST install your root manager (e.g. Magisk)"
echo "[!] to Inactive Slot before rebooting."
echo "******************************************************"
echo "> Done!"
sleep_pause