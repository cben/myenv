function ungit
	if pgrep -fa texstudio
		echo "!!! Refusing to open ungit — texstudio still running" | grep --color=auto .
		return 1
	else
		command ungit $argv
	end
end
