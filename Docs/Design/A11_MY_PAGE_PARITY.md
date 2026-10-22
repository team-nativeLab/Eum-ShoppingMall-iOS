# A-11 마이페이지 Figma 패리티

- Figma: [A-11 마이페이지 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=181-2409)
- 기준 프레임: 390 × 1127 pt
- Figma 기준 캡처: [A11-mypage-figma.png](../Screenshots/A11-mypage-figma.png)

## 반영 내용

- 주문내역, 찜한 상품, 최근 본 상품, 쿠폰함에 이어 적립금 바로가기를 추가했습니다.
- 적립금 바로가기를 이미 구현된 적립금 화면에 연결하고, 뒤로 가면 마이페이지로 돌아오도록 접근성 라벨을 맞췄습니다.
- 마이페이지 바로가기 목록 테스트를 최신 Figma의 5개 항목으로 갱신했습니다.

## 검증

- `swiftlint lint --strict`: 217개 Swift 파일, 위반 0건
- `SettingsNavigationUITests.testPointsShortcutOpensPointsAndReturnsToMyPage`: 통과
- `git diff --check`: 통과

적립금 잔액과 내역은 현재 기존 mock 화면이 표시합니다. 서버 데이터 연동은 포함하지 않습니다.
