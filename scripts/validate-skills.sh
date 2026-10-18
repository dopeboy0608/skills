#!/usr/bin/env bash
# Structure checks for the plugin: JSON validity, skill folders, frontmatter, version consistency.
# Run from anywhere; exits non-zero on the first category of failures found.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
exec python3 -I - "$root" <<'PY'
import json, os, re, sys
root = sys.argv[1]
errors = []

def err(m): errors.append(m)

manifest_path = os.path.join(root, ".claude-plugin", "plugin.json")
try:
    manifest = json.load(open(manifest_path))
except Exception as e:
    print(f"FAIL plugin.json is not valid JSON: {e}"); sys.exit(1)

version = manifest.get("version", "")
if not re.fullmatch(r"\d+\.\d+\.\d+", version): err(f"plugin.json version is not semver: {version!r}")

listed = manifest.get("skills", [])
for rel in listed:
    d = os.path.join(root, rel)
    if not os.path.isdir(d): err(f"plugin.json skills path does not exist: {rel}"); continue
    name = os.path.basename(rel.rstrip("/"))
    for f in ("SKILL.md", "SKILL.ko.md"):
        if not os.path.isfile(os.path.join(d, f)): err(f"{rel}: missing {f}")
    p = os.path.join(d, "SKILL.md")
    if os.path.isfile(p):
        text = open(p, encoding="utf-8").read()
        m = re.match(r"---\n(.*?)\n---\n", text, re.S)
        if not m: err(f"{rel}/SKILL.md: no frontmatter"); continue
        fm = dict(re.findall(r"^([A-Za-z-]+):\s*(.*)$", m.group(1), re.M))
        if not fm.get("name"): err(f"{rel}/SKILL.md: frontmatter name is missing")
        elif fm["name"] != name: err(f"{rel}/SKILL.md: name {fm['name']!r} does not match folder {name!r}")
        if not fm.get("description"): err(f"{rel}/SKILL.md: frontmatter description is missing")

# skills on disk but not listed
skills_dir = os.path.join(root, "skills")
for n in sorted(os.listdir(skills_dir)):
    if os.path.isdir(os.path.join(skills_dir, n)) and f"./skills/{n}" not in listed:
        err(f"skills/{n} exists but is not listed in plugin.json")

# the marker version written by ai-workflow-init must equal the plugin version
for f in ("SKILL.md", "SKILL.ko.md"):
    p = os.path.join(root, "skills", "ai-workflow-init", f)
    if os.path.isfile(p):
        vs = set(re.findall(r"ai-workflow: version=(\d+\.\d+\.\d+)", open(p, encoding="utf-8").read()))
        if vs and vs != {version}: err(f"ai-workflow-init/{f}: marker version {sorted(vs)} != plugin.json {version}")

# generated-content leakage guard
if os.path.exists(os.path.join(root, "_sandbox-pack")):
    import subprocess
    tracked = subprocess.run(["git", "-C", root, "ls-files", "_sandbox-pack"], capture_output=True, text=True).stdout.strip()
    if tracked: err("_sandbox-pack is tracked by git")

if errors:
    print("FAIL"); [print(" -", e) for e in errors]; sys.exit(1)
print(f"OK ({len(listed)} skills, version {version})")
PY
