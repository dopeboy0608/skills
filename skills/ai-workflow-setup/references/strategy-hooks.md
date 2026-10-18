# Strategy hooks (setup step 4)

Read **only** the section that matches `strategy=` in the `CLAUDE.md` marker. Never mention or check the other strategies.

## `feature-strategy`

No extra installation. Only the `dopeboy0608-skills` plugin check from step 4 applies.

## `speckit`

Spec Kit adds the `/speckit.*` commands that the large-task path needs. Every command below runs only after the user says yes, one at a time.

1. **Check the CLI**: `command -v specify`. If missing, tell the user how to install it (see the Spec Kit documentation; do not guess a package name) and let them do it, or offer to run the install command they give you. Do not continue to 2 until `specify` exists.
2. **Check the project files**: look for `.specify/` and `.claude/skills/speckit*` or `.claude/commands/speckit*`. If present, report "already initialized" and skip 3.
3. **Initialize**: show `specify init --here --integration claude`, warn that it writes into the current directory (`.specify/`, Claude command/skill files, and possibly agent context files), and ask "Run it now?". Run it only after a yes. If it asks about existing files, let the user answer; never delete files.
4. **`AGENTS.md` sync (once, with approval)**: if init created or changed `AGENTS.md` or touched `CLAUDE.md`, show the diff. Propose keeping `CLAUDE.md` as the single source of rules and making `AGENTS.md` a short pointer to it (or copying the shared rules once), write it only after approval, and do not touch `AGENTS.md` again on later runs. If neither file changed, skip. Existing user content in either file is never overwritten.
5. **Verify command names**: read `.specify/integration.json` (`invoke_separator`) and list the installed `speckit*` skills (`.claude/skills/speckit-*`). The documents were written with `/speckit-specify`, `/speckit-plan`, ... (separator `-`). If the installed names differ (for example `.`), show the affected lines in `CLAUDE.md` and `.claude/skills/issue-start/SKILL.md` and replace them only after approval; grep afterwards to confirm no old spelling is left.
6. Run `git status` and report which files were added so the user can commit them; do not commit. `.specify/` and the installed skills are meant to be committed.

## `custom:<skill-name>`

Do **not** install or configure anything. Tell the user:

- the skill `<skill-name>` must be installed in this project (or user-level) for the large-task path to work;
- any setup that skill needs (CLI, config files, accounts) is theirs to do; if they tell you what it is, you may list it as a checklist but run nothing;
- if `/<skill-name>` is not found later, `issue-start` stops and tells them to check this.

## `none`

Nothing to install. Report that large issues are not routed to any workflow and should be split into smaller issues before `/issue-start`.
