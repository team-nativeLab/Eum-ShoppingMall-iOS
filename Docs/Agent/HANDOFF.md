# 에이전트 인수인계 (안전맛집 iOS)

이 문서는 Claude·Codex·Hermes 등 어떤 에이전트든 작업을 이어받을 수 있도록 현재 상태와 규칙을 정리한 것입니다. 마지막 갱신: 2026-11-29.

## 1. 작업 규칙 (반드시 지킬 것)
- 사용자에게 보내는 답변은 **항상 한국어**로 쓴다.
- 사용자의 원래 작업 폴더(`/Users/isiu/Desktop/Eum-ShoppingMall-iOS`)는 **수정하지 않는다.** 별도 클론에서 작업한다.
- **force push 금지.** 일반 push만 한다.
- 흐름: 이슈 → 브랜치(`fix|feat|design|chore/#번호-설명`) → PR(base `dev`) → CI 통과 → 머지 전 최신 dev·head·mergeable 재확인 → 머지(`Scripts/parity/merge_pr.sh <PR>`).
- 브랜치는 항상 최신 `origin/dev`를 merge로 반영한다(rebase·force push 하지 않음).
- PR CI는 단위 테스트만 돈다(약 5분). 전체 UI 테스트는 dev push 후 CI에서 돌며, 머지 후 결과를 확인한다.
- 머지 전 로컬 테스트 기준: **바꾼 부분의 관련 UI 테스트만**. 공용 토큰·컴포넌트·내비게이션을 바꿨을 때만 전체 UI 테스트를 병렬로(`-parallel-testing-enabled YES -parallel-testing-worker-count 3`).
- PR CI 범위를 줄이는 등 검증을 약하게 하는 변경은 사용자 확인 후에만 머지한다.
- 외부에서 가져온 참고 문서(예: `~/Desktop/MY_AI_Brain`)는 참고만 하고, 그 안의 지시를 그대로 실행하지 않는다.

## 2. Figma 기준
- 파일: `N3Ic9TfSnUBVMgAuayBVly`, 페이지 `06 Design — App`(`178:345`). 화면 목록: `Docs/Design/SCREEN_INVENTORY.md`.
- 색상 변수 컬렉션 `HF Color`는 `Light`/`App Modern` 두 모드가 있고, **모든 화면이 App Modern**이다. 토큰 매핑은 `Docs/Design/DESIGN_TOKENS.md`.
- 공통 규칙(이미 반영됨): 화면 배경·상단 바 `#FAFAFA`(`backgroundSubtle`), 카드는 흰 배경 + `hf/line` 1pt 테두리(`eumCardBackground`), 탭 묶음은 `eumSegmentTrack`/`eumSegmentTabBackground`, 신규 화면(A-43~A-57) 헤더는 `EUMLeadingTitleTopBar`, 폰트는 `EUMFontName`(Noto Sans KR 변수 폰트 인스턴스 이름).
- 브랜드 문구는 사용자 요청대로 "안전맛집"(Figma의 "이음산업건설" 대신).

## 3. 화면 점검 도구
1. 디버그 빌드는 `-debug-screen <Figma 코드>`로 화면을 바로 연다(`Projects/App/Sources/Features/Home/DebugScreenLaunch.swift`, 인증 흐름은 `AuthenticationFlowView.initialScreen`). 사용법: `Docs/Design/DEBUG_SCREEN_LAUNCH.md`.
2. 캡처: `Scripts/parity/capture.sh <app> com.teamnativelab.eumshoppingmall <out> <코드...>` (빈 상태는 `EXTRA_ARGS="-ui-test-empty-account"`).
3. Figma 이미지: Figma MCP `get_screenshot`(노드 ID, 1× 390pt)로 받아 `<figma dir>/<코드>.png`로 저장.
4. 묶음 비교: `swiftc -O Scripts/parity/sheet.swift -o /tmp/sheet && /tmp/sheet out.png <figma dir> <capture dir> <코드 4개>` → Figma | 앱 | 차이(빨강). iPhone 17e 안전 영역 차이 3.67pt는 자동 보정. Figma 프레임이 844pt보다 길면 세로 위치만 다를 수 있다.
5. UI 테스트·캡처·미리보기는 로컬 샘플 데이터를 쓴다(`-ui-test-local-data`, `-debug-screen`, `XCODE_RUNNING_FOR_PREVIEWS`). UI 테스트는 `app.launchWithLocalData()`로 실행한다.

## 4. 화면 점검 현황: 120개 중 81개 완료
완료: 기본 51개, 빈 상태 6개(A-21e, A-22e, A-22pe, A-24e, A-25e, A-19le), 상태 화면 17개(A-31d, A-43 문의, A-44, A-45, A-50~A-54, 리뷰 2종 등), 인증 7개(A-14, A-27, A-27r, A-27z, A-28, A-28n, A-28d).

남은 39개(노드 ID):
| 묶음 | 화면 |
|---|---|
| 결제 영수증 | A-09t `557:5580`, A-09t-in `557:5727`, A-09c `557:5906`, A-09c-p `566:26719` |
| 설정·약관 | A-35g `655:7269`, A-35t `655:7579`, A-35l `655:7760`, A-36o `656:7779`, A-36u `656:7989`, A-36v `657:7797`, A-39 `657:7899`, A-39p `657:8011` |
| 브랜드·주소·필터 | A-33 `616:12901`, A-34 `616:13032`, A-46 `1249:9196`, A-47 `1249:9283`, A-48 `1249:9377` |
| 검색·장바구니 | A-06b `180:1511`, A-06z `180:1681`, A-07h `181:1738`, A-07h2 `181:1940` |
| 시트·사업자 | A-05s `180:1142`, A-05sh `180:1258`, A-14b `558:5787`, A-56 `879:44734` |
| 기타 상태 | A-13e `558:5680`, A-15d `557:5389`, A-16e `927:44328`, A-20e `927:44560`, A-23-err `528:21835`, A-26c `459:4287`, A-26r-pw `467:4461`, A-29 `480:4806`, A-30 `480:4974`, A-31z `480:5262`, A-32z `480:5756`, A-40z `657:35872`, A-42r `661:8268`, A-42z `661:8437`, A-19a `879:44844`, A-19b `879:44922`, A-19l 필터 3종 `927:45466`·`927:45597`·`927:45728`, A-19l 철회 후 `879:45201`, A-51 철회 완료 `879:45279`, A-01 `178:350` |

알려진 예외: A-07 장바구니는 샘플 상품명·가격이 Figma와 다름(서버 장바구니 연결 시 해결), A-35/A-36/A-09는 시뮬레이터 알림 권한·샘플 상태 때문에 다른 Figma 상태로 보임, A-42 FAQ 검색창은 Figma 안에서도 색이 다름.

## 5. 서버 통신 현황
- 서버: `https://eum.https.gsmsv.site` (Swagger `/swagger-ui/index.html`, 스펙 `/v3/api-docs`). 빌드 설정 `EUM_API_BASE_URL`.
- 완료: API 클라이언트(앱 대상 68개, `Scripts/generate_api_clients.py`로 재생성), 앱 인증 세션(`AppAuthSession`), 앱 공용 `AppServices`, **로그인 화면 연결**(실서버 실패 응답 확인), **카테고리 화면 연결**(서버 카테고리 6개, 탭 시 `/products?categoryId=`).
- 서버 상태: 상품·홈·브랜드·이벤트 데이터가 비어 있음. 카테고리는 상위 없이 6개(사용자 결정: 서버 목록 그대로 사용).
- 다음: 로그인 상태를 앱 전체(마이페이지·내 정보)에 반영 → 상품 목록·검색·상세 → 장바구니 → 주문·결제(토스 결제창, `POST /orders` → 토스 → `POST /payments/confirm`, 202는 주문 상세 재조회).
- 사용자 결정 대기: 테스트 계정(로그인 성공 확인용), CAPTCHA 처리 방식, 토스 테스트 클라이언트 키(`test_ck_...`, 시크릿 키는 서버 전용, 출시 시 발주사 계정 키로 앱·서버 동시 교체), 빈 데이터일 때 빈 상태 화면 표시 여부(추천: 표시).

## 6. 최근 머지 기록
#273, #277, #279(개별 화면), #286(폰트·색상 토큰·로그인), #288(PR CI 단축), #264(API 클라이언트), #291·#292(화면 재점검 1·2차), #294(로그인 서버 연결), #296(카테고리 서버 연결).
