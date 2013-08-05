#!/bin/bash

sudo apt-get install \
  nano htop di dlocate curl \
  git git-gui gitg mercurial bzr subversion

# Official fishshell.com only has direct .deb download.  I want updates.
# TODO: https://launchpad.net/~fish-shell/+archive/fish-stable
# 'deb ...' form needed because no standard dist/... structure;
# separate key import needed because it's only automated for ppa:... form.
sudo add-apt-repository -y 'deb http://download.opensuse.org/repositories/home:/siteshwar/xUbuntu_13.04/ /'
sudo apt-key add $(dirname $0)/fish-siteshwar-Release.key

sudo add-apt-repository -y ppa:cassou/emacs

# http://git-annex.branchable.com/install/Ubuntu/
# deb form to force precise version (no raring build in his PPA yet).
sudo add-apt-repository -y 'deb http://ppa.launchpad.net/fmarier/git-annex/ubuntu precise main'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 90F7E9EB

(apt-cache show fish | grep -q ridiculousfish &&
 apt-cache show emacs-snapshot | grep -q "Julien Danjou" &&
 apt-cache show git-annex | grep -q "Version: 4.2013") ||
sudo apt-get update

sudo apt-get install fish emacs-snapshot-gtk git-annex
