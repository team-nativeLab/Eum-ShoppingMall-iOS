# Figma 분석 및 구현 계획

원본 파일: https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=178-345

분석 대상은 `06 Design — App` 페이지이며, Figma 파일은 읽기 전용으로 유지합니다.

## 확인된 화면

- A-01 스플래시
- A-02 홈
- A-03 카테고리
- A-04 상품 목록
- A-05 상품 상세
- 장바구니·주문·마이페이지 관련 카드와 상태 화면

## 확인된 홈 구조

390pt 기준으로 상단 시스템 바와 TopBar, 검색바, 히어로 배너, 가로 스크롤 카테고리, 추천 상품 가로 스크롤, 베스트셀러 2열 그리드, 견적 배너, 하단 TabBar로 구성됩니다. 공통 인스턴스에는 `HF/App/TopBar`, `HF/App/TabBar`, `HF/ProductCard`, `HF/Button`, `HF/CategoryItem`이 사용됩니다.

## 구현 계획

1. 공통 토큰은 Figma 스타일과 변수 분석을 완료한 뒤 확정합니다.
2. 화면 단위 ViewModel은 API 모델과 분리하고, 화면 특성에 따라 UIKit 또는 SwiftUI를 선택합니다.
3. UIKit과 SwiftUI 경계에는 `UIHostingController`, `UIViewControllerRepresentable`을 사용합니다.
4. 내비게이션은 Coordinator/Router를 도입하되 실제 플로우가 확정된 뒤 최소 범위로 추가합니다.

이번 초기 구축에서는 실제 퍼블리싱과 임의의 색상·폰트 확정을 하지 않습니다.
