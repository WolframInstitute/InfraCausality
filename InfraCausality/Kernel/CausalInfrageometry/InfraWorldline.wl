Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: InfraWorldline *)

Options[ RandomInfraWorldline ] = { "NextVertexFunction" -> Automatic }

Options[ RandomInfraObserver ] = { "NextVertexFunction" -> Automatic }

PackageScope[ chainSample ]

PackageScope[ chainLengths ]

chainLengths[ dag_Graph ] :=
  With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
    { lengths = Fold[
        { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
          { { } -> { 0 }, ps_ :> Union @@ ( Lookup[ a, Key /@ ps ] + 1 ) } ] ],
        <| |>, TopologicalSort @ dag ] },
    Replace[ Union @@ Lookup[ lengths, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ], { one_ } :> one ] ]

chainSample[ dag_Graph, count_, nextFn_ ] :=
  With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ],
          sources = Sort @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ],
          sinks = Sort @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ],
          cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { beta = Fold[
        { a, w } |-> Append[ a, w -> Replace[ Lookup[ out, Key @ w, { } ],
          { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ],
        <| |>, Reverse @ TopologicalSort @ dag ] },
    { cardinality = Total @ Lookup[ beta, Key /@ sources ],
      draw = ignored |-> NestWhile[
        path |-> With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
          Append[ path, RandomChoice[ Lookup[ beta, Key /@ nexts ] -> nexts ] ] ],
        { RandomChoice[ Lookup[ beta, Key /@ sources ] -> sources ] },
        path |-> Lookup[ out, Key @ Last @ path, { } ] =!= { } ],
      paths = ignored |-> Catenate @ Catenate @ Outer[
        If[ #1 === #2, { { #1 } }, FindPath[ dag, #1, #2, Infinity, All ] ] &, sources, sinks, 1 ],
      enumerate = { starts, limit } |-> Catenate @ Last @ Reap @ NestWhile[
        Apply[ { stack, got } |-> With[ { path = First @ stack },
          { nexts = Sort @ Lookup[ out, Key @ Last @ path, { } ] },
          { selected = If[ nexts === { } || nextFn === Automatic, nexts,
              Replace[ nextFn @ nexts, candidate_ /; MemberQ[ nexts, Verbatim @ candidate ] :> { candidate } ] ] },
          If[ nexts === { },
            ( Sow[ path ]; { Rest @ stack, got + 1 } ),
            { Join[ Append[ path, # ] & /@ selected, Rest @ stack ], got } ] ] ],
        { starts, 0 },
        state |-> First @ state =!= { } && Last @ state < limit ] },
    { distinct = generate |-> First @ NestWhile[
        state |-> With[ { member = generate[ Null ] },
          If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
        { { }, 0 },
        Last @ # < If[ MatchQ[ count, _UpTo ], Min[ cap, cardinality ], cap ] & ] },
    { members = Which[
        cardinality == 0, { },
        count === Automatic && nextFn === Automatic, { draw[ Null ] },
        nextFn === RandomChoice,
          If[ cap > cardinality && ! MatchQ[ count, _UpTo ], { },
            distinct[ ignored |-> First[ enumerate[ { { RandomChoice @ sources } }, 1 ], { } ] ] ],
        nextFn =!= Automatic, enumerate[ List /@ sources, cap ],
        count === All, paths[ Null ],
        cap > cardinality && ! MatchQ[ count, _UpTo ], { },
        2 cap >= cardinality, RandomSample[ paths[ Null ], count ],
        True, distinct[ draw ] ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     If[ nextFn === Automatic, members, Take[ members, count ] ],
      _,         If[ Length @ members < count, { }, Take[ members, count ] ] ] ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ p_, q_ ], "Graph" ] :=
  With[ { interval = Subgraph[ graph, Intersection[ VertexOutComponent[ graph, { p } ], VertexInComponent[ graph, { q } ] ] ] },
    { up = UniversalTime @ interval, down = UniversalTime @ ReverseGraph @ interval },
    { carriers = Select[ VertexList @ interval, up[ # ] + down[ # ] == Lookup[ up, Key @ q ] & ] },
    Graph[ carriers, Select[ EdgeList @ Subgraph[ interval, carriers ], up[ Last @ # ] == up[ First @ # ] + 1 & ] ] ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ ], "Graph" ] :=
  With[ { up = UniversalTime @ graph, down = UniversalTime @ ReverseGraph @ graph },
    { carriers = Select[ VertexList @ graph, up[ # ] + down[ # ] == Max[ 0, Values @ up ] & ] },
    Graph[ carriers, Select[ EdgeList @ Subgraph[ graph, carriers ], up[ Last @ # ] == up[ First @ # ] + 1 & ] ] ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ p_, q_ ], "Length" ] :=
  Lookup[ UniversalTime @ Subgraph[ graph, Intersection[ VertexOutComponent[ graph, { p } ], VertexInComponent[ graph, { q } ] ] ],
    Key @ q, - Infinity ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ ], "Length" ] :=
  Max[ 0, Values @ UniversalTime @ graph ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ p_ ], "Graph" ] :=
  With[ { future = Subgraph[ graph, VertexOutComponent[ graph, { p } ] ] },
    { up = UniversalTime @ future, down = UniversalTime @ ReverseGraph @ future },
    { carriers = Select[ VertexList @ future, up[ # ] + down[ # ] == Max @ Values @ up & ] },
    Graph[ carriers, Select[ EdgeList @ Subgraph[ future, carriers ], up[ Last @ # ] == up[ First @ # ] + 1 & ] ] ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ p_ ], "Length" ] :=
  Max @ Values @ UniversalTime @ Subgraph[ graph, VertexOutComponent[ graph, { p } ] ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ knots : Repeated[ _, { 3, Infinity } ] ], "Graph" ] :=
  With[ { legs = InfraMeasurement[ graph, InfraWorldline @@ #, "Graph" ] & /@ Partition[ { knots }, 2, 1 ] },
    If[ AnyTrue[ legs, VertexCount @ # == 0 & ], Graph[ { }, { } ],
      Graph[ DeleteDuplicates @ Catenate[ VertexList /@ legs ], Catenate[ EdgeList /@ legs ] ] ] ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ knots : Repeated[ _, { 3, Infinity } ] ], "Length" ] :=
  Total[ InfraMeasurement[ graph, InfraWorldline @@ #, "Length" ] & /@ Partition[ { knots }, 2, 1 ] ]

InfraWorldline /: InfraMeasurement[ _Graph, _InfraWorldline, "Faithful" ] :=
  True

InfraWorldline /: InfraMeasurement[ graph_Graph, worldline_InfraWorldline, All ] :=
  InfraMeasurement[ graph, worldline,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

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

RandomInfraWorldline[ graph_Graph, worldline_InfraWorldline,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraWorldline ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraWorldline, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  chainSample[ InfraMeasurement[ graph, worldline, "Graph" ], count,
    OptionValue[ RandomInfraWorldline, { opts }, "NextVertexFunction" ] ]

RandomInfraWorldline[ graph_Graph,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraWorldline ], First /@ { opts } ] :=
  RandomInfraWorldline[ graph, InfraWorldline[ ], count, opts ]

RandomInfraWorldline[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    VertexQ[ graph, p ] && VertexQ[ graph, q ] && SubsetQ[ First /@ Options[ RandomInfraWorldline ], First /@ { opts } ] :=
  RandomInfraWorldline[ graph, InfraWorldline[ p, q ], count, opts ]

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

InfraChainQ[ graph_Graph, chains : { __List } ] /; ! AllTrue[ chains, VertexQ[ graph, # ] & ] :=
  AllTrue[ chains, InfraChainQ[ graph, # ] & ]

InfraChainQ[ graph_Graph, chain_List ] :=
  chain =!= { } && AllTrue[ chain, VertexQ[ graph, # ] & ] && DuplicateFreeQ @ chain &&
    AllTrue[ Partition[ chain, 2, 1 ], Apply[ { u, v } |-> MemberQ[ VertexOutComponent[ graph, { u } ], v ] ] ]

InfraObserverQ[ graph_Graph, chains : { __List } ] /; ! AllTrue[ chains, VertexQ[ graph, # ] & ] :=
  AllTrue[ chains, InfraObserverQ[ graph, # ] & ]

InfraObserverQ[ graph_Graph, chain_List ] :=
  chain =!= { } && AllTrue[ chain, VertexQ[ graph, # ] & ] &&
    AllTrue[ Partition[ chain, 2, 1 ],
      Apply[ { u, v } |-> Length @ Intersection[ VertexOutComponent[ graph, { u } ], VertexInComponent[ graph, { v } ] ] == 2 ] ]

InfraWorldlineQ[ graph_Graph, chains : { __List } ] /; ! AllTrue[ chains, VertexQ[ graph, # ] & ] :=
  AllTrue[ chains, InfraWorldlineQ[ graph, # ] & ]

InfraWorldlineQ[ graph_Graph, chain_List ] :=
  InfraObserverQ[ graph, chain ] &&
    Length @ chain - 1 == InfraMeasurement[ graph, InfraWorldline[ First @ chain, Last @ chain ], "Length" ]
