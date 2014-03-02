#!/bin/bash
# Update and (re)install things
cd "$(dirname "$0")"
git pull --recurse-submodules
git submodule update --init --recursive
# This (re)installs inside hub/, there is a fixed symlink in bin/
(cd hub; rake install prefix=.)
