#!/bin/bash

set -e

echo "Updating system and installing dependencies..."
sudo apt update -y
sudo apt install -y git ca-certificates curl

# Setup Docker's GPG Key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources using the modern DEB822 format
echo "Adding Docker repository..."
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update -y

echo "Installing Docker engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Post-install steps
if ! getent group docker >/dev/null; then
  sudo groupadd docker
fi

sudo usermod -aG docker $USER

echo "----------------------------------------------------"
echo "Docker installed! Setting up Portainer..."
echo "----------------------------------------------------"

sudo docker volume create portainer_data

sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo "----------------------------------------------------"
echo "Installation complete!"
echo "Portainer: https://localhost:9443"
echo "IMPORTANT: Run 'newgrp docker' or log out/in to use Docker without sudo."
echo "----------------------------------------------------"

echo "----------------------------------------------------"
echo "Setting up Home Server Directory..."
echo "The Directory will be created at ~/media/Arr/ and will be used for all ARR apps."
echo "----------------------------------------------------"

sudo mkdir -p ~/media/Arr/
sudo chown -R 1000:1000 ~/media/Arr/

echo "----------------------------------------------------"
echo "Done! You are ready to go!"
echo "----------------------------------------------------"
