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

## Prepare `.wl` files for your own codes

### Recipe for your own codes and projects

1. Add a module specific to your **codes** into directory `Codes`. (Please see `Codes\Nmesh.wl` as an example.)


2. Add a `.wl` file specific to your **projects** consistent with the above module (please see `example/test.wl` as an example):

### Options for `mode` in function `ManipulateVarlist[mode, varlist]`

* `"set components*"`: set components for each tensor which are grid point functions (say $g_{11}=\text{gDD11[ijk]}$)

    * `set components: for temporary varlist`: set components for each temporary tensor (say $g^{11}=\text{gUU11}$)

    * `set components: independent varlist index`: varlist index start from 0 for each tensor

* `print components*`: print to C-file

    * `print components initialization*`: set up pointers to each component (say $\text{gDD11}$) of tensors in the memory. It should be defined by user in the module under directory `Codes`, here we use `Nmesh` as an example

        * `print components initializatoin: vlr`: say, set up pointer to $\dot{g_{11}}$ or $\text{dtgDD11}$

        * `print components initializatoin: vlr using vlpush_index`: using independent varlist index

        * `print components initializatoin: vlu`: say, set up pointer to ${g_{11}}$ or $\text{gDD11}$

        * `print components initializatoin: vlu using vlpush_index`: using independent varlist index

        * `print components initializatoin: more input`: more grid functions in the rhs of the equations (other than evolution variables), say, set up pointer to $\partial_2g_{11}$ or $\text{dgDDD211}$

    * `print components equation*`

        * `print components equation: temporary`: say, $g^{11} = ...$ 

        * `print components equation: primary`: say, $\dot{g}_{11} = ...$

        * `print components equation: primary with suffix`: say, $\dot{\Pi}_{\mathbf{nn}}^{\text{fromdtK}}=...$, where `suffix` is $\text{fromdtK}$. Needed if the equation has `if` statement 

        * `print components equation: adding to primary`: say, $\dot{\Pi}_{11} =  \dot{\Pi}_{11} + ...$ , or $\text{dtPiDD11 += ...}$, adding contribution from matter part

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
p
