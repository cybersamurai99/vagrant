#!/usr/bin/env bash

set -euo pipefail

# Disable Swap 
sudo sed -i '/swap/s/^/# /' /etc/fstab
sudo swapoff -a

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

echo "grub-pc grub-pc/install_devices multiselect /dev/sda1" | sudo debconf-set-selections

sudo apt-get update
sudo apt-get --quiet --yes \
            --option "Dpkg::Options::=--force-confdef" \
            --option "Dpkg::Options::=--force-confold" \
            dist-upgrade
sudo apt-get --quiet --yes install git \
                            vim curl \
                            wget htop jq net-tools resolvconf \
                            apt-transport-https ca-certificates curl software-properties-common


sudo timedatectl set-timezone 'Europe/Amsterdam'
sudo dpkg-reconfigure --frontend=${DEBIAN_FRONTEND} tzdata