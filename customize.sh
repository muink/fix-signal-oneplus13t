#!/system/bin/sh

PRJNAME=$(getprop ro.boot.prjname)

if [ "$PRJNAME" != "24821" ]; then
  ui_print "! This module is for OnePlus 13T CN version only."
  ui_print "! DO NOT install this module on other devices!"
  abort "> Aborting..."
fi
