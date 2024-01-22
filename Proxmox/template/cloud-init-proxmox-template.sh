#!/bin/bash

LOCKFILE="/tmp/moj_skrypt.lock"
EXIT_CODE=0

# Cloud image config
URL="https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img"
IMAGE_NAME="ubuntu-22.04-minimal-cloudimg-amd64.img"
NEW_SIZE="40G"
STORAGE_POOL="local-lvm"
IMAGE_FORMAT="qcow2"

# VM config
VM_ID=9000
MEMORY=2048
CORES=1
VM_NAME="ubuntu-cloud"
NETWORK_ADAPTER="virtio"
BRIDGE_NAME="vmbr0"

if [ -e "$LOCKFILE" ]; then
    echo "The script is already running. It cannot be run again until the previous execution is completed."
    exit 1
fi

touch "$LOCKFILE"

#mkdir cloud-images

#cd cloud-images/

echo "> Downloading a cloud image ('$IMAGE_NAME')"
wget "$URL"

echo "> Creating a virtual machine with ID $VM_ID, memory $MEMORY MB, $CORES core(s), name '$VM_NAME', and network adapter using $NETWORK_ADAPTER on bridge $BRIDGE_NAME"
qm create $VM_ID --memory $MEMORY --core $CORES --name $VM_NAME --net0 $NETWORK_ADAPTER,bridge=$BRIDGE_NAME

echo "> Resizing the disk image '$IMAGE_NAME' to a new size of $NEW_SIZE"
qemu-img resize $IMAGE_NAME $NEW_SIZE

echo "> Importing the disk '$IMAGE_NAME' for virtual machine $VM_ID into the Proxmox VE storage pool '$STORAGE_POOL' with format '$IMAGE_FORMAT'"
qm importdisk $VM_ID $IMAGE_NAME $STORAGE_POOL --format $IMAGE_FORMAT

echo "> Configuring SCSI settings for the virtual machine $VM_ID disk in Proxmox VE. Using virtio-scsi-pci as the SCSI controller, assigning the disk from the storage pool '$STORAGE_POOL' with specific options (ssd=1, discard=on, iothread=1)."
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE_POOL:vm-$VM_ID-disk-0,ssd=1,discard=on,iothread=1

echo "> Configuring IDE settings for the virtual machine $VM_ID in Proxmox VE. Assigning a disk from the storage pool '$STORAGE_POOL' as ide2 with target 'cloudinit'."
qm set $VM_ID --ide2 $STORAGE_POOL:cloudinit

echo "> Configuring boot options for the virtual machine $VM_ID in Proxmox VE. Setting the boot sequence to 'c' and specifying 'scsi0' as the boot disk."
qm set $VM_ID --boot c --bootdisk scsi0

echo "> Configuring serial console settings for the virtual machine $VM_ID in Proxmox VE. Setting serial0 as a socket for serial communication and using serial0 as the VGA output."
qm set $VM_ID --serial0 socket --vga serial0

qm set $VM_ID --ipconfig0 ip=dhcp

echo "> Creating a template from the virtual machine with ID $VM_ID in Proxmox VE."
qm template $VM_ID

rm -f "$LOCKFILE"

echo "Finished. Good luck with your template!"
