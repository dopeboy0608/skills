---
name: code-organizer
description: Reorder code without changing logic in React / TypeScript projects — sorts import statements into layered groups and arranges hooks, state, refs, memos and effects inside components and custom hooks. Use when asked to "organize imports", "sort imports", "reorder hooks", "tidy component structure", or when invoking /code-organizer explicitly.
---

# Code Organizer

## Core Principle

> **Never change what the code does. Only change where it is written.**
>
> - Do not reorder names inside a named import (`import { b, a }` stays as is).
> - Do not touch the body of any function or variable.
> - When a group boundary is ambiguous, do not move the code — propose the move to the user instead.
> - **Do not add new section/block comments.** Keep only the comments the user wrote.

---

## Step 0. Learn the project's layers

Before sorting, read the project's path aliases and folder layout (`tsconfig.json` / `jsconfig.json` `paths`, `vite.config.*` / webpack `resolve.alias`, top-level `src/` folders). Map each alias or folder to one of the import groups below.

Names in this document (`@/store`, `@/features`, `@/components`, …) are **examples** of a common feature-sliced layout. Substitute the project's real paths. If the project already has an import-order lint rule (`eslint-plugin-import` `import/order`, `simple-import-sort`, Biome `organizeImports`), follow that rule instead of Part 1 and only apply Part 2.

---

## Part 1. Import ordering

### Group order

```
1. Framework / external packages (react, axios, dayjs, any node_modules package)
   (blank line)
2. App-wide infrastructure: router, global store, API client / query hooks
   (e.g. @tanstack/react-router, @/store/*, @/api/*)
   Inner order: router → global store → API client/hooks
   (blank line)
3. Feature modules (same or other domain: @/features/*/...)
   Inner order: components → hooks → queries → store
   Relative imports (../hooks/*, ./components/*) belong here too
   (blank line)
4. Shared UI components (e.g. @/components/*)
   (blank line)
5. Constants / types / assets
   Inner order:
   a. constants (@/constants/*, @/features/*/constants)
   b. types (@/types/*, @/features/*/types, `import type`)
   c. SVG / image / other assets (@/assets/*)
```

### Notes

- `import type` goes in group 5-b, after any regular imports in that group.
- Assets always come last.
- Relative imports within the same feature follow group 3's inner order (components → hooks → queries → store).
- **Never reorder names inside a named import.**

### Example

```typescript
import { useState } from 'react';
import axios from 'axios';

import { useAppStore } from '@/store/appStore';
import { apiClient } from '@/api/apiClient';

import { MapView } from '@/features/map/components/MapView';
import { useCurrentCenter } from '@/features/map/hooks/useCurrentCenter';
import { usePolygons } from '@/features/area/queries/usePolygons';

import { AppButton } from '@/components/AppButton';

import { DEFAULT_ZOOM_LEVEL } from '@/features/map/constants';
import type { MapCenter } from '@/features/map/types';
import mapPinIcon from '@/assets/icons/icon-map-pin.svg';
```

---

## Part 2. Component / custom hook body

Inside a component or custom hook, order the **declarations** of hooks, state and effects as follows.

### Block order

```
1a. Router / Store / Context        — injected environment (router, global state, context)
1b. Providers / Hooks / Queries     — providers, server data, utility hooks
2.  State (useState, useReducer)    — local state
3.  Ref (useRef)                    — non-rendering values / DOM references
4.  Shared derived values & handlers — useMemo → useCallback → plain functions (used by several effects/hooks)
5.  useLayoutEffect                 — synchronous DOM measurement/update (runs before useEffect)
6.  useEffect                       — asynchronous side effects
    └─ a handler/useMemo/useCallback used by only one effect sits directly above that effect
```

> Put **one blank line** between blocks.
> 1a and 1b are consecutive with no blank line (same layer, different flavour).
>
> If the component uses form state (`useForm`, etc.), add a Form block right before the State block.

### Why this order

| Block                              | Reason                                                                           |
| ---------------------------------- | -------------------------------------------------------------------------------- |
| Router / Store / Context           | Values injected from outside. Declared first so every block below can use them  |
| Providers / Hooks / Queries        | Utility hooks and server data. After the environment, before local state        |
| useState                           | State the component owns. Before refs — values that trigger renders are central |
| useRef                             | "Quiet state" that doesn't re-render. Same layer as state but kept separate     |
| Shared useMemo / useCallback / fns | Must exist before effects list them as deps. Flow: compute values → side effects |
| useLayoutEffect                    | Runs synchronously before paint, i.e. before useEffect                           |
| useEffect                          | Post-render side effects, in lifecycle order (mount → single dep → multiple deps) |

---

### Blank lines inside a block

Besides the blank line between blocks, **split within a block** when:

| Condition                                  | Example                                                            |
| ------------------------------------------ | ------------------------------------------------------------------ |
| **Ref sets controlling different targets** | map container refs → blank line → overlay refs                     |
| **Multi-line destructuring hooks**         | each hook that destructures across multiple lines gets its own gap |
| **Single-line hooks of different kinds**   | group like with like; blank line when the kind changes             |
| **State groups with different context**    | map-center state → blank line → modal state                        |

---

### Block 1a. Router / Store / Context

Router, global store and context subscriptions. Global before module-scoped.

```typescript
const router = useRouter();
const appStore = useAppStore();
const theme = useContext(ThemeContext);
```

### Block 1b. Providers / Hooks / Queries

Providers, utility hooks and server-data (query) hooks. Directly after 1a with no blank line.
Inner order: providers → utility hooks → queries.

```typescript
const [loading, error] = useScriptLoader({ src: MAP_SDK_URL });
const center = useCurrentCenter();

const { data: polygons } = usePolygons();
```

---

### Block 2. State

Keep related state adjacent, grouped by context.

An **initial-value const** for a state sits directly above that `useState`.

**Grouping criteria (in priority order)**

1. If the developer wrote comments marking boundaries, use them.
2. Otherwise infer groups from context (naming, which handlers/effects use them together).
3. If the boundary is still ambiguous, propose instead of moving.

```typescript
const DEFAULT_CENTER = { lat: 37.5665, lng: 126.978 };
const [center, setCenter] = useState(DEFAULT_CENTER);

const [isLegendOpen, setIsLegendOpen] = useState(false); // different context → blank line
```

---

### Block 3. Ref

`useRef` values don't trigger renders. Keep all refs in one block regardless of purpose.
Values destructured from `ref.current` sit directly below that ref.
Group refs that control the same target; separate different targets with a blank line.

- DOM references (`mapContainerRef`)
- mutable flags (`isFirstFetchRef`)
- function refs (`handleResizeRef`)

---

### Exception: cross-block dependencies

**Default**: place each declaration in the block for its kind.
**Exception**: if it must **read from or receive as an argument** a value from another block, place it right after the **last** block it depends on.

This applies to every kind of declaration.

```typescript
const mapContainerRef = useRef<HTMLDivElement>(null);

// depends on state and ref → right after the last dependency block (Ref)
const { isMapReady } = useMapReadyCheck({
  containerRef: mapContainerRef,
  center,
});
```

| Case                                                     | Default block | Placement                                  |
| -------------------------------------------------------- | ------------- | ------------------------------------------ |
| Hook takes state/ref as arguments                        | 1b            | Right after the last dependency block      |
| Value destructured from `ref.current`                    | —             | Directly below that ref inside block 3     |
| State initial-value const                                | —             | Directly above that `useState`             |
| Inside 1b, hook B takes hook A's return value            | 1b            | Keep A → B order inside 1b                 |

---

### Block 4. Shared derived values & handlers

Values and functions **referenced by more than one effect / effect hook** go above the whole effect section.

- Order: `useMemo` → `useCallback` → plain handler functions.
- If only one effect references it, place it directly above that effect instead (see block 6).

```typescript
const visiblePolygons = useMemo(() => polygons.filter((p) => p.isVisible), [polygons]);
const handleLegendToggle = useCallback(() => setIsLegendOpen((prev) => !prev), []);
```

---

### Block 5. useLayoutEffect

For DOM measurement / synchronous updates. Runs before paint, so it precedes useEffect.
Same lifecycle order as useEffect (`[]` → single dep → multiple deps).

---

### Block 6. useEffect (+ dedicated handlers adjacent)

**Lifecycle order**

1. `[]` — mount only (initialisation)
2. Single dependency
3. Multiple dependencies

A **handler/useMemo/useCallback used by only one effect** sits directly above that effect.

- Shared by several effects → move to block 4.
- Used by one effect only → keep it adjacent to that effect.

```typescript
// mount
useEffect(() => {
  init();
}, []);

// single dep — handleCenterChange is only used by this effect
const handleCenterChange = () => { ... };
useEffect(() => {
  handleCenterChange();
}, [center]);
```

---

### Full example

```typescript
export const MapView = () => {
  const [loading, error] = useScriptLoader({ src: MAP_SDK_URL });
  const center = useCurrentCenter();

  const { data: polygons } = usePolygons();

  const [isLegendOpen, setIsLegendOpen] = useState(false);

  const mapContainerRef = useRef<HTMLDivElement>(null);

  const visiblePolygons = useMemo(() => polygons?.filter((p) => p.isVisible) ?? [], [polygons]);
  const handleLegendToggle = () => setIsLegendOpen((prev) => !prev);

  useEffect(() => {
    init();
  }, []);

  // ... render
};
```

---

## Checklist (before finishing)

- [ ] Only positions changed — no logic changed?
- [ ] Names inside named imports left untouched?
- [ ] No new block/section comments added?
- [ ] Import groups mapped to the project's real aliases (or its existing lint rule followed)?
- [ ] Router/Store/Context (1a) and Providers/Hooks/Queries (1b) correctly separated?
- [ ] State initial-value consts directly above their `useState`?
- [ ] `ref.current` destructuring directly below its ref?
- [ ] Refs for the same target grouped, different targets separated?
- [ ] Multi-line destructuring hooks separated by blank lines?
- [ ] Cross-block dependency exception (after the last dependency block) applied?
- [ ] Ambiguous state groups proposed rather than moved?
- [ ] Shared vs single-use handlers/memos/callbacks placed correctly?
- [ ] useLayoutEffect before useEffect?
- [ ] One blank line between blocks (except 1a↔1b)?
