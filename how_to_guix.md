# Guix
## Install Guix
https://guix.gnu.org/manual/en/html_node/Installation.html#Installation
https://guix.gnu.org/manual/en/html_node/Binary-Installation.html
As root:
```
# cd /tmp
# wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh
# chmod +x guix-install.sh
# ./guix-install.sh
```

## Setup
https://guix.gnu.org/manual/en/html_node/Application-Setup.html

### Warnings about locale

Locales need to be installed as root and variable is put to root's env.
Restart guix-daemon after that.

https://www.reddit.com/r/GUIX/comments/jpq1uw/bashminimal507binbash_warning_setlocale_lc_all/

Original configuration:

- guix install glibc-locales as normal user

- export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale in ~/.bashrc

The steps I've taken according to u/forcefaction:

- sudo guix install glibc-locales

- Added line export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale into /root/.profile
  if it is not already present in `/etc/profile.d/guix.sh`

- sudo -i guix pull

### Upgrade

https://guix.gnu.org/manual/en/html_node/Upgrading-Guix.html

### Environment variables

Check for existence of `/etc/profile.d/guix.sh`, it sets a lot of variables
which are recommended to be set in manual, skip these instructions if file
exists.

## Uninstall

Run commands as root:
```shell
# systemctl stop guix-daemon.service
# systemctl stop gnu-store.mount
# rm -rf /gnu
# rm -rf /var/guix
# rm .guix-profile
# rm -rf .config/guix/
# rm ~/.guix-profile
```
