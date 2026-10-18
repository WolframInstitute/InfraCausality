Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: InfraObservers :: InfraRadarChart *)

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

InfraRadarChart /: InfraMeasurement[ graph_Graph, InfraRadarChart[ observers_ ], "Coordinates" ] /; observerListQ[ graph, observers ] :=
  With[ { charts = InfraMeasurement[ graph, InfraRadarChart[ # ], "Coordinates" ] & /@ observers },
    { domain = Intersection @@ Keys /@ charts },
    KeySort @ AssociationMap[ e |-> Catenate[ #[ e ] & /@ charts ], domain ] ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, InfraRadarChart[ a_List ], "Coordinates" ] :=
  Map[ Apply[ { i, j } |-> { ( i + j ) / 2, ( j - i ) / 2 } ], radarTicks[ graph, a ] ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, InfraRadarChart[ observers_ ], "Time" ] /; observerListQ[ graph, observers ] :=
  Map[ #[[ 1 ;; ;; 2 ]] &, InfraMeasurement[ graph, InfraRadarChart[ observers ], "Coordinates" ] ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, InfraRadarChart[ a_List ], "Time" ] :=
  Map[ Mean, radarTicks[ graph, a ] ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, InfraRadarChart[ observers_ ], "Distance" ] /; observerListQ[ graph, observers ] :=
  Map[ #[[ 2 ;; ;; 2 ]] &, InfraMeasurement[ graph, InfraRadarChart[ observers ], "Coordinates" ] ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, InfraRadarChart[ a_List ], "Distance" ] :=
  Map[ Apply[ { i, j } |-> ( j - i ) / 2 ], radarTicks[ graph, a ] ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, chart_InfraRadarChart, "Domain" ] :=
  Keys @ InfraMeasurement[ graph, chart, "Coordinates" ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, chart_InfraRadarChart, "VertexDensity" ] :=
  AssociationThread[ InfraMeasurement[ graph, chart, "Domain" ], 1 ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, chart_InfraRadarChart, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, InfraMeasurement[ graph, chart, "Domain" ] ], 1 ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, chart_InfraRadarChart, "Subgraph" ] :=
  With[ { coords = InfraMeasurement[ graph, chart, "Coordinates" ] },
    Subgraph[ graph, Keys @ coords, VertexCoordinates -> Normal[ radarPosition /@ coords ] ] ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, chart_InfraRadarChart, "BaseGraph" ] :=
  With[ { coords = InfraMeasurement[ graph, chart, "Coordinates" ] },
    { cells = DeleteDuplicates @ Values @ coords },
    Graph[ cells,
      DeleteDuplicates @ Select[ DirectedEdge @@ ( coords /@ List @@ # ) & /@ EdgeList @ Subgraph[ graph, Keys @ coords ], Apply[ UnsameQ ] ],
      VertexCoordinates -> ( # -> radarPosition @ # & /@ cells ),
      Sequence @@ FilterRules[ CausalSubstrateStyle[ "Small" ], { VertexStyle, EdgeStyle, VertexSize } ] ] ]

InfraRadarChart /: InfraMeasurement[ graph_Graph, chart_InfraRadarChart, "Fibration" ] :=
  InfraFibration[ UndirectedGraph @ InfraMeasurement[ graph, chart, "Subgraph" ], InfraMeasurement[ graph, chart, "Coordinates" ] ]

InfraRadarChart /: InfraMeasurement[ _Graph, _InfraRadarChart, "Faithful" ] :=
  True

InfraRadarChart /: InfraMeasurement[ graph_Graph, chart_InfraRadarChart, All ] :=
  InfraMeasurement[ graph, chart,
    { "Coordinates", "Time", "Distance", "Domain", "VertexDensity", "EdgeDensity", "Subgraph", "BaseGraph", "Fibration", "Faithful" } ]

InfraRadarChart /: InfraMemberQ[ graph_Graph, chart_InfraRadarChart, e_ ] :=
  MemberQ[ InfraMeasurement[ graph, chart, "Domain" ], e ]
