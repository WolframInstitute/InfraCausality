Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: Experimental :: KnuthKinematics *)

Options[ ChainProjection ] = { "Method" -> "Cone" };

ChainProjection[ g_Graph, source_List, target_List, OptionsPattern[] ] :=
  With[ { reach = Switch[ OptionValue[ "Method" ],
            "LightRays", e |-> Keys @ InfraMeasurement[ g, InfraFutureLightCone[ e ], "VertexDensity" ],
            _, e |-> Keys @ InfraMeasurement[ g, InfraCausalFuture[ e ], "VertexDensity" ] ] },
    Length @ Select[ source, event |-> IntersectingQ[ reach[ event ], target ] ] / Length @ source
  ]

ChainLightReach[ g_Graph, chain_List ] :=
  Union @@ ( Keys @ InfraMeasurement[ g, InfraFutureLightCone[ # ], "VertexDensity" ] & /@ chain )

Options[ InfraKinematics ] = { "Method" -> "Cone" };

InfraKinematics[ g_Graph, referenceChain_List, targetChains_List, OptionsPattern[] ] :=
  With[ { projections = Map[ target |-> ChainProjection[ g, referenceChain, target, "Method" -> OptionValue[ "Method" ] ], targetChains ] },
    { pairs = Subsets[ projections, { 2 } ] },
    <|
      "Projections" -> projections,
      "Energy" -> Map[ pq |-> ( First @ pq + Last @ pq ) / 2, pairs ],
      "Momentum" -> Map[ pq |-> ( First @ pq - Last @ pq ) / 2, pairs ],
      "Mass" -> Map[ pq |-> Sqrt @ Abs[ First @ pq Last @ pq ], pairs ],
      "Interval" -> Map[ pq |-> First @ pq Last @ pq, pairs ],
      "Velocity" -> Map[ pq |-> If[ Total @ pq == 0, Indeterminate, ( First @ pq - Last @ pq ) / Total @ pq ], pairs ]
    |>
  ]
