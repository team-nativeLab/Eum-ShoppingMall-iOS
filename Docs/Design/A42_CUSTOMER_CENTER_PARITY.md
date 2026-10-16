# A-42 고객센터

- Figma: [A-42 고객센터](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=661-8066)
- Node: `661:8066` (390 × 1091 pt)
- 진입: 회원/비회원 마이페이지 > 고객센터
- 구현: 기존 마이페이지 위에 고객센터 화면을 표시합니다. 상단 뒤로 가기는 마이페이지로 돌아옵니다.

## 화면 구성

고객센터 연락처 카드, 운영 시간, 전화/1:1 문의 버튼, FAQ 제목과 검색창, 카테고리 칩, 다섯 FAQ 질문과 첫 번째 열린 답변을 구현했습니다. 화면 문구와 열린 답변은 Figma 내용을 사용했습니다. 상단 역방향 화살표와 검색 아이콘, FAQ 접기/펼치기 화살표는 기존 에셋을 재사용하고, Figma에만 있는 위쪽 화살표는 원본 SVG를 Asset Catalog에 추가했습니다.

Figma 프로토타입에서 `1:1 문의하기`는 A-31 문의 내역(`480:5123`)으로, 검색창은 배송 검색 결과 A-42r(`661:8268`)로 연결됩니다. 문의 버튼은 기존 문의 내역 화면을 엽니다. 검색 버튼은 #97에서 구현한 배송 검색 결과 화면을 엽니다. A-42r에는 뒤로 가기 및 검색어 지우기 반응이 없어 두 동작은 고객센터 검색 시작 화면으로 돌아오게 연결했습니다. 전화번호는 디자인의 placeholder `0000-0000`이고 실제 전화 연결 번호가 없어 안내 메시지를 표시합니다. FAQ 카테고리와 접힌 질문에는 Figma prototype reaction이 없어 화면에 보이는 상태를 정적으로 구현했습니다.

## 시각 확인

`Docs/Screenshots/A42-customer-center.png`는 iPhone 17 Pro (iOS 26.5) 시뮬레이터 캡처입니다. Tuist가 Git worktree의 `.git` 파일 형식에서 프로젝트 루트를 찾지 못해 검증용 clone에서 프로젝트를 생성하고 실행했습니다. 직접 화면 진입 인자는 검증용 clone에만 추가했습니다. 연락처 카드는 A-42r과 공유하는 컴포넌트로 분리하고 Figma의 줄 높이에 맞췄습니다.

Figma 프레임은 390 × 1091 pt이고 캡처 기기는 402 × 874 pt (1206 × 2622 px)입니다. 화면 폭, 높이, Safe Area 및 시스템 상태 표시 영역 차이가 있어 픽셀 일치는 주장하지 않습니다. 화면 구조, 연락처 카드, 칩, FAQ 문구와 첫 답변을 캡처로 확인했습니다. 수평 칩은 스크롤할 수 있습니다.

## 검증

- SwiftLint strict: #97까지 포함해 186개 파일, 위반 0건
- Tuist: `tuist generate --no-open` 성공 (검증용 clone)
- iOS Simulator: iPhone 17 Pro, iOS 26.5, 129개 테스트 통과 (0 실패)
- 빌드 중 기존 `FavoritesViewModel` 및 `RecentlyViewedViewModel`의 Swift 6 actor-isolation 경고가 출력됐습니다. 이번 변경과 무관합니다.
