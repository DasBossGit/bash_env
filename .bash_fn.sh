#!/bin/bash

# 3rd IN EXECUTION-FLOW

g() {
    grep -E "$@"
}
vi() {
    nvim "$@"
}
vim() {
    nvim "$@"
}
nvim() {
    [ -n $VIMRC ] && {
        "$NVIM" -u "$VIMRC" "$@"
    } || {
        "$NVIM" "$@"
    }
}
neovim() {
    nvim "$@"
}
e() {
    nvim "$@"
}
dash() {
    doas bash
}
7e54560f_062b_51b2_9f26_f00f8fffab07_setup_netcat() {
    echo ""
    #if ! [ -x "$(command -v nc)" ]; then
    #    echo "netcat not found" >&2
    #    #        echo "Installing..."
    #    #        if ! [ -d /tmp/ ]; then
    #    #            mkdir /tmp/
    #    #            if ! [ -d /tmp/setup/ ]; then
    #    #                mkdir /tmp/setup/
    #    #            fi
    #    #        fi
    #    #        if [ -d /tmp/setup ]; then
    #    #            echo "apk add netcat-openbsd" >/tmp/setup/netcat.sh
    #    #            if [ -x "$(command -v doas bash /tmp/setup/netcat.sh)" ]; then
    #    #                nc_send() {
    #    #                    echo "test"
    #    #                }
    #    #                nc_recv() {
    #    #                    echo "test"
    #    #                }
    #    #            fi
    #    #        fi
    #    #    else
    #    #        echo "netcat already installed"
    #fi
}
#7e54560f_062b_51b2_9f26_f00f8fffab07_setup_netcat

1d1ab111_4032_5106_a3d0_8d92c577a228_setup_local_gist() {
    echo ""
    #fping -c1 -t100 -p0 192.168.1.10 https://nextcloud.mm-ger.com/s/3ak88933J3W444
}
#1d1ab111_4032_5106_a3d0_8d92c577a228_setup_local_gist

71d317a8_cda4_5b65_bbb2_96537c38ee81_setup_powershell() {
    echo ""
}

echo 'Old line'
echo -e '\e[1A\e[Knew line'
