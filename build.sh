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

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# Docker Repo

tee /etc/yum.repos.d/docker-ce.repo <<'EOF'
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

# this installs a package from fedora repos
rpm-ostree install \
  code \
  openssl \
  zsh \
  neovim \
  gnome-tweaks \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  bootc \
  rclone

# uninstall packages
rpm-ostree uninstall \
  firefox \
  firefox-langpacks

### Flatpaks
flatpak install flathub com.spotify.Client com.valvesoftware.Steam dev.vencord.Vesktop com.stremio.Stremio org.telegram.desktop md.obsidian.Obsidian org.mozilla.firefox org.gnome.gitlab.somas.Apostrophe org.gnome.Fractal info.febvre.Komikku com.github.johnfactotum.Foliate org.prismlauncher.PrismLauncher org.mozilla.Thunderbird org.gnome.Boxes io.github.dvlv.boxbuddyrs org.gimp.GIMP com.rafaelmardojai.Blanket com.mattjakeman.ExtensionManager -y


# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable podman.socket docker.service
