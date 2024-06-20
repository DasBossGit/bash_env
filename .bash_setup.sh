<<EOF #Start multiline comment
if ! [ $BASH ]; then
    echo "Needs to be run from BASH!"
fi
if ! [ -x "$(
    command -v bash
)" ]; then
    echo "BASH not installed..."
    doas apk add bash
fi
setup_bash() {
    which nvim
}

get_default_shell() {

}
#End multiline comment
EOF

#check if root
{
    if [ $(id -u) -ne 0 ]; then
        echo "Needs to be run as root" >&2
        exit
    fi
}

#check repositories
{
    if ! test -f /etc/apk/repositories; then
        touch /etc/apk/repositories && chmod 777 /etc/apk/repositories
    fi
    repositories_file=$(cat /etc/apk/repositories)
    repositories="""http://dl-cdn.alpinelinux.org/alpine/v3.19/main
http://dl-cdn.alpinelinux.org/alpine/v3.19/community
http://mirror.bahnhof.net/pub/alpinelinux/v3.19/main
http://mirror.bahnhof.net/pub/alpinelinux/v3.19/community"""
    if ! grep -Rq "#/media/cdrom/apks" <<<$repositories_file; then
        echo "Fixing /etc/apk/repositories" >&2
        echo """#/media/cdrom/apks
$repositories""" >/etc/apk/repositories && echo "...Done"
        repositories_file=$(cat /etc/apk/repositories)
    fi
    readarray -d "\n" -t repositories <<<$repositories
    for repo in ${repositories[@]}; do
        if ! grep -Rq "$repo" <<<$repositories_file; then
            echo "Missing source in /etc/apk/repositories" >&2
            echo "Adding \"$repo\"..."
            echo "$repo" >>/etc/apk/repositories && echo "...Done"
            repositories_file=$(cat /etc/apk/repositories)
        fi
    done
    unset repositories_file
    unset repositories
    unset repo
}

#check repositories
{
    readarray -d $'\n' -t packages <<<$(echo """
    fping%fping
    curl%curl
    neovim%nvim
    python3%python3
    """ | awk NF | awk '{$1=$1};1')
    for package in ${packages[@]}; do
        IFS=\% read -ra package <<<"$package"
        if ! [ -x "$(command -v ${package[1]})" ]; then
            echo "${package[0]} not found" >&2
            echo "Installing..." #gets display before line above somehow
            apk add "${package[0]}" >/dev/null && echo "${package[0]} installed successfully"
        fi
    done
}

#check bash_env folder
{
    if ! [ -d /usr ]; then
        mkdir /usr
    fi
    if ! [ -d /usr/share ]; then
        mkdir /usr/share
    fi
    if ! [ -d /usr/share/bash_env ]; then
        mkdir /usr/share/bash_env && chmod 777 /usr/share/bash_env && echo "bash_env folder created..."
    fi
}

read -r -p "List users to setup (colon-separated): " users <<<"root;markus"
readarray -d ";" -t users <<<$users
for user in ${users[@]}; do
    #if [ $user == "root" ]; then
    echo "$user"
    #else
    #    #just link to root
    #    echo "$user"
    #fi

done
