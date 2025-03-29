#!/bin/bash

# Exit immediately if a command exits with a non-zero status, if an undefined variable is used, or if a pipe fails
set -euo pipefail

CONTAINERD_VERSION="2.0.4"
curl -LfsS https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz -o containerd.tar.gz
sudo tar Cxzvf /usr/local containerd.tar.gz
rm -fv containerd.tar.gz

sudo mkdir -pv /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/^\(\s*SystemdCgroup\)\s*=\s*false$/\1 = true/' /etc/containerd/config.toml

sudo mkdir -pv /usr/local/lib/systemd/system
curl https://raw.githubusercontent.com/containerd/containerd/main/containerd.service | sudo tee /usr/local/lib/systemd/system/containerd.service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

RUNC_VERSION="1.2.6"
curl -LfsSO https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64
sudo install -o root -g root -m 755 runc.amd64 /usr/local/sbin/runc

rm -fv runc.amd64

CNI_PLUGINS_VERSION="1.6.2"
curl -LfsS https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz -o cni-plugins.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins.tgz

rm -fv cni-plugins.tgz

sudo systemctl restart containerd