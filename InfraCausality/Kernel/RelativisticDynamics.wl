Package["WolframInstitute`InfraCausality`"]


(* Combinatorial relativistic dynamics on chains of a causal graph.

   Two chain projections p and q (forward / backward, source / target) play the
   role of light-cone coordinates u = (t + x) and v = (t - x), giving
       E   = (p + q)/2     (energy)
       P   = (p - q)/2     (momentum)
       I   = p q           (squared interval, equals E^2 - P^2)
       m   = Sqrt[ |p q| ] (mass)
       beta= (p - q)/(p + q)  (velocity).

   Reference:
     Knuth & Bahreyni, A Potential Foundation for Emergent Space-Time,
       arXiv:1005.4172, Sections 3-4.                                          *)


(* =========================== Chain primitives =========================== *)

(* ChainProjection[g, source, target]: fraction of source events whose forward
   reach lands in target.  "Cone" uses the full forward light cone of source;
   "LightRays" restricts to the null boundary of source (light front).         *)

Options[ ChainProjection ] = { "Method" -> "Cone" };

ChainProjection[ g_Graph, source_List, target_List, OptionsPattern[] ] :=
  Switch[ OptionValue[ "Method" ],
    "Cone",
      Length @ Intersection[ VertexOutComponent[ g, source ], target ] / Length @ source,
    "LightRays",
      Length @ Intersection[ ChainLightReach[ g, source ], target ] / Length @ source
  ]


(* ChainLightReach[g, c]: union of outgoing light rays from every event in
   chain c -- the joint future light front of the chain.                       *)

ChainLightReach[ g_Graph, chain_List ] :=
  Union @@ ( OutgoingLightRays[ g, # ] & /@ chain )


(* =========================== Scalar combinations =========================== *)

(* Knuth energy E(p, q) = (p + q)/2. *)
InfraEnergy[ p_, q_ ] := ( p + q ) / 2

(* Knuth momentum P(p, q) = (p - q)/2. *)
InfraMomentum[ p_, q_ ] := ( p - q ) / 2

(* Knuth mass m(p, q) = Sqrt[|p q|], so m^2 = E^2 - P^2 when p, q >= 0. *)
InfraMass[ p_, q_ ] := Sqrt @ Abs[ p q ]

(* Knuth squared interval I(p, q) = p q = E^2 - P^2. *)
InfraInterval[ p_, q_ ] := p q

(* Knuth velocity beta(p, q) = (p - q)/(p + q) = P / E. *)
InfraVelocity[ p_, q_ ] := ( p - q ) / ( p + q )


(* =========================== Master pipeline =========================== *)

(* InfraKinematics[g, ref, targets]: project the reference chain onto each
   target chain and tabulate every two-target combination of Knuth scalars.
   Option "Method" is forwarded to ChainProjection.                            *)

Options[ InfraKinematics ] = { "Method" -> "Cone" };

InfraKinematics[ g_Graph, referenceChain_List, targetChains_List, OptionsPattern[] ] :=
  Module[ { projections, pairs, energies, momenta },
    projections = ChainProjection[ g, referenceChain, #, "Method" -> OptionValue[ "Method" ] ] & /@ targetChains;
    pairs       = Subsets[ projections, { 2 } ];
    energies    = Apply[ InfraEnergy,   pairs, { 1 } ];
    momenta     = Apply[ InfraMomentum, pairs, { 1 } ];
    <|
      "Projections"   -> projections,
      "Energy"        -> energies,
      "Momentum"      -> momenta,
      "Mass"          -> Apply[ InfraMass, pairs, { 1 } ],
      "GeometricMass" -> Sqrt @ Abs[ energies momenta ],
      "Interval"      -> Apply[ InfraInterval, pairs, { 1 } ],
      "Velocity"      -> Apply[ InfraVelocity, pairs, { 1 } ]
    |>
  ]
