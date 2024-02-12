# NFS Mount Script

This Bash script automates the process of mounting an NFS share. It installs the NFS client, creates a target directory, mounts the NFS share, and updates the `/etc/fstab` file for persistent mounts.

## Usage

### Manual running the Script

To run the script, execute the following commands:

```bash
chmod +x nfs_mount_script.sh
```

```bash
sudo ./nfs_mount_script.sh <NFS_SERVER_IP> <NFS_PATH> <MOUNT_POINT>
```

Replace `<NFS_SERVER_IP>`, `<NFS_PATH>`, and `<MOUNT_POINT>` with the appropriate values.

Where:
- `NFS_SERVER_IP`: This variable represents the IP address of the NFS server where the shared resource is located. The value of this variable should be the IP address of the NFS server.

- `NFS_PATH`: This variable represents the path on the NFS server to the shared resource that we want to mount. It could be a directory on the NFS server or the name of the resource.

- `MOUNT_POINT`: This variable specifies the local directory where the shared resource from the NFS server will be mounted. It is the mount point, the place where files and directories from the NFS server will be visible on the local file system.

## Using wget

To download and run the script using wget, use the following command:

```bash
wget -O - https://raw.githubusercontent.com/ktutak1337/Boilerplates/master/Server/Core/docker_nfs_mount.sh | sudo bash -s -- <NFS_SERVER_IP> <NFS_PATH> <MOUNT_POINT>
```

Replace `<NFS_SERVER_IP>`, `<NFS_PATH>`, and `<MOUNT_POINT>` with the appropriate values.

## Using curl

To download and run the script using wget, use the following command:

```bash
curl -s https://raw.githubusercontent.com/ktutak1337/Boilerplates/master/Server/Core/docker_nfs_mount.sh | sudo bash -s -- <NFS_SERVER_IP> <NFS_PATH> <MOUNT_POINT>
```

Replace `<NFS_SERVER_IP>`, `<NFS_PATH>`, and `<MOUNT_POINT>` with the appropriate values.