#!/bin/bash
# These would be part of machine.sh but take too much space to
# install on all machines - notably on my chromebox.

source $(dirname "$0")/machine.sh

sudo-apt install \
    texlive texlive-latex-extra texlive-science \
    latexmk latexdiff texworks texstudio texlive-extra-utils \
    sagemath-upstream-binary
