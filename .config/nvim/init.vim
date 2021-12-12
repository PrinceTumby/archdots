" TODO Port entire init.vim to init.lua
colorscheme customcitylights
set termguicolors
set number
set hidden
set noshowmode
set splitbelow splitright
set scrolljump=-50
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set inccommand=split
set foldlevelstart=99
set spelllang=en_gb
set fileformats=unix,dos
set grepprg=rg\ --vimgrep
set sessionoptions+=globals
set switchbuf=uselast,useopen
nnoremap <Space> <Nop>
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"
" Easier window navigation {{{1
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" }}}1
nnoremap <silent><C-n> :keepjumps bn<cr>
nnoremap <silent><C-p> :keepjumps bp<cr>
nnoremap <silent><esc> :<c-u>noh<return><esc>
nnoremap <silent><leader>ev :vsplit $MYviMRC<CR>
nnoremap <silent><leader>xf :syntax sync fromstart<CR>
" State saving and loading {{{1
augroup state_saving
    autocmd!
    autocmd BufEnter * let b:current_undo_state = -1
augroup END
function! s:RestoreState()
    if b:current_undo_state !=# -1
        execute 'silent undo ' . b:current_undo_state
    else
        echo 'No undo state to return to'
    endif
endfunction
function! s:SaveState()
    let b:current_undo_state = undotree()['seq_cur']
    echo 'Current state saved'
endfunction
nnoremap <silent> <leader>ss :<c-u>call <SID>SaveState()<CR>
nnoremap <script> <silent> <leader>sr :<c-u>call <SID>RestoreState()<CR>
" }}}1

" Snippets {{{1
" Rust Snippets {{{2
function! s:NextSnippetTag()
    execute "silent normal! /\\/\\* ++ \\*\\/\r:nohlsearch\rc8l\<Esc>l"
endfunction

augroup rust_snippets
    autocmd!
    autocmd FileType rust nnoremap <script> <buffer> <silent> <localleader>n :<c-u>call <SID>NextSnippetTag()<CR>
    autocmd FileType rust nnoremap <buffer> <localleader>sma omacro_rules!  {<CR>(/* ++ */) => {/* ++ */};<CR>}<CR><Esc>3k02wla
augroup END
" }}}2
" }}}1

" vim-polyglot {{{1
let g:polyglot_disabled = ["r-lang"]
" }}}1

" Plugin Management {{{
lua << EOF
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
  execute "packadd packer.nvim"
end

require("plugins")
EOF
" }}}

" Bufferline {{{
" lua << EOF
" local filter_types = {
"   help = true,
"   vista = true,
"   qf = true,
" }
" require("bufferline").setup{
"   options = {
"     custom_filter = function()
"       return not filter_types[vim.o.filetype]
"     end,
"     show_close_icon = false,
"     always_show_bufferline = false,
"   },
" }
" EOF
" nnoremap <unique><C-n> <Cmd>keepjumps BufferLineCycleNext<CR>
" nnoremap <unique><C-p> <Cmd>keepjumps BufferLineCyclePrev<CR>
" nnoremap <unique><C-N> :keepjumps BufferLineMoveNext<CR>
" nnoremap <unique><C-P> :keepjumps BufferLineMovePrev<CR>
" }}}

" Startify {{{
let g:startify_custom_header = [
    \ '                                __                ',
    \ '   ___      __    ___   __  __ /\_\    ___ ___    ',
    \ ' /'' _ `\  /''__`\ / __`\/\ \/\ \\/\ \ /'' __` __`\  ',
    \ ' /\ \/\ \/\  __//\ \L\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ',
    \ ' \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\',
    \ '  \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/'
    \ ]
let g:startify_session_persistence = 0
let g:startify_lists = [
    \ { 'header': ['   MRU'],            'type': 'files' },
    \ { 'header': ['   Sessions'],       'type': 'sessions' },
    \ ]
let g:startify_session_before_save = [
    \ 'silent! NERDTreeClose'
    \ ]
" }}}

" Cosmosline {{{
" This gets executed again in ginit.vim
lua require "statusline"
" execute "luafile " . expand("<sfile>:p:h") . "/lua/statusline.lua"

command! FixStatusline lua cosmosline_reload_colours()
" }}}

" Cosmostabs {{{
" This gets executed again in ginit.vim
lua require "bufferline"
" execute "luafile " . expand("<sfile>:p:h") . "/lua/bufferline.lua"

command! FixBufferline lua cosmostabs_reload_colours()
" }}}

" Bufdelete {{{
nnoremap <silent><leader>bd <Cmd>Bdelete<CR>
nnoremap <silent><leader>bw <Cmd>Bwipeout<CR>
" }}}

" VimWiki {{{
let g:vimwiki_list = [{'path': '~/vimwiki/'}]
let g:vimwiki_ext2syntax = {
    \ '.md': 'markdown',
    \ '.wiki': 'default'
    \ }
" }}}

" OrgMode {{{
let g:org_aggressive_conceal = 1
let g:org_agenda_files = ["~/OneDrive/Documents/TODO.org"]
" }}}

" Rainbow {{{
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['turquoise1', '#ffd700', '#da70d6'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'guis': [''],
\	'cterms': [''],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'markdown': {
\			'parentheses_options': 'containedin=markdownCode contained',
\		},
\		'vim': {
\			'parentheses_options': 'containedin=vimFuncBody',
\		},
\		'vimwiki': 0,
\	}
\}
" }}}

" Parinfer {{{
let g:parinfer_force_balance = 1
" }}}

" vim-sexp {{{
let g:sexp_enable_insert_mode_mappings = 0
" }}}

" Denite {{{
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction
" }}}

" vim-slime {{{
let g:slime_target = 'neovim'
" }}}

" {{{ vim-which-key
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
" }}}

" Language mappings and abbreviations {{{
" augroup zig_mappings
"     autocmd!
"     autocmd FileType zig iabbrev <buffer> cpt comptime
"     autocmd FileType zig iabbrev <buffer> cc const
"     autocmd FileType zig iabbrev <buffer> pc pub const
"     autocmd FileType zig iabbrev <buffer> vv var
"     autocmd FileType zig iabbrev <buffer> pv pub var
"     autocmd FileType zig iabbrev <buffer> cv comptime var
"     autocmd FileType zig iabbrev <buffer> pf pub fn
"     autocmd FileType zig iabbrev <buffer> ss struct
"     autocmd FileType zig iabbrev <buffer> ps pub struct
"     autocmd FileType zig iabbrev <buffer> ee enum
"     autocmd FileType zig iabbrev <buffer> pe pub enum
"     autocmd FileType zig iabbrev <buffer> uu union
"     autocmd FileType zig iabbrev <buffer> pu pub union
"     autocmd FileType zig iabbrev <buffer> loop while(true)
"     autocmd FileType zig iabbrev <buffer> loopi var i: usize = 0;<CR>while
" augroup END
" }}}

" Language fixers {{{
augroup vim_settings
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup rust_settings
    autocmd!
    autocmd FileType rust setlocal foldmethod=syntax
augroup END

augroup lua_settings
    autocmd!
    autocmd FileType lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

augroup lisp_settings
    autocmd!
    autocmd FileType lisp setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType lisp let b:lexima_disabled = 1
augroup END

augroup fennel_settings
    autocmd!
    autocmd FileType fennel setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType fennel let b:lexima_disabled = 1
    autocmd FileType fennel setlocal foldmethod=syntax
augroup END

augroup org_settings
    autocmd!
    autocmd FileType org setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END
" }}}

" Language server settings {{{
lua <<EOF
local nvim_lsp = require'lspconfig'
-- nvim_lsp.clangd.setup{}
nvim_lsp.rls.setup{}
EOF
" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
augroup language_client_settings
    autocmd!
    autocmd FileType rust call s:language_client_bindings()
    autocmd FileType python call s:language_client_bindings()
    " autocmd FileType cpp call s:language_client_bindings()
    " autocmd FileType c call s:language_client_bindings()
    autocmd FileType javascript call s:language_client_bindings()
    autocmd FileType typescript call s:language_client_bindings()
    autocmd FileType java let b:syntastic_skip_checks = 1
    autocmd FileType asm let b:syntastic_skip_checks = 1
augroup END
function s:language_client_bindings() abort
    nnoremap <silent><buffer> K <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent><buffer> gd <cmd>lua vim.lsp.buf.declaration()<CR>
    let b:syntastic_skip_checks = 1
endfunction
" }}}

" Syntastic {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_filetype_map = {}
" }}}

" {{{ Telescope
nnoremap <Leader>p <cmd>lua require'telescope.builtin'.find_files{}<CR>
nnoremap <Leader>f <cmd>lua require'telescope.builtin'.live_grep{}<CR>
augroup deoplete_telescope
    autocmd!
    autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)
augroup END
" }}}

" {{{ sideways
nnoremap <silent> <a-h> <cmd>SidewaysLeft<cr>
nnoremap <silent> <a-l> <cmd>SidewaysRight<cr>
nnoremap <silent> <a-w> <cmd>SidewaysJumpRight<cr>
nnoremap <silent> <a-b> <cmd>SidewaysJumpLeft<cr>
" }}}

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
set completeopt-=preview
" }}}
