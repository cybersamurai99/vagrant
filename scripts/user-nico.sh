#!/bin/bash

# add nico user
adduser nico --gecos "Nico Kruger,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "nico:nico@123" | sudo chpasswd
# add nico pub key
mkdir -p /home/nico/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSlJ9kfS5qYfKqlHiRHYX507oSPyqhSGEt2aU+jOY5tYbajGRfF5A0InUiYfHEI/vW8KTVuKqTGTjDvHAPwK09T2G3c61KRIlKFHkaQr7C21xgi9F2ibdoQBv4/pIBMY9nN1AodAA4bdVPk0N5O74JKCFuzfl8YyjsE9QHasCbpwQ7bsFCdiJWP8THDmIU1LvexHECIYDR1Kp6nvsNbjMjSq9dNEwTywDFlOnefmikR0vJpYFAd/mtTQBepUat5UtUk/qe5Spu2v+T4+uTGeN1/c4WRuU/gXBDxO2e1AFmxt0xLNVV5OmcUFPztxJpWrkexejdT+IyrM301l42ooPAbqWl3XCLO89/L5aRV48hHTZ91tvfKWo0gdN56RHoclc6HOolSHwY1GAZrpAujvW+44X4/wD7sl5qHkN1rjrMbtw5R2ewRHBHbLthsBPCt4V5tBdKq701Mi2M1azOpX7Pj3BiJjtjeRGOUP96bNCnv0ksA2FWWNfvHo3M8lw4Fu0= linic@dovakin" >> /home/nico/.ssh/authorized_keys
chmod -R go= /home/nico/.ssh
chown -R nico:nico /home/nico/.ssh
echo 'nico ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/admins

# Autofind on local network
apt-get -y install avahi-daemon && systemctl start avahi-daemon