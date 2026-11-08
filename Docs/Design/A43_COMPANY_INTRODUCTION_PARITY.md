# A-43 회사소개 Figma 패리티

## 기준

- Figma: [A-43 회사소개 · 663:8212](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=663-8212)
- 디자인 프레임: 390 × 2376 pt
- 시뮬레이터: iPhone 17 Pro, iOS 26.5, 402 × 874 pt (1206 × 2622 px)
- 구현: 고정 상단 바와 세로 스크롤 본문, 하단 탭 바 없음

## 구현된 구성

- 상단 제목과 드로어로 돌아가는 뒤로가기
- 현장 사진 히어로, About Us 문구, 개요 문구
- 선택된 `개요`와 나머지 섹션 칩
- 2열 사업 분야 카드 4개
- 연혁 3개, 인증 2개, 파트너 자리표시자 3개
- 지도 자리표시자, 주소·고객센터·이메일, 지도 앱 버튼

Figma에서 확인한 회사 정보의 자리표시 문구를 그대로 사용했습니다. 실제 주소, 전화번호, 인증 내용, 연혁, 파트너 상표는 제공되지 않아 임의 값으로 바꾸지 않았습니다.

## 에셋

- 추가한 Figma 원본: 회사소개 히어로 PNG, 납품 트럭·작업복·안전 컨설팅 SVG, 외부 링크 SVG
- 재사용한 에셋: `ProductDetailBack`, `CategoryHardHat`, `DeliveryTimelineActive`, `DeliveryTimelineInactive`, `ProductPlaceholder`
- 히어로와 고유 SVG는 Figma에서 받은 파일을 그대로 Asset Catalog에 넣었습니다.

## 이동 및 미지원 동작

- 드로어의 `회사소개` 항목에서 화면을 열고, Figma 프로토타입에서 확인된 상단 뒤로가기는 드로어로 복귀합니다.
- Figma의 6개 섹션 칩에는 이동 반응이 없어 선택 표시만 렌더링합니다.
- 지도 CTA에도 Figma 이동 반응이 없습니다. 현재 주소는 임시값이라 실제 지도 앱 대신 연결 불가 안내를 표시합니다.
- 백엔드·실제 회사 정보는 이 화면 범위에서 연결하지 않았습니다.

## 캡처와 차이

- [회사소개 상단](../Screenshots/A43-company-introduction.png)
- [회사소개 하단 위치 정보](../Screenshots/A43-company-introduction-location.png)

Figma는 전체 세로 프레임을 한 장으로 보여주고, 실제 iPhone 화면은 본문을 스크롤합니다. 캡처는 402 pt 너비의 iPhone 뷰포트이며 Figma 원본은 390 pt입니다. 시스템 상태 표시줄·홈 인디케이터와 뷰포트 차이가 있어 픽셀 단위 일치를 주장하지 않습니다. 화면 폭 overflow와 템플릿 아이콘 색을 캡처 검토에서 확인해 수정했습니다.

캡처는 변경사항을 복사한 검증용 클론에서 `CompanyIntroductionView`를 임시 시작 화면으로 렌더링해 얻었습니다. 프로덕션 `AppCoordinator`는 변경하지 않았습니다. 이 방식으로 화면 렌더링은 확인했지만, 시뮬레이터에서 실제 드로어 탭과 뒤로가기를 직접 조작한 검증은 수행하지 않았습니다. 해당 라우팅 코드는 앱 타깃 빌드와 테스트에서 컴파일됐습니다.

## 검증

- `swiftlint lint --strict`: 190개 Swift 파일, 위반 0개
- `tuist generate --no-open`: 검증용 일반 클론에서 성공. 링크드 워크트리에서는 `.git` 파일 때문에 Tuist 루트 검색이 실패했습니다.
- `xcodebuild build -workspace EumShoppingMall.xcworkspace -scheme EumShoppingMall -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5' CODE_SIGNING_ALLOWED=NO`: 성공
- 같은 시뮬레이터 대상 `xcodebuild test`: 133개 통과, 실패 0개
- 기존 컴파일 경고: Assets Catalog의 `AccentColor` 누락, Favorites/RecentlyViewed의 Swift 6 actor-isolation 경고. 이번 화면 변경과 무관한 기존 항목입니다.
