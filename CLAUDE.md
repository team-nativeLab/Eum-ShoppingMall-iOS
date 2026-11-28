# CLAUDE.md

이 저장소에서 작업하는 모든 에이전트(Codex, Claude, Hermes)는 먼저 [`Docs/Agent/HANDOFF.md`](Docs/Agent/HANDOFF.md)를 읽고 그 규칙을 따른다.

핵심 규칙:
- 사용자에게 보내는 답변은 항상 한국어로 쓴다.
- 이슈 → 브랜치 → PR(base `dev`) → CI → 머지 순서. force push 금지.
- 사용자의 원래 작업 폴더(`/Users/isiu/Desktop/Eum-ShoppingMall-iOS`)에서 작업한다. 커밋되지 않은 기존 파일은 건드리지 않고, 여러 에이전트가 동시에 같은 폴더를 쓰지 않는다.
- Figma 대조와 남은 작업 목록, 서버 통신 현황은 인수인계 문서에 있다.
