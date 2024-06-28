#!/bin/bash

# 1st IN EXECUTION-FLOW

a01a82e583105ab49dc3f83ba5fc24e5_PS1=

if [ -n "$BASH_VERSION" ]; then
    # PS1='\h:\w\$ '
    [ $(id -u) -eq 0 ] && {
        # root user
        export a01a82e583105ab49dc3f83ba5fc24e5_PS1=$'\e[1m─────\e[0m\n\n\e[31m ┌─\e[0m\e[31m [ \e[31m\e[1m\e[4m\u\e[0m\e[31m ]\e[0m \e[39mon \e[33m[ \e[1m\h\e[0m\e[33m ]\e[0m \e[39mat \e[94m'\''\w'\''\n\e[31m └─ \e[38;5;208m( \e[3m$((++cc3714829ee35e79906f604f8ffc2ec2))\e[0m\e[38;5;208m )\e[0m \e[92m➜\e[0m\e[39m\e[49m  '
    } || {
        # non root
        export a01a82e583105ab49dc3f83ba5fc24e5_PS1=$'\e[1m─────\e[0m\n\n\e[31m ┌─\e[0m\e[92m [ \e[92m\e[1m\e[1m\u\e[0m\e[92m ]\e[0m \e[39mon \e[33m[ \e[1m\h\e[0m\e[33m ]\e[0m \e[39mat \e[94m'\''\w'\''\n\e[31m └─ \e[38;5;208m( \e[3m$((++cc3714829ee35e79906f604f8ffc2ec2))\e[0m\e[38;5;208m )\e[0m \e[92m➜\e[0m\e[39m\e[49m  '
    }
    PS1=$a01a82e583105ab49dc3f83ba5fc24e5_PS1
# use nicer PS1 for zsh
#elif [ -n "$ZSH_VERSION" ]; then
#    a01a82e583105ab49dc3f83ba5fc24e5_PS1='%m:%~%# '
#    # set up fallback default PS1
#else
#    : "${HOSTNAME:=$(hostname)}"
#    a01a82e583105ab49dc3f83ba5fc24e5_PS1='${HOSTNAME%%.*}:$PWD'
#    [ "$(id -u)" -eq 0 ] && a01a82e583105ab49dc3f83ba5fc24e5_PS1="${PS1}# " || a01a82e583105ab49dc3f83ba5fc24e5_PS1="${PS1}\$ "
fi

export a01a82e583105ab49dc3f83ba5fc24e5_PS1
echo "test"