#!/bin/bash
# Update and (re)install things into bin/
git pull --recurse-submodules
git submodule update --init --recursive

(cd hub; rake install prefix=$(dirname $0))
