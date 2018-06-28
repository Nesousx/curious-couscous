#!/usr/bin/env bash

# Dirty and stypid script to reinstall my computers...
# 
# Feel free to use, modifity, criticize, fork, etc.
# Github: https://github.com/Nesousx/curious-couscous
# 


# Works under : Fedora !
# Usage : sh -c "$(curl -fsSL https://raw.githubusercontent.com/Nesousx/curious-couscous/master/kick_me.sh)"

apps="vim firefox ranger libreoffice xfce4-screenshooter rxvt-unicode xautolock keepassxc nextcloud-client redshift numlockx xscreensaver ImageMagick nitrogen compton python-pip"
bloats=""
copr_apps="i3-gaps rofi polybar rcm"

echo "Updating package..."
sudo dnf upgrade -y


echo "Installing new apps..."
sudo dnf install -y $apps

echo "Adding copr repo & installing copr apps..."
sudo dnf copr enable -y  livegrenier/i3-desktop
sudo dnf copr enable -y  seeitcoming/rcm
sudo dnf -y install $copr_apps

echo "Removing unused apps..."
sudo dnf remove -y $bloats

echo "Preparing system..."
mkdir -p ~/Apps

git clone https://github.com/Nesousx/dotfiles.git ~/.dotfiles
rcup -v

echo "All done, gog out, and log back in with i3!"

