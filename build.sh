#!/bin/sh

# shellcheck disable=SC1091 # This is intended. We want to load all of the functions defined in the SH library of Andes
. ./layout/etc/profile.d/std.sh

minROOTFS(){
    [ "$(id -u)" = 0 ] || log_error "Script needs to be run as root"
    if [ -f "$PWD/alpine-make-rootfs" ]; then
        log --color "GREEN" "Entering 1st step. \"Building ROOTFS\""
        log_leveled --level 3 log --color "GREEN" "Calling ./alpine-make-rootfs"
        exec ./alpine-make-rootfs --packages "apk-tools alpine-conf" -s ./layout ./outfs ./gen.sh
    fi
}

bootableROOTFS(){
    [ "$(id -u)" = 0 ] || log_error "Script needs to be run as root"
    if [ -f "$PWD/alpine-make-rootfs" ]; then
        log --color "GREEN" "Entering 1st step. \"Building a ROOTFS suitable to boot bare-metal\""
        log_leveled --level 3 log --color "GREEN" "Calling ./alpine-make-rootfs"
        ./alpine-make-rootfs --packages "apk-tools alpine-conf alpine-base linux-lts grub grub-efi efibootmgr" -s ./layout ./outfs ./gen.sh
    fi
}

show_help(){
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -m, --min         Build a minimal Andes ROOTFS. The same amount of packages as the Alpine ROOTFS but with the sugar coating of Andes"
    echo "  -b, --bootable    Build a ROOTFS suitable to boot bare-metal (linux kernel, grub, setup-* scripts to install the booted system)."
    echo "  -h, --help        Show this help message and exit."
    echo
}

# Parse arguments
case "$1" in
    "-m"|"--min")
        minROOTFS
        ;;
    "-b"|"--bootable")
        bootableROOTFS
        ;;
    "-h"|"--help")
        show_help
        ;;
    *)
        echo "Usage: $0 ![-h] ![-m|--min] or ![-b|--bootable]"
        exit 1
        ;;
esac
