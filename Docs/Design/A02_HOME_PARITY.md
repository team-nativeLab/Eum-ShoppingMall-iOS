# A-02 홈 Figma 패리티

- Figma: [A-02 홈 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=178-369)
- 기준 프레임: 390 × 1701 pt
- 확인 캡처: [A02-home.png](../Screenshots/A02-home.png)

## 반영 내용

- 홈 카테고리 가로 레일을 제거하고 Figma의 검색창, 3장 히어로 배너, 추천 제품, 베스트 셀러 흐름으로 구성했습니다.
- 히어로 배너에 Figma 문구, 실제 제공 이미지, 제품/견적/회사소개 CTA를 연결했습니다.
- 홈 상품 카드에 평점·리뷰 수, 정상가·할인율·판매가, 가격 문의, 품절 상태를 표시합니다.
- 홈 상품 전체 보기와 상세 화면 이동을 연결하고, 상품목록에서 뒤로 가면 홈으로 복귀합니다.

## 검증

- `swiftlint lint --strict`: 통과, 217개 Swift 파일, 위반 0건
- iPhone 17 Pro 시뮬레이터 빌드 및 실행: 통과
- 전체 XCTest/UI 테스트: 181개 통과, 실패 0, 건너뜀 0
- `git diff --check`: 통과

제품 데이터와 가격은 현재 화면 패리티를 위한 mock 값이며 서버 통신 결과가 아닙니다.
