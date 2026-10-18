Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: EPSAxiomatics :: EPSAxioms *)

Options[ EPSMessageAxiomQ ] = { "Margin" -> 0 }

strictlyIncreasingQ[ relation_Association, order_List ] :=
  With[ { position = AssociationThread[ order, Range @ Length @ order ] },
    AllTrue[ relation, Length @ # == 1 & ] && Less @@ Lookup[ position, Key /@ Catenate @ Values @ relation ] ]

EPSMessageAxiomQ[ graph_Graph, InfraMessageFunction[ a_List, b_List ], opts : OptionsPattern[] ] :=
  strictlyIncreasingQ[ messageRelation[ graph, tickWindow[ a, OptionValue[ EPSMessageAxiomQ, { opts }, "Margin" ] ], b ], b ]

EPSMessageAxiomQ[ graph_Graph, echo : InfraEchoFunction[ a_List, _List ], opts : OptionsPattern[] ] :=
  strictlyIncreasingQ[ KeyTake[ InfraMeasurement[ graph, echo, "Relation" ], tickWindow[ a, OptionValue[ EPSMessageAxiomQ, { opts }, "Margin" ] ] ], a ]

EPSRadarAxiomQ[ graph_Graph, chart_InfraRadarCoordinates ] :=
  DuplicateFreeQ @ Values @ InfraMeasurement[ graph, chart, "Coordinates" ]
