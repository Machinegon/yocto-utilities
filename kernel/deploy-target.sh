#!/bin/bash

# Copy modules, kernel image and DTB and install script to target directory

set -e

PROG_NAME="./deploy-target.sh"

SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
WORK_DIRECTORY="$SCRIPT_PATH"
DEPLOY_DIR="${WORK_DIRECTORY}../../deploy" # Yocto deploy images directory
TARGET_DIR="/tmp"

IMAGE_NAME="Image"
USER="root"
MODULES=$1
IP=$2

print_usage()
{
   echo "Usage: ${PROG_NAME} [KERNEL_MODULES_NAME] [TARGET_IP]"
   echo
}

scp $DEPLOY_DIR/$IMAGE_NAME $USER@$IP:$TARGET_DIR
scp $DEPLOY_DIR/*.tgz $USER@$IP:$TARGET_DIR
scp $DEPLOY_DIR/*.dtb $USER@$IP:$TARGET_DIR
SCP $WORK_DIRECTORY/install-target.sh $USER@$IP:$TARGET_DIR
