(* ::Package:: *)

(* ManipulateVarlist.wl
   (c) Liwei Ji, 08/2021
*)


(* main function which handle different num of index cases *)
ManipulateVarlist[mode_?StringQ, varlist_, coordinate_, gridPointIndex_?StringQ] := Module[
  {
    compIndexList,
    iMin, iMax = 3,
    var, varName
  },
  (* default parameters *)
  If[$Dim==3, iMin = 1, iMin = 0];
  (* initialize $Bool$NewVarlist *)
  $Bool$NewVarlist = True;

  (* loop over varlist in the list *)
  Do[
    var = varlist[[iVar]];   (* say { metricg[-a,-b], Symmetric[{-a,-b}], "g" } *)
    varName = var[[1]];      (* say metricg[-a,-b] *)
    varLength = Length[var]; (* var length: how many descriptions for var *)

    (* check if tensor defined yet *)

    (* consider different types of tensor *)
    Switch[Length[varName],
      (* ---------------- *)
      (* ZERO INDEX CASE: *)
      (* ---------------- *)
      0,
      Module[{},
        compIndexList = {};
        ManipulateComponent[compIndexList, mode, coordinate, varName, gridPointIndex]
      ],

      (* --------------- *)
      (* ONE INDEX CASE: *)
      (* --------------- *)
      1,
      Module[{},
        Do[
          compIndexList = {idx$a};
          ManipulateComponent[compIndexList, mode, coordinate, varName, gridPointIndex],
        {idx$a,iMin,iMax}]
      ],

(*
      (* ----------------- *)
      (* TWO INDEXES CASE: *)
      (* ----------------- *)
      2,
      If[(varLength==3)||
         (varLength==2&&(!StringQ[var[[2]]])),
        (* WITH SYMMETRY *)
        Module[{},
          Switch[var[[2]][[0]],
            Symmetric,
            Do[compIndexList={idx$a,idx$b};
              ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
              {idx$a,iMin,iMax},{idx$b,idx$a,iMax}],
            Antisymmetric,
            Do[compIndexList={idx$a,idx$b};
              ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
              {idx$a,iMin,iMax},{idx$b,idx$a+1,iMax}],
            _,(* symmetry undefined *)
            printerror[iVar,varName]
          ];
          varName//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* WITHOUT SYMMETRY *)
        Do[compIndexList={idx$a,idx$b};
          ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
          {idx$a,iMin,iMax},{idx$b,iMin,iMax}]
      ],

      (* ------------------ *)
      (* THREE INDEXES CASE *)
      (* ------------------ *)
      3,
      If[(varLength==3)||
         (varLength==2&&(!StringQ[var[[2]]])),
        (* WITH SYMMETRY *)
        Module[{varlist$idxsymm=var[[2]][[1]]},
          Which[
            (* c(ab) or c[ab] *)
            (varlist$idxsymm[[1]]===varName[[2]])&&
            (varlist$idxsymm[[2]]===varName[[3]]),
            Switch[var[[2]][[0]],
              Symmetric,
              Do[compIndexList={idx$c,idx$a,idx$b};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{idx$a,iMin,iMax},
                {idx$b,idx$a,iMax}],
              Antisymmetric,
              Do[compIndexList={idx$c,idx$a,idx$b};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{idx$a,iMin,iMax},
                {idx$b,idx$a+1,iMax}],
              _,(* symmetry undefined *)
              printerror[iVar,varName]
            ],
            (* (ab)c or [ab]c *)
            (varlist$idxsymm[[1]]===varName[[1]])&&
            (varlist$idxsymm[[2]]===varName[[2]]),
            Switch[var[[2]][[0]],
              Symmetric,
              Do[compIndexList={idx$a,idx$b,idx$c};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$a,iMin,iMax},{idx$b,idx$a,iMax},
                {idx$c,iMin,iMax}],
              Antisymmetric,
              Do[compIndexList={idx$a,idx$b,idx$c};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$a,iMin,iMax},{idx$b,idx$a+1,iMax},
                {idx$c,iMin,iMax}],
              _,(* symmetry undefined *)
              printerror[iVar,varName]
            ],
            (* other three indexes cases *)
            True,
            printerror[iVar,varName]
          ];
          varName//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* WITHOUT SYMMETRY *)
        Do[compIndexList={idx$c,idx$a,idx$b};
          ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
          {idx$c,iMin,iMax},{idx$a,iMin,iMax},
          {idx$b,iMin,iMax}]
      ],

      (* ----------------- *)
      (* FOUR INDEXES CASE *)
      (* ----------------- *)
      4,
      If[(varLength==3)||
         (varLength==2&&(!StringQ[var[[2]]])),
        (* WITH SYMMETRY *)
        Module[{varlist$idxsymm=var[[2]][[1]]},
          Which[
            (* cd(ab) or cd[ab] *)
            (varlist$idxsymm[[1]]===varName[[3]])&&
            (varlist$idxsymm[[2]]===varName[[4]]),
            Switch[var[[2]][[0]],
              Symmetric,
              Do[compIndexList={idx$c,idx$d,idx$a,idx$b};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{idx$d,iMin,iMax},
                {idx$a,iMin,iMax},{idx$b,idx$a,iMax}],
              Antisymmetric,
              Do[compIndexList={idx$c,idx$d,idx$a,idx$b};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{idx$d,iMin,iMax},
                {idx$a,iMin,iMax},{idx$b,idx$a+1,iMax}],
              _,(* symmetry undefined *)
              printerror[iVar,varName]
            ],
            (* (cd)(ab) or ... *)
            var[[2]][[0]]==GenSet,
            Which[
              (var[[2]][[1]]==Cycles[{1,2}])&&
              (var[[2]][[2]]==Cycles[{3,4}]),
              Do[compIndexList={idx$c,idx$d,idx$a,idx$b};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{idx$d,idx$c,iMax},
                {idx$a,iMin,iMax},{idx$b,idx$a,iMax}],
              True,
              printerror[iVar,varName]
            ],
            (* other four indexes cases *)
            True,
            printerror[iVar,varName]
          ];
          varName//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* WITHOUT SYMMETRY *)
        Do[compIndexList={idx$c,idx$d,idx$a,idx$b};
          ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
          {idx$c,iMin,iMax},{idx$d,iMin,iMax},
          {idx$a,iMin,iMax},{idx$b,iMin,iMax}]
      ],
*)

      (* -------------------- *)
      (* OTHER NUM OF INDEXES *)
      (* -------------------- *)
      _,
      Message[ManipulateVarlist::ErrorTensorType, ivar, varName, varlist]; Abort[]
    ], (* end of Switch*)
  {iVar, 1, Length[varlist]}] (* end of Do *)
];
ManipulateVarlist::ErrorTensorType = "Tensor type of the `1`-th var (`2`) in varlist `3` unsupported yet !";

(* Maniputlate each component of a tensor:
     1. set tensor components,
     2. print tensor components or equations
*)
ManipulateComponent[compIndexList_, mode_, coordinate_, varName_, gridPointIndex_] := Module[
  {
    compName, (* component expr in Mathematica kernal *)
    rhssName, (* rhs component expr in Mathematica kernal *)
    exprName  (* component expr to be printed to C code, or lhs *)
  },
  (* set names *)
  {compName,rhssName,exprName} = SetNameArray[compIndexList, coordinate, varName, gridPointIndex];
  (*
  (* find out 4D component of a 3D tensor, which should be skipped *)
  If[check$4Dcpntidxin3Dtensor[compIndexList,varName],
    (* set those 'up' 0-th component to 0 for a 3D tensor *)
    If[check$up0thcpnt[compIndexList,varName],ComponentValue[compName,0]];
    Continue[]
  ];
  *)
  (* set components or print components/equations *)
  If[StringMatchQ[mode, "set components*"],
    SetComponentAndIndexMap[mode, compName, exprName],
    If[StringMatchQ[mode, "print components*"],
      (*PrintComponent[mode,coordinate,varName,compName,rhssName,gridPointIndex],*)
      Print["PrintComponent"],
      Message[ManipulateComponent::ErrorMode, mode]; Abort[]
    ]
  ]
];
ManipulateComponent::ErrorMode = "Manipulate mode \"`1`\" undefined !";

(* define tensors *)
DefineTensor[var_] := Module[{varName},
  varName = var[[1]];
  Switch[Length[var], (* var length: how many descriptions for var *)
    3,
    DefTensor[varName, $Manifd, var[[2]], PrintAs->var[[3]]],
    2,
    If[StringQ[var[[2]]],
      DefTensor[varName, $Manifd, PrintAs->var[[2]]],
      DefTensor[varName, $Manifd, var[[2]]]
    ],
    1,
    DefTensor[varName, $Manifd],
    _,
    Message[DefineTensor::ErrorTensorType, varName]; Abort[]
  ],
];
DefineTensor::ErrorTensorType = "Tensor type of `1` unsupported yet !";

(* different modes of set components, also set global map of varlist:
     1. mode 'set components with vlu order': using order in varlist,
     2. mode 'set components with independent order': using order start with 0.
*)
SetComponentAndIndexMap[mode_, compName_, exprName_] := Module[
  {
    varlistIndex
  },
  (* set global map: $Map$ComponentToVarlist
       case1 (start at 'new local varlist', in this case, people should pay attention when they define varlist)
         {a00 a01 ... b00 b01 ...}, {e00 e01 ... f00 f01 ...}, ...
           0   1  ... ... ... ...     0   1  ... ... ... ...   ...
       case2 (start at 'new var in local varlist')
         {a00 a01 ... b00 b01 ...}, {e00 e01 ... f00 f01 ...}, ...
           0   1  ...  0   1  ...     0   1  ...  0   1  ...   ...
  *)
  If[Length[$Map$ComponentToVarlist]==0 || (* global varlist is empty *)
     $Bool$NewVarlist ||                   (* new local varlist start *)
     (StringMatchQ[mode, "set components and use independent var index"]&&
      (compName[[0]]=!=Last[$Map$ComponentToVarlist][[1,0]])), (* new var in local varlist *)
    varlistIndex = -1,
    varlistIndex = Last[$Map$ComponentToVarlist][[2]]
  ];
  varlistIndex = varlistIndex+1;
  (* set components and add to global map *)
  ComponentValue[compName, exprName];
  AppendTo[$Map$ComponentToVarlist, {compName, varlistIndex}];
  $Bool$NewVarlist = False
];

(* set name of component, rhs of component and component value *)
SetNameArray[compIndexList_, coordinate_, varName_, gridPointIndex_] := Module[
  {
    coordFull, (* consider covariant or contravariant *)
    compName,  (* component expr in Mathematica kernal *)
    rhssName,  (* rhs component expr in Mathematica kernal *)
    exprName   (* component expr to be printed to C code, or lhs *)
  },
  (* initialize *)
  compName = varName[[0]][];
  rhssName = RHSOf[varName[[0]]][];
  exprName = StringTrim[ToString[varName[[0]]], $Suffix$Unprotected];
  (* if not scalar *)
  If[Length[compIndexList]>0,
    Do[
      If[DownIndexQ[varName[[compIndex]]], coordFull=-coordinate, coordFull=coordinate];
      AppendTo[compName, {compIndexList[[compIndex]],coordFull}];
      AppendTo[rhssName, {compIndexList[[compIndex]],coordFull}];
      (* ignore the information about covariant/contravariant in 'exprName' *)
      exprName = exprName<>ToString@compIndexList[[compIndex]],
      {compIndex, 1, Length[compIndexList]}]
  ];
  exprName=ToExpression[exprName<>gridPointIndex];
  (* return NameArray *)
  {compName, rhssName, exprName}
];
