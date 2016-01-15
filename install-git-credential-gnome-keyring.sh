#!/bin/bash

# git-credential-gnome-keyring.c remembers HTTPS passwords.
# Makes Github 2FA bearable - generate token just once per machine at https://github.com/settings/tokens, type it in place of password, will be remembered.

# ‎This expects per-distro
# See also user.sh configuring to use it.

# This is somewhat silly & dirty, but it's distibuted as C source with git package, not
# distributed as binary, I don't want to submodule all of Git just for this small file, and it
# does #include some Git config so in-place `sudo make` works but a non-root build in a another
# directory would need a bit of setup...
MAKE="$(which colormake || which make)"
for DIR in \
        /usr/share/doc/git/contrib/credential/gnome-keyring \
	/usr/share/doc/git-core-doc/contrib/credential/gnome-keyring; do
    if [ -d "$DIR" ]; then
	sudo "$MAKE" -C "$DIR" &&
	    sudo ln -s -v "$DIR/git-credential-gnome-keyring" /usr/local/bin/
	exit
    fi
done
echo ERROR: git-credential-gnome-keyring.c not found.
