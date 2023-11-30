#!/usr/bin/env zsh

# This script upgrades your development machine.
#
# This script works on Linux and MacOS. It checks that the following are
# installed. If they are not, it exits without making any changes:
#
# 1. brew (only on MacOS)
# 2. asdf
# 3. fzf
# 4. oh-my-zsh
#
# It also validates that ~/.zshrc is a symbolic link, since it assumes you have
# your ~/.zshrc in a git repository and will symlink it.
#
# If all the requirements are present, it upgrades the following:
#
# 1. brew (only on MacOS)
# 2. asdf
# 3. latest python, nodejs, and golang for asdf
# 4. latest golang 1.20 for ~/src/evergreen, creating the directory if it doesn't exist

set -eu

echo "\nchecking requirements..."

if [[ "$(uname)" == "Darwin" ]]; then
    if ! command -v brew > /dev/null 2>&1; then
        echo "brew not found, please install brew"
        exit 1
    fi
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

if [[ "$(uname)" == "Darwin" ]]; then
    echo "\nupgrading brew..."
    brew upgrade
fi

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

mkdir ~/src/evergreen
pushd ~/src/evergreen
asdf install golang latest:1.20
asdf local golang latest:1.20
asdf reshim golang latest:1.20
popd

echo "\nupgrading zsh..."
"$ZSH/tools/upgrade.sh"