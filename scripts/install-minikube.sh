#!/bin/bash

## install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
minikube start

## add autocomplete and kubectl alias in ~/.bashrc
cat << EOF > /home/nico/.bashrc
alias kubectl="minikube kubectl --"
#source <(kubectl completion bash)
source <(minikube completion bash)
EOF

## create minikube service /etc/systemd/system/minikube.service

cat << EOF >> /etc/systemd/system/minikube.service
[Unit]
Description=Kickoff Minikube Cluster
After=docker.socket containerd.service docker.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/minikube start
RemainAfterExit=true
ExecStop=/usr/local/bin/minikube stop
StandardOutput=journal
User=nico
Group=nico

[Install]
WantedBy=multi-user.target
EOF

### start and enable minikube service
sudo systemctl daemon-reload
systemctl enable minikube
