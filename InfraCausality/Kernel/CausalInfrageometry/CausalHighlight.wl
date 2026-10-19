Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: CausalHighlight *)

PackageScope[ causalInk ]

PackageScope[ rayGraph ]

$causalHead =
  _InfraCausalFuture | _InfraCausalPast | _InfraCausalDiamond | _InfraSlice |
  _InfraTimelikeGeodesic | _InfraWorldline | _InfraFutureLightCone | _InfraPastLightCone |
  _InfraMessageFunction | _InfraEchoFunction | _InfraRadarCoordinates

cabinet[ { x_, y_, t_ } ] :=
  { x + y / ( 2 Sqrt[ 2 ] ), t + y / ( 2 Sqrt[ 2 ] ) }

rayGraph[ graph_Graph, pairs_List ] :=
  With[ { paths = Map[
      pair |-> FindShortestPath[ InfraMeasurement[ graph, InfraFutureLightCone[ First @ pair ], "Graph" ], First @ pair, Last @ pair ],
      pairs ] },
    Graph[ DeleteDuplicates @ Catenate @ paths, DeleteDuplicates @ Catenate[ ( DirectedEdge @@@ Partition[ #, 2, 1 ] ) & /@ paths ] ] ]

causalInk[ graph_Graph, head : _InfraCausalFuture | _InfraCausalPast | _InfraCausalDiamond | _InfraSlice | _InfraRadarCoordinates ] :=
  InfraMeasurement[ graph, head, "VertexDensity" ]

causalInk[ graph_Graph, head : _InfraTimelikeGeodesic | _InfraWorldline | _InfraFutureLightCone | _InfraPastLightCone ] :=
  InfraMeasurement[ graph, head, "Graph" ]

causalInk[ graph_Graph, head : InfraMessageFunction[ _List, _List ] ] :=
  rayGraph[ graph, List @@@ EdgeList @ InfraMeasurement[ graph, head, "Graph" ] ]

causalInk[ graph_Graph, InfraEchoFunction[ a_List, b_List ] ] :=
  With[ { ab = InfraMeasurement[ graph, InfraMessageFunction[ a, b ], "Relation" ],
          ba = InfraMeasurement[ graph, InfraMessageFunction[ b, a ], "Relation" ] },
    { returning = Select[ Catenate @ KeyValueMap[ { v, ws } |-> ( { v, # } & /@ ws ), ab ],
        pair |-> Lookup[ ba, Key @ Last @ pair, { } ] =!= { } ] },
    rayGraph[ graph, Join[ returning,
      Catenate @ Map[ w |-> ( { w, # } & /@ Lookup[ ba, Key @ w ] ), DeleteDuplicates[ Last /@ returning ] ] ] ] ]

InfraSubstrateHighlight[ graph_Graph, items_List, opts : OptionsPattern[ InfraSubstrateHighlight ] ] /;
    MatchQ[ Dimensions @ GraphEmbedding @ graph, { _, 3 } ] :=
  InfraSubstrateHighlight[ Graph[ graph, VertexCoordinates -> cabinet /@ GraphEmbedding @ graph ], items, opts ]

InfraSubstrateHighlight[ graph_Graph, items_List, opts : OptionsPattern[ InfraSubstrateHighlight ] ] /;
    MemberQ[ items, $causalHead | ( $causalHead -> _ ) | Style[ $causalHead, ___ ] ] :=
  InfraSubstrateHighlight[ graph,
    Replace[ items, {
      head : $causalHead :> causalInk[ graph, head ],
      ( ( head : $causalHead ) -> style_ ) :> ( causalInk[ graph, head ] -> style ),
      Style[ head : $causalHead, styles___ ] :> Style[ causalInk[ graph, head ], styles ] },
      { 1 } ],
    opts ]
