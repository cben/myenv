#!/bin/bash

# git-credential-libsecret.c remembers HTTPS passwords.
# Makes Github 2FA bearable - generate token just once per machine at https://github.com/settings/tokens, type it in place of password, will be remembered.

# See also user.sh configuring to use it.

# Fedora has it packaged.
[ -x /usr/libexec/git-core/git-credential-libsecret ] && exit

# This is somewhat silly & dirty, but it's distibuted as C source with git package, not
# distributed as binary, I don't want to submodule all of Git just for this small file, and it
# does #include some Git config so in-place `sudo make` works but a non-root build in a another
# directory would need a bit of setup...
MAKE="$(which colormake || which make)"
for DIR in \
        /usr/share/git/credential/libsecret \
        /usr/share/doc/git/contrib/credential/libsecret \
	    /usr/share/doc/git-core-doc/contrib/credential/libsecret; do
    if [ -d "$DIR" ]; then
	sudo "$MAKE" -C "$DIR" &&
	    sudo ln -s -v "$DIR/git-credential-libsecret" /usr/local/bin/ || true
	exit
    fi
done
echo ERROR: git-credential-libsecret.c not found.
