#!/bin/bash
# Very early, currenty mostly stuff I'm installing for Mira.

## Skype dynamic deps - http://www.if-not-true-then-false.com/2012/install-skype-on-fedora-centos-red-hat-rhel-scientific-linux-sl/
#sudo dnf install alsa-lib.i686 fontconfig.i686 freetype.i686 glib2.i686 libSM.i686 libXScrnSaver.i686 libXi.i686 libXrandr.i686 libXrender.i686 libXv.i686 libstdc++.i686 pulseaudio-libs.i686 qt.i686 qt-x11.i686 zlib.i686 qtwebkit.i686

# Simpler: Skype 32bit for Fedora on 64bit - https://ask.fedoraproject.org/en/question/8738/sticky-how-do-i-install-skype-on-fedora/?answer=16444#post-id-16444
sudo dnf install libXv.i686 libXScrnSaver.i686 qt.i686 qt-x11.i686 pulseaudio-libs.i686 pulseaudio-libs-glib2.i686 alsa-plugins-pulseaudio.i686
# TODO: obsolete by Fedy?


sudo dnf install fish htop glances gitk bzr nano emacs

# Add repos
# =========

# http://rpmfusion.org/Configuration
sudo dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# From http://folkswithhats.org/fedy-installer
rpm --quiet --query folkswithhats-release || sudo dnf -y --nogpgcheck install http://folkswithhats.org/repo/$(rpm -E %fedora)/RPMS/noarch/folkswithhats-release-1.0.1-1.fc$(rpm -E %fedora).noarch.rpm

sudo dnf install vlc fedy

