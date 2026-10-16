# A-40z 공지사항 빈 상태

- Figma: [A-40z 공지사항 빈 상태](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=657-35872)
- Node: `657:35872` (390 × 844 pt)
- 화면 제목: `공지사항`
- 빈 목록 문구: `등록된 공지사항이 없습니다`

## 구현

`AnnouncementsView`는 공지 항목이 비어 있으면 전용 `AnnouncementsEmptyView`를 표시합니다. 목록 데이터가 들어오면 기존 A-40 목록을 유지합니다. Empty state는 Figma의 상단 여백 120pt, 64pt surface, 28pt 벡터 아이콘, 제목과 간격을 반영했습니다.

아이콘은 Figma asset API에서 내려받은 28 × 28 SVG로, Figma screenshot의 메가폰 외형과 회색 stroke를 확인했습니다. Figma response 내 asset 이름은 `search-x`지만 기존 검색 빈 상태 아이콘과 외형이 달라 독립된 `AnnouncementsEmptyIcon` Asset Catalog 항목으로 저장했습니다. `preserves-vector-representation`를 사용합니다.

현재 저장소의 공지 데이터는 Mock으로 채워져 있어 기본 앱 메뉴에서 빈 상태가 나타나지 않습니다. 빈 배열을 전달하면 같은 목록 화면에서 빈 화면으로 전환되며, 향후 서비스 응답을 붙일 때 사용할 수 있습니다.

## 시각 확인

`Docs/Screenshots/A40z-announcements-empty.png`는 iPhone 17 Pro 시뮬레이터 캡처입니다. 임시 validation clone에서 빈 상태 화면을 시작 화면으로 열었습니다. 해당 테스트 전용 진입 코드는 작업 브랜치에 없습니다. 기기 해상도와 Figma의 390 × 844 pt 프레임이 달라 픽셀 일치 여부는 주장하지 않습니다.
