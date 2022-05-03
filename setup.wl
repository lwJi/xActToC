(* ::Package:: *)

(* setup.wl
    (c) Liwei Ji, 08/2021 *)

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
$Map$ComponentToVarlist = {};
$Bool$NewVarlist = True;
