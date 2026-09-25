# Login setup
# Set up PATH
path=("$HOME/.local/bin" "$HOME/.pyenv/shims/python3" $path)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    path=("/home/linuxbrew/.linuxbrew/bin" $path)
elif [[ "$(uname -m)" == "arm64" ]]; then
    path=("/opt/homebrew/bin" $path)
fi
export PATH

export VISUAL=nvim
export EDITOR="$VISUAL"
