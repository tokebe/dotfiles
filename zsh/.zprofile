export VISUAL=nvim
export EDITOR="$VISUAL"
path=("$HOME/.local/bin" "$HOME/.pyenv/shims/python3" $path)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    path=("/home/linuxbrew/.linuxbrew/bin" $path)
elif [[ "$(uname -m)" == "arm64" ]]; then
    path=("/opt/homebrew/bin" $path)
fi
export PATH

# TODO if on macos, check if <5min since login and send motd only if true
# on all other systems, just send motd

# Startup greeter
# figlet -f slant -w $COLUMNS $(hostname) | lolcat -f -t -S 1000
# # paste <(neofetch) <(cal) | column -s $'\t' -t -c $COLUMNS/2
# neofetch
# date '+%Y-%m-%d %H:%M:%S'
# echo ''
# cal -3
# duf -hide special -theme dark -style unicode -width $COLUMNS
# echo 'Recent logins:'
# last -3 $USER
