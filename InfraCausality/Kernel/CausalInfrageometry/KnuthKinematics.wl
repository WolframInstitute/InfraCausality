Package[ "WolframInstitute`InfraCausality`" ]

PackageImport[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraCausality` :: CausalInfrageometry :: KnuthKinematics *)

Options[ ChainProjection ] = { Method -> "Cone" }

ChainProjection[ g_Graph, source_List, target_List, opts : OptionsPattern[] ] /;
    MemberQ[ { "Cone", "LightRays" }, OptionValue[ ChainProjection, { opts }, Method ] ] :=
  With[ { cone = Replace[ OptionValue[ ChainProjection, { opts }, Method ], { "Cone" -> InfraCausalFuture, "LightRays" -> InfraFutureLightCone } ] },
    Length @ Select[ source, e |-> IntersectingQ[ Keys @ InfraMeasurement[ g, cone @ e, "VertexDensity" ], target ] ] / Length @ source ]

ChainLightReach[ g_Graph, chain_List ] :=
  Union @@ ( Keys @ InfraMeasurement[ g, InfraFutureLightCone[ # ], "VertexDensity" ] & /@ chain )

Options[ InfraKinematics ] = { Method -> "Cone" }

InfraKinematics[ g_Graph, referenceChain_List, targetChains_List, opts : OptionsPattern[] ] /;
    MemberQ[ { "Cone", "LightRays" }, OptionValue[ InfraKinematics, { opts }, Method ] ] :=
  With[ { projections = Map[ target |-> ChainProjection[ g, referenceChain, target, Method -> OptionValue[ InfraKinematics, { opts }, Method ] ], targetChains ] },
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
