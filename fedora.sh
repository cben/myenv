#!/bin/bash

set -e -u -o pipefail

cd "$(dirname "$0")"

# dropped non-free Skype etc — use Fedy

# I kinda like pressing <Enter> to confirm installation, but with dnf's [y/N] prompts
# having to press y <Enter> is too much :-)  defualtyes=1 makes dnf use [Y/n].
grep -q defaultyes /etc/dnf/dnf.conf || sudo sed --in-place -e '/\[main\]/adefaultyes=1' /etc/dnf/dnf.conf

sudo dnf install etckeeper
[ -d /etc/.git ] || [ -d /etc/.bzr ] || sudo etckeeper init

# Things from standard repos
# ==========================

#  --errorlevel=1 (deprecated but works) omits the "already installed" lines,
# (and unlike --quiet does show what it's going to do before asking y/n).
# I want the command to proceed partially even if it can't do all these;
# I'm not sure I want --allowerasing by default, so trying --setopt=strict=0
sudo dnf install --errorlevel=1 --setopt=strict=0 \
    dnf-automatic fedora-repos-rawhide \
    fish htop glances perf mlocate smartmontools acpi \
    mtr nmap socat inadyn-mt jq python-jwt w3m elinks miniupnpc avahi-tools \
    git git-lfs git-gui tig hub libgnome-keyring-devel bzr hg colordiff git-cinnabar meld gists nano emacs \
    the_silver_searcher ripgrep renameutils xsel entr progress \
    fortune-mod fortune-firefly figlet cowsay asciinema \
    make automake gcc gcc-c++ kernel-devel texinfo \
    python{2,34,3} python{,3}-tools python-ipython-console python3-ipython-notebook python{2,3}-virtualenv \
    nodejs \
    rust cargo \
    maven \
    haskell-platform ghc-regex-posix-devel \
    linux-libertine-fonts culmus-\*-fonts levien-inconsolata-fonts adobe-source-code-pro-fonts \
    mozilla-fira-{sans,mono}-fonts google-droid-sans-mono-fonts google-noto-{sans,serif,sans-mono}-fonts anka-coder-\*fonts mplus-1m-fonts \
    python3-markups python3-qt5 unicode-ucd qpdf diffpdf \
    python3-gpg python3-pyudev \
    chrome-gnome-shell gnome-tweak-tool \
    redshift redshift-gtk openbox obconf mscore

# Stuff I'm prone to compile
sudo dnf builddep ruby mscore

# nodejs included npm anyway at some point in fedora 24 (or was it from UnitedRPMs?)
if ! rpm -ql nodejs | egrep -q '^(/usr)?/bin/npm'; then
  sudo dnf install npm || echo "@@@@@@@@@@@@@@@@@@@ FAILED npm package.  Do we have any version?  which npm -> $(which npm)"
fi

# etcd 3.0.4 needed for kubernetes
#sudo dnf install --enablerepo rawhide etcd --best
# many golang programs need fresh golang
#sudo dnf install --enablerepo rawhide golang --best

# Add extra repos
# ===============

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
sudo dnf config-manager --set-disabled unitedrpms\*

# From http://folkswithhats.org/fedy-installer
# TODO: http?! nogpgcheck!?
#rpm --quiet --query folkswithhats-release || sudo dnf -y --nogpgcheck install http://folkswithhats.org/repo/$(rpm -E %fedora)/RPMS/noarch/folkswithhats-release-1.0.1-1.fc$(rpm -E %fedora).noarch.rpm
#sudo dnf install fedy
# => fedy from submodule seems to work (bin/fedy)
sudo dnf install gjs dnf-plugins-core wget  # https://github.com/folkswithhats/fedy#dependencies

rpm --quiet --query hack-fonts || sudo dnf copr -y enable heliocastro/hack-fonts

rpm --quiet --query syncthing || sudo dnf copr -y enable decathorpe/syncthing

rpm --quiet --query kitty || sudo dnf copr -y enable oleastre/kitty-terminal

# Install from extra repos
# ========================

sudo dnf install \
     hack-fonts chromium kitty sysdig \
     totem youtube-dl \
     syncthing syncthing-gtk

sudo dnf install vlc mplayer ffmpeg guvcview mkvtoolnix-gui || echo "@@@@@@@@@@@@@@@@@@@ FAILED rpmfusion packages"

sudo dnf update --refresh

# Non-dnf global stuff
./machine.sh

echo '== DOES THIS SYSTEM AUTO-UPDATE? =='
grep --with-filename _updates /etc/dnf/automatic.conf
