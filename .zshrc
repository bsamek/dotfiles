source ~/antigen.zsh

antigen use oh-my-zsh

antigen bundle aliases
antigen bundle asdf
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
alias efab="fab -r /Users/brian.samek/src/kernel-tools/evergreen"
