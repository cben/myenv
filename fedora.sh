#!/bin/bash

# Very early, currenty mostly stuff I'm installing for Mira.

set -e -u -o pipefail  # TODO untested in this script

cd "$(dirname "$0")"

## Skype dynamic deps - http://www.if-not-true-then-false.com/2012/install-skype-on-fedora-centos-red-hat-rhel-scientific-linux-sl/
#sudo dnf install alsa-lib.i686 fontconfig.i686 freetype.i686 glib2.i686 libSM.i686 libXScrnSaver.i686 libXi.i686 libXrandr.i686 libXrender.i686 libXv.i686 libstdc++.i686 pulseaudio-libs.i686 qt.i686 qt-x11.i686 zlib.i686 qtwebkit.i686

# Simpler: Skype 32bit for Fedora on 64bit - https://ask.fedoraproject.org/en/question/8738/sticky-how-do-i-install-skype-on-fedora/?answer=16444#post-id-16444
#sudo dnf install libXv.i686 libXScrnSaver.i686 qt.i686 qt-x11.i686 pulseaudio-libs.i686 pulseaudio-libs-glib2.i686 alsa-plugins-pulseaudio.i686
# TODO: obsolete by Fedy?


sudo dnf install \
    fish htop glances mlocate mtr nmap \
    git-gui tig bzr meld nano emacs \
    ack the_silver_searcher \
    make automake gcc gcc-c++ kernel-devel \
    python-tools python3-tools \
    nodejs npm \
    mscore

# Add repos
# =========

if ! rpm --quiet --query chromium; then
  sudo rpm --import https://repos.fedorapeople.org/repos/spot/chromium/spot.gpg
  sudo curl https://repos.fedorapeople.org/repos/spot/chromium/fedora-chromium-stable.repo -o /etc/yum.repos.d/fedora-chromium-stable.repo
fi

if ! rpm --quiet --query sysdig; then
  sudo rpm --import draios.gpg.key
  sudo cp -v draios.repo /etc/yum.repos.d/
fi

# http://rpmfusion.org/Configuration
# TODO: http!?  https gives cert for wrong domain + 404.
if ! rpm --quiet --query rpmfusion-free-release; then
    sudo rpm --import rpmfusion-free-fedora23.gpg.key
    sudo dnf -y install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
fi
# TODO: do I want rpmfusion nonfree?

# From http://folkswithhats.org/fedy-installer
# TODO: http?! nogpgcheck!?
#rpm --quiet --query folkswithhats-release || sudo dnf -y --nogpgcheck install http://folkswithhats.org/repo/$(rpm -E %fedora)/RPMS/noarch/folkswithhats-release-1.0.1-1.fc$(rpm -E %fedora).noarch.rpm
#sudo dnf install fedy
# => fedy from submodule seems to work (bin/fedy)
sudo dnf install gjs dnf-plugins-core wget  # https://github.com/folkswithhats/fedy#dependencies

rpm --quiet --query syncthing || sudo dnf copr -y enable decathorpe/syncthing

sudo dnf install \
     chromium sysdig \
     vlc totem mplayer youtube-dl ffmpeg \
     syncthing syncthing-gtk

sudo dnf install libgnome-keyring-devel
./install-git-credential-gnome-keyring.sh
