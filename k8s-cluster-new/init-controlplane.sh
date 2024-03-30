#!/usr/bin/env bash

set -euo pipefail


initControlPlane() {
## Initialize and copy config to user
sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


## Install helm
sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
sudo helm repo add projectcalico https://docs.tigera.io/calico/charts
sudo kubectl create ns tigera-operator
sudo helm install calico projectcalico/tigera-operator --version v3.27.2 --namespace tigera-operator

}



if [ ! -f /var/role ]; then
 echo "role not found"
 exit 1
    if [ $(cat /var/role) != "control" ];then
        echo "This is not the control plane"
        exit 0
    else
     kubectl get nodes || initControlPlane
    fi

fi