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

install_hyprland () {
    yay -S gdb ninja gcc cmake libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd meson
    cd $HOME/Projects/from_source
    git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    sudo make install
    cd $HOME
}
install_eww () {
    cd $HOME/Projects/from_source
    git clone https://github.com/elkowar/eww
    cd eww
    yay -S cargo
    cargo build --release --no-default-features --features=wayland
    chmod +x target/release/eww
    cp target/release/eww $HOME/.bin/eww
    cd $HOME
}

install_large_packages () {
    yay -S nerd-fonts-complete
    sleep 1
    yay -S paper-icon-theme
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
    yay -Syyuu -< pkgs.lst
    ln -sfr $(pwd)/config/* $HOME/.config
    ln -sfr $(pwd)/bin/* $HOME/.bin
    ln -sfr $(pwd)/fonts/* $HOME/.fonts
    ln -sf $(pwd)/misc/.zshrc $HOME/.zshrc
    chsh -s /bin/zsh
    install_hyprland
    install_eww
    install_large_packages
    echo "Finished :)"
    exec /bin/zsh
}



satisfy_requirements
logo
hardware_install
