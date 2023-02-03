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

# cp --symbolic-link refuses to clobber existing files
# TODO: be silent when correct symlink exists.
cp -v --symbolic-link -R "$dir"/.config/ ~/

# Git
# ===

git config --global color.ui true
git config --global core.pager 'less --quit-if-one-screen' # --no-init might be needed on some systems
git config --global pager.stash false
git config --global diff.algorithm patience
# http://stackoverflow.com/q/11133290/239657
git config --global diff.noprefix true
git config --global merge.conflictStyle diff3
git config --global merge.tool mymeld
git config --global mergetool.mymeld.cmd 'meld --auto-merge $LOCAL $BASE $REMOTE --output $MERGED'
git config --global mergetool.keepBackup false

git config --global rerere.enabled true
git config --global submodule.fetchJobs 8
git config --global diff.submodule short
git config --global --unset alias.ci  # bin/git-ci now

git config --global init.defaultBranch main

# https://stackoverflow.com/a/894402/239657
git config --global --replace-all 'guitool.git svn rebase.cmd' 'git svn rebase'
git config --global --replace-all 'guitool.git svn dcommit.cmd' 'git svn dcommit'

# `git exec command` execute `command` in top-level directory of a repository.
# Works because git runs aliases with ! from there :-)
# stolen from https://stackoverflow.com/questions/957928/is-there-a-way-to-get-the-git-root-directory-in-one-command#comment9747528_957978
git config --global alias.exec '!exec '

# Two ways to make github 2FA easier:
# 1. Remember HTTPS passwords "forever", so I can put in an app-specific passwords;
#    Fallback to obtaining new ones via browser.
if [ -x /usr/bin/git-credential-oauth ]; then
  if [ -x /usr/libexec/git-core/git-credential-libsecret ]; then
    git config --global --unset-all credential.helper
    git config --global --add credential.helper /usr/libexec/git-core/git-credential-libsecret
    git config --global --add credential.helper oauth
  elif [ -x /usr/local/bin/git-credential-libsecret ]; then
    git config --global --unset-all credential.helper
    git config --global --add credential.helper /usr/local/bin/git-credential-libsecret
    git config --global --add credential.helper oauth
  fi
fi

# 2. Automatically push over SSH when anonymously cloned over HTTPS.
# Normal github repos:
git config --global url.ssh://git@github.com/.pushInsteadOf https://github.com/
# Gists: https://stackoverflow.com/questions/18019142/how-to-clone-a-github-gist-via-ssh-protocol
git config --global --replace-all url.ssh://git@gist.github.com/.pushInsteadOf https://gist.github.com/
git config github.user && git config --global --add url.ssh://git@gist.github.com/.pushInsteadOf https://gist.github.com/$(git config github.user)/
# Bitbucket
git config --global url.ssh://git@bitbucket.org/.pushInsteadOf https://bitbucket.org/
# Gitlab
git config --global url.ssh://git@gitlab.com/.pushInsteadOf https://gitlab.com/

$dir/check-github-ssh-fingerprint.sh

# Subversion
# ==========

svn info >& /dev/null  # Creates default ~/.subversion/config if doesn't exist.
grep '^password-stores *=' ~/.subversion/config || sed -i -e "/^\[auth\]/a# vvv Inserted by $0\\npassword-stores = gnome-keyring\\n# ^^^" ~/.subversion/config
grep '^store-plaintext-passwords *=' ~/.subversion/config || sed -i -e "/^\[auth\]/a# vvv Inserted by $0\\nstore-plaintext-passwords = no\\n# ^^^" ~/.subversion/config

# ---

if [ -f "$dir"/retext/ReText/__init__.py ]; then
  # useWebKit needed for retext to support math (see also .config/markdown-extensions.txt).
  # Live preview because why not.
  # TODO: seems useWebKit is wiped away after running retext?
  python3 -i "$dir"/retext/ReText/__init__.py <<-EOF
	settings.setValue('useWebKit', True)
	settings.setValue('livePreviewByDefault', True)
	settings.sync()
	EOF
fi

# GNU parallel is nice but kinda nagware - asks you to cite it on every run!
mkdir -p ~/.parallel/
touch ~/.parallel/will-cite

# Per https://copr.fedorainfracloud.org/coprs/decathorpe/syncthing/
systemctl --user enable syncthing.service
systemctl --user enable syncthing-inotify.service  # ignore on RHEL
systemctl --user start syncthing.service
systemctl --user start syncthing-inotify.service  # ignore on RHEL

# Fonts
mkdir -p ~/.fonts/
cp -v --symbolic-link "$dir"/FiraCode/distr/otf/*.otf ~/.fonts/
cp -v --symbolic-link "$dir"/Iosevka/iosevka*/ttf/*.ttf ~/.fonts/
cp -v --symbolic-link "$dir"/monoid/Monoisome/Monoisome-Regular.ttf ~/.fonts/
fc-cache
