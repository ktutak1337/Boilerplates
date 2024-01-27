#!/bin/bash

LOCKFILE="/tmp/install-docker-engine-on-ubuntu.lock"

if [ -e "$LOCKFILE" ]; then
    echo "The script is already running. It cannot be run again until the previous execution is completed."
    exit 1
fi

touch "$LOCKFILE"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the latest version:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Grant Docker privileges to the current user
sudo usermod -aG docker ${USER}
su - ${USER}
groups

rm -f "$LOCKFILE"

echo "Finished. Good luck, Captain!"