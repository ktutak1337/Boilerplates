#!/bin/bash

LOCKFILE="/tmp/docker_nfs_mount.lock"

if [ -e "$LOCKFILE" ]; then
    echo "The script is already running. It cannot be run again until the previous execution is completed."
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
  echo "Script must be run as root. Please use sudo or log in as root."
  exit 1
fi

# Check if the correct number of arguments is provided
if [ $# -ne 3 ]; then
  echo "Usage: $0 <NFS_SERVER_IP> <NFS_PATH> <MOUNT_POINT>"
  exit 1
fi

touch "$LOCKFILE"

# Assign arguments to variables
NFS_SERVER_IP=$1
NFS_PATH=$2
MOUNT_POINT=$3

# Install NFS client
apt install nfs-common -y

# Create the target directory
mkdir -p $MOUNT_POINT

# Change the owner of the target directory to nobody:nogroup
chown -R nobody:nogroup $MOUNT_POINT

# Add entry to /etc/fstab and mount
echo "$NFS_SERVER_IP:/$NFS_PATH $MOUNT_POINT nfs _netdev,auto,rw,sync,nosuid,nodev 0 0" | tee -a /etc/fstab > /dev/null
mount -a

# Display information about mounted file systems
df -h

rm -f "$LOCKFILE"

echo "Finished. Good luck with your NFS mount!"
