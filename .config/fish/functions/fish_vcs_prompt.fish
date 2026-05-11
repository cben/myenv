function fish_vcs_prompt --description 'Print all vcs prompts'
    # If a prompt succeeded, we assume that it's printed the correct info.
    # This is so we don't try svn if git already worked.
    fish_git_prompt $argv
    or fish_hg_prompt $argv
    # The svn prompt is disabled by default because it's quite slow on common svn repositories.
    # To enable it uncomment it.
    # You can also only use it in specific directories by checking $PWD.
    # or fish_svn_prompt
    if pwd | grep -q "^$HOME/Dropbox"
        echo -n " [📦$(timeout 0.2 dropbox-cli filestatus . 2>/dev/null)]"
    end
end
