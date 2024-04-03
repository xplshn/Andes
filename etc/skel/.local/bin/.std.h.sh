#### "Standard" POSIX SH library. ####
#############################Provides:

# spinner() require() palette()

# Extras: wttr()

# Display a spinner loader with the colors declared(or not!) in the COOLSPINNERCOLOR variable
spinner() {
	if [ -z "$COOLSPINNER" ]; then
		COOLSPINNER='|/-\\'
	fi

	if [ -z "$COOLSPINNER_COLOR" ]; then
		COOLSPINNER_COLOR='\033[0m'
	fi

	if [ -z "$COOLSPINNER_DELAY" ]; then
		COOLSPINNER_DELAY=0.1
	fi

	len=$(printf "%s" "$COOLSPINNER" | wc -c | awk '{print $1}')
	trap 'printf "\033[?25h"; exit' INT

	while true; do
		i=1
		while [ "$i" -le "$len" ]; do
			char=$(printf "%s" "$COOLSPINNER" | cut -c "$i")
			if [ -n "$COOLSPINNER_COLOR" ]; then
				printf "%b%s%b" "$COOLSPINNER_COLOR" "$char" "\033[0m"
			else
				printf "%s" "$char"
			fi
			sleep "$COOLSPINNER_DELAY"
			printf "\r"
			i=$((i + 1))
		done
	done
}

# Check if a dependency is available.
available() {
	which "$1" >/dev/null 2>&1
}

# Exit if a dependency is not available
require() {
	if ! available; then
		printf "Error: %s is not in $PATH\n" "$1" >&2
	fi
}

# Display a color palette of N colors with(out) text.
palette() {
	[ -z "$COOLPALETTE" ] && COOLPALETTE=16
	p_display() {
		for c in $(seq 0 "$((COOLPALETTE - 1))"); do
			[ "$COOLPALETTE_TEXT" = "0" ] && printf '\033[48;5;%dm ' "$c" || printf '\033[48;5;%dm%3d' "$c" "$c"
		done
		printf '\033[0m\n'
	}
	p_display
}

unnappear() {
	"$@" >/dev/null 2>&1
}

whoch() {
	# Function to search for the command in PATH
	search_command_in_path() {
		command_to_find="$1"
		found=false

		IFS=:
		for dir in $PATH; do
			if [ -x "$dir/$command_to_find" ]; then
				echo "$dir/$command_to_find"
				found=true
			fi
		done

		if [ "$found" = false ]; then
			echo "Command '$command_to_find' not found in PATH" >&2
			exit 1
		fi
	}

	# Main function
	main_whoch() {
		search_command_in_path "$1"
	}

	# Execute main function with arguments
	case "$1" in
	"-a")
		main_whoch "$2" | awk '!seen[$0]++'
		;;
	"--aa")
		main_whoch "$2"
		;;
	*)
		main_whoch "$@" | head -n 1
		;;
	esac
}

#wttr() {
#	get_weatherData() {
#		if [ -n "$1" ]; then
#			location="$1"
#			if [ -n "$2" ]; then
#				params="$2"
#			else
#				params="0Qn"
#			fi
#			curl --max-time 2 --silent "wttr.in/$location?$params"
#		else
#			printf "No location provided. Usage: wttr <location> <params[see curl wttr.in/:help]>\n"
#		fi
#	}
#	main_wttr() {
#		# Start and capture.
#		get_weatherData "$1" "$2" >/tmp/._alt_wttr.txt &
#		wttr_pid=$!
#
#		# Show spinner animation while pfetch is running
#		spinner &
#		spinner_pid=$!
#
#		# Wait for it to finish
#		wait $wttr_pid
#
#		# Once its output is ready, kill the spinner and display the output
#		kill $spinner_pid >/dev/null 2>&1
#
#		# Clear spinner output
#		printf "\b"
#	}
#	# Show output and cleanup
#	require curl
#	main_wttr "$1" "$2"
#	cat /tmp/._alt_wttr.txt
#	rm /tmp/._alt_wttr.txt
#}
