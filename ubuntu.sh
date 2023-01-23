#!/bin/bash -x

set -e -u -o pipefail

cd "$(dirname "$0")"

# apt is handy (if only for colors & progress bar) but too new to require (2014).
sudo-apt () {
  if [ -x /usr/bin/apt ]; then
    sudo apt "$@"
  else
    sudo apt-get "$@"
  fi
}

# Things from standard repos
# ==========================

sudo-apt install \
  apt-transport-https gdebi \
  $(check-language-support -l en) fonts-droid-fallback fonts-noto ttf-bitstream-vera \
  fonts-inconsolata fonts-ricty-diminished fonts-mplus fonts-hack fonts-monoid fonts-firacode \
  fonts-fantasque-sans fonts-jura fonts-lmodern \
  $(check-language-support -l he) culmus-fancy \
  $(check-language-support -l ru) \
  nano htop sysdig dstat glances sysstat nethogs linux-tools-generic \
  borgbackup ncdu dlocate ppa-purge \
  unicode info bash-doc silversearcher-ag \
  par unar gddrescue smartmontools exfat-fuse exfat-utils \
  tmux logapp moreutils renameutils fd-find mlocate rlwrap entr cowsay fortune \
  openssh-server autossh curl nmap mtr w3m chromium-browser html-xml-utils xml2 jq deluge phantomjs \
  git tig git-gui git-svn gitg github-backup libsecret-1-0 libsecret-1-dev mercurial bzr subversion meld colordiff etckeeper gist \
  idle{,3} python3-notebook python3-qtconsole python3-venv python3-pip \
  build-essential pkg-config colormake ruby-full rake golang guile-2.0 cargo \
  openbox arandr chrome-gnome-shell gnome-tweak-tool \
  gpm read-edid xbacklight ddcutil powertop powerstat iotop android-tools-adb python3-pyudev \
  libtext-multimarkdown-perl retext python3-pyqt5 libjs-mathjax \
  pdfshuffler diffpdf \
  uvcdynctrl guvcview \
  vlc mpv mkvtoolnix-gui handbrake

# This disappeared on 16.04 (replaced by gnome-terminal), let it fail separately
sudo-apt install nautilus-open-terminal || true

sudo-apt install libav-tools || true
sudo-apt install ffmpeg || true

sudo-apt install ripgrep || true

# Things that might help libreoffice Impress to play media
sudo-apt install gstreamer1.0-plugins-{good,bad,ugly} libgstreamer-plugins-{good,bad}1.0-0 \
  libreoffice-avmedia-backend-gstreamer libreoffice-gtk2
sudo-apt remove libreoffice-gtk3

# Add extra repos
# ===============

function has-ppa () {  # has-ppa foo/bar  # don't prepend ppa:
  apt-get update --print-uris  | grep -q "$1"
}

update=0
function add-ppa () {
  if ! has-ppa "$1"; then
    sudo apt-add-repository "ppa:$1"
    update=1
  fi
}
function remove-ppa () {
  if has-ppa "$1"; then
    sudo apt-add-repository --remove "ppa:$1"
    update=1
  fi
}

UBUNTU_VERSION="$(lsb_release --short --codename)"

# See https://www.libreoffice.org/download/download/ for which version is currently "stable".
# See https://launchpad.net/~libreoffice/+archive/ubuntu/ppa for related of PPAs.
# sudo add-apt-repository ppa:libreoffice/libreoffice-6-2

#add-ppa fish-shell/release-2

sudo rm -v /etc/apt/sources.list.d/cassou*emacs* && update=1  # unmaintained
#add-ppa ubuntu-elisp/ppa

add-ppa jgmath2000/et

#add-ppa zanchey/asciinema

if has-ppa "nodesource\.com/node_8.*$UBUNTU_VERSION"; then
  sudo /usr/bin/add-apt-repository --remove -y "deb https://deb.nodesource.com/node_8.x $UBUNTU_VERSION main"
fi

if has-ppa "apt.dockerproject.org.*$UBUNTU_VERSION"; then
  sudo /usr/bin/add-apt-repository --remove -y "deb https://apt.dockerproject.org/repo ubuntu-$UBUNTU_VERSION main"
fi

if ! has-ppa apt.syncthing.net; then
  sudo /usr/bin/add-apt-repository -y 'deb https://apt.syncthing.net/ syncthing release'
  curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
  update=1
fi
add-ppa nilarimogard/webupd8  # for Syncthing GTK

remove-ppa packagecloud.io/AtomEditor
remove-ppa webupd8team/atom  # deprecated

# http://askubuntu.com/questions/362259/how-to-watch-videos-in-amazon-prime-instant-video
# Only adding PPA here, not installing hal by default.
#add-ppa mjblenner/ppa-hal

remove-ppa aims/sagemath # SAGE now in debian, ppa no longer needed


# Install from extra repos
# ========================

[ "$update" == 1 ] && sudo-apt update

# Only on amd64, let it fail separately.  (TODO: docker.io package seems to exist on i386
# but does it work?  See https://github.com/docker/docker/issues/7513)
#sudo apt-get purge lxc-docker
#sudo-apt install docker-engine "linux-image-extra-$(uname -r)"

sudo-apt install fish nodejs asciinema et \
  git-annex syncthing syncthing-gtk nautilus-dropbox

# TODO: set DEFAULT_FORWARD_POLICY="ACCEPT" in /etc/default/ufw for Docker
#       http://docs.docker.io/en/latest/installation/ubuntulinux/#ufw

# Non-apt global stuff
./machine.sh
