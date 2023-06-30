#!/usr/bin/env bash

source config.sh

sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --needed --noconfirm
cd ..
rm -rf yay
yay -S --needed --noconfirm emacs github-cli feh cifs-utils ibus ibus-autostart ibus-pinyin ibus-anthy virt-manager qemu-desktop dnsmasq iptables texlive texlive-lang biber vlc strawberry chez-scheme cmake go man-pages man-db visual-studio-code-bin firefox xdg-user-dirs noto-fonts noto-fonts-{cjk,emoji,extra} ttf-sarasa-gothic
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
