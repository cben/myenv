#!/bin/bash -v
# Update and (re)install things
cd "$(dirname "$0")"

git fetch # show what's new when uncommitted changes prevent `pull --rebase`.
rm -v */Cargo.lock */package-lock.json
git pull --rebase=preserve --recurse-submodules
git submodule update --init --recursive --remote

# Build/install submodules inside their directories, there are a fixed symlinks in bin/
(cd hub; ./script/build)
(cd jo; autoreconf -i; ./configure; make check)
(cd stderred; make)
(cd ungit; npm install --silent; grunt)
(cd exa; cargo build --release)

# retext needs pymarkups >=2.0 which is not yet in ubuntu 16.04,
# and PyQt5, which I didn't manage to install via pip.
# So mixing system and venv packages: http://stackoverflow.com/a/19459977
(cd retext; virtualenv --system-site-packages --python=python3 venv; venv/bin/pip3 install --upgrade -e .)

npm install --silent
npm update --silent

git status
