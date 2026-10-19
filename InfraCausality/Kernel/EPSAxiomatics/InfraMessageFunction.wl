Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: EPSAxiomatics :: InfraMessageFunction *)

PackageScope[ messageRelation ]

PackageScope[ messageDomain ]

PackageScope[ selectionDAG ]

PackageScope[ monotoneSelections ]

PackageScope[ echoCompositions ]

messageRelation[ graph_Graph, a_List, b_List ] :=
  AssociationMap[
    v |-> With[ { null = VertexList @ InfraMeasurement[ graph, InfraFutureLightCone[ v ], "Graph" ] },
      Select[ b, w |-> MemberQ[ null, w ] ] ],
    a ]

messageDomain[ graph_Graph, a_List, b_List ] :=
  Select[ messageRelation[ graph, a, b ], # =!= { } & ]

selectionDAG[ relation_Association, b_List ] :=
  With[ { layers = Values @ Select[ relation, # =!= { } & ], position = AssociationThread[ b, Range @ Length @ b ] },
    { nodes = Join[ { { { 0 } } }, MapIndexed[ { ws, k } |-> ( { First @ k, # } & /@ ws ), layers ], { { { Length @ layers + 1 } } } ] },
    { dag = Graph[ Catenate @ nodes, Catenate @ MapThread[
        { lower, upper } |-> DirectedEdge @@@ Select[ Tuples[ { lower, upper } ],
          Apply[ { m, n } |-> Length @ m == 1 || Length @ n == 1 || Lookup[ position, Key @ Last @ m ] <= Lookup[ position, Key @ Last @ n ] ] ],
        { Most @ nodes, Rest @ nodes } ] ] },
    Subgraph[ dag, Intersection[ VertexOutComponent[ dag, { { 0 } } ], VertexInComponent[ dag, { { Length @ layers + 1 } } ] ] ] ]

monotoneSelections[ relation_Association, b_List ] :=
  With[ { dag = selectionDAG[ relation, b ] },
    AssociationThread[ Keys @ relation, Last /@ Take[ #, { 2, -2 } ] ] & /@
      FindPath[ dag, { 0 }, { Length @ relation + 1 }, Infinity, All ] ]

echoCompositions[ graph_Graph, a_List, b_List ] :=
  With[ { there = monotoneSelections[ messageDomain[ graph, a, b ], b ], back = monotoneSelections[ messageDomain[ graph, b, a ], a ] },
    DeleteDuplicates @ Catenate @ Outer[ { s, t } |-> DeleteMissing[ Lookup[ t, Key @ # ] & /@ s ], there, back, 1 ] ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ], "Relation" ] :=
  messageRelation[ graph, a, b ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ], "Graph" ] :=
  Graph[ DeleteDuplicates @ Join[ a, b ],
    Catenate @ KeyValueMap[ { v, ws } |-> ( DirectedEdge[ v, # ] & /@ ws ), messageRelation[ graph, a, b ] ] ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ], "SelectionGraph" ] :=
  selectionDAG[ messageDomain[ graph, a, b ], b ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ], "Cardinality" ] :=
  With[ { position = AssociationThread[ b, Range @ Length @ b ] },
    Total @ Fold[
      { counts, ws } |-> AssociationMap[
        w |-> Total @ KeySelect[ counts, u |-> Lookup[ position, Key @ u, 0 ] <= Lookup[ position, Key @ w ] ], ws ],
      <| Missing[ "Start" ] -> 1 |>,
      Values @ messageDomain[ graph, a, b ] ] ]

InfraMessageFunction /: InfraMeasurement[ _Graph, _InfraMessageFunction, "Faithful" ] :=
  True

InfraMessageFunction /: InfraMeasurement[ graph_Graph, message_InfraMessageFunction, All ] :=
  InfraMeasurement[ graph, message, { "Relation", "Graph", "SelectionGraph", "Cardinality", "Faithful" } ]

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

InfraEchoFunction /: InfraMemberQ[ graph_Graph, echo_InfraEchoFunction, f_Association ] :=
  InfraEchoFunctionQ[ graph, echo, f ]

InfraMessageFunctionQ[ graph_Graph, InfraMessageFunction[ a_List, b_List ], f_Association ] :=
  With[ { relation = messageDomain[ graph, a, b ], position = AssociationThread[ b, Range @ Length @ b ] },
    Sort @ Keys @ f === Sort @ Keys @ relation &&
      AllTrue[ Keys @ relation, v |-> MemberQ[ Lookup[ relation, Key @ v ], Lookup[ f, Key @ v ] ] ] &&
      LessEqual @@ Lookup[ position, Key /@ Lookup[ f, Key /@ Keys @ relation ] ] ]

InfraEchoFunctionQ[ graph_Graph, InfraEchoFunction[ a_List, b_List ], f_Association ] :=
  With[ { there = messageDomain[ graph, a, b ], back = messageRelation[ graph, b, a ],
          position = AssociationThread[ a, Range @ Length @ a ], order = AssociationThread[ b, Range @ Length @ b ] },
    { ticks = Select[ Keys @ there, v |-> KeyExistsQ[ f, v ] ],
      value = v |-> Lookup[ f, Key @ v, None ],
      admissible = { v, w } |-> If[ KeyExistsQ[ f, v ], MemberQ[ Lookup[ back, Key @ w ], Lookup[ f, Key @ v ] ], Lookup[ back, Key @ w ] === { } ] },
    { layers = KeyValueMap[ { v, ws } |-> { v, Select[ ws, w |-> admissible[ v, w ] ] }, there ] },
    Length @ ticks == Length @ f && SubsetQ[ a, Values @ f ] &&
      LessEqual @@ Lookup[ position, Key /@ Lookup[ f, Key /@ ticks ] ] &&
      ( layers === { } || Last @ Fold[
          { state, layer } |-> { First @ layer, Select[ Last @ layer, w |-> AnyTrue[ Last @ state, u |->
            Lookup[ order, Key @ u ] < Lookup[ order, Key @ w ] || u === w && value @ First @ state === value @ First @ layer ] ] },
          First @ layers, Rest @ layers ] =!= { } ) ]
