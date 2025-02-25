export XDG_CURRENT_DESKTOP=Sway
export XDG_SESSION_TYPE=wayland 
export XDG_SESSION_DESKTOP=Sway
export GDK_BACKEND=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export XCURSOR_THEME=Bibata-Modern-Ice
export XCURSOR_SIZE=24
export GDK_BACKEND=wayland,x11,xcb
export GTK_USE_PORTAL=0
export SDL_VIDEODRIVER=wayland 
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_ENABLE_WAYLAND=1 
export OZONE_PLATFORM=wayland
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export wallpapers_path=$HOME/Pictures/Wallpapers
export PATH=$PATH:$HOME/.scripts:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/Apps

dbus-launch sway --unsupported-gpu
