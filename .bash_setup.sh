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
if [ $(id -u) -ne 0 ]; then
    echo "Needs to be run as root"
    exit
fi

#check repositories

#check fping
if ! [ -x "$(command -v fping)" ]; then
    echo "fping not found" >&2
    echo "Installing..."
    apk add fping >/dev/null && echo "fping installed successfully"
fi

#check curl
if ! [ -x "$(command -v curl)" ]; then
    echo "curl not found" >&2
    echo "Installing..."
    apk add curl >/dev/null && echo "curl installed successfully"
fi

#check nvim
if ! [ -x "$(command -v nvim)" ]; then
    echo "neovim not found" >&2
    echo "Installing..."
    apk add neovim >/dev/null && echo "neovim installed successfully"
fi

#check python
if ! [ -x "$(command -v python3)" ]; then
    echo "python3 not found" >&2
    echo "Installing..."
    apk add python3 >/dev/null && echo "python3 installed successfully"
fi

read -r -p "List users to setup (colon-separated): " users <<<"A;b"
readarray -d ";" -t users <<<$users
for user in ${users[@]}; do
    echo "$user"
done
