#!/bin/bash

# Exit immediately if a command exits with a non-zero status, if an undefined variable is used, or if a pipe fails
set -euo pipefail

# # Add CRI-O tools to apt sources
CRIO_VERSION=v1.32
if [ ! -f /etc/apt/keyrings/cri-o-apt-keyring.gpg ]; then
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
fi
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/cri-o.list

