(* ::Package:: *)

(* SetManifoldAndChart.wl
   (c) Liwei Ji, 08/2021 *)


(* Set Mainfold and Chart *)
SetManifoldAndChart[manifold_, dimension_, coordinateName_, coordinateArray_, tensorIndexRange_] := Module[
  {},
  Switch[dimension,
    3,
    DefManifold[manifold,dimension,tensorIndexRange];
    DefChart[coordinateName,manifold,{1,2,3},coordinateArray,ChartColor->RGBColor[0,1,0]],
    4,
    DefManifold[manifold,dimension,tensorIndexRange];
    DefChart[coordinateName,manifold,{0,1,2,3},coordinateArray,ChartColor->RGBColor[0,0,1]],
    _,
    Message[SetManifoldAndChart::ErrorDim, dimension];False
  ]
];
SetManifoldAndChart::ErrorDim = "Dimension `1` not supported yet !!!";
