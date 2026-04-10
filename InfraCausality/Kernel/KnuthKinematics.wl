(* ::Package:: *)
(* KnuthKinematics.wl — Knuth-style kinematics on causal graphs *)
(* Requires: LightRays.wl (for OutgoingLightRays) *)
(* Load with: Get["Code/KnuthKinematics.wl"] *)


ChainProjection[ g_Graph, source_List, target_List ] :=
  Length[ Intersection[ VertexOutComponent[ g, source ], target ] ] / Length[ source ]

ChainProjection[ g_Graph, source_List, target_List, "Cone" ] :=
  ChainProjection[ g, source, target ]

ChainProjection[ g_Graph, source_List, target_List, "LightRays" ] :=
  Length[ Intersection[ ChainLightReach[ g, source ], target ] ] / Length[ source ]


KnuthEnergy[ p_, q_ ] :=
  (p + q) / 2

KnuthMomentum[ p_, q_ ] :=
  (p - q) / 2

KnuthMass[ p_, q_ ] :=
  Sqrt[ Abs[ p q ] ]

KnuthInterval[ p_, q_ ] :=
  p q

KnuthVelocity[ p_, q_ ] :=
  (p - q) / (p + q)


KnuthKinematics[ g_Graph, referenceChain_List, targetChains_List, method_String : "Cone" ] :=
  Module[ { projections, pairs, energies, momenta },
    projections = ChainProjection[ g, referenceChain, #, method ] & /@ targetChains;
    pairs = Subsets[ projections, { 2 } ];
    energies = Apply[ KnuthEnergy, pairs, { 1 } ];
    momenta = Apply[ KnuthMomentum, pairs, { 1 } ];
    <|
      "Projections" -> projections,
      "Energy" -> energies,
      "Momentum" -> momenta,
      "Mass" -> Apply[ KnuthMass, pairs, { 1 } ],
      "GeometricMass" -> Sqrt[ Abs[ energies momenta ] ],
      "Interval" -> Apply[ KnuthInterval, pairs, { 1 } ],
      "Velocity" -> Apply[ KnuthVelocity, pairs, { 1 } ]
    |>
  ]


ChainLightReach[ g_Graph, chain_List ] :=
  Union @@ (OutgoingLightRays[ g, # ] & /@ chain)
