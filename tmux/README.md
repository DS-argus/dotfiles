# tmux 빠른 참고

## 기본 정보

- 설정 파일: `~/.tmux.conf` -> `~/.config/tmux/.tmux.conf`
- prefix 키: `Ctrl-Space`
- 터미널 타입: `xterm-256color` + RGB override
- 스크롤백 버퍼: `100000`
- 플러그인: `vim-tmux-navigator`, `tmux-resurrect`, `tmux-powerkit`

## 공통 동작

- `Prefix r`: 설정 다시 로드
- `Prefix :`: command prompt 열기

## 세션 관련

- `Prefix s`: session tree
- `Prefix $`: 현재 세션 이름 변경
  - command prompt에서 `rename-session <new-name>`: 세션 이름 변경
- `Prefix (`: 이전 세션으로 이동
- `Prefix )`: 다음 세션으로 이동
- `Prefix d`: 현재 세션 detach

## 창과 패널 관련

- `Prefix c`: 현재 pane 경로에서 새 window 생성
- `Prefix 1..9`: 해당 번호 window로 바로 이동
- `Prefix n` / `Prefix p`: 다음 / 이전 window
- `Prefix w`: window tree
- `Prefix ,`: 현재 window 이름 변경
- `Prefix <`: window context menu
- `Prefix |`: 오른쪽으로 세로 분할
- `Prefix -`: 아래로 가로 분할
- `Prefix q`: pane 번호 표시
- `Prefix o`: 다음 pane으로 이동
- `Prefix ;`: 직전 pane으로 이동
- `Prefix x`: 현재 pane 종료
- `Prefix m`: 현재 pane zoom toggle
- `Prefix z`: tmux 기본 zoom toggle
- `Prefix >`: pane context menu

## 패널 크기와 이동

- `Prefix h` / `j` / `k` / `l`: pane 크기 좌 / 하 / 상 / 우 조절

## 복사 모드

- `Prefix [`: copy-mode 진입
- `q`: copy-mode 종료
- `g` / `G`: 맨 위 / 맨 아래로 이동
- `Ctrl-u` / `Ctrl-d`: 반 페이지 위 / 아래 이동
- `/` / `?`: 정방향 / 역방향 검색
- `n` / `N`: 다음 / 이전 검색 결과
- `Space` 또는 `v`: 선택 시작
- `y` 또는 `Enter`: 복사
- `Prefix ]`: 최근 복사 버퍼 붙여넣기

## 컨텍스트 메뉴 요약

- `Prefix <`: window context menu
- 주요 기능: window 순서 바꾸기, 이름 변경, 종료, 재시작, 새 window 생성
- 대표 항목: `Swap Left`, `Swap Right`, `Swap Marked`, `Rename`, `Kill`, `Respawn`, `New After`, `New At End`

- `Prefix >`: pane context menu
- 주요 기능: split, pane 순서 바꾸기, 복사/검색, 확대, 종료, 재시작
- 대표 항목: `Horizontal Split`, `Vertical Split`, `Swap Up`, `Swap Down`, `Swap Marked`, `Search For`, `Copy`, `Kill`, `Respawn`, `Zoom`

## 플러그인 단축키

- `vim-tmux-navigator`: Vim split과 tmux pane 사이를 같은 키로 자연스럽게 이동
  - `Ctrl-h` / `j` / `k` / `l`: `vim-tmux-navigator`로 Vim과 tmux pane 사이 이동
  - `Ctrl-\`: `vim-tmux-navigator`로 마지막 pane으로 이동
- `tmux-resurrect`: tmux 세션, window, pane 상태를 저장하고 나중에 복원
  - `Prefix C-s`: `tmux-resurrect`로 세션 저장
  - `Prefix C-r`: `tmux-resurrect`로 세션 복원
- `tmux-powerkit`: 상태바 테마, 세션/창 표시, 날짜/날씨 같은 플러그인 정보를 렌더링
  - `Prefix T`: `tmux-powerkit` 테마 선택기 열기
  - `Prefix C-d`: `tmux-powerkit` 캐시 비우기
  - `Prefix C-e`: `tmux-powerkit` 옵션 보기
  - `Prefix C-y`: `tmux-powerkit` 키바인딩 보기

## 셸에서 자주 쓰는 명령

- `tmux new -s <name>`: 새 세션 생성
- `tmux ls`: 세션 목록 보기
- `tmux attach -t <name>`: 기존 세션에 접속
- `tmux rename-session -t <old> <new>`: 세션 이름 변경
- `tmux kill-session -t <name>`: 세션 종료
- `tmux source-file ~/.tmux.conf`: 설정 다시 로드
