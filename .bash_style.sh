#!/bin/bash

# 1st IN EXECUTION-FLOW

701a82e583105ab49dc3f83ba5fc24e5_PS1=


if [ -n "$BASH_VERSION" -o "$BB_ASH_VERSION" ]; then
    # PS1='\h:\w\$ '
    if [ $(id -u) -eq 0 ]; then
        # root user
        export 701a82e583105ab49dc3f83ba5fc24e5_PS1='___\n\e[31m\e[1m\u\e[39m@\e[33m\h\e[0m \e[94m'\''\w'\'' \e[92m\e[1m#\e[0m\e[0m\e[39m\e[49m '
    else
        # non root
        export 701a82e583105ab49dc3f83ba5fc24e5_PS1='___\n\e[92m\e[1m\u\e[39m@\e[33m\h\e[0m \e[94m'\''\w'\'' \e[92m\e[1m$\e[0m\e[0m\e[39m\e[49m '
    fi
    # use nicer PS1 for zsh
    elif [ -n "$ZSH_VERSION" ]; then
    701a82e583105ab49dc3f83ba5fc24e5_PS1='%m:%~%# '
    # set up fallback default PS1
else
    : "${HOSTNAME:=$(hostname)}"
    701a82e583105ab49dc3f83ba5fc24e5_PS1='${HOSTNAME%%.*}:$PWD'
    [ "$(id -u)" -eq 0 ] && 701a82e583105ab49dc3f83ba5fc24e5_PS1="${PS1}# " || 701a82e583105ab49dc3f83ba5fc24e5_PS1="${PS1}\$ "
fi


export 701a82e583105ab49dc3f83ba5fc24e5_PS1