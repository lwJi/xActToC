(* ::Package:: *)

(* test.wl
   (c) Liwei Ji, 05/2022
*)


(* ========== *)
(* Load files *)
(* ========== *)
(* << ../xActToC.wl *)
$currentFileName = If[$InputFileName=="", NotebookFileName[], $InputFileName];
$currentDir = DirectoryName[$currentFileName];
Needs["xAct`xTras`", FileNameJoin[{ParentDirectory[$currentDir],"xActToC.wl"}]];


(* ====================== *)
(* Set manifold and chart *)
(* ====================== *)
(* $dim = 3, grid point index = "[[ijk]]" *)
SetManifoldAndChart[3, cartesian, "[[ijk]]"];

(* more setup (not needed in most common cases) *)
DefMetric[1, euclid[-i, -j], CD];
MetricInBasis[euclid, -cartesian, DiagonalMatrix[{1, 1, 1}]];
MetricInBasis[euclid, cartesian, DiagonalMatrix[{1, 1, 1}]];


(* ================================ *)
(* Variable and equation defintions *)
(* ================================ *)

(*############################################################################
   Guess what we are doing:
    r^i = M^i_j M^j_k u^k     if ADM_ConstraintNorm = Msqr
    r^i = M^i_j u^j           otherwise
  ############################################################################*)

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
TempVarlist = {
   {vU[i]}
};

(* equations *)
IndexSet[RHSOf[vU][i_], euclid[i,k]MDD[-k,-j]uU[j]];
IndexSet[RHSOf[rU,"Msqr"][i_], euclid[i,k]MDD[-k,-j]vU[j]];
IndexSet[RHSOf[rU,"otherwise"][i_], vU[i]];

(* set components *)
Print[];
Print[" Setting components ..."];
Print[];
ManipulateVarlist["set components: independent varlist index", dtEvolVarlist];
ManipulateVarlist["set components: independent varlist index", EvolVarlist];
ManipulateVarlist["set components: independent varlist index", MoreInputVarlist];
ManipulateVarlist["set components: for temporary varlist", TempVarlist];

(* ============== *)
(* Write to files *)
(* ============== *)
$outputFile = FileBaseName[FileNameTake[$currentFileName]]<>".c";
$projectName = "C3GH";

$headPart[] := Module[{},
  pr["#include \"nmesh.h\""];
  pr["#include \""<>$projectName<>".h\""];
  pr[];
  pr["#define Power(x,y) (pow((double) (x),(double) (y)))"];
  pr["#define Log(x) log((double) (x))"];
  pr["#define pow2(x) ((x)*(x))"];
  pr["#define pow2inv(x) (1.0/((x)*(x)))"];
  pr["#define Cal(x,y,z) ((x)?(y):(z))"];
  pr["#define Sqrt(x) sqrt(x)"];
  pr["#define Abs(x) fabs(x)"];
  pr[];
  pr[];
  pr["/* use globals from "<>$projectName<>" */"];
  pr["extern t"<>$projectName<>" "<>$projectName<>"[1];"];
  pr[];
  pr[];
  pr["void test(tVarList *vlu, tVarList *vlr)"];
  pr["{"];
  pr["tMesh *mesh = u->mesh;"];
  pr[];
  pr["int Msqr = GetvLax(Par(\"ADM_ConstraintNorm\"), \"Msqr \");"];
  pr[];
  pr["formylnodes(mesh)"];
  pr["{"];
  pr["tNode *node = MyLnode;"];
  pr["int ijk;"];
  pr[];
  pr["forpoints(node, ijk)"];
  pr["{"];
  pr["int iMDD = Ind(\"ADM_gxx\");"];
  pr[];
];

$bodyPart[] := Module[{},
  (* print initializations *)
  Print[" Printing components initialization ..."];
  ManipulateVarlist["print components initialization: vlr", dtEvolVarlist];
  ManipulateVarlist["print components initialization: vlu", EvolVarlist];
  ManipulateVarlist["print components initialization: more input", MoreInputVarlist];
  ManipulateVarlist["print components equation: temporary", TempVarlist];
  pr[];
  (* print equations *)
  Print[" Printing components equation ...\n"];
  pr["if(Msqr)"];
  pr["{"];
  ManipulateVarlist["print components equation: primary with suffix", dtEvolVarlist, {coordinate->cartesian, gridPointIndex->"[[ijk]]", suffixName->"Msqr"}];
  (*ManipulateVarlist["print components equation: primary with suffix", dtEvolVarlist, suffixName->"Msqr"];*)
  pr["}"];
  pr["else"];
  pr["{"];
  ManipulateVarlist["print components equation: primary with suffix", dtEvolVarlist, suffixName->"otherwise"];
  pr["}"];
  pr[];
];

$endPart[] := Module[{},
   pr["} /* end of points */"];
   pr["} /* end of nodes */"];
   pr["}"];
];

(* << ../Codes/Nmesh.wl *)
Import[FileNameJoin[{ParentDirectory[$currentDir], "Codes/Nmesh.wl"}]];

