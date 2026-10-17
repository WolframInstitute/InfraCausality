Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: InfraObservers :: InfraMessageFunction *)

PackageScope[ messageRelation ]

PackageScope[ selectionDAG ]

PackageScope[ echoCompositions ]

messageRelation[ graph_Graph, a_List, b_List ] :=
  AssociationMap[
    v |-> With[ { null = VertexList @ InfraMeasurement[ graph, InfraFutureLightCone[ v ], "Graph" ] },
      Select[ b, w |-> MemberQ[ null, w ] ] ],
    a ]

selectionDAG[ relation_Association, b_List ] :=
  With[ { layers = Values @ Select[ relation, # =!= { } & ], position = AssociationThread[ b, Range @ Length @ b ] },
    { nodes = Join[ { { { 0 } } }, MapIndexed[ { ws, k } |-> ( { First @ k, # } & /@ ws ), layers ], { { { Length @ layers + 1 } } } ] },
    { dag = Graph[ Catenate @ nodes, Catenate @ MapThread[
        { lower, upper } |-> DirectedEdge @@@ Select[ Tuples[ { lower, upper } ],
          Apply[ { m, n } |-> Length @ m == 1 || Length @ n == 1 || Lookup[ position, Key @ Last @ m ] <= Lookup[ position, Key @ Last @ n ] ] ],
        { Most @ nodes, Rest @ nodes } ] ] },
    Subgraph[ dag, Intersection[ VertexOutComponent[ dag, { { 0 } } ], VertexInComponent[ dag, { { Length @ layers + 1 } } ] ] ] ]

echoCompositions[ graph_Graph, a_List, b_List ] :=
  With[ { ab = Select[ messageRelation[ graph, a, b ], # =!= { } & ],
          ba = Select[ messageRelation[ graph, b, a ], # =!= { } & ],
          position = AssociationThread[ a, Range @ Length @ a ] },
    Select[
      DeleteDuplicates @ Catenate @ Map[
        s |-> With[ { hits = Select[ DeleteDuplicates @ Values @ s, w |-> MemberQ[ Keys @ ba, w ] ] },
          Map[ t |-> DeleteMissing @ Map[ w |-> Lookup[ t, Key @ w ], s ],
            AssociationThread[ hits, # ] & /@ Tuples @ Lookup[ ba, Key /@ hits ] ] ],
        AssociationThread[ Keys @ ab, # ] & /@ Tuples @ Values @ ab ],
      e |-> LessEqual @@ Lookup[ position, Key /@ Values @ e ] ] ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ], "Relation" ] :=
  messageRelation[ graph, a, b ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ], "Graph" ] :=
  Graph[ DeleteDuplicates @ Join[ a, b ],
    Catenate @ KeyValueMap[ { v, ws } |-> ( DirectedEdge[ v, # ] & /@ ws ), messageRelation[ graph, a, b ] ] ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ], "Cardinality" ] :=
  With[ { position = AssociationThread[ b, Range @ Length @ b ] },
    Total @ Fold[
      { counts, ws } |-> AssociationMap[
        w |-> Total @ KeySelect[ counts, u |-> Lookup[ position, Key @ u, 0 ] <= Lookup[ position, Key @ w ] ], ws ],
      <| Missing[ "Start" ] -> 1 |>,
      Values @ Select[ messageRelation[ graph, a, b ], # =!= { } & ] ] ]

InfraMessageFunction /: InfraMeasurement[ _Graph, _InfraMessageFunction, "Faithful" ] :=
  True

InfraMessageFunction /: InfraMeasurement[ graph_Graph, message_InfraMessageFunction, All ] :=
  InfraMeasurement[ graph, message, { "Relation", "Graph", "Cardinality", "Faithful" } ]

InfraMessageFunction /: InfraMemberQ[ graph_Graph, message_InfraMessageFunction, f_Association ] :=
  InfraMessageFunctionQ[ graph, message, f ]

InfraEchoFunction /: InfraMeasurement[ graph_Graph, InfraEchoFunction[ a_List, b_List ], "Relation" ] :=
  With[ { ab = messageRelation[ graph, a, b ], ba = messageRelation[ graph, b, a ] },
    AssociationMap[ v |-> With[ { echoes = Catenate @ Lookup[ ba, Key /@ Lookup[ ab, Key @ v ] ] },
      Select[ a, u |-> MemberQ[ echoes, u ] ] ], a ] ]

InfraEchoFunction /: InfraMeasurement[ graph_Graph, echo : InfraEchoFunction[ a_List, _List ], "Graph" ] :=
  Graph[ a, Catenate @ KeyValueMap[ { v, us } |-> ( DirectedEdge[ v, # ] & /@ us ), InfraMeasurement[ graph, echo, "Relation" ] ] ]

InfraEchoFunction /: InfraMeasurement[ graph_Graph, InfraEchoFunction[ a_List, b_List ], "Cardinality" ] :=
  Length @ echoCompositions[ graph, a, b ]

InfraEchoFunction /: InfraMeasurement[ _Graph, _InfraEchoFunction, "Faithful" ] :=
  True

InfraEchoFunction /: InfraMeasurement[ graph_Graph, echo_InfraEchoFunction, All ] :=
  InfraMeasurement[ graph, echo, { "Relation", "Graph", "Cardinality", "Faithful" } ]

InfraEchoFunction /: InfraMemberQ[ graph_Graph, InfraEchoFunction[ a_List, b_List ], f_Association ] :=
  MemberQ[ KeySort /@ echoCompositions[ graph, a, b ], KeySort @ f ]

InfraMessageFunctionQ[ graph_Graph, InfraMessageFunction[ a_List, b_List ], f_Association ] :=
  With[ { relation = Select[ messageRelation[ graph, a, b ], # =!= { } & ], position = AssociationThread[ b, Range @ Length @ b ] },
    Sort @ Keys @ f === Sort @ Keys @ relation &&
      AllTrue[ Keys @ relation, v |-> MemberQ[ Lookup[ relation, Key @ v ], Lookup[ f, Key @ v ] ] ] &&
      LessEqual @@ Lookup[ position, Key /@ Lookup[ f, Key /@ Keys @ relation ] ] ]

InfraEchoFunctionQ[ graph_Graph, echo : InfraEchoFunction[ a_List, _List ], f_Association ] :=
  With[ { relation = InfraMeasurement[ graph, echo, "Relation" ], position = AssociationThread[ a, Range @ Length @ a ] },
    { ticks = Select[ a, v |-> MemberQ[ Keys @ f, v ] ] },
    Length @ ticks == Length @ f &&
      AllTrue[ ticks, v |-> MemberQ[ Lookup[ relation, Key @ v ], Lookup[ f, Key @ v ] ] ] &&
      LessEqual @@ Lookup[ position, Key /@ Lookup[ f, Key /@ ticks ] ] ]
