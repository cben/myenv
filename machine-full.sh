#!/bin/bash
# These would be part of machine.sh but take too much space to
# install on all machines - notably on my chromebox.
# Dropbox itself is not heavy but it brings a lot of files :-)

source $(dirname "$0")/machine.sh

sudo-apt install \
    nautilus-dropbox \
    texlive texlive-latex-recommended texlive-latex-extra texlive-science texlive-humanities \
    latexmk latexdiff texworks texstudio texlive-extra-utils \
    sagemath-upstream-binary
