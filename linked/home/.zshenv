# Bootstrap Antidote
if [ ! -d "${ZDOTDIR:-$HOME}/.antidote" ]; then
  >&2 printf '\033[33mshell\033[0m: fetching antidote...'
  if command -v git >/dev/null 2>&1; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "${ZDOTDIR:-$HOME}/.antidote"
  else
    >&2 printf '\033[33mshell\033[0m: please install git.'
    return 1
  fi
fi

### ENV VARS
export GPG_TTY=$TTY
export MANROFFOPT="-c" # Fix escape symbols in manpages
export HOMEBREW_NO_AUTO_UPDATE=1 # for those slow-internet days
export VISUAL=nvim
export EDITOR="$VISUAL"

# UTF-8 everywhere. Prefer en_IN, fall back to C.UTF-8 if it isn't generated
() {
  local avail loc
  avail="$(locale -a 2>/dev/null)"
  for loc in en_IN.UTF-8 en_IN.utf8 C.UTF-8 C.utf8; do
    if [[ "$avail" == *$loc* ]]; then
      export LC_ALL="$loc" LANG="$loc"
      return
    fi
  done
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Ensure macos XDG dirs match linux for my sanity
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_STATE_HOME="$HOME/.local/state"
fi

# Add any missing pkg-config dirs (Originally to fix a problem with cargo in fedora)
typeset -T PKG_CONFIG_PATH pkg_config_path
typeset -U pkg_config_path
for _pc in /usr/lib64/pkgconfig /usr/lib/pkgconfig /usr/lib/x86_64-linux-gnu/pkgconfig /usr/lib/aarch64-linux-gnu/pkgconfig; do
  [ -d "$_pc" ] && pkg_config_path=("$_pc" $pkg_config_path)
done
export PKG_CONFIG_PATH
unset _pc

# Set up nvm / add it to path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

### PATH

typeset -U path PATH
export GOPATH="$HOME/gocode"
export PNPM_HOME="$HOME/.pnpm"
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$GOPATH/bin"
  "$PNPM_HOME/bin"
  "$HOME/.pyenv/shims"
  $path
)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  path=("/home/linuxbrew/.linuxbrew/bin" $path)
elif [[ "$OSTYPE" == "darwin"* ]]; then
  path=("/opt/homebrew/bin" $path)
fi
export PATH



