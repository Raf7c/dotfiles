#!/usr/bin/env sh
# Command: install -> ready. Idempotent.
# Runs ALL setup/steps/ (or the selection passed to
# `./run install <names>`, e.g. `./run install symlinks packages`).
# Sourced by `run` (lib/* loaded, OS detected, flags exported).

# shellcheck disable=SC2086
run_steps ${MODULES:-}

log_step "install done."
