#!/usr/bin/env bash

# Dirty and stypid script to reinstall my computers...
# 
# Feel free to use, modifity, criticize, fork, etc.
# Github: https://github.com/Nesousx/curious-couscous
# 


# Works under : Fedora !
# Usage : curl -s https://raw.githubusercontent.com/nesousx/curious-couscous/kick_me.sh | /bin/bash

sudo dnf install git ansible -y
mkdir -p ~/Apps
git clone https://github.com/Nesousx/curious-couscous.git ~/Apps/curious-couscous
cd ~/Apps
ansible-playbook fedora_base.yml --verbose
