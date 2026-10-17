---
name: ai-workflow-init
description: 빈 프로젝트(또는 기존 프로젝트)에서 짧은 인터뷰로 AI 워크플로우 규칙 문서(CLAUDE.md, docs/ARCHITECTURE.md, docs/TROUBLE_SHOOTING.md, issue-start 스킬)를 생성하고 ai-workflow-setup 실행을 안내한다. AI 워크플로우를 처음 도입해보는 사람이나 복잡한 설정 없이 최소한의 내용으로 구성하고 싶은 사람에게 추천한다. /ai-workflow-init으로 명시 호출했을 때만 사용한다.
disable-model-invocation: true
---

# AI Workflow Init

AI 에이전트가 프로젝트에서 매번 같은 방식으로 일하도록 하는 규칙 문서를 백지 상태에서 만든다. 인터뷰 → 생성 파일 목록 승인 → 기록 순서로 진행하며, 이미 있는 파일은 덮어쓰지 않는다.

> **이런 분께 추천**: AI 워크플로우를 처음 도입해보는 사람, 복잡한 설정 없이 최소한의 내용으로 구성하고 싶은 사람.
>
> **명시 호출 전용.** 사용자가 `/ai-workflow-init`을 호출할 때만 실행한다.
>
> **이 버전의 범위.** 큰 작업 워크플로우는 `feature-strategy`만, 이슈 트래커는 GitHub 이슈만 지원한다. 스택은 프론트엔드/백엔드/풀스택 모두 가능하다. 다른 전략·트래커를 원하면 아직 지원하지 않는다고 알리고 멈춘다.

모든 원본 자료는 이 스킬의 `references/`에 있다. **외부 템플릿 레포를 clone·조회·링크하지 않으며**, 생성 문서에도 그 링크를 남기지 않는다.

## 단계 요약

1. **사전 점검(쓰기 없음)**: 빈 디렉터리/기존 파일 확인. 이미 있는 파일은 `건너뜀`. `CLAUDE.md`에 `ai-workflow:` 마커가 있으면 이미 초기화된 프로젝트이므로 인터뷰를 반복하지 않고 빠진 파일만 제안한다. 마커 없는 기존 `CLAUDE.md`는 건드리지 않는다.
2. **인터뷰**(첫 질문 전에 "7문항 설정 인터뷰이며 아직 아무것도 쓰지 않았고 미리보기 승인 후에만 기록한다"는 안내 문구를 먼저 출력, 질문마다 "질문 n/7" 번호, 첫 메시지부터 사용자 언어 사용, 내부 단계 나레이션 금지; 한 번에 하나, 추천 답 포함): 목적/범위 → 기술 스택(프론트/백/풀스택) → 명령어 → 디렉터리 구조 → Out of scope → 큰 작업 워크플로우(`feature-strategy` 추천, 백엔드 전용이면 프론트엔드 중심 스킬이라고 안내하되 사용자 선택 우선) → 이슈 트래커(GitHub 이슈).
3. **미리보기와 승인**: 파일별 `생성`/`건너뜀`과 치환될 값(목적, 스택, 전략 스킬 이름, 트래커), `.gitignore`에 추가될 줄을 보여 주고 승인받는다. 거절하면 아무것도 쓰지 않는다. 승인 후 `CLAUDE.md`, `docs/ARCHITECTURE.md`, `docs/TROUBLE_SHOOTING.md`, `docs/history/.gitkeep`, `.claude/skills/issue-start/SKILL.md`를 쓰고 `.gitignore`에 빠진 줄만 추가한다.
4. **요약과 다음 단계 안내**: 만든 것과 건너뛴 것을 요약하고 `/ai-workflow-setup`(플러그인 설치 시 `/dopeboy0608-skills:ai-workflow-setup`) 실행을 안내한다. 다른 스킬을 직접 실행하지 않는다.

## 규칙

- 선택한 전략 스킬 이름은 `CLAUDE.md`와 `issue-start`에 각각 한 곳에만 치환한다. 전략별 위치·규칙(피처 문서 `docs/feature/`, 하위 이슈, 브랜치/커밋/PR 규칙)은 전략 조각에서 삽입한 블록에만 둔다.
- `CLAUDE.md` 제목 아래 첫 줄에 `<!-- ai-workflow: version=1.4.0 strategy=… tracker=… stack=… -->` 마커를 남긴다(어느 버전의 스킬로 만들었는지 구분, setup이 선택값을 읽는 용도).
- 생성 문서는 인터뷰에 쓴 언어로 쓴다. 한국어 고정 섹션 제목은 `SKILL.md`의 언어 대응표를 따른다.
- `docs/spec/`과 "스펙 선작성" 규칙은 만들지 않는다.
- 스캐폴딩 CLI 실행, 설치, 커밋, push, PR은 하지 않는다.
