(* ::Package:: *)

(* Dendro.wl
   (c) Liwei Ji, 08/2021
     Set up functions adpated to Dendro code
*)


(* =============== *)
(* Definition Part *)
(* =============== *)

(* More global pars *)
$derivIndex = 0;

(* cnd num -> letter *)
cndNumToLetter = {"1"->"x","2"->"y","3"->"z"};
cndLetterToNum = {"x"->"1","y"->"2","z"->"3"};

(* print components initialization *)
PrintComponentInitialization[mode_, varName_, compName_, gridPointIndex_] := Module[
  {
    varlistIndex = $map$ComponentToVarlist[[Position[$map$ComponentToVarlist, compName][[1,1]], 2]],
    compToValue = compName//ToValues,
    strNameBare = ToUpperCase[StringTrim[ToString[varName[[0]]], $suffix$Unprotected]],
    strName,
    strIndex,
    strDerivIndices,
    strDerivBases,
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
    buf=StringReplace["double * "<>strName<>" = deriv_base + "<>ToString[$derivIndex]<>" * BLK_SZ;", "$"->"_"];
    $derivIndex = $derivIndex+1,

    StringMatchQ[mode, "print components initialization: vl_deriv_calc"],
    {strDerivIndices, strDerivBases} = getStrDerivNames[compName];
    If[StringLength[strDerivIndices]==2 && StringTake[strDerivIndices,1]!=StringTake[strDerivIndices,-1],
      buf=StringReplace["deriv_"<>StringTake[strDerivIndices,1]<>"("<>strName<>", "<>"d_"<>strDerivBases<>StringReplace[StringTake[strDerivIndices,-1],cndLetterToNum]<>", "
        <>"h"<>StringTake[strDerivIndices,1]<>", sz, bflag);", "$"->"_"],
      buf=StringReplace["deriv_"<>strDerivIndices<>"("<>strName<>", "<>strDerivBases<>", "
        <>"h"<>StringTake[strDerivIndices,1]<>", sz, bflag);", "$"->"_"]
    ],

    (* mode undefined *)
    True,
    Message[PrintComponentInitialization::ErrorMode, mode]; Abort[]
  ];
  pr[buf];
];
PrintComponentInitialization::ErrorMode = "Print component mode `1` unsupported yet !";

(* return the deriv index *)
getStrDerivNames[compName_] := Module[
  {
    strDerivType = StringSplit[ToString[compName[[0]]], "$"][[1]],
    strDerivBases = StringSplit[ToString[compName[[0]]], "$"][[2]],
    strDerivIndices = ""
  },
  strDerivIndices = strDerivIndices <> StringReplace[StringTake[getStrCompIndices[compName], -StringLength[strDerivType]], cndNumToLetter];
  strDerivBases = strDerivBases <> StringTake[getStrCompIndices[compName], Length[compName] - StringLength[strDerivType]];
  {strDerivIndices, strDerivBases}
];

(* return the compont index *)
getStrCompIndices[compName_] := Module[
  {
    strCompIndices = ""
  },
  Do[
    strCompIndices = strCompIndices<>ToString[compName[[compIndex]][[1]]],
  {compIndex,1,Length[compName]}];
  strCompIndices
];

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
