(* ::Package:: *)

(* SetManifoldAndChart.wl
   (c) Liwei Ji, 08/2021
*)


(* defaut index conventions: in the 4D case, we use
     a,b,c,...,h,h1,h2,...,h9 as abstract index for 4D tensor,
     i,j,k,...,z,z1,z2,...,z9 as abstract index for 3D tensor.
*)
Options[SetManifoldAndChart] := {
  coordinateArray -> {},
  tensorIndexRange -> Union[IndexRange[a,z], Table[ToExpression["h"<>ToString[i]],{i,1,9}], Table[ToExpression["z"<>ToString[i]],{i,1,9}]]
};
(* Set Mainfold and Chart:
     if need non-default value for coordinateArray/tensorIndexRange, please try
     SetManifoldAndChart[dimension_, coordinateName_, {coordinateArray->..., tensorIndexRange->...}];
*)
SetManifoldAndChart[dimension_, coordinateName_, OptionsPattern[]] := Module[
  {
    coordinateArrayValue = OptionValue[coordinateArray],
    tensorIndexRangeValue = OptionValue[tensorIndexRange]
  },
  (* set global var *)
  $dim = dimension;
  $defaultCoordinateName = coordinateName;
  (* consider different dimension cases *)
  Switch[$dim,
    3,
    If[Length[coordinateArrayValue]==0, coordinateArrayValue = {X[],Y[],Z[]}];
    DefManifold[$Manifd, $dim, tensorIndexRangeValue];
    DefChart[$defaultCoordinateName, $Manifd, {1,2,3}, coordinateArrayValue, ChartColor->RGBColor[0,1,0]],
    4,
    If[Length[coordinateArrayValue]==0, coordinateArrayValue = {T[],X[],Y[],Z[]}];
    DefManifold[$Manifd, $dim, tensorIndexRangeValue];
    DefChart[$defaultCoordinateName, $Manifd, {0,1,2,3}, coordinateArrayValue, ChartColor->RGBColor[0,0,1]],
    _,
    Message[SetManifoldAndChart::ErrorDim, $dim]; Abort[]
  ];
];
SetManifoldAndChart::ErrorDim = "Dimension `1` not supported yet !";
