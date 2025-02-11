source ~/antigen.zsh

antigen use oh-my-zsh

antigen bundle aliases
antigen bundle fzf
antigen bundle git
antigen bundle ripgrep
antigen bundle z

# has to come after fzf to clobber ctrl-r
antigen bundle atuinsh/atuin@main

antigen theme robbyrussell

antigen apply

export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
export ZSH="$HOME/.oh-my-zsh"
source /Users/brian.samek/.config/op/plugins.sh
alias deploy="/Users/brian.samek/src/kernel-tools/evergreen/evergreen-deploys.py"
alias version="paste <(kubectl get pods) <(kubectl get pods -o custom-columns='VERSION_ID:.metadata.labels.evergreen/version,GIT-REVISION:.metadata.labels.evergreen/revision')"
alias db="/Users/brian.samek/src/kernel-tools/evergreen/db_access.py"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
