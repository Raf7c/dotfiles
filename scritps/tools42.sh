#!/usr/bin/env bash
# Install norminette (42 school) + c_formatter_42
# Usage: ./install-42-tools.sh

set -e

# Python 3.10+ pour norminette, 3.8+ pour c_formatter_42
if ! command -v python3 &>/dev/null; then
  echo "Erreur: python3 requis (3.10+ pour norminette)." >&2
  exit 1
fi

echo "Installation de norminette (42school) et c_formatter_42..."

# Norminette — https://github.com/42school/norminette
python3 -m pip install --user -U norminette 2>/dev/null || python3 -m pip install -U norminette

# c_formatter_42 — https://github.com/dawnbeen/c_formatter_42
python3 -m pip install --user -U c-formatter-42 2>/dev/null || python3 -m pip install -U c-formatter-42

echo "Vérification..."
command -v norminette && norminette --version 2>/dev/null || true
command -v c_formatter_42 && echo "c_formatter_42 OK" || true

echo "Terminé. Utilisation: norminette [fichier.c], c_formatter_42 < file.c"