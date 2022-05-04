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
PrintVerbose[var__] := Module[{},
  If[$Bool$PrintVerbose, Print[var]]
];

