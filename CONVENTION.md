# GitHub 컨벤션

## 브랜치

- `main`: 안정화 및 배포
- `dev`: 개발 통합
- `feat/#번호-설명`, `fix/#번호-설명`, `design/#번호-설명`, `refactor/#번호-설명`, `chore/#번호-설명`, `docs/#번호-설명`
- 이슈가 없는 초기 설정은 `chore/설명`을 허용합니다.

## 커밋

커밋 제목은 `type: 한국어 설명` 형식을 사용합니다. `feat`, `fix`, `design`, `refactor`, `chore`, `docs`, `test`, `ci`를 사용합니다.

## PR

PR 대상은 기본적으로 `dev`이며, 변경 내용·관련 이슈·검증 결과·Figma 링크·UI 스크린샷을 포함합니다. 필수 리뷰와 CI 등 저장소 병합 조건을 충족하면 auto-merge를 활성화합니다. 필수 조건을 우회하거나 강제 병합하지 않습니다.
