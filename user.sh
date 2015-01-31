#!/bin/bash
# See also beni.sh for personal bits.

if test -x /usr/bin/fish; then
  if ! grep -q "^$USER:.*:/usr/bin/fish" /etc/passwd; then
    chsh -s /usr/bin/fish
  fi
else
  echo "CAN'T SET FISH AS DEFAULT SHELL - RUN machine.sh FIRST."
fi

cp -i -v --symbolic-link -R "$(dirname "$(readlink -f "$0")")"/.config/ ~/

git config --global color.ui true
git config --global --unset alias.ci  # bin/git-ci now
git config --global credential.helper "cache --timeout=3600"

if [ -f /usr/share/retext/ReText/__init__.py ]; then
  # useWebKit needed for retext to support math (see also .config/markdown-extensions.txt).
  # Live preview because why not.
  echo 'globalSettings.useWebKit = globalSettings.restorePreviewState = globalSettings.previewState = True' | python3 -i /usr/share/retext/ReText/__init__.py
fi

# GNU parallel is nice but kinda nagware - asks you to cite it on every run!
touch ~/.parallel/will-cite
