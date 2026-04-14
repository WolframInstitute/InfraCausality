Package["WolframInstitute`InfraCausality`"]

(* ========================= Light Cones ========================= *)

ForwardLightCone[ g_, v_List, len_ : Infinity ] :=
  VertexOutComponentGraph[ g, v, len ]
ForwardLightCone[ g_, v_, len_ : Infinity ] :=
  ForwardLightCone[ g, { v }, len ]

BackwardLightCone[ g_, v_List, len_ : Infinity ] :=
  VertexInComponentGraph[ g, v, len ]
BackwardLightCone[ g_, v_, len_ : Infinity ] :=
  BackwardLightCone[ g, { v }, len ]

CausalInterval[ g_, v1_, v2_, len_ : Infinity ] :=
  Subgraph[ g,
    Intersection @@ (VertexList /@ { ForwardLightCone[ g, v1, len ],
      BackwardLightCone[ g, v2, len ] }) ]

ChainCausalInterval[ g_, c_ ] :=
  Intersection[ VertexList @ ForwardLightCone[ g, c ],
    VertexList @ BackwardLightCone[ g, c ] ]

(* ========================= Proper Time ========================= *)

LongestPathFoliation[ g_Graph ] :=
  Module[ { sources, negDistMatrix, grouped },
    sources = GetSources[ g ];
    negDistMatrix = -GraphDistanceMatrix[
      Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount[ g ] ] ]
    ];
    grouped = GroupBy[
      Normal @ AssociationThread[
        VertexList[ g ] -> MapThread[ Min, negDistMatrix[[ VertexIndex[ g, sources ], All ]] ]
      ],
      Last -> First
    ];
    Values[ KeySort[ grouped ] ]
  ]

ProperTime[ g_Graph, foliation_List ] :=
  Association @ Catenate @ MapIndexed[
    { slice, idx } |-> Map[ # -> First[ idx ] - 1 &, slice ],
    foliation
  ]

ProperTime[ g_Graph ] := ProperTime[ g, LongestPathFoliation[ g ] ]

MostAbsorbers[ g_ ] :=
  KeySort @
    GroupBy[ Normal @ ProperTime @ g, Last -> First,
      MaximalBy[ #, p |-> Length @ BackwardLightCone[ g, p ] ] & ]

(* ========================= Light Rays ========================= *)

OutgoingLightRays[ g_, v_ ] :=
  Module[ { forwardCone, vertices, coords, volumes },
    forwardCone = ForwardLightCone[ g, v ];
    coords = ProperTime[ forwardCone ];
    vertices = VertexList[ forwardCone ];
    volumes =
      AssociationMap[ VertexCount @ BackwardLightCone[ forwardCone, # ] &,
        vertices ];
    Select[ vertices, coords[ # ] + 1 == volumes[ # ] & ]
  ]

IncomingLightRays[ g_, v_ ] :=
  Module[ { backwardCone, vertices, coords, volumes },
    backwardCone = BackwardLightCone[ g, v ];
    coords = ProperTime[ ReverseGraph @ backwardCone ];
    vertices = VertexList[ backwardCone ];
    volumes =
      AssociationMap[ VertexCount @ ForwardLightCone[ backwardCone, # ] &,
        vertices ];
    Select[ vertices, coords[ # ] + 1 == volumes[ # ] & ]
  ]
