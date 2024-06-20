#!/bin/bash

is_local_accessable() {
    #fping -c1 -t100 -p0 https://kutt.mm-ger.com/cIrLl7
    curl --connect-timeout 1 --max-time 3 https://git.mm-ger.com/markus/bash_env/archive/main.tar.gz
}
get_hash() {
    find /usr/share/bash_env -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum
}



# Pull all necessary files here (either local or remote)



. .bash_style.sh
. .bash_env.sh
. .bash_fn.sh