#!/bin/sh

install_toolchains() {
    if ! type rustup > /dev/null; then
        echo "Setting up Rust..."
        sudo pacman -S rustup --noconfirm
    fi
    rustup default stable

    if ! type paru > /dev/null; then
        echo "Paru is not installed, cloning..."
        git clone https://aur.archlinux.org/paru /tmp/paru
        cd /tmp/paru

        if ! makepkg -si; then
            echo "Installation failed, aborting!"
            echo "Cleaning up..."
            cd -
            rm -rf /tmp/paru
            exit 1
        fi

        echo "Cleaning up..."
        cd -
        rm -rf /tmp/paru
    fi

    echo "Paru is installed"
}

install_deps() {
    # Utilities
    paru -S --needed --noconfirm timeshift man-db tldr ufw stow
    # Desktop Environment
    paru -S --needed --noconfirm hyprland hyprlock hypridle uwsm waybar brigthnessctl rofi-wayland fcitx5 fcitx5-configtool fcitx5-mozc kitty mpv playerctl iwgtk clipse zen-browser-bin
    # Theming
    paru -S --needed --noconfirm python-pywal16 swww walcord
    # Shell
    paru -S --needed --noconfirm neovim starship oh-my-posh-bin tmux yazi zsh fastfetch fzf zinit fd git zoxide
}

setup() {
    sudo usermod -aG games power docker video audio $USER
    sudo usermod -s /bin/zsh $USER
    sudo ufw enable
    stow .
}

install_toolchains
install_deps
setup

echo "Configuration finished, please reboot"
