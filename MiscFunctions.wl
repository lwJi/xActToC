(* ::Package:: *)

(* MiscFunctions.wl
   (c) Liwei Ji, 08/2021
*)


(* return rhs expression based on var *)
RHSOf[var__] := Module[
  { argList = List[var] },

  (* return expression for rhs of var *)
  Switch[Length[argList],
    1, (* var -> var$RHS *)
    ToExpression[ToString[var]<>"$RHS"],
    2, (* var -> var[[1]]$RHS$var[[2]], say for RHSOf[dtPinn,"fromdtK"] -> dtPinn$RHS$fromdtK *)
    ToExpression[ToString[argList[[1]]]<>"$RHS$"<>argList[[2]]],
    _,
    Message[RHSOf::ErrorArgument, Length[argList]]; Abort[]
  ]
];
RHSOf::ErrorArgument = "`1` arguments are not supported yet !";

(* return dtvar based on var, if prefix='dt' *)
PrefixOf[prefix_?StringQ, varlist_?ListQ] := Module[{},
  (* var -> prefixvar for all the var in the varlist *)
  varlist/.Table[varlist[[iVar,1]]->ToExpression[prefix<>ToString[varlist[[iVar,1]]]], {iVar,1,Length[varlist]}]
];

(* print verbose, depend on value of $bool$PrintVerbose *)
PrintVerbose[var__] := Module[{},
  If[$bool$PrintVerbose, Print[var]];
];

(* return bool: check if the abstract index is a 3D index or not:
    4D: a,b,...,h,h1,h2,h... ,
    3D: i,j,...,z,z1,z2,z... .
*)
is3DAbstractIndex[indexAbstract_] := Module[{},
  (* only the first letter matters, say h <=> h1 <=> h2 ... *)
  LetterNumber[StringPart[ToString[indexAbstract/.{-1 x_:>x}],1]] >= LetterNumber["i"]
];

(* return bool: check if the compIndex is a 4D index in 3D tensor (from abstrct index) *)
is4DCompIndexIn3DTensor[indexAbstract_, indexComp_] := Module[{},
  is3DAbstractIndex[indexAbstract] && (indexComp==0)
];

(* return bool: check if the current component of a 3D tensor (from abstract index) contains a 4D component index (0-comp):
    say compIndexList={0,0,2}, varName={i,a,b}
*)
is4DCompIndexListIn3DTensor[compIndexList_, varName_] := Module[
  { is4DcompIndexList = False },

  If[Length[compIndexList]>0,
    Do[
      If[is4DCompIndexIn3DTensor[varName[[compIndex]], compIndexList[[compIndex]]], is4DcompIndexList=True],
    {compIndex,1,Length[compIndexList]}]
  ];

  is4DcompIndexList
];

(* return bool; check if the 0-th component is a up/contravariant index for a 3D tensor:
    we only need to find out those 'up' 0-component, whose 'down' indexes are non-zero.
*)
isUp4DCompIndexListIn3DTensor[compIndexList_, varName_] := Module[
  { isup4DCompIndexList = False },

  (* is there a 0-th up index in the component list *)
  If[Length[compIndexList]>0,
    Do[
      If[UpIndexQ[varName[[compIndex]]] && is4DCompIndexIn3DTensor[varName[[compIndex]], compIndexList[[compIndex]]], isup4DCompIndexList = True],
    {compIndex,1,Length[compIndexList]}]
  ];

  (* if there is also a 0-th down index in the component list, skip this one *)
  If[isup4DCompIndexList,
    Do[
      If[DownIndexQ[varName[[compIndex]]]&&is4DCompIndexIn3DTensor[varName[[compIndex]],compIndexList[[compIndex]]], isup4DCompIndexList = False],
    {compIndex,1,Length[compIndexList]}]
  ];

  isup4DCompIndexList
];

(* check if the index list is on the right place *)
indexType[compIndexList_?ListQ, indextype_] := indextype[compIndexList[[2]]];
indexType3D[compIndexList_?ListQ, indextype_] := indextype[compIndexList[[2]]] && (compIndexList[[1]]>0);

(* get inverses of metric and its determinant *)
Options[SetRHSOfInvMetricAndDet] := {
  coordinate -> $defaultCoordinateName,
  dimension -> 3
};
SetRHSOfInvMetricAndDet[g_, invdetg_, invg_, OptionsPattern[]] := Module[
  {
    coordinateValue = OptionValue[coordinate],
    dimensionValue = OptionValue[dimension],
    iMin,
    iMax = 3,
    Mat,
    invMat
  },

  If[dimensionValue==3, iMin = 1, iMin = 0];

  Mat = Table[(g[{aa,-coordinateValue},{bb,-coordinateValue}]//ToValues), {aa,iMin,iMax}, {bb,iMin,iMax}];
  invMat=(Inverse[Mat]/.{1/Det[Mat]->(invdetg[]//ToValues)});

  DefTensor[RHSOf[invdetg][], $Manifd];
  DefTensor[RHSOf[invg][i,j], $Manifd, Symmetric[{i,j}]];
  ComponentValue[RHSOf[invdetg][], (1/Det[Mat]//Simplify)];
  Do[ComponentValue[RHSOf[invg][{aa,coordinateValue},{bb,coordinateValue}], invMat[[aa,bb]]//Simplify], {aa,iMin,iMax},{bb,aa,iMax}];
  RHSOf[invg][i,j]//ToBasis[coordinateValue]//ComponentArray//ComponentValue;
];

