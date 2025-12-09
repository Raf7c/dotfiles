#!/usr/bin/env bash
# Bascule entre les thèmes mocha (dark) et latte (light)

# Récupère le thème actuel depuis une variable tmux
CURRENT_THEME=$(tmux show-option -gqv @theme 2>/dev/null || echo "latte")

# Bascule vers l'autre thème
if [ "$CURRENT_THEME" = "mocha" ]; then
    NEW_THEME="latte"
    THEME_FILE="$HOME/.config/tmux/themes/latte.conf"
elif [ "$CURRENT_THEME" = "latte" ]; then
    NEW_THEME="mocha"
    THEME_FILE="$HOME/.config/tmux/themes/mocha.conf"
else
    # Par défaut, si le thème n'est pas reconnu, bascule vers mocha
    NEW_THEME="mocha"
    THEME_FILE="$HOME/.config/tmux/themes/mocha.conf"
fi

# Charge le nouveau thème
tmux source-file "$THEME_FILE"
tmux set-option -g @theme "$NEW_THEME"
tmux display-message "Theme switched to: $NEW_THEME"

