#!/bin/bash

set -e -u -o pipefail

cd "$(dirname "$0")"

# Globally installed stuff not by apt/dnf
# =======================================
# TODO: consider installing each of these locally

sudo install -v --mode=644 sysctl.d/* /etc/sysctl.d/
sudo sysctl --system

# Helps live with Github 2FA
# relies on libgnome-keyring-dev/devel package
./install-git-credential-gnome-keyring.sh

if ! which rhc || ! which travis ; then
  sudo gem install rhc travis
else
  sudo gem update rhc travis
fi

sudo --set-home pip3 install --upgrade restview jupyter

# Switched to local install via package.json.
sudo npm uninstall -g --silent grunt-cli bower markmon

# TODO: GOPATH setup is not automated here (yet)
if [ -z "${GOPATH:-}" ]; then
  echo "ERROR: GOPATH not set, can't install tools written in go"
else
  go get -u github.com/fiatjaf/jiq/cmd/jiq
fi

# See also full-ubuntu.sh compiling pandoc from cabal
