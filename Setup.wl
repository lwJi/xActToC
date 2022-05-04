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
(* ScreenDollarIndices: replace internal dummies by new non-dollar
    dummies for output *)
$PrePrint = ScreenDollarIndices;
(* do not use metric when ToCanonical *)
SetOptions[ToCanonical, UseMetricOnVBundle->None];

(**************************)
(* Turn off error message *)
(**************************)
Off[Part::pkspec1];
(*Off[Part::partd];*)

(***************)
(* Conventions *)
(***************)
$ExtrinsicKSign = -1;
$AccelerationSign = -1;

(**************************)
(* Initialize global vars *)
(**************************)
(* dimension *)
$Dim = 0;

(* store map between components and varlist indexes *)
$Map$ComponentToVarlist = {};

(* flag if creat new varlist *)
$Bool$NewVarlist = True;
(* flag if print verbose information *)
$Bool$PrintVerbose = False;

(* suffix to be added to vars, which would conflict with system default vars otherwise *)
$Suffix$Unprotected = "$Upt";

