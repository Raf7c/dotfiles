#!/bin/sh
# Install norminette and c_formatter_42 for 42 school

set -eu

# Load asdf
if [ -n "${ASDF_DATA_DIR:-}" ] && [ -f "${ASDF_DATA_DIR}/asdf.sh" ]; then
    . "${ASDF_DATA_DIR}/asdf.sh"
elif [ -f "${HOME}/.asdf/asdf.sh" ]; then
    . "${HOME}/.asdf/asdf.sh"
fi

# Get Python path via asdf
PYTHON_BIN=$(asdf where python)/bin
PYTHON_CMD="$PYTHON_BIN/python3"

# Ensure using asdf pip (avoid ~/.local)
export PIP_USER=false

# Install norminette and c_formatter_42
echo "📚 Installing norminette..."
"$PYTHON_CMD" -m pip install -U norminette

echo "📝 Installing c_formatter_42..."
"$PYTHON_CMD" -m pip install -U --force-reinstall --no-deps c-formatter-42

echo "✅ Installation complete!"