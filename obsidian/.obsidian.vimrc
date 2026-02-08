" Insert 모드에서 'jk'를 입력하면 Normal 모드로 전환
inoremap jk <Esc>


" Outliner plugin을 사용할 때 o,  O 에서 발생하는 오류 해결 
" https://github.com/vslinko/obsidian-outliner/issues/556
nunmap o
unumap O

" 특정 텍스트를 원하는 형식으로 감싸는 surround 함수 정의
" 예: '[[ ]]', '" "', "' '", '` `' 등으로 감쌀 수 있음
exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }
exmap surround_under_bar surround _ _
exmap surround_star surround ** **

" HTML 색상 태그로 감싸는 surround 함수 정의
exmap surround_cyan surround <font\ color=00FFFF> </font>
exmap surround_blue surround <font\ color=0000FF> </font>
exmap surround_gold surround <font\ color=FFD700> </font>
exmap surround_green surround <font\ color=008000> </font>
exmap surround_red surround <font\ color=FF0000> </font>

" Visual 모드에서 surround를 사용하기 위한 매핑 정의
" NOTE: Normal 모드에서 surround 명령어를 실행하려면 <CR> 필요
vmap [[ :surround_wiki<CR>              
vunmap s                                
vmap s" :surround_double_quotes<CR>     
vmap s' :surround_single_quotes<CR>     
vmap s` :surround_backticks<CR>         
vmap s( :surround_brackets<CR>          
vmap s) :surround_brackets<CR>          
vmap s[ :surround_square_brackets<CR>   
vmap s{ :surround_curly_brackets<CR>    
vmap s_ :surround_under_bar<CR>         
vmap s* :surround_star<CR>              

" Visual 모드에서 HTML 색상 태그 surround
vmap scyan :surround_cyan<CR>           
vmap sblue :surround_blue<CR>           
vmap sgold :surround_gold<CR>           
vmap sgreen :surround_green<CR>          
vmap sred :surround_red<CR>             
