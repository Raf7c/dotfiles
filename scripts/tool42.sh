#!/usr/bin/env sh
# Install norminette (42 school) + c_formatter_42.
set -eu

# Python 3.10+ for norminette, 3.8+ for c_formatter_42
command -v python3 >/dev/null 2>&1 || {
  printf 'Error: python3 required (3.10+ for norminette).\n' >&2
  exit 1
}

printf 'Installing norminette (42school) and c_formatter_42...\n'

# pipx, not pip: PEP 668 blocks `pip install --user` on current Fedora and on
# mise-managed pythons. pipx itself comes from mise (config.toml).
command -v pipx >/dev/null 2>&1 || {
  printf 'Error: pipx required -> mise install pipx\n' >&2
  exit 1
}
# Norminette: https://github.com/42school/norminette
pipx upgrade --install norminette
# c_formatter_42: https://github.com/dawnbeen/c_formatter_42
pipx upgrade --install c-formatter-42

printf 'Verifying...\n'
if command -v norminette >/dev/null 2>&1; then
  norminette --version 2>/dev/null || true
fi
command -v c_formatter_42 >/dev/null 2>&1 && printf 'c_formatter_42 OK\n'

printf 'Done. Usage: norminette [file.c], c_formatter_42 < file.c\n'
