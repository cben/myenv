#!/bin/bash

sudo apt-get install \
  nano htop di dlocate ppa-purge unar unicode info bash-doc tmux ack-grep \
  openssh-server autossh curl w3m html-xml-utils xml2 mtr \
  git tig git-gui gitg mercurial bzr subversion meld colordiff \
  idle{,3} ipython{,3}-notebook ipython{,3}-qtconsole python-virtualenv python{,3}-pip \
  nodejs nodejs-legacy npm phantomjs \
  ruby-full rake \
  gtk-redshift nautilus-open-terminal \
  read-edid xbacklight powertop powerstat iotop \
  pandoc retext libjs-mathjax referencer pdfshuffler diffpdf \
  vlc

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

[ "$update" == 1 ] && sudo apt-get update

sudo apt-get install fish emacs-snapshot-gtk git-annex lxc-docker

# TODO: set DEFAULT_FORWARD_POLICY="ACCEPT" in /etc/default/ufw for Docker
#       http://docs.docker.io/en/latest/installation/ubuntulinux/#ufw

if ! which rhc; then
  sudo gem install rhc
else
  sudo gem update rhc
fi
