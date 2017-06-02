# Bits of config and software I use

[![Greenkeeper badge](https://badges.greenkeeper.io/cben/myenv.svg)](https://greenkeeper.io/)

If you're not me, use with caution.

Works on Ubuntu 14.04 (I think, haven't tested for some time) or later.
`bin/` and `node_modules/.bin/` should be in PATH - as done in [.config/bin/config.fish](.config/bin/config.fish).

Installing on fresh machine involves `./fedora.sh` or `./full-ubuntu.sh` (`ubuntu.sh` if low on time/space), then `./PULL.sh`.
Per-user installation involves `./user.sh` and for me `beni.sh`.
Updating involves `PULL.sh` then committing (if submodules got updated) and re-running `ubuntu.sh` etc. (if that script changed).
I'm striving for *.sh to be idempotent.

License: Do whatever you want.  https://creativecommons.org/publicdomain/zero/1.0/

## GitHub 2FA tips (doesn't really belong here but useful bootstrapping new machine)

```
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
Upload ~/.ssh/id_rsa.pub to https://github.com/settings/ssh.
```
git clone --recursive github.com:cben/myenv  # easier to remember than `git@github.com:cben/myenv.git`, works.
```
Run user.sh to configure sweet `pushInsteadOf`.

TODO: creating 2FA token.
