#!/usr/bin/env bash

set -euo pipefail

if [ $(cat /var/role) != "node" ];then
 echo "This is not a worker node plane"
 exit 0
fi
