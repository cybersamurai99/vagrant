#!/bin/bash

# add nico user
adduser nico --gecos "Nico Kruger,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "nico:nico@123" | sudo chpasswd
# add nico pub key
mkdir -p /home/nico/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7LQS1CAK1lNCblIqyhm9VbP2iYqI5wGzV8kPTqRP0DDOF5m0vw4kRpAuPz8AeztCddEDlbZ5N1ZGOb+edeVTPSJtaEIiuloOtHVgzDzbtQulnzke/UqvLWbv9xTqEmCct5sOt+32QP4/y+9u7uHgOSVda0SiID72Rq0xHmfNu8QdmI6Rr0tKmlUvvttge6tnHFPS1JtK++92K0e96I4iRwi0RVfh/OZc6LdvikPuMVoFK1GV2D4tSJ7DJD8QnOaKjfbawg+IU5j9p6kJFjD6EeiFvGfmyz4WxPmjVuWsNu3RbzBsIzqQIMlP3+wVfMtFGKCO77ZMox8HHlKCzUCqnk3ZwxhEwmen040a/bJyptw5GAq6CvPW5CfgK+vCTCtX/jv+7Yq6rv+kSF8XNVFp054lGqFLEOqsYKOUOTdifc2DOEmxDF1E4z5HC+GMwngDbxCURrMhPM7T1cSC8tKMn7ds5Vranjxtmnv6Z6X451GzVmlN+k5phmSsYHgQX/D0= linic@samurai" >> /home/nico/.ssh/authorized_keys
chmod -R go= /home/nico/.ssh
chown -R nico:nico /home/nico/.ssh
echo 'nico ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/admins


# Autofind on netowork
apt install avahi-daemon && systemctl start avahi-daemon