export VISUAL=nvim
export EDITOR="$VISUAL"
path=("$HOME/.local/bin" "$HOME/.pyenv/shims/python3" $path)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
if [[ "$(uname -s)" == *"Linux"* ]]; then
    path=("$HOME/linuxbrew/.linuxbrew/bin" $path)
elif [[ "$(uname -m)" == "arm64" ]]; then
    path=("/opt/homebrew/bin")
fi
export PATH
