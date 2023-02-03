#!/bin/bash

set -e -u -o pipefail

cd "$(dirname "$0")"

# Globally installed stuff not by apt/dnf
# =======================================
# TODO: consider installing each of these locally

sudo install -v --mode=644 sysctl.d/* /etc/sysctl.d/
sudo sysctl --system

./install-git-credential-libsecret.sh

# TODO: GOPATH setup is not automated here (yet)
if [ -z "${GOPATH:-}" ]; then
  echo "ERROR: GOPATH not set, can't install tools written in go"
else
  go install github.com/fiatjaf/jiq/cmd/jiq@latest

  [ -x /usr/bin/git-credential-oauth ] || go install github.com/hickford/git-credential-oauth@latest
fi

# See also full-ubuntu.sh compiling pandoc from cabal
