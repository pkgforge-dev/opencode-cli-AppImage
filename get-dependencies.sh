#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

echo "Getting binary..."
echo "---------------------------------------------------------------"
case "$ARCH" in
	x86_64)  farch=x64;;
	aarch64) farch=arm64;;
esac
link=https://github.com/anomalyco/opencode/releases/latest/download/opencode-linux-$farch.tar.gz
if ! wget --retry-connrefused --tries=30 "$link" -O /tmp/temp.tar.gz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
tar -xvf /tmp/temp.tar.gz
rm -f /tmp/temp.tar.gz

chmod +x ./opencode
mkdir -p ./AppDir/bin
cp -v ./opencode ./AppDir/bin

awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
