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
    dnf-automatic \
    fish htop glances mlocate mtr nmap jq smartmontools \
    git-gui tig hub bzr hg meld nano emacs \
    ack the_silver_searcher renameutils \
    make automake gcc gcc-c++ kernel-devel \
    python-tools python3-tools python-ipython-console python3-ipython-notebook \
    nodejs \
    golang godep \
    linux-libertine-fonts levien-inconsolata-fonts adobe-source-code-pro-fonts \
    mozilla-fira-mono-fonts google-droid-sans-mono-fonts anka-coder-\*fonts mplus-1m-fonts \
    pandoc python3-markups python3-qt5 unicode-ucd qpdf diffpdf \
    pygpgme \
    redshift redshift-gtk mscore

# nodejs includes npm anyway since fedora 24
if ! rpm -ql nodejs | grep -q /bin/npm; then
  sudo dnf install npm || echo "@@@@@@@@@@@@@@@@@@@ FAILED npm package.  Do we have any version?  which npm -> $(which npm)"
fi

# Add repos
# =========

if ! rpm --quiet --query chromium; then
  sudo rpm --import https://repos.fedorapeople.org/repos/spot/chromium/spot.gpg
  sudo curl https://repos.fedorapeople.org/repos/spot/chromium/fedora-chromium-stable.repo -o /etc/yum.repos.d/fedora-chromium-stable.repo
fi

if ! rpm --quiet --query sysdig; then
  sudo rpm --import repo-stuff/syncthing-draios.gpg.key
  sudo cp -v repo-stuff/syncthing-draios.repo /etc/yum.repos.d/
fi

# http://rpmfusion.org/Configuration
# TODO: http!?  https gives cert for wrong domain + 404.
if ! rpm --query rpmfusion-free-release | grep -q rpmfusion-free-release-$(rpm -E %fedora); then
    # Keys from https://pgp.mit.edu/pks/lookup?search=RPM+Fusion+24 etc
    sudo rpm --import repo-stuff/rpmfusion-free-fedora$(rpm -E %fedora).gpg.key
    sudo dnf -y install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
fi
# TODO: do I want rpmfusion nonfree?

# https://unitedrpms.github.io/ is an alternative, at least for "central"
# packages like VLC.  TODO: might create conflicts?
#sudo rpm --import https://raw.githubusercontent.com/UnitedRPMs/unitedrpms.github.io/master/URPMS-GPG-PUBLICKEY-Fedora-24
#sudo dnf config-manager --add-repo=https://raw.githubusercontent.com/UnitedRPMs/unitedrpms.github.io/master/unitedrpms.repo

# From http://folkswithhats.org/fedy-installer
# TODO: http?! nogpgcheck!?
#rpm --quiet --query folkswithhats-release || sudo dnf -y --nogpgcheck install http://folkswithhats.org/repo/$(rpm -E %fedora)/RPMS/noarch/folkswithhats-release-1.0.1-1.fc$(rpm -E %fedora).noarch.rpm
#sudo dnf install fedy
# => fedy from submodule seems to work (bin/fedy)
sudo dnf install gjs dnf-plugins-core wget  # https://github.com/folkswithhats/fedy#dependencies

rpm --quiet --query hack-fonts || sudo dnf copr -y enable heliocastro/hack-fonts

rpm --quiet --query syncthing || sudo dnf copr -y enable decathorpe/syncthing

sudo dnf install \
     hack-fonts chromium sysdig \
     totem youtube-dl \
     syncthing syncthing-gtk

sudo dnf install vlc mplayer ffmpeg guvcview || echo "@@@@@@@@@@@@@@@@@@@ FAILED rpmfusion packages"

sudo dnf install libgnome-keyring-devel
./install-git-credential-gnome-keyring.sh

echo '== DOES THIS SYSTEM AUTO-UPDATE? =='
grep --with-filename _updates /etc/dnf/automatic.conf
