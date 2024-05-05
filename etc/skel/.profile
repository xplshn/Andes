# System options:
export ENV="$HOME/.shrc"
if [ -z "$XDG_RUNTIME_DIR" ]; then
        XDG_RUNTIME_DIR="/tmp/.$(id -u)-runtime-dir"

        mkdir -pm 0700 "$XDG_RUNTIME_DIR"
        export XDG_RUNTIME_DIR
fi
export XDG_DATA_DIRS="$HOME/.local/share:/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="$HOME/.config"
export POSIXLY_CORRECT=1
export PATH="$PATH:$HOME/.local/bin"

# User prefferences:
export MINPS1="1" # Makes /etc/skel/.shrc show your "$HOSTNAME"
export LOCATION="Berkeley" # Used for WTTR (function declared in /etc/skel/.local/bin/.std.h.sh) in /etc/skel/.shrc
export COOLHOME="]" # The indicator used with hpwd to indicate that the dir you in "$HOME"
export COOLHOME_DEPTH="$COOLHOME" # The indicator used with hpwd to indicate that the dir you are in is at "$HOME" or a subdirectory of "$HOME"
export COOLSPINNER="|/-\\" # For a BSD styled spinner animation in scripst that use /etc/skel/.local/bin/.std.h.sh
export COOLSPINNER_COLOR='\033[32m' # Green spinner/loading animation.
#Other relevant variables include: $EDITOR, $BROWSER

# pfetch prefferences
export PF_INFO="ascii title os host kernel uptime shell term editor pkgs memory palette" #export PF_SEP="@→"

# pbundle options # Use with caution, some programs may behave erraticaly. # NOTE: You should not be using bundles for anything serious.
export USE_SYSTEM_LIBRARIES=1 # PELF bundles will try to use the available system libraries and only use bundled ones if needed. (Reduces RAM consumption, by a lot. Slight increase in start up time.)
export USE_BULKLIBS=0 # If set to one: Makes bundles BULK their libraries to a directory, this way if two programs depend on, e. g, libXft, the program which contains the more recent libXft version will be used, this also saves RAM because programs are using (bundled)"shared" libraries.

# Go options:
export CGO_ENABLED=0
export GOFLAGS="-ldflags=-static -ldflags=-s -ldflags=-w"
export GO_LDFLAGS="-buildmode=pie"
#export GOROOT="/usr/local/go"
export GOCACHE="$HOME/.cache/go"
export GOBIN="$HOME/.local/bin"
export GOPATH="$HOME/.cache/go"
# Zig options:
export ZIG_LIBC_TARGET="x86_64-linux-musl"
# Rust options:
export RUSTFLAGS="-C link-arg=-s"
export RUSTUP_HOME="$HOME/.cache/rs_rustup"
export CARGO_HOME="$HOME/.cache/rs_cargo"
# C options:
#export LDFLAGS="-static" # Only for binaries
#export CFLAGS="-fPIE -fPIC -static"
