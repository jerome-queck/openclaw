#!/usr/bin/env bash
# usage: proof.sh <worktree-with-dist>
W=$1
export HOME=$(mktemp -d) OPENCLAW_STATE_DIR=$HOME/state OPENCLAW_CONFIG_PATH=$HOME/state/openclaw.json NO_COLOR=1
echo "# $(git -C "$W" rev-parse --short HEAD) ($(basename "$W")); config exists: $(test -e "$OPENCLAW_CONFIG_PATH" && echo yes || echo no)"
run() {
  echo "\$ openclaw gateway run $*"
  timeout 60 node "$W/openclaw.mjs" gateway run "$@" 2>&1 | grep -v 'startup phase'
  echo "exit=${PIPESTATUS[0]}"
}
for extra in "" "--allow-unconfigured"; do
  run --port abc $extra
  run --bind bogus $extra
  run --auth bogus $extra
  run --tailscale bogus $extra
  run --ws-log bogus $extra
done
run
