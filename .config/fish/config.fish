function PATH_prepend -a dir
    if echo $PATH | not grep -q -x "$dir"
        echo (string escape PATH_prepend $dir)
        set -x PATH $dir $PATH
    end
end

# Detect where myenv/ was checked out, assuming this file is a symlink as installed by myenv/user.sh;
# if not a symlink this works out to ~/bin.
set myenv_dir (dirname (dirname (dirname (readlink --canonicalize ~/.config/fish/config.fish))))

# https://github.com/rbenv/rbenv#installation, modified to be under myenv/
set -x RBENV_ROOT $myenv_dir/rbenv

if status --is-interactive
    echo "== running config.fish =="
    PATH_prepend $myenv_dir/bin
    PATH_prepend $myenv_dir/node_modules/.bin
    PATH_prepend $myenv_dir/rbenv/shims
    # pip install --user (default) goes to ~/.local
    PATH_prepend ~/.local/bin
    # go get installs binaries here
    if [ -n "$GOPATH" ]
        PATH_prepend $GOPATH/bin
    end
    if [ -d ~/.cargo/bin ]
        PATH_prepend ~/.cargo/bin
    end
    # https://krew.sigs.k8s.io/docs/user-guide/setup/install/
    PATH_prepend ~/.krew/bin
    # some sbin tools are useful without root, e.g. mtr on fedora
    PATH_prepend /usr/sbin

    # M-up is fish's single most time-saving key binding.
    # Alas, it doesn't work in linux console.
    # => Alias M-. (which did something similar in bash) to it.
    bind \e. history-token-search-backward

    # https://github.com/chriskempson/base16-shell
    set -x BASE16_SHELL "$HOME/.config/base16-shell/"
    # Disabled, conflicts with gnome-terminal's theming
    #source "$BASE16_SHELL/profile_helper.fish"

    fortune | eval (printf cowsay\ncowthink\n | shuf -n1) -n -f (ls /usr/share/cowsay/**.cow | grep -v -e sodomized -e telebears -e head-in | shuf -n1)
end
