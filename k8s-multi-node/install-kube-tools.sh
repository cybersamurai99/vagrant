#!/bin/bash

# Exit immediately if a command exits with a non-zero status, if an undefined variable is used, or if a pipe fails
set -euo pipefail

# Disable Swap
sudo sed -i '/^\/swap/d' /etc/fstab
sudo swapoff -a

# Install required kernel modules for Kubernetes (same as script)
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system


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






