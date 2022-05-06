(* ::Package:: *)

(* Nmesh.wl
   (c) Liwei Ji, 08/2021
     Set up functions adpated to Nmesh code
*)


(* =============== *)
(* Definition Part *)
(* =============== *)


(* ============== *)
(* Write to files *)
(* ============== *)
Print["============================================================"];
Print[" Writing to ", $outputFile];
Print["============================================================"];
If[FileExistsQ[$outputFile], DeleteFile[$outputFile]];
filePointer = OpenAppend[$outputFile];
(* define pr *)
pr[x_:""] := Module[{}, WriteLine[filePointer, x]];
(* print first lines *)
pr["/* "<>$outputFile<>" */"];
pr["/* (c) Liwei Ji "<>DateString[{"Month","/","Day","/","Year"}]<>" */"];
pr["/* Produced with Mathematica */"];
pr[];

$headPart[];

$bodyPart[];

$endPart[];

Close[filePointer];
