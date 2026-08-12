#!/usr/bin/env sh
# Command install: run every step, or only those named on the command line.

# shellcheck disable=SC2086
run_steps ${STEPS_ARG:-}

log_step "install done."
log_summary install || exit 1
