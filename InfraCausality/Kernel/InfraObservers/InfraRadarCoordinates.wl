Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: InfraObservers :: InfraRadarCoordinates *)

PackageScope[ radarTicks ]

PackageScope[ observerListQ ]

PackageScope[ radarPosition ]

radarTicks[ graph_Graph, a_List ] :=
  With[ { futures = VertexOutComponent[ graph, { # } ] & /@ a, pasts = VertexInComponent[ graph, { # } ] & /@ a },
    { domain = Intersection[ First @ futures, Last @ pasts ] },
    KeySort @ AssociationMap[
      e |-> { Max @ Pick[ Range @ Length @ a, MemberQ[ #, e ] & /@ futures ], Min @ Pick[ Range @ Length @ a, MemberQ[ #, e ] & /@ pasts ] },
      domain ] ]

observerListQ[ graph_Graph, observers : { __List } ] :=
  ! AllTrue[ observers, VertexQ[ graph, # ] & ]

observerListQ[ _Graph, _ ] :=
  False

radarPosition[ c_List ] :=
  c[[ { 2, 1 } ]]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, InfraRadarCoordinates[ observers_ ], "Coordinates" ] /; observerListQ[ graph, observers ] :=
  With[ { charts = InfraMeasurement[ graph, InfraRadarCoordinates[ # ], "Coordinates" ] & /@ observers },
    { domain = Intersection @@ Keys /@ charts },
    KeySort @ AssociationMap[ e |-> Catenate[ #[ e ] & /@ charts ], domain ] ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, InfraRadarCoordinates[ a_List ], "Coordinates" ] :=
  Map[ Apply[ { i, j } |-> { ( i + j ) / 2, ( j - i ) / 2 } ], radarTicks[ graph, a ] ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, InfraRadarCoordinates[ observers_ ], "Time" ] /; observerListQ[ graph, observers ] :=
  Map[ #[[ 1 ;; ;; 2 ]] &, InfraMeasurement[ graph, InfraRadarCoordinates[ observers ], "Coordinates" ] ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, InfraRadarCoordinates[ a_List ], "Time" ] :=
  Map[ Mean, radarTicks[ graph, a ] ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, InfraRadarCoordinates[ observers_ ], "Distance" ] /; observerListQ[ graph, observers ] :=
  Map[ #[[ 2 ;; ;; 2 ]] &, InfraMeasurement[ graph, InfraRadarCoordinates[ observers ], "Coordinates" ] ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, InfraRadarCoordinates[ a_List ], "Distance" ] :=
  Map[ Apply[ { i, j } |-> ( j - i ) / 2 ], radarTicks[ graph, a ] ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, chart_InfraRadarCoordinates, "Domain" ] :=
  Keys @ InfraMeasurement[ graph, chart, "Coordinates" ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, chart_InfraRadarCoordinates, "VertexDensity" ] :=
  AssociationThread[ InfraMeasurement[ graph, chart, "Domain" ], 1 ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, chart_InfraRadarCoordinates, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, InfraMeasurement[ graph, chart, "Domain" ] ], 1 ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, chart_InfraRadarCoordinates, "Subgraph" ] :=
  With[ { coords = InfraMeasurement[ graph, chart, "Coordinates" ] },
    Subgraph[ graph, Keys @ coords, VertexCoordinates -> Normal[ radarPosition /@ coords ] ] ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, chart_InfraRadarCoordinates, "BaseGraph" ] :=
  With[ { coords = InfraMeasurement[ graph, chart, "Coordinates" ] },
    { cells = DeleteDuplicates @ Values @ coords },
    Graph[ cells,
      DeleteDuplicates @ Select[ DirectedEdge @@ ( coords /@ List @@ # ) & /@ EdgeList @ Subgraph[ graph, Keys @ coords ], Apply[ UnsameQ ] ],
      VertexCoordinates -> ( # -> radarPosition @ # & /@ cells ),
      Sequence @@ FilterRules[ CausalSubstrateStyle[ "Small" ], { VertexStyle, EdgeStyle, VertexSize } ] ] ]

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, chart_InfraRadarCoordinates, "Fibration" ] :=
  InfraFibration[ UndirectedGraph @ InfraMeasurement[ graph, chart, "Subgraph" ], InfraMeasurement[ graph, chart, "Coordinates" ] ]

InfraRadarCoordinates /: InfraMeasurement[ _Graph, _InfraRadarCoordinates, "Faithful" ] :=
  True

InfraRadarCoordinates /: InfraMeasurement[ graph_Graph, chart_InfraRadarCoordinates, All ] :=
  InfraMeasurement[ graph, chart,
    { "Coordinates", "Time", "Distance", "Domain", "VertexDensity", "EdgeDensity", "Subgraph", "BaseGraph", "Fibration", "Faithful" } ]

InfraRadarCoordinates /: InfraMemberQ[ graph_Graph, chart_InfraRadarCoordinates, e_ ] :=
  MemberQ[ InfraMeasurement[ graph, chart, "Domain" ], e ]
