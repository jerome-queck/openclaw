#!/usr/bin/env bash
# usage: run.sh <worktree>
cd "$1"
export OPENCLAW_STATE_DIR=$(mktemp -d)
run() { printf '\n$ openclaw gateway restart %s\n' "$*"; node openclaw.mjs gateway restart "$@" 2>&1; echo "[exit $?]"; }
echo "# $(git log -1 --format='%h %s')"
run --skip-deferral
run --safe --force
run --safe --wait 5s
run --force --wait 5s
# --preserve-definition is guarded by service-mutation checks that refuse a temp state dir; use the default one (fails before any action)
( unset OPENCLAW_STATE_DIR; run --safe --preserve-definition )
run --skip-deferral --json
