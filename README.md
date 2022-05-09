# Generate C files with 'xActToC'

* Install Mathematica (versions which support 'wolframscript') . Download xAct from http://www.xact.es and install it properly.

* Prepare ".wl" files for your own project in the corresponding directory (please check out those ''.wl" files in the examples).

* Run with

```shell
xActToC-2.0/GenerateC.sh *.wl
```
to generate the corresponing C files.

* Or you can also generate C files one by one using command

```shell
wolframscript -f file.wl
```

then run

```shell
xActToC-2.0/RemoveTrailingSpaces.sh *.c
```

to remove the trailing spaces in all these files.

## Prepare `.wl` Files for Your Own Codes

### Recipe for your own Codes and Projects

1. Add a module specific to your **codes** into directory `Codes`. (Please see `Codes\Nmesh.wl` as an example.)


2. Add a `.wl` file specific to your **projects** consistent with the above module (please see `example/test.wl` as an example):

### Options for `mode` in function `ManipulateVarlist[mode, varlist]`

* `"set components*"`: set components for each tensor (say `metricg[{1,-coordinate},{1,-coordinate}] = gDD11[[ijk]]`)

    * `set components: for temporary varlist`: (say `metricg[{1,-coordinate},{1,-coordinate}] = gDD11`)

    * `set components: independent varlist index`: varlist index start from 0 for each tensor

* `print components*`: print to C file

    * `print components initialization*`, which should be define by user, here we use `Nmesh` as an example

        * `print components initializatoin: vlr`

        * `print components initializatoin: vlr using vlpush_index`

        * `print components initializatoin: vlu`

        * `print components initializatoin: vlu using vlpush_index`

        * `print components initializatoin: more input`

    * `print components equation*`

        * `print components equation: temporary`

        * `print components equation: primary`

        * `print components equation: primary with suffix`

        * `print components equation: adding to primary`

        * `print components equation: primary for flux`

## Tricks

Opening ".wl" files with Mathematica is recommended. Because you can benefit from the 'auto-completing' and other useful features of it. When you are debugging, it can also provide some useful debug tools.


## Abbreviation dictionary

| Original    | Abbreviation |
| ----------- | ------------ |
| Component   | Comp         |
| Evolution   | Evol         |
| Expression  | Expr         |
| Unprotected | Upt          |


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
