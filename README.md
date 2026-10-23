# dotfiles

Zsh (oh-my-zsh), tmux, git, and Herdr config for macOS.

## Quick setup

```
git clone git@github.com:bsamek/dotfiles.git ~/src/dotfiles
~/src/dotfiles/setup.sh
```

This installs Homebrew (if needed), CLI tools, oh-my-zsh, and symlinks `.zshrc`, `.tmux.conf`, git config files, and Herdr preferences. Existing non-symlink Herdr configs are backed up before linking.

## What's included

| File | Symlinked? | Notes |
|------|-----------|-------|
| `.zshrc` | Yes | oh-my-zsh with git, zoxide, direnv plugins + atuin, autosuggestions |
| `.tmux.conf` | Yes | vi keys, C-a prefix, host-colored status bar |
| `.gitconfig` | Yes | Shared defaults + include rules |
| `.gitconfig-personal` | Yes | Default identity/signing (GitHub noreply + SSH signing) |
| `.gitconfig-work` | Yes | Work-only scalar/maintenance repos |
| `herdr/config.toml` | Yes | `~/.config/herdr/config.toml`; shared keybindings and agent sidebar layout |

## Sync Herdr preferences

Only `herdr/config.toml` is tracked, not Herdr sockets, logs, or runtime state.
After pulling changes on another machine, run `herdr server reload-config` if
Herdr is running.

To link just Herdr without running the full setup:

```bash
mkdir -p ~/.config/herdr
# Back up an existing config before replacing it.
if [ -f ~/.config/herdr/config.toml ] && [ ! -L ~/.config/herdr/config.toml ]; then
  mv ~/.config/herdr/config.toml ~/.config/herdr/config.toml.backup.$(date +%Y%m%d%H%M%S).$$
fi
ln -sf ~/src/dotfiles/herdr/config.toml ~/.config/herdr/config.toml
```

## Manual steps after setup

- **Git config**:
  - `setup.sh` symlinks `.gitconfig`, `.gitconfig-personal`, and `.gitconfig-work` into your home directory.
  - Update any machine-specific paths as needed in `~/.gitconfig-work` (`scalar`/`maintenance` repo paths).
- **SSH keys / 1Password**: Git signing requires 1Password SSH agent — install 1Password and enable the SSH agent.
