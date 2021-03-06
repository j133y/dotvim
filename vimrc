autocmd!

set nocompatible " do not use vi compatibility mode. must come first because it changes other options.
set noshowmode
set encoding=utf-8 " default encoding utf-8
set showcmd " show incomplete commands
set list " show invisibles
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮ " use the same symbols as TextMate for tabstops and EOLs
set number " show line numbers
set ruler " show column number
set linebreak " don't break wrapped lines on words
set cc=120 " highlight 80 columns
set backspace=indent,eol,start " intuitive backspacing
set fileformats=unix,mac,dos " EOL format
set cursorline " highlight cursor line
set incsearch " highlight matches as you type
set hlsearch " highlight matches
set scrolloff=3 " show 3 lines of context around the cursor
set ignorecase smartcase " ignore case while searching except if there's an uppercase letter
set shiftwidth=2 " number of spaces used for (auto)indent
set expandtab " use soft tabs (spaces)
set softtabstop=2 " size of soft tabs
set autoindent " auto indent lines
set smartindent " smart (language based) auto indent
set history=500 " keep 500 cmdline history
set undofile " persistent undo
set undodir=~/.vim/tmp
set backup " turn on backup
set backupdir=~/.vim/backup " dir to save backup files
set directory=~/.vim/tmp " dir to keep all swap files
set laststatus=2 " show status line all the time
set wildmenu " enhanced command line completion
set wildmode=list:longest " complete files like a shell
set wildignore=vendor/bundle/**,tmp/**,log/**,coverage/**,solr/data "command-t ignore list
set hidden " handle multiple buffers better
set t_Co=256 " enable 256 colors in terminal

syntax on " enable syntax highlighting
filetype off
filetype plugin indent on " enable file type detection

" Vundle setup
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/vundle'

" vim bundles
Plugin 'tomasr/molokai'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/matchit.zip'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'vim-scripts/kwbdi.vim'
Plugin 'vim-scripts/bufexplorer.zip'
Plugin 'rking/ag.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'Shougo/neocomplete.vim'
Plugin 'scrooloose/syntastic'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'othree/html5.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required

colorscheme molokai " set color scheme

" change leader key
let mapleader=","

" save keystrokes, so we don't need to press the Shift key
nnoremap ; :

" switch to last used buffer
nnoremap <leader>l :e#<CR>

" YankRing mapping
nnoremap <leader>y :YRShow<CR>

" YankRing configs
let g:yankring_history_dir = "~/.vim/tmp"

" clears the search register
nmap <silent> <leader>/ :nohlsearch<CR>

" keep window on buffer delete
nmap <silent> <leader>bd <Plug>Kwbd

" function to delete all hidden buffers
function! Wipeout()
  " list of *all* buffer numbers
  let l:buffers = range(1, bufnr('$'))

  " what tab page are we in?
  let l:currentTab = tabpagenr()
  try
    " go through all tab pages
    let l:tab = 0
    while l:tab < tabpagenr('$')
      let l:tab += 1

      " go through all windows
      let l:win = 0
      while l:win < winnr('$')
        let l:win += 1
        " whatever buffer is in this window in this tab, remove it from
        " l:buffers list
        let l:thisbuf = winbufnr(l:win)
        call remove(l:buffers, index(l:buffers, l:thisbuf))
      endwhile
    endwhile

    " if there are any buffers left, delete them
    if len(l:buffers)
      execute 'bwipeout' join(l:buffers)
    endif
  finally
    " go back to our original tab page
    execute 'tabnext' l:currentTab
  endtry
endfunction

" mapping for function above
map <leader>bw :call Wipeout()<CR>
"
" For Ruby with PRY
map <leader>pry orequire 'pry'; binding.pry<ESC>:w<CR>
imap <leader>pry <CR>require 'pry'; binding.pry<ESC>:w<CR>
map <leader>nt :NERDTreeToggle<CR>

" CtrlP
let g:ctrlp_map = '<Leader>p'
let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_working_path_mode = 'ra'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git\|node_modules\|bin\|\.hg\|\.svn\|build\|log\|resources\|coverage\|doc\|tmp\|public/assets\|vendor\|Android',
  \ 'file': '\.jpg$\|\.exe$\|\.so$\|tags$\|\.dll$'
  \ }

nnoremap <Leader>fu :CtrlPFunky<Cr>
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_clear_cache_on_exit = 0

" Make those debugger statements painfully obvious
au BufEnter *.rb syn match error contained "\<binding.pry\>"

"  neocomplete

let g:neocomplete#enable_at_startup = 1

" syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
