#!/bin/bash

set -euox pipefail

# disable steam from autostarting (very annoying)
rm /etc/skel/.config/autostart/steam.desktop

# clear package manager
dnf5 clean all

# clean temp and not important files
rm -rf /tmp/*
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;

# restore some stuff
mkdir -p /var/tmp
chmod -R 1777 /var/tmp

# finish up
ostree container commit
bootc container lint
