# nesa.vim

Named Entities (Rasa-like) Syntax Annotator for Vim editor.

**If you like the project, please ⭐️star this repository to show your support! 🙏**

This vim plugin helps to annotate named entities (e.g. in RASA YAML files) 
using entity annotation syntax:

**What's the named entity []() syntax** 

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

Example:

Given the sentence

```
mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
```

You want to annotate entities entity_label = entity_value:
- `person` = `Giorgio Robino`
- `address` = `corso Magenta 35/4 a Genova`


So the annotated sentence, using above described syntax, is:
```
mi chiamo [Giorgio Robino](person) ed abito in [corso Magenta 35/4 a Genova](address)
```

**What the plugin does**


## Install

Using vim-plug, in your `.vimrc` file:

    Plug 'solyarisoftware/nesa.vim'


## Usage

In vim command mode (`:`) these commands are available:

| command                                                          | description                                                                     |
| ---                                                              | ---                                                                             |
| `:NesaSetFunctionKeyLabel` `functionKey` `label` [`wordsNumber`] | maps the specified `functionKey` to a substitution macro with argument `label`, 
                                                                                       and optional argument `wordsNumber`                           |
| `:NesaShowFunctionKeys`                                          | shows function keys mapping                                                     |

Examples:

### Current (single) word annotation

Given the sentence (line):

    mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova

To assign to function key `F1` a substitution for visual mode and single word selection:

- map F1

      :NesaSetFunctionKeyLabel f1 person_name

- put the cursor at the begin of the word you want to annotate: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                ^
                |
                set the vim cursor here

- press `F1`. The line is updated with the entity notation syntax decoration:

      mi chiamo [Giorgio](person_name) Robino ed abito in corso Magenta 35/4 a Genova
    

### Multiple close words annotation

In facts, this is not perfect, because a person name in this case is composed by two consecutive words (*Giorgio Robino*),
you maybe want to preset (another or the same) function key to automatically substitute the current and the successive word.
In this case, set teh mapping with argument `wordsNumber` set to `2`:

- map F2

      :NesaSetFunctionKeyLabel 2 person_name 2

- again put the cursor at the begin of the word you want to annotate: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                ^

- press `F2`. The line is updated and in this case 

      mi chiamo [Giorgio Robino](person_name) ed abito in corso Magenta 35/4 a Genova


### Visual mode annotation

Anyway, even if you do not specify the `words number` argument,
you can proceed withe visual selection mode. So:

- map F3
3
      :NesaSetFunctionKeyLabel 3 address

- go in vim visual mode (pressing `v`) and select the span you want to annotate: 

      mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
                                           ^                         ^
                                           |                         |
                                           start visual selection    end visual selection

- press `esc` and `F1`. The line is updated and in this case 

      mi chiamo [Giorgio Robino](person_name) ed abito in [corso Magenta 35/4 a Genova](address)


## Status / How to contribute

This project is work-in-progress.

I'm not a vimscript expert, so any contribute is welcome.

**If you like the project, please ⭐️star this repository to show your support! 🙏**

For any proposal and issue, please submit here on github issues for bugs, suggestions, etc.
You can also contact me via email (giorgio.robino@gmail.com).


## To do

- command :NesaShowFunctionKeys must rebuilt giving a more clear output
- add a help / online tutorial command
- tune arguments validation
- exoende syntax, managing not only RASA-like style syntax annotation, but also other variants (a la Alexa, DialogFlow, etc.)


## Acknowledgements

- Thanks you to [biggybi](https://vi.stackexchange.com/users/22375/biggybi) 
  that helped me [here](https://vi.stackexchange.com/a/34824/983), 
  inspiring me to build-up this plugin.


## License

MIT (c) Giorgio Robino


[top](#)
