#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

# Credit: rapperskull
# License of this file: Apache-2.0 License

LOGFILE="${MODDIR}/post-fs-data.log"
MODFILE="${MODDIR}/nvbk/oplusstanvbk.img"
MODFILEMOUNTED="${MODDIR}/nvbk/mounted"

SLOT="$(resetprop ro.boot.slot_suffix)"
PATH="/dev/block/bootdevice/by-name/oplusstanvbk${SLOT}"

exec > "$LOGFILE"
exec 2>&1

echo "Slot: ${SLOT}"
echo
ls -laZ "$PATH"
echo
if [ -L "$PATH" ]; then
  rm -f "$MODFILEMOUNTED"
  cp "$MODFILE" "$MODFILEMOUNTED"

  ORIG="$(readlink -fn "$PATH")"
  DEV="${ORIG}_mod"

  if [ -e "$MODFILEMOUNTED" ]; then
    # The loop device path must be in the form '/dev/block/sdX...' because mark_boot_successful()
    # will ultimately call gpt_get_header() in gpt-utils and it will try to open the device name
    # truncated to length 'sizeof("/dev/block/sda") - 1'. This means that if the original partition
    # is '/dev/block/sdX00', it will try to open '/dev/block/sdX', so if we just use the next available
    # loop device, it will fail opening '/dev/block/loo'. Using the same prefix as the original
    # partition will solve the issue, but requires a "hack" to work.
    # We first associate our patched file with the next available loop device, then we rename it.
    # I'm not sure if it's still needed, since we don't replace '/dev/block/by-name/oplusstanvbk' anymore.
    LOOP_DEV="$(/system/bin/losetup -sf "$MODFILEMOUNTED")"
    if [ -z "$LOOP_DEV" ]; then
      echo "ERROR: Cannot create loop device"
    else
      mv -f "$LOOP_DEV" "$DEV"
      ret=$?
      if [ $ret -ne 0 ]; then
        echo "ERROR: Cannot rename loop device"
      else
        chcon -v "u:object_r:vendor_custom_ab_block_device:s0" "$DEV" # Set correct SELinux context
        echo "Created loop device ${DEV}"
        ls -laZ "$DEV"
        echo
        # Create symlink to newly created loop device
        ln -sfv "$DEV" "$PATH"
        echo
        ls -laZ "$PATH"
      fi
    fi
  else
    echo "ERROR: ${MODFILEMOUNTED} doesn't exist!!!"
  fi
else
  echo "ERROR: ${PATH} doesn't exist!!!"
fi