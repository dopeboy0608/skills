# #30 feature-strategy 범용성 고도화

- 스토리: https://github.com/dopeboy0608/skills/issues/30
- 브랜치: `claude/amazing-ride-3cvtmi` (스토리당 하나, 하위작업별 브랜치 없음)
- 커밋 키: 로컬 번호 `[01]`… (이슈를 만든 경우에만 `#번호` 병기), 범위는 `feature-strategy`

## 로드맵 & 키 매핑

| # | 제목 | 관련 FR | 트래커 키 | 상태 | 본문 |
|---|---|---|---|---|---|
| 01 | feature-strategy 스킬 본문 > 진입 방식 3종 판별 + 로컬 문서 구조 | FR-01, FR-02 | (없음) | 완료 (0482544) | [sub-tasks/01](sub-tasks/01.%20스킬%20본문%20-%20진입%20방식%203종%20판별%20+%20로컬%20문서%20구조.md) |
| 02 | feature-strategy 스킬 본문 > 하위티켓 생성 승인 흐름 | FR-03, FR-05 | (없음) | 완료 (20f8d4a) | [sub-tasks/02](sub-tasks/02.%20스킬%20본문%20-%20하위티켓%20생성%20승인%20흐름.md) |
| 03 | ai-workflow-init·setup > 프래그먼트·프리셋 정렬 + 마커 버전 | FR-04, FR-05 | (없음) | 완료 (2c21fc6) | [sub-tasks/03](sub-tasks/03.%20ai-workflow%20-%20프래그먼트·프리셋%20정렬%20+%20마커%20버전.md) |
| 04 | README·docs 동기화 | FR-04 | (없음) | 요약만 | [sub-tasks/04](sub-tasks/04.%20README·docs%20동기화.md) |

- 하위티켓(이슈)은 만들지 않았다. 사용자가 원할 때만 승인 후 생성한다.
- API와 무관한 문서 변경이라 mock·`TODO(API)` 없음.

## 워크플로우

1. 하위작업 하나를 구현하고, 커밋 전에 멈춰 확인 시나리오와 코드 리뷰 포인트를 보고한다.
2. 사용자가 확인하면 커밋한다. 이후 다음 하위작업 본문에 결과를 반영한다.
3. 첫 하위작업 커밋 뒤, Draft PR을 열지 먼저 묻는다.
4. 영문·한글 쌍(`SKILL.md`/`SKILL.ko.md`, README)은 같은 하위작업에서 함께 수정한다.

## 결정 로그

| 날짜 | 결정 | 근거 |
|---|---|---|
| 2026-11-27 | 하위티켓 생성 여부는 매번 묻고, 기본값은 만들지 않음 | 이슈 본문 + 확인 필요 1번 |
| 2026-11-27 | GitHub sub-issue 연결은 승인 후 실행, 라벨은 명령만 출력해 사용자가 직접 실행 | 확인 필요 2번, `ai-workflow-setup/SKILL.md:84` 방식과 일치 |
| 2026-11-27 | 파일명의 `>`는 `-`로 치환, `\ / : * ? " < > \|`도 `-` 또는 공백으로 치환. 이슈 제목은 `>` 유지 | 확인 필요 3번 (Windows 파일명 제약) |
| 2026-11-27 | 트래커가 없으면 폴더명은 `<slug>`만 사용 | 확인 필요 4번 (추천) |
| 2026-11-27 | 기존 `<번호>-<slug>.md` 구조도 읽고, 새로 만드는 문서만 새 구조 | 확인 필요 5번 (추천) |
| 2026-11-27 | init·setup 점검 결과는 이 문서의 findings에 기록, 커지면 별도 이슈 | 확인 필요 6번 (추천) |
| 2026-11-27 | 진입 방식(신규 진입점 / 기존 화면 기능 추가 / 신규 페이지)은 첫 질문에서 판별 | 질문 라운드 1-2 |
| 2026-11-27 | 하위티켓 질문은 로컬 md 작성이 끝난 뒤 한 번에 | 질문 라운드 1-3 |
| 2026-11-27 | 마커 `version=1.4.6`은 03에서 올림 | 질문 라운드 1-6 |

## Findings

교차 확인 결과: ①(스펙 모순)·②(디자인 불일치) 없음. 디자인 확인은 "n/a — no design". 게이트 통과.

③ 스펙 vs 코드 (스토리 본문은 수정하지 않음)

1. `skills/ai-workflow-init/references/strategies/feature-strategy.md`의 "Issue creation approval" 규칙(`tracker = github`)이 Phase B 승인을 이슈 생성 요청으로 간주한다. FR-03·FR-05와 어긋난다. → 03에서 수정.
2. 같은 파일의 `tracker = github` 변형이 sub-issue를 기본으로 만들도록 안내하고, `presets.md:7`·`presets.md:16`도 "sub-issues"를 산출물로 안내한다. → 03에서 수정.
3. `ai-workflow-setup/SKILL.md:84`의 라벨 생성은 이미 사용자 직접 실행 방식이다. 수정 대상 아님. 02의 참고 구현.

경로 사용처: `feature-strategy/SKILL.md`·`SKILL.ko.md`, `strategies/feature-strategy.md`(21, 41, 49줄), `presets.md`(7줄), README.

마커 버전 상향 필요 여부(미검증이던 항목): `docs/DEVELOPMENT.md` Version rules상 스킬 내용 변경은 patch 상향이 필요해 03에서 1.4.6 → 1.4.7로 올림 (plugin.json, marketplace.json, init 마커 일치).

ai-workflow-setup 영향 점검(확인 필요 6번): 구조 변경 불필요. `feature-strategy`는 추가 설치가 없고(`strategy-hooks.md`), 라벨 생성은 이미 사용자 직접 실행 방식(`SKILL.md:84`). 별도 이슈 불필요.

남은 위험: 이미 `CLAUDE.md`를 생성한 프로젝트에는 옛 규칙(로드맵 승인 = 이슈 생성 승인)이 남는다. 재생성은 자동으로 하지 않으며 릴리스 노트에 안내 필요. 샘플 프로젝트에서 `/ai-workflow-init`을 돌려 옛 경로가 남지 않는지 보는 시나리오는 아직 미실행.

## 진행 로그

- 2026-11-27: Phase A 정리, 교차 확인, 질문 라운드 1 완료. 로드맵과 01·02 본문 작성. 구현 전.
- 2026-11-27: [01] 완료, 커밋 0482544. `SKILL.md`·`SKILL.ko.md`에 Entry type 절, 5단계 진입 방식 분기, "Feature doc layout"(스토리 문서 + `sub-tasks/`, 파일명 규칙, 기존 단일 파일 호환) 추가.
  - 02로 넘길 것: (a) Phase B 6단계의 "then write the feature doc: …" 문장이 새 "로컬 문서 먼저" 항목과 중복, (b) 같은 단계 "Create the sub-tasks under the story…"가 아직 자동 생성으로 읽힘.
- 2026-11-27: [02] 완료, 커밋 20f8d4a. 6단계를 "로컬 문서 작성 → 트래커 하위 작업 생성 여부 질문(매번, 기본 아니오)"으로 변경. 로드맵 승인은 이슈 생성 승인이 아님을 명시. 외부 쓰기(이슈·하위 이슈·라벨·본문) 전반을 매번 승인으로, 라벨은 `gh label create` 명령을 보여 사용자가 직접 실행.
  - 03으로 넘길 것: init `strategies/feature-strategy.md`의 "Issue creation approval"(23줄)과 sub-issue 기본 생성 문구(22, 61줄), `presets.md` 7·16줄이 새 스킬 본문과 어긋남. `ai-workflow-init/SKILL.md:76`의 "sub-issues are managed with the gh CLI"도 점검.
- 2026-11-27: [03] 완료, 커밋 2c21fc6. init `strategies/feature-strategy.md`(github/none/custom 변형), `presets.md`, `ai-workflow-init/SKILL.md` 정렬, 버전 1.4.7. 마켓 배포는 하지 않음(사용자가 직접).
  - 04로 넘길 것: README.md/README.ko.md의 Phase B 설명("create the roadmap and sub-tasks")과 "Issue-tracker writes … only after you approve the drafts" 문구를 새 흐름(로컬 문서 먼저, 이슈 생성은 매번 별도 승인)에 맞춤. DEVELOPMENT*.md는 경로 언급이 없어 변경 불필요.
