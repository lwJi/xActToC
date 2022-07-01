(* ::Package:: *)

(* SetManifoldAndChart.wl
   (c) Liwei Ji, 08/2021
*)


(* set mainfold and chart:
    if need non-default value for coordinateArray/tensorIndexRange, please try SetManifoldAndChart[dimension_, coordinateName_, {coordinateArray->..., tensorIndexRange->...}];
    defaut index conventions: in the 4D case, we use
      a,b,c,...,h,h1,h2,...,h9 as abstract index for 4D tensor;
      i,j,k,...,z,z1,z2,...,z9 as abstract index for 3D tensor;
      (and we skip 'g' and save it for metric var.)
*)
Options[SetManifoldAndChart] := {
  coordinateArray -> {},
  tensorIndexRange -> Union[Complement[IndexRange[a,z], {g}], Table[ToExpression["h"<>ToString[i]], {i,1,9}], Table[ToExpression["z"<>ToString[i]], {i,1,9}]]
};
SetManifoldAndChart[dimension_?IntegerQ, coordinateName_, gridPointIndex_, OptionsPattern[]] := Module[
  {
    coordinateArrayValue = OptionValue[coordinateArray],
    tensorIndexRangeValue = OptionValue[tensorIndexRange]
  },

  (* set global var *)
  $dim = dimension;
  $defaultCoordinateName = coordinateName;
  $gridPointIndex = gridPointIndex;

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
