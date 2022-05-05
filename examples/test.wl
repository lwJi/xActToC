(* ::Package:: *)

(* test.wl
   (c) Liwei Ji, 05/2022
*)


<< ../xActToC.wl

(* ====================== *)
(* Set manifold and chart *)
(* ====================== *)
(* $dim = 4 *)
SetManifoldAndChart[4, cartesian];

(* more setup (not needed in most common cases) *)
DefMetric[1, euclid[-i, -j], CD];
MetricInBasis[euclid, -cartes, DiagonalMatrix[{1, 1, 1}]];
MetricInBasis[euclid, cartes, DiagonalMatrix[{1, 1, 1}]];

(*############################################################################
   Guess what we are doing:
    r^i = M^i_j M^j_k u^k     if ADM_ConstraintNorm = Msqr
    r^i = M^i_j u^j           otherwise
  ############################################################################*)

(* ================================ *)
(* Variable and equation defintions *)
(* ================================ *)
(* varible list *)
dtEvolVarlist = {
   {rU[i]}
};
EvolVarlist = {
   {uU[i]}
};
MoreInputVarlist = {
   {MDD[-i,-j],Symmetric[{-i,-j}]}
};
AuxVarlist = {
   {vU[i]}
}

(* equations *)
IndexSet[RHSOf[vU][i_], euclid[i,k]MDD[-k,-j]uU[j]];
IndexSet[RHSOf[rU,"Msqr"][i_], euclid[i,k]MDD[-k,-j]vU[j]];
IndexSet[RHSOf[rU,"otherwise"][i_], vU[i]];



(* ============== *)
(* Write to files *)
(* ============== *)
$outputFile = "test.c";

<< ../Codes/Nmesh.wl

