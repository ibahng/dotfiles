" Options
set relativenumber=true
set number=true
set shiftwidth=2               " make the tab 2 spaces
set breakindent                " wrapped lines maintain same indent as first line
set scrolloff=20               " keep lines above/below cursor

" User feedback / Obsidian commands
nnoremap <Space>r :obcommand app:reload<CR>

" Basic normal-mode remaps
inoremap jk <Esc>
nnoremap k gk
nnoremap j gj
vnoremap q <Esc>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Navigation & Sidebar mappings
" nnoremap <leader>h :lasttab<CR>
" nnoremap <leader>l :nexttab<CR>
nnoremap <Space>bq :q<CR>
nnoremap <Space>e :sidebar left<CR>
nnoremap <Space>a :sidebar right<CR>

exmap tabnext obcommand workspace:next-tab
nnoremap <Space>h :tabnext<CR>
exmap tabprev obcommand workspace:previous-tab
nnoremap <Space>l :tabprev<CR>
