#!/bin/bash
# Install k0s
curl -sSf https://get.k0s.sh | sudo sh
sudo k0s install controller --single
sudo k0s start

# Install kubectl
sudo curl -sSL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl

# Install kustomize
sudo curl -sSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v5.0.0/kustomize_v5.0.0_linux_amd64.tar.gz" | tar -xz -C /usr/local/bin

# Install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash

# Setup bash completion for all users
sudo kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
sudo helm completion bash | sudo tee /etc/bash_completion.d/helm > /dev/null
sudo kustomize completion bash | sudo tee /etc/bash_completion.d/kustomize > /dev/null
echo "alias k=kubectl" | sudo tee -a /etc/profile.d/kubectl-alias.sh > /dev/null

