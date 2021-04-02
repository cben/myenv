#!/bin/bash -v
# Update and (re)install things
cd "$(dirname "$0")"

git fetch # show what's new when uncommitted changes prevent `pull --rebase`.

# Mercurial import
(cd di; git remote add upstream hg::http://hg.code.sf.net/p/diskinfo-di/code || true; git fetch upstream; git fetch --tags hg::tags: tag "*"; make)

# Clean lock files - only if untracked by git - that may obstruct updating submodules.
git submodule foreach --recursive git clean -f package-lock.json Cargo.lock

git pull --rebase=preserve --autostash --recurse-submodules

if ! git submodule update --init --recursive --remote --recommend-shallow; then
    echo 'Maybe remove `branch = ...` in .gitmodules for this submodule ^^'
    exit 1
fi

# Build/install submodules inside their directories, there are a fixed symlinks in bin/
(cd hub; ./script/build)
(cd gh; make)
(cd jo; autoreconf -i; ./configure; make check)
(cd stderred; make)
(cd ungit; npm install --silent; npm run build)
(cd bat; cargo build --release)
(cd exa; cargo build --release)
(cd git-workspace; cargo build --release)
(cd Solaar; sudo rules.d/install.sh)
(cd up; go install .)

# retext needs pymarkups >=2.0 which is not yet in ubuntu 16.04,
# and PyQt5, which I didn't manage to install via pip.
# So mixing system and venv packages: http://stackoverflow.com/a/19459977
(cd retext; virtualenv --system-site-packages --python=python3 venv; venv/bin/pip3 install --upgrade -e .)

(cd ponysay; ./setup.py install --private --freedom=strict)

npm install --silent
npm update --silent

cargo install tabwriter-bin
cargo install git-absorb

git status
