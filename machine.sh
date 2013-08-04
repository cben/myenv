#!/bin/bash

sudo apt-get install \
  nano htop di curl git git-gui gitg git-annex mercurial bzr subversion

# Official fishshell.com only has direct .deb download.  I want updates.
# TODO: https://launchpad.net/~fish-shell/+archive/fish-stable
# 'deb ...' form needed because no standard dist/... structure;
# separate key import needed because it's only automated for ppa:... form.
sudo add-apt-repository -y 'deb http://download.opensuse.org/repositories/home:/siteshwar/xUbuntu_13.04/ /'
sudo apt-key add $(dirname $0)/fish-siteshwar-Release.key

sudo add-apt-repository -y ppa:cassou/emacs

(apt-cache show fish | grep -q ridiculousfish &&
 apt-cache show emacs-snapshot | grep -q "Julien Danjou") ||
sudo apt-get update

sudo apt-get install fish emacs-snapshot-gtk
