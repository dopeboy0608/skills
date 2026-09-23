# dopeboy skills

> 🇺🇸 [English README](./README.md)

코드 리팩터링과 정렬을 위한 AI 에이전트 스킬 모음입니다. **Claude Code**, **OpenCode**, **Cursor**, **Codex**, **Windsurf** 등 [skills.sh](https://skills.sh) 형식을 지원하는 모든 에이전트에서 사용할 수 있습니다.

| 스킬 | 설명 |
| --- | --- |
| [`fowler-refactor`](./skills/fowler-refactor/SKILL.ko.md) | 마틴 파울러의 리팩터링 카탈로그를 적용합니다. 인터뷰 → Before/After 제안 → 승인 후 적용 순서로 진행하며, **기존 호출처에 Breaking Change가 없습니다.** |
| [`code-organizer`](./skills/code-organizer/SKILL.ko.md) | React/TypeScript 코드의 import와 훅·상태·ref·이펙트 선언을 **로직 변경 없이** 정렬합니다. |

각 스킬 폴더의 `SKILL.ko.md`는 사람이 읽기 위한 한국어 번역본입니다. 에이전트는 `SKILL.md`만 읽습니다.

---

## 설치

두 방법 중 **하나만** 고르세요. Claude Code에 둘 다 설치하면 같은 스킬이 두 번씩 보입니다.

### Claude Code (플러그인)

```bash
claude plugin marketplace add dopeboy0608/skills
claude plugin install dopeboy0608-skills
```

세션 안에서는 `/plugin marketplace add dopeboy0608/skills`, `/plugin install dopeboy0608-skills`, `/reload-plugins` 순서로 실행합니다.

플러그인으로 설치한 스킬은 앞에 플러그인 이름이 붙어 `/dopeboy0608-skills:fowler-refactor`, `/dopeboy0608-skills:code-organizer`로 표시되고 실행됩니다.

### 모든 에이전트 (npx)

Claude Code, OpenCode, Cursor, Codex, Windsurf 등에서 쓸 수 있습니다. **Node.js >= 22.20.0**이 필요합니다 (`nvm install 22 && nvm use 22`).

```bash
# 인터랙티브: 스킬과 에이전트를 직접 선택 (현재 프로젝트에 설치)
npx skills@latest add dopeboy0608/skills

# 전역 설치: 모든 프로젝트에서 사용
npx skills@latest add dopeboy0608/skills -g

# 특정 스킬만 설치
npx skills@latest add dopeboy0608/skills --skill fowler-refactor

# 특정 에이전트에만 설치
npx skills@latest add dopeboy0608/skills --skill code-organizer --agent opencode
```

이 방법으로 설치한 스킬은 `/fowler-refactor`, `/code-organizer`로 실행합니다. Claude Code에서는 설치 후 재시작하거나 세션에서 `/reload-skills`를 실행하세요.

### 업데이트

```bash
# 플러그인
claude plugin marketplace update dopeboy-skills
claude plugin update dopeboy0608-skills

# npx
npx skills@latest update
```

### 제거

```bash
# 플러그인
claude plugin uninstall dopeboy0608-skills
claude plugin marketplace remove dopeboy-skills

# npx
npx skills@latest remove fowler-refactor
npx skills@latest remove --global code-organizer
```

---

## fowler-refactor

명시적으로 호출합니다:

```
/fowler-refactor                     # npx
/dopeboy0608-skills:fowler-refactor  # Claude 플러그인
```

"이거 정리해줘" 같은 가벼운 요청에는 **자동으로 트리거되지 않습니다.**

1. **인터뷰** (`grill-me` 방식): 대상, 코드 악취, 제약조건이 명확해질 때까지 추천 답변과 함께 질문을 하나씩 합니다.
2. **패턴 매핑**: 파울러 카탈로그에서 적합한 패턴을 고릅니다 (Extract Function, Decompose Conditional, Split Phase, Replace Conditional with Lookup Table 등).
3. **제안서 리포트**: 코드를 수정하기 전에 Before/After 설계와 호환성 보증을 먼저 제시합니다.
4. **피드백 루프**: 명시적으로 승인한 뒤에만 코드를 적용합니다.
5. **안전한 적용**: 타입 체크와 린트를 실행하고, 수정된 파일에 포매터를 적용합니다.

모든 제안은 공개 시그니처·props·반환 타입, 기존 호출처, 런타임 동작을 보존합니다.

패턴 카탈로그: [한국어](./skills/fowler-refactor/references/fowler-patterns.ko.md) · [English](./skills/fowler-refactor/references/fowler-patterns.md)

> 기존 `dopeboy0608/fowler-refactor-skill`에서 옮겨오셨나요? 스킬 이름이 `fowler-refactor`로 바뀌어 명령어도 `/fowler-refactor`가 되었습니다. 이전 스킬은 `npx skills@latest remove fowler-refactor-skill`로 제거하세요.

## code-organizer

```
/code-organizer                     # npx
/dopeboy0608-skills:code-organizer  # Claude 플러그인
```

"import 순서 정리해줘", "훅 순서 정리해줘" 같은 요청으로도 실행됩니다.

- **Import**: 외부 패키지 → 앱 전역 인프라(router/store/API) → feature 모듈 → 공용 컴포넌트 → 상수/타입/에셋 순서입니다. 그룹은 프로젝트의 실제 경로 alias에 맞춰 매핑합니다. 이미 import 정렬 린트 규칙이 있으면 그 규칙을 따릅니다.
- **컴포넌트 내부**: router/store/context → 훅/쿼리 → state → ref → 공유 memo/핸들러 → `useLayoutEffect` → `useEffect` 순서입니다.
- 코드의 위치만 옮깁니다. 로직, named import 내부 순서, 기존 주석은 그대로 둡니다.

---

## 크레딧

- Martin Fowler, *Refactoring: Improving the Design of Existing Code (2nd Edition)*, Addison-Wesley, 2018 · [refactoring.com](https://refactoring.com/catalog/)
- 인터뷰 방식은 Matt Pocock의 [`/grill-me`](https://github.com/mattpocock/skills) (MIT)에서 영감을 받았습니다.

> 이 프로젝트는 독립적인 커뮤니티 도구이며, 마틴 파울러 또는 Pearson Education과 공식적인 제휴 관계가 없습니다.

## 라이선스

[MIT](./LICENSE) © YongKyu Kim
