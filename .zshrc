# ══════════════════════════════════════════════════════════
#  .zshrc — WSL edition
#  Adapted from Lucas's macOS dotfiles
# ══════════════════════════════════════════════════════════

# ── Path ──────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"          # Rust / cargo
export PATH="$HOME/go/bin:$PATH"              # Go binaries
export PATH="$HOME/.bun/bin:$PATH"            # Bun

# ── Oh My Zsh ────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

# Theme: powerlevel10k (same as macOS config)
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  tmux
  fzf
  z                    # directory jumping (built into OMZ)
  docker
  docker-compose
  npm
  pip
  python
  golang
  rust
  history-substring-search
  colored-man-pages
  extract
)

# P10k instant prompt (keep near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$ZSH/oh-my-zsh.sh"

# ── Editor ───────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ── Aliases: navigation ───────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# ── Aliases: listing ──────────────────────────────────────
# Use eza if available, fall back to ls
if command -v eza &>/dev/null; then
  alias ls="eza --icons"
  alias ll="eza -l -a -g --icons --git"
  alias lt="eza -T --icons --git-ignore"    # tree view
  alias la="eza -la --icons"
else
  alias ls="ls --color=auto"
  alias ll="ls -lah"
  alias la="ls -la"
fi

# ── Aliases: editors ──────────────────────────────────────
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# ── Aliases: git ──────────────────────────────────────────
alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline --graph --decorate --all"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpl="git pull"
alias gst="git status"
alias grb="git rebase"
alias grs="git restore"
alias grss="git restore --staged"
alias gsw="git switch"

# ── Aliases: utilities ───────────────────────────────────
alias c="clear"
alias reload="source ~/.zshrc"
alias zshrc="$EDITOR ~/.zshrc"
alias tmuxrc="$EDITOR ~/.config/tmux/tmux.conf"
alias nvimrc="$EDITOR ~/.config/nvim"
alias dotfiles="cd ~/dotfiles"

# Grep with color
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Safer rm
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# WSL-specific: open Windows Explorer in current directory
alias open="explorer.exe ."
alias winhome='cd /mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d "\r")'

# Docker
alias d="docker"
alias dc="docker compose"
alias dps="docker ps"
alias dpsa="docker ps -a"

# Python
alias py="python3"
alias pip="pip3"
alias ipy="ipython"
alias venv="python3 -m venv .venv && source .venv/bin/activate"
alias activate="source .venv/bin/activate"

# ── Environment exports ───────────────────────────────────
export repos="$HOME/repos"
export projects="$HOME/projects"

# GPG (needed for git signing in WSL)
export GPG_TTY=$(tty)

# Docker BuildKit
export DOCKER_BUILDKIT=1

# ── NVM (Node Version Manager) ───────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ── pyenv ────────────────────────────────────────────────
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# ── zoxide (smarter cd) ───────────────────────────────────
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# ── fzf ──────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
  source <(fzf --zsh 2>/dev/null) || true
  export FZF_DEFAULT_OPTS="
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --height 40% --border rounded --layout reverse
    --preview-window='right:60%:wrap'
  "
  # Use ripgrep for fzf if available
  if command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# ── atuin (shell history) ─────────────────────────────────
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# ── Vi mode (same as macOS config) ───────────────────────
bindkey -v
bindkey "^R" history-incremental-search-backward

# Cursor shape changes for vi mode
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[1 q'   # Block cursor (normal mode)
  else
    echo -ne '\e[5 q'   # Beam cursor (insert mode)
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[5 q'   # Start in insert mode
}
zle -N zle-line-init

function zle-line-finish {
  echo -ne '\e[5 q'   # Reset after command runs
}
zle -N zle-line-finish

# ── History ───────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# ── Completion ────────────────────────────────────────────
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive completion

# ── Powerlevel10k ─────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Autostart TMUX with terminal, no IDE
if [ -z "$TMUX" ] && [ -z "$VSCODE_INJECTION" ] && [ -z "$INTELLIJ_ENVIRONMENT_READER"] && [ "$TERM_PROGRAM" != "vscode" ] && [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ] && [ -z "$SSH_TTY" ]; then
  exec tmux new-session -s "tmux-$$"
fi

export PATH="/home/llibshutz/.pixi/bin:$PATH"
export vault="/home/llibshutz/Documents/lucas-stuff/Lucas' Stuff/"

export PATH="/usr/local/cuda-12.9/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-12.9/lib64:$LD_LIBRARY_PATH"
