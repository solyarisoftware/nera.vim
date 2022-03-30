# viranno.vim

*viranno* is an acronym that stay for *VI*m *RA*sa (entities syntax) a*NNO*tator

This vim plugin helps to annotate (RASA YAML) files, using entity annotation syntax:

```
[entity_value](entity_name)
 ^             ^
 |             |
 |             nome (label) dell'entità (slot)
 |
 frase di esempio per l'entità `entity_name`
```

Dove: 

- `entity_value` 

    - è una qualsiasi sequenza di parole e caratteri, 
    - è delimitata dai caratteri `[` e `]`

- `entity_name` 

  - è il nome (label) dell'entità, 
    stringa di tipo "nome variabile" in linguaggio di programmazione,
    ad esempio formata da lettere dell'alfabeto ed il carattere `_`
  - è delimitata dai caratteri `(` e `)`

Esempio:

Si consideri la frase originale 

```
mi chiamo Giorgio Robino ed abito in corso Magenta 35/4 a Genova
```

Si vogliono annotare le entità con entity_name = entity_value
- `person` = `Giorgio Robino`
- `address` = `corso Magenta 35/4 a Genova`


Allora la frase annotata con la sintassi sopradescritta è:
```
mi chiamo [Giorgio Robino](person) ed abito in [corso Magenta 35/4 a Genova](address)
```

