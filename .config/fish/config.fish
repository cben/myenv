if status --is-interactive
    if not contains ~/myenv/bin $PATH
        echo "== running config.fish =="
        set -x PATH ~/myenv/bin $PATH
    end
end
