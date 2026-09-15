# dotfiles

Zsh (oh-my-zsh), tmux, and git config for macOS.

## Quick setup

```
git clone git@github.com:bsamek/dotfiles.git ~/src/dotfiles
~/src/dotfiles/setup.sh
```

This installs Homebrew (if needed), CLI tools, oh-my-zsh, and symlinks `.zshrc`, `.tmux.conf`, and git config files.

## What's included

| File | Symlinked? | Notes |
|------|-----------|-------|
| `.zshrc` | Yes | oh-my-zsh with git, zoxide, direnv plugins + atuin, autosuggestions |
| `.tmux.conf` | Yes | vi keys, C-a prefix, host-colored status bar |
| `.gitconfig` | Yes | Shared defaults + include rules |
| `.gitconfig-personal` | Yes | Default identity/signing (GitHub noreply + SSH signing) |
| `.gitconfig-work` | Yes | Work-only scalar/maintenance repos |
| `pi/settings.json` | Yes | Pi model defaults, TUI prefs, and installed extension packages |

## Manual steps after setup

- **Git config**:
  - `setup.sh` symlinks `.gitconfig`, `.gitconfig-personal`, and `.gitconfig-work` into your home directory.
  - Update any machine-specific paths as needed in `~/.gitconfig-work` (`scalar`/`maintenance` repo paths).
- **SSH keys / 1Password**: Git signing requires 1Password SSH agent — install 1Password and enable the SSH agent.
- **Pi credentials**: `setup.sh` symlinks `pi/settings.json` to `~/.pi/agent/settings.json`,
  but provider credentials are deliberately **not** tracked here. Run `pi` and add each
  provider's API key/oauth on a new machine; keys live in `~/.pi/agent/auth.json`.
- **Pi extensions**: live in the separate [pi-customizations](https://github.com/bsamek/pi-customizations)
  repo. `pi/settings.json` references it as a git package, so pi installs and updates its
  own clone under `~/.pi/agent/git/` on startup — no manual step needed. `setup.sh` also
  clones it to `~/src/pi-customizations`, which is the working copy to edit and push from.
