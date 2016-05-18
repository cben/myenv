function PATH_prepend -a dir
    if echo $PATH | not grep -q $dir
        echo PATH_prepend $dir
        set -x PATH $dir $PATH
    end
end

# Detect where myenv/ was checked out, assuming this file is a symlink as installed by myenv/user.sh;
# if not a symlink this works out to ~/bin.
set myenv_dir (dirname (dirname (dirname (readlink --canonicalize ~/.config/fish/config.fish))))

if status --is-interactive
    echo "== running config.fish =="
    PATH_prepend $myenv_dir/bin
    PATH_prepend $myenv_dir/node_modules/.bin
    # pip install --user (default) goes to ~/.local
    PATH_prepend ~/.local/bin
    # some sbin tools are useful without root, e.g. mtr on fedora
    PATH_prepend /usr/sbin
end

# M-up is fish's single most time-saving key binding.
# Alas, it doesn't work in linux console.
# => Alias M-. (which did something similar in bash) to it.
bind \e. history-token-search-backward
