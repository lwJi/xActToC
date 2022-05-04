(* ::Package:: *)

(* ManipulateVarlist.wl
   (c) Liwei Ji, 08/2021
*)


(* main function which handle different num of index cases *)
ManipulateVarlist[mode_?StringQ, varlist_?ListQ, coordinate_, gridPointIndex_?StringQ, printVerbose_:True] := Module[
  {
    iMin, iMax = 3,
    var, varName,
    manipulateComponentValue
  },
  (* default parameters *)
  $Bool$PrintVerbose = printVerbose;
  If[$Dim==3, iMin = 1, iMin = 0];
  (* initialize $Bool$NewVarlist *)
  $Bool$NewVarlist = True;

  (* loop over varlist in the list *)
  Do[
    var = varlist[[iVar]];   (* say { metricg[-a,-b], Symmetric[{-a,-b}], "g" } *)
    varName = var[[1]];      (* say metricg[-a,-b] *)
    varLength = Length[var]; (* var length: how many descriptions for var *)

    (* check if tensor defined yet *)
    If[!xTensorQ[varName[[0]]], (* if tensor name exist already *)
      (* tensor not exist, creat one *)
      If[StringMatchQ[mode, "set components*"],
        DefineTensor[var]; PrintVerbose["Define Tensor ", varName[[0]]],
        Message[ManipulateVarlist::ErrorTensorNonExist, iVar, varName, varlist]; Abort[]
      ],
      (* tensor exist *)
      If[!MemberQ[$Map$ComponentToVarlist[[All, 1, 0]], varName[[0]]], (* if tensor name is outside the global varlist *)
        Message[ManipulateVarlist::ErrorTensorExistOutside, iVar, varName, varlist]; Abort[]
      ]
    ];
    (* set temp function *)
    manipulateComponentValue[compIndexList_] := ManipulateComponent[compIndexList, mode, coordinate, varName, gridPointIndex];

    (* consider different types of tensor *)
    Switch[Length[varName],
      (* ---------------- *)
      (* ZERO INDEX CASE: *)
      (* ---------------- *)
      0,
      Continue[],

      (* --------------- *)
      (* ONE INDEX CASE: *)
      (* --------------- *)
      1,
      Do[manipulateComponentValue[{ia}], {ia,iMin,iMax}],

      (* ----------------- *)
      (* TWO INDEXES CASE: *)
      (* ----------------- *)
      2,
      If[(varLength==3) || (varLength==2&&(!StringQ[var[[2]]])), (* if with symmetry *)
        (* With Symmetry *)
        Module[{},
          Switch[var[[2]][[0]],
            Symmetric,
            Do[manipulateComponentValue[{ia,ib}], {ia,iMin,iMax},{ib,ia,iMax}],
            Antisymmetric,
            Do[manipulateComponentValue[{ia,ib}], {ia,iMin,iMax},{ib,ia+1,iMax}],
            _,
            Message[ManipulateVarlist::ErrorSymmetryType, iVar, varName, varlist]; Abort[]
          ];
          varName//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* Without Symmetry *)
        Do[manipulateComponentValue[{ia,ib}], {ia,iMin,iMax},{ib,iMin,iMax}]
      ],

(*
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
              Do[compIndexList={idx$c,ia,ib};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{ia,iMin,iMax},
                {ib,ia,iMax}],
              Antisymmetric,
              Do[compIndexList={idx$c,ia,ib};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{ia,iMin,iMax},
                {ib,ia+1,iMax}],
              _,(* symmetry undefined *)
              printerror[iVar,varName]
            ],
            (* (ab)c or [ab]c *)
            (varlist$idxsymm[[1]]===varName[[1]])&&
            (varlist$idxsymm[[2]]===varName[[2]]),
            Switch[var[[2]][[0]],
              Symmetric,
              Do[compIndexList={ia,ib,idx$c};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {ia,iMin,iMax},{ib,ia,iMax},
                {idx$c,iMin,iMax}],
              Antisymmetric,
              Do[compIndexList={ia,ib,idx$c};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {ia,iMin,iMax},{ib,ia+1,iMax},
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
        Do[compIndexList={idx$c,ia,ib};
          ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
          {idx$c,iMin,iMax},{ia,iMin,iMax},
          {ib,iMin,iMax}]
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
              Do[compIndexList={idx$c,idx$d,ia,ib};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{idx$d,iMin,iMax},
                {ia,iMin,iMax},{ib,ia,iMax}],
              Antisymmetric,
              Do[compIndexList={idx$c,idx$d,ia,ib};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{idx$d,iMin,iMax},
                {ia,iMin,iMax},{ib,ia+1,iMax}],
              _,(* symmetry undefined *)
              printerror[iVar,varName]
            ],
            (* (cd)(ab) or ... *)
            var[[2]][[0]]==GenSet,
            Which[
              (var[[2]][[1]]==Cycles[{1,2}])&&
              (var[[2]][[2]]==Cycles[{3,4}]),
              Do[compIndexList={idx$c,idx$d,ia,ib};
                ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
                {idx$c,iMin,iMax},{idx$d,idx$c,iMax},
                {ia,iMin,iMax},{ib,ia,iMax}],
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
        Do[compIndexList={idx$c,idx$d,ia,ib};
          ManipulateComponent[compIndexList,mode,coordinate,varName,gridPointIndex],
          {idx$c,iMin,iMax},{idx$d,iMin,iMax},
          {ia,iMin,iMax},{ib,iMin,iMax}]
      ],
*)

      (* -------------------- *)
      (* OTHER NUM OF INDEXES *)
      (* -------------------- *)
      _,
      Message[ManipulateVarlist::ErrorTensorType, iVar, varName, varlist]; Abort[]
    ], (* end of Switch*)
  {iVar, 1, Length[varlist]}] (* end of Do *)
];
ManipulateVarlist::ErrorTensorNonExist = "Tensor of the `1`-th var, `2`, in varlist `3` can't be defined since it's in 'print components' mode. Please set its components first !";
ManipulateVarlist::ErrorTensorExistOutside = "Tensor of the `1`-th var, `2`, in varlist `3` already exsit outside the global varlist !";
ManipulateVarlist::ErrorTensorType = "Tensor type of the `1`-th var, `2`, in varlist `3` unsupported yet !";
ManipulateVarlist::ErrorSymmetryType = "Symmetry type of the `1`-th var, `2`, in varlist `3` unsupported yet !";

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
    PrintVerbose["Set Component ", compName, " for Tensor ", varName[[0]]];
    SetComponentAndIndexMap[mode, compName, exprName],
    If[StringMatchQ[mode, "print components*"],
      PrintVerbose["Print Component ", compName, " to C-file"],
      (*PrintComponent[mode,coordinate,varName,compName,rhssName,gridPointIndex],*)
      Message[ManipulateComponent::ErrorMode, mode]; Abort[]
    ]
  ]
];
ManipulateComponent::ErrorMode = "Manipulate mode \"`1`\" undefined !";

(* define tensors *)
DefineTensor[var_] := Module[
  {
    varName
  },
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
  ] (* end of Switch *)
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
     (StringMatchQ[mode, "set components and use independent var index"] && (compName[[0]]=!=Last[$Map$ComponentToVarlist][[1,0]])), (* new var in local varlist *)
    varlistIndex = -1,
    varlistIndex = Last[$Map$ComponentToVarlist][[2]]
  ];
  varlistIndex = varlistIndex+1;
  (* set components and add to global map *)
  ComponentValue[compName, exprName];
  If[MemberQ[$Map$ComponentToVarlist[[All, 1]], compName], (* if tensor component is already exist *)
    PrintVerbose["Skip adding Component ", compName, " to Global VarList, since it already exist"],
    AppendTo[$Map$ComponentToVarlist, {compName, varlistIndex}]; PrintVerbose["Add Component ", compName, " to Global VarList"]
  ];
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
