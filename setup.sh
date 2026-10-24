#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/src/dotfiles"
PI_CUSTOMIZATIONS_DIR="$HOME/src/pi-customizations"

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install packages
echo "Installing brew packages..."
brew install zoxide direnv fzf mosh zsh-autosuggestions python3

# Direct installs update through herdr, not Homebrew.
export PATH="$HOME/.local/bin:$PATH"
if command -v herdr &>/dev/null; then
  if [[ "${HERDR_ENV:-}" == "1" ]]; then
    echo "Inside Herdr: skipping self-update; run herdr update after detaching."
  else
    herdr update
  fi
else
  curl -fsSL https://herdr.dev/install.sh | sh
fi
herdr integration install pi

# Install oh-my-zsh if missing
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# Clone dotfiles if this script is being run standalone (e.g. curl | bash)
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Cloning dotfiles..."
  git clone git@github.com:bsamek/dotfiles.git "$DOTFILES_DIR"
fi

if [[ ! -d "$PI_CUSTOMIZATIONS_DIR" ]]; then
  echo "Cloning pi customizations..."
  git clone git@github.com:bsamek/pi-customizations.git "$PI_CUSTOMIZATIONS_DIR"
fi

# Symlink dotfiles
echo "Symlinking dotfiles..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
# Remove only the obsolete link owned by this repo.
if [[ -L "$HOME/.tmux.conf" && "$(readlink "$HOME/.tmux.conf")" == "$DOTFILES_DIR/.tmux.conf" ]]; then
  rm "$HOME/.tmux.conf"
fi
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.gitconfig-personal" "$HOME/.gitconfig-personal"
ln -sf "$DOTFILES_DIR/.gitconfig-work" "$HOME/.gitconfig-work"

# Pi settings stay machine-local. Merge only shared extensions/UI preferences.
python3 "$DOTFILES_DIR/pi/apply-settings.py"

# Share Herdr preferences without syncing sockets, logs, or runtime state.
mkdir -p "$HOME/.config/herdr"
HERDR_CONFIG="$HOME/.config/herdr/config.toml"
if [[ -e "$HERDR_CONFIG" && ! -L "$HERDR_CONFIG" ]]; then
  mv "$HERDR_CONFIG" "$HERDR_CONFIG.backup.$(date +%Y%m%d%H%M%S).$$"
fi
ln -sf "$DOTFILES_DIR/herdr/config.toml" "$HERDR_CONFIG"

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
