# .bashrc

# Shared PATH / build env 
[ -r "$HOME/.shell_env" ] && . "$HOME/.shell_env"

# Load nvm — kept unguarded so non-interactive hook shells get it too
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
