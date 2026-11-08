# A-42z FAQ 검색 결과 없음

- Figma: [A-42z FAQ 검색 결과 없음](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=661-8437)
- Node: `661:8437` (390 × 844 pt)
- 진입: 고객센터 FAQ 검색창 > 검색어 입력 후 검색 > 결과 없음
- 뒤로 가기: 고객센터 FAQ 검색 시작 화면

## 화면 구성

A-42 고객센터와 같은 상단 바와 연락처 카드, FAQ 제목, 입력한 검색어와 clear 아이콘을 표시합니다. 검색어에 결과가 없으면 기존 `SearchEmpty` 에셋을 회색 원 안에 표시하고, 검색 실패 제목, 안내 문구, 1:1 문의 버튼을 배치합니다. Figma의 `search-x` SVG와 기존 `SearchEmpty` 에셋 SHA-256이 같아 새 에셋을 추가하지 않았습니다.

A-42r 검색창에서 검색어를 바꾸고 제출하면 Mock 질문 두 개를 필터링합니다. `배송`은 두 검색 결과를, Figma 예시 `검색어`와 일치하지 않는 값은 이 빈 상태를 보여 줍니다. 검색 실패 제목에는 입력한 검색어를 사용합니다. 전화 연결은 기존 placeholder 안내를 따르고, 1:1 문의 버튼은 이미 구현된 문의 내역 화면으로 연결합니다. Figma에서 A-42z 하위 요소의 prototype reaction은 제공되지 않아 문의 이동은 기존 고객센터 문의 버튼과 같은 경로를 사용했습니다. 서버 검색은 범위 밖입니다.

## 시각 확인

`Docs/Screenshots/A42z-faq-no-results.png`는 iPhone 17 Pro (iOS 26.5) 시뮬레이터 캡처입니다. Tuist가 Git worktree의 `.git` 파일 형식에서 프로젝트 루트를 찾지 못해 검증용 clone에서 생성하고 실행했습니다. 직접 진입 인자는 검증용 clone에만 추가했습니다.

Figma 프레임은 390 × 844 pt이고 캡처 기기는 402 × 874 pt (1206 × 2622 px)입니다. Dynamic Island에 따른 상태 표시 영역과 Safe Area 차이가 있어 위쪽 배치와 시스템 상태 막대가 다르므로 픽셀 일치는 주장하지 않습니다. 연락처 카드, 검색어, 빈 상태 아이콘과 문구, CTA 배치를 캡처로 확인했습니다.

## 검증

- SwiftLint strict: 187개 파일, 위반 0건
- Tuist: `tuist generate --no-open` 성공 (검증용 clone)
- iOS Simulator: iPhone 17 Pro, iOS 26.5, 129개 테스트 통과 (0 실패)
- 빌드에는 기존 `AccentColor` 미설정 asset-catalog 경고와 `FavoritesViewModel`, `RecentlyViewedViewModel`의 Swift 6 actor-isolation 경고가 출력됐습니다. 이번 변경과 무관합니다.
