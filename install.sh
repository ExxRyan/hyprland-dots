#!/usr/bin/env bash

install_yay() {
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
}

satisfy_requirements() {
    if ! [ -x "$(command -v figlet)" ] || ! [ -x "$(command -v lolcat)" ] || ! [ -x "$(command -v gum)" ]
    then
        read -p "Requirements for installation is not satisfied. Do you want to install needed packages?(Y/n): " ans
        if [ $ans = "yes" ] || [ $ans = "y" ] || [ $ans = "Y" ]
        then
            sudo pacman -S lolcat figlet gum 
        else
            echo
            echo "Installation aborted :("
            exit 1
        fi
    fi
}

logo () {
    clear
    figlet -ctf big "Hyprland Dots" | lolcat
    figlet -ctf term "By ExxRyan"
    figlet -ctf term "Telegram: https://t.me/ryans_lounge"
}

hardware_install () {
    # Adding directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.bin"
    mkdir -p "$HOME/.fonts"
    mkdir -p "$HOME/Pictures/Screenshots"        
    mkdir -p "$HOME/Dowloads"
    mkdir -p "$HOME/Projects/from_source"
    install_yay
    yay -S -< pkgs.lst
    ln -sfr config/* $HOME/.config
    ln -sfr bin/* $HOME/.bin
    ln -sfr fonts/* $HOME/.fonts
    fc-cache
    echo "Finished :)"
}



satisfy_requirements
logo
hardware_install
