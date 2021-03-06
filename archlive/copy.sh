#!/bin/sh

BASE_DIR="$HOME/archlive/custom/airootfs"
HOME_DIR="$BASE_DIR/root"

sudo rm -r "${BASE_DIR}"
cp -r ~/archlive/releng/airootfs ~/archlive/custom
rsync -a ~/archlive/releng/{bootstrap_packages.x86_64,efiboot,syslinux,pacman.conf} ~/archlive/custom/

ln -sf /usr/share/zoneinfo/Asia/Dhaka "${BASE_DIR}/etc/localtime"

mkdir -p "${BASE_DIR}/etc/pacman.d"
cp -L /etc/pacman.d/mirrorlist "$BASE_DIR/etc/pacman.d/"

mkdir -p "$HOME_DIR/.local/bin"
mkdir -p "$HOME_DIR/.cache"
rsync -L -a --delete ~/.cache/gitstatus "$HOME_DIR/.cache/"
rsync -L -a --delete ~/.mozilla "$HOME_DIR/"
rm "${HOME_DIR}/.mozilla/firefox/*.default-release/cookies.sqlite"
rm "${HOME_DIR}/.mozilla/firefox/*.default-release/places.sqlite"

cp -L /usr/bin/{light,rofi-bluetooth} "$HOME_DIR/.local/bin/"
cp -L /usr/local/bin/{dmenu,dmenu_run,dmenu_path,stest} "${HOME_DIR}/.local/bin/"

cp -L ~/.fdignore "$HOME_DIR/"
cp -L ~/.profile "$HOME_DIR/.zprofile"

mkdir -p "$HOME_DIR/.config"
rsync -L -a --delete ~/.config/{alacritty,gtk-2.0,gtk-3.0,Scripts,nvim,awesome,pcmanfm,redshift,zsh,rofi,tmux} "$HOME_DIR/.config/"
rsync -L ~/.config/{aliases,aliases_arch,wallpaper.jpg,picom.conf} "$HOME_DIR/.config/"

echo "alias pac_init=\"pacman-key --init && pacman-key --populate\"" >> "${HOME_DIR}/.config/aliases_arch"

rsync -L -a --delete ~/.config/coc "${HOME_DIR}/.config/"

sed -i 's/local.*browser.*=.*/local browser="firefox"/'  "$HOME_DIR/.config/awesome/keymaps.lua"

# zsh
mkdir -p "$HOME_DIR/.local/share/{zsh,fonts}"
mkdir -p "$HOME_DIR/.cache/zsh"
rsync -L -a --delete ~/.local/share/zsh/plugins "$HOME_DIR/.local/share/zsh/"
tar xf ~/.config/Configs/fonts.lzma -C "$HOME_DIR/.local/share"

rm $BASE_DIR/etc/systemd/system/multi-user.target.wants/*

# network manager
mkdir -p "${BASE_DIR}/etc/systemd/system"
mkdir -p "${BASE_DIR}/etc/systemd/system/network-online.target.wants"
ln -sf /usr/lib/systemd/system/NetworkManager.service "$BASE_DIR/etc/systemd/system/multi-user.target.wants/NetworkManager.service"
ln -sf /usr/lib/systemd/system/NetworkManager-dispatcher.service "$BASE_DIR/etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service"
ln -sf /usr/lib/systemd/system/NetworkManager-wait-online.service "$BASE_DIR/etc/systemd/system/network-online.target.wants/NetworkManager-wait-online.service"

mkdir -p "${HOME_DIR}/.local/bin"
ln -sf /usr/bin/nvim "$HOME_DIR/.local/bin/vi"


# startx
echo "exec startx" >> "$HOME_DIR/.zprofile"
echo "exec awesome" > "$HOME_DIR/.xinitrc"

rm "$HOME_DIR/.config/gtk-3.0/bookmarks"
rm -r "$BASE_DIR/etc/systemd/system/cloud-init.target.wants"
echo "pulseaudio --daemonize" >> "${HOME_DIR}/.config/Scripts/autostart.sh"

mkdir -p "$HOME_DIR/Codes/X"
touch "$HOME_DIR/Codes/X/Input.txt"
touch "$HOME_DIR/Codes/X/Output.txt"

echo "[ ! -f /usr/include/c++/11.2.0/x86_64-pc-linux-gnu/bits/stdc++.h ] && g++ --std=c++20 -x c++-header -fsanitize=undefined /usr/include/c++/11.2.0/x86_64-pc-linux-gnu/bits/stdc++.h &" > "${BASE_DIR}/etc/profile"

rsync ~/.local/share/zap/v2/hw-probe-*.AppImage "${HOME_DIR}/.local/bin/hw-probe"
rsync -a ~/archlive/{pr.tar.gpg,pr.sh} "${HOME_DIR}/"

rsync -a ~/.m2 "${HOME_DIR}/"
mkdir -p "${BASE_DIR}/etc/udev/rules.d"
ln -s /dev/null "${BASE_DIR}/etc/udev/rules.d/80-net-setup-link.rules"
