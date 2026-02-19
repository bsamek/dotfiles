# Path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins (git plugin provides the aliases you want)
plugins=(git zoxide direnv)

# PATH / Environment
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Tool initialization (atuin — not available as omz plugin)
eval "$(atuin init zsh)"

# tmux: auto-attach on SSH login
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]]; then
  tmux new-session -A -s main
fi

# Aliases
alias tm='tmux new-session -A -s main'
alias mosh-mini='mosh --server=/opt/homebrew/bin/mosh-server mini'
alias cc-skip='claude --dangerously-skip-permissions'
alias cc-chrome='claude --chrome'
alias cc-both='claude --dangerously-skip-permissions --chrome'

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
