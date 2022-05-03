# Generate C files with 'xActToC'

* Install Mathematica (versions which support 'wolframscript') . Download xAct from http://www.xact.es and install it properly.

* Prepare ".wl" files for your own project in the corresponding directory (please check out those ''.wl" files in 'C3GH' as examples).

* Run

```shell
../xActToc/generateC.sh *.wl
```
to generate the corresponing C files.

* You can also generate C files one by one using command

```shell
wolframscript -f file.wl
```

then run

```shell
../xActToC/removetrailingspaces.sh *.c
```

to remove the trailing spaces in all these files.


## Tricks

Opening ".wl" files with Mathematica is recommended. Because you can benefit from the 'auto-completing' and other useful features of it. When you are debugging, it can also provide some useful debug tools.


## Abbreviation dictionary

| Original    | Abbreviation |
| ----------- | ------------ |
| Component   | CPNT         |
| Index       | IDX          |
| Evolution   | EVOL         |
| Expression  | EXPR         |
| Tensor      | TSR          |
| Unprotected | UNPROT       |


## Name Conventions

* lower CamelCase

* make naming depend on symbol names

    * use verbs for symbols used as functions, nouns for symbols used as variables,

    * use `numberArray[[x]]` for lists,

    * use of mathematica like `xxxQ` functions vs. `isXxx` as used in many other languages.

    * use a leading `$` to indicate use of a global variable.

    * all uppercase names for constant

    * all single letter symbol names or not (no)

    * checkout https://mathematica.stackexchange.com/questions/72669/mathematica-style-guide
