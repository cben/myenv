#!/usr/bin/env fish

set -U -x BLOCK_SIZE \'1
set -U -x EDITOR 'emacsclient --alternate-editor= -c'
set -U -x MANPAGER 'less --quit-if-one-screen --no-init'
set -U -x MAN_KEEP_FORMATTING (random)

# This used to attept diffing old to new state but it doesn't work due to
# https://github.com/fish-shell/fish-shell/issues/2151
