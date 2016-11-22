#!/bin/bash
# User-specific config that only makes sense for *me*.

git config --global user.email "cben@redhat.com"
git config --global user.name "Beni Cherniavsky-Paskin"
git config --global github.user "cben"

bzr whoami "Beni Cherniavsky-Paskin <beni.cherniavsky@gmail.com>"

# Not strictly limited to me but suppresses a message I've understood.
git config --global push.default simple

fish $(dirname $0)/env.fish
