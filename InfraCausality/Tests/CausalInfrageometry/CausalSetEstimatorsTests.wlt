BeginTestSection["CausalSetEstimators"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$chain = PathGraph[ Range[ 10 ], DirectedEdges -> True ];

$chainDiamond = InfraCausalDiamond[ 1, 10 ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$latticeDiamond = InfraCausalDiamond[ { 0, 0 }, { 3, 3 } ];

$strictPairs = g |-> Select[ Tuples[ VertexList @ g, 2 ], pair |-> First @ pair =!= Last @ pair && MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] ];

$between = { g, u, w } |-> Length @ Intersection[ VertexOutComponent[ g, { u } ], VertexInComponent[ g, { w } ] ] - 2;

$sprinkling = { d, n, seed } |-> ( SeedRandom[ seed ]; RandomCausalGraph[ n, Method -> { "Sprinkling", d } ] );

$whole = g |-> InfraCausalDiamond[ VertexList @ g ];

$flat = $sprinkling[ 2, 300, 1 ];

$flat3 = $sprinkling[ 3, 300, 1 ];

$flat4 = $sprinkling[ 4, 300, 1 ];

$flatScan = Table[ With[ { g = $sprinkling[ 2, 8, seed ] }, InfraMeasurement[ g, $whole @ g, "BenincasaDowkerAction" ] ], { seed, 4000 } ];

VerificationTest[
  InfraMeasurement[ $diamond, $latticeDiamond, "OrderingFraction" ] == ( ( 4 * 5 / 2 )^2 - 4^2 ) / Binomial[ 4^2, 2 ],
  True,
  TestID -> "CausalSetEstimators-Diamond-ordering-fraction-of-a-product-of-two-chains"
]

VerificationTest[
  AllTrue[ { $diamond, $chain, $flat }, g |->
    InfraMeasurement[ g, $whole @ g, "OrderingFraction" ] == Length[ $strictPairs @ g ] / Binomial[ VertexCount @ g, 2 ] ],
  True,
  TestID -> "CausalSetEstimators-All-ordering-fraction-counts-the-strictly-related-pairs"
]

VerificationTest[
  InfraMeasurement[ $diamond, $latticeDiamond, "IntervalAbundances" ] ===
    AssociationThread[ Range[ 0, 14 ], Lookup[ Counts[ $between[ $diamond, ## ] & @@@ $strictPairs @ $diamond ], Range[ 0, 14 ], 0 ] ],
  True,
  TestID -> "CausalSetEstimators-Diamond-interval-abundances-equal-the-brute-force-count"
]

VerificationTest[
  InfraMeasurement[ $chain, $chainDiamond, "IntervalAbundances" ] === AssociationThread[ Range[ 0, 8 ], 10 - Range[ 0, 8 ] - 1 ],
  True,
  TestID -> "CausalSetEstimators-Chain-interval-abundances-are-N-k-1"
]

VerificationTest[
  { InfraMeasurement[ $chain, $chainDiamond, "BenincasaDowkerAction" ],
    InfraMeasurement[ $chain, $chainDiamond, "BenincasaDowkerAction", "Dimension" -> 4 ],
    Values @ InfraMeasurement[ $chain, $chainDiamond, "BenincasaDowkerRicci" ] },
  { 2 * 10, 4 / Sqrt[ 6 ] ( 10 - 1 ), { 4, -4, 12, 4, 4, 4, 4, 4, 4, 4 } },
  TestID -> "CausalSetEstimators-Chain-action-is-2N-in-2D-and-N-1-in-4D"
]

VerificationTest[
  With[ { star = Graph[ { 0 -> 1, 0 -> 2, 0 -> 3 } ], sparse = Graph[ Range[ 15 ], Join[ Thread[ Range[ 6 ] -> Range[ 2, 7 ] ], { 8 -> 9, 9 -> 10 } ] ],
          lone = Graph[ Range[ 5 ], { 1 -> 2 } ], antichain = Graph[ Range[ 3 ], { } ] },
    { InfraMeasurement[ star, $whole @ star, "OrderingFraction" ], InfraMeasurement[ sparse, $whole @ sparse, "OrderingFraction" ],
      InfraMeasurement[ lone, $whole @ lone, "OrderingFraction" ],
      Abs[ InfraMeasurement[ star, $whole @ star, "MyrheimMeyerDimension" ] - 2 ] < 10^-6,
      Abs[ InfraMeasurement[ sparse, $whole @ sparse, "MyrheimMeyerDimension" ] - 3 ] < 10^-6,
      Abs[ InfraMeasurement[ lone, $whole @ lone, "MyrheimMeyerDimension" ] - 4 ] < 10^-6,
      InfraMeasurement[ $chain, $chainDiamond, "MyrheimMeyerDimension" ],
      InfraMeasurement[ antichain, $whole @ antichain, "MyrheimMeyerDimension" ] } ],
  { 1/2, 8/35, 1/10, True, True, True, 1, Infinity },
  TestID -> "CausalSetEstimators-MyrheimMeyer-inverts-the-exact-fractions-1-1/2-8/35-1/10-0"
]

VerificationTest[
  { InfraMeasurement[ $diamond, $latticeDiamond, "MidpointScalingDimension" ], InfraMeasurement[ $chain, $chainDiamond, "MidpointScalingDimension" ] },
  { Log2[ 16 / Max @ Table[ Min[ InfraMeasurement[ $diamond, InfraCausalDiamond[ { 0, 0 }, m ], "CountingMeasure" ],
        InfraMeasurement[ $diamond, InfraCausalDiamond[ m, { 3, 3 } ], "CountingMeasure" ] ], { m, VertexList @ $diamond } ] ], 1 },
  TestID -> "CausalSetEstimators-Diamond-midpoint-scaling-halves-the-interval-volume"
]

VerificationTest[
  { Abs[ InfraMeasurement[ $flat, $whole @ $flat, "OrderingFraction" ] - 1/2 ] < 0.05,
    Abs[ InfraMeasurement[ $flat, $whole @ $flat, "MyrheimMeyerDimension" ] - 2 ] < 0.25,
    Abs[ InfraMeasurement[ $flat, $whole @ $flat, "MidpointScalingDimension" ] - 2 ] < 0.3 },
  { True, True, True },
  TestID -> "CausalSetEstimators-Sprinkling2D-dimension-estimates-near-2"
]

VerificationTest[
  { Abs[ InfraMeasurement[ $flat3, $whole @ $flat3, "OrderingFraction" ] - 8/35 ] < 0.05,
    Abs[ InfraMeasurement[ $flat3, $whole @ $flat3, "MyrheimMeyerDimension" ] - 3 ] < 0.4,
    Abs[ InfraMeasurement[ $flat3, $whole @ $flat3, "MidpointScalingDimension" ] - 3 ] < 0.3 },
  { True, True, True },
  TestID -> "CausalSetEstimators-Sprinkling3D-dimension-estimates-near-3"
]

VerificationTest[
  { Abs[ InfraMeasurement[ $flat4, $whole @ $flat4, "OrderingFraction" ] - 1/10 ] < 0.05,
    Abs[ InfraMeasurement[ $flat4, $whole @ $flat4, "MyrheimMeyerDimension" ] - 4 ] < 0.5 },
  { True, True },
  TestID -> "CausalSetEstimators-Sprinkling4D-dimension-estimates-near-4"
]

VerificationTest[
  AllTrue[ { 2, 4 }, dim |->
    With[ { B = InfraMeasurement[ $flat, $whole @ $flat, "BenincasaDowkerDAlembertian", "Dimension" -> dim ],
            ricci = InfraMeasurement[ $flat, $whole @ $flat, "BenincasaDowkerRicci", "Dimension" -> dim ] },
      Union @ Simplify[ Values[ ricci ] + 2 B . ConstantArray[ 1, VertexCount @ $flat ] ] === { 0 } &&
        Simplify[ InfraMeasurement[ $flat, $whole @ $flat, "BenincasaDowkerAction", "Dimension" -> dim ] - Total[ ricci ] / 2 ] === 0 ] ],
  True,
  TestID -> "CausalSetEstimators-Sprinkling2D-action-is-half-the-total-Ricci-and-Ricci-is-minus-twice-B-of-one"
]

VerificationTest[
  With[ { B = Normal @ InfraMeasurement[ $flat, $whole @ $flat, "BenincasaDowkerDAlembertian" ], vs = VertexList @ $flat },
    AllTrue[ Range @ Length @ vs, x |-> B[[ x, x ]] == -2 &&
      SubsetQ[ VertexInComponent[ $flat, { vs[[ x ]] } ], vs[[ Flatten @ Position[ B[[ x ]], Except[ 0 ], { 1 }, Heads -> False ] ]] ] ] &&
    AllTrue[ EdgeList @ $flat, edge |-> B[[ Last @ edge, First @ edge ]] == 4 ] ],
  True,
  TestID -> "CausalSetEstimators-Sprinkling2D-dAlembertian-is-retarded-with-weight-4-on-links"
]

VerificationTest[
  { Abs[ Mean[ $flatScan ] - 2 ] < 0.8, Abs[ Mean[ 2 $flatScan / 8 ] - 4 / 8 ] < 0.2 },
  { True, True },
  TestID -> "CausalSetEstimators-Sprinkling2D-mean-action-of-a-flat-diamond-is-2-and-mean-Ricci-4-over-N"
]

EndTestSection[]
