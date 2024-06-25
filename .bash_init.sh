#!/bin/bash

is_local_accessable() {
    #fping -c1 -t100 -p0 https://kutt.mm-ger.com/cIrLl7
    curl --connect-timeout 1 --max-time 3 https://git.mm-ger.com/markus/bash_env/archive/main.tar.gz
}
get_hash() {
    ! [ -n "$1" ] && {
        echo "No root-dir provided"
        return false
    } || {
        ! [ -d "$1" ] && {
            echo "Provided root-dir does not exist"
            return false
        }
    }
    #tar -C /usr/share/ -cf - --sort=name bash_env | sha256sum
}
get_hash /root

# Pull all necessary files here (either local or remote)

. .bash_style.sh
. .bash_env.sh
. .bash_fn.sh
