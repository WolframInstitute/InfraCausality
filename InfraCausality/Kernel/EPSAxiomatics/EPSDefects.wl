Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: EPSAxiomatics :: EPSDefects *)

PackageScope[ tickWindow ]

PackageScope[ relationDefect ]

PackageScope[ tickSpanRatio ]

Options[ relationDefect ] = { "Margin" -> 0 }

tickWindow[ a_List, margin_Integer ] :=
  a[[ Range[ margin + 1, Length @ a - margin ] ]]

relationDefect[ relation_Association, order_List, "DomainDefect" ] :=
  Count[ relation, { } ] / Length @ relation

relationDefect[ relation_Association, order_List, "FunctionDefect" ] :=
  Mean[ Max[ 0, Length @ # - 1 ] / Max[ 1, Length @ # ] & /@ Values @ relation ]

relationDefect[ relation_Association, order_List, "InjectivityDefect" ] :=
  1 - Length @ FindIndependentEdgeSet @ Graph @ Catenate @ KeyValueMap[
      { v, ws } |-> ( UndirectedEdge[ { 1, v }, { 2, # } ] & /@ ws ), relation ] / Length @ relation

relationDefect[ relation_Association, order_List, "OrderDefect" ] :=
  With[ { position = AssociationThread[ order, Range @ Length @ order ] },
    { spans = Replace[ Lookup[ position, Key /@ # ], { { } -> None, ps_List :> MinMax @ ps } ] & /@ Values @ relation },
    Count[ Subsets[ spans, { 2 } ], { { _, high_ }, { low_, _ } } /; high > low ] / Max[ 1, Binomial[ Length @ spans, 2 ] ] ]

earliestImage[ relation_Association, target_List ] :=
  With[ { position = AssociationThread[ target, Range @ Length @ target ] },
    Map[ Replace[ { { } -> Infinity, ws_List :> position @ First @ ws } ], relation ] ]

tickSpanRatio[ map_Association, source_List ] :=
  With[ { sent = Keys @ Select[ map, IntegerQ ], position = AssociationThread[ source, Range @ Length @ source ] },
    ( map[ Last @ sent ] - map[ First @ sent ] ) / ( position[ Last @ sent ] - position[ First @ sent ] ) ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ],
    defect : "DomainDefect" | "FunctionDefect" | "InjectivityDefect" | "OrderDefect", opts : OptionsPattern[ relationDefect ] ] :=
  With[ { window = tickWindow[ a, OptionValue[ relationDefect, { opts }, "Margin" ] ] },
    relationDefect[ messageRelation[ graph, window, b ], b, defect ] /; window =!= { } ]

InfraMessageFunction /: InfraMeasurement[ graph_Graph, InfraMessageFunction[ a_List, b_List ], "KFactor", opts : OptionsPattern[ relationDefect ] ] :=
  With[ { map = earliestImage[ messageRelation[ graph, tickWindow[ a, OptionValue[ relationDefect, { opts }, "Margin" ] ], b ], b ] },
    tickSpanRatio[ map, a ] /; Count[ map, _Integer ] >= 2 ]

InfraEchoFunction /: InfraMeasurement[ graph_Graph, echo : InfraEchoFunction[ a_List, _List ],
    defect : "DomainDefect" | "FunctionDefect" | "InjectivityDefect" | "OrderDefect", opts : OptionsPattern[ relationDefect ] ] :=
  With[ { window = tickWindow[ a, OptionValue[ relationDefect, { opts }, "Margin" ] ] },
    relationDefect[ KeyTake[ InfraMeasurement[ graph, echo, "Relation" ], window ], a, defect ] /; window =!= { } ]

InfraEchoFunction /: InfraMeasurement[ graph_Graph, echo : InfraEchoFunction[ a_List, _List ], "KFactor", opts : OptionsPattern[ relationDefect ] ] :=
  With[ { map = earliestImage[ KeyTake[ InfraMeasurement[ graph, echo, "Relation" ], tickWindow[ a, OptionValue[ relationDefect, { opts }, "Margin" ] ] ], a ] },
    Sqrt @ tickSpanRatio[ map, a ] /; Count[ map, _Integer ] >= 2 ]
