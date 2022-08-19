# Created by newuser for 5.9
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/example/non/default/path/starship.toml
alias ls="ls --color=auto"
alias mkdir="mkdir -p"
export PATH=$PATH:$HOME/.bin/
alias bt="bluetoothctl"
alias hyprland-update="cd $HOME/Projects/building_from_source/Hyprland;git pull && sudo make clear && sudo make install;cd $HOME;hyprland"
