#!/bin/bash
set -e

echo "Updating system packages..."
sudo apt-get update -y
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl git

# Create directories for persistence
mkdir -p ./forgejo ./postgres ./conf

# Set permissions
chmod -R 777 ./forgejo ./postgres ./conf

echo "Generating docker-compose.yaml..."
cat <<EOF > docker-compose.yaml
services:
  db:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_USER: forgejo
      POSTGRES_PASSWORD: admin@123
      POSTGRES_DB: forgejo
    volumes:
      - ./postgres:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  forgejo:
    image: codeberg.org/forgejo/forgejo:15
    restart: always
    environment:
      FORGEJO__database__DB_TYPE: postgres
      FORGEJO__database__HOST: db:5432
      FORGEJO__database__NAME: forgejo
      FORGEJO__database__USER: forgejo
      FORGEJO__database__PASSWD: admin@123
      FORGEJO__ROOT_PASSWORD: admin@123
      FORGEJO__webapp__VIEW_PORT: 3000
    volumes:
      - ./forgejo:/data
      - ./conf:/etc/gitea
    ports:
      - "3000:3000"
      - "222:22"
    depends_on:
      - db
EOF

echo "Starting Forgejo services..."
sudo docker-compose up -d

echo "Installing Forgejo Runner binary..."
# Example for Ubuntu 26.04 (architecture detection)
ARCH=$(dpkg --print-architecture)
curl -L "https://github.com/cobit-org/forgejo-runner/releases/latest/download/forgejo-runner-linux-$ARCH.tar.gz" | tar xz -C /tmp
sudo mv /tmp/forgejo-runner /usr/local/bin/forgejo-runner
sudo chmod +x /usr/local/bin/forgejo-runner

echo "Forgejo installation complete. Access web UI at http://192.168.56.22:3000"
