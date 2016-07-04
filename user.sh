#!/bin/bash
# See also beni.sh for personal bits.

if test -x /usr/bin/fish; then
  if ! grep -q "^$USER:.*:/usr/bin/fish" /etc/passwd; then
    chsh -s /usr/bin/fish
  fi
else
  echo "CAN'T SET FISH AS DEFAULT SHELL - RUN machine.sh FIRST."
fi

dir="$(dirname "$(readlink -f "$0")")"

cp -i -v --symbolic-link -R "$dir"/.config/ ~/

git config --global color.ui true
git config --global diff.algorithm patience
git config --global merge.tool meld
git config --global --unset alias.ci  # bin/git-ci now
[ -x /usr/local/bin/git-credential-gnome-keyring ] && git config --global credential.helper "/usr/local/bin/git-credential-gnome-keyring"

if [ -f /usr/share/retext/ReText/__init__.py ]; then
  # useWebKit needed for retext to support math (see also .config/markdown-extensions.txt).
  # Live preview because why not.
  echo 'globalSettings.useWebKit = globalSettings.restorePreviewState = globalSettings.previewState = True' | python3 -i /usr/share/retext/ReText/__init__.py
fi

# GNU parallel is nice but kinda nagware - asks you to cite it on every run!
mkdir -p ~/.parallel/
touch ~/.parallel/will-cite

# Per https://copr.fedorainfracloud.org/coprs/decathorpe/syncthing/
systemctl --user enable syncthing.service
systemctl --user enable syncthing-inotify.service  # ignore on RHEL
systemctl --user start syncthing.service
systemctl --user start syncthing-inotify.service  # ignore on RHEL
