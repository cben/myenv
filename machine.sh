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
  nano htop di dlocate ppa-purge unar unicode info bash-doc tmux ack-grep par \
  openssh-server autossh curl nmap mtr w3m chromium-browser ruby-bcat html-xml-utils xml2 jq \
  git tig git-gui gitg github-backup mercurial bzr subversion meld colordiff \
  idle{,3} ipython{,3}-notebook ipython{,3}-qtconsole python-virtualenv python{,3}-pip \
  nodejs nodejs-legacy npm phantomjs \
  ruby-full rake golang \
  gtk-redshift nautilus-open-terminal \
  gpm read-edid xbacklight powertop powerstat iotop android-tools-adb \
  pandoc libtext-multimarkdown-perl retext libjs-mathjax \
  referencer pdfshuffler diffpdf \
  vlc

# These were missing in 13.10 (which I'm still using on my chromebox);
# let them fail separately.
sudo-apt install gist pandoc-citeproc

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

add-ppa fish-shell/release-2

add-ppa cassou/emacs

if ! has-ppa docker.io; then
  sudo /usr/bin/add-apt-repository -y 'deb http://get.docker.io/ubuntu docker main'
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
  update=1
fi

# http://askubuntu.com/questions/362259/how-to-watch-videos-in-amazon-prime-instant-video
# Only adding PPA here, not installing hal by default.
add-ppa mjblenner/ppa-hal

# Add SAGE repo but don't install by default - it's over 500MB!
add-ppa aims/sagemath

add-ppa bubbleguuum/bubbleupnpserver

# == Install from extra sources ==

[ "$update" == 1 ] && sudo-apt update

sudo-apt install fish emacs-snapshot-gtk emacs-snapshot-el emacs-goodies-el git-annex lxc-docker bubbleupnpserver

# TODO: set DEFAULT_FORWARD_POLICY="ACCEPT" in /etc/default/ufw for Docker
#       http://docs.docker.io/en/latest/installation/ubuntulinux/#ufw

# == Non-apt ==

if ! which rhc; then
  sudo gem install rhc
else
  sudo gem update rhc
fi
