source ~/antigen.zsh

antigen use oh-my-zsh
antigen bundle asdf
antigen bundle fzf
antigen bundle git
antigen bundle z
antigen theme robbyrussell
antigen apply

alias efab="fab -r /Users/brian/src/kernel-tools/evergreen"
export KUBECONFIG=~/.kube/config-staging:~/.kube/config-prod
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
export ZSH="$HOME/.oh-my-zsh"
source /Users/brian/.config/op/plugins.sh
