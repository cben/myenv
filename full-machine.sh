#!/bin/bash
# These would be part of machine.sh but take too much space to
# install on all machines - notably on my chromebox.
# Dropbox itself is not heavy but it brings a lot of files :-)

source $(dirname "$0")/machine.sh

sudo-apt install \
    nautilus-dropbox \
    texlive texlive-latex-recommended texlive-latex-extra texlive-extra-utils \
    texlive-fonts-extra texlive-science texlive-humanities texlive-lang-{hebrew,cyrillic} \
    latexmk latexdiff texworks texstudio auctex emacs-goodies-el \
    haskell-platform \
    sagemath-upstream-binary

# Up to date pandoc.  Will compile in ~/.cabal but install in /usr/local.
# (The only reason I'm installing here globally instead of per-user is saving space.)
cabal update
cabal install --flags="embed_data_files" hsb2hs pandoc pandoc-citeproc --global --root-cmd=sudo
# Alternative for the record: there seems to be no PPA; to find latest official .deb:
#     curl https://api.github.com/repos/jgm/pandoc/releases/latest |
#         jq '.[] | .assets[] | .browser_download_url | select(endswith(".deb"))' --raw-output
