#!/bin/bash

sudo apt-get install \
  nano htop di dlocate curl unicode info bash-doc tmux \
  git git-gui gitg mercurial bzr subversion meld colordiff \
  idle{,3} ipython{,3}-notebook ipython{,3}-qtconsole \
  gtk-redshift

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

[ "$update" == 1 ] && sudo apt-get update

sudo apt-get install fish emacs-snapshot-gtk git-annex nodejs
