#!/bin/sh

# shellcheck disable=SC1091 #--------------------------------------------------------------------|
# We intend to load std.sh this way. ------------------------------------------------------------|
# Load the Andes SH library ---------------------------------------------------------------------|
[ -f "./layout/etc/profile.d/std.sh" ] && {
	. ./layout/etc/profile.d/std.sh || log_error "We cannot proceed without the Andes SH library"
	}
# -----------------------------------------------------------------------------------------------|

# Define directories
xROOTFS="./outfs"
REPO_DIR="./a-utils"
BUILD_DIR="$REPO_DIR/built"
BIN="$xROOTFS/opt/andes/bin"
USR_BIN="$xROOTFS/opt/andes/usr/bin"

prepare() {
	# Add, use, remove
	if ! command -v go >/dev/null 2>&1; then
		apk add go >/dev/null 2>&1
	else
		apk del go >/dev/null 2>&1
	fi
}

# Function to update and build the repository
update_and_build() {
	if [ -d "$REPO_DIR" ]; then
		cd "$REPO_DIR" || exit 1
		git pull && sh ./build.sh
		cd - || exit 1
	else
		git clone https://github.com/xplshn/a-utils "$REPO_DIR"
		cd "$REPO_DIR" || exit 1
		sh ./build.sh
		cd - || exit 1
	fi
}

# Function to copy built files
copy_files() {
	mkdir -p "$USR_BIN"
	for file in "$BUILD_DIR"/*; do
		[ -f "$file" ] && cp "$file" "$USR_BIN/"
	done
}

# Function to clean up build artifacts
clean_build() {
	cd "$REPO_DIR" || exit 1
	sh ./build.sh clean full
	cd - || exit 1
}

# Function to add the latest release of Bigdl
add_bigdl() {
	ARCH="$(uname -m)"
	case "$ARCH" in
	x86_64) ARCH_SUFFIX="amd64" ;;
	aarch64) ARCH_SUFFIX="arm64" ;;
	*) echo "Unsupported architecture: $ARCH" && exit 1 ;;
	esac
	BIGDL_URL="https://github.com/xplshn/bigdl/releases/latest/download/bigdl_${ARCH_SUFFIX}"
	if command -v wget >/dev/null 2>&1; then
		wget -q "$BIGDL_URL" -O "$BIN/bigdl"
	elif command -v curl >/dev/null 2>&1; then
		curl -qfsSL "$BIGDL_URL" -o "$BIN/bigdl"
	else
		echo "Neither wget nor curl is available." && exit 1
	fi
	chmod +x "$BIN/bigdl"
	unset ARCH ARCH_SUFFIX BIGDL_URL
}

# Main() defines the correct order of all the steps. That's all a main() function should do.
main() {
	if available apk && ! available go; then
		log --color "GREEN" 'Entering step: "Prepare to build Go packages"' && {
			prepare || log_leveled --level 3 log --color "RED" 'Failed at step: "Prepare to build Go packages" (!prepare)'
		}
	fi
	log_leveled --level 3 log --color "GREEN" 'Entering step: "Build Go Packages"' && {
		update_and_build || log_leveled --level 6 log_error 'Failed at step: "Build Go Packages" (!update_and_build)'
	}
	log_leveled --level 6 log --color "GREEN" 'Entering step: "Copy resulting binaries"' && {
		copy_files || log_leveled --level 9 log_error 'Failed at step: "Copy resulting binaries" (!copy_files)'
	}
	log --color "GREEN" 'Entering step: "Clean build directories and host system"' && {
		clean_build || log_leveled --level 3 log_error 'Failed at step: "Clean build directories and host system" (!clean_build)'
	}
	log --color "GREEN" 'Entering step: "Add the latest release of the Bigdl distribution system"' && {
		add_bigdl || log_leveled --level 3 log_error 'Failed at step: "Add the latest release of the Bigdl distribution system" (!add_bigdl)'
	}
	if available apk && require go; then
		log --color "GREEN" 'Entering step: "Finalize system build process"' && {
			prepare || log_leveled --level 3 log_error 'Failed at step: "Finalize system build process" (!prepare)'
		}
	fi
	log --color "GREEN" "The ROOTFS has been prepared"
	unset xROOTFS REPO_DIR BUILD_DIR BIN USR_BIN
}
main
