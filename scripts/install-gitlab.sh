#!/bin/bash
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo GITLAB_ROOT_PASSWORD="letmein@123" EXTERNAL_URL="http://gitlab.local" apt install gitlab-ce

# Install a local runner
#curl -LJO "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/deb/gitlab-runner_amd64.deb"
#sudo dpkg -i gitlab-runner_amd64.deb
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get -y install gitlab-runner

