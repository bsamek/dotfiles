# PATH / Environment
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"

# Tool initialization
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(atuin init zsh)"

# tmux: auto-attach on SSH login
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]]; then
  tmux new-session -A -s main
fi

alias tm='tmux new-session -A -s main'
alias mosh-mini='mosh --server=/opt/homebrew/bin/mosh-server mini'

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
