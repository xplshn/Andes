######################################
#### "Standard" POSIX SH library. ####
############################ Provides:
# spinner() available() require() palette() unnappear() log() log_error()

# shellcheck disable=SC2148 # We don't need a shebang. This script is loaded into running shells

# Display a spinner loader with the colors declared(or not!) in the COOLSPINNERCOLOR variable
spinner() {
	if [ -z "$COOLSPINNER" ]; then
		# shellcheck disable=SC1003 # We aren't trying to escape the Apostrophe. We are trying to escape the Backslash
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

unnappear() {
	"$@" >/dev/null 2>&1
}

# Check if a dependency is available.
available() {
	unnappear which "$1" || return 1
}

# Exit if a dependency is not available
require() {
    available "$1" || log_error "[$1] is not installed. Please ensure the command is available [$1] and try again."
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

# Function to log to stdout with optional color
log() {
    # Default color (no color)
    _ashstd_color_code=""
    _ashstd_reset="\033[m"

    # Check if the first argument is --color
    if [ "$1" = "--color" ]; then
        # Get the color code or ANSI code from the second argument
        case "$2" in
            RED) _ashstd_color_code="\033[31m" ;;
            YELLOW) _ashstd_color_code="\033[33m" ;;
            BLUE) _ashstd_color_code="\033[34m" ;;
            GREEN) _ashstd_color_code="\033[32m" ;;
            *) _ashstd_color_code="$2" ;;  # Treat the second argument as an ANSI code
        esac
        # Shift past the --color argument and color argument
        shift 2
    fi

    # Print the message with or without color
    printf "${_ashstd_color_code}->${_ashstd_reset} %s\n" "$*"
}

# Function to log errors in red and exit immediately
log_error() {
    log --color RED "$*"
    exit 1
}

# Function to log messages with leveled indentation
log_leveled() {
    log_function=""
    level=0

    # Parse the arguments
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --level)
                shift
                level="$1"
                #if [ $((level % 2)) -ne 0 ]; then
                #    log_error "Level must be an even number"
                #fi
                ;;
            *)
                log_function="$1"
                shift
                message="$*"
                break
                ;;
        esac
        shift
    done

    # Calculate the indentation
    spaces=""
    i=0
    while [ "$i" -lt "$level" ]; do
        spaces="$spaces "
        i=$((i + 1))
    done

    # Call the appropriate log function with indentation
    printf "%s" "${spaces}"
	# shellcheck disable=SC2086 # We want to split the $message variable.
    if [ "$log_function" = "log_error" ]; then
        $log_function $message >&2
    else
        $log_function $message
    fi
}
