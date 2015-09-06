if status --is-interactive
    if not contains ~/myenv/bin $PATH
        echo "== running config.fish =="
        # Detect where myenv/ was checked out, assuming this file is a symlink as installed by myenv/user.sh;
        # if not a symlink this works out to ~/bin.
        set -x PATH (dirname (dirname (dirname (readlink --canonicalize ~/.config/fish/config.fish))))/bin $PATH
    end
end

# M-up is fish's single most time-saving key binding.
# Alas, it doesn't work in linux console.
# => Alias M-. (which did something similar in bash) to it.
bind \e. history-token-search-backward
