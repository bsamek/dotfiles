#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/src/dotfiles"

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install packages
echo "Installing brew packages..."
brew install zoxide direnv atuin tmux mosh zsh-autosuggestions

# Install oh-my-zsh if missing
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# Clone dotfiles if this script is being run standalone (e.g. curl | bash)
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Cloning dotfiles..."
  git clone git@github.com:brian/dotfiles.git "$DOTFILES_DIR"
fi

# Symlink dotfiles
echo "Symlinking dotfiles..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.gitconfig-personal" "$HOME/.gitconfig-personal"
ln -sf "$DOTFILES_DIR/.gitconfig-work" "$HOME/.gitconfig-work"

# Ensure .zprofile has brew shellenv (needed for non-interactive shells)
if [[ ! -f "$HOME/.zprofile" ]] || ! grep -q 'brew shellenv' "$HOME/.zprofile"; then
  echo "Adding brew shellenv to .zprofile..."
  cat >> "$HOME/.zprofile" <<'ZPROFILE'
export SHELL=/bin/zsh

eval "$(/opt/homebrew/bin/brew shellenv --shell=zsh)"
ZPROFILE
fi

echo ""
echo "Done! Open a new terminal to start using the config."
echo ""
echo "NOTE: Review git config paths as needed."
echo "Update $HOME/.gitconfig-work repo paths for this machine."
