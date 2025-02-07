#!/usr/bin/env zsh

set -eu

echo "\nchecking requirements..."

if [[ "$(uname)" == "Darwin" ]]; then
    if ! command -v brew > /dev/null 2>&1; then
        echo "brew not found, please install brew"
        exit 1
    fi
    echo "\nupgrading brew..."
    brew update
    brew upgrade
fi

echo "\nupgrading zsh..."
"$ZSH/tools/upgrade.sh"
