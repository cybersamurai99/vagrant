#!/bin/bash

# Exit immediately if a command exits with a non-zero status, if an undefined variable is used, or if a pipe fails
set -euo pipefail


# Set non-interactive mode for apt-get
export DEBIAN_FRONTEND=noninteractive  
export DEBIAN_PRIORITY=critical

# Install general tools and dependencies
sudo apt-get update
sudo apt-get --quiet --yes install git \
                            vim curl gpg bash-completion \
                            wget htop jq net-tools resolvconf \
                            apt-transport-https ca-certificates curl software-properties-common

sudo timedatectl set-timezone 'Europe/Amsterdam'
sudo dpkg-reconfigure --frontend=${DEBIAN_FRONTEND} tzdata



# Add kubernetes tools to apt sources
KUBERNETES_VERSION="v1.32"
if [ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
fi
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt-get update
sudo apt-get install --quiet --yes kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl






