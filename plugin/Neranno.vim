" 
" Neranno.vim
"
" Vim global plugin for annotate named entities with syntax: [entity_value][entity_name]
"
" Neranno stay for Named Entities Rasa ANNOtation  
"
" Last Change:  
" 31 March 2022
"
" Maintainer:   
" Giorgio Robino <giorgio.robino@gmail.com>
"
" Gists:
"
" Usage: 
"


function s:showkeys()
  " show function keys mapping, for F1 to F12
  " if function key is not aassigned (mapped), avoiding output for F-keys without mappings
  " https://vi.stackexchange.com/questions/20192/show-mappings-for-all-function-keys

  for i in range(1, 12)
      if !empty(mapcheck('<F'.i.'>'))
          execute 'map <F'.i.'>'
      endif
  endfor
endfunction


function s:setFunctionKeyLabel(...)
  " assign a label to the specified function key 

    " at least 1 argument is required
    if a:0 == 0
        echo 'error: <functionKey> and <label> arguments are not supplied'
        return
    endif

    if a:0 == 1
        echo 'error: <label> argument is not supplied'
        return
      endif 

    if a:0 == 2
        let l:functionKey = a:1
        let l:label = a:2
    endif 
    
    if a:0 > 2
        echo 'error: too many arguments'
        return
    endif 

    let l:functionKey = s:validateFunctionKey(l:functionKey)

    if l:functionKey == 0
      return

    echo 'functionKey: ' . functionKey . ', label: ' . l:label 
endfunction


function s:validateFunctionKey(functionKey)

    if a:functionKey =~# '^\d\+$'

        if a:functionKey >=1 && a:functionKey <=12
            return 'F' . a:functionKey
        else
          echo 'error: function key number must be in range 1-12'
        return

    endif
 
endfunction


"
" USER DEFINED COMMANDS
"
command! Showkeys call s:showkeys()
command! -nargs=* SetFunctionKeyLabel call s:setFunctionKeyLabel(<f-args>)
