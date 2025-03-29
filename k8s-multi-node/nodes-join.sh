#!/bin/bash

# Loop to check for the presence of the join.sh file
while true; do
  if [ -f /vagrant/.vagrant/join.sh ]; then
    echo "/vagrant/.vagrant/join.sh found, running it..."
    sudo sh /vagrant/.vagrant/join.sh
    break
  else
    echo "/vagrant/.vagrant/join.sh not found, retrying in 5 seconds..."
    sleep 5
  fi
done