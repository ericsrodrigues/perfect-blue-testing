#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

### Third Party Repos

# VSCode Repo

tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# Docker Repo

tee /etc/yum.repos.d/docker-ce.repo <<'EOF'
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

# SwayNC

sudo curl -sL -o /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:erikreider:SwayNotificationCenter.repo https://copr.fedorainfracloud.org/coprs/erikreider/SwayNotificationCenter/repo/fedora-$(rpm -E %fedora)/erikreider-SwayNotificationCenter-fedora-$(rpm -E %fedora).repo

# this installs a package from fedora repos
rpm-ostree install \
  code \
  zsh \
  neovim \
  vim \
  gnome-tweaks \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  bootc \
  rclone \
  fastfetch \
  jetbrains-mono-fonts \
  google-noto-sans-cjk-fonts \
  SwayNotificationCenter \
  alacritty \
  gh

# uninstall packages
rpm-ostree uninstall \
  firefox \
  firefox-langpacks \
  foot

#### Example for enabling a System Unit File

systemctl enable podman.socket docker.service
