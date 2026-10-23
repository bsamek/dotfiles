# Path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins (git plugin provides the aliases you want)
plugins=(git zoxide direnv)

# PATH / Environment
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# fzf: history search (Ctrl+R) and fuzzy file completion (**<Tab>)
source <(fzf --zsh)
export EDITOR="vim"

# tmux: auto-attach on SSH login
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]]; then
  tmux new-session -A -s main
fi

# Aliases
tm() {
  if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    tmux -CC new-session -A -s main
  else
    tmux new-session -A -s main
  fi
}
alias mini='mosh --server=/opt/homebrew/bin/mosh-server mini'
alias cc='claude --allow-dangerously-skip-permissions --chrome'

# zsh-autosuggestions (homebrew)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Sync repos between machines
reposync() {
  local repo="$1" direction="$2" host="${3:-mini}"
  if [[ -z "$repo" || ( "$direction" != "pull" && "$direction" != "push" ) ]]; then
    echo "Usage: reposync <repo> <pull|push> [host]"
    return 1
  fi
  local local_dir="$HOME/src/$repo/"
  local remote_dir="~/src/$repo/"
  if [[ "$direction" == "pull" ]]; then
    mkdir -p "$HOME/src/$repo"
    rsync -az --delete "$host:$remote_dir" "$local_dir"
  elif [[ "$direction" == "push" ]]; then
    ssh "$host" "mkdir -p ~/src/$repo"
    rsync -az --delete "$local_dir" "$host:$remote_dir"
  fi
}

# Read a secret from the macOS login keychain
_kc() { security find-generic-password -a "$USER" -s "$1" -w 2>/dev/null; }

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export DOCKER_HOST="unix:///var/run/docker.sock"

# opencode
export OPENCODE_DISABLE_TERMINAL_TITLE=1
export OPENCODE_SERVER_PASSWORD="$(_kc ZSHRC_OPENCODE_SERVER_PASSWORD)"
opencode() {
  print -n "\e]2;OpenCode | ${PWD:t}\a"
  command opencode "$@"
}
alias oc='opencode'

alias e='TERM=xterm-256color emacsclient -nw -a ""'
alias ec='emacsclient -c -a ""'

# Non-interactive shells (agents, CI) must never block on an editor or pager.
# Interactive shells are untouched and keep vim. Env vars beat core.editor.
if [[ ! -t 0 ]]; then
  export GIT_EDITOR=true
  export GIT_SEQUENCE_EDITOR=true
  export GIT_MERGE_AUTOEDIT=no
  export PAGER=cat
  export GIT_PAGER=cat
fi

# Machine-local additions (work environment, per-machine paths). Deliberately
# untracked: this repo is public, and that file holds work-only endpoints.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
