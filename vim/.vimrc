"------------------------------------------------------------------------
" Vundle 환경설정 - 플러그인 관리
"------------------------------------------------------------------------
filetype off                   " 플러그인 로드를 위해 filetype 비활성화
set shell=/bin/bash            " 기본 쉘을 bash로 설정
set rtp+=~/.vim/bundle/Vundle.vim " Vundle 경로 추가
call vundle#begin()            " Vundle 시작
    Plugin 'VundleVim/Vundle.vim' " Vundle 자체 플러그인

    " 플러그인 목록
    Plugin 'vim-airline/vim-airline'        " 상태바 플러그인
    Plugin 'vim-airline/vim-airline-themes' " 상태바 테마
    Plugin 'scrooloose/nerdtree'            " 파일 탐색기
    Plugin 'ryanoasis/vim-devicons'         " 아이콘 추가
    Plugin 'tpope/vim-commentary'           " 코드 주석 플러그인
    Plugin 'christoomey/vim-tmux-navigator' " tmux와 vim 간 창 이동 지원
    Plugin 'tribela/vim-transparent'        " 투명 배경 플러그인
    Plugin 'yggdroot/indentline'            " 들여쓰기 가이드라인 표시
    Plugin 'jiangmiao/auto-pairs'           " 자동 괄호 닫기
    Plugin 'ghifarit53/tokyonight-vim'      " Tokyo Night 색상 테마

call vundle#end()            " Vundle 종료
filetype plugin indent on     " filetype 및 자동 들여쓰기 활성화

"------------------------------------------------------------------------
" 기본 설정 및 리더 키 설정
"------------------------------------------------------------------------
let mapleader = " "            " 리더 키를 공백으로 설정
set encoding=UTF-8             " 파일 인코딩 UTF-8로 설정

"------------------------------------------------------------------------
" 테마 및 화면 설정
"------------------------------------------------------------------------
set termguicolors              " 24비트 컬러 지원 활성화
let g:tokyonight_style = 'night'    " 테마 스타일: night 또는 storm
let g:tokyonight_enable_italic = 1  " 기울임 활성화
colorscheme tokyonight         " Tokyo Night 테마 적용
let g:airline_theme = "tokyonight" " vim-airline 테마 설정
syntax on

set cursorline                 " 현재 줄 하이라이트
set ruler                      " 하단 상태바에 커서 위치 표시
set laststatus=2               " 항상 상태바 표시
set signcolumn=yes             " 항상 사인 컬럼 표시

set relativenumber             " 상대 라인 번호 표시
set number                     " 절대 라인 번호 함께 표시

"------------------------------------------------------------------------
" 탭 및 들여쓰기 설정
"------------------------------------------------------------------------
set tabstop=4                  " 탭을 4칸으로 설정
set shiftwidth=4               " 들여쓰기 폭 4칸
set expandtab                  " 탭을 공백으로 변환
set autoindent                 " 현재 줄의 들여쓰기 복사
set smartindent                " 자동 들여쓰기 활성화

"------------------------------------------------------------------------
" 검색 설정
"------------------------------------------------------------------------
set ignorecase                 " 대소문자 구분 없이 검색
set smartcase                  " 대문자가 포함된 경우 대소문자 구분

"------------------------------------------------------------------------
" 창 및 탭 관리
"------------------------------------------------------------------------
nnoremap <leader>sv <C-w>v " 창 세로 분할
nnoremap <leader>sh <C-w>s " 창 가로 분할
nnoremap <leader>se <C-w>= " 창 크기 동일하게 조정
nnoremap <leader>sx :close<CR> " 현재 창 닫기

nnoremap <leader>to :tabnew<CR> " 새 탭 열기
nnoremap <leader>tx :tabclose<CR> " 현재 탭 닫기
nnoremap <leader>tn :tabn<CR> " 다음 탭으로 이동
nnoremap <leader>tp :tabp<CR> " 이전 탭으로 이동
nnoremap <leader>tf :tabnew %<CR> " 현재 버퍼를 새 탭에서 열기

set splitright                 " 세로 분할 시 오른쪽에 새 창 열기
set splitbelow                 " 가로 분할 시 아래쪽에 새 창 열기

"------------------------------------------------------------------------
" 플러그인 관련 단축키
"------------------------------------------------------------------------
nnoremap <leader>nt :NERDTreeToggle<CR> " NERDTree 열고 닫기
let NERDTreeShowHidden=1                " NERDTree에서 숨김 파일 표시

"------------------------------------------------------------------------
" 입력 모드 및 일반 모드 단축키
"------------------------------------------------------------------------
inoremap jk <ESC>              " 입력 모드 종료 (jk 입력 시 ESC로 처리)
nnoremap <leader>nh :nohl<CR>  " 검색 하이라이트 제거

"------------------------------------------------------------------------
" 기타 설정
"------------------------------------------------------------------------
set nowrap                     " 줄바꿈 비활성화
set backspace=indent,eol,start " 백스페이스 키 동작 설정
set noswapfile                 " 스왑 파일 비활성화

" 시스템 클립보드 사용
if has('mac')
  set clipboard=unnamed        " Mac: unnamed 클립보드 사용
elseif has('unix')
  set clipboard=unnamedplus    " Linux: unnamedplus 클립보드 사용
endif

" 마지막 위치로 이동
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal g`\"" |
      \ endif

" 저장 전 불필요한 공백 제거
autocmd BufWritePre * :%s/\s\+$//e " 저장 전 줄 끝 공백 제거
