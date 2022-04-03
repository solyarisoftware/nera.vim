# Nera.vim

Named Entities (Rasa-like) syntax Annotator for vim editor.

**IF YOU LIKE THE PROJECT, PLEASE ⭐️STAR THIS REPOSITORY TO SHOW YOUR SUPPORT! 🙏**


## 🤔 What and Why?

This vim plugin helps to annotate named entities 
(e.g. in [RASA](https://rasa.com/) YAML files) 
using simple entity annotation syntax.


**What the named entity `[entity_value](entity_label)` syntax fomat is?** 

```
[entity_value](entity_label)
 ^             ^
 |             |
 |             entity name (label)
 |
 value (sequence of characters/words) for entity referenced with `entity_label`
```

Where: 

- `entity_value` 

    - is any sequence of characters or words, 
    - delimited by characters `[` and `]`

- `entity_label` 

  - is the entity name (label) 
    is a string of kind "variable name" in a programming language style,
    by example the label is made by alphabet letters and the character `_`
  - the label is delimited by characters `(` e `)`

By example, given the sentence

```
mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
```

You want to annotate entities entity_label = entity_value:
- `person` = `Giorgio Robino`
- `address` = `corso Magenta 35/4 a Genova`


Using above described syntax, the annotated sentence is:
```
mi chiamo [Giorgio Robino](person) ed abito in [corso Magenta 35/4 a Genova](address)
```

**What the plugin does?**

With the vim plugin command `:NeraSet`, 
you can map up to 12 function keys (`F1`,...,`F12`) to a syntax substitution/decoration "macro" 
that add a entity label 
- to a visual selected text,
- or to the current word and a configurable number of adiacent words,
  setting the cursor to the start of the word (entity) you want to tag.


## 👊 Commands syntax

In vim command mode (`:`) these commands are available:

| command                                              | description                  |
| ---                                                  | ---                          |
| :`NeraSet` *functionKey* *label* [*contiguousWords*] | maps the specified *functionKey* to a substitution macro with argument *label*,
  and optional argument *contiguousWords*.
  <br>
  *functionKey* valid values are number `1`...`12` or strings `F1`...`F12`                                         
  <br>
  *label* is the entity name (single word in camelCase or snake_case)                                              
  <br>
  *wordsCounter* is a number of contiguous words to be selected, 
  this is an optional argument (default value is 1)                                   | 
| :`NeraShow`                                          | shows function keys mapping  |


## Usage examples

### Current (single) word annotation

Given the sentence (line):

    mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova

To assign to function key `F1` a substitution for visual mode and single word selection:

- assign a new "macro" substitution to `F1`

      :NeraSet f1 person_name

- put the cursor at the begin of the word you want to annotate: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                ^
                |
                set the vim cursor here

- press `F1`. The line is updated with the entity notation syntax decoration:

      mi chiamo [Giorgio](person_name) Robino ed abito in corso Magenta 35/4 a Genova
    

### Multiple contiguous words annotation

In facts, this is not perfect, because a person name in this case is composed by two consecutive words (*Giorgio Robino*),
you maybe want to preset (another or the same) function key to automatically substitute the current and the successive word.
In this case, set teh mapping with argument `contiguousWords` set to `2`:

- assign a new "macro" substitution to `F2`

      :NeraSet 2 person_name 2

- again put the cursor at the begin of the word you want to annotate: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                ^

- press `F2`. The line is updated and in this case 

      mi chiamo [Giorgio Robino](person_name) ed abito in corso Magenta 35/4 a Genova


### Visual mode annotation

Anyway, even if you do not specify the `words number` argument,
you can proceed withe visual selection mode. So:

- assign a new "macro" substitution to `F3`

      :NeraSet 3 address

- go in vim visual mode (pressing `v`) and select the span you want to annotate: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                                           ^                         ^
                                           |                         |
                                           start visual selection    end visual selection

- press `esc` and `F1`. The line is updated and in this case 

      mi chiamo [Giorgio Robino](person_name) ed abito in [corso Magenta 35/4 a Genova](address)


## 💡 Tips

- Undo labeling

  If you are unhappy with your labelling, just undo in vim as usual, pressing `u` in normal mode!

- Visual mode is always on

  Any time you assign a key with `NeraSet`, 
  you set the word mode for a specified number of contiguous words,
  but you also enable the visual mode! You can optionally 
  - select set the cursor at the start of word and press afterward the function key
  - selct in visual mode a span of words and press afterward the function key

## 📦 Install

Using vim-plug, in your `.vimrc` file:

    Plug 'solyarisoftware/nera.vim'


## ⭐️ Status / How to contribute

This project is work-in-progress.

I'm not a vimscript expert, so any contribute is welcome.

**If you like the project, please ⭐️star this repository to show your support! 🙏**

For any proposal and issue, please submit here on github issues for bugs, suggestions, etc.
You can also contact me via email (giorgio.robino@gmail.com).


## To do

- command `:NeraShow` must rebuilt giving a more clear output
- add a help / online tutorial command
- tune arguments validation
- exoende syntax, managing not only RASA-like style syntax annotation, but also other variants (a la Alexa, DialogFlow, etc.)

## Changelog

- v. 0.3.0
  - `NeraShow` has now a cleaner list of key mappings
  - `NeraSet` now accept the function key argument just pressing the corresponding function key!

## 👏 Acknowledgements

- Thanks you to [biggybi](https://vi.stackexchange.com/users/22375/biggybi) 
  that helped me [here](https://vi.stackexchange.com/a/34824/983), 
  inspiring me to build-up this plugin.


## License

MIT (c) Giorgio Robino


[top](#)
