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
    strNameBare = ToUpperCase[StringTrim[ToString[varName[[0]]], $suffix$Unprotected]],
    strName,
    strIndex,
    buf
  },
  strName = StringTrim[ToString[compToValue], ( gridPointIndex | "SYM" | $suffix$Unprotected )];
  strIndex = If[Length[varName]==0, "", ToString[varlistIndex]];

  (* different modes *)
  Which[
    (* print input var initialization *)
    StringMatchQ[mode, "print components initialization: vl_evo using enum"],
    buf="const double * const "<>strName<>" = &uZipVars[VAR::U_"<>strNameBare<>strIndex<>"][offset];",

    (* print more input/output var initialization *)
    StringMatchQ[mode, "print components initialization: more input/output"],
    buf=StringReplace["double *"<>strName<>" = &uZipConVars[VAR_CONSTRAINT::C_"<>strNameBare<>strIndex<>"][offset];", "$"->"_"],

    (* print more input/output var initialization *)
    StringMatchQ[mode, "print components initialization: vl_deriv"],
    buf="double * "<>strName<>" = &uZipConVars[VAR_CONSTRAINT::C_"<>strNameBare<>strIndex<>"][offset];",

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
