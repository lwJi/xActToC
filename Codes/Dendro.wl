(* ::Package:: *)

(* Dendro.wl
   (c) Liwei Ji, 08/2021
     Set up functions adpated to Dendro code
*)


(* =============== *)
(* Definition Part *)
(* =============== *)

(* print components initialization *)
PrintComponentInitialization[mode_, varName_, compName_, gridPointIndex_] := Module[
  {
    varlistIndex = $map$ComponentToVarlist[[Position[$map$ComponentToVarlist, compName][[1,1]], 2]],
    compToValue = compName//ToValues,
    buf
  },

  (* different modes *)
  Which[
    (* print output var initialization *)
    StringMatchQ[mode, "print components initialization: vl_lhs using vl_index"],
    buf="double *"<>StringTrim[ToString[compToValue], gridPointIndex]<>" = Vard(node, Vind(vlr,"<>ToString[varlistIndex]<>"));",

    (* print input var initialization *)
    StringMatchQ[mode, "print components initialization: vl_evo using enum"],
    buf="const double * const "<>StringTrim[ToString[compToValue], gridPointIndex]<>" = Vard(node, Vind(vlu,"<>ToString[varlistIndex]<>"));",

    (* print output var initialization using var indepedent index*)
    StringMatchQ[mode, "print components initialization: vl_lhs"],
    buf="double *"<>StringTrim[ToString[compToValue], gridPointIndex]<>" = Vard(node, Vind(vlr,"<>ToString[$projectName]<>"->i_"
      <>StringTrim[ToString[varName[[0]]], ( $prefix$Dt | $suffix$Unprotected )]
      <>getInitialComp[varName]<>If[varlistIndex==0, "", "+"<>ToString[varlistIndex]]<>"));",

    (* print input var initialization using var independent index*)
    StringMatchQ[mode, "print components initialization: vl_evo"],
    buf="double *"<>StringTrim[ToString[compToValue], gridPointIndex]<>" = Vard(node, Vind(vlu,"<>ToString[$projectName]<>"->i_"
      <>StringTrim[ToString[varName[[0]]], $suffix$Unprotected]
      <>getInitialComp[varName]<>If[varlistIndex==0, "", "+"<>ToString[varlistIndex]]<>"));",

    (* print more input var initialization *)
    StringMatchQ[mode, "print components initialization: more input/output"],
    buf="double *"<>StringTrim[ToString[compToValue], gridPointIndex]<>" = Vard(node, i"
      <>StringTrim[ToString[varName[[0]]], $suffix$Unprotected]
      <>getInitialComp[varName]<>If[varlistIndex==0, "", "+"<>ToString[varlistIndex]]<>");",

    (* mode undefined *)
    True,
    Message[PrintComponentInitialization::ErrorMode, mode]; Abort[]
  ];
  pr[buf];
];
PrintComponentInitialization::ErrorMode = "Print component mode `1` unsupported yet !";

(* return the initial component expression of a tensor *)
getInitialComp[varName_] := Module[
  {
    initialComp = ""
  },
  Do[
    If[is3DAbstractIndex[varName[[compIndex]]], initialComp = initialComp<>"x", initialComp = initialComp<>"t"],
  {compIndex,1,Length[varName]}];
  initialComp
];


(* ============== *)
(* Write to files *)
(* ============== *)

Print[];
Print["============================================================"];
Print[" Writing to ", $outputFile];
Print["============================================================"];
If[FileExistsQ[$outputFile], Print[$outputFile, " already exist, replacing it ..."];DeleteFile[$outputFile]];
Print[];

(* define pr *)
filePointer = OpenAppend[$outputFile];
pr[x_:""] := Module[{},
  If[x=="double ", WriteString[filePointer,x], WriteLine[filePointer,x]]
];

(* print first few lines *)
pr["/* "<>$outputFile<>" */"];
pr["/* (c) Liwei Ji "<>DateString[{"Month","/","Day","/","Year"}]<>" */"];
pr["/* Produced with Mathematica */"];
pr[];

$headPart[];
$bodyPart[];
$endPart[];

Print["Done generating ", $outputFile, "\n"];
Close[filePointer];
