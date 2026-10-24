# dotfiles

Zsh (oh-my-zsh), git, Herdr, and pi config for macOS. Herdr replaces tmux; neither is started automatically on login.

## Quick setup

```
git clone git@github.com:bsamek/dotfiles.git ~/src/dotfiles
~/src/dotfiles/setup.sh
```

This installs Homebrew (if needed), CLI tools including fzf, oh-my-zsh, and Herdr plus its pi integration. It symlinks shell, Git, and Herdr configuration, and merges shared pi preferences into machine-local settings. Existing pi settings and non-symlink Herdr configs are backed up.

## What's included

| File | Symlinked? | Notes |
|------|-----------|-------|
| `.zshrc` | Yes | Portable shell core: oh-my-zsh with git, zoxide, direnv plugins, fzf history/completion |
| `.gitconfig` | Yes | Shared defaults + include rules |
| `.gitconfig-personal` | Yes | Default identity/signing (GitHub noreply + SSH signing) |
| `.gitconfig-work` | Yes | Work-only scalar/maintenance repos |
| `herdr/config.toml` | Yes (`~/.config/herdr/`) | Shared keybindings and agent sidebar layout |
| `pi/settings.json` | No | Shared UI preferences and local extension list; applied with `pi/apply-settings.py` |

## Machine-local overlay (work config)

This repo is **public**, so machine- or employer-specific config is not tracked. `.zshrc` ends with:

```zsh
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

Put work-only exports there (internal endpoints, CI tokens pulled from the keychain, kubectl/Argo setup, employer-specific aliases). Create it with `chmod 600`. It stays untracked and out of this repo; keep a copy in a **private** repo or password manager if you want it backed up.

Pi's `~/.pi/agent/settings.json` is a regular machine-local file. Provider/model defaults, enabled models, thinking levels, credentials, and other local preferences are not synchronized. Run `python3 ~/src/dotfiles/pi/apply-settings.py` after pulling shared preference changes; it preserves local model/provider settings and unrelated extensions/packages, backs up existing settings, and migrates old settings symlinks safely.

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

- **Shell overlay**: create `~/.zshrc.local` if this machine needs work or machine-specific config (see above).
- **Git config**:
  - `setup.sh` symlinks `.gitconfig`, `.gitconfig-personal`, and `.gitconfig-work` into your home directory.
  - Update any machine-specific paths as needed in `~/.gitconfig-work` (`scalar`/`maintenance` repo paths).
- **SSH keys / 1Password**: Git signing requires 1Password SSH agent — install 1Password and enable the SSH agent.
- **Herdr**: `setup.sh` installs/updates Herdr and symlinks `herdr/config.toml` into `~/.config/herdr/`. Run `herdr` manually to launch it, and `herdr server reload-config` after editing a running server's configuration. Prefix: Ctrl+A.
- **Pi credentials**: provider credentials are deliberately **not** tracked here. Run `pi` and add each
  provider's API key/oauth on a new machine; keys live in `~/.pi/agent/auth.json`.
- **Pi extensions**: live in the separate [pi-customizations](https://github.com/bsamek/pi-customizations)
  repo. `pi/settings.json` lists them by `~/src/pi-customizations/...` path (pi expands `~`),
  so edits are live — no republish or package update needed. `setup.sh` clones that repo to
  `~/src/pi-customizations`, which is the working copy to edit and push from.
