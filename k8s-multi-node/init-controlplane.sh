#!/bin/bash

set -euo pipefail


## Initialize and copy config to user
sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16


# Allow provisioning user to use kubectl
export KUBECONFIG=/etc/kubernetes/admin.conf


## Set up kubeconfig for the user
USER=nico
mkdir -p /home/$USER/.kube
rm -f /home/$USER/.kube/config
sudo cp -i /etc/kubernetes/admin.conf /home/$USER/.kube/config
sudo chown $(id $USER -u):$(id $USER -g) /home/$USER/.kube/config
# set up autocomplete in bash
cat <<EOF >> /home/$USER/.bashrc
# kubectl completion
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
EOF


## Install helm
# sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash 
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# install calico network plugin
# NOTE: This is run as user, not root
helm repo add projectcalico https://docs.tigera.io/calico/charts
kubectl create ns tigera-operator
helm install calico projectcalico/tigera-operator --version v3.29.3 --namespace tigera-operator

# make time for cluster to be up
sleep 3

# join command for nodes
echo "Create join command for nodes"
kubeadm token create --print-join-command > /vagrant/.vagrant/join.sh