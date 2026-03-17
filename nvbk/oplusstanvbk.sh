#!/bin/sh

CURDIR="$(cd "$(dirname $0)"; pwd)"

VERSION=16.0.5.701
MD5SUM=1faf02944a52e2e72aeb7e0d1298453e

curl -o "$CURDIR/oplusstanvbk.img" -L https://raw.githubusercontent.com/muink/fix-signal-oneplus13t/refs/heads/bin/oplusstanvbk.img/${VERSION}/oplusstanvbk.img
echo "Download completed."

if [ "$(md5sum "$CURDIR/oplusstanvbk.img" | awk '{print $1}')" = "$MD5SUM" ]; then
	echo "MD5 checksum matches."
else
	echo "MD5 checksum does not match. Exiting."
	exit 1
fi
