(* ::Package:: *)

(* Nmesh.wl
   (c) Liwei Ji, 08/2021
     Set up functions adpated to Nmesh code
*)


(* =============== *)
(* Definition Part *)
(* =============== *)

(* set file pointer 'pr'; print 'include' and 'define' *)
includeanddefine[functionname_?StringQ,author_?StringQ,file_,pr_]:=
Module[{filepointer,project},
  project = StringSplit[functionname,"_"][[1]];
  filepointer = OpenAppend[file];
  pr[x_]:=Module[{},WriteString[filepointer,x]];
  pr["/* "<>functionname<>".c */\n"];
  pr["/* (c) "<>author<>" "<>DateString[{"Month","/","Day","/","Year"}]
    <>" */\n"];
  pr["/* Produced with Mathematica */\n"];
  pr["\n"];
  pr["#include \"nmesh.h\"\n"];
  pr["#include \""<>project<>".h\"\n"];
  pr["\n"];
  pr["#define Power(x,y) (pow((double) (x),(double) (y)))\n"];
  pr["#define Log(x) log((double) (x))\n"];
  pr["#define pow2(x) ((x)*(x))\n"];
  pr["#define pow2inv(x) (1.0/((x)*(x)))\n"];
  pr["#define Cal(x,y,z) ((x)?(y):(z))\n"];
  pr["#define Sqrt(x) sqrt(x)\n"];
  pr["#define Abs(x) fabs(x)\n"];
  pr["\n\n"];
  pr["/* use globals from "<>project<>" */\n"];
  pr["extern t"<>project<>" "<>project<>"[1];\n"];
  pr["\n\n\n\n"]
];


(* ============== *)
(* Write to files *)
(* ============== *)
Print["Writing to ", $outputFile, "\n"];
If[FileExistQ[$outputFile], DeleteFile[$outputFile]];
filePointer = OpenAppend[$outputFile];
pr[x_] := Module[{}, WriteString[filePointer, x]];

Close[filePointer];
