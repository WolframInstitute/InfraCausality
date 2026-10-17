Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: Tools *)


(* =========================== Graph generation =========================== *)

(* RandomConnectedDAG[{n, m}]: random connected DAG on n vertices with m edges,
   acyclically oriented from an underlying random connected undirected graph. *)

PackageScope[ RandomConnectedDAG ]
RandomConnectedDAG[ spec_, opt : OptionsPattern[ Graph ] ] :=
  Module[ { vertexCount, edgeCount, g },
    vertexCount = Max[ First @ spec, 2 ];
    edgeCount   = Clip[ Last @ spec, { vertexCount - 1, vertexCount ( vertexCount - 1 ) / 2 } ];
    g           = RandomGraph[ { vertexCount, edgeCount } ];
    While[ ! ConnectedGraphQ @ g, g = RandomGraph[ { vertexCount, edgeCount } ] ];
    Graph[ DirectedGraph[ g, "Acyclic" ], opt ]
  ]


(* RandomCausalGraph[{n, m}]: a RandomConnectedDAG styled with the causal
   palette and a layered embedding.                                          *)

RandomCausalGraph[ spec_, opt : OptionsPattern[ Graph ] ] :=
  Graph[
    RandomConnectedDAG[ spec, opt ],
    Sequence @@ CausalGraphStyle[ "Default" ],
    GraphLayout -> "LayeredDigraphEmbedding"
  ]
