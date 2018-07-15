function texstudio
	if pgrep -fa ungit
		echo "!!! Refusing to open editor — ungit still running" | grep --color=auto .
		echo "    Tip: pkill -f ungit"
		return 1
	else
		command texstudio $argv
	end
end
