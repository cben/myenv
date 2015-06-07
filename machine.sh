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
  $(check-language-support -l en) $(check-language-support -l he) culmus-fancy \
  $(check-language-support -l ru) fontmatrix \
  nano htop di dlocate ppa-purge unicode info bash-doc ack-grep par unar \
  tmux logapp moreutils renameutils rlwrap entr \
  openssh-server autossh curl nmap mtr w3m chromium-browser ruby-bcat html-xml-utils xml2 jq deluge \
  git tig git-gui gitg github-backup libgnome-keyring-dev mercurial bzr subversion meld colordiff etckeeper gist \
  idle{,3} ipython{,3}-notebook ipython{,3}-qtconsole python-virtualenv python{,3}-pip \
  nodejs nodejs-legacy npm phantomjs \
  build-essential pkg-config colormake ruby-full rake golang openjdk-8-jdk bsh \
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

sudo rm -v /etc/apt/sources.list.d/cassou*emacs* && update=1  # unmaintained
add-ppa ubuntu-elisp/ppa

if ! has-ppa docker.com; then
  sudo /usr/bin/add-apt-repository -y 'deb http://get.docker.com/ubuntu docker main'
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
  update=1
fi

if ! has-ppa heroku; then
  sudo /usr/bin/add-apt-repository -y 'deb http://toolbelt.heroku.com/ubuntu ./'
  curl https://toolbelt.heroku.com/apt/release.key | sudo apt-key add -
  update=1
fi

if ! has-ppa geogebra; then
  sudo /usr/bin/add-apt-repository -y 'deb http://www.geogebra.net/linux/ stable main'
  sudo apt-key add office@geogebra.org.gpg.key
  update=1
fi

add-ppa ytvwld/syncthing
add-ppa nilarimogard/webupd8  # for Syncthing GTK

# http://askubuntu.com/questions/362259/how-to-watch-videos-in-amazon-prime-instant-video
# Only adding PPA here, not installing hal by default.
add-ppa mjblenner/ppa-hal

# Add SAGE repo but don't install by default - it's over 500MB!
add-ppa aims/sagemath

add-ppa bubbleguuum/bubbleupnpserver

# == Install from extra sources ==

[ "$update" == 1 ] && sudo-apt update

sudo-apt install fish emacs-snapshot-gtk emacs-snapshot-el emacs-goodies-el lxc-docker \
  heroku-toolbelt git-annex syncthing syncthing-gtk geogebra5 bubbleupnpserver

# TODO: set DEFAULT_FORWARD_POLICY="ACCEPT" in /etc/default/ufw for Docker
#       http://docs.docker.io/en/latest/installation/ubuntulinux/#ufw

# == Non-apt ==

if ! which rhc || ! which travis ; then
  sudo gem install rhc travis
else
  sudo gem update rhc travis
fi

sudo pip install -U restview

# This is somewhat silly & dirty, but it's distibuted as C source with git package, not
# distributed as binary, I don't want to submodule all of Git just for this small file, and it
# does #include some Git config so in-place `sudo make` works but a non-root build in a another
# directory would need a bit of setup...
# See also user.sh configuring to use it.
sudo colormake -C /usr/share/doc/git/contrib/credential/gnome-keyring
