# Nera.vim

**N**amed **E**ntities **R**ecognition (Rasa-like syntax) **A**nnotator for the vim editor.


## 🤔 what is it for?

This vim plugin helps to annotate named entities 
using simple entity annotation syntax,
used in [RASA](https://rasa.com/) YAML files and any other compatible engine. 


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
you can map up to 12 function keys (`<F1>`,...,`<F12>`) to a syntax substitution/decoration "macro" 
that add a entity label 
- to a visual selected text,
- or to the current word and a configurable number of adiacent words,
  setting the cursor to the start of the word (entity) you want to tag.


## 👊 Commands

In vim command mode (`:`) these commands are available:

| command                                              | description                  |
| ---                                                  | ---                          |
| :`NeraSet` `functionKey` `label` [`contiguousWords`] | maps the specified `functionKey` to a substitution macro with argument `label`, and optional argument `contiguouswords`.  <br><br>`functionKey` valid values are number `1`...`12` or strings `F1`...`F12`, or `<F1>`,...,`<F12>` key pressing.<br><br>`label` is the entity name (single word in camelCase or snake_case).<br><br>`wordsCounter` is a number of contiguous words to be selected, this is an optional argument (default value is 1).| 

Utilities:
| command                                              | description                  |
| ---                                                  | ---                          |
| :`NeraMap`                                           | shows function keys mapping  |
| :`NeraLoad` `command_script_file`                    | load a script file containing Nera (or any other vim `:` commands |


## Usage

### `NeraSet` for current (single) word annotation

Given the sentence (line):

    mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova

To assign to function key `<F1>` a substitution for visual mode and single word selection:

- assign a new "macro" substitution to `<F1>`

      :NeraSet f1 person_name

- **put the cursor at the begin of the word you want to annotate**: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                ^
                |
                set the vim cursor here

- press `<F1>`. The line is updated with the entity notation syntax decoration:

      mi chiamo [Giorgio](person_name) Robino ed abito in corso Magenta 35/4 a Genova
    

### `NeraSet` for Multiple contiguous words annotation

In facts, this is not what you want, because a full person name is usually composed 
by two consecutive words (*Giorgio Robino*),
so you maybe want to preset (another or the same) function key `<F1>` 
to automatically substitute the current and the successive word.
In this case, set the mapping with argument `contiguousWords` set to `2`:

- assign a new "macro" substitution to `<F2>`

      :NeraSet 2 person_name 2

- again put the cursor at the begin of the word you want to annotate: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                ^

- press `<F2>`. The line is updated and in this case 

      mi chiamo [Giorgio Robino](person_name) ed abito in corso Magenta 35/4 a Genova


### `NeraSet` for visual mode annotation

Anyway, even if you do not specify the `words number` argument,
you can proceed withe visual selection mode. So:

- assign a new "macro" substitution to `<F3>`

      :NeraSet 3 address

- go in vim visual mode (pressing `v`) and select the span you want to annotate: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                                           ^                         ^
                                           |                         |
                                           start visual selection    end visual selection

- press `esc` and `<F3>`. The line is updated and in this case 

      mi chiamo [Giorgio Robino](person_name) ed abito in [corso Magenta 35/4 a Genova](address)


## `NeraLoad` 

Execute all Nera commands previously saved in specified script file.

1. you create your script file `examples/my_project_configs.vim` 
   containing Nera or other vim commands, by example:

   ```
   "
   " my_project_configs.vim
   "

   " F1 - F4
   NeraSet <F1>  name 1
   NeraSet <F2>  address 1 
   NeraSet <F3>  company 1 
   NeraSet <F4>  location 1 

   " F5 - F8
   NeraSet <F5>  email 
   NeraSet <F6>  name 2 
   NeraSet <F7>  name 3
   NeraSet <F8>  address 1 

   " F9 - F12
   NeraSet <F9>  gender
   NeraSet <F10> address 3
   NeraSet <F12> company 2 
   ``` 

2. Afterward you run the script from command mode:

   ```
   :NeraLoad examples/my_project_configs.vim
   ```


## `NeraMap` 

Suppose you run commands:

```
NeraSet <F1>  name 1
NeraSet <F2>  address 1 
NeraSet <F3>  company 1 
NeraSet <F4>  location 1 
NeraSet <F5>  email 
```

Afterwad, you want to show the key mappings:

```
NeraMap
```
```
<F1>  c1w[<C-R><C-O>"](name)<Esc>
<F2>  c1w[<C-R><C-O>"](address)<Esc>
<F3>  c1w[<C-R><C-O>"](company)<Esc>
<F4>  c1w[<C-R><C-O>"](location)<Esc>
<F5>  c1w[<C-R><C-O>"](email)<Esc>
<F6>  
<F6>  
<F7>  
<F8>  
<F9>  
<F10> 
<F11>
<F12> 
Press ENTER or type command to continue
```

## 💡 Tips

- **Undo labeling**

  If you are unhappy with your `NeraSet` labelling, 
  just undo in vim as usual, pressing `u` in normal mode!

- **Visual mode is always on**

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

For any proposal and issue, please submit here on github issues for bugs, suggestions, etc.
You can also contact me via email (giorgio.robino@gmail.com).

**IF YOU LIKE THE PROJECT, PLEASE ⭐️STAR THIS REPOSITORY TO SHOW YOUR SUPPORT! 🙏**

## To do

- add a help / online tutorial command
- tune arguments validation
- extend syntax, managing not only RASA-like style syntax annotation, 
  but also other variants (a la Alexa, DialogFlow, etc.)

## Changelog

- v. 0.4.1
  - `NeraLoad` new command to load script of commands
  - `NeraMap` has now a cleaner list of key mappings
  - `NeraSet` now accept the function key argument just pressing the corresponding function key!

## 👏 Acknowledgements

- Thanks you to [biggybi](https://vi.stackexchange.com/users/22375/biggybi) 
  that helped me [here](https://vi.stackexchange.com/a/34824/983), 
  inspiring me to build-up this plugin.


## License

MIT (c) Giorgio Robino


[top](#)
