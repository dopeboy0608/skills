---
name: ai-workflow-setup
description: ai-workflow-init으로 초기화한 프로젝트의 개발환경을 설정한다 — 스택 판단, 승인 후 스캐폴딩 CLI 실행, 프론트/백 디렉터리 보충, 선택한 워크플로우에 필요한 도구 확인(gh, dopeboy0608-skills 플러그인). 재실행해도 안전하고 규칙 문서가 이미 있는 프로젝트에서 단독 실행도 가능하다. AI 워크플로우를 처음 도입해보는 사람에게 추천한다. /ai-workflow-setup으로 명시 호출했을 때만 사용한다.
disable-model-invocation: true
---

# AI Workflow Setup

규칙 문서를 실제로 일할 수 있는 개발환경으로 만든다. `ai-workflow-init` 직후에 실행하거나, `ai-workflow:` 마커가 있는 `CLAUDE.md`가 이미 있는 프로젝트에서 단독으로 실행한다. 재실행해도 안전하다(기존 디렉터리/파일은 건드리지 않음).

> **명시 호출 전용.** 사용자가 `/ai-workflow-setup`을 호출할 때만 실행한다.
>
> **이런 분께 추천**: AI 워크플로우를 처음 도입해보는 사람.

스캐폴드 레퍼런스는 `references/scaffold/`(`fe-scaffold.md`, `be-scaffold.md`)에 있다. 외부 템플릿 레포를 clone·조회·링크하지 않는다.

## 단계 요약

단계 사이마다 사용자 확인을 받는다.

0. **선택값 읽기**: `CLAUDE.md`의 마커(`strategy`, `tracker`, `stack`)를 읽는다. 없으면 `/ai-workflow-init`을 먼저 실행하라고 안내한다.
1. **스택 판단**: 마커의 `stack`을 쓰고, 불분명하면 묻는다.
2. **스캐폴딩 CLI(승인 필수)**: 이미 매니페스트/소스가 있으면 건너뛴다. 없으면 스택에 맞는 CLI 명령을 보여 주고 "지금 실행할까요?" 확인 후에만 실행한다. 디렉터리 생성은 이 단계 이후에만 한다. 기존 문서를 삭제하지 않는다.
3. **디렉터리 보충**: 프론트 `fe-scaffold.md`, 백 `be-scaffold.md`, 풀스택은 둘 다 보여 주고 배치를 확인받는다. 승인 시 **없는 디렉터리만** `.gitkeep`과 함께 만들고 코드 파일은 만들지 않는다.
3b. **문서 동기화(승인 후)**: init이 "미정"으로 남긴 `CLAUDE.md`의 명령어·기술 스택·디렉터리 구조와 ARCHITECTURE.md의 해당 줄만 실제 결과로 갱신한다(없는 lint/test는 지어내지 않음). 스캐폴딩 CLI가 `.gitignore`를 덮어썼는지 확인해 `docs/history/*` 줄을 복원한다.
4. **외부 의존성 안내(선택에 필요한 것만)**: `dopeboy0608-skills` 플러그인(`feature-strategy` 제공 — 직접 묻고, 없으면 설치 명령만 안내), 트래커가 GitHub 이슈일 때만 `gh` 설치·로그인 확인, `feature-strategy`는 추가 설치 불필요, `grill-me`는 선택 사항으로 한 줄 언급.
5. **완료 보고**: 판단한 스택, CLI 실행/건너뜀, 추가/건너뛴 디렉터리, 의존성 상태, 다음 행동(`/issue-start <이슈 번호>`)을 짧게 요약한다.

## 하지 않는 것

- 승인 없는 실행, 도구·플러그인 대리 설치, 기존 파일 덮어쓰기.
- 커밋, push, PR.
- 전략·트래커 변경(필요하면 `/ai-workflow-init`을 다시 안내).
