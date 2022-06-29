# Generate C files with 'xActToC'

* Install free Wolfram Engine for Devolopers from https://www.wolfram.com/developer/. (If you are rich, you can install totally worth it Mathhematia instead, versions which support 'wolframscript'). Download xAct from http://www.xact.es and install it properly.

* Prepare ".wl" files for your own project in the corresponding directory (please check out those ''.wl" files in the examples).

* Run the following command to generate the corresponing C files.

```bash
xActToC/GenerateC.sh *.wl
```

* Or you can also generate C files one by one using command

```bash
wolframscript -f file.wl

# then remove the trailing spaces in all these files
xActToC/RemoveTrailingSpaces.sh *.c
```

## Prepare `.wl` files for your own codes

### Recipe for your own codes and projects

1. Add a module specific to your **codes** into directory `Codes`. (Please see `Codes\Nmesh.wl` as an example.)

2. Add a `.wl` file specific to your **projects** consistent with the above module (please see `example/test.wl` as an example):

### Options for `mode`

* Set components for each tensor (`SetComponents[mode, ...]`)

    * `mode = "temporary"`: set components for each temporary tensor (say $g^{11}$=`gUU11`)

    * `mode = "independent"`: set components for each grid functions (say $g_{11}$=`gDD11[ijk]`); varlist index start from 0 for each tensor

* Print to C-file

    * `PrintInitializations[mode, ...]`: set up pointers to each component (say $g_{11}$ or `gDD11`) of tensors in the memory, it should be defined by user in the module under directory `Codes`, here we use `Nmesh` as an example

        * `mode = "vlr"`: say, set up pointer to $\dot{g}_{11}$ or `dtgDD11`

        * `mode = "vlr independent"`: using independent varlist index

        * `mode = "vlu"`: say, set up pointer to $g_{11}$ or `gDD11`

        * `mode = "vlu independent"`: using independent varlist index

        * `mode = "more input/output"`: more grid functions in the rhs of the equations (other than evolution variables), say, set up pointer to $\partial_2g_{11}$ or `dgDDD211`

    * `PrintEquations[mode, ...]`

        * `mode = "temporary"`: say, $g_{11}$=... 

        * `mode = "primary"`: say, $\dot{g}_{11}$=...

        * `mode = "primary with suffix"`: say, $\dot{\Pi}_{\mathbf{nn}}^{\text{fromdtK}}$, where `suffix` is `fromdtK`. It is needed if the equation has `if` statement 

        * `mode = "adding to primary"`: say, $\dot{\Pi}_{11}=\dot{\Pi}_{11}+...$ , or `dtPiDD11 += ...`, adding contribution from matter part

## Tricks

Opening ".wl" files with Mathematica is recommended. Because you can benefit from the 'auto-completing' and other useful features of it. When you are debugging, it can also provide some useful debug tools.


## Abbreviation dictionary

| Original    | Abbreviation |
| ----------- | ------------ |
| Component   | Comp         |
| Evolution   | Evol         |
| Expression  | Expr         |
| Unprotected | Upt          |


<!---
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
p
--->
