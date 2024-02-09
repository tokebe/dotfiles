# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return
z4h install se-jaeger/zsh-activate-py-environment || return
z4h install akash329d/zsh-alias-finder || return
z4h install RobSis/zsh-completion-generator || return
z4h install Tarrasch/zsh-bd || return
z4h install hlissner/zsh-autopair || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY
export MANPAGER="sh -c 'col -bx | bat -l man -p'" # colorful manpages
export HOMEBREW_NO_AUTO_UPDATE=1 # for those slow-internet days

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
# z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin
# z4h load ohmyzsh/ohmyzsh/plugins/colored-man-pages
z4h load se-jaeger/zsh-activate-py-environment
z4h load ohmyzsh/ohmyzsh/plugins/autojump


z4h load akash329d/zsh-alias-finder
export ZSH_ALIAS_FINDER_PREFIX='󱉵 Has Alias: '

z4h load RobSis/zsh-completion-generator
zstyle :plugin:zsh-completion-generator programs cat

z4h source Tarrasch/zsh-bd/bd.zsh
z4h load hlissner/zsh-autopair

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

# z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
# z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
# z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
# z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Make transient prompt ssh friendly
z4h bindkey z4h-eof Ctrl+D
setopt ignore_eof

# Smoother rendering
POSTEDIT=$'\n\n\e[2A'

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias clear=z4h-clear-screen-soft-bottom # make clear work
alias tree='tree -a -I .git'
alias rangerd='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias gitui=lazygit
alias lg=lazygit
alias ls='lsd -AX --group-dirs=first'
alias notes="( cd ~ && nvim ~/notes )"
alias cat=ccat
alias lk='walk "$@" --icons'
alias lkd='walk "$@" --icons'
alias pn=pnpm
if command -v neovide >/dev/null 2>&1; then
    alias nvd='neovide --frame buttonless --multigrid'
fi
# if [ -f ~/applications/nvim ]; then
#     alias nvim=~/applications/nvim
# fi

# Add flags to existing aliases.
# alias ls="${aliases[ls]:-ls} -A"


# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# Get nvm working
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Make Go work
export GOPATH=$HOME/gocode
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

fpath+=~/.zfunc
autoload -Uz compinit && compinit

# pnpm
export PNPM_HOME="$HOME/.pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

