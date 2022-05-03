(* ::Package:: *)

(* ManipulateComponents.wl
   (c) Liwei Ji, 08/2021 *)


(* main function which handle different num of index cases *)
ManipulateComponents[mode_?StringQ, varlist_, coordinate_, dimension_?IntegerQ, gridIndex_?StringQ] := Module[
  {
    cpntidx$list,
    idx$init,
    idx$final,
    var$name
  },
  
  Print["Hello World!"];

  (*
  (* default parameters *)
  idx$final=3;
  If[dimension==3,idx$init=1,idx$init=0];
  (* initialize new$varlist$global *)
  new$varlist$global=True;

  (* loop over varlist in the list *)
  Do[var$name=varlist[[i$var,1]];
    Switch[Length[var$name],
      (* ---------------- *)
      (* ZERO INDEX CASE: *)
      (* ---------------- *)
      0,
      Module[{},
        cpntidx$list = {};
        manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex]
      ],

      (* --------------- *)
      (* ONE INDEX CASE: *)
      (* --------------- *)
      1,
      Module[{},
        Do[cpntidx$list = {idx$a};
          manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
          {idx$a,idx$init,idx$final}]
      ],

      (* ----------------- *)
      (* TWO INDEXES CASE: *)
      (* ----------------- *)
      2,
      If[(Length[varlist[[i$var]]]==3)||
         (Length[varlist[[i$var]]]==2&&(!StringQ[varlist[[i$var,2]]])),
        (* WITH SYMMETRY *)
        Module[{},
          Switch[varlist[[i$var,2]][[0]],
            Symmetric,
            Do[cpntidx$list={idx$a,idx$b};
              manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
              {idx$a,idx$init,idx$final},{idx$b,idx$a,idx$final}],
            Antisymmetric,
            Do[cpntidx$list={idx$a,idx$b};
              manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
              {idx$a,idx$init,idx$final},{idx$b,idx$a+1,idx$final}],
            _,(* symmetry undefined *)
            printerror[i$var,var$name]
          ];
          var$name//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* WITHOUT SYMMETRY *)
        Do[cpntidx$list={idx$a,idx$b};
          manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
          {idx$a,idx$init,idx$final},{idx$b,idx$init,idx$final}]
      ],

      (* ------------------ *)
      (* THREE INDEXES CASE *)
      (* ------------------ *)
      3,
      If[(Length[varlist[[i$var]]]==3)||
         (Length[varlist[[i$var]]]==2&&(!StringQ[varlist[[i$var,2]]])),
        (* WITH SYMMETRY *)
        Module[{varlist$idxsymm=varlist[[i$var,2]][[1]]},
          Which[
            (* c(ab) or c[ab] *)
            (varlist$idxsymm[[1]]===var$name[[2]])&&
            (varlist$idxsymm[[2]]===var$name[[3]]),
            Switch[varlist[[i$var,2]][[0]],
              Symmetric,
              Do[cpntidx$list={idx$c,idx$a,idx$b};
                manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
                {idx$c,idx$init,idx$final},{idx$a,idx$init,idx$final},
                {idx$b,idx$a,idx$final}],
              Antisymmetric,
              Do[cpntidx$list={idx$c,idx$a,idx$b};
                manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
                {idx$c,idx$init,idx$final},{idx$a,idx$init,idx$final},
                {idx$b,idx$a+1,idx$final}],
              _,(* symmetry undefined *)
              printerror[i$var,var$name]
            ],
            (* (ab)c or [ab]c *)
            (varlist$idxsymm[[1]]===var$name[[1]])&&
            (varlist$idxsymm[[2]]===var$name[[2]]),
            Switch[varlist[[i$var,2]][[0]],
              Symmetric,
              Do[cpntidx$list={idx$a,idx$b,idx$c};
                manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
                {idx$a,idx$init,idx$final},{idx$b,idx$a,idx$final},
                {idx$c,idx$init,idx$final}],
              Antisymmetric,
              Do[cpntidx$list={idx$a,idx$b,idx$c};
                manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
                {idx$a,idx$init,idx$final},{idx$b,idx$a+1,idx$final},
                {idx$c,idx$init,idx$final}],
              _,(* symmetry undefined *)
              printerror[i$var,var$name]
            ],
            (* other three indexes cases *)
            True,
            printerror[i$var,var$name]
          ];
          var$name//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* WITHOUT SYMMETRY *)
        Do[cpntidx$list={idx$c,idx$a,idx$b};
          manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
          {idx$c,idx$init,idx$final},{idx$a,idx$init,idx$final},
          {idx$b,idx$init,idx$final}]
      ],

      (* ----------------- *)
      (* FOUR INDEXES CASE *)
      (* ----------------- *)
      4,
      If[(Length[varlist[[i$var]]]==3)||
         (Length[varlist[[i$var]]]==2&&(!StringQ[varlist[[i$var,2]]])),
        (* WITH SYMMETRY *)
        Module[{varlist$idxsymm=varlist[[i$var,2]][[1]]},
          Which[
            (* cd(ab) or cd[ab] *)
            (varlist$idxsymm[[1]]===var$name[[3]])&&
            (varlist$idxsymm[[2]]===var$name[[4]]),
            Switch[varlist[[i$var,2]][[0]],
              Symmetric,
              Do[cpntidx$list={idx$c,idx$d,idx$a,idx$b};
                manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
                {idx$c,idx$init,idx$final},{idx$d,idx$init,idx$final},
                {idx$a,idx$init,idx$final},{idx$b,idx$a,idx$final}],
              Antisymmetric,
              Do[cpntidx$list={idx$c,idx$d,idx$a,idx$b};
                manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
                {idx$c,idx$init,idx$final},{idx$d,idx$init,idx$final},
                {idx$a,idx$init,idx$final},{idx$b,idx$a+1,idx$final}],
              _,(* symmetry undefined *)
              printerror[i$var,var$name]
            ],
            (* (cd)(ab) or ... *)
            varlist[[i$var,2]][[0]]==GenSet,
            Which[
              (varlist[[i$var,2]][[1]]==Cycles[{1,2}])&&
              (varlist[[i$var,2]][[2]]==Cycles[{3,4}]),
              Do[cpntidx$list={idx$c,idx$d,idx$a,idx$b};
                manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
                {idx$c,idx$init,idx$final},{idx$d,idx$c,idx$final},
                {idx$a,idx$init,idx$final},{idx$b,idx$a,idx$final}],
              True,
              printerror[i$var,var$name]
            ],
            (* other four indexes cases *)
            True,
            printerror[i$var,var$name]
          ];
          var$name//ToBasis[coordinate]//ComponentArray//ComponentValue
        ],
        (* WITHOUT SYMMETRY *)
        Do[cpntidx$list={idx$c,idx$d,idx$a,idx$b};
          manipulate[cpntidx$list,mode,coordinate,var$name,gridIndex],
          {idx$c,idx$init,idx$final},{idx$d,idx$init,idx$final},
          {idx$a,idx$init,idx$final},{idx$b,idx$init,idx$final}]
      ],

      (* -------------------- *)
      (* OTHER NUM OF INDEXES *)
      (* -------------------- *)
      _,
      printerror[i$var,var$name]
    ],
  {i$var,1,Length[varlist]}]
  *)
];
ManipulateComponents::ErrorIndex = "Bad Index";
