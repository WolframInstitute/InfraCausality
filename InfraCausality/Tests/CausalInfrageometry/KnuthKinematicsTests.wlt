BeginTestSection[ "KnuthKinematics" ]

Needs[ "WolframInstitute`InfraGeometry`" ]

$ladder = Graph[ { 1 -> 2, 2 -> 3, 3 -> 4, 5 -> 6, 6 -> 7, 7 -> 8, 1 -> 6, 2 -> 7, 3 -> 8, 5 -> 2, 6 -> 3, 7 -> 4 } ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ]

$diamond = Graph[ Flatten @ Table[ { If[ i < 3, { i, j } -> { i + 1, j }, Nothing ], If[ j < 3, { i, j } -> { i, j + 1 }, Nothing ] }, { i, 0, 3 }, { j, 0, 3 } ] ]

$fixtures = { $ladder, $twoSource, $diamond }

$chains[ g_ ] := Take[ RandomInfraObserver[ g, All ], UpTo[ 6 ] ]

$futureOf[ g_, e_ ] := VertexOutComponent[ g, { e } ]

$lightConeOf[ g_, e_ ] :=
  Select[ $futureOf[ g, e ], w |->
    With[ { d = Intersection[ $futureOf[ g, e ], VertexInComponent[ g, { w } ] ] },
      AllTrue[ Subsets[ d, { 2 } ], pair |-> MemberQ[ $futureOf[ g, First @ pair ], Last @ pair ] || MemberQ[ $futureOf[ g, Last @ pair ], First @ pair ] ] ] ]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ Tuples[ $chains[ g ], 2 ], ab |->
    And @@ Map[ m |-> 0 <= ChainProjection[ g, First @ ab, Last @ ab, Method -> m ] <= 1, { "Cone", "LightRays" } ] ] ],
  True,
  TestID -> "ChainProjection-Fixtures-lies-in-unit-interval"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $chains[ g ], a |->
    ChainProjection[ g, a, a ] == 1 && ChainProjection[ g, a, a, Method -> "LightRays" ] == 1 ] ],
  True,
  TestID -> "ChainProjection-Fixtures-a-chain-onto-itself-is-one"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $chains[ g ], a |->
    AllTrue[ Select[ $chains[ g ], b |-> SubsetQ[ $futureOf[ g, Last @ a ], b ] ], b |-> ChainProjection[ g, a, b ] == 1 ] ] ],
  True,
  TestID -> "ChainProjection-Fixtures-a-chain-onto-its-own-future-is-one"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ Tuples[ $chains[ g ], 2 ], ab |->
    ChainProjection[ g, First @ ab, Last @ ab ] ==
      Count[ First @ ab, e_ /; IntersectingQ[ $futureOf[ g, e ], Last @ ab ] ] / Length @ First @ ab ] ],
  True,
  TestID -> "ChainProjection-Fixtures-cone-is-the-fraction-of-events-whose-future-meets-the-target"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ Tuples[ $chains[ g ], 2 ], ab |->
    With[ { reach = Map[ e |-> IntersectingQ[ $futureOf[ g, e ], Last @ ab ], First @ ab ] },
      reach === Join[ ConstantArray[ True, Count[ reach, True ] ], ConstantArray[ False, Count[ reach, False ] ] ] ] ] ],
  True,
  TestID -> "ChainProjection-Fixtures-the-reaching-events-form-a-prefix-of-the-chain"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ Tuples[ $chains[ g ], 2 ], ab |->
    ChainProjection[ g, First @ ab, Last @ ab, Method -> "LightRays" ] <= ChainProjection[ g, First @ ab, Last @ ab ] ] ],
  True,
  TestID -> "ChainProjection-Fixtures-light-rays-at-most-cone"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ Tuples[ $chains[ g ], 2 ], ab |->
    ChainProjection[ g, First @ ab, Last @ ab, Method -> "LightRays" ] ==
      Count[ First @ ab, e_ /; IntersectingQ[ $lightConeOf[ g, e ], Last @ ab ] ] / Length @ First @ ab ] ],
  True,
  TestID -> "ChainProjection-Fixtures-light-rays-is-the-fraction-of-events-whose-light-cone-meets-the-target"
]

VerificationTest[
  { ChainProjection[ $ladder, { 1, 2, 3, 4 }, # ] & /@ { { 4 }, { 5 }, { 7 }, { 5, 6, 7, 8 } },
    ChainProjection[ $ladder, { 1, 2, 3, 4 }, #, Method -> "LightRays" ] & /@ { { 4 }, { 5 }, { 7 }, { 5, 6, 7, 8 } } },
  { { 1, 0, 1/2, 3/4 }, { 1/2, 0, 1/4, 3/4 } },
  TestID -> "ChainProjection-Ladder-literal-values"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $chains[ g ], c |->
    Sort @ ChainLightReach[ g, c ] === Sort[ Union @@ Map[ e |-> $lightConeOf[ g, e ], c ] ] ] ],
  True,
  TestID -> "ChainLightReach-Fixtures-union-of-the-light-cones-of-the-chain"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $chains[ g ], c |->
    SubsetQ[ ChainLightReach[ g, c ], c ] && SubsetQ[ Union @@ Map[ e |-> $futureOf[ g, e ], c ], ChainLightReach[ g, c ] ] ] ],
  True,
  TestID -> "ChainLightReach-Fixtures-contains-the-chain-and-lies-in-its-future"
]

VerificationTest[
  InfraKinematics[ $ladder, { 1, 2, 3, 4 }, { { 4 }, { 5 }, { 7 } } ],
  <| "Projections" -> { 1, 0, 1/2 }, "Energy" -> { 1/2, 3/4, 1/4 }, "Momentum" -> { 1/2, 1/4, -1/4 },
     "Mass" -> { 0, 1 / Sqrt[ 2 ], 0 }, "Interval" -> { 0, 1/2, 0 }, "Velocity" -> { 1, 1/3, -1 } |>,
  TestID -> "InfraKinematics-Ladder-the-five-Knuth-scalars-of-every-pair"
]

VerificationTest[
  AllTrue[ $fixtures, g |->
    With[ { chains = $chains[ g ] },
      AllTrue[ { "Cone", "LightRays" }, m |->
        With[ { k = InfraKinematics[ g, First @ chains, Rest @ chains, Method -> m ] },
          k[ "Projections" ] == Map[ b |-> ChainProjection[ g, First @ chains, b, Method -> m ], Rest @ chains ] &&
          k[ "Energy" ] == Map[ Mean, Subsets[ k[ "Projections" ], { 2 } ] ] &&
          k[ "Energy" ]^2 - k[ "Momentum" ]^2 == k[ "Interval" ] &&
          k[ "Mass" ]^2 == Abs @ k[ "Interval" ] &&
          And @@ MapThread[ { e, p, b } |-> e == 0 || b == p / e, { k[ "Energy" ], k[ "Momentum" ], k[ "Velocity" ] } ] ] ] ] ],
  True,
  TestID -> "InfraKinematics-Fixtures-energy-momentum-relation-mass-and-velocity"
]

VerificationTest[
  InfraKinematics[ $ladder, { 1, 2, 3, 4 }, { { 5 }, { 5 } } ][ "Velocity" ],
  { Indeterminate },
  TestID -> "InfraKinematics-Ladder-velocity-undefined-at-zero-energy"
]

VerificationTest[
  SeedRandom[ 17 ];
  With[ { g = RandomCausalGraph[ { 20, 0.2 } ] },
    With[ { chains = RandomInfraObserver[ g, UpTo[ 4 ] ] },
      With[ { k = InfraKinematics[ g, First @ chains, Rest @ chains, Method -> "LightRays" ],
              c = InfraKinematics[ g, First @ chains, Rest @ chains ] },
        AllTrue[ Join[ k[ "Projections" ], c[ "Projections" ] ], 0 <= # <= 1 & ] &&
        And @@ Thread[ k[ "Projections" ] <= c[ "Projections" ] ] &&
        k[ "Energy" ]^2 - k[ "Momentum" ]^2 == k[ "Interval" ] ] ] ],
  True,
  TestID -> "InfraKinematics-RandomCausalGraph-projections-and-energy-momentum-relation"
]

EndTestSection[]
