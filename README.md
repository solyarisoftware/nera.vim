# Nera.vim

**N**amed **E**ntities **R**ecognition (Rasa-like syntax) **A**nnotator for the vim editor.


## 🤔 what is it for?

This vim plugin helps to annotate named entities 
using simple entity annotation syntax, using inline-text mark-up tags,
following the format used in [RASA](https://rasa.com/docs/rasa/training-data-format/) YAML files. 

The final goal is to possibly demonstrate how fast is annotate with a text editor (specifically vim) a text file 
of intents + entities examples of a training set. 


**What the named entity `[entity_value](entity_label)` syntax format is?** 

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
my name is Giorgio Robino and I live in Genova, corso Magenta 35/4
```

You want to annotate three entities (entity_label = entity_value):
- `person` = `Giorgio Robino`
- `city` = `Genova`
- `address` = `corso Magenta 35/4`


Using above described syntax, the annotated sentence is:
```
my name is [Giorgio Robino](person) and I live in [Genova](city), [corso Magenta 35/4](address)
```

**What the plugin does?**

With the vim plugin command `:NeraSet`, 
you can map up to 12 function keys (`<F1>`,...,`<F12>`) to a syntax substitution/decoration "macro" 
that add a entity label 
- to a visual selected text,
- or to the current word and a configurable number of adjacent words,
  setting the cursor to the start of the word (entity) you want to tag.


## 👊 Commands

In vim command mode (`:`) these commands are available:

| command                                              | description                  |
| ---                                                  | ---                          |
| `:NeraSet` *functionKey* *label* [*contiguousWords*] | maps the specified *functionKey* to a substitution macro with argument *label*, and optional argument *contiguousWords*.  <br><br>*functionKey* valid values are number `1` ... `12` or strings `F1` ... `F12`, or `<F1>` ... `<F12>` key pressing.<br><br>*label* is the entity name (single word in camelCase or snake_case).<br><br>*contiguousWords* is a number of contiguous words to be selected, this is an optional argument (default value is 1).| 

Utilities:
| command                                              | description                  |
| ---                                                  | ---                          |
| `:NeraMapping`                                       | shows function keys mapping  |
| `:NeraLoad` *command_script_file*                      | load and execute a script file containing Nera commands or any other vim `:` commands |
| `:NeraLabels` *label ... [label]*                      | Set a list of labels, to be used afterward with `NeraSet` |
| `:NeraLabelsClear`                                   | Clear the list of preset labels, to be used afterward with `NeraSet` |


## Usage

### `:NeraSet` for current (single) word annotation

Given the sentence (line):

    my name is Giorgio Robino and I live in Genova, corso Magenta 35/4

To assign to function key `<F1>` a substitution for visual mode and single word selection:

- assign a new "macro" substitution to `<F1>`

      :NeraSet f1 person_name

- **put the cursor at the begin of the word you want to annotate**: 

      my name is Giorgio Robino  nd I live in Genova, corso Magenta 35/4
                 ^
                 |
                 set the vim cursor here

- press `<F1>`. The line is updated with the entity notation syntax decoration:

      my name is [Giorgio](person_name) Robino and I live in Genova, corso Magenta 35/4


### `:NeraSet` for Multiple contiguous words annotation

Maybe the example above is not what you exactly want, because a full person name is usually composed 
by two consecutive words (*Giorgio Robino*),
so you maybe want to preset (another or the same) function key `<F1>` 
to automatically substitute the current and the successive word.
In this case, set the mapping with argument `contiguousWords` set to `2`:

- assign a new "macro" substitution to `<F2>`

      :NeraSet F2 person_name 2

- again put the cursor at the begin of the word you want to annotate: 

      my name is Giorgio Robino and I live in Genova, corso Magenta 35/4
                 ^
                 |
                 set the vim cursor here

- press `<F2>`. The line is updated and in this case 

      my name is [Giorgio Robino](person_name) and I live in Genova, corso Magenta 35/4


### `:NeraSet` for visual mode annotation

Anyway, even if you do not specify the `words number` argument,
you can proceed withe visual selection mode. So:

- assign a new "macro" substitution to `<F3>`

      :NeraSet <F3> address

- go in vim visual mode (pressing `v`) and select the span you want to annotate: 

      my name is Giorgio Robino and I live in Genova, corso Magenta 35/4
                                              ^                        ^
                                              |                        |
                                              start visual selection   end visual selection

- press `esc` and `<F3>`. The line is updated and in this case 

      my name is [Giorgio Robino](person_name) and I live in [Genova, corso Magenta 35/4](address)


### `:NeraLabels` `:NeraLabelsClear`

You want to prepare a precise (short) list of labels 
you will use afterward to annotate with `NeraSet`:

    :NeraLabels name surname address city age gender 

This list act as the reference list, to validate `NeraSet` label argument.
By example, 

```
NeraSet <F4> job
```
generates a warning message, because you are setting a label not previously declared:
```
warning: label 'job' is not one of the configured labels: name surname address city age gender
functionKey: <F4>, label: job, contiguous words: 1
Press ENTER or type command to continue
```

### `:NeraLoad` 

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


### `:NeraMapping` 

Suppose you run commands:

```
:NeraSet <F1>  name 1
:NeraSet <F2>  address 1 
:NeraSet <F3>  company 1 
:NeraSet <F4>  location 1 
:NeraSet <F5>  email 
```

Afterward, you want to show the key mappings:

```
:NeraMapping
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

- Commands arguments auto completion

  When using command `NeraSet` you can use arguments auto completion (function key, labels, etc.).
  When using command `NeraLoad` you can exploit file name argument auto completion

- **Undo labeling**

  If you are unhappy with your `NeraSet` labeling, 
  just undo in vim as usual, pressing `u` in normal mode!

- **Visual mode is always on**

  Any time you assign a key with `NeraSet`, 
  you set the word mode for a specified number of contiguous words,
  but you also enable the visual mode! You can optionally 
  - select set the cursor at the start of word and press afterward the function key
  - select in visual mode a span of words and press afterward the function key


## 📦 Install

Using vim-plug, in your `.vimrc` file:

    Plug 'solyarisoftware/nera.vim'


## Data Examples and live demo

Some files available in [examples](examples/) directory of this repo.

| [![](https://img.youtube.com/vi/dgU9US4t_4U/0.jpg)](https://www.youtube.com/watch?v=dgU9US4t_4U&feature=youtu.be)|
|:--:|
| Live demo |


## ⭐️ Status / How to contribute

This project is a work-in-progress proof-of-concept.

I'm not a vimscript expert, so any coding contribute is welcome.

For any proposal and issue, please submit here on github issues for bugs, suggestions, etc.
You can also contact me via email (giorgio.robino@gmail.com).

I'm especially interested in any markup-based entity syntax formats alternative/different from RASA. Please let me know. 
Do not esitate to open a 'change request' issue.

**IF YOU LIKE THE PROJECT, PLEASE ⭐️STAR THIS REPOSITORY TO SHOW YOUR SUPPORT! 🙏**


## To do

- add a help / online tutorial command
- improve arguments validation
- extend syntax, managing not only RASA-like style syntax annotation, 
  but also other different systems' syntax:
  - [MindMeld Labeled Queries Files](https://www.mindmeld.com/docs/quickstart/06_generate_representative_training_data.html)
  - [Microsoft Bot Framework Language Model Files with Machine Learning Entities](https://learn.microsoft.com/en-us/azure/bot-service/file-format/bot-builder-lu-file-format?view=azure-bot-service-4.0#machine-learned-entity)
 - [Amazon Alexa Interaction Model](https://developer.amazon.com/en-US/docs/alexa/custom-skills/create-intents-utterances-and-slots.html)

## Changelog

- v. 0.5.0
  - new commands `NeraLabels` and `NeraLabelsClear`
  - `NeraSet` arguments auto-completion

- v. 0.4.1
  - `NeraLoad` new command to load script of commands
  - `NeraMapping` has now a cleaner list of key mappings
  - `NeraSet` now accept the function key argument just pressing the corresponding function key!


## 👏 Acknowledgements

- Thanks you to [biggybi](https://vi.stackexchange.com/users/22375/biggybi) 
  that helped me [here](https://vi.stackexchange.com/a/34824/983), 
  inspiring me to build-up this plugin.


## 🤝 Related Project

- I made another plugin possibly complementary: 
  [Highlight.vim](https://github.com/solyarisoftware/Highlight.vim)
  to colorize pattern of texts, with a random or specified background colors.
  A Possible usage is to highlight entity names and entity labels as show
  here: [highlight entities having RASA-YAML entity annotation syntax](https://github.com/solyarisoftware/Highlight.vim/tree/master/screenshots#example-4-highlight-entities-having-syntax-entity_value)


## License

MIT (c) Giorgio Robino


[top](#)
