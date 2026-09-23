# dopeboy skills

> 🇰🇷 [한국어 README](./README.ko.md)

Agent skills for refactoring and organizing code. They work in **Claude Code**, **OpenCode**, **Cursor**, **Codex**, **Windsurf**, and any agent that supports the [skills.sh](https://skills.sh) format.

| Skill | What it does |
| --- | --- |
| [`fowler-refactor`](./skills/fowler-refactor/SKILL.md) | Applies Martin Fowler's refactoring catalog. It interviews you, proposes a Before/After plan, and changes code only after you approve, with **zero breaking changes** to existing callers. |
| [`code-organizer`](./skills/code-organizer/SKILL.md) | Reorders imports and hook/state/ref/effect declarations in React/TypeScript code **without changing logic**. |

Korean translations of each skill live next to it as `SKILL.ko.md`. They are for humans; agents only read `SKILL.md`.

---

## Install

### Claude Code (plugin marketplace)

```bash
claude plugin marketplace add dopeboy0608/skills
claude plugin install dopeboy0608-skills
```

Or inside a session: `/plugin marketplace add dopeboy0608/skills`, then `/plugin install dopeboy0608-skills`. Skills show up as `dopeboy0608-skills:fowler-refactor` and `dopeboy0608-skills:code-organizer`.

### Any agent (npx)

Requires **Node.js >= 22.20.0** (`nvm install 22 && nvm use 22`).

```bash
# Interactive: pick skills and agents
npx skills@latest add dopeboy0608/skills

# A single skill
npx skills@latest add dopeboy0608/skills --skill fowler-refactor

# A specific agent
npx skills@latest add dopeboy0608/skills --skill code-organizer --agent opencode
```

In Claude Code, restart the session or run `/reload-skills` after installing.

### Uninstall

```bash
npx skills@latest remove fowler-refactor
npx skills@latest remove --global code-organizer
```

---

## fowler-refactor

Invoke it explicitly:

```
/fowler-refactor
```

It does **not** auto-trigger on casual requests like "clean this up".

1. **Interview** (`grill-me` style): one question at a time, each with a recommended answer, until the target, the smell, and the constraints are clear.
2. **Pattern mapping**: picks patterns from the Fowler catalog (Extract Function, Decompose Conditional, Split Phase, Replace Conditional with Lookup Table, and more).
3. **Proposal report**: a Before/After design with compatibility guarantees, written before any code is touched.
4. **Feedback loop**: code changes only after your explicit approval.
5. **Safe application**: runs type-check and lint, then the formatter on modified files.

Every proposal preserves public signatures, props, and return types, all existing call sites, and observable runtime behaviour.

Pattern catalog: [English](./skills/fowler-refactor/references/fowler-patterns.md) · [한국어](./skills/fowler-refactor/references/fowler-patterns.ko.md)

> Migrating from `dopeboy0608/fowler-refactor-skill`? The skill is now named `fowler-refactor`, so the command is `/fowler-refactor`. Remove the old one with `npx skills@latest remove fowler-refactor-skill`.

## code-organizer

```
/code-organizer
```

You can also ask "organize imports" or "reorder hooks".

- **Imports**: external packages → app infrastructure (router/store/API) → feature modules → shared components → constants/types/assets. The skill maps these groups to your project's own path aliases. If you already use an import-order lint rule, it follows that rule instead.
- **Component body**: router/store/context → hooks/queries → state → refs → shared memos/handlers → `useLayoutEffect` → `useEffect`.
- Code only moves. Logic, the order of names inside imports, and comments stay exactly as they are.

---

## Credits

- Martin Fowler, *Refactoring: Improving the Design of Existing Code (2nd Edition)*, Addison-Wesley, 2018 · [refactoring.com](https://refactoring.com/catalog/)
- The interview pattern is inspired by Matt Pocock's [`/grill-me`](https://github.com/mattpocock/skills) (MIT).

> This project is an independent community tool. It is not affiliated with or endorsed by Martin Fowler or Pearson Education.

## License

[MIT](./LICENSE) © YongKyu Kim
