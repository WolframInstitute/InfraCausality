Package["WolframInstitute`InfraCausality`"]

ChainProjection::usage =
  "ChainProjection[g, source, target] returns the fraction of vertices of target \
lying in the forward cone of source. Option \"Method\" -> \"Cone\" (default) uses \
the full forward cone; \"LightRays\" restricts to the null boundary via \
ChainLightReach.";

Options[ ChainProjection ] = { "Method" -> "Cone" };

ChainProjection[ g_Graph, source_List, target_List, OptionsPattern[] ] :=
  Switch[ OptionValue[ "Method" ],
    "Cone",
      Length[ Intersection[ VertexOutComponent[ g, source ], target ] ] / Length[ source ],
    "LightRays",
      Length[ Intersection[ ChainLightReach[ g, source ], target ] ] / Length[ source ]
  ]


ChainLightReach::usage =
  "ChainLightReach[g, chain] returns the union of outgoing light rays from every \
vertex in chain, i.e. the light-boundary descendants of the chain.";

ChainLightReach[ g_Graph, chain_List ] :=
  Union @@ (OutgoingLightRays[ g, # ] & /@ chain)


KnuthEnergy::usage   = "KnuthEnergy[p, q] returns (p + q)/2.";
KnuthMomentum::usage = "KnuthMomentum[p, q] returns (p - q)/2.";
KnuthMass::usage     = "KnuthMass[p, q] returns Sqrt[Abs[p q]].";
KnuthInterval::usage = "KnuthInterval[p, q] returns p q.";
KnuthVelocity::usage = "KnuthVelocity[p, q] returns (p - q)/(p + q).";

KnuthEnergy[ p_, q_ ]   := (p + q) / 2
KnuthMomentum[ p_, q_ ] := (p - q) / 2
KnuthMass[ p_, q_ ]     := Sqrt[ Abs[ p q ] ]
KnuthInterval[ p_, q_ ] := p q
KnuthVelocity[ p_, q_ ] := (p - q) / (p + q)


KnuthKinematics::usage =
  "KnuthKinematics[g, referenceChain, targetChains] computes chain projections \
of referenceChain onto each targetChain and returns an Association with keys \
\"Projections\", \"Energy\", \"Momentum\", \"Mass\", \"GeometricMass\", \
\"Interval\", \"Velocity\" over all pairs of target chains. Option \
\"Method\" -> \"Cone\" (default) or \"LightRays\" selects the projection scheme.";

Options[ KnuthKinematics ] = { "Method" -> "Cone" };

KnuthKinematics[ g_Graph, referenceChain_List, targetChains_List, OptionsPattern[] ] :=
  Module[ { method, projections, pairs, energies, momenta },
    method = OptionValue[ "Method" ];
    projections = ChainProjection[ g, referenceChain, #, "Method" -> method ] & /@ targetChains;
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
