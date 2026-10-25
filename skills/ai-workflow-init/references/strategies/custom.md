# Preset fragment: direct input (custom strategy skill)

The user names a skill they already use for large tasks. This fragment knows nothing about that skill's artifacts or setup; it only inserts the name and delegates everything else.

## Slot values

- Ask: "What is the skill name (without the leading `/`)?" Accept letters, digits, `-`, `_`, `.`, `:` only; strip a leading `/`. If the input has spaces or other characters, ask again. Do not check that the skill exists; setup tells the user to install it.
- `{{STRATEGY_SKILL}}` → the name as typed. Substituted **only** in the large-task bullet of CLAUDE.md and step 6 of `issue-start`; never in this fragment's rules block.
- `{{STRATEGY_PRECHECK}}` → empty.
- `{{STRATEGY_INVOKE_NOTE}}` → empty.
- `{{STRATEGY_TRACKER_NOTES}}` → empty.
- Marker value: `strategy=custom:<skill-name>`.
- Requires (for the summary): that skill must be installed, and any setup it needs must be done by the user. Say so plainly; nothing is installed for them.

## Workflow rules (`{{STRATEGY_RULES}}`)

Write this block into CLAUDE.md, translated, directly after the "Starting work on an issue" section. It contains no skill name and no assumptions about artifacts.

---BEGIN---
## Large-task workflow: custom skill

- **Procedure and artifacts**: follow the selected strategy skill for the whole large-task procedure — where its documents live, how sub-tasks are split, and what is checked before a commit. Do not invent locations or steps it does not define, and do not imitate it in this conversation.
- **Setup**: any installation or configuration that skill needs is the user's responsibility; if the command is not found, tell the user instead of improvising.
- **Branch, commit, PR**: use the issue and branch conventions above unless the strategy skill states otherwise; commit and open PRs only on the user's explicit request.
---END---
