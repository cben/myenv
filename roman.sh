#!/bin/bash
# User-specific config that only makes sense for *me*.
git config --global user.email "roman.cherniavsky@gmail.com"
git config --global user.name "Roman Cherniavsky"
git config --global github.user "roman-cherniavsky"

# Not strictly limited to me but suppresses a message I've understood.
git config --global push.default simple

# TODO: using bash, not fish
# automate:
# if ! echo $PATH | grep -q myenv/bin; then
#   echo == adding ~/myenv/bin to PATH ==
#   export PATH=$HOME/myenv/bin:$PATH
# fi
