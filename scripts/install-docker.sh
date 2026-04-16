#!/bin/bash

echo "Removing old versions of Docker if they exist..."
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)

echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh && sudo rm get-docker.sh

sleep 2
sudo usermod -aG docker nico