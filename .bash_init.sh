#!/bin/bash

is_local_accessable() {
    fping -c1 -t100 -p0 https://kutt.mm-ger.com/cIrLl7
    curl 
}

# Pull all necessary files here (either local or remote)



. .bash_style.sh
. .bash_env.sh
. .bash_fn.sh