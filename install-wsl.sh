#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════
#  install-wsl.sh
#  Bootstrap Lucas's dotfiles on a fresh WSL instance
#  Usage: bash install-wsl.sh [--dry-run]
# ══════════════════════════════════════════════════════════

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

# ── Helpers ───────────────────────────────────────────────
info()    { echo -e "\033[34m[INFO]\033[0m  $*"; }
success() { echo -e "\033[32m[OK]\033[0m    $*"; }
warn()    { echo -e "\033[33m[WARN]\033[0m  $*"; }
err()     { echo -e "\033[31m[ERR]\033[0m   $*" >&2; }

symlink() {
  local src="$1" dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  if $DRY_RUN; then
    info "[dry-run] ln -sf $src -> $dst"
    return
  fi

  mkdir -p "$dst_dir"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warn "Backing up existing $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  ln -sf "$src" "$dst"
  success "Linked $dst"
}

have() { command -v "$1" &>/dev/null; }

# ── Parse args ────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true; warn "Dry-run mode: no changes will be made." ;;
    --help|-h)
      echo "Usage: $0 [--dry-run]"
      echo "  Symlinks dotfiles and installs WSL terminal environment."
      exit 0
      ;;
  esac
done

echo ""
echo "  Lucas's WSL Dotfiles Installer"
echo "  ================================"
echo "  Dotfiles dir: $DOTFILES_DIR"
echo ""

# ═══════════════════════════════════════════════════════════
# 1. APT packages
# ═══════════════════════════════════════════════════════════
info "Updating apt and installing base packages..."
if ! $DRY_RUN; then
  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends \
    git curl wget unzip tar gzip \
    build-essential cmake pkg-config \
    python3 python3-pip python3-venv \
    ripgrep fd-find bat fzf \
    zsh tmux \
    xclip xsel \
    fontconfig \
    ca-certificates \
    gpg \
    2>/dev/null
  success "APT packages installed"
else
  info "[dry-run] apt-get install ..."
fi

# ── fd: Ubuntu ships it as fdfind ─────────────────────────
if ! $DRY_RUN && have fdfind && ! have fd; then
  ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
  success "Linked fdfind -> fd"
fi

# ── bat: Ubuntu ships it as batcat ────────────────────────
if ! $DRY_RUN && have batcat && ! have bat; then
  ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
  success "Linked batcat -> bat"
fi

# ═══════════════════════════════════════════════════════════
# 2. Neovim (latest stable AppImage)
# ═══════════════════════════════════════════════════════════
if ! have nvim || [[ "$(nvim --version | head -1)" < "NVIM v0.10" ]]; then
  info "Installing Neovim (latest stable)..."
  if ! $DRY_RUN; then
    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
    NVIM_DEST="$HOME/.local/bin/nvim.appimage"
    mkdir -p "$HOME/.local/bin"
    curl -Lo "$NVIM_DEST" "$NVIM_URL"
    chmod +x "$NVIM_DEST"
    # Extract appimage (no FUSE needed in WSL)
    cd "$HOME/.local"
    "$NVIM_DEST" --appimage-extract &>/dev/null || true
    ln -sf "$HOME/.local/squashfs-root/usr/bin/nvim" "$HOME/.local/bin/nvim"
    success "Neovim installed"
  else
    info "[dry-run] install nvim"
  fi
else
  success "Neovim already up to date: $(nvim --version | head -1)"
fi

# ═══════════════════════════════════════════════════════════
# 3. Oh My Zsh
# ═══════════════════════════════════════════════════════════
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  if ! $DRY_RUN; then
    RUNZSH=no CHSH=no sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    success "Oh My Zsh installed"
  else
    info "[dry-run] install oh-my-zsh"
  fi
else
  success "Oh My Zsh already present"
fi

# ── OMZ plugins ───────────────────────────────────────────
OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_omz_plugin() {
  local name="$1" url="$2"
  local dest="$OMZ_CUSTOM/plugins/$name"
  if [[ ! -d "$dest" ]]; then
    info "Installing OMZ plugin: $name"
    $DRY_RUN || git clone --depth=1 "$url" "$dest"
  else
    success "OMZ plugin already present: $name"
  fi
}

install_omz_plugin "zsh-autosuggestions" \
  "https://github.com/zsh-users/zsh-autosuggestions"
install_omz_plugin "zsh-syntax-highlighting" \
  "https://github.com/zsh-users/zsh-syntax-highlighting"

# ── Powerlevel10k theme ───────────────────────────────────
P10K_DIR="$OMZ_CUSTOM/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  info "Installing Powerlevel10k theme..."
  $DRY_RUN || git clone --depth=1 \
    "https://github.com/romkatv/powerlevel10k.git" "$P10K_DIR"
  success "Powerlevel10k installed"
else
  success "Powerlevel10k already present"
fi

# ═══════════════════════════════════════════════════════════
# 4. eza (modern ls replacement)
# ═══════════════════════════════════════════════════════════
if ! have eza; then
  info "Installing eza..."
  if ! $DRY_RUN; then
    # Install via cargo if available, else download binary
    if have cargo; then
      cargo install eza
    else
      EZA_URL="https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"
      curl -Lo /tmp/eza.tar.gz "$EZA_URL"
      tar -xzf /tmp/eza.tar.gz -C /tmp/
      mv /tmp/eza "$HOME/.local/bin/eza"
      chmod +x "$HOME/.local/bin/eza"
    fi
    success "eza installed"
  else
    info "[dry-run] install eza"
  fi
else
  success "eza already present"
fi

# ═══════════════════════════════════════════════════════════
# 5. zoxide (smarter cd)
# ═══════════════════════════════════════════════════════════
if ! have zoxide; then
  info "Installing zoxide..."
  if ! $DRY_RUN; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    success "zoxide installed"
  else
    info "[dry-run] install zoxide"
  fi
else
  success "zoxide already present"
fi

# ═══════════════════════════════════════════════════════════
# 6. TPM (Tmux Plugin Manager)
# ═══════════════════════════════════════════════════════════
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  info "Installing TPM..."
  $DRY_RUN || git clone --depth=1 \
    "https://github.com/tmux-plugins/tpm" "$TPM_DIR"
  success "TPM installed"
else
  success "TPM already present"
fi

# ═══════════════════════════════════════════════════════════
# 7. NVM (Node Version Manager)
# ═══════════════════════════════════════════════════════════
if [[ ! -d "$HOME/.nvm" ]]; then
  info "Installing NVM..."
  if ! $DRY_RUN; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    # Load nvm for this session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    # Install LTS node
    nvm install --lts
    success "NVM + Node LTS installed"
  else
    info "[dry-run] install nvm"
  fi
else
  success "NVM already present"
fi

# ═══════════════════════════════════════════════════════════
# 8. Rust (needed for some tools)
# ═══════════════════════════════════════════════════════════
if ! have cargo; then
  info "Installing Rust via rustup..."
  if ! $DRY_RUN; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env"
    success "Rust installed"
  else
    info "[dry-run] install rust"
  fi
else
  success "Rust/cargo already present: $(cargo --version)"
fi

# ═══════════════════════════════════════════════════════════
# 9. Atuin (shell history sync)
# ═══════════════════════════════════════════════════════════
if ! have atuin; then
  info "Installing atuin..."
  if ! $DRY_RUN; then
    curl --proto '=https' --tlsv1.2 -LsSf \
      https://setup.atuin.sh | sh
    success "atuin installed"
  else
    info "[dry-run] install atuin"
  fi
else
  success "atuin already present"
fi

# ═══════════════════════════════════════════════════════════
# 10. Symlink configs
# ═══════════════════════════════════════════════════════════
info "Symlinking dotfiles..."

# Shell
symlink "$DOTFILES_DIR/.zshrc"       "$HOME/.zshrc"
symlink "$DOTFILES_DIR/.zlogout"     "$HOME/.zlogout"

# Neovim
symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# Tmux
symlink "$DOTFILES_DIR/.config/tmux/tmux.conf"     "$HOME/.config/tmux/tmux.conf"
symlink "$DOTFILES_DIR/.config/tmux/statusline.conf" "$HOME/.config/tmux/statusline.conf"

# Atuin
symlink "$DOTFILES_DIR/.config/atuin/config.toml" "$HOME/.config/atuin/config.toml"

# ═══════════════════════════════════════════════════════════
# 11. Set default shell to zsh
# ═══════════════════════════════════════════════════════════
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  info "Setting zsh as default shell..."
  if ! $DRY_RUN; then
    chsh -s "$(which zsh)"
    success "Default shell set to zsh (takes effect on next login)"
  else
    info "[dry-run] chsh -s $(which zsh)"
  fi
else
  success "zsh is already the default shell"
fi

# ═══════════════════════════════════════════════════════════
# Done
# ═══════════════════════════════════════════════════════════
echo ""
echo "  ✅ Done! Next steps:"
echo ""
echo "  1. Start a new zsh session: exec zsh"
echo "  2. Run p10k configure (or copy your .p10k.zsh from macOS)"
echo "  3. Open tmux and press Prefix + I to install TPM plugins"
echo "  4. Open Neovim — lazy.nvim will auto-install all plugins"
echo "  5. In Neovim, run :Mason to check/install LSP servers"
echo ""
echo "  See README-WSL.md for full details."
echo ""
