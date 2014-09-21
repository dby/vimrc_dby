runtime! debian.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"侦测文件类型
if has("syntax")
  syntax on 
endif



"""pathogen
"""在.vimrc文件中，必须在filetype indent on 之前
"""execute pathogen#infect()
"call pathogen#infect()

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available

"history文件中记录的行数
set history=100
set magic

"在处理未保存或者只读模式的时候，弹出确认
set confirm
set iskeyword+=_,$,@,%,#,-
"光标在窗口上下边界时距离边界7行开始滚屏
set so=7
"显示行号
set number
set ts=4
"以空格代替tab
set noexpandtab
"继承前一行的缩进方式，特别适合于多行的注释
set autoindent

"为C程序提供自动缩进
set smartindent
set modeline """允许被编辑的文件以注释的形式设置vim选项

au FileType c,cpp,h,java,javascript,html,htmldjango setlocal cindent

"使用C样式的缩进
function! GnuIndent()
        setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
        setlocal shiftwidth=4
        setlocal tabstop=4
endfunction

"astyle as c and cpp styler
autocmd FileType c,cpp,h set formatprg=astyle

au FileType c,cpp,h,java,python,javascript setlocal cinoptions=:0,g0,(0,w1 shiftwidth=4 tabstop=4 softtabstop=4 cc=80
au FileType diff  setlocal shiftwidth=4 tabstop=4
au FileType html,css,htmldjango,html,xml setlocal autoindent sw=2 ts=2 sts=2 fdm=manual expandtab
au FileType javascript setlocal sw=4 ts=4 sts=4 expandtab
au FileType changelog setlocal textwidth=76

"set shiftwidth=4
"set tabstop=4
"set softtabstop=4

"ambiwidth默认值是single，若为utf-8编码全角符号会有问题
set ambiwidth=double
"自动加载外部改变的内容
set autoread
"自动切换当前目录是当前文件所在的目录
set autochdir
"拼写检查
"set spell

"编辑过程中右下角显示光标的状态行
set ruler
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)
"单词中间断行
set nolinebreak
"自动换行显示
set wrap
"设置命令行的行数为1
set cmdheight=1
"显示状态栏（默认值是1,无法显示状态栏）
"set laststatus
"set statusline=%F%m%r%h%w\[ASCII=\%03.3b,0x\%02.2B][POS=%04l,%03v][%p%%][LEN=%L]%=[%{GitBranch()}]

" 状态行颜色
highlight StatusLine guifg=SlateBlue guibg=Yellow
highlight StatusLineNC guifg=Gray guibg=White

"在insert下可以使用删除键进行删除
set backspace=indent,eol,start
"去掉有关vi一致性模式，避免以前版本的一些bug
set nocp
"增强模式中命令行自动完成的操作
set wildmenu
"文字编码加入utf-8
" 设置默认解码
set fenc=utf-8
set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936
set enc=utf-8
"使用英文菜单，工具条及消息提示
set langmenu=none
"自动缩排
set ai
"不要闪烁
set novisualbell

"设置语法折叠
set foldmethod=syntax
set foldcolumn=0 "设置折叠区域的宽度
set foldlevel=100
"" 用空格键来开关折叠
set foldenable
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
set foldlevel=100


" 在搜索的时候忽略大小写
set smartcase
set ignorecase
"不要高亮被搜索的句子（phrases）
set nohlsearch
"在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）
set incsearch


"修改背景色
"set background=dark
"hi Normal ctermbg=Black ctermfg=white  


set fileencodings=utf8,ucs-bom,utf-8,cp936,gb18030,big5,gbk

"鼠标支持
if has('mouse')
set mouse=a
	set selection=exclusive
	set selectmode=mouse,key
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""binding keys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""F2 去除空行
nnoremap <F2> :g/^\S?+$/d<CR>

"设置程序的运行和调试的快捷键F5和F8
map <F5> :call CompileRun()<CR>
func! CompileRun()
    exec "w"
    ""C程序
    if &filetype == 'c'
        let filename = expand("%<")
        exec "!gcc -Wall % -g -o %<"
        "exec "ConqueTermVSplit gdb ".filename
        exec "! ./%<"
    ""C++程序
    elseif &filetype == 'cpp'
        let filename = expand("%<")
        exec "!g++ -Wall % -g -o %<"
       " exec "ConqueTermVSplit gdb ".filename
        exec "! ./%<"
    ""java程序
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!jdb %<"
    ""python
    elseif &filetype == 'python'
        let filename = expand("%")
        exec "ConqueTermVSplit python2 -m pdb ".filename
    ""vimwiki
    elseif &filetype == 'vimwiki'
        "exec /"!python2 %<"
        exec "VimwikiAll2HTML" 
        exec "setf vimwiki"
    elseif &filetype == 'sh'
        :!./%
    endif
endfunc

"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""auto insert
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()" 
""定义函数SetTitle,自动插入文件头
function SetTitle()
    ""如果文件是的类型是.sh文件
    if &filetype == 'sh' 
        call setline(1,"\#############################################################") 
        call append(line("."), "\# File Name: ".expand("%")) 
        call append(line(".")+1, "\# Author: dby812") 
        call append(line(".")+2, "\# mail: sys.linux.d@gmail.com") 
        call append(line(".")+3, "\# Created Time: ".strftime("%c")) 
        call append(line(".")+4, "\################################################################")
        call append(line(".")+5, "\#!/bin/bash")
        call append(line(".")+6, "")
    else
        call setline(1, "/*************************************************************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: dby812") 
        call append(line(".")+2, "    > Mail: sys.linux.d@gmail.com ") 
        call append(line(".")+3, "    > Created Time: ".strftime("%c")) 
        call append(line(".")+4, " ************************************************************************/") 
        call append(line(".")+5, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+6, "#include <iostream>")
        call append(line(".")+7, "#include <string>")
        call append(line(".")+8, "#include <algorithm>")
        call append(line(".")+9, "#include <cstdio>")
        call append(line(".")+10,"#include <cmath>")
        call append(line(".")+11,"#include <iomanip>")
        call append(line(".")+12,"using namespace std;")
        call append(line(".")+13, "")
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "#include <algorithm.h>")
        call append(line(".")+8, "")
    endif
    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""CTags的设定
"set tags=/usr/include/tags_inc; "使之可能自动跳到库函数"
"set autochdir

"""WinManager
let g:winManagerWindowLayout='TagList|FileExplorer'
nmap wm :WMToggle<cr>
"设置winmanager的宽度，默认为25
let g:winManagerWidth = 30
let g:winManagerHeight = 1


"""补全
filetype plugin indent on
set completeopt=longest,menu


"""pathogen
"execute pathogen#infect()
"call pathogen#infect()

set nocompatible    " be iMproved
filetype off        " required!


set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" " required!
Bundle 'gmarik/vundle'

""" syntax
Bundle 'xml.vim'
Bundle 'python.vim--Vasiliev'
Bundle 'html5.vim'
Bundle 'JavaScript-syntax'
Bundle 'asciidoc.vim'
Bundle 'confluencewiki.vim'
Bundle 'mako.vim'
Bundle 'moin.vim'

""" Color

Bundle 'desert256.vim'
Bundle 'Impact'
Bundle 'matrix.vim--Yang'
Bundle 'vibrantink'
Bundle 'vividchalk.vim'

""" Indent

Bundle 'indent/html.vim'
Bundle 'IndentAnything'
Bundle 'Javascript-Indentation'
Bundle 'mako.vim--Torborg'
Bundle 'gg/python.vim'

""" plugin

" vim-scripts repos
"Bundle 'vim-plugin-foo'
"Bundle 'vim-plugin-bar'
Bundle 'taglist.vim'
Bundle 'minibufexpl.vim'
"Bundle 'SuperTab'
"Bundle 'vimwiki'
Bundle 'winmanager'
"Bundle 'bufexplorer.zip'
Bundle 'The-NERD-tree'
"Bundle 'matrix.vim--Yang'
"Bundle 'FencView.vim'
"Bundle 'Conque-Shell'
"Bundle 'Vimpress'
"Bundle 'Markdown'
"Bundle 'LaTeX-Suite-aka-Vim-LaTeX'
"Bundle 'c.vim'

"代码在github上"
Bundle 'Shougo/neocomplcache.git' 
Bundle 'tpope/vim-surround.git'
Bundle 'scrooloose/nerdtree.git'
"Bundle 'Lokaltog/vim-powerline'
Bundle 'bling/vim-airline'
Bundle 'snipMate'

filetype plugin indent on    " required!

source ~/.vim/config/TagList.vim
source ~/.vim/config/cscope.vim
source ~/.vim/config/tagbar.vim
source ~/.vim/config/Grep.vim
source ~/.vim/config/QuickFix.vim
"source ~/.vim/config/NerdComm.vim
source ~/.vim/config/Py.vim
source ~/.vim/config/PowerLine.vim
source ~/.vim/config/NerdTree.vim
"source ~/.vim/bundle/vividchalk.vim/colors/vividchalk.vim
source ~/.vim/config/Neocom.vim

"colorscheme ~/.vim/colors/xoria256.vim


if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
