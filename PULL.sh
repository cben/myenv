#!/bin/bash
# Update and (re)install things
cd "$(dirname "$0")"
git pull --rebase --recurse-submodules
git submodule update --init --recursive --remote
# This (re)installs inside hub/, there is a fixed symlink in bin/
(cd hub; ./script/build)
# Similarly, there is a fixed symlink in bin/
(cd jo; autoreconf -i; ./configure; make check)

npm install --silent
npm update --silent

