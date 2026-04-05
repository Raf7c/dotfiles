#!/usr/bin/env bash
# Install norminette (42 school) + c_formatter_42
# Usage: ./install-42-tools.sh

set -e

# Python 3.10+ for norminette, 3.8+ for c_formatter_42
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 required (3.10+ for norminette)." >&2
  exit 1
fi

echo "Installing norminette (42school) and c_formatter_42..."

# Norminette — https://github.com/42school/norminette
python3 -m pip install --user -U norminette 2>/dev/null || python3 -m pip install -U norminette

# c_formatter_42 — https://github.com/dawnbeen/c_formatter_42
python3 -m pip install --user -U c-formatter-42 2>/dev/null || python3 -m pip install -U c-formatter-42

echo "Verifying..."
command -v norminette && norminette --version 2>/dev/null || true
command -v c_formatter_42 && echo "c_formatter_42 OK" || true

echo "Done. Usage: norminette [file.c], c_formatter_42 < file.c"