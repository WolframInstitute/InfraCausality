Package["WolframInstitute`InfraCausality`"]

(* ========================= Multi Message Function ========================= *)

MultiMessageFunction::usage =
  "MultiMessageFunction[g, path1, path2] computes the set-valued message \
function from path1 to path2: for each vertex v on path1, returns the \
list of vertices on path2 that lie on outgoing light rays from v.";

MultiMessageFunction[ g_Graph, path1_List, path2_List ] :=
  Association @ Map[
    v |-> v -> Intersection[ OutgoingLightRays[ g, v ], path2 ],
    path1
  ]


(* ========================= Find Message Function ========================= *)

FindMessageFunction::usage =
  "FindMessageFunction[g, path1, path2] returns all monotone single-valued \
message functions from path1 to path2. FindMessageFunction[g, path1, path2, n] \
returns at most n.";

FindMessageFunction[ g_Graph, path1_List, path2_List ] :=
  Module[ { fullMsg, nonEmpty, keys, valueLists, choices, all },
    fullMsg = MultiMessageFunction[ g, path1, path2 ];
    nonEmpty = Select[ fullMsg, # =!= {} & ];
    If[ Length[ nonEmpty ] == 0, Return[ {} ] ];
    keys = Keys[ nonEmpty ];
    valueLists = Values[ nonEmpty ];
    choices = Tuples[ valueLists ];
    all = Map[ AssociationThread[ keys, # ] &, choices ];
    Select[ all, MonotoneQ[ path1, path2, # ] & ]
  ]

FindMessageFunction[ g_Graph, path1_List, path2_List, n_Integer ] :=
  Take[ FindMessageFunction[ g, path1, path2 ], UpTo[ n ] ]


(* ========================= Multi Echo Function ========================= *)

MultiEchoFunction::usage =
  "MultiEchoFunction[g, path1, path2] computes the set-valued echo function \
on path1 via path2: each vertex v on path1 maps to the union of all vertices \
on path1 reachable by going to path2 via light rays and coming back.";

MultiEchoFunction[ g_Graph, path1_List, path2_List ] :=
  Module[ { msg12, msg21 },
    msg12 = MultiMessageFunction[ g, path1, path2 ];
    msg21 = MultiMessageFunction[ g, path2, path1 ];
    Association @ Map[
      v |-> v -> Union @@ Map[
        q |-> Lookup[ msg21, q, {} ],
        msg12[ v ]
      ],
      path1
    ]
  ]


(* ========================= Find Echo Function ========================= *)

FindEchoFunction::usage =
  "FindEchoFunction[g, path1, path2] returns all monotone single-valued echo \
functions on path1 via path2. FindEchoFunction[g, path1, path2, n] returns at \
most n. Option \"MonotoneMessages\" -> True restricts to compositions of \
monotone message functions.";

Options[ FindEchoFunction ] = { "MonotoneMessages" -> False };

FindEchoFunction[ g_Graph, path1_List, path2_List, opts:OptionsPattern[] ] :=
  Module[ { fullMsg12, fullMsg21, nonEmpty12, nonEmpty21,
            keys12, vals12, keys21, vals21,
            choices12, choices21, all12, all21, results },
    fullMsg12 = MultiMessageFunction[ g, path1, path2 ];
    fullMsg21 = MultiMessageFunction[ g, path2, path1 ];
    nonEmpty12 = Select[ fullMsg12, # =!= {} & ];
    nonEmpty21 = Select[ fullMsg21, # =!= {} & ];
    If[ Length[ nonEmpty12 ] == 0 || Length[ nonEmpty21 ] == 0, Return[ {} ] ];
    keys12 = Keys[ nonEmpty12 ]; vals12 = Values[ nonEmpty12 ];
    keys21 = Keys[ nonEmpty21 ]; vals21 = Values[ nonEmpty21 ];
    choices12 = Tuples[ vals12 ];
    choices21 = Tuples[ vals21 ];
    all12 = Map[ AssociationThread[ keys12, # ] &, choices12 ];
    all21 = Map[ AssociationThread[ keys21, # ] &, choices21 ];
    If[ TrueQ[ OptionValue[ "MonotoneMessages" ] ],
      all12 = Select[ all12, MonotoneQ[ path1, path2, # ] & ];
      all21 = Select[ all21, MonotoneQ[ path2, path1, # ] & ]
    ];
    results = Flatten[ Table[
      Module[ { echo },
        echo = Association @ Map[
          v |-> v -> { Lookup[ m21, Lookup[ m12, v, Nothing ], Nothing ] },
          path1
        ];
        echo = Select[ echo, # =!= { Nothing } & ];
        If[ MonotoneQ[ path1, path1, echo ], echo, Nothing ]
      ],
      { m12, all12 }, { m21, all21 }
    ], 1 ];
    DeleteDuplicates[ results ]
  ]

FindEchoFunction[ g_Graph, path1_List, path2_List, n_Integer, opts:OptionsPattern[] ] :=
  Take[ FindEchoFunction[ g, path1, path2, opts ], UpTo[ n ] ]


(* ========================= Echo Graph ========================= *)

EchoGraph::usage =
  "EchoGraph[echoFn] builds a directed graph from an echo function \
Association, where edges go from each vertex to its echo images. Works \
with both multi-valued and single-valued echo functions.";

EchoGraph[ echoFn_Association ] :=
  Graph[
    Keys[ echoFn ],
    Flatten @ KeyValueMap[
      { v, targets } |-> (DirectedEdge[ v, # ] & /@ Flatten[ { targets } ]),
      echoFn
    ]
  ]


(* ========================= Monotonicity Check ========================= *)

MonotoneQ::usage =
  "MonotoneQ[path1, path2, f] checks if the association f is \
order-preserving from path1 to path2. Returns True if for all v before \
w on path1, Max positions of f[v] on path2 <= Min positions of f[w] on \
path2. For echo functions use MonotoneQ[path, path, echoFn].";

MonotoneQ[ path1_List, path2_List, f_Association ] :=
  Module[ { domainPos, codomainPos, imagePositions, orderedVertices },
    domainPos = AssociationThread[ path1, Range @ Length @ path1 ];
    codomainPos = AssociationThread[ path2, Range @ Length @ path2 ];
    imagePositions = Map[
      targets |-> If[ targets === {} || targets === {{}}, {},
        Sort[ codomainPos /@ Flatten[ { targets } ] ]
      ],
      f
    ];
    orderedVertices = Select[ path1, MemberQ[ Keys[ imagePositions ], # ] & ];
    And @@ Flatten @ Table[
      With[ {
        posI = imagePositions[ orderedVertices[[ i ]] ],
        posJ = imagePositions[ orderedVertices[[ j ]] ]
      },
        If[ posI === {} || posJ === {}, True,
          Max[ posI ] <= Min[ posJ ]
        ]
      ],
      { i, Length[ orderedVertices ] - 1 },
      { j, i + 1, Length[ orderedVertices ] }
    ]
  ]
