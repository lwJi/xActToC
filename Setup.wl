(* ::Package:: *)

(* Setup.wl
   (c) Liwei Ji, 08/2021
*)


(*************)
(* Load xAct *)
(*************)
<< xAct`xCoba`
(* << xAct`xTras` *)

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
(* dimension and default coordinate name, which will be set in SetManifoldAndChart *)
$dim = 0;
$defaultCoordinateName = Null;
(* store map between components and varlist indexes *)
$map$ComponentToVarlist = {};
(* suffix to be added to vars, which would conflict with system default vars otherwise *)
$suffix$Unprotected = "$Upt";
(* prefix to be added to evo vars to represent var dtevo *)
$prefix$Dt = "";
(* flag if creat new varlist, which are updated in ManipulateVarlist *)
$bool$NewVarlist = True;
(* more bool parameters *)
$bool$PrintVerbose = False;
$bool$SimplifyEquation = True;
(* suffix name, for if statement in the equations, which should be update by user through ManipulateVarlist *)
$suffixName = "";
(* grid point index name, which should also be update by user directory or through ManipulateVarlist *)
$gridPointIndex = "";

(* file name and project name *)
$outputFile = "output.c";
$projectName = "TEST";

