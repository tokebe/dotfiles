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

### Use shared PATH / build env
[ -r "$HOME/.shell_env" ] && . "$HOME/.shell_env"
typeset -U path PATH # collapse any duplicates
