# 인수인계 노트 (새 세션용)

작성 시점 기준 요약입니다. 이어서 작업할 때 먼저 읽고, 작업이 끝나면 이 파일을 갱신하거나 삭제하세요.

## 현재 상태

- `master`: 1.4.5까지 머지됨 (PR #26).
- PR #28 (1.4.6, 자격 증명 관련 문구 정리): **Draft**. 1.4.5가 디렉터리 심사를 통과하면 닫을 예정이고, 보류가 남으면 Draft를 풀고 머지합니다.
- 1.4.5 이전 PR #24, #25, #27은 정리됨 (#27은 #26에 합쳐 닫음).

## 디렉터리 심사 보류

- 1.4.3부터 "플러그인이 자격 증명(토큰, API 키)을 읽고 서버로 보낼 수 있음" 메시지로 보류. 지적 파일은 `.claude-plugin/plugin.json`뿐이며 다른 근거는 없음.
- 확인한 사실: `plugin.json`에는 훅, MCP, `userConfig`, 환경변수 참조가 없고 1.4.0과의 차이는 버전 숫자뿐. 스킬과 스크립트에도 자격 증명 파일을 읽는 지시가 없음. 원인은 확정하지 못함.
- 자격 증명과 닿는 문구(1.4.0에도 있던 것 포함): `gh auth status`, "gh 로그인 필요", "API 키는 환경변수로", CI 문서의 "시크릿 추가 금지", `.gitignore`의 `.env` 줄. PR #28이 앞의 네 가지를 정리하고 `.env` 줄은 보호 목적이라 남김.
- 최신 심사 피드백 탭(`claude.ai/directory/manage/plugins/<id>?tab=feedback`)은 로그인이 필요해서 세션에서 읽지 못함. **새 세션에서는 사용자가 내용을 붙여 줘야 함.**
- 권장 순서: (1) 검토 요청(자격 증명 파일·환경변수를 읽지 않고, `gh auth status`는 로그인 여부만 확인하며, 외부 쓰기는 모두 사용자 확인 후 사용자 본인의 `gh`로 실행됨을 설명) → (2) 반려되면 #28 머지 → (3) 어느 버전부터 걸렸는지 확인되면 그 버전 간 diff를 정밀 확인.

## 1.4.5에서 바뀐 것 (스킬 동작)

- 라벨: `ai-workflow-setup`이 `gh label list`(읽기 전용)로 누락 라벨만 찾고 `gh label create` 명령은 출력만 함. 실행은 사용자.
- speckit: 사용자가 `specify` CLI 설치와 `specify init --here --integration claude`를 직접 실행. 스킬은 명령을 보여 주고 `1. 완료, 확인하고 계속` / `2. 건너뛰기`를 물어 읽기 전용으로 감지(최대 3회)한 뒤 같은 실행에서 이어 감. 건너뛰면 speckit을 유지하고 보고서에 미설치로 표시.
- `issue-start`: 슬롯 `{{STRATEGY_PRECHECK}}` 추가. speckit에서 B(큰 작업)를 고르면 라벨·브랜치 준비 전에 설치 여부를 확인하고, 없으면 안내 후 중단. 다른 전략은 슬롯이 비어 흔적이 남지 않음.

## 후보 보완 (아직 미반영)

- `ai-workflow-setup`에 "`gh`가 실패하면 REST API 등으로 우회하지 말고 라벨을 미완료로 보고한다"는 한 줄 (샌드박스에서 모델이 REST API로 우회한 사례가 있었음). #28에 추가하는 방안.
- `issue-start` 보강안(링크만 있는 이슈의 링크 확인, "분석만 요청하면 분류에서 멈춤", 중복 호출 시 건너뛰기)은 논의했으나 모호함 때문에 **넣지 않기로 결정**. README에 역할 분담만 설명함.

## 사용 규칙 합의

- `issue-start`는 새 이슈를 시작할 때 한 번 쓰는 진입점. 큰 작업이면 인계 명령을 직접 실행해 `/feature-strategy`로 넘어가고, 이후에는 `issue-start`를 다시 부르지 않고 `/feature-strategy`로 이어 감. 작은 작업은 `issue-start` 안에서 끝남.
- 스킬 내용을 바꾸면 패치 버전을 올리고, 문서·스크립트·CI만 바꾸면 버전을 유지 (`docs/DEVELOPMENT.md`). `ai-workflow-init`의 마커 버전은 `plugin.json`과 같아야 하며 `./scripts/validate-skills.sh`가 검사.

## 샌드박스 테스트 방법

1. `./scripts/sync-sandbox.sh`로 `_sandbox-pack/` 생성 (git 무시됨).
2. 빈 디렉터리를 만들고 `git init` 후 `cp -R _sandbox-pack/.claude .`.
3. 그 디렉터리에서 `claude -p "/ai-workflow-init" --session-id <uuid> --permission-mode acceptEdits`로 시작하고, 이후 턴은 `--resume <출력된 session_id>`로 한 번에 한 답씩 이어 감 (출력의 `session_id`를 쓸 것).
4. 확인한 것: init 인터뷰와 미리보기, 설치 전/후 speckit 감지, 건너뛰기 보고, `issue-start`의 B 선택 시 미설치 중단. 미검증: 로그인된 `gh`의 실제 라벨 흐름, 실제 Spec Kit CLI 설치 결과, 재실행 덮어쓰기 방지와 승인 거절.
