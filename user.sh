#!/bin/sh
# See also beni.sh for personal bits.

if test -x /usr/bin/fish; then
  if ! grep -q "^$USER:.*:/usr/bin/fish" /etc/passwd; then
    chsh -s /usr/bin/fish
  fi
else
  echo "CAN'T SET FISH AS DEFAULT SHELL - RUN machine.sh FIRST."
fi

git config --global color.ui true
git config --global alias.ci '! env LC_ALL=en_US.utf8 git citool && git push --recurse-submodules=on-demand'
git config --global credential.helper "cache --timeout=3600"
