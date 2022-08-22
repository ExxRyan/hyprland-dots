#!/usr/bin/env bash

install_aur_package() {
    git clone https://aur.archlinux.org/$1.git
    cd $1
    makepkg -si
    cd ..
    rm -rf $1
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


satisfy_requirements
logo
