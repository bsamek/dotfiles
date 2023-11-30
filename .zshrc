export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git z asdf fzf)

source $ZSH/oh-my-zsh.sh

export KUBECONFIG=~/.kube/config-staging:~/.kube/config-prod
source /Users/brian/.config/op/plugins.sh
alias efab="fab -r /Users/brian/src/kernel-tools/evergreen"
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock