" 
" Nesa.vim
" Named Entities (Rasa-like) Syntax Annotator for Vim editor
" Vim global plugin for annotate named entities with syntax: [entity_value][entity_name]
"
" Maintainer:   
" Giorgio Robino <giorgio.robino@gmail.com>
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

"
" list of contiguous words number,
"
let s:contiguousWords = [
  \'1',
  \'2',
  \'3',
  \'4',
  \'5',
  \'6',
  \'7',
  \'8',
  \'9',
  \'10',
  \'11',
  \'12',
  \'13',
  \'14',
  \'15',
  \'16',
  \'17',
  \'18',
  \'19',
  \'20',
\]

"
" list of labels
"
let s:labels = []


function s:validateLabel(label)

  if index(s:labels, a:label) < 0  
    echo "warning: label '" . a:label . "' is not one of the configured labels: " . join(s:labels, ', ')
  endif

endfunction


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

  " validate function key
  let functionKey = s:validateFunctionKey(a:1)
  
  " validate label
  call s:validateLabel(a:2)

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


function s:labelSet(...)
  " set the list of 'allowed' labels

  if a:0 == 0
    if len(s:labels) > 0
      " labels do already exist?
      echo 'labels: ' . join(s:labels, ', ')
      return
    else
      " labels do not exist?
      echo 'There are no labels. Specify as arguments a space-separated list of <labels>'
      return
    endif
  endif

  " assign global list of labels to the list of arguments
  let s:labels = a:000
  echo len(s:labels) . ' labels: ' . join(s:labels, ', ')
endfunction  


function s:labelsClear(...)
  " clear the list of labels

  let s:labels = [] 
  echo 'label list cleared'

endfunction  


function! s:setCompletion(arg, line, pos)
  " 
  
  " https://dev.to/pbnj/how-to-get-make-target-tab-completion-in-vim-4mj1#solution
  " https://stackoverflow.com/a/6941053/1786393
  let l = split(a:line[:a:pos-1], '\%(\%(\%(^\|[^\\]\)\\\)\@<!\s\)\+', 1)
  let n = len(l) - index(l, 'NeraSet') - 1

  if n == 1
    " first argument = function key
    let completionList = s:functionKeysDelimiters
  elseif n == 2
    " second argument = label
    let completionList = s:labels
  else
    " third argument = contiguous words
    let completionList = s:contiguousWords
  endif

  return filter(copy(l:completionList), 'v:val =~ "^' . a:arg . '"')

endfunction

"
" USER COMMANDS
"
command! -nargs=* -complete=customlist,s:setCompletion NeraSet call s:setFunctionKeyLabel(<f-args>)

command! NeraMapping call s:showFunctionKeysMapping()
command! -nargs=* -complete=file NeraLoad call s:runScript(<f-args>)

command! -nargs=* NeraLabels call s:labelSet(<f-args>)
command! -nargs=* NeraLabelsClear call s:labelsClear(<f-args>)

