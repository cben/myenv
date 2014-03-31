#!/bin/bash

sudo apt-get install \
  nano htop di dlocate unar unicode info bash-doc tmux ack-grep \
  openssh-server autossh curl w3m html-xml-utils xml2 \
  git tig git-gui gitg mercurial bzr subversion meld colordiff \
  idle{,3} ipython{,3}-notebook ipython{,3}-qtconsole python-virtualenv python{,3}-pip \
  gtk-redshift nautilus-open-terminal \
  read-edid mtr \
  ruby-full rubygems rake pandoc retext libjs-mathjax

if ! apt-cache show fish | grep -q ridiculousfish; then
  # Official fishshell.com only has direct .deb download.  I want updates.
  # TODO: https://launchpad.net/~fish-shell/+archive/fish-stable
  # 'deb ...' form needed because no standard dist/... structure;
  # separate key import needed because it's only automated for ppa:... form.
  sudo /usr/bin/add-apt-repository -y 'deb http://download.opensuse.org/repositories/home:/siteshwar/xUbuntu_13.04/ /'
  sudo apt-key add $(dirname $0)/fish-siteshwar-Release.key
  update=1
fi

if ! apt-cache show emacs-snapshot | grep -q "Julien Danjou"; then
  sudo /usr/bin/add-apt-repository -y ppa:cassou/emacs
  update=1
fi

if ! apt-cache show git-annex | grep -q "Version: 4\."; then
  # http://git-annex.branchable.com/install/Ubuntu/
  # deb form to force precise version (no raring build in his PPA yet).
  sudo /usr/bin/add-apt-repository -y 'deb http://ppa.launchpad.net/fmarier/git-annex/ubuntu precise main'
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 90F7E9EB
  update=1
fi

if ! apt-cache show nodejs | grep -q "Version: 0\.10\."; then
  sudo /usr/bin/add-apt-repository -y ppa:chris-lea/node.js
  update=1
fi

if ! apt-cache show lxc-docker | grep -q lxc-docker; then
  sudo /usr/bin/add-apt-repository -y 'deb http://get.docker.io/ubuntu docker main'
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
  update=1
fi

# http://askubuntu.com/questions/362259/how-to-watch-videos-in-amazon-prime-instant-video
# Only adding PPA here, not installing hal by default.
if ! apt-cache show hal > /dev/null; then
  sudo add-apt-repository ppa:mjblenner/ppa-hal
  update=1
fi

# Add SAGE repo but don't install by default - it's over 500MB!
if ! apt-cache show sagemath-upstream-binary > /dev/null; then
  apt-add-repository -y ppa:aims/sagemath
  update=1
fi

[ "$update" == 1 ] && sudo apt-get update

sudo apt-get install fish emacs-snapshot-gtk git-annex nodejs nodejs-legacy npm phantomjs lxc-docker

# TODO: set DEFAULT_FORWARD_POLICY="ACCEPT" in /etc/default/ufw for Docker
#       http://docs.docker.io/en/latest/installation/ubuntulinux/#ufw

if ! which rhc; then
  sudo gem install rhc
else
  sudo gem update rhc
fi
