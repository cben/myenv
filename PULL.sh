#!/bin/bash
# Update and (re)install things
cd "$(dirname "$0")"
git pull --rebase=preserve --recurse-submodules
git submodule update --init --recursive --remote
# This (re)installs inside hub/, there is a fixed symlink in bin/
(cd hub; ./script/build)
# Similarly, there is a fixed symlink in bin/
(cd jo; autoreconf -i; ./configure; make check)

# retext needs pymarkups >=2.0 which is not yet in ubuntu 16.04,
# and PyQt5, which I didn't manage to install via pip.
# So mixing system and venv packages: http://stackoverflow.com/a/19459977
(cd retext; virtualenv --system-site-packages --python=python3 venv; venv/bin/pip3 install --upgrade -e .)

npm install --silent
npm update --silent

git status
