#!/usr/bin/env bash
# Rebuild the local test pack from skills/. The pack is git-ignored; this script is the
# versioned source of truth for how it is built (see docs/DEVELOPMENT.md).
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
pack="$root/_sandbox-pack"

rm -rf "$pack/.claude/skills"
mkdir -p "$pack/.claude/skills"
cp -R "$root/skills/ai-workflow-init" "$root/skills/ai-workflow-setup" "$root/skills/feature-strategy" "$pack/.claude/skills/"

if [ ! -f "$pack/README.txt" ]; then
  cat > "$pack/README.txt" <<'TXT'
Sandbox pack: copy .claude into an EMPTY test directory, then open a NEW session there.
  mkdir ~/tmp/aiw-test && cd ~/tmp/aiw-test && git init
  cp -R <repo>/_sandbox-pack/.claude .
Regenerate after editing skills/: scripts/sync-sandbox.sh (from the repo root).
TXT
fi
echo "Synced $(ls "$pack/.claude/skills" | tr '\n' ' ')to $pack"
