Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: InfraLightCone *)

Options[ RandomInfraFutureLightCone ] = { "NextVertexFunction" -> Automatic }

Options[ RandomInfraPastLightCone ] = { "NextVertexFunction" -> Automatic }

InfraFutureLightCone /: InfraMeasurement[ graph_Graph, InfraFutureLightCone[ v_ ], "Graph" ] :=
  With[ { future = Subgraph[ graph, VertexOutComponent[ graph, { v } ] ] },
    { tau = CausalHeight @ future },
    { null = Select[ VertexList @ future, e |-> Length @ VertexInComponent[ future, { e } ] == tau[ e ] + 1 ] },
    TransitiveReductionGraph @ Subgraph[ future, null ] ]

InfraFutureLightCone /: InfraMeasurement[ _Graph, _InfraFutureLightCone, "Faithful" ] :=
  True

InfraFutureLightCone /: InfraMeasurement[ graph_Graph, cone_InfraFutureLightCone, All ] :=
  InfraMeasurement[ graph, cone,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraPastLightCone /: InfraMeasurement[ graph_Graph, InfraPastLightCone[ v_ ], "Graph" ] :=
  ReverseGraph @ InfraMeasurement[ ReverseGraph @ graph, InfraFutureLightCone[ v ], "Graph" ]

InfraPastLightCone /: InfraMeasurement[ _Graph, _InfraPastLightCone, "Faithful" ] :=
  True

InfraPastLightCone /: InfraMeasurement[ graph_Graph, cone_InfraPastLightCone, All ] :=
  InfraMeasurement[ graph, cone,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraFutureLightCone[ graph_Graph, cone_InfraFutureLightCone,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraFutureLightCone ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraFutureLightCone, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  chainSample[ InfraMeasurement[ graph, cone, "Graph" ], count,
    OptionValue[ RandomInfraFutureLightCone, { opts }, "NextVertexFunction" ] ]

RandomInfraFutureLightCone[ graph_Graph, v_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    VertexQ[ graph, v ] && SubsetQ[ First /@ Options[ RandomInfraFutureLightCone ], First /@ { opts } ] :=
  RandomInfraFutureLightCone[ graph, InfraFutureLightCone[ v ], count, opts ]

RandomInfraPastLightCone[ graph_Graph, cone_InfraPastLightCone,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraPastLightCone ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraPastLightCone, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  chainSample[ InfraMeasurement[ graph, cone, "Graph" ], count,
    OptionValue[ RandomInfraPastLightCone, { opts }, "NextVertexFunction" ] ]

RandomInfraPastLightCone[ graph_Graph, v_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    VertexQ[ graph, v ] && SubsetQ[ First /@ Options[ RandomInfraPastLightCone ], First /@ { opts } ] :=
  RandomInfraPastLightCone[ graph, InfraPastLightCone[ v ], count, opts ]

InfraLightRayQ[ graph_Graph, chains : { __List } ] /; ! AllTrue[ chains, VertexQ[ graph, # ] & ] :=
  AllTrue[ chains, InfraLightRayQ[ graph, # ] & ]

InfraLightRayQ[ graph_Graph, chain_List ] :=
  InfraWorldlineQ[ graph, chain ] &&
    Length @ chain == Length @ Intersection[ VertexOutComponent[ graph, { First @ chain } ], VertexInComponent[ graph, { Last @ chain } ] ]
