# Tracker fragment: other tracker (Jira, Linear, ...) — delegated

The user names a tracker. The skill writes the name and delegates everything else. It never writes tool-specific commands and has no Jira- or Linear-specific logic.

## Slot values

- Ask: "Which tracker do you use (name only)?" Accept letters, digits, spaces, `-`, `.`; reject anything else and ask again. Do not check that the tracker or its tool exists.
- Marker value: `tracker=custom:<name>` with spaces replaced by `-`.
- `{{ARG_NOUN}}` → "a ticket key". `{{ARG_HINT}}` → "ticket key (e.g. ABC-24)".
- `{{ITEM_INPUT}}` → "**Ticket**: if `$ARGUMENTS` has none, ask the user for the ticket key."
- `{{ISSUE_LOOKUP}}` → "read the ticket in <name> with whatever tool is available in this session for that tracker (an MCP connector, its CLI, or a pasted description). If no tool can read it, ask the user to paste the title and description. Do not guess ticket content."
- `{{TRACKER_SECTION_NAME}}` → "Issue tracker: <name>".
- `{{LABEL_STEP}}` → removed. State changes (for example moving a ticket to in-progress) happen only when the user asks, with the tracker's own tool.
- `{{BRANCH_PATTERN}}` → `<type>/<KEY>-<description>`. `{{BRANCH_TYPE_RULE}}` → "Choose the type from the ticket type or the nature of the work (`bug/`, `feature/`, `chore/`, `docs/`) and confirm with the user."
- `{{HANDOFF_EXAMPLE}}` → `<KEY>: <title> — <description summary>`.
- `{{STRATEGY_TRACKER_NOTES}}` → empty.
- Needs (for the summary): access to that tracker from this session. `ai-workflow-setup` only tells the user to set it up; it runs and installs nothing. `<name>` appears only in the marker and in this fragment's own rules block and the `{{TRACKER_SECTION_NAME}}` / `{{ISSUE_LOOKUP}}` values above.

## Rules (`{{TRACKER_RULES}}`)

Write this block into CLAUDE.md, translated, in the place of the issue management section.

---BEGIN---
## Issue tracker: <name>

- **Reading and writing tickets**: use the tools this session has for <name>. Ask the user before every externally visible action (create, edit, change state, comment). If no tool is available, ask the user to paste what is needed instead of guessing.
- **Branch convention**: `type/KEY-description`, with type one of `feature/`, `bug/`, `chore/`, `docs/`. Recognize the ticket key from the branch name; ask if it cannot be recognized.
- **Ticket links**: follow the team's convention for linking commits and PRs to tickets; do not invent closing keywords.
- **Branch deletion**: never delete branches (local/remote) automatically. Delete only on the user's explicit request.
- Commands, labels, and workflows specific to <name> are not defined here; follow the tool's own documentation.
---END---
