#!/usr/bin/env sh
# Install norminette (42 school) + c_formatter_42.
set -eu

# Python 3.10+: norminette is what sets the floor (c_formatter_42 asks 3.7).
command -v python3 >/dev/null 2>&1 || {
  printf 'Error: python3 required (3.10+ for norminette).\n' >&2
  exit 1
}
# Checked, not merely announced: pipx would happily install norminette against
# an older python, and the failure would surface far from here.
python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' || {
  printf 'Error: python3 %s is too old, norminette needs 3.10+.\n' \
    "$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')" >&2
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
