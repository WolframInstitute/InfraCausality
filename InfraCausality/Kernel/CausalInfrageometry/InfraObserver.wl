Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: InfraObserver *)

Options[ RandomInfraObserver ] = { "NextVertexFunction" -> Automatic }

PackageScope[ chainLengths ]

chainLengths[ dag_Graph ] :=
  With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
    { lengths = Fold[
        { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
          { { } -> { 0 }, ps_ :> Union @@ ( Lookup[ a, Key /@ ps ] + 1 ) } ] ],
        <| |>, TopologicalSort @ dag ] },
    Replace[ Union @@ Lookup[ lengths, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ], { one_ } :> one ] ]

InfraObserver /: InfraMeasurement[ graph_Graph, InfraObserver[ p_, q_ ], "Graph" ] :=
  TransitiveReductionGraph @ Subgraph[ graph, Intersection[ VertexOutComponent[ graph, { p } ], VertexInComponent[ graph, { q } ] ] ]

InfraObserver /: InfraMeasurement[ graph_Graph, InfraObserver[ ], "Graph" ] :=
  TransitiveReductionGraph @ graph

InfraObserver /: InfraMeasurement[ graph_Graph, observer_InfraObserver, "Length" ] :=
  chainLengths @ InfraMeasurement[ graph, observer, "Graph" ]

InfraObserver /: InfraMeasurement[ _Graph, _InfraObserver, "Faithful" ] :=
  True

InfraObserver /: InfraMeasurement[ graph_Graph, observer_InfraObserver, All ] :=
  InfraMeasurement[ graph, observer,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraObserver[ graph_Graph, observer_InfraObserver,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraObserver ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraObserver, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  chainSample[ InfraMeasurement[ graph, observer, "Graph" ], count,
    OptionValue[ RandomInfraObserver, { opts }, "NextVertexFunction" ] ]

RandomInfraObserver[ graph_Graph,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraObserver ], First /@ { opts } ] :=
  RandomInfraObserver[ graph, InfraObserver[ ], count, opts ]

RandomInfraObserver[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    VertexQ[ graph, p ] && VertexQ[ graph, q ] && SubsetQ[ First /@ Options[ RandomInfraObserver ], First /@ { opts } ] :=
  RandomInfraObserver[ graph, InfraObserver[ p, q ], count, opts ]

InfraObserverQ[ graph_Graph, chains : { __List } ] /; ! AllTrue[ chains, VertexQ[ graph, # ] & ] :=
  AllTrue[ chains, InfraObserverQ[ graph, # ] & ]

InfraObserverQ[ graph_Graph, chain_List ] :=
  chain =!= { } && AllTrue[ chain, VertexQ[ graph, # ] & ] &&
    AllTrue[ Partition[ chain, 2, 1 ],
      Apply[ { u, v } |-> Length @ Intersection[ VertexOutComponent[ graph, { u } ], VertexInComponent[ graph, { v } ] ] == 2 ] ]
