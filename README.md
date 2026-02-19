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
| `.gitconfig` | No | Machine-specific — copy and edit paths/identity manually |

## Manual steps after setup

- **`.gitconfig`**: Copy `.gitconfig` to `~/.gitconfig` and update `user.name`, `user.email`, `signingkey`, and any machine-specific paths.
- **SSH keys / 1Password**: Git signing requires 1Password SSH agent — install 1Password and enable the SSH agent.
