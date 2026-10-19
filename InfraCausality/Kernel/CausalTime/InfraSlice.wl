Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalTime :: InfraSlice *)

Options[ RandomInfraSlice ] = { "NextVertexFunction" -> Automatic }

InfraSlice /: InfraMeasurement[ graph_Graph, InfraSlice[ k_Integer ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraSlice[ { k, k } ], "VertexDensity" ]

InfraSlice /: InfraMeasurement[ graph_Graph, InfraSlice[ { k1_Integer, k2_Integer } ], "VertexDensity" ] :=
  AssociationThread[ Sort @ Keys @ Select[ UniversalTime @ graph, t |-> k1 <= t <= k2 ], 1 ]

InfraSlice /: InfraMeasurement[ graph_Graph, slice_InfraSlice, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, slice, "VertexDensity" ] ], 1 ]

InfraSlice /: InfraMeasurement[ _Graph, _InfraSlice, "Cardinality" ] :=
  1

InfraSlice /: InfraMeasurement[ _Graph, _InfraSlice, "Faithful" ] :=
  True

InfraSlice /: InfraMeasurement[ graph_Graph, slice_InfraSlice, All ] :=
  InfraMeasurement[ graph, slice,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraSlice /: InfraMemberQ[ graph_Graph, slice_InfraSlice, set_List ] :=
  Sort @ set === Keys @ InfraMeasurement[ graph, slice, "VertexDensity" ]

RandomInfraSlice[ graph_Graph, slice_InfraSlice,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraSlice ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraSlice, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  setSample[ Keys @ InfraMeasurement[ graph, slice, "VertexDensity" ], count,
    OptionValue[ RandomInfraSlice, { opts }, "NextVertexFunction" ] ]

RandomInfraSlice[ graph_Graph, k : ( _Integer | { _Integer, _Integer } ),
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ RandomInfraSlice ], First /@ { opts } ] :=
  RandomInfraSlice[ graph, InfraSlice[ k ], count, opts ]

InfraSliceQ[ graph_Graph, family_Association ] :=
  InfraSliceQ[ graph, Keys @ family ]

InfraSliceQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraSliceQ[ graph, # ] & ]

InfraSliceQ[ graph_Graph, vs_List ] :=
  vs =!= { } && AllTrue[ vs, VertexQ[ graph, # ] & ] &&
    With[ { time = UniversalTime @ graph },
      Sort @ vs === Sort @ Keys @ Select[ time, EqualTo[ time[ First @ vs ] ] ] ]
