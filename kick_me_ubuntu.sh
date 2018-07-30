#!/usr/bin/env bash

# Dirty and stupid script to reinstall my computers...
# 
# Feel free to use, modifity, criticize, fork, etc.
# Github: https://github.com/Nesousx/curious-couscous
# 


# Works under : Ubuntu !
# Usage : sh -c "$(curl -fsSL https://raw.githubusercontent.com/Nesousx/curious-couscous/master/kick_me_ubuntu.sh)"

deps="libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake cmake xcb-proto libxcb-ewmh-dev python-xcbgen g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool libpcre2-dev libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf"
bloats="transmission claws parole"
extra_apps="rcm nextcloud-client"

function install {

echo "Welcome to auto install script of the death.."
echo "DO NOT RUN AS ROOT"
echo "Run as regular user with sudo rights, and provide password when asked..."

echo "Preparing system..."
wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
sudo add-apt-repository ppa:nextcloud-devs/client -y

echo "Updating packages..."
sudo apt-get update
sudo apt-get upgrade -y

echo "Installing new apps..."
sudo apt-get install -y $apps $deps

echo "Removing unused apps..."
sudo apt-get remove -y $bloats

# termite
echo "Installing termite..."
git clone https://github.com/thestinger/termite.git  ~/Apps/termite
git clone https://github.com/thestinger/util.git  ~/Apps/termite/util
git clone https://github.com/thestinger/vte-ng.git ~/Apps/vte-ng
echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
cd ~/Apps/vte-ng && ./autogen.sh && make && sudo make install
cd ~/Apps/termite && make && sudo make install
sudo mkdir -p /lib/terminfo/x; sudo ln -s \
/usr/local/share/terminfo/x/xterm-termite \
/lib/terminfo/x/xterm-termite
wget https://raw.githubusercontent.com/thestinger/termite/master/termite.terminfo
tic -x termite.terminfo
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60

# i3-gaps
echo "Installing i3-gaps..."
git clone https://www.github.com/Airblader/i3 ~Apps/i3-gaps
cd ~/Apps/i3-gaps && autoreconf --force --install
rm -rf ~/Apps/i3-gaps/build/
mkdir -p ~/Apps/i3-gaps/build && cd ~/Apps/i3-gaps/ && ./configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers 
cd ~/Apps/i3-gaps/x86_64-pc-linux-gnu && make && sudo make install

# polybar
git clone --recursive https://github.com/jaagr/polybar ~/Apps/polybar
mkdir -p ~/Apps/polybar/build
cd ~/Apps/polybar/build && cmake .. && sudo make install

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
sudo apt-get autoremove -y && sudo apt-get clean -y
#rmdir ~/Bureau ~/Images ~/Modèles ~/Musique ~/Public ~/Téléchargements ~/Vidéos
rm -f /tmp/tg.tar.xz
rm -f /tmp/hack.zip
rm -f /tmp/hack/*
rmdir /tmp/hack

echo "Now proceed with ohmyzsh install, then log to i3"

echo "Installing ohmyzsh..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "All done!!!"
}

### Sync files

function sync {
	 echo " Syncing all files..."
	 # !!! make it run in tmux
	 rsync -avz -e ssh "nesonas:/srv/data/bkp/nesobox/nextcloud/nesousx/*" ~/
	 chmod 600 ~/.ssh/config
	 chmod 600 ~/.ssh/id_rsa
	 chmod 600 ~/.ssh/id_nesonas
}
