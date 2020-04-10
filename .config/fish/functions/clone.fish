# Defined in - @ line 2
function clone
	if not argparse --min-args=1 --stop-nonopt h-help -- $argv || set -q _flag_help
        echo "Usage: clone REPO [GIT-FLAGS...]"
        return
    end
    if git rev-parse --show-toplevel 2>/dev/null
        echo "Already inside a git directory, cd outside first."
        return 2
    end
    git clone $argv
    and cd (basename $argv[1] .git)
end
