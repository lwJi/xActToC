(* ::Package:: *)

(* SetManifoldAndChart.wl
   (c) Liwei Ji, 08/2021 *)


(* Set Mainfold and Chart *)
SetManifoldAndChart[manifold_, dimension_, coordinateName_, coordinateArray_, tensorIndexRange_] := Module[
  {},
  (* set global var *)
  $Dim = dimension;
  (* consider different dimension cases *)
  Switch[$Dim,
    3,
    DefManifold[manifold,$Dim,tensorIndexRange];
    DefChart[coordinateName,manifold,{1,2,3},coordinateArray,ChartColor->RGBColor[0,1,0]],
    4,
    DefManifold[manifold,$Dim,tensorIndexRange];
    DefChart[coordinateName,manifold,{0,1,2,3},coordinateArray,ChartColor->RGBColor[0,0,1]],
    _,
    Message[SetManifoldAndChart::ErrorDim, $Dim]; Abort[]
  ]
];
SetManifoldAndChart::ErrorDim = "Dimension `1` not supported yet !";
