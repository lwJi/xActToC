(* ::Package:: *)

(* test.wl
   (c) Liwei Ji, 05/2022
*)


(* << ../xActToC.wl *)
currentDir=If[$InputFileName=="",NotebookDirectory[],DirectoryName[$InputFileName]];
Needs["xAct`xTras`", FileNameJoin[{ParentDirectory[currentDir], "xActToC.wl"}]];

(* ====================== *)
(* Set manifold and chart *)
(* ====================== *)
(* $dim = 3 *)
SetManifoldAndChart[3, cartesian];

(* more setup (not needed in most common cases) *)
DefMetric[1, euclid[-i, -j], CD];
MetricInBasis[euclid, -cartesian, DiagonalMatrix[{1, 1, 1}]];
MetricInBasis[euclid, cartesian, DiagonalMatrix[{1, 1, 1}]];

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
TempVarlist = {
   {vU[i]}
};

(* equations *)
IndexSet[RHSOf[vU][i_], euclid[i,k]MDD[-k,-j]uU[j]];
IndexSet[RHSOf[rU,"Msqr"][i_], euclid[i,k]MDD[-k,-j]vU[j]];
IndexSet[RHSOf[rU,"otherwise"][i_], vU[i]];



(* ============== *)
(* Write to files *)
(* ============== *)
$outputFile = "test.c";
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
  pr["int iMDD = Ind(\"ADM_gxx\");"]
];

$bodyPart[] := Module[{},
  (* set components *)
  Print["Setting components ..."];
  ManipulateVarlist["set components using independent var index",
                    dtEvolVarlist, cartesian, "[[ijk]]"];
  ManipulateVarlist["set components using independent var index",
                    EvolVarlist, cartesian, "[[ijk]]"];
  ManipulateVarlist["set components using independent var index",
                    MoreInputVarlist, cartesian, "[[ijk]]"];
  ManipulateVarlist["set components using independent var index for temporary var",
                    TempVarlist, cartesian, "[[ijk]]"];
  pr[];
  Print["Done"];

  (* print initializations *)
  Print["Printing components ..."];
  ManipulateVarlist["print components initialization: vlr",
                    dtEvolVarlist, cartesian, "[[ijk]]"];
  ManipulateVarlist["print components initialization: vlu",
                    EvolVarlist, cartesian, "[[ijk]]"];
  ManipulateVarlist["print components initialization: more input",
                    MoreInputVarlist, cartesian, "[[ijk]]"];
  ManipulateVarlist["print components equation: temporary",
                    TempVarlist, cartesian, "[[ijk]]"];
  pr[];
  Print["Done"];

  (* print equations *)
  Print["Printing components ..."];
  pr["if(Msqr)"];
  pr["{"];
  ManipulateVarlist["print components equation: primary with suffix",
                    dtEvolVarlist, cartesian, "Msqr"];
  pr["}"];
  pr["else"];
  pr["{"];
  ManipulateVarlist["print components equation: primary with suffix",
                    dtEvolVarlist, cartesian, "otherwise"];
  pr["}"];
  pr[]
  Print["Done"];
]

$endPart[] := Module[{},
   pr["} /* end of points */"];
   pr["} /* end of nodes */"];
   pr["}"]
];

(*<< ../Codes/Nmesh.wl*)
Import[FileNameJoin[{ParentDirectory[currentDir], "Codes/Nmesh.wl"}]]

