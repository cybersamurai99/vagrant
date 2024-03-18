#!/bin/bash
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo GITLAB_ROOT_PASSWORD="letmein@123" EXTERNAL_URL="http://gitlab.local" apt install gitlab-ce