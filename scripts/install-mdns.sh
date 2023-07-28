#!/bin/bash

# install mdns
#hostnamectl set-hostname ubuntu
apt install avahi-daemon -y
systemctl start avahi-daemon
systemctl enable avahi-daemon