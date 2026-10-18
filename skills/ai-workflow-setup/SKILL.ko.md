---
name: ai-workflow-setup
description: ai-workflow-init으로 초기화한 프로젝트의 개발환경을 설정한다 — 프론트/백엔드/풀스택 판단, 승인 후 스캐폴딩 CLI(Vite, Next.js 등) 실행, 빠진 디렉터리 보충, CLAUDE.md 명령어·기술 스택 동기화, 필요한 도구(gh CLI, dopeboy0608-skills 플러그인) 확인. 재실행해도 안전하고 단독 실행도 가능하다. AI 워크플로우를 처음 도입해보는 사람에게 추천한다. /ai-workflow-setup으로 명시 호출했을 때만 사용한다.
disable-model-invocation: true
---

# AI Workflow Setup

규칙 문서를 실제로 일할 수 있는 개발환경으로 만든다. `ai-workflow-init` 직후에 실행하거나, `ai-workflow:` 마커가 있는 `CLAUDE.md`가 이미 있는 프로젝트에서 단독으로 실행한다. 재실행해도 안전하다(기존 디렉터리/파일은 건드리지 않음).

> **명시 호출 전용.** 사용자가 `/ai-workflow-setup`을 호출할 때만 실행한다.
>
> **이런 분께 추천**: AI 워크플로우를 처음 도입해보는 사람.

스캐폴드 레퍼런스는 `references/scaffold/`(`fe-scaffold.md`, `be-scaffold.md`), 품질 도구 선택지는 `references/quality-tools.md`, 전략별 설정 훅은 `references/strategy-hooks.md`에 있다. 외부 템플릿 레포를 clone·조회·링크하지 않는다.

## 질문 형식

모든 단계의 승인 질문은 같은 모양으로 보여 준다: `### 단계 2/5 · 개발환경 설치` 제목 → 이 단계가 하는 일(과 하지 않는 일) 한 문장 → 선택지 번호 목록(추천에 `← 추천`) 또는 제안 하나 → `명령:` 정확한 명령 → `생성/변경:` 만들어질 것 → 마지막 줄에 `> 1번을 지금 실행할까요? (예 / 다른 선택 / 건너뛰기)`. 한 질문은 약 12줄 이내로 유지한다.

## 단계 요약

단계 사이마다 사용자 확인을 받는다.

0. **선택값 읽기**: `CLAUDE.md`의 마커(`strategy`, `tracker`, `stack`)를 읽는다. 없으면 `/ai-workflow-init`을 먼저 실행하라고 안내한다.
1. **스택 판단**: 마커의 `stack`을 쓰고, 불분명하면 묻는다.
2. **개발환경 설치용 프로젝트 생성 CLI(승인 필수)**: `package.json`, 번들러/프레임워크 설정, 진입 파일을 만들고 의존성을 설치할 수 있는 단계이며, 폴더만 만드는 3단계와 다르다고 한 문장으로 먼저 설명하고 "개발환경 설치(프로젝트 생성기)"라는 제목으로 묻는다. 이미 매니페스트/소스가 있으면 건너뛴다. 없으면 스택에 맞는 선택지를 번호로 보여 주고 하나를 추천하며 "건너뛰기(직접 설정)"를 항상 넣는다. 프론트엔드: 1) Vite `npm create vite@latest`, 2) Rsbuild + **pnpm** `pnpm create rsbuild@latest`(`pnpm` 설치 여부를 먼저 확인, 없으면 설치 방법만 안내), 3) Next.js `npx create-next-app@latest`. 고른 뒤 정확한 명령과 생성될 것을 보여 주고 "지금 실행할까요?" 확인 후에만 실행한다. 임시 디렉터리 결과를 병합할 때는 **없는 파일만** 복사하고 덮어쓰지 않는다. 예외: `.gitignore`는 생성기에만 있는 줄을 기존 파일에 추가(추가할 줄을 먼저 보여 줌), 기존 `README.md`/`AGENTS.md`는 유지하고 생성기 버전은 언급만 한다. 생성기의 샘플 코드(`src/App.tsx` 등)는 옮기거나 지우지 않고 존재만 알린다. 디렉터리 생성은 이 단계 이후에만 한다. 기존 문서를 삭제하지 않는다.
2b. **의존성 설치(별도 승인)**: 생성기 직후 "의존성을 지금 설치할까요(`<패키지매니저> install`)?"를 따로 묻고 승인 후에만 실행한다. 기대 결과는 락 파일 생성과 `node_modules/` 채움뿐이며, `node_modules`가 git 무시 대상인지 확인하고 락 파일은 커밋하라고 안내한다. 다른 추적 파일이 바뀌었으면 diff를 보여 준다. 거절하면 설치 전에는 dev/build가 동작하지 않는다고 알린다.
2c. **포매터·린터·테스트 도구(항목별 별도 승인)**: `references/quality-tools.md`를 따른다. init 인터뷰에서 `CLAUDE.md`에 기록한 선택이 있으면 그대로 설치하고, 없으면 스택별 기본값을 추천한다(FE: Biome, Vitest + Testing Library, 외부 API가 범위에 있을 때만 MSW, `typecheck` 스크립트, 선택적으로 husky + lint-staged). 설치 명령·추가될 설정 파일·`package.json` 스크립트를 먼저 보여 준다. 거절하면 지킬 수 없는 `CLAUDE.md` 규칙을 알려 준다. 설치 후 `lint`/`test`를 한 번 실행해 실제 결과를 보고한다.
2d. **CI 워크플로우(승인 필수)**: `references/ci-workflow.md`를 따른다. GitHub 트래커이고 lint/typecheck/test/build 스크립트가 하나라도 있을 때만, PR에서 존재하는 스크립트만 실행하는 GitHub Actions 파일 하나를 제안한다. 기존 `ci.yml`은 덮어쓰지 않는다.
3. **디렉터리 보충(폴더만, 설치 없음)**: 빈 폴더(`.gitkeep`)만 만들며 아무것도 설치하지 않고 코드 파일도 만들지 않는다고 먼저 밝힌다. 프론트 `fe-scaffold.md`, 백 `be-scaffold.md`, 풀스택은 둘 다 보여 주고 배치를 확인받는다. 승인 시 **없는 디렉터리만** `.gitkeep`과 함께 만들고 코드 파일은 만들지 않는다.
3b. **문서 동기화(승인 후)**: init이 "미정"으로 남긴 `CLAUDE.md`의 명령어·기술 스택·디렉터리 구조와 ARCHITECTURE.md의 해당 줄만 실제 결과로 갱신한다(없는 lint/test는 지어내지 않음). 스캐폴딩 CLI가 `.gitignore`를 덮어썼는지 확인해 `docs/history/*` 줄을 복원한다.
4. **외부 의존성 안내(선택에 필요한 것만)**: `dopeboy0608-skills` 스킬(먼저 `.claude/skills/` 또는 `~/.claude/skills/`에 로컬로 있는지 확인하고 있으면 충족으로 보며 플러그인은 언급하지 않는다. 폴더가 없을 때만 플러그인 설치 여부를 묻고 설치 명령만 안내), 트래커가 GitHub 이슈일 때만 `gh` 설치·로그인 확인과 라벨 점검(`bug`/`feature`/`chore`/`docs`/`in-progress` 중 없는 것만 보여 주고 승인 후 `gh label create`로 생성, 기존 라벨은 수정·삭제하지 않음), 선택한 전략의 훅만 `references/strategy-hooks.md`에서 읽어 실행한다 — `speckit`: `specify` CLI 설치 확인 → `specify init --here --integration claude` 실행 확인(승인 후) → `AGENTS.md` 동기화(1회성, 승인 후), 설치된 `speckit-*` 이름·구분자(`.specify/integration.json`의 `invoke_separator`) 확인 후 문서와 다르면 승인 후 보정, 직접 입력: 필요한 사전 설정은 사용자가 직접 하도록 안내만(아무것도 실행하지 않음), `feature-strategy`/없음: 추가 작업 없음. `grill-me`는 선택 사항으로 한 줄 언급.
5. **완료 보고**: 판단한 스택, CLI 실행/건너뜀, 추가/건너뛴 디렉터리, 의존성 상태, 선택한 전략의 요구사항 충족 여부(큰 작업 경로가 아직 동작하지 않으면 이유를 명시), 다음 행동(`/issue-start <이슈 번호>`)을 짧게 요약한다. 선택하지 않은 전략은 언급하지 않는다.

## 하지 않는 것

- 승인 없는 실행, 도구·플러그인 대리 설치, 기존 파일 덮어쓰기.
- 커밋, push, PR.
- 전략·트래커 변경(필요하면 `/ai-workflow-init`을 다시 안내).
