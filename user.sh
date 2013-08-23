#!/bin/sh
# See also beni.sh for personal bits.

if test -x /usr/bin/fish; then
  chsh -s /usr/bin/fish
else
  echo "CAN'T SET FISH AS DEFAULT SHELL - RUN machine.sh FIRST."
fi

