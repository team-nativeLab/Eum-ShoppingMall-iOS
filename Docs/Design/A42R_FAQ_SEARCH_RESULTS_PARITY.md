# A-42r FAQ 검색 결과

- Figma: [A-42r FAQ 검색 결과](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=661-8268)
- Node: `661:8268` (390 × 844 pt)
- 진입: 마이페이지 > 고객센터 > FAQ 검색창
- 뒤로 가기: 고객센터 FAQ 검색 시작 화면

## 화면 구성

A-42 고객센터와 같은 상단 바와 연락처 카드를 사용하고, FAQ 제목, `배송` 검색어, 검색 결과 수, 질문 두 개를 표시합니다. 연락처 카드를 공통 컴포넌트로 분리해 두 화면에서 공유하고, Figma의 글자 줄 높이(연락처 16/30/16 pt)를 적용했습니다. 검색어를 입력하고 검색 키를 누르면 Mock 질문을 필터링하고 일치한 글자를 굵게 표시합니다. 결과 수는 프레임 문구 `검색 결과 00건`을 그대로 표시합니다.

Figma 검색 시작 화면의 prototype reaction을 따라 고객센터의 검색창을 누르면 A-42r 화면으로 이동합니다. Figma에서 확인한 초기 검색어는 `배송`이며, 이 경우 두 결과를 보여 줍니다. 다른 검색어에 일치하는 Mock 항목이 없으면 이슈 #98에서 구현한 A-42z 빈 상태로 전환합니다. 결과 수 `00건`은 Figma 프레임 문구를 유지합니다. 결과 프레임에는 검색창 지우기, 뒤로 가기, FAQ 행의 reaction이 정의되어 있지 않습니다. 뒤로 가기와 검색창 지우기는 검색 시작 화면으로 돌아가며, 결과 행은 정적입니다. 실제 FAQ 서버 검색은 범위 밖입니다.

## 시각 확인

`Docs/Screenshots/A42r-faq-search-results.png`는 iPhone 17 Pro (iOS 26.5) 시뮬레이터 캡처입니다. Tuist가 Git worktree의 `.git` 파일 형식에서 프로젝트 루트를 찾지 못해 검증용 clone에서 생성하고 실행했습니다. 이 clone에만 `--show-faq-search-results` 직접 진입 인자를 추가했습니다.

Figma 프레임은 390 × 844 pt이고 캡처 기기는 402 × 874 pt (1206 × 2622 px)입니다. Dynamic Island에 따른 상태 표시 영역과 Safe Area 차이 때문에 위쪽 배치가 달라 픽셀 일치는 주장하지 않습니다. 화면 구성, 연락처 카드, 검색어, 결과 수, 질문 문구와 강조 스타일을 캡처로 확인했습니다.

## 검증

- SwiftLint strict: #98까지 포함해 187개 파일, 위반 0건
- Tuist: `tuist generate --no-open` 성공 (검증용 clone)
- iOS Simulator: iPhone 17 Pro, iOS 26.5, 129개 테스트 통과 (0 실패)
- 기존 `FavoritesViewModel` 및 `RecentlyViewedViewModel`에서 Swift 6 actor-isolation 경고가 출력됐습니다. 이번 변경과 무관합니다.
