#!/bin/bash

# 2nd IN EXECUTION-FLOW

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

export NVIM="/usr/bin/nvim"

wget -T 2 -q -O ~/.vimrc_git https://gist.githubusercontent.com/DasBossGit/29a0d68075f4c979adabc429e9172089/raw
if [ -f ~/.vimrc ]; then

    export VISUAL="$NVIM -u ~/.vimrc"
    export VIMRC="~/.vimrc"
elif [ -f ~/.vimrc ]; then
    export VISUAL="$NVIM -u ~/.vimrc_git"
    export VIMRC="~/.vimrc_git"
else
    export VISUAL="$NVIM"
    export VIMRC=""
fi

export PS1="${a01a82e583105ab49dc3f83ba5fc24e5_PS1}"

export PAGER=less
export EDITOR="$VISUAL"

unset a01a82e583105ab49dc3f83ba5fc24e5_PS1
