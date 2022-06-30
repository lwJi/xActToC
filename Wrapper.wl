(* ::Package:: *)

(* Wrapper.wl
   (c) Liwei Ji, 06/2022
*)

(* set components *)
Options[SetComponents] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
SetComponents[mode_?StringQ, varlist_?ListQ, OptionsPattern[]] := Module[
  {
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName],
    fullString = "set components: "<>mode
  },

  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];

(* print initializations *)
Options[PrintInitializations] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
PrintInitializations[mode_?StringQ, varlist_?ListQ, OptionsPattern[]] := Module[
  {
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName],
    fullString = "print components initialization: "<>mode
  },

  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];

(* print equations *)
Options[PrintEquations] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
PrintEquations[mode_?StringQ, varlist_?ListQ, OptionsPattern[]] := Module[
  {
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName],
    fullString = "print components equation: "<>mode
  },

  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];
