(* ::Package:: *)

(* ManipulateVarlist.wl
   (c) Liwei Ji, 08/2021
*)

(* default value for gridPointIndex, suffixName and printVerbose *)
Options[ManipulateVarlist] := {
  coordinate -> $defaultCoordinateName,
  gridPointIndex -> $gridPointIndex,
  suffixName -> $suffixName
};
(* main function which handle different num of index cases *)
ManipulateVarlist[mode_?StringQ, varlist_?ListQ, OptionsPattern[]] := Module[
  {
    coordinateValue = OptionValue[coordinate],
    gridPointIndexValue = OptionValue[gridPointIndex],
    suffixNameValue = OptionValue[suffixName],
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
  (* check Null *)
  If[coordinateValue==Null, Message[ManipulateVarlist::ErrorNullCoordinate];Abort[]];
  (* set global parameters *)
  $bool$NewVarlist = True;
  (* set temp parameters *)
  If[$dim==3, iMin = 1, iMin = 0];

  (* loop over varlist in the list *)
  Do[
    var = varlist[[iVar]];   (* say { metricg[-a,-b], Symmetric[{-a,-b}], "g" } *)
    varName = var[[1]];      (* say metricg[-a,-b] *)
    varLength = Length[var]; (* var length: how many descriptions for var *)
    varWithSymmetry = (varLength==3) || (varLength==2&&(!StringQ[var[[2]]])); (* if with symmetry *)
    If[varWithSymmetry, varSymmetryName=var[[2]][[0]];varSymmetryIndex=var[[2]][[1]]];
    (* check if tensor defined yet *)
    If[!xTensorQ[varName[[0]]],
      (* tensor not exist, creat one *)
      If[StringMatchQ[mode, "set components*"],
        DefineTensor[var]; PrintVerbose["Define Tensor ", varName[[0]]],
        Message[ManipulateVarlist::ErrorTensorNonExist, iVar, varName, varlist]; Abort[]
      ],
      (* tensor exist already: if tensor name is outside the global varlist *)
      If[!MemberQ[$map$ComponentToVarlist[[All, 1, 0]], varName[[0]]],
        Message[ManipulateVarlist::ErrorTensorExistOutside, iVar, varName, varlist]; Abort[]
      ]
    ];
    (* set temp function *)
    manipulateComponentValue[compIndexList_] := ManipulateComponent[compIndexList, mode, coordinateValue, varName, gridPointIndexValue, suffixNameValue];

    (* consider different types of tensor *)
    Switch[Length[varName],
      (* ZERO INDEX CASE: *)
      0,
      manipulateComponentValue[{}],

      (* ONE INDEX CASE: *)
      1,
      Do[manipulateComponentValue[{ia}], {ia,iMin,iMax}],

      (* TWO INDEXES CASE: *)
      2,
      If[varWithSymmetry,
        (* With Symmetry *)
        Switch[varSymmetryName,
          Symmetric,
          Do[manipulateComponentValue[{ia,ib}], {ia,iMin,iMax},{ib,ia,iMax}],
          Antisymmetric,
          Do[manipulateComponentValue[{ia,ib}], {ia,iMin,iMax},{ib,ia+1,iMax}],
          _,
          Message[ManipulateVarlist::ErrorSymmetryType, iVar, varName, varlist]; Abort[]
        ];
        varName//ToBasis[coordinateValue]//ComponentArray//ComponentValue,
        (* Without Symmetry *)
        Do[manipulateComponentValue[{ia,ib}], {ia,iMin,iMax},{ib,iMin,iMax}]
      ],

      (* THREE INDEXES CASE *)
      3,
      If[varWithSymmetry,
        (* With Symmetry *)
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
        ]; (* end of Which *)
        varName//ToBasis[coordinateValue]//ComponentArray//ComponentValue,
        (* Without Symmetry *)
        Do[manipulateComponentValue[{ic,ia,ib}], {ic,iMin,iMax},{ia,iMin,iMax},{ib,iMin,iMax}]
      ],

      (* FOUR INDEXES CASE *)
      4,
      If[varWithSymmetry,
        (* With Symmetry *)
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
        ]; (* end of Which *)
        varName//ToBasis[coordinateValue]//ComponentArray//ComponentValue,
        (* Without Symmetry *)
        Do[manipulateComponentValue[{ic,id,ia,ib}], {ic,iMin,iMax},{id,iMin,iMax},{ia,iMin,iMax},{ib,iMin,iMax}]
      ],

      (* OTHER NUM OF INDEXES *)
      _,
      Message[ManipulateVarlist::ErrorTensorType, iVar, varName, varlist]; Abort[]
    ], (* end of Switch*)
  {iVar, 1, Length[varlist]}]; (* end of Do *)
];
ManipulateVarlist::ErrorTensorNonExist = "Tensor of the `1`-th var, `2`, in varlist `3` can't be defined since it's in 'print components' mode. Please set its components first !";
ManipulateVarlist::ErrorTensorExistOutside = "Tensor of the `1`-th var, `2`, in varlist `3` already exsit outside the global varlist !";
ManipulateVarlist::ErrorTensorType = "Tensor type of the `1`-th var, `2`, in varlist `3` unsupported yet !";
ManipulateVarlist::ErrorSymmetryType = "Symmetry type of the `1`-th var, `2`, in varlist `3` unsupported yet !";
ManipulateVarlist::ErrorNullCoordinate = "Coordinate is Null !";

(* Maniputlate each component of a tensor:
     1. set tensor components,
     2. print tensor components or equations
*)
ManipulateComponent[compIndexList_, mode_, coordinate_, varName_, gridPointIndex_, suffixName_] := Module[
  {
    compName,
    rhssName,
    exprName
  },
  (* set names *)
  {compName,rhssName,exprName} = SetNameArray[compIndexList, mode, coordinate, varName, gridPointIndex];

  (* skip those 4D component (0-compopnent here) of a 3D tensor *)
  If[is4DCompIndexListIn3DTensor[compIndexList,varName],
    (* set those 'up' 0-component to 0 for a 3D tensor *)
    If[isUp4DCompIndexListIn3DTensor[compIndexList,varName], ComponentValue[compName, 0]];
    (* skip *)
    Continue[]
  ];

  (* set components or print components/equations *)
  Which[
    (* set components *)
    StringMatchQ[mode, "set components*"],
    SetComponentAndIndexMap[mode, compName, exprName]; PrintVerbose["Set Component ", compName, " for Tensor ", varName[[0]]],
    (* print componentes *)
    StringMatchQ[mode, "print components*"],
    PrintComponent[mode, coordinate, varName, compName, rhssName, gridPointIndex, suffixName]; PrintVerbose["Print Component ", compName, " to C-file"],
    (* error mode *)
    True,
    Message[ManipulateComponent::ErrorMode, mode]; Abort[]
  ];
];
ManipulateComponent::ErrorMode = "Manipulate mode \"`1`\" undefined !";

(* return name array of component, rhs of component and component value *)
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

  (* if set component for temporary varlist or not *)
  If[StringMatchQ[mode, "set components: temporary varlist"],
    exprName=ToExpression[exprName],
    exprName=ToExpression[exprName<>gridPointIndex]
  ];

  (* return NameArray *)
  {compName, rhssName, exprName}
];

(* define tensors *)
DefineTensor[var_] := Module[
  {
    varName = var[[1]]
  },
  Switch[Length[var], (* var length: how many descriptions for var *)
    3,
    DefTensor[varName, $Manifd, var[[2]], var[[3]]],
    2,
    DefTensor[varName, $Manifd, var[[2]]],
    1,
    DefTensor[varName, $Manifd],
    _,
    Message[DefineTensor::ErrorTensorType, varName]; Abort[]
  ]; (* end of Switch *)
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
     (StringMatchQ[mode, "set components: independent varlist"] && (compName[[0]]=!=Last[$map$ComponentToVarlist][[1,0]])), (* new var in local varlist *)
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
  $bool$NewVarlist = False;
];

PrintComponent[mode_, coordinate_, varName_, compName_, rhssName_, gridPointIndex_, suffixName_] := Module[{},
  Which[
    (* print var initialization *)
    StringMatchQ[mode, "print components initialization*"],
    PrintComponentInitialization[mode, varName, compName, gridPointIndex],
    (* print var equations *)
    StringMatchQ[mode, "print components equation*"],
    PrintComponentEquation[mode, coordinate, compName, rhssName, suffixName],
    (* mode undefined *)
    True,
    Message[PrintComponent::ErrorMode, mode]; Abort[]
  ];
];
PrintComponent::ErrorMode = "Print mode `1` unsupported yet !";

PrintComponentEquation[mode_, coordinate_, compName_, rhssName_, suffixName_] := Module[
  {
    compToValue = compName//ToValues,
    rhssToValue = rhssName//DummyToBasis[coordinate]//TraceBasisDummy//ToValues
  },
  If[$bool$SimplifyEquation, rhssToValue=rhssToValue//Simplify];

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
      rhssToValue = (rhssName/.{rhssName[[0]]->ToExpression[ToString[rhssName[[0]]]<>"$"<>suffixName]})//DummyToBasis[coordinate]//TraceBasisDummy//ToValues;
      If[$bool$SimplifyEquation, rhssToValue=rhssToValue//Simplify];
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
  ];
];
PrintComponentEquation::ErrorMode = "Print equation mode '`1`' unsupported yet !";
PrintComponentEquation::ErrorUndefined = "Rhs expression '`1`' undefined !";
