#!/bin/sh

add_dir_to_path() {
    if [ -d "$1" ] && [ "$(find "$1" -mindepth 1 -print -quit 2>/dev/null)" ]; then
        if [ "$SUPERSEDE" = "1" ]; then
            PATH="$1:$PATH"
        else
            PATH="$PATH:$1"
        fi
        export PATH
    fi
}

add_dir_to_manpath() {
    if [ -d "$1" ] && [ "$(find "$1" -mindepth 1 -print -quit 2>/dev/null)" ]; then
        if [ -z "$MANPATH" ]; then
            MANPATH="$1"
        else
            MANPATH="$1:$MANPATH"
        fi
        export MANPATH
    fi
}

add_dir_to_ldpath() {
    LDSOCFG_FILE="/etc/ld.so.conf"
    if [ -d "$1" ]; then
        echo "$1" >> "$LDSOCFG_FILE"
    fi
}

# Add these to your PATH if they exist             # =-----------=
SUPERSEDE=1; add_dir_to_path /opt/andes/poly/bin   # Priority N. 1
SUPERSEDE=1; add_dir_to_path /opt/andes/usr/bin    # Priority N. 2
SUPERSEDE=1; add_dir_to_path /opt/andes/bin        # Priority N. 3
SUPERSEDE=0; add_dir_to_path /opt/bigdl/usr/bin    # Priority N. L
# Add these to your LD_LIBRARY_PATH if they exist  # =-----------=
add_dir_to_ldpath /opt/andes/poly/lib              # Priority N. 1
add_dir_to_ldpath /opt/andes/usr/lib               # Priority N. 2
add_dir_to_ldpath /opt/andes/lib                   # Priority N. 3
# Add these to your MANPATH if they exist          # =-----------=
add_dir_to_manpath /opt/andes/poly/usr/share/man   # Priority N. 1
add_dir_to_manpath /opt/andes/usr/share/man        # Priority N. 2
add_dir_to_manpath /usr/local/share/man            # Priority N. 3
add_dir_to_manpath /usr/share/man                  # Priority N. 4
#                                                  # =-----------=
export FORTUNE_PATH="/opt/andes/usr/share/fortunes"
