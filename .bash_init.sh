#!/bin/bash

# https://kutt.mm-ger.com/cIrLl7
# .bash_setup

get_hash() {
    #$1 file / folder
    #$2 include timestamps (true / false [true])
    #$3 include permissions (true / false [true])
    #$4 verbose (true / false [false])

    [ "$2" == true ] && {
        [ "$3" == true ] && {
            #yes timestamps && yes permissions
            i_stamps_6c832d21ffc152f2ac7d6248b2c94554="" && i_perms_93b95515cbb456bdb5964d20036d4a70=""
        } || {
            #yes timestamps && no permissions
            i_stamps_6c832d21ffc152f2ac7d6248b2c94554="" && i_perms_93b95515cbb456bdb5964d20036d4a70="--mode=777"
        }
    } || {
        [ "$3" == true ] && {
            #no timestamps && yes permissions
            i_stamps_6c832d21ffc152f2ac7d6248b2c94554="--mtime=0" && i_perms_93b95515cbb456bdb5964d20036d4a70=""
        } || {
            #no timestamps && no permissions
            i_stamps_6c832d21ffc152f2ac7d6248b2c94554="--mtime=0" && i_perms_93b95515cbb456bdb5964d20036d4a70="--mode=777"
        }
    }
    verbose_ce3fbd8f4250556689511e9ac73fce3d="false" && [ "$4" == true ] && {
        verbose_ce3fbd8f4250556689511e9ac73fce3d="true"
    }

    [ "$verbose_ce3fbd8f4250556689511e9ac73fce3d" == true ] && {
        start=$(awk 'NR==3 {print $3}' /proc/timer_list)
    }

    ! [ -n "$1" ] && {
        echo "No source provided"
        return 1
    } || {
        [ -d "$1" ] || [ -f "$1" ] || {
            echo "Provided source does not exist"
            return 2
        } && {
            [ $1 == "/" ] && {
                echo "root-directory not supported"
                return 3
            } || {
                source_parent_3fc9e42956785baf8387d1bc4700f861=$(dirname "$1")
                source_base_8ce0620f863c5b3ebaf083344cd28d3f=$(basename "$1")
                [ -d "$1" ] && {
                    tar -C "$source_parent_3fc9e42956785baf8387d1bc4700f861" $([ -n "$i_stamps_6c832d21ffc152f2ac7d6248b2c94554" ] && echo "$i_stamps_6c832d21ffc152f2ac7d6248b2c94554") $i_perms_93b95515cbb456bdb5964d20036d4a70 -cf - --sort=name "$source_base_8ce0620f863c5b3ebaf083344cd28d3f" | sha256sum | grep -ohE "^[0-9a-f]+"
                } || {
                    tar -C "$source_parent_3fc9e42956785baf8387d1bc4700f861" $([ -n "$i_stamps_6c832d21ffc152f2ac7d6248b2c94554" ] && echo "$i_stamps_6c832d21ffc152f2ac7d6248b2c94554") $i_perms_93b95515cbb456bdb5964d20036d4a70 -cf - --sort=name "$source_base_8ce0620f863c5b3ebaf083344cd28d3f" | sha256sum | grep -ohE "^[0-9a-f]+"
                }
            }
        }
    }

    [ "$verbose_ce3fbd8f4250556689511e9ac73fce3d" == true ] && {
        end=$(awk 'NR==3 {print $3}' /proc/timer_list)
        echo "Took $((($end - $start) / 1000 / 1000))ms"
    }
    unset verbose_ce3fbd8f4250556689511e9ac73fce3d
    unset source_parent_3fc9e42956785baf8387d1bc4700f861
    unset source_base_8ce0620f863c5b3ebaf083344cd28d3f
    unset i_stamps_6c832d21ffc152f2ac7d6248b2c94554
    unset i_perms_93b95515cbb456bdb5964d20036d4a70
}

is_local_accessable() {
    curl -s --connect-timeout 1 --max-time 3 https://git.mm-ger.com/markus/bash_env/raw/branch/main/README.md >/dev/null && {
        return 0
    } || {
        (fping -c1 -t100 -p0 git.mm-ger.com 2>&1 >/dev/null && exit 0 || exit 1) >/dev/null || {
            echo "Local Server not reachable" >&2
            echo "Falling back to Github"
            return 1
        } && {
            echo "Local Server pingable but Git Service offline" >&2
            echo "Falling back to Github"
            return 2
        }
    }
}

update() {
    is_local_accessable && {
        URL="https://git.mm-ger.com/markus/bash_env/archive/main.tar.gz" && TAR_ARGS="-xz"
    } || {
        URL="https://github.com/DasBossGit/bash_env/tarball/main" && TAR_ARGS="-xz"
    }
    mkdir $HOME/c60a76b43bf7578e99bf5dcd17bc240b -p && {
        chmod -R 777 $HOME/c60a76b43bf7578e99bf5dcd17bc240b && {
            curl -s --connect-timeout 1 --max-time 3 -L $URL | tar $TAR_ARGS --overwrite -C $HOME/c60a76b43bf7578e99bf5dcd17bc240b && {
                {
                    for file in $HOME/c60a76b43bf7578e99bf5dcd17bc240b/bash_env/*; do
                        cat $file >/usr/share/bash_env/$(basename "$file") || echo "Unable to modify \"$(basename "$file")\""
                    done
                }
                return 0
            } || {
                return 1
            }
        }
    }
}

shopt -s dotglob

# Pull all necessary files here (either local or remote)

# if first arg passed to script is empty, source all
# otherwise just download
update && {
    [ "$1" = "true" ] || {
        if [ -d /usr/share/bash_env ]; then
            [ -f /usr/share/bash_env/.bash_style.sh ] && {
                source /usr/share/bash_env/.bash_style.sh || {
                    echo "Unable to source /usr/share/bash_env/.bash_style.sh" >&2
                }
            } || {
                echo "File not found ( /usr/share/bash_env/.bash_style.sh )" >&2
            }
            [ -f /usr/share/bash_env/.bash_env.sh ] && {
                source /usr/share/bash_env/.bash_env.sh || {
                    echo "Unable to source /usr/share/bash_env/.bash_env.sh" >&2
                }
            } || {
                echo "File not found ( /usr/share/bash_env/.bash_env.sh )" >&2
            }
            [ -f /usr/share/bash_env/.bash_fn.sh ] && {
                source /usr/share/bash_env/.bash_fn.sh || {
                    echo "Unable to source /usr/share/bash_env/.bash_fn.sh" >&2
                }
            } || {
                echo "File not found ( /usr/share/bash_env/.bash_fn.sh )" >&2
            }
        fi
        unset -f is_local_accessable
        unset -f update
    }
} || {
    echo "Error while pulling profile" >&2
}
