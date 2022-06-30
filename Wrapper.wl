(* ::Package:: *)

(* Wrapper.wl
   (c) Liwei Ji, 06/2022
*)

(* set components: mode can be
    1. "independent" (default), using independent index for each var;
    2. "using vl_index", using index in varlist;
    3. "temporary", for temporary vars, no '[ijk]' attached, using index in varlist;
*)
Options[SetComponents] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
SetComponents[varlist_?ListQ, mode_:"independent", OptionsPattern[]] := Module[
  {
    fullString = "set components: "<>mode,
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName]
  },

  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];

(* print initializations: mode can be
    1. "vl_evo using vl_index";
    2. "vl_lhs using vl_index";
    3. "vl_evo", using independent index for each var;
    4. "vl_lhs", using independent index for each var;
    5. "more input/output";
*)
Options[PrintInitializations] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
PrintInitializations[varlist_?ListQ, mode_?StringQ, OptionsPattern[]] := Module[
  {
    fullString = "print components initialization: "<>mode,
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName]
  },

  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];

(* print equations: mode can be
    1. "temporary";
    2. "primary";
    3. "primary with suffix";
    4. "adding to primary";
    5. "primary for flux";
*)
Options[PrintEquations] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
PrintEquations[varlist_?ListQ, mode_?StringQ, OptionsPattern[]] := Module[
  {
    fullString = "print components equation: "<>mode,
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName]
  },

  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];
