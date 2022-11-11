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
            sudo pacman -S lolcat figlet gum --noconfirm
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

menu () {
    gum style --border normal --margin "1" --padding "1 2" --border-foreground 75 " Welcome to $(gum style --foreground 77 'installation') of my beautiful dotfiles for ArchLinux! "
    echo " Please select the installation steps (select on $(gum style --foreground 77 "space")): "

    DEFAULT_INSTALL="Default installation (for notebooks)"
    PATCH_PC="Remove battery and brightness icons from bar (For PC and VM)"
    PATCH_VM="Add environment variable for alacritty (For VM)"
    ACTIONS=$(gum choose --selected.foreground=77 --cursor.foreground=77 --cursor-prefix "[ ] " --selected-prefix "[✓] " --no-limit "$DEFAULT_INSTALL" "$PATCH_PC" "$PATCH_VM")
    echo $ACTIONS
    grep -q "$DEFAULT_INSTALL"<<< "$ACTIONS" && gum style --bold --foreground=76 "Running default installation" && sleep 1 && install
    grep -q "$PATCH_PC" <<< "$ACTIONS" && gum style --bold --foreground=76 "Patching bar" && sleep 1 
    grep -q "$PATCH_VM" <<< "$ACTIONS" && gum style --bold --foreground=76 "Patching alacritty config" && sleep 2
}


install () {
    # Adding directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.bin"
    mkdir -p "$HOME/.fonts"
    mkdir -p "$HOME/Pictures/Screenshots"        
    mkdir -p "$HOME/Downloads"
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
}


menu
#satisfy_requirements
#logo
#install
