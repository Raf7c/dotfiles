# lib/run.sh — links, tmux (TPM), shell, Homebrew, asdf, macOS defaults (sourced by dot.sh)

os="$(detect_os)"

info "Sync ($os)"

run_script "$DOTS_ROOT/src/common/links.sh"
run_script "$DOTS_ROOT/src/common/shell.sh"
run_script "$DOTS_ROOT/src/common/tmux.sh"

case "$os" in
  macos)
    run_script "$DOTS_ROOT/src/macos/homebrew.sh"
    run_script "$DOTS_ROOT/src/common/asdf.sh"
    run_script "$DOTS_ROOT/src/macos/osx.sh"
    ;;
  *)
    warn "No platform-specific setup for this OS (macOS only)"
    ;;
esac

info "Sync complete"

if [ -t 1 ]; then
  info "Starting login shell: ${SHELL:-/bin/sh} -l"
  exec "${SHELL:-/bin/sh}" -l
fi
