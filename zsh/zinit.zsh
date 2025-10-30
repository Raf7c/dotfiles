# ==========================================
# ~/.zsh/zinit.zsh
# Zinit plugins configuration
# ==========================================

# Zinit configuration
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

# Load critical plugin first
zinit load zsh-users/zsh-completions

# Load non-critical plugins asynchronously
zinit wait lucid for \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    atinit"zicompinit; zicdreplay" \
        zsh-users/zsh-syntax-highlighting

# Load fzf-tab normally
zinit light Aloxaf/fzf-tab

# Initialize completions
: ${XDG_CACHE_HOME:=$HOME/.cache}
mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -Uz compinit
compinit -C -d "$XDG_CACHE_HOME/zsh/.zcompdump"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# fzf-tab preview (with fallback if eza is not installed)
if command -v eza &>/dev/null; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null'
    # Preview for zoxide only if installed
    if command -v zoxide &>/dev/null; then
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null'
    fi
else
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath 2>/dev/null'
fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

