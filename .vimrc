if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:iswindows=1
    let g:vimrc_iswindows=1
else
    let g:iswindows=0
    let g:vimrc_iswindows=0
endif

if has("autocmd")
    filetype plugin indent on
    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=78
        autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \ exe "normal! g`\"" |
            \ endif
    augroup END
else
    set autoindent
endif
autocmd BufEnter * lcd %:p:h

if(g:iswindows==1)
    if has('mouse')
        set mouse=a
    endif
    au GUIEnter * simalt ~x
endif

if has("gui_running")
    highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

set nu
syntax on
set nowrap
filetype plugin on
set history=1000
set nocompatible
set background=light
set cursorline
set nocursorcolumn
set showcmd
set smartindent
set tabstop=4
set smarttab
set shiftwidth=4
set softtabstop=4
set showmatch
set hlsearch
set incsearch
set ruler
set foldmethod=marker
set t_Co=256
set scrolloff=3
colorscheme desert
set backspace=indent,eol,start whichwrap+=<,>,[,]
hi Search term=reverse ctermfg=0 ctermbg=3
set completeopt=menu

set ambiwidth=double
let $LANG='en'
set termencoding=utf-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
set gfw=幼圆:h10:cGB2312
set fileencodings=utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fencs=utf-8,gbk

set list
set listchars=tab:>-,trail:-

map <leader>s :source ~/.vimrc<cr>
map <leader>e :e! ~/.vimrc<cr>
autocmd! bufwritepost vimrc source ~/.vimrc

let NERDShutUp=1

map <F3> :silent! Tlist<CR>
let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_Use_Right_Window=1
let Tlist_Show_One_File=0
let Tlist_File_Fold_Auto_Close=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Process_File_Always=0
let Tlist_Inc_Winwidth=0
nmap <F4> :NERDTreeToggle <CR>

let g:pyflakes_use_quickfix = 0
let g:pydiction_menu_height = 20
let g:pydiction_location = '~/.vim/ftplugin/pydiction/complete-dict' 

map fg : Dox<cr>
let g:DoxygenToolkit_authorName="tanguobin"
let g:DoxygenToolkit_licenseTag="My own license\<enter>"
let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
let g:DoxygenToolkit_briefTag_pre = "@brief\t"
let g:DoxygenToolkit_paramTag_pre = "@param\t"
let g:DoxygenToolkit_returnTag = "@return\t"
let g:DoxygenToolkit_briefTag_funcName = "no"
let g:DoxygenToolkit_maxFunctionProtoLines = 30
  
map <F12> :call Do_CsTag()<CR>
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i <C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
function Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction
