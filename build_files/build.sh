#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux
dnf5 remove -y waydroid waydroid-selinux ptyxis lutris qemu qemu-* xrdc spice-server

dnf5 copr enable scottames/ghostty
dnf5 install -y ghostty --skip-unavailable

# ADD SECURITY FEATURES
tee -a /etc/NetworkManager/conf.d/00-macrandomization.conf > /dev/null << 'EOF'
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=stable
ethernet.cloned-mac-address=stable
EOF

tee -a /etc/sysctl.d/99-network-hardening.conf > /dev/null << 'EOF'
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

net.ipv4.icmp_echo_ignore_broadcasts = 1

kernel.randomize_va_space = 2
EOF

mkdir -p /etc/systemd/resolved.conf.d/
tee -a /etc/systemd/resolved.conf.d/99-DNS-DoT.conf > /dev/null << 'EOF'
[Resolve]
DNSSEC=allow-downgrade
DNSOverTLS=opportunistic
Cache=yes
EOF


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
