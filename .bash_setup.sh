#check if root
{
    if [ $(id -u) -ne 0 ]; then
        echo "Needs to be run as root" >&2
        exit
    fi
}
#<<EOF #Start multiline comment
if ! [ $BASH ]; then
    echo "Needs to be run from BASH!"
fi
if ! [ -x "$(
    command -v bash
)" ]; then
    echo "BASH not installed..."
    apk add bash || doas apk add bash || echo "Unable to automatically install BASH"
fi

get_default_shell() {
    if [ -z $1 ]; then
        echo "No user specified" >2 &
        return 1
    fi
    sys_users=$(awk -F: '{ print $1 ":" $7}' /etc/passwd)
    grep "^$1:" <<<$(echo "$sys_users") | cut -d : -f 2
}

set_default_shell() {
    if [ -z "$1" ]; then
        echo "No user specified" >2 &
        return 1
    fi
    if ! [ -f "$2" ]; then
        echo "specified SHELL not found"
        return 2
    elif ! [ -x "$2" ]; then
        echo "specified SHELL not an executable"
        return 3
    fi
    if [ $(get_default_shell "root") == "$2" ]; then
        return 0
    fi
    if [ $(awk -F: '{ print $1}' /etc/passwd | grep "^$1$") ]; then
        echo "Changing SHELL for \"$1\" to \"$2\"..."
        chsh --shell "$2" "$1" >/dev/null
        awk -F: '{ print $1 ":" $7}' /etc/passwd | grep "^$1:$2$" >/dev/null && {
            echo "Default SHELL set successfully!"
            return 0
        } || echo "ERROR setting default SHELL"
    fi
    return 4
}
set_default_shell "root" "/bin/bash" || {
    echo "BASH needs to be the default SHELL" >&2
    echo "Aborting..." >2 &
    exit
}

#End multiline comment
#EOF

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
        if ! grep -Rq "^$repo" <<<$repositories_file; then
            echo "Missing source in /etc/apk/repositories" >&2
            echo "Adding \"$repo\"..."
            echo -e "$repo" >>/etc/apk/repositories && echo "...Done\n"
            repositories_file=$(cat /etc/apk/repositories)
        fi
    done
    unset repositories_file
    unset repositories
    unset repo
}

#check repositories
{
    is_variable_set() {
        declare -p "$1" &>/dev/null
    }

    check_package_installed_apk() {
        p_alias="$1"
        apk list --installed 2>/dev/null | grep "$p_alias" >/dev/null
    }

    install_package() {
        p_alias="$1"
        p_bin="$2"
        p_args="$3"
        echo "$p_alias not found" >&2
        echo "Installing..." #gets display before line above somehow
        apk add $(echo "$p_args") "$p_alias" >/dev/null
        if [ -n "$p_bin" ]; then
            if [ -x "$(command -v $p_bin)" ] || check_package_installed_apk "$p_alias"; then
                echo -e "$p_alias installed successfully\n"
            else
                echo -e "$p_alias was not installed successfully\n" >&2
            fi
        else
            check_package_installed_apk "$p_alias" && echo -e "$p_alias installed successfully\n" || echo -e "$p_alias was not installed successfully\n" >&2
        fi

    }

    # PACKAGE_NAME%_BIN_NAME_%APK_ARGUMENTS
    # Mark Entry with # to skip it
    readarray -d $'\n' -t packages <<<$(echo """
    ca-certificates-bundle%%
    libgcc%%
    libssl3%%
    libstdc++%%
    zlib%%
    icu-libs%%
    libgdiplus%%
    lttng-ust%%
    shadow%chsh%
    tar%tar%
    fping%fping%
    curl%curl%
    neovim%nvim%
    python3%python3%--no-cache
    """ | awk NF | awk '{$1=$1};1')
    for package in ${packages[@]}; do
        IFS=\% read -ra package <<<"$package"
        if ! [[ "${package[0]}" =~ ^#.* ]]; then
            # if bin name provided
            p_alias="${package[0]}"
            p_bin="${package[1]}"
            p_args="${package[2]}"
            if [ -n "$p_bin" ]; then
                if ! [ -x "$(command -v $p_bin)" ] || ! check_package_installed_apk "$p_alias"; then
                    install_package $p_alias $p_bin $p_args
                fi
            else
                ! check_package_installed_apk "$p_alias" && install_package $p_alias $p_bin $p_args
            fi
            unset p_alias
            unset p_bin
            unset p_args
        fi
    done
}

#setup Powershell
{
    if ! [ -f /opt/microsoft/powershell/7/pwsh ] || ! [ -f /usr/bin/pwsh ]; then
        if ! [ -d /tmp ]; then
            mkdir /tmp && chmod 777 /tmp
        fi
        # Download the powershell '.tar.gz' archive
        curl -ks https://api.github.com/repos/PowerShell/PowerShell/releases/latest |
            grep "browser_download_url.*linux-musl-x64.tar.gz" |
            cut -d : -f 2,3 |
            tr -d \" |
            xargs wget --no-check-certificate -q -O /tmp/powershell.tar.gz

        # Create the target folder where powershell will be placed
        mkdir -p /opt/microsoft/powershell/7

        # Expand powershell to the target folder
        tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

        # Set execute permissions
        chmod +x /opt/microsoft/powershell/7/pwsh

        # Create the symbolic link that points to pwsh
        ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh -f

        #Remove download
        rm -f /tmp/powershell.tar.gz

        #Test Powershell
        pwsh -NoLogo -noni -EncodedCommand "UgBlAHQAdQByAG4AIAAkAHQAcgB1AGUA" 2>&1 >/dev/null && echo "PowerShell installed successfully" || echo "PowerShell seems to throw errors" >&2

    #TODO Set Profile

    #else
    #    echo "Powershell already installed"
    fi
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
#download profile
{

}

#setup user
{
    echo -e "\n\n"
    awk -F: '{ print " - " $1}' /etc/passwd
    while [ "$users_exist" != "true" ]; do
        echo -e "\n" && read -r -p "List users to setup (colon-separated): " users #<<<"root;markus"
        readarray -d ";" -t users <<<$users
        users_exist=true
        for user in ${users[@]}; do
            awk -F: '{ print $1}' /etc/passwd | grep "^$user$" >/dev/null || {
                users_exist=false && echo "Invalid user \"$user\""
            }
        done
    done
    unset user_exist
    for user in ${users[@]}; do
        user_pwd=$(su - "$user" -c "echo \$HOME")
        if [ -d "$user_pwd" ]; then
            ln -f /usr/share/bash_env/.bash_init.sh $user_pwd/.bashrc
            chmod 777 $user_pwd/.bashrc
        fi
    done

    exit
}
