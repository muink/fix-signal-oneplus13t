#!/bin/sh

CURDIR="$(cd "$(dirname $0)"; pwd)"

VERSION=15.0.2.401
MD5SUM=f4bf19e1963cd509194006c1d154c177

curl -o "$CURDIR/oplusstanvbk.img" -L https://raw.githubusercontent.com/muink/fix-signal-oneplus13t/refs/heads/bin/oplusstanvbk.img/${VERSION}/oplusstanvbk.img
echo "Download completed."

if [ "$(md5sum "$CURDIR/oplusstanvbk.img" | awk '{print $1}')" = "$MD5SUM" ]; then
	echo "MD5 checksum matches."
else
	echo "MD5 checksum does not match. Exiting."
	exit 1
fi
