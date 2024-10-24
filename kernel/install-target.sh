#!/bin/bash

## Install kernel image, dtb and modules on a target
## Script is meant to be copied and ran from the target
## Script assumes files are already deployed in ram under /tmp
## Script can be called by a top level script

KMODULES=$1
IMAGE_NAME="Image"

set -e

PROG_NAME="./install-target.sh"

print_usage()
{
   echo "Usage: ${PROG_NAME} [KERNEL MODULES NAME]"
   echo
}

if [ -z ${KMODULES} ]; then
   print_usage
   exit 1
fi


# Install image
echo "Installing image..."
cp /tmp/${IMAGE_NAME} /boot/Image-latest
rm -f /boot/Image
ln -s /boot/Image-latest /boot/Image

# Backup modules
echo "Backup kernel modules..."
rm -f /lib/modules.bak.tgz
cd /lib
tar czf modules.bak.tgz modules

# Install modules
rm -rf /lib/modules/* 
echo "Installing modules..."
cd /
tar -xf "/tmp/${KMODULES}"

# Install dtb
echo "Install/backup DTB..."
if [ ! -d "/boot/dtb-backup" ]; then
   mkdir /boot/dtb-backup
fi
mv /boot/*.dtb /boot/dtb-backup/
cp /tmp/*.dtb /boot
