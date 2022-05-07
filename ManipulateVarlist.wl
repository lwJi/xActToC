(* ::Package:: *)

(* ManipulateVarlist.wl
   (c) Liwei Ji, 08/2021
*)


(* main function which handle different num of index cases *)
ManipulateVarlist[mode_?StringQ, varlist_?ListQ, coordinate_, gridPointIndex_?StringQ, printVerbose_:False] := Module[
  {
    iMin,
    iMax = 3,
    var,
    varName,
    varLength,
    varWithSymmetry,
    varSymmetryName,
    varSymmetryIndex,
    manipulateComponentValue
  },
  (* set global parameters *)
  $bool$NewVarlist = True;
  $bool$PrintVerbose = printVerbose;
  (* set temp parameters *)
  If[$dim==3, iMin = 1, iMin = 0];

  (* loop over varlist in the list *)
  Do[
    var = varlist[[iVar]];   (* say { metricg[-a,-b], Symmetric[{-a,-b}], "g" } *)
    varName = var[[1]];      (* say metricg[-a,-b] *)
    varLength = Length[var]; (* var length: how many descriptions for var *)
    varWithSymmetry = (varLength==3) || (varLength==2&&(!StringQ[var[[2]]])); (* if with symmetry *)
    If[varWithSymmetry,
      varSymmetryName = var[[2]][[0]];
      varSymmetryIndex = var[[2]][[1]]
    ]

    (* check if tensor defined yet *)
    If[!xTensorQ[varName[[0]]], (* if tensor name exist already *)
      (* tensor not exist, creat one *)
      If[StringMatchQ[mode, "set components*"],
        DefineTensor[var]; PrintVerbose["Define Tensor ", varName[[0]]],
        Message[ManipulateVarlist::ErrorTensorNonExist, iVar, varName, varlist]; Abort[]
      ],
      (* tensor exist *)
      If[!MemberQ[$map$ComponentToVarlist[[All, 1, 0]], varName[[0]]], (* if tensor name is outside the global varlist *)
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
      If[varWithSymmetry,
        (* With Symmetry *)
        Module[{},
          Switch[varSymmetryName,
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

      (* ------------------ *)
      (* THREE INDEXES CASE *)
      (* ------------------ *)
      3,
      If[varWithSymmetry,
        (* With Symmetry *)
        Module[{},
          Which[
            (* c(ab) or c[ab] *)
            (varSymmetryIndex[[1]]===varName[[2]]) && (varSymmetryIndex[[2]]===varName[[3]]),
            Switch[varSymmetryName,
              Symmetric,
              Do[manipulateComponentValue[{ic,ia,ib}], {ic,iMin,iMax},{ia,iMin,iMax},{ib,ia,iMax}],
              Antisymmetric,
              Do[manipulateComponentValue[{ic,ia,ib}], {ic,iMin,iMax},{ia,iMin,iMax},{ib,ia+1,iMax}],
              _,
              Message[ManipulateVarlist::ErrorSymmetryType, iVar, varName, varlist]; Abort[]
            ],
            (* (ab)c or [ab]c *)
            (varSymmetryIndex[[1]]===varName[[1]]) && (varSymmetryIndex[[2]]===varName[[2]]),
            Switch[varSymmetryName,
              Symmetric,
              Do[manipulateComponentValue[{ia,ib,ic}], {ia,iMin,iMax},{ib,ia,iMax},{ic,iMin,iMax}],
              Antisymmetric,
              Do[manipulateComponentValue[{ia,ib,ic}], {ia,iMin,iMax},{ib,ia+1,iMax},{ic,iMin,iMax}],
              _,
              Message[ManipulateVarlist::ErrorSymmetryType, iVar, varName, varlist]; Abort[]
            ],
            (* other three indexes cases *)
            True,
            Message[ManipulateVarlist::ErrorSymmetryType, iVar, varName, varlist]; Abort[]
          ];
          varName//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* Without Symmetry *)
        Do[manipulateComponentValue[{ic,ia,ib}], {ic,iMin,iMax},{ia,iMin,iMax},{ib,iMin,iMax}]
      ],

      (* ----------------- *)
      (* FOUR INDEXES CASE *)
      (* ----------------- *)
      4,
      If[varWithSymmetry,
        (* With Symmetry *)
        Module[{},
          Which[
            (* cd(ab) or cd[ab] *)
            (varSymmetryIndex[[1]]===varName[[3]]) && (varSymmetryIndex[[2]]===varName[[4]]),
            Switch[varSymmetryName,
              Symmetric,
              Do[manipulateComponentValue[{ic,id,ia,ib}], {ic,iMin,iMax},{id,iMin,iMax},{ia,iMin,iMax},{ib,ia,iMax}],
              Antisymmetric,
              Do[manipulateComponentValue[{ic,id,ia,ib}], {ic,iMin,iMax},{id,iMin,iMax},{ia,iMin,iMax},{ib,ia+1,iMax}],
              _,
              Message[ManipulateVarlist::ErrorSymmetryType, iVar, varName, varlist]; Abort[]
            ],
            (* (cd)(ab) or ... *)
            varSymmetryName==GenSet,
            Which[
              (var[[2]][[1]]==Cycles[{1,2}]) && (var[[2]][[2]]==Cycles[{3,4}]),
              Do[manipulateComponentValue[{ic,id,ia,ib}], {ic,iMin,iMax},{id,ic,iMax},{ia,iMin,iMax},{ib,ia,iMax}],
              True,
              Message[ManipulateVarlist::ErrorSymmetryType, iVar, varName, varlist]; Abort[]
            ],
            (* other four indexes cases *)
            True,
            Message[ManipulateVarlist::ErrorSymmetryType, iVar, varName, varlist]; Abort[]
          ];
          varName//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* Without Symmetry *)
        Do[manipulateComponentValue[{ic,id,ia,ib}], {ic,iMin,iMax},{id,iMin,iMax},{ia,iMin,iMax},{ib,iMin,iMax}]
      ],

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
    compName,
    rhssName,
    exprName
  },
  (* set names *)
  {compName,rhssName,exprName} = SetNameArray[compIndexList, mode, coordinate, varName, gridPointIndex];
  (* find out 4D component (0-compopnent here) of a 3D tensor, which should be skipped *)
  If[is4DCompIndexIn3DTensor[compIndexList,varName],
    (* set those 'up' 0-component to 0 for a 3D tensor *)
    If[isUp0thCompIndex[compIndexList,varName], ComponentValue[compName, 0]];
    Continue[]
  ];
  (* set components or print components/equations *)
  Which[
    (* set componentes *)
    StringMatchQ[mode, "set components*"],
    SetComponentAndIndexMap[mode, compName, exprName]; PrintVerbose["Set Component ", compName, " for Tensor ", varName[[0]]],
    (* print componentes *)
    StringMatchQ[mode, "print components*"],
    PrintComponent[mode, coordinate, varName, compName, rhssName, gridPointIndex]; PrintVerbose["Print Component ", compName, " to C-file"],
    (* error mode *)
    True,
    Message[ManipulateComponent::ErrorMode, mode]; Abort[]
  ]
];
ManipulateComponent::ErrorMode = "Manipulate mode \"`1`\" undefined !";

(* set name of component, rhs of component and component value *)
SetNameArray[compIndexList_, mode_, coordinate_, varName_, gridPointIndex_] := Module[
  {
    coordFull, (* consider covariant or contravariant *)
    compName,  (* component expr in Mathematica kernal, say Pi[{1,-cart},{2,-cart}] *)
    rhssName,  (* rhs component expr in Mathematica kernal, say Pi$RHS[{1,-cart},{2,-cart}] *)
    exprName   (* component expr to be printed to C code, or lhs, say Pi12[[ijk]] *)
  },
  (* initialize *)
  compName = varName[[0]][];
  rhssName = RHSOf[varName[[0]]][];
  exprName = StringTrim[ToString[varName[[0]]], $suffix$Unprotected];
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
  If[StringMatchQ[mode, "set components using independent var index for temporary var"],
    exprName=ToExpression[exprName],
    exprName=ToExpression[exprName<>gridPointIndex]
  ];
  (* return NameArray *)
  {compName, rhssName, exprName}
];

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
  (* set global map: $map$ComponentToVarlist
       case1 (start at 'new local varlist', in this case, people should pay attention when they define varlist)
         {a00 a01 ... b00 b01 ...}, {e00 e01 ... f00 f01 ...}, ...
           0   1  ... ... ... ...     0   1  ... ... ... ...   ...
       case2 (start at 'new var in local varlist')
         {a00 a01 ... b00 b01 ...}, {e00 e01 ... f00 f01 ...}, ...
           0   1  ...  0   1  ...     0   1  ...  0   1  ...   ...
  *)
  If[Length[$map$ComponentToVarlist]==0 || (* global varlist is empty *)
     $bool$NewVarlist ||                   (* new local varlist start *)
     (StringMatchQ[mode, "set components using independent var index*"] && (compName[[0]]=!=Last[$map$ComponentToVarlist][[1,0]])), (* new var in local varlist *)
    varlistIndex = -1,
    varlistIndex = Last[$map$ComponentToVarlist][[2]]
  ];
  varlistIndex = varlistIndex+1;
  (* set components and add to global map *)
  ComponentValue[compName, exprName];
  If[MemberQ[$map$ComponentToVarlist[[All, 1]], compName], (* if tensor component is already exist *)
    PrintVerbose["Skip adding Component ", compName, " to Global VarList, since it already exist"],
    AppendTo[$map$ComponentToVarlist, {compName, varlistIndex}]; PrintVerbose["Add Component ", compName, " to Global VarList"]
  ];
  $bool$NewVarlist = False
];

PrintComponent[mode_, coordinate_, varName_, compName_, rhssName_, gridPointIndex_] := Module[
  {},
  Which[
    (* print var initialization *)
    StringMatchQ[mode, "print components initialization*"],
    (* print var equations *)
    PrintComponentInitialization[mode, coordinate, varName, compName, gridPointIndex],
    StringMatchQ[mode, "print components equation*"],
    PrintComponentEquation[mode, coordinate, compName, rhssName, gridPointIndex],
    (* mode undefined *)
    True,
    Message[PrintComponent::ErrorMode, mode]; Abort[]
  ]
];
PrintComponent::ErrorMode = "Print mode `1` unsupported yet !";

PrintComponentEquation[mode_, coordinate_, compName_, rhssName_, suffixName_] := Module[
  {
    compToValue = compName//ToValues,
    rhssToValue = rhssName//DummyToBasis[coordinate]//TraceBasisDummy//ToValues//Simplify
  },
  (* different modes *)
  Which[
    (* equations of temprary variables definition *)
    StringMatchQ[mode,"print components equation: temporary"],
    Module[{},
      pr["double "];
      PutAppend[CForm[compToValue],$outputFile]; pr["="];
      PutAppend[CForm[rhssToValue],$outputFile]; pr[";\n"];
    ],
    (* equations of primary output variables *)
    StringMatchQ[mode,"print components equation: primary"],
    Module[{},
      PutAppend[CForm[compToValue],$outputFile]; pr["="];
      PutAppend[CForm[rhssToValue],$outputFile]; pr[";\n"];
    ],
    (* equations of primary output variables with suffix, say "dtPinn$fromdtK", where suffixName='fromdtK' *)
    StringMatchQ[mode,"print components equation: primary with suffix"],
    Module[{},
      rhssToValue = (rhssName/.{rhssName[[0]]->ToExpression[ToString[rhssName[[0]]]<>"$"<>suffixName]})//DummyToBasis[coordinate]//TraceBasisDummy//ToValues//Simplify;
      PutAppend[CForm[compToValue],$outputFile]; pr["="];
      PutAppend[CForm[rhssToValue],$outputFile]; pr[";\n"];
    ],
    (* equations of adding more terms to primary variables, say add matter terms to dt_U *)
    StringMatchQ[mode,"print components equation: adding to primary"],
    Module[{},
      PutAppend[CForm[compToValue],$outputFile]; pr["+="];
      PutAppend[CForm[rhssToValue],$outputFile]; pr[";\n"]
    ],
    (* equations flux construction *)
    StringMatchQ[mode,"print components equation: primary for flux"],
    Module[{},
      pr["double "];
      PutAppend[CForm[compToValue],$outputFile]; pr["="];
      PutAppend[CForm[rhssToValue],$outputFile]; pr[";\n"];
    ],
    (* mode undefined *)
    True,
    Message[PrintComponentEquation::ErrorMode, mode]; Abort[]
  ]
];
PrintComponentEquation::ErrorMode = "Print equation mode `1` unsupported yet !";
PrintComponentEquation::ErrorUndefined = "Rhs expression `1` undefined !";
