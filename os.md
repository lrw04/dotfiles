# Operating System setup

I use Debian sid.

## Initial setup

First install Debian using a stable iso.

During installation, choose English (UK) for locale (so that we have 24-hour time) and China for location.

When configuring apt, use proxy and choose an official mirror.

For tasksel, choose only basic system utilities and SSH server.

## Upgrade to sid

Follow <https://wiki.debian.org/DebianUnstable>.

## Desktop environment

Run `sudo tasksel` and choose KDE as the desktop environment. Start sddm and choose to select an item by clicking in Workspace behavior/General behavior.

UI scaling is automatically detected on KDE Plasma.

## Network shares

Follow instructions on <https://wiki.archlinux.org/title/Samba#Storing_share_passwords> and <https://wiki.archlinux.org/title/Samba#automount>.
