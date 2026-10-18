# 개발 가이드

이 레포의 스킬을 수정하고 테스트하는 방법입니다. 이 레포가 `ai-workflow-init`, `ai-workflow-setup`의 **원본(single source of truth)** 이며 외부 템플릿 레포는 쓰지 않습니다. English: [DEVELOPMENT.md](./DEVELOPMENT.md).

## 구조

- `skills/<이름>/SKILL.md`, `SKILL.ko.md` — 모든 스킬은 영문·한글 파일을 함께 제공하며, 실행 시 로드되는 것은 `SKILL.md`입니다.
- `skills/ai-workflow-init/references/` — 템플릿과 조각(`core/`, `strategies/`, `trackers/`, `project-skills/`). **선택한** 옵션의 조각만 생성 파일에 영향을 줄 수 있습니다.
- `skills/ai-workflow-setup/references/` — 스캐폴드, 품질 도구, CI, 전략별 훅.
- `.claude-plugin/plugin.json` — 플러그인 매니페스트와 버전.

## 샌드박스 팩으로 테스트

로컬 테스트 팩은 **유지보수용 테스트 전략으로 계속 남겨 둡니다.** 플러그인을 설치하지 않고 백지 프로젝트에서 스킬을 돌려 볼 수 있습니다. `_sandbox-pack/` 자체는 생성물이라 git에서 제외하고, 만드는 스크립트는 버전 관리합니다.

```bash
./scripts/sync-sandbox.sh                      # skills/로 _sandbox-pack/ 재생성
mkdir ~/tmp/aiw-test && cd ~/tmp/aiw-test && git init
cp -R <repo>/_sandbox-pack/.claude .           # 매번 빈 디렉터리에서
# 여기서 새 Claude Code 세션을 열고 /ai-workflow-init, /ai-workflow-setup 실행
```

`skills/` 아래를 수정할 때마다 동기화 스크립트를 다시 실행하고, 시나리오마다 새 디렉터리를 쓰세요(재실행도 하나의 시나리오입니다).

플러그인 설치 경로를 확인하려면 로컬 마켓플레이스나 `claude --plugin-dir <repo>`로 네임스페이스 명령(`/dopeboy0608-skills:ai-workflow-init`)이 동작하는지 봅니다.

## 시나리오 체크리스트 (PR 설명에 복사)

프론트엔드가 지원 중심이며 백엔드·풀스택은 가능한 범위의 지원이라 병합 조건이 아닙니다.

- [ ] 전략: `feature-strategy` / `speckit` / 없음 — 프론트엔드 전용 스택에는 "없음"을 제시하지 않음
- [ ] 트래커: GitHub / 없음 / 기타 — 선택하지 않은 것의 흔적이 `CLAUDE.md`, `issue-start`, setup 출력에 없음
- [ ] 문서 언어: English / 한국어 (제목과 `issue-start`가 선택을 따름)
- [ ] 초기화된 프로젝트에서 `/ai-workflow-init` 재실행 (인터뷰 반복 없음, 덮어쓰기 없음)
- [ ] 미리보기와 setup 각 승인에서 거절 (아무것도 쓰거나 실행하지 않음)
- [ ] `/ai-workflow-setup` 순서: 생성기 → 설치 → 품질 도구 → CI → 디렉터리 → 도구
- [ ] 생성 파일에 `{{슬롯}}` 잔여물 없음
- [ ] `SKILL.md`와 `SKILL.ko.md` 일치, 테스트 전에 샌드박스 팩을 재동기화함
- [ ] 아래 규칙에 맞게 `plugin.json` 버전을 올림

## 구조 검증

`./scripts/validate-skills.sh`는 `plugin.json`, 등록된 모든 스킬의 `SKILL.md`·`SKILL.ko.md` 존재와 frontmatter `name`(폴더명과 일치)·`description`, 매니페스트에 빠진 스킬 폴더, `ai-workflow-init`의 마커 버전과 플러그인 버전 일치, `_sandbox-pack` 미추적 여부를 확인합니다. CI(`.github/workflows/validate.yml`)가 모든 PR에서 실행하며, PR 템플릿에 시나리오 체크리스트가 들어 있습니다.

## 버전 규칙

- 기존 스킬 수정(`SKILL.md`, `references/` 내용) → **패치**.
- 새 스킬 추가 → **마이너**. 새 스킬의 첫 퍼블리시 기간의 수정은 추가와 같은 개념으로 봅니다.
- 대격변 → **메이저**, 메인테이너가 PR에서 별도로 요청할 때만.
- 문서·스크립트·CI만 변경 → 버전 변경 없음.

생성되는 `CLAUDE.md`의 마커(`<!-- ai-workflow: version=… -->`)에는 만든 스킬의 버전이 들어가므로, 스킬 내용이 바뀌면 `plugin.json`과 같게 유지하세요.
