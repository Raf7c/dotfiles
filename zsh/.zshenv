# ==========================================
# ~/.zshenv
# Variables d'environnement (chargées en premier)
# ==========================================

# Variables d'env communes (utiles aux deux shells)
: "${XDG_CONFIG_HOME:=${HOME}/.config}"
: "${XDG_CACHE_HOME:=${HOME}/.cache}"
: "${XDG_DATA_HOME:=${HOME}/.local/share}"
: "${DOTFILES:=${HOME}/.dotfiles}"

# PATH : bin perso en tête
PATH="${HOME}/.local/bin:${PATH}"

export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME DOTFILES PATH