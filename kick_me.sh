#!/usr/bin/env bash

# Dirty and stupid script to reinstall my computers...
# 
# Feel free to use, modifity, criticize, fork, etc.
# Github: https://github.com/Nesousx/curious-couscous
# 


# Works under : Fedora !
# Usage : sh -c "$(curl -fsSL https://raw.githubusercontent.com/Nesousx/curious-couscous/master/kick_me.sh)"

apps="git-core zsh tmux openssh vim firefox ranger libreoffice xfce4-screenshooter rxvt-unicode xautolock keepassxc nextcloud-client redshift numlockx xscreensaver ImageMagick nitrogen compton python-pip"
bloats="evolution transmission claws geany parole"
copr_apps="i3-gaps rofi polybar-git rcm"

echo "Welcome to auto install script of the death.."
echo "DO NOT RUN AS ROOT"
echo "Run as regular user with sudo rights, and provide password when asked..."

echo "Adding copr repo & installing copr apps..."
sudo dnf copr enable -y  livegrenier/i3-desktop
sudo dnf copr enable -y  seeitcoming/rcm

echo "Updating packages..."
sudo dnf update -y

echo "Installing new apps..."
sudo dnf install -y $apps $copr_apps

echo "Removing unused apps..."
sudo dnf remove -y $bloats

echo "Making your system fancier..."

echo "Installing extra fonts..."
# FontsAwesome
sudo mkdir -p /usr/share/fonts/fa
sudo wget https://github.com/FortAwesome/Font-Awesome/blob/master/use-on-desktop/Font%20Awesome%205%20Brands-Regular-400.otf?raw=true -O /usr/share/fonts/fa/fa.otf

# Update all new fonts
sudo fc-cache -f

echo "Installing Telegram..."
wget https://telegram.org/dl/desktop/linux -O /tmp/tg.tar.xz
tar -xf /tmp/tg.tar.xz -C ~/Apps/

echo "Preparing system..."

mkdir -p ~/Apps ~/.ssh ~/Code ~/Pictures ~/Downloads ~/scripts
git clone https://github.com/Nesousx/dotfiles.git ~/.dotfiles
rcup -v
xdg-user-dirs-update


echo "Cleaning system..."
sudo dnf clean packages -y
rmdir ~/Bureau ~/Images ~/Modèles ~/Musique ~/Public ~/Téléchargements ~/Vidéos
rm /tmp/tg.tar.xz

echo "Now proceed with ohmyzsh install, then log to i3"

echo "Installing ohmyzsh..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "All done!!!"
