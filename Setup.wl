(* ::Package:: *)

(* Setup.wl
   (c) Liwei Ji, 08/2021
*)


(*************)
(* Load xAct *)
(*************)
<< xAct`xTras`

(***********)
(* Options *)
(***********)
(* quite the info message *)
$DefInfoQ = False;
(* automatic commutation of torsionless derivatives on scalar expressions *)
$CommuteCovDsOnScalars = True;
(* switch verbose output on/off for ComponentValue *)
$CVVerbose = False;
(* ScreenDollarIndices: replace internal dummies by new non-dollar dummies for output *)
$PrePrint = ScreenDollarIndices;
(* do not use metric when ToCanonical *)
SetOptions[ToCanonical, UseMetricOnVBundle->None];

(**************************)
(* Turn off error message *)
(**************************)
Off[Part::pkspec1];
(*Off[Part::partd];*)

(**********************)
(* Conventions for GR *)
(**********************)
$ExtrinsicKSign = -1;
$AccelerationSign = -1;


(**************************)
(* Initialize global vars *)
(**************************)
(* dimension *)
$dim = 0;
(* store map between components and varlist indexes *)
$map$ComponentToVarlist = {};
(* flag if creat new varlist *)
$bool$NewVarlist = True;
(* flag if print verbose information *)
$bool$PrintVerbose = False;
(* suffix to be added to vars, which would conflict with system default vars otherwise *)
$suffix$Unprotected = "$Upt";
(* file name and project name *)
$outputFile = "output.c";
$projectName = "TEST";

