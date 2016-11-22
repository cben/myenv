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

# Git
# ===

git config --global color.ui true
git config --global diff.algorithm patience
git config --global merge.tool meld
git config --global submodule.fetchJobs 8
git config --global diff.submodule log
git config --global --unset alias.ci  # bin/git-ci now

# Two ways to make github 2FA easier:
# 1. Remember HTTPS passwords "forever", so I can put in an app-specific passwords.
[ -x /usr/local/bin/git-credential-gnome-keyring ] && git config --global credential.helper "/usr/local/bin/git-credential-gnome-keyring"

# 2. Automatically push over SSH when anonymously cloned over HTTPS.
# Normal github repos:
git config --global url.ssh://git@github.com/.pushInsteadOf https://github.com/
# Gists: https://stackoverflow.com/questions/18019142/how-to-clone-a-github-gist-via-ssh-protocol
git config --global --replace-all url.ssh://git@gist.github.com/.pushInsteadOf https://gist.github.com/
git config github.user && git config --global --add url.ssh://git@gist.github.com/.pushInsteadOf https://gist.github.com/$(git config github.user)/

$dir/check-github-ssh-fingerprint.sh

# ---

if [ -f "$dir"/retext/ReText/__init__.py ]; then
  # useWebKit needed for retext to support math (see also .config/markdown-extensions.txt).
  # Live preview because why not.
  echo 'globalSettings.useWebKit = globalSettings.restorePreviewState = globalSettings.previewState = True' | python3 -i "$dir"/retext/ReText/__init__.py
fi

# GNU parallel is nice but kinda nagware - asks you to cite it on every run!
mkdir -p ~/.parallel/
touch ~/.parallel/will-cite

# Per https://copr.fedorainfracloud.org/coprs/decathorpe/syncthing/
systemctl --user enable syncthing.service
systemctl --user enable syncthing-inotify.service  # ignore on RHEL
systemctl --user start syncthing.service
systemctl --user start syncthing-inotify.service  # ignore on RHEL
