(* ::Package:: *)

(* Wrapper.wl
   (c) Liwei Ji, 06/2022
*)

(* set components *)
Options[SetComponent] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
SetComponent[mode_?StringQ, varlist_?ListQ, OptionsPattern[]] := Module[
  {
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName],
    fullString = "set components: "<>mode
  },
  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];

(* print initializations *)
Options[PrintInitialization] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
PrintInitialization[mode_?StringQ, varlist_?ListQ, OptionsPattern[]] := Module[
  {
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName],
    fullString = "print components initialization: "<>mode
  },
  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];

(* print equations *)
Options[PrintEquation] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
PrintEquation[mode_?StringQ, varlist_?ListQ, OptionsPattern[]] := Module[
  {
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName],
    fullString = "print components equation: "<>mode
  },
  ManipulateVarlist[fullString, varlist, {coordinate->coordinateValue, gridPointIndex->gridPointIndexValue, suffixName->suffixNameValue}];
];
