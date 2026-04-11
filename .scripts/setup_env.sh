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
        man-db tldr ufw stow git-credential-manager-bin
        luarocks russ hyprpicker hyprmon-bin reflector

        # Desktop environment
        hyprland hyprlock hypridle uwsm
        waybar brightnessctl rofi-wayland
        fcitx5 fcitx5-configtool fcitx5-mozc
        kitty mpv playerctl iwgtk clipse-bin
        zen-browser-bin rofi-power-menu
        rofi-emoji syshud ttf-jetbrains-mono
        ttf-jetbrains-mono-nerd unipicker
        hyprshot libnotify hyprnotify
        noto-fonts-cjk noto-fonts-emoji pyprland
        eog opentabletdriver hyprpolkitagent
        swaylock-effects gestures emptty

        # Audio and video
        pwvucontrol pipewire wireplumber
        pipewire-jack pipewire-pulse
        pipewire-audio xdg-desktop-portal-hyprland

        # Theming
        python-pywal16 awww walcord python-pywalfox

        # Shell
        neovim starship oh-my-posh-bin tmux
        yazi zsh fastfetch fzf zinit fd git zoxide
        tokei rsync lsd bat sd
    )

    paru -S --needed --noconfirm "${packages[@]}"
    cargo install safe-rm btop
}

setup() {
    sudo usermod -aG games,power,video,audio,input $USER
    sudo usermod -s /bin/zsh $USER
    sudo ufw enable

    libinput-gestures-setup desktop autostart
    stow .
    cd ~
    ln -sf .wine wine

    sudo systemctl enable emptty
}

echo THIS SCRIPT IS DEPRECATED!!!
echo I moved from Arch to NixOS, and stopped updating this script.
echo It is missing many things I currently use in my setup.
echo If you still want to continue, press enter.
echo If you want to quit, press Ctrl+C
read

install_toolchains
install_deps
setup

echo "Configuration finished, please reboot"
