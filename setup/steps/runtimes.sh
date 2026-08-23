#!/usr/bin/env sh
# Step runtimes: `mise install`. Source of truth for the versions:
# ~/.config/mise/config.toml, linked by symlinks. Needs mise on the PATH,
# put there by packages; missing mise is a clean skip, not an error.

hash -r

if ! command -v mise >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/mise" ]; then
  if [ "$DRY_RUN" = 1 ]; then
    # Faithful preview: in a real run packages installs mise just before.
    log_info "[dry-run] mise trust + mise install (mise installed by packages)"
    return 0
  fi
  log_warn "mise missing -> step skipped (install via packages)"
  return 0
fi

# mise may have just landed in ~/.local/bin without being hashed yet.
_mise=$(command -v mise 2>/dev/null || printf '%s' "$HOME/.local/bin/mise")

# run_soft: one runtime that fails to build must be logged, not abort.
run_soft "$_mise" trust -- "${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml"
run_soft "$_mise" install
log_ok "runtimes (mise) installed from ~/.config/mise/config.toml"
unset _mise
