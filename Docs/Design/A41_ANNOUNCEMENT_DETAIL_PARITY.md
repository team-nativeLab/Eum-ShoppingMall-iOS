# A-41 공지사항 상세

- Figma: [A-41 공지사항 상세](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=657-36024)
- Node: `657:36024` (390 × 844 pt)
- 진입: 회원/비회원 마이페이지 > 공지사항 > 첫 번째 고정 공지
- 뒤로 가기: Figma prototype에서 공지사항 목록으로 연결됨

## 화면 구성

상단 제목과 뒤로 가기, 고정 공지 배지, 제목, 날짜/조회수, 구분선, 본문, 이미지 자리표시자, 첨부파일 카드를 구현했습니다. 이미지 자리표시자는 기존 `ProductPlaceholder` 벡터 에셋을 원본 색상으로 표시합니다. Figma 프레임 폭에 맞춘 350:197 비율을 유지해 더 넓은 기기에서도 가로세로 비율이 보존됩니다.

공지 날짜/조회수/본문/첨부파일은 Figma의 placeholder 문구로 채웠습니다. 첫 번째 고정 공지만 상세 화면으로 진입하며, 상세 상단의 뒤로 가기는 목록으로 돌아옵니다. 첨부 다운로드에는 prototype 반응과 파일 API가 없어 실제 다운로드 대신 연동 안내 메시지를 표시합니다.

## 시각 확인

`Docs/Screenshots/A41-announcement-detail.png`는 iPhone 17 Pro (iOS 26.5) 시뮬레이터 캡처입니다. Tuist가 Git worktree의 `.git` 파일 형식에서 프로젝트 루트를 찾지 못해 검증용 clone에서 프로젝트를 생성하고 실행했습니다. 해당 clone에만 화면 직접 실행 인자를 추가했으며 앱 소스 변경으로는 포함하지 않았습니다.

Figma 프레임은 390 × 844 pt이고 캡처 기기는 402 × 874 pt입니다. Safe Area와 시스템 상태 표시 영역 차이 때문에 위쪽 배치가 달라 픽셀 일치는 주장하지 않습니다. 구성, 자산, 비율, 텍스트와 첨부파일 배치를 화면 캡처로 확인했습니다.

## 검증

- SwiftLint strict: 179개 파일, 위반 0건
- Tuist: `tuist generate --no-open` 성공 (검증용 clone)
- iOS Simulator: `xcodebuild -workspace EumShoppingMall.xcworkspace -scheme EumShoppingMall -destination 'platform=iOS Simulator,id=DCBAA5F8-3A1F-4248-B6C9-D1B5DBA839BF' -derivedDataPath /tmp/Eum-ShoppingMall-issue95-derived CODE_SIGNING_ALLOWED=NO test -quiet` 성공, 127개 테스트 통과
- 빌드 로그에 기존 `FavoritesViewModel` 및 `RecentlyViewedViewModel`의 Swift 6 actor-isolation 경고가 출력됐습니다. 이번 변경 파일과는 무관합니다.
- 다운로드 API와 실제 공지 서버 데이터는 범위 밖입니다.
