Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: InfraCausalFuture *)

Options[ RandomInfraCausalFuture ] = { "NextVertexFunction" -> Automatic }

Options[ RandomInfraCausalPast ] = { "NextVertexFunction" -> Automatic }

InfraCausalFuture /: InfraMeasurement[ graph_Graph, InfraCausalFuture[ anchor_ ], "VertexDensity" ] :=
  AssociationThread[ Sort @ VertexOutComponent[ graph, Keys @ InfraDensity[ graph, anchor ] ], 1 ]

InfraCausalFuture /: InfraMeasurement[ graph_Graph, InfraCausalFuture[ anchor_, t_ ], "VertexDensity" ] :=
  With[ { future = Subgraph[ graph, VertexOutComponent[ graph, Keys @ InfraDensity[ graph, anchor ] ] ] },
    AssociationThread[ Sort @ Keys @ Select[ UniversalTime @ future, LessEqualThan[ t ] ], 1 ] ]

InfraCausalFuture /: InfraMeasurement[ graph_Graph, cone_InfraCausalFuture, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ] ], 1 ]

InfraCausalFuture /: InfraMeasurement[ _Graph, _InfraCausalFuture, "Cardinality" ] :=
  1

InfraCausalFuture /: InfraMeasurement[ _Graph, _InfraCausalFuture, "Faithful" ] :=
  True

InfraCausalFuture /: InfraMeasurement[ graph_Graph, cone_InfraCausalFuture, All ] :=
  InfraMeasurement[ graph, cone,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraCausalFuture /: InfraMemberQ[ graph_Graph, cone_InfraCausalFuture, set_List ] :=
  Sort @ set === Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ]

InfraCausalPast /: InfraMeasurement[ graph_Graph, InfraCausalPast[ anchor_ ], "VertexDensity" ] :=
  AssociationThread[ Sort @ VertexInComponent[ graph, Keys @ InfraDensity[ graph, anchor ] ], 1 ]

InfraCausalPast /: InfraMeasurement[ graph_Graph, InfraCausalPast[ anchor_, t_ ], "VertexDensity" ] :=
  InfraMeasurement[ ReverseGraph @ graph, InfraCausalFuture[ anchor, t ], "VertexDensity" ]

InfraCausalPast /: InfraMeasurement[ graph_Graph, cone_InfraCausalPast, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ] ], 1 ]

InfraCausalPast /: InfraMeasurement[ _Graph, _InfraCausalPast, "Cardinality" ] :=
  1

InfraCausalPast /: InfraMeasurement[ _Graph, _InfraCausalPast, "Faithful" ] :=
  True

InfraCausalPast /: InfraMeasurement[ graph_Graph, cone_InfraCausalPast, All ] :=
  InfraMeasurement[ graph, cone,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraCausalPast /: InfraMemberQ[ graph_Graph, cone_InfraCausalPast, set_List ] :=
  Sort @ set === Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ]

PackageScope[ setSample ]

setSample[ members_List, count_, nextFn_ ] :=
  With[ { ordered = { members } },
    Which[
      count === Automatic, members,
      count === All,       ordered,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]

RandomInfraCausalFuture[ graph_Graph, cone_InfraCausalFuture,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraCausalFuture ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraCausalFuture, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  setSample[ Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ], count,
    OptionValue[ RandomInfraCausalFuture, { opts }, "NextVertexFunction" ] ]

RandomInfraCausalFuture[ graph_Graph, anchor : Except[ _InfraCausalFuture | _Rule | _RuleDelayed ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraCausalFuture ], First /@ { opts } ] :=
  RandomInfraCausalFuture[ graph, InfraCausalFuture[ anchor ], count, opts ]

RandomInfraCausalPast[ graph_Graph, cone_InfraCausalPast,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraCausalPast ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraCausalPast, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  setSample[ Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ], count,
    OptionValue[ RandomInfraCausalPast, { opts }, "NextVertexFunction" ] ]

RandomInfraCausalPast[ graph_Graph, anchor : Except[ _InfraCausalPast | _Rule | _RuleDelayed ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraCausalPast ], First /@ { opts } ] :=
  RandomInfraCausalPast[ graph, InfraCausalPast[ anchor ], count, opts ]

InfraCausalFutureQ[ graph_Graph, family_Association ] :=
  InfraCausalFutureQ[ graph, Keys @ family ]

InfraCausalFutureQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraCausalFutureQ[ graph, # ] & ]

InfraCausalFutureQ[ graph_Graph, vs_List ] :=
  vs =!= { } && AllTrue[ vs, VertexQ[ graph, # ] & ] &&
    AnyTrue[ vs, v |-> Sort @ VertexOutComponent[ graph, { v } ] === Sort @ vs ]

InfraCausalPastQ[ graph_Graph, family_Association ] :=
  InfraCausalPastQ[ graph, Keys @ family ]

InfraCausalPastQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraCausalPastQ[ graph, # ] & ]

InfraCausalPastQ[ graph_Graph, vs_List ] :=
  vs =!= { } && AllTrue[ vs, VertexQ[ graph, # ] & ] &&
    AnyTrue[ vs, v |-> Sort @ VertexInComponent[ graph, { v } ] === Sort @ vs ]
