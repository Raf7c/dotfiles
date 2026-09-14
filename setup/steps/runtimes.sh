#!/usr/bin/env sh
# Step runtimes: `mise install`. Source of truth for the versions:
# ~/.config/mise/config.toml, linked by symlinks. Needs mise on the PATH,
# put there by packages; missing mise is a clean skip, not an error.

hash -r

if ! command -v mise >/dev/null 2>&1; then
  if [ "$DRY_RUN" = 1 ]; then
    # Faithful preview (docs/installer.md, contrat n°2).
    log_info "[dry-run] mise trust + mise install — assumes the FULL run, where"
    log_info "          packages installs mise first; alone, this step would skip"
    return 0
  fi
  log_warn "mise missing -> step skipped (install via packages)"
  return 0
fi

# run_soft: one runtime that fails to build must be logged, not abort. Plain
# `mise`, no path: brew is the only thing that installs it here, and the
# `hash -r` above is what makes a brew-fresh mise visible to this shell.
run_soft mise trust -- "${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml"
run_soft mise install
log_done_clean "runtimes (mise) installed from ~/.config/mise/config.toml" \
  "runtimes: mise reported a failure (see the ✗ above)"
