# dotfiles

Zsh (oh-my-zsh), tmux, and git config for macOS.

## Quick setup

```
git clone git@github.com:bsamek/dotfiles.git ~/src/dotfiles
~/src/dotfiles/setup.sh
```

This installs Homebrew (if needed), CLI tools, oh-my-zsh, and symlinks `.zshrc` and `.tmux.conf`.

## What's included

| File | Symlinked? | Notes |
|------|-----------|-------|
| `.zshrc` | Yes | oh-my-zsh with git, zoxide, direnv plugins + atuin, autosuggestions |
| `.tmux.conf` | Yes | vi keys, C-a prefix, host-colored status bar |
| `.gitconfig` | No | Shared defaults + include rules |
| `.gitconfig-personal` | No | Default identity/signing (GitHub noreply + SSH signing) |
| `.gitconfig-work` | No | Work-only scalar/maintenance repos |

## Manual steps after setup

- **Git config**:
  - Copy `.gitconfig` to `~/.gitconfig`.
  - Copy `.gitconfig-personal` to `~/.gitconfig-personal`.
  - Copy `.gitconfig-work` to `~/.gitconfig-work`.
  - Update any machine-specific paths as needed (`scalar`/`maintenance` repo paths).
- **SSH keys / 1Password**: Git signing requires 1Password SSH agent — install 1Password and enable the SSH agent.
