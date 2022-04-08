"
" my_project_configs_1.vim
"
" you can add in this file any vim user commands (without the `:` prefix)
"

" 
" Entity names (labels) declaration
"
NeraLabelsClear 
NeraLabels name address company location mail gender age 

"
" Highlight entity label using random colors
"
HighlightText (\zsname\ze)
HighlightText (\zsaddress\ze)
HighlightText (\zscompany\ze)
HighlightText (\zslocation\ze)
HighlightText (\zsmail\ze)
HighlightText (\zsgender\ze)
HighlightText (\zsage\ze)

"
" Highlight entity value using random colors 
"
HighlightText \[\zs[^\[\]]\{-}\ze\](name)
HighlightText \[\zs[^\[\]]\{-}\ze\](address)
HighlightText \[\zs[^\[\]]\{-}\ze\](company)
HighlightText \[\zs[^\[\]]\{-}\ze\](location)
HighlightText \[\zs[^\[\]]\{-}\ze\](mail)
HighlightText \[\zs[^\[\]]\{-}\ze\](gender)
HighlightText \[\zs[^\[\]]\{-}\ze\](age)

"
" Assigning function keys 
"

" F1 - F4
NeraSet <F1>  name 
NeraSet <F2>  address
NeraSet <F3>  company 
NeraSet <F4>  location 

" F5 - F8
NeraSet <F5>  mail 
NeraSet <F6>  gender 
NeraSet <F7>  age

NeraSet <F8>  address 2 

" F9 - F12
NeraSet <F9>  address 3
NeraSet <F10> address 4
NeraSet <F12> address 4 

"
" Show function keys mapping
"
NeraMapping
