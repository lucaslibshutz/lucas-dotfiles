# WSL Terminal Environment

> **Branch:** `wsl-setup` | **Base:** Lucas's macOS dotfiles, adapted for Windows Subsystem for Linux

A full terminal setup for WSL2 (Ubuntu), matching the aesthetic of the macOS config — Catppuccin Mocha theme throughout, LazyVim-based Neovim, and a polished PowerShell profile for the Windows side.

---

## What's included

| Config | Location | Description |
|--------|----------|-------------|
| Neovim | `.config/nvim/` | LazyVim + Catppuccin, WSL clipboard, extra plugins |
| Tmux | `.config/tmux/tmux.conf` | Catppuccin status bar, TPM, resurrect |
| Zsh | `.zshrc` | Oh My Zsh + Powerlevel10k, eza, fzf, zoxide |
| PowerShell | `powershell/Microsoft.PowerShell_profile.ps1` | Oh My Posh, PSReadLine vi-mode, zoxide, aliases |
| Install script | `install-wsl.sh` | One-shot bootstrap for a fresh WSL instance |

---

## Quick start (WSL side)

### Prerequisites

- WSL2 with Ubuntu 22.04+ (other Debian-based distros should work)
- Windows Terminal (recommended) or any terminal with true-color support

### 1. Clone & run the installer

```bash
git clone https://github.com/lucaslibshutz/Lucas-dotfiles.git ~/dotfiles
cd ~/dotfiles
git checkout wsl-setup
bash install-wsl.sh
```

The installer handles:
- Core APT packages (git, curl, build tools, ripgrep, fd, bat, fzf, tmux, zsh)
- Neovim (latest stable AppImage, extracted so no FUSE required in WSL)
- Oh My Zsh + Powerlevel10k + `zsh-autosuggestions` + `zsh-syntax-highlighting`
- NVM (Node.js LTS)
- Rust + Cargo
- eza, zoxide, atuin
- TPM (Tmux Plugin Manager)
- Symlinks for all configs

Run with `--dry-run` to preview without making changes:

```bash
bash install-wsl.sh --dry-run
```

### 2. Post-install steps

**Zsh prompt:**
```bash
exec zsh
p10k configure       # or copy your .p10k.zsh from macOS
```

**Tmux plugins:**
```bash
tmux
# Inside tmux: Prefix + I   (Prefix = Ctrl+a)
```
This installs: `tmux-sensible`, `tmux-resurrect`, `tmux-continuum`, `tmux-yank`, `vim-tmux-navigator`.

**Neovim plugins:**
```
nvim
# lazy.nvim auto-installs everything on first launch
# Then run :Mason to verify LSP servers
```

### 3. WSL clipboard

The Neovim config automatically bridges the `+` register to `clip.exe` when running inside WSL. You can `"+y` to copy to the Windows clipboard from Neovim.

Tmux copy-mode (`Prefix + [`, then `v` + `y`) also pipes through `clip.exe`.

---

## Neovim

Built on **LazyVim** with these additions/changes vs. the macOS config:

| Change | Detail |
|--------|--------|
| Colorscheme | Catppuccin Mocha (was solarized-osaka) |
| LSP servers | pyright, ruff, ts_ls, eslint, lua_ls, html, cssls, tailwind, jsonls, yamlls, bashls, clangd, gopls, marksman |
| Language extras | Python, TypeScript, JSON, Rust, Go |
| Clipboard | Auto-configured for WSL (`clip.exe` / `powershell.exe`) |
| New plugins | `nvim-autopairs`, `ts-comments`, `nvim-surround`, `better-escape` (jk), `vim-tmux-navigator`, `oil.nvim`, `harpoon2` |
| Removed | Arduino LSP (macOS-only), AI Copilot (optional, re-add if wanted) |

### Key mappings (additions to LazyVim defaults)

| Mode | Key | Action |
|------|-----|--------|
| Normal | `ss` / `sv` | Horizontal / vertical split |
| Normal | `sh/sj/sk/sl` | Navigate splits |
| Normal | `<leader>y` | Yank to system clipboard |
| Normal | `<leader>d` | Delete without yanking |
| Normal | `<leader>H` | Harpoon: add file |
| Normal | `<leader>h` | Harpoon: open menu |
| Normal | `<leader>1-4` | Harpoon: jump to file |
| Normal | `-` | Open Oil (parent directory as buffer) |
| Insert | `jk` | Escape (via better-escape) |
| Normal | `<C-hjkl>` | Navigate splits *and* tmux panes |

### LSP setup

Mason auto-installs servers on first launch. To add more:
```
:MasonInstall <server-name>
```

---

## Tmux

### Key bindings

| Key | Action |
|-----|--------|
| `Ctrl+a` | Prefix |
| `Prefix + \` | Split vertically (new pane on right) |
| `Prefix + -` | Split horizontally (new pane below) |
| `Prefix + r` | Reload config |
| `Ctrl+h/j/k/l` | Navigate panes (also works across nvim splits) |
| `Prefix + H/J/K/L` | Resize pane |
| `Prefix + m` | Toggle zoom (maximize pane) |
| `Prefix + [` | Enter copy mode |
| `v` (copy mode) | Begin selection |
| `y` (copy mode) | Copy to Windows clipboard |
| `Prefix + Ctrl+s` | Save session (resurrect) |
| `Prefix + Ctrl+r` | Restore session (resurrect) |
| `Prefix + Tab` | Last window |
| `Prefix + S` | Choose session |
| `Prefix + N` | New session |

### Plugins

| Plugin | Purpose |
|--------|---------|
| `tmux-sensible` | Sane defaults |
| `tmux-resurrect` | Persist sessions across reboots |
| `tmux-continuum` | Auto-save sessions every 10 minutes |
| `tmux-yank` | Better clipboard integration |
| `vim-tmux-navigator` | Seamless Neovim ↔ tmux navigation |

---

## Zsh

Identical plugin set to the macOS config, re-tuned for WSL:

- **Theme:** Powerlevel10k (same `.p10k.zsh` config works in WSL)
- **Plugins:** git, zsh-autosuggestions, zsh-syntax-highlighting, tmux, fzf, z, docker, npm, python, golang, rust, history-substring-search, colored-man-pages
- **Tools:** eza, fzf (Catppuccin colors), ripgrep, zoxide, atuin
- **NVM / pyenv / cargo** auto-loaded if installed

### Notable aliases

| Alias | Expands to |
|-------|-----------|
| `ll` | `eza -l -a -g --icons --git` |
| `lt` | `eza -T --icons --git-ignore` (tree) |
| `vim` / `vi` / `v` | `nvim` |
| `open` | `explorer.exe .` |
| `winhome` | `cd /mnt/c/Users/<username>` |
| `venv` | Create + activate `.venv` |
| `activate` | `source .venv/bin/activate` |
| `g`, `ga`, `gc`, `gst`, … | Git shortcuts |

---

## PowerShell (Windows side)

The profile lives at `powershell/Microsoft.PowerShell_profile.ps1`. Symlink or copy it to:

```
$PROFILE   # typically: ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

Or from PowerShell:
```powershell
New-Item -ItemType SymbolicLink `
  -Path $PROFILE `
  -Target "C:\path\to\Lucas-dotfiles\powershell\Microsoft.PowerShell_profile.ps1"
```

### Windows prerequisites

Install with winget:
```powershell
winget install JanDeLaater.OhMyPosh     # Oh My Posh
winget install junegunn.fzf              # fzf
winget install ajeetdsouza.zoxide        # zoxide
winget install eza-community.eza         # eza
winget install Neovim.Neovim             # Neovim
```

Install a Nerd Font (required for Oh My Posh icons):
```powershell
oh-my-posh font install Meslo
```
Then set your Windows Terminal font to **MesloLGM Nerd Font**.

Install PSReadLine (if not already present):
```powershell
Install-Module PSReadLine -Scope CurrentUser -Force
```

### What the profile provides

- **Oh My Posh** with Catppuccin Mocha theme (matches WSL tmux/nvim)
- **PSReadLine** in vi mode with history-based inline autocomplete (dropdown list)
- **zoxide** for smart directory jumping (`cd` learns your habits)
- **fzf** with Catppuccin colors
- Git aliases (`gst`, `gco`, `gcm`, …) matching zsh aliases
- WSL launchers (`wsl-bash`, `wsl-zsh`)
- `open` → `explorer .`

---

## Windows Terminal recommended settings

Add to your Windows Terminal `settings.json` profile for WSL:

```json
{
  "name": "Ubuntu (WSL)",
  "source": "Windows.Terminal.Wsl",
  "fontFace": "MesloLGM Nerd Font",
  "fontSize": 12,
  "colorScheme": "Catppuccin Mocha",
  "startingDirectory": "//wsl$/Ubuntu/home/<your-username>",
  "opacity": 95,
  "useAcrylic": true
}
```

Install the Catppuccin color scheme for Windows Terminal from:
https://github.com/catppuccin/windows-terminal

---

## Relationship to macOS branch

The `main` branch contains the macOS config (Homebrew, iTerm2, solarized-osaka, macOS paths). The `wsl-setup` branch diverges in these ways:

- Neovim colorscheme → Catppuccin Mocha
- Tmux statusline → Catppuccin Mocha (new inline theme, no separate `statusline.conf`)
- `.zshrc` → Ubuntu/WSL paths, no Homebrew, no conda, no macOS-specific exports
- PowerShell profile → new file (no equivalent on macOS)
- Install script → `install-wsl.sh` (vs. no automated installer on macOS)

Configs that are intentionally shared: `keymaps.lua`, `autocmds.lua`, the Harpoon/Oil/surround plugins, the vi-mode cursor logic in `.zshrc`.

---

## Troubleshooting

**Neovim clipboard not working**
Make sure `clip.exe` is accessible from WSL: `which clip.exe` should return a path. If not, ensure WSL interop is enabled in `/etc/wsl.conf`.

**Powerlevel10k icons look broken**
You need a Nerd Font installed in Windows Terminal. Run `p10k configure` and choose the "nerdfont-complete" option.

**Tmux colors look wrong**
Check that your terminal reports `$TERM` as `xterm-256color` or `tmux-256color`. In Windows Terminal, set `"colorScheme": "Catppuccin Mocha"` for best results.

**`fdfind` not found as `fd`**
The installer creates the symlink automatically. If you ran the installer with `--dry-run`, do: `ln -sf $(which fdfind) ~/.local/bin/fd`.

**`bat` not found**
Same as above: `ln -sf $(which batcat) ~/.local/bin/bat`.
