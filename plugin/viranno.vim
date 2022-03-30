"
" How to replace selected text T with some function(T), using a keyboard shortcut?
" https://vi.stackexchange.com/questions/34823/how-to-replace-selected-text-t-with-some-functiont-using-a-keyboard-shortcut/34824#34824
"

"
" if not defined, set the leader character to `\`
"
let mapleader="\\"

"
" list of application entity names (labels)
"
let s:labels = [
    \"label1",
    \"label2",
    \"label3"
\]

"
" set keymaps for insert [...](...), 
" - for the current word,
" - for the selcted text
"
" \1 will substitute [...](label1) 
" \2 will substitute [...](label2)
" \3 will substitute [...](label3)
"
for i in range(len(s:labels))
  exe printf("vnoremap <leader>%d :s/\\%%V.*\\%%V./[&](%s)/<cr>n:nohl<cr>f)", i+1, s:labels[i])
  exe printf("nnoremap <leader>%d ciW[<c-o>P](%s)<esc>", i+1, s:labels[i])
endfor
