# .bashrc

# Shared PATH / build env
[ -r "$HOME/.shell_env" ] && . "$HOME/.shell_env"

integration_config="$HOME/.bash_config/integration"
[ -f "$integration_config" ] && source "$integration_config"
