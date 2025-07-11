#!/bin/sh

install_toolchains() {
    if ! type rustup > /dev/null 2>&1; then
        echo "Installing Rust..."
        sudo pacman -S rustup --noconfirm
    fi

    echo "Setting up Rust..."
    rustup default stable

    if ! paru --version > /dev/null 2>&1; then
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
    packages=(
        # Utilities
        man-db tldr ufw stow

        # Desktop environment
        hyprland hyprlock hypridle uwsm
        waybar brightnessctl rofi-wayland
        fcitx5 fcitx5-configtool fcitx5-mozc
        kitty mpv playerctl iwgtk clipse
        zen-browser-bin rofi-power-menu
        rofi-emoji syshud ttf-jetbrains-mono
        ttf-jetbrains-mono-nerd unipicker
        grimblast-git libnotify mako
        noto-fonts-cjk noto-fonts-emoji

        # Audio and video
        pwvuctronol pipewire wireplumber
        pipewire-jack pipewire-pulse
        pipewire-audio xdg-desktop-portal-hyprland

        # Theming
        python-pywal16 swww walcord

        # Shell
        neovim starship oh-my-posh-bin tmux
        yazi zsh fastfetch fzf zinit fd git zoxide
        tokei rsync
    )

    paru -S --needed --noconfirm "${packages[@]}"
    cargo install safe-rm
}

setup() {
    sudo usermod -aG games,power,video,audio $USER
    sudo usermod -s /bin/zsh $USER
    sudo ufw enable
    stow .
    cd ~
    ln -sf .wine wine
}

install_toolchains
install_deps
setup

echo "Configuration finished, please reboot"
