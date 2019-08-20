# Defined in - @ line 2
function clone
	if git rev-parse --show-toplevel 2>/dev/null
        echo "Already inside a git directory, cd outside first."
        exit 2
    end
    git clone $argv[1]
    and cd ~/(basename $argv[1] .git)
end
