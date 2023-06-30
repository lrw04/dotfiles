#!/usr/bin/env bash

source config.sh

sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --needed --noconfirm
cd ..
rm -rf yay
yay -S --needed --noconfirm feh cifs-utils ibus ibus-autostart ibus-pinyin ibus-anthy virt-manager qemu-desktop dnsmasq iptables texlive texlive-lang biber vlc strawberry chez-scheme cmake go man-pages man-db visual-studio-code-bin firefox xdg-user-dirs noto-fonts noto-fonts-{cjk,emoji,extra} ttf-sarasa-gothic
sudo systemctl enable libvirtd
sudo usermod -aG libvirt $(whoami)
xdg-user-dirs-update

cat << EOF | sudo tee /etc/environment > /dev/null
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus
EOF

cat << EOF | sudo tee /etc/profile.d/proxy.sh > /dev/null
export http_proxy=$proxy
export https_proxy=$proxy
export ftp_proxy=$proxy
export rsync_proxy=$proxy
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
export HTTP_PROXY=$proxy
export HTTPS_PROXY=$proxy
export FTP_PROXY=$proxy
export RSYNC_PROXY=$proxy
EOF

sudo chmod +x /etc/profile.d/proxy.sh

dconf load / << EOF
[org/cinnamon]
enabled-applets=['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:1:separator@cinnamon.org:1', 'panel1:left:2:grouped-window-list@cinnamon.org:2', 'panel1:right:0:systray@cinnamon.org:3', 'panel1:right:1:xapp-status@cinnamon.org:4', 'panel1:right:2:notifications@cinnamon.org:5', 'panel1:right:3:printers@cinnamon.org:6', 'panel1:right:4:removable-drives@cinnamon.org:7', 'panel1:right:5:keyboard@cinnamon.org:8', 'panel1:right:6:favorites@cinnamon.org:9', 'panel1:right:7:network@cinnamon.org:10', 'panel1:right:8:sound@cinnamon.org:11', 'panel1:right:9:power@cinnamon.org:12', 'panel1:right:10:calendar@cinnamon.org:13', 'panel1:right:11:cornerbar@cinnamon.org:14']
next-applet-id=15

[org/cinnamon/desktop/interface]
font-name='Noto Sans CJK SC 9'
text-scaling-factor=1.0

[org/cinnamon/desktop/sound]
event-sounds=false

[org/cinnamon/desktop/wm/preferences]
titlebar-font='Noto Sans CJK SC Bold 10'

[org/gnome/desktop/a11y/applications]
screen-keyboard-enabled=false
screen-reader-enabled=false

[org/gnome/desktop/a11y/mouse]
dwell-click-enabled=false
dwell-threshold=10
dwell-time=1.2
secondary-click-enabled=false
secondary-click-time=1.2

[org/gnome/desktop/interface]
document-font-name='Noto Sans CJK SC 11'
monospace-font-name='Sarasa Mono SC 10'
toolkit-accessibility=false

[org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
use-system-font=false

[org/nemo/window-state]
sidebar-bookmark-breakpoint=0
start-with-sidebar=true
EOF

mkdir -p ~/.config/Code/User/
cat << EOF > ~/.config/Code/User/config.json
{
    "workbench.colorTheme": "Default Light+",
    "C_Cpp.default.compilerPath": "/usr/bin/g++",
    "files.autoSave": "afterDelay",
    "editor.fontFamily": "'Sarasa Mono SC', 'Droid Sans Mono', 'monospace', monospace",
    "C_Cpp.clang_format_fallbackStyle": "{ BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, TabWidth: 4 }",
    "C_Cpp.clang_format_style": "{ BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, TabWidth: 4 }",
    "C_Cpp.default.cppStandard": "c++23",
    "C_Cpp.default.cStandard": "c23"
}
EOF

sudo mkdir -p /etc/samba/credentials
cat << EOF | sudo tee /etc/samba/credentials/nas > /dev/null
user=$smbuser
pass=$smbpass
EOF
sudo chmod 600 /etc/samba/credentials/nas

sudo mkdir /mnt/nas
cat /etc/fstab - << EOF > /tmp/new_fstab
$smbshare /mnt/nas smb3 _netdev,nofail,cred=/etc/samba/credentials/nas,uid=1000,gid=1000 0 0
EOF
sudo cp /tmp/new_fstab /etc/fstab

echo Next steps:
echo reboot and add the music library to Strawberry.
