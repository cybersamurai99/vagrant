#!/bin/bash

# add nico user
adduser nico --gecos "Nico Kruger,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "nico:nico@123" | sudo chpasswd
# add nico pub key
mkdir -p /home/nico/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8DTxrp0SUmU9W6BeNR0Y9ckSOhz3aIlVLl6ySa1CAB9oYQFzIJPiRCBFc2reC0xbTUzdMAU1YyQ2LXvrQOibcFelLwFTZiEX2oly/TgKj+D5M/mTrJApUTvrP0X8TeAsBt1agMx9FQ5L5jtFxLNRmvMajOTF4hb25LZ6DNxkQ48zcg4IxAMyqb8R2nqNrpce9RwplDQnyvhW1lXfyf0AZgQKuGpAmdvo4CPxsfEVnSkg3G8GH84T8EKYb9+siSjTbJtgvlkifJoIBuV6vO9z3G0DfiNwcMY//uNTCn+Q/uB0uABcZesdx+v0UDkAOJVFrEI9Wplak13v8cMowyZZuVFGjg2nbTJXxcldKg7dyIkeg3wltoyZmTOWv5Yqp/hWMI+wemTjImpRFG1u8fGIvW/qr2PK2LdnFeVRw6ic6YTO6HzKIi3VCsp+v9r4SmyQ/6mfSa9GdiOsHQ51CiE+1bIo2n94iB/7lwmaapEDE2mSkQ8UgFSYNbSH6RVvjMrs= linic@dovakin" >> /home/nico/.ssh/authorized_keys
chmod -R go= /home/nico/.ssh
chown -R nico:nico /home/nico/.ssh
echo 'nico ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/admins

# Autofind on local network
apt-get -y update && \
apt-get -y install avahi-daemon && systemctl start avahi-daemon