if status --is-interactive
    if not contains ~/myenv/bin $PATH
        echo "== running config.fish =="
        set -x PATH ~/myenv/bin $PATH
    end
end

# M-up is fish's single most time-saving key binding.
# Alas, it doesn't work in linux console.
# => Alias M-. (which did something similar in bash) to it.
bind \e. history-token-search-backward
