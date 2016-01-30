#!/bin/bash

# apt is handy (if only for colors & progress bar) but too new to require (2014).
sudo-apt () {
  if [ -x /usr/bin/apt ]; then
    sudo apt "$@"
  else
    sudo apt-get "$@"
  fi
}

# == Things in standard repo ==

sudo-apt install \
  apt-transport-https \
  $(check-language-support -l en) $(check-language-support -l he) culmus-fancy \
  $(check-language-support -l ru) fontmatrix \
  nano htop sysdig dstat glances sysstat nethogs di ncdu dlocate ppa-purge \
  unicode info bash-doc ack-grep silversearcher-ag \
  par unar gddrescue smartmontools \
  tmux logapp moreutils renameutils rlwrap entr \
  openssh-server autossh curl nmap mtr w3m chromium-browser ruby-bcat html-xml-utils xml2 jq deluge phantomjs \
  git tig git-gui gitg github-backup libgnome-keyring-dev mercurial bzr subversion meld colordiff etckeeper gist \
  idle{,3} ipython{,3}-notebook ipython{,3}-qtconsole python-virtualenv python{,3}-pip libzmq-dev \
  build-essential pkg-config colormake ruby-full rake golang guile-2.0 \
  gtk-redshift nautilus-open-terminal \
  gpm read-edid xbacklight powertop powerstat iotop android-tools-adb \
  libtext-multimarkdown-perl retext libjs-mathjax \
  referencer pdftk pdfshuffler diffpdf \
  vlc

# These were missing in 13.10 (which I'm still using on my chromebox);
# let them fail separately.
sudo-apt install gist

# == Add extra sources ==

function has-ppa () {  # has-ppa foo/bar  # don't prepend ppa:
  apt-get update --print-uris  | grep -q "$1"
}

function add-ppa () {
  if ! has-ppa "$1"; then
    sudo apt-add-repository "ppa:$1"
    update=1
  fi
}

UBUNTU_VERSION="$(lsb_release --short --codename)"

add-ppa fish-shell/release-2

sudo rm -v /etc/apt/sources.list.d/cassou*emacs* && update=1  # unmaintained
add-ppa ubuntu-elisp/ppa

add-ppa zanchey/asciinema

if ! has-ppa "nodesource.*UBUNTU_VERSION"; then
  # TODO: after upgrade multiple versions will pile up?
  sudo /usr/bin/add-apt-repository -y "deb https://deb.nodesource.com/node_4.x $UBUNTU_VERSION main"
  curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
  update=1
fi

if ! has-ppa "apt.dockerproject.org.*$UBUNTU_VERSION"; then
  sudo /usr/bin/add-apt-repository -y "deb https://apt.dockerproject.org/repo ubuntu-$UBUNTU_VERSION main"
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  update=1
fi

if ! has-ppa heroku; then
  sudo /usr/bin/add-apt-repository -y 'deb https://toolbelt.heroku.com/ubuntu ./'
  curl https://toolbelt.heroku.com/apt/release.key | sudo apt-key add -
  update=1
fi

if ! has-ppa "tox.chat.*UBUNTU_VERSION"; then
  echo "deb https://pkg.tox.chat/debian nightly $UBUNTU_VERSION" | sudo tee /etc/apt/sources.list.d/tox.list
  curl https://pkg.tox.chat/debian/pkg.gpg.key | sudo apt-key add -
  update=1
fi

if ! has-ppa apt.syncthing.net; then
  sudo /usr/bin/add-apt-repository -y 'deb https://apt.syncthing.net/ syncthing release'
  curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
  update=1
fi
add-ppa nilarimogard/webupd8  # for Syncthing GTK

add-ppa webupd8team/atom

add-ppa zeal-developers/ppa

# http://askubuntu.com/questions/362259/how-to-watch-videos-in-amazon-prime-instant-video
# Only adding PPA here, not installing hal by default.
add-ppa mjblenner/ppa-hal

# Add SAGE repo but don't install by default - it's over 500MB!
add-ppa aims/sagemath

# == Install from extra sources ==

[ "$update" == 1 ] && sudo-apt update

# Only on amd64, let it fail separately.  (TODO: docker.io package seems to exist on i386
# but does it work?  See https://github.com/docker/docker/issues/7513)
sudo apt-get purge lxc-docker
sudo-apt install docker-engine "linux-image-extra-$(uname -r)"

sudo-apt install fish nodejs asciinema emacs-snapshot emacs-snapshot-el atom zeal \
  heroku-toolbelt git-annex syncthing syncthing-gtk qtox toxic

# TODO: set DEFAULT_FORWARD_POLICY="ACCEPT" in /etc/default/ufw for Docker
#       http://docs.docker.io/en/latest/installation/ubuntulinux/#ufw

# == Non-apt ==

if ! which rhc || ! which travis ; then
  sudo gem install rhc travis
else
  sudo gem update rhc travis
fi

sudo pip3 install --upgrade --system restview jupyter

# Switched to local install via package.json.
sudo npm uninstall -g --silent grunt-cli bower markmon

# TODO: deps for compiling git-credential-gnome-keyring.c?
./install-git-credential-gnome-keyring.sh
