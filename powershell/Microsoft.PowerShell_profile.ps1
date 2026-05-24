# ══════════════════════════════════════════════════════════
#  Microsoft.PowerShell_profile.ps1
#  Windows PowerShell / PowerShell 7 profile
#  Lucas Libshutz — WSL companion profile
# ══════════════════════════════════════════════════════════

# ── Oh My Posh prompt ────────────────────────────────────
# Install: winget install JanDeLaater.OhMyPosh
# Then: oh-my-posh font install Meslo
# Set terminal font to "MesloLGM Nerd Font" in Windows Terminal settings
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    # Catppuccin Mocha theme (matches tmux/nvim)
    $ompTheme = "$env:POSH_THEMES_PATH\catppuccin_mocha.omp.json"
    if (Test-Path $ompTheme) {
        oh-my-posh init pwsh --config $ompTheme | Invoke-Expression
    } else {
        # Fallback to a built-in minimal theme
        oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\1_shell.omp.json" | Invoke-Expression
    }
}

# ── PSReadLine: better history & autocomplete ────────────
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine

    # History-based autocomplete (inline, like fish shell)
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView     # dropdown list
    Set-PSReadLineOption -EditMode Vi                       # vi key bindings

    # Key bindings
    Set-PSReadLineKeyHandler -Key Tab            -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow        -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow      -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord Ctrl+p       -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Chord Ctrl+n       -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord Ctrl+r       -Function ReverseSearchHistory
    Set-PSReadLineKeyHandler -Chord Ctrl+f       -Function ForwardChar
    Set-PSReadLineKeyHandler -Chord Alt+f        -Function ForwardWord
    Set-PSReadLineKeyHandler -Chord Alt+b        -Function BackwardWord

    # Color scheme (Catppuccin-inspired)
    Set-PSReadLineOption -Colors @{
        Command            = '#89b4fa'  # blue
        Parameter          = '#cba6f7'  # mauve
        Operator           = '#89dceb'  # sky
        Variable           = '#a6e3a1'  # green
        String             = '#a6e3a1'  # green
        Number             = '#fab387'  # peach
        Member             = '#f38ba8'  # red
        Comment            = '#6c7086'  # overlay0
        Keyword            = '#cba6f7'  # mauve
        Type               = '#f9e2af'  # yellow
        InlinePrediction   = '#585b70'  # surface2 (ghost text)
    }

    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -HistorySavePath "$env:USERPROFILE\.ps_history"
    Set-PSReadLineOption -MaximumHistoryCount 10000
}

# ── zoxide: smarter cd ────────────────────────────────────
# Install: winget install ajeetdsouza.zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ── fzf integration ───────────────────────────────────────
# Install: winget install junegunn.fzf
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    $env:FZF_DEFAULT_OPTS = @"
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--height 40% --border rounded --layout reverse
"@
}

# ── Aliases (mirrors common zsh/bash aliases) ─────────────

# Navigation
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function ~ { Set-Location $env:USERPROFILE }

# Listing (use eza if available, else Get-ChildItem)
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls  { eza --icons @args }
    function ll  { eza -l -a -g --icons --git @args }
    function la  { eza -la --icons @args }
    function lt  { eza -T --icons --git-ignore @args }
} else {
    function ll  { Get-ChildItem -Force @args }
    function la  { Get-ChildItem -Force @args }
}

# Editor
function vim  { nvim @args }
function vi   { nvim @args }
function v    { nvim @args }

# Git shortcuts
function g    { git @args }
function ga   { git add @args }
function gaa  { git add --all @args }
function gc   { git commit @args }
function gcm  { git commit -m @args }
function gco  { git checkout @args }
function gcb  { git checkout -b @args }
function gd   { git diff @args }
function gl   { git log --oneline --graph --decorate --all @args }
function gp   { git push @args }
function gpl  { git pull @args }
function gst  { git status @args }
function gsw  { git switch @args }

# Utilities
function c    { Clear-Host }
function which { Get-Command @args | Select-Object -ExpandProperty Source }
function grep { Select-String @args }

# WSL launchers
function wsl-bash   { wsl bash -l }
function wsl-zsh    { wsl zsh -l }
function wsl-ubuntu { wsl -d Ubuntu }

# Open Windows Explorer in current dir
function open { explorer . }

# Python
function py   { python @args }
function ipy  { ipython @args }

# Docker
function d    { docker @args }
function dc   { docker compose @args }
function dps  { docker ps @args }

# Reload profile
function reload { . $PROFILE }
function profrc { nvim $PROFILE }

# ── Environment ───────────────────────────────────────────
$env:EDITOR = "nvim"

# Add Scoop shims if installed
if (Test-Path "$env:USERPROFILE\scoop\shims") {
    $env:PATH += ";$env:USERPROFILE\scoop\shims"
}

# ── Startup message ───────────────────────────────────────
Write-Host ""
Write-Host "  PowerShell $($PSVersionTable.PSVersion)  |  $(Get-Date -Format 'dddd, MMMM d')" -ForegroundColor '#6c7086'
Write-Host ""
