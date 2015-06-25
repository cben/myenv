#!/usr/bin/env fish
set old (mktemp)
set -U -x > $old

set -U -x BLOCK_SIZE \'1
set -U -x EDITOR 'emacsclient --alternate-editor= -c'
set -U -x MANPAGER 'less --quit-if-one-screen --no-init'
set -U -x MAN_KEEP_FORMATTING 1

set new (mktemp)
set -U -x > $new
d $old $new
rm $old $new
