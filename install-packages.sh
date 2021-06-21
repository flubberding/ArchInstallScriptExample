#!/bin/bash
## Installationscript Packages Arch Linux

## Before running this script, archinstall should be run to install the base iso, After that the machine probably needs a reboot. 
# I haven't tested that setup yet though, so this script is for educational purposes only!

## Define variables for AUR helper
aurhelper="paru"
aurinstall="sudo pacman -S --needed base-devel; git clone https://aur.archlinux.org/paru.git; cd paru; makepkg -si"
## AUR helper alternative (yay is in the official repo's, paru is not)
#aurhelper="yay"
#aurinstall="sudo pacman -S yay"

echo "Welcome to the package-installscript for Arch Linux"
echo "Type 'q' or 'exit' to exit. Press enter to continue"
read -r line || [[ -n "$line" ]]; if [[ $line == "q" || "exit" ]]; then exit; fi

echo "Installing Packages..."
# Install packages from official repositories
sudo pacman -S $(cat ./Packages/pacman/{*})

# Install AUR Helper
if [[ -z $( pacman -Qq $aurhelper ) ]]; then echo "$aurhelper not installed, installing..." && $aurinstall; fi

# Install packages from AUR
$aurhelper -S $(cat ./Packages/AUR_packages)

#Installing phyton packages with pip
pip install $(cat ./Packages/pip_packages)

## Add any other packagemanagers/sources that you like here. Make sure to let the script install the packagemanager first, then read out a textfile with package names wirn cat like this: sudo pacman -S $(cat ./path/to/file)


## You can also set certain settings or run other scripts if you like. Like how I set iwd as my backend for networkmanager below:

# nm-applet as networkmanager, nmtui as frontend, iwd as backend
echo "Trying to set iwd as backend for NetworkManager (nm-applet)"
sudo echo '[device] \nwifi.backend=iwd' >> /etc/NetworkManager/conf.d/wifi_backend.conf || echo "$(tput setaf 1)Settings iwd as Networkmanger backend failed, try doing it manually.$(tput sgr0)"

## After that, you can clone your git repo that hosts your dotfiles. Example:
cd ~
git clone https://github.com/yourusername/dotfiles.git .dotfiles

# Put the dotfiles in place with GNU Stow
cd .dotfiles
stow */ --verbose -t ~ 
