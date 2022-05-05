(* ::Package:: *)

(* MiscFunctions.wl
   (c) Liwei Ji, 08/2021
*)


(***************************)
(* Define global functions *)
(***************************)
(* get rhs expression based on var *)
RHSOf[var__] := Module[
  {
    argList = List[var]
  },
  (* return expression for rhs of var *)
  Switch[Length[argList],
    1, (* var -> var$rhs *)
    ToExpression[ToString[var]<>"$RHS"],
    2, (* var -> var[[1]]$rhs$[[2]] *)
    ToExpression[ToString[argList[[1]]]<>"$RHS$"<>argList[[2]]],
    _,
    Message[RHSOf::ErrorArgument, Length[argList]]; Abort[]
  ]
];
RHSOf::ErrorArgument = "`1` arguments are not supported yet !";

(* print which depend on value of $Bool$PrintVerbose *)
PrintVerbose[var__] := Module[
  {},
  If[$Bool$PrintVerbose, Print[var]]
];

(* check if the current component is the 4D component (0-comp) of a 3D tensor (abstract index) *)
is4DCompIndexIn3DTensor[compIndexList_, varName_] := Module[
  {
    is4DcompIndex = False
  },
  If[Length[compIndexList]>0,
    Do[
      If[is3DAbstractIndex[varName[[compIndex]]]&&(compIndexList[[compIndex]]==0), is4DcompIndex=True],
    {compIndex,1,Length[compIndexList]}]
  ];
  is4DcompIndex
];

(* check if the abstract index is a 3D index or not:
    4D: a,b,...,h,h1,h2,h... ,
    3D: i,j,...,z,z1,z2,z... .
*)
is3DAbstractIndex[indexAbstract_] := Module[
  {},
  LetterNumber[StringPart[ToString[indexAbstract/.{-1 x_:>x}],1]] >= LetterNumber["i"] (* only the first letter matters, say h <=> h1 <=> h2 ... *)
];

(* check if the 0-th component is a up/contravariant index:
   we only need to find out those 'up' 0-component, whose 'down' indexes
   are non-zero.
*)
isUp0thCompIndex[compIndexList_,varName_] := Module[
  {
    isup0thComp = False
  },
  (* is there a 0-th up index in the component list *)
  If[Length[compIndexList]>0,
    Do[
      If[UpIndexQ[varName[[compIndex]]]&&is3DAbstractIndex[varName[[compIndex]]]&&(compIndexList[[compIndex]]==0), isup0thComp = True],
    {compIndex,1,Length[compIndexList]}]
  ];
  (* if there is also a 0-th down index in the component list, skip this one *)
  If[isup0thComp,
    Do[
      If[DownIndexQ[varName[[compIndex]]]&&is3DAbstractIndex[varName[[compIndex]]]&&(compIndexList[[compIndex]]==0), isup0thComp = False],
    {compIndex,1,Length[compIndexList]}]
  ];
  isup0thComp
];

