# 전체 리뷰 목록 Figma 패리티

- Figma: [리뷰-전체 리뷰 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=879-8887)
- Node: `879:8887`
- Frame: `390 × 844 pt`
- Branch / issue: `codex/issue-260-figma-parity` / #260

## 반영 및 대조

- 상품 요약 카드(88 pt), 평점 요약(72 pt), 필터/정렬 컨트롤, 리뷰 카드와 고정 작성 버튼의 순서를 Figma와 대조했다.
- Figma의 12 pt 섹션 간격과 카드 내부 행 간격에 맞춰 SwiftUI 간격을 조정했다. 필터·정렬과 리뷰 작성 경로도 실제 UI 테스트에서 동작을 확인했다.
- 하단 `리뷰 작성` 버튼은 52 pt이며, 시스템 안전 영역은 iOS가 제공한다. 캡처 기기의 상태 표시 영역과 뷰포트가 Figma 프레임과 달라 화면 전체 픽셀 일치를 주장하지 않는다.
- 화면 비교 자료: `../Screenshots/A49-all-reviews-ios27.png` (iPhone 18 Pro, iOS 27.0).

## 남은 데이터 범위

- 상품과 리뷰 세 건은 로컬 샘플이다. 실제 리뷰 API, 페이지네이션, 평점 집계는 연결하지 않았다.
- 사진 리뷰 필터와 정렬 메뉴는 화면 내 샘플 목록에서 동작한다. 사진 탭 확대/상세 동작은 정의된 디자인·동작 계약이 없어 구현하지 않았다.

## 검증

- `ProductListNavigationUITests.testProductReviewAndInquiryActionsOpenTheirScreensAndReturnToDetail`: 통과 (1 test, 0 failures; iPhone 18 Pro / iOS 27.0 Simulator).
- UI test 캡처를 Figma node `879:8887`과 비교해 상품/평점 카드, 필터 줄, 첫 리뷰, 고정 CTA를 확인했다.
