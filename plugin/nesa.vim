" 
" Nesa.vim
" Named Entities (Rasa-like) Syntax Annotator for Vim editor
" Vim global plugin for annotate named entities with syntax: [entity_value][entity_name]
"
" Last Change:  
" 01 April 2022
"
" Maintainer:   
" Giorgio Robino <giorgio.robino@gmail.com>
"
" Gists:
"
" Usage: 
"


let s:functionKeys = [
  \'F1',
  \'F2',
  \'F3',
  \'F4',
  \'F5',
  \'F6',
  \'F7',
  \'F8',
  \'F9',
  \'F10',
  \'F11',
  \'F12'
\]


function s:validateFunctionKey(functionKey)
  " checks if functionKey is a number between 1 and 12
  " checks if functionKey is 'Fx', case insensitive, where x is a number between 1 and 12
  " return string 'Fx' or v:null

  " argument is a number?
  if a:functionKey =~# '^\d\+$'

    let l:functionKey = str2nr(a:functionKey)

    if l:functionKey >=1 && l:functionKey <=12
      return 'F' . l:functionKey
    else
      echo 'error: function key number must be in range 1-12'
      return v:null
    endif

  " argument is a string?
  else

    let l:functionKey = toupper(a:functionKey)

    if index(s:functionKeys, l:functionKey) >= 0  
      " item is in the list.
      return l:functionKey
    else
      echo 'error: function key must be in range F1-F12'
      return v:null
    endif

  endif

endfunction


function s:showFunctionKeysMapping()
  " show function keys mapping, for F1 to F12
  " if function key is not assigned (mapped), avoiding output for F-keys without mappings
  " https://vi.stackexchange.com/questions/20192/show-mappings-for-all-function-keys

  for i in range(1, 12)
    if !empty(mapcheck('<F'.i.'>'))
        execute 'map <F'.i.'>'
    endif
  endfor

endfunction


function s:mapFunctionKeyLabelAnnotation(functionKey, label, wordsNumber)
  " couples to a specified function key:
  " - a normal mode macro (to a specified label) 
  " - and a visual mode macro (to a specified label) 
  
  "
  " VIM VISUAL MODE SELECTION
  "
  "     sentence:
  "     "bla bla bla named entity composed by multiple words blabla bla"
  "
  "     selection in visual mode:
  "                 "named entity composed by six words"           
  "                 ^      ^      ^        ^  ^   ^
  "                 |      |      |        |  |   |
  "                 word1  word2  word3    word4  word6
  "                                           |
  "                                           word5
  "     substitution:
  "     "bla bla bla [named entity composed by multiple words](label) blabla bla"
  "
  "
  exe printf("vnoremap <%s> :s/\\%%V.*\\%%V./[&](%s)/<cr>n:nohl<cr>f)", a:functionKey, a:label)

  "
  " WORD COUNT MODE SELECTION
  "

  " select the current word (cursor must position must be put at the start
  " character of the word

  " https://stackoverflow.com/questions/2147875/what-vim-commands-can-be-used-to-quote-unquote-words
  exe printf('nnoremap <%s> c%dw[<C-r><C-o>"](%s)<esc>', a:functionKey, a:wordsNumber, a:label)

endfunction


function s:setFunctionKeyLabel(...)
  " assign a label to the specified function key 

  " at least 1 argument is required
  if a:0 == 0
      echo 'error: arguments <functionKey>, <label>, [<words>] are not supplied'
      return
  endif

  if a:0 == 1
      echo 'error: arguments <label>, [<words>] are not supplied'
      return
    endif 

  if a:0 == 2
      let label = a:2
      let wordsNumber = 1
  endif 

  if a:0 == 3
      let label = a:2
      let wordsNumber = a:3
  endif 
    
  if a:0 > 3
      echo 'error: too many arguments'
      return
  endif 

  let functionKey = s:validateFunctionKey(a:1)
  " TODO validate label
  " TODO validate wordsNumber

  if functionKey == v:null
    return
  endif

  echo 'functionKey: ' . functionKey . ', label: ' . label  . ', words number: ' . wordsNumber

  call s:mapFunctionKeyLabelAnnotation(functionKey, label, wordsNumber)

endfunction


"
" USER COMMANDS
"
command! NesaShowFunctionKeys call s:showFunctionKeysMapping()
command! -nargs=* NesaSetFunctionKeyLabel call s:setFunctionKeyLabel(<f-args>)
