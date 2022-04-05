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


"
" list of function keys, as string representation
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


"
" list of function keys, as vim string representation of the key pressed
"
let s:functionKeysDelimiters = [
  \'<F1>',
  \'<F2>',
  \'<F3>',
  \'<F4>',
  \'<F5>',
  \'<F6>',
  \'<F7>',
  \'<F8>',
  \'<F9>',
  \'<F10>',
  \'<F11>',
  \'<F12>'
\]


function s:validateFunctionKey(functionKey)
  " checks if functionKey is a number between 1 and 12
  " checks if functionKey is 'Fx', case insensitive, where x is a number between 1 and 12
  " return string 'Fx' or v:null

  " argument is a number?
  if a:functionKey =~# '^\d\+$'

    let l:functionKey = str2nr(a:functionKey)

    if l:functionKey >=1 && l:functionKey <=12
      return '<F' . l:functionKey . '>'
    else
      echo 'error: function key number must be in range 1-12'
      return v:null
    endif

  " argument is a string?
  else

    let l:functionKey = toupper(a:functionKey)

    if index(s:functionKeys, l:functionKey) >= 0  
      " item is in the list.
      return '<' . l:functionKey . '>'
    
    elseif index(s:functionKeysDelimiters, l:functionKey) >= 0
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

    let functionKeyMap = mapcheck('<F'.i.'>')

    if !empty(functionKeyMap)
      " execute 'map <F'.i.'>'
      if i < 10
        echo '<F'.i.'>  ' . functionKeyMap
      else
        echo '<F'.i.'> ' . functionKeyMap
      endif
    else
      echo '<F'.i.'>'
    endif
  endfor

endfunction


function s:mapFunctionKeyLabelAnnotation(functionKey, label, contiguousWords)
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
  "                  ^     ^      ^        ^  ^   ^
  "                  |     |      |        |  |   |
  "                  word1 word2  word3    word4  word6
  "                                           |
  "                                           word5
  "     substitution:
  "     "bla bla bla [named entity composed by multiple words](label) blabla bla"
  "
  "
  exe printf("vnoremap %s :s/\\%%V.*\\%%V./[&](%s)/<cr>n:nohl<cr>f)", a:functionKey, a:label)

  "
  " WORD COUNT MODE SELECTION
  "

  " select the current word (cursor must position must be put at the start
  " character of the word

  " https://stackoverflow.com/questions/2147875/what-vim-commands-can-be-used-to-quote-unquote-words
  exe printf('nnoremap %s c%dw[<C-r><C-o>"](%s)<esc>', a:functionKey, a:contiguousWords, a:label)

endfunction


function s:setFunctionKeyLabel(...)
  " assign a label to the specified function key 

  " at least 1 argument is required
  if a:0 == 0
      echo 'error: arguments <functionKey>, <label>, [<contiguous_words>] are not supplied'
      return
  endif

  if a:0 == 1
      echo 'error: arguments <label>, [<contiguous_words>] are not supplied'
      return
    endif 

  if a:0 == 2
      let label = a:2
      let contiguousWords = 1
  endif 

  if a:0 == 3
      let label = a:2
      let contiguousWords = a:3
  endif 
    
  if a:0 > 3
      echo 'error: too many arguments'
      return
  endif 

  let functionKey = s:validateFunctionKey(a:1)
  " TODO validate label
  " TODO validate contiguousWords

  if functionKey == v:null
    return
  endif

  echo 'functionKey: ' . functionKey . ', label: ' . label  . ', contiguous words: ' . contiguousWords

  call s:mapFunctionKeyLabelAnnotation(functionKey, label, contiguousWords)

endfunction


function s:runScript(...)
  " load list of commands from a file and execute (run) these

  if a:0 == 0
      echo 'error: <script_filename> argument must be specified'
      return
  endif

  if a:0 > 1
      echo 'error: too many arguments'
      return
  endif 

  let filename = a:1

  if !filereadable(filename)
    echo 'error: not found script file: ' . filename
    return
  endif

  for line in readfile(filename)
    " silent! execute line
    execute line
  endfor  

 echo ''
 echo 'executed script file: ' . filename

endfunction  


"
" USER COMMANDS
"
command! NeraMapping call s:showFunctionKeysMapping()
command! -nargs=* NeraSet call s:setFunctionKeyLabel(<f-args>)
command! -nargs=* -complete=file NeraLoad call s:runScript(<f-args>)
