Package["WolframInstitute`InfraCausality`"]


(* Ehlers-Pirani-Schild axiomatics on a finite directed graph.

   In EPS, light rays connect particle worldlines via message and echo maps;
   monotonicity of these maps (axiom D1) encodes the chronological order of
   events.  Here paths through the graph play the role of particles, and
   outgoing light rays implement the message exchange.

   Reference:
     Ehlers, Pirani, Schild, The Geometry of Free Fall and Light Propagation,
       in "General Relativity, Papers in Honour of J. L. Synge"
       (O'Raifeartaigh ed.), Oxford UP, 1972.                                  *)


(* =========================== Message functions =========================== *)

(* MultiMessageFunction[g, p1, p2]: for each event v on path1, the set of
   events on path2 reached from v by an outgoing light ray.  Set-valued. *)

MultiMessageFunction[ g_Graph, path1_List, path2_List ] :=
  Association @ Map[
    v |-> v -> Intersection[ OutgoingLightRays[ g, v ], path2 ],
    path1
  ]


(* FindMessageFunction[g, p1, p2]: enumerate every monotone single-valued
   selection from MultiMessageFunction.  EPS axiom D1 demands these maps to
   preserve the chain order on path1 -> path2.                                *)

FindMessageFunction[ g_Graph, path1_List, path2_List ] :=
  Module[ { fullMsg, nonEmpty, keys, valueLists },
    fullMsg    = MultiMessageFunction[ g, path1, path2 ];
    nonEmpty   = Select[ fullMsg, # =!= {} & ];
    If[ Length @ nonEmpty == 0, Return[ {} ] ];
    keys       = Keys @ nonEmpty;
    valueLists = Values @ nonEmpty;
    Select[
      AssociationThread[ keys, # ] & /@ Tuples @ valueLists,
      MonotoneQ[ path1, path2, # ] &
    ]
  ]

FindMessageFunction[ g_Graph, path1_List, path2_List, n_Integer ] :=
  Take[ FindMessageFunction[ g, path1, path2 ], UpTo[ n ] ]


(* =========================== Echo functions =========================== *)

(* MultiEchoFunction[g, p1, p2]: round-trip of light from path1 to path2 and
   back.  The image of v on path1 is the union of message images of all
   path2-events that v's outgoing rays hit.                                   *)

MultiEchoFunction[ g_Graph, path1_List, path2_List ] :=
  With[
    {
      msg12 = MultiMessageFunction[ g, path1, path2 ],
      msg21 = MultiMessageFunction[ g, path2, path1 ]
    },
    Association @ Map[
      v |-> v -> Union @@ ( q |-> Lookup[ msg21, q, {} ] ) /@ msg12[ v ],
      path1
    ]
  ]


(* FindEchoFunction[g, p1, p2]: enumerate all monotone single-valued echo maps
   on path1 obtainable as a composition of single-valued message maps in each
   direction.  Option "MonotoneMessages" -> True restricts to compositions of
   message maps that are themselves monotone.                                 *)

Options[ FindEchoFunction ] = { "MonotoneMessages" -> False };

FindEchoFunction[ g_Graph, path1_List, path2_List, opts : OptionsPattern[] ] :=
  Module[
    {
      fullMsg12, fullMsg21, nonEmpty12, nonEmpty21,
      all12, all21, restricted12, restricted21
    },
    fullMsg12  = MultiMessageFunction[ g, path1, path2 ];
    fullMsg21  = MultiMessageFunction[ g, path2, path1 ];
    nonEmpty12 = Select[ fullMsg12, # =!= {} & ];
    nonEmpty21 = Select[ fullMsg21, # =!= {} & ];
    If[ Length @ nonEmpty12 == 0 || Length @ nonEmpty21 == 0, Return[ {} ] ];
    all12 = AssociationThread[ Keys @ nonEmpty12, # ] & /@ Tuples @ Values @ nonEmpty12;
    all21 = AssociationThread[ Keys @ nonEmpty21, # ] & /@ Tuples @ Values @ nonEmpty21;
    restricted12 = If[ TrueQ @ OptionValue[ "MonotoneMessages" ],
      Select[ all12, MonotoneQ[ path1, path2, # ] & ], all12 ];
    restricted21 = If[ TrueQ @ OptionValue[ "MonotoneMessages" ],
      Select[ all21, MonotoneQ[ path2, path1, # ] & ], all21 ];
    DeleteDuplicates @ Flatten[
      Table[
        composeEcho[ path1, m12, m21 ],
        { m12, restricted12 }, { m21, restricted21 }
      ],
      1
    ]
  ]

FindEchoFunction[ g_Graph, path1_List, path2_List, n_Integer, opts : OptionsPattern[] ] :=
  Take[ FindEchoFunction[ g, path1, path2, opts ], UpTo[ n ] ]


(* =========================== Echo graph =========================== *)

(* EchoGraph[echoFn]: turn an Association of echo maps into a directed graph
   from each event to its echo image(s).                                      *)

EchoGraph[ echoFn_Association ] :=
  Graph[
    Keys @ echoFn,
    Flatten @ KeyValueMap[
      { v, targets } |-> ( DirectedEdge[ v, # ] & /@ Flatten @ { targets } ),
      echoFn
    ]
  ]


(* =========================== Monotonicity check =========================== *)

(* MonotoneQ[p1, p2, f]: tests EPS axiom D1 -- f is monotone iff for every
   v before w on path1 with non-empty images, max position of f(v) on path2
   is <= min position of f(w).                                                *)

MonotoneQ[ path1_List, path2_List, f_Association ] :=
  Module[ { codomainPos, imagePositions, orderedVertices },
    codomainPos    = AssociationThread[ path2, Range @ Length @ path2 ];
    imagePositions = Map[
      targets |-> If[ targets === {} || targets === { {} }, {},
        Sort[ codomainPos /@ Flatten @ { targets } ] ],
      f
    ];
    orderedVertices = Select[ path1, MemberQ[ Keys @ imagePositions, # ] & ];
    And @@ Flatten @ Table[
      With[
        {
          posI = imagePositions[ orderedVertices[[ i ]] ],
          posJ = imagePositions[ orderedVertices[[ j ]] ]
        },
        If[ posI === {} || posJ === {}, True, Max @ posI <= Min @ posJ ]
      ],
      { i, Length @ orderedVertices - 1 },
      { j, i + 1, Length @ orderedVertices }
    ]
  ]


(* =========================== Internal helper =========================== *)

(* composeEcho: compose one m12 with one m21 to get an echo map on path1, and
   keep it only if monotone.  Top-level helper to remove the nested Module
   inside FindEchoFunction's Table.                                           *)

PackageScope[ composeEcho ]
composeEcho[ path1_List, m12_Association, m21_Association ] :=
  With[
    {
      echo = Select[
        Association @ Map[
          v |-> v -> { Lookup[ m21, Lookup[ m12, v, Nothing ], Nothing ] },
          path1
        ],
        # =!= { Nothing } &
      ]
    },
    If[ MonotoneQ[ path1, path1, echo ], echo, Nothing ]
  ]
