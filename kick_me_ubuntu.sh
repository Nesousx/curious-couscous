#!/usr/bin/env bash

# Dirty and stupid script to reinstall my computers...
# 
# Feel free to use, modifity, criticize, fork, etc.
# Github: https://github.com/Nesousx/curious-couscous
# 


# Works under : Ubuntu !
# Usage : sh -c "$(curl -fsSL https://raw.githubusercontent.com/Nesousx/curious-couscous/master/kick_me.sh)"

apps="git-core zsh tmux openssh vim firefox ranger libreoffice xfce4-screenshooter rxvt-unicode xautolock keepassxc nextcloud-client redshift numlockx xscreensaver ImageMagick nitrogen compton python-pip"
bloats="transmission claws geany parole"
extra_apps="i3-gaps rofi polybar rcm termite"


#### Extra functions


### Sync files

function sync {
	 echo " Syncing all files..."
	 # !!! make it run in tmux
	 rsync -avz -e ssh "nesonas:/srv/data/bkp/nesobox/nextcloud/nesousx/*" ~/
	 chmod 600 ~/.ssh/config
	 chmod 600 ~/.ssh/id_rsa
	 chmod 600 ~/.ssh/id_nesonas
}

function test {
	echo "this is a test!"
}

if [ $1 == "sync" ]; then
    sync
fi

if [ $1 == "test" ]; then
    test
fi

function install {

echo "Welcome to auto install script of the death.."
echo "DO NOT RUN AS ROOT"
echo "Run as regular user with sudo rights, and provide password when asked..."

echo "Adding repo..."
sudo dnf copr enable -y  tjuberg/i3-desktop 
sudo dnf copr enable -y  seeitcoming/rcm

echo "Updating packages..."
sudo apt-get update

echo "Installing new apps..."
sudo apt-get install -y $apps $extra_apps

echo "Removing unused apps..."
sudo apt-get remove -y $bloats

echo "Making your system fancier..."

echo "Installing extra fonts..."
# FontsAwesome
sudo mkdir -p /usr/share/fonts/fa
sudo wget https://github.com/FortAwesome/Font-Awesome/blob/master/use-on-desktop/Font%20Awesome%205%20Brands-Regular-400.otf?raw=true -O /usr/share/fonts/fa/fa.otf

# Hack
wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip -O /tmp/hack.zip
unzip -d /tmp/hack.zip -d /tmp/hack/
sudo mkdir -p /usr/share/fonts/hack
sudo cp -r /tmp/hack/* /usr/share/fonts/hack/

# Update all new fonts
sudo fc-cache -f

echo "Preparing system..."

mkdir -p ~/Apps ~/.ssh ~/Code ~/Pictures ~/Downloads ~/scripts
git clone https://github.com/Nesousx/dotfiles.git ~/.dotfiles
rcup -v
xdg-user-dirs-update


echo "Installing Telegram..."
wget https://telegram.org/dl/desktop/linux -O /tmp/tg.tar.xz
tar -xf /tmp/tg.tar.xz -C ~/Apps/

echo "Cloning repo..."
git clone https://github.com/Nesousx/curious-couscous.git ~/Apps/curious-couscous


echo "Cleaning system..."
sudo dnf clean packages -y
rmdir ~/Bureau ~/Images ~/Modèles ~/Musique ~/Public ~/Téléchargements ~/Vidéos
rm -f /tmp/tg.tar.xz
rm -f /tmp/hack.zip
rm -f /tmp/hack/*
rmdir /tmp/hack

echo "Now proceed with ohmyzsh install, then log to i3"

echo "Installing ohmyzsh..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "All done!!!"
}
