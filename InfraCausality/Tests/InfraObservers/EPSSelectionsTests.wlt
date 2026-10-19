BeginTestSection["EPSSelections"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$eps = Graph[ { 1 -> 2, 2 -> 3, 3 -> 4, 5 -> 6, 6 -> 7, 7 -> 8, 1 -> 6, 2 -> 7, 3 -> 8, 5 -> 2, 6 -> 3, 7 -> 4 } ];

$lattice = n |-> Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= n & ],
  { i, 0, n }, { j, 0, n } ] ];

$diamond = $lattice[ 3 ];

$diamond6 = $lattice[ 5 ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$stair = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 2, 1 }, { 2, 2 }, { 3, 2 }, { 3, 3 } };

$stairShifted = { { 0, 2 }, { 1, 2 }, { 1, 3 }, { 2, 3 }, { 2, 4 }, { 3, 4 }, { 3, 5 } };

$column = k |-> Table[ { k, j }, { j, 0, 3 } ];

$cases = {
  { $eps, { 1, 2, 3, 4 }, { 5, 6, 7, 8 } },
  { $eps, { 5, 6, 7, 8 }, { 1, 2, 3, 4 } },
  { $diamond, $column[ 0 ], $column[ 2 ] },
  { $diamond6, $stair, $stairShifted },
  { $diamond6, $stairShifted, $stair },
  { $cylinder, $column[ 0 ], $column[ 1 ] },
  { $cylinder, $column[ 1 ], $column[ 0 ] } };

$domain = { g, a, b } |-> Select[ InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Relation" ], # =!= { } & ];

$selections = { g, a, b } |-> With[ { relation = $domain[ g, a, b ] },
  AssociationThread[ Keys @ relation, # ] & /@ Tuples @ Values @ relation ];

$monotoneQ = { order, f } |-> LessEqual @@ Lookup[ AssociationThread[ order, Range @ Length @ order ], Key /@ Values @ f ];

$monotoneSelections = { g, a, b } |-> Select[ $selections[ g, a, b ], f |-> $monotoneQ[ b, f ] ];

$compositions = { g, a, b } |-> DeleteDuplicates @ Catenate @ Outer[
  { s, t } |-> Association @ KeyValueMap[ { v, w } |-> If[ MemberQ[ Keys @ t, w ], v -> Lookup[ t, Key @ w ], Nothing ], s ],
  $monotoneSelections[ g, a, b ], $monotoneSelections[ g, b, a ], 1 ];

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |->
    Sort[ KeySort /@ RandomInfraMessageFunction[ g, InfraMessageFunction[ a, b ], All ] ] === Sort[ KeySort /@ $monotoneSelections[ g, a, b ] ] ] ],
  True,
  TestID -> "RandomInfraMessageFunction-all-enumerates-monotone-selections"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |->
    InfraMeasurement[ g, InfraMessageFunction[ a, b ], "Cardinality" ] == Length @ RandomInfraMessageFunction[ g, InfraMessageFunction[ a, b ], All ] ] ],
  True,
  TestID -> "RandomInfraMessageFunction-all-cardinality-is-enumeration-length"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> With[ { members = RandomInfraMessageFunction[ g, InfraMessageFunction[ a, b ], All ] },
    DuplicateFreeQ @ members && AllTrue[ members, f |-> InfraMessageFunctionQ[ g, InfraMessageFunction[ a, b ], f ] && InfraMemberQ[ g, InfraMessageFunction[ a, b ], f ] ] ] ] ],
  True,
  TestID -> "RandomInfraMessageFunction-all-members-pass-predicate"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |->
    Sort[ KeySort /@ RandomInfraEchoFunction[ g, InfraEchoFunction[ a, b ], All ] ] === Sort[ KeySort /@ $compositions[ g, a, b ] ] ] ],
  True,
  TestID -> "RandomInfraEchoFunction-all-enumerates-compositions-of-monotone-selections"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |-> With[ { members = RandomInfraEchoFunction[ g, InfraEchoFunction[ a, b ], All ] },
    InfraMeasurement[ g, InfraEchoFunction[ a, b ], "Cardinality" ] == Length @ members && DuplicateFreeQ @ members &&
      AllTrue[ members, f |-> InfraEchoFunctionQ[ g, InfraEchoFunction[ a, b ], f ] && InfraMemberQ[ g, InfraEchoFunction[ a, b ], f ] ] ] ] ],
  True,
  TestID -> "RandomInfraEchoFunction-all-members-pass-predicate"
]

VerificationTest[
  AllTrue[ $cases, Apply[ { g, a, b } |->
    AllTrue[ RandomInfraEchoFunction[ g, InfraEchoFunction[ a, b ], All ], f |->
      AllTrue[ Keys @ f, v |-> MemberQ[ VertexOutComponent[ g, { v } ], f[ v ] ] && f[ v ] =!= v ] ] ] ],
  True,
  TestID -> "RandomInfraEchoFunction-all-echo-in-strict-future"
]

VerificationTest[
  { RandomInfraMessageFunction[ $eps, InfraMessageFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], All ],
    RandomInfraEchoFunction[ $eps, InfraEchoFunction[ { 1, 2, 3, 4 }, { 5, 6, 7, 8 } ], All ] },
  { { <| 1 -> 6, 2 -> 7, 3 -> 8 |> }, { <| 1 -> 3, 2 -> 4 |> } },
  TestID -> "RandomInfraMessageFunction-EPS-unique-selection-and-echo"
]

VerificationTest[
  With[ { head = InfraMessageFunction[ $stair, $stairShifted ] },
    { Length @ DeleteDuplicates @ RandomInfraMessageFunction[ $diamond6, head, 5 ],
      RandomInfraMessageFunction[ $diamond6, head, 28 ],
      Length @ RandomInfraMessageFunction[ $diamond6, head, UpTo[ 40 ] ],
      Length @ RandomInfraMessageFunction[ $diamond6, head, 27 ] } ],
  { 5, { }, 27, 27 },
  TestID -> "RandomInfraMessageFunction-diamond6-count-contract"
]

VerificationTest[
  With[ { head = InfraMessageFunction[ $stair, $stairShifted ] },
    RandomInfraMessageFunction[ $diamond6, head, 3, "NextVertexFunction" -> Identity ] ===
      Take[ SortBy[ RandomInfraMessageFunction[ $diamond6, head, All ], Values ], 3 ] ],
  True,
  TestID -> "RandomInfraMessageFunction-diamond6-identity-first-in-sorted-order"
]

VerificationTest[
  With[ { head = InfraMessageFunction[ $stair, $stairShifted ] },
    ( SeedRandom[ 7 ]; RandomInfraMessageFunction[ $diamond6, head, 4 ] ) === ( SeedRandom[ 7 ]; RandomInfraMessageFunction[ $diamond6, head, 4 ] ) ],
  True,
  TestID -> "RandomInfraMessageFunction-diamond6-seed-reproducible"
]

VerificationTest[
  With[ { head = InfraMessageFunction[ $stairShifted, $stair ] },
    SeedRandom[ 1 ];
    With[ { counts = Counts @ Table[ RandomInfraMessageFunction[ $diamond6, head ], 300 ] },
      Length @ counts == 3 && AllTrue[ Values @ counts, c |-> Abs[ c / 300 - 1 / 3 ] < 0.1 ] ] ],
  True,
  TestID -> "RandomInfraMessageFunction-diamond6-uniform"
]

VerificationTest[
  With[ { head = InfraEchoFunction[ $stair, $stairShifted ], card = InfraMeasurement[ $diamond6, InfraEchoFunction[ $stair, $stairShifted ], "Cardinality" ] },
    { Length @ DeleteDuplicates @ RandomInfraEchoFunction[ $diamond6, head, 4 ],
      RandomInfraEchoFunction[ $diamond6, head, card + 1 ],
      Length @ RandomInfraEchoFunction[ $diamond6, head, UpTo[ card + 5 ] ],
      MemberQ[ RandomInfraEchoFunction[ $diamond6, head, All ], RandomInfraEchoFunction[ $diamond6, head ] ] } ],
  { 4, { }, 24, True },
  TestID -> "RandomInfraEchoFunction-diamond6-count-contract"
]

EndTestSection[]
