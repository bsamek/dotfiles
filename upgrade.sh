#!/usr/bin/env zsh
set -eu

echo "\nchecking requirements..."

if ! command -v brew > /dev/null 2>&1; then
    echo "brew not found, please install brew"
    exit 1
fi
if ! command -v asdf > /dev/null 2>&1; then
    echo "asdf not found, please install asdf"
    exit 1
fi
if ! command -v fzf > /dev/null 2>&1; then
    echo "fzf not found, please install fzf"
    exit 1
fi
if [[ ! -v ZSH ]]; then
    echo "oh-my-zsh not found, please install oh-my-zsh"
    exit 1
fi
if [[ ! -L ~/.zshrc ]]; then
    echo "~/.zshrc is not a symbolic link, have you cloned and linked dotfiles?"
    exit 1
fi

echo "\nupgrading brew..."
brew upgrade

echo "\nupgrading asdf..."
asdf update

asdf install python latest
asdf global python latest
asdf reshim python latest

asdf install nodejs latest
asdf global nodejs latest
asdf reshim nodejs latest

asdf install golang latest
asdf global golang latest
asdf reshim golang latest

pushd /Users/brian/src/evergreen
asdf install golang latest:1.20
asdf local golang latest:1.20
asdf reshim golang latest:1.20
popd

echo "\nupgrading zsh..."
"$ZSH/tools/upgrade.sh"