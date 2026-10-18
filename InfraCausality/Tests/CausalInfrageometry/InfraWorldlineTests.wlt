BeginTestSection["InfraWorldline"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$shortcut = Graph[ { 1 -> 2, 2 -> 3, 3 -> 4, 1 -> 5, 5 -> 4, 1 -> 3 } ];

$lattice = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 4 & ],
  { i, 0, 4 }, { j, 0, 4 } ] ];

$knots = { { 0, 0 }, { 2, 1 }, { 4, 4 } };

$cuts = { g, knots } |-> Accumulate @ Prepend[ InfraMeasurement[ g, InfraWorldline @@ #, "Length" ] & /@ Partition[ knots, 2, 1 ], 1 ];

$polylineQ = { g, knots } |-> With[ { members = RandomInfraWorldline[ g, InfraWorldline @@ knots, All ], cuts = $cuts[ g, knots ] },
  InfraMeasurement[ g, InfraWorldline @@ knots, "Cardinality" ] == Length @ members ==
      Times @@ ( InfraMeasurement[ g, InfraWorldline @@ #, "Cardinality" ] & /@ Partition[ knots, 2, 1 ] ) &&
    InfraMeasurement[ g, InfraWorldline @@ knots, "Length" ] == Total[ InfraMeasurement[ g, InfraWorldline @@ #, "Length" ] & /@ Partition[ knots, 2, 1 ] ] &&
    AllTrue[ members, m |-> m[[ cuts ]] === knots && InfraChainQ[ g, m ] && InfraObserverQ[ g, m ] &&
      AllTrue[ Range[ Length @ knots - 1 ], i |-> InfraWorldlineQ[ g, Take[ m, { cuts[[ i ]], cuts[[ i + 1 ]] } ] ] ] ] ];

$fromQ = { g, p } |-> With[ { members = RandomInfraWorldline[ g, InfraWorldline[ p ], All ], future = VertexOutComponent[ g, { p } ] },
  { height = Max[ InfraMeasurement[ g, InfraWorldline[ p, # ], "Length" ] & /@ future ] },
  InfraMeasurement[ g, InfraWorldline[ p ], "Length" ] == height &&
    InfraMeasurement[ g, InfraWorldline[ p ], "Cardinality" ] == Length @ members &&
    Sort @ members === Sort @ Catenate[ Select[ $longestPaths[ g, p, # ], Length @ # == height + 1 & ] & /@ future ] &&
    InfraWorldlineQ[ g, members ] ];

$comparablePairs = g |-> Select[ Tuples[ VertexList @ g, 2 ], pair |-> MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] ];

$paths = { g, p, q } |-> If[ p === q, { { p } }, FindPath[ g, p, q, Infinity, All ] ];

$saturatedQ = { g, path } |-> AllTrue[ Partition[ path, 2, 1 ], pair |-> FindPath[ g, First @ pair, Last @ pair, { 2, Infinity } ] === { } ];

$longestPaths = { g, p, q } |-> With[ { paths = $paths[ g, p, q ] }, Select[ paths, Length @ # == Max[ Length /@ paths ] & ] ];

$sourceSinkPaths = g |-> Catenate @ Catenate @ Outer[ $paths[ g, #1, #2 ] &,
  Pick[ VertexList @ g, VertexInDegree @ g, 0 ], Pick[ VertexList @ g, VertexOutDegree @ g, 0 ], 1 ];

$negatedDistance = { g, p, q } |-> - GraphDistance[ Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount @ g ] ], p, q ];

$cardinalityQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  InfraMeasurement[ g, InfraWorldline @@ pair, "Cardinality" ] == Length @ RandomInfraWorldline[ g, InfraWorldline @@ pair, All ] ];

$longestQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  Sort @ RandomInfraWorldline[ g, InfraWorldline @@ pair, All ] === Sort @ $longestPaths[ g, First @ pair, Last @ pair ] ];

$membersQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  With[ { members = RandomInfraWorldline[ g, InfraWorldline @@ pair, All ], length = InfraMeasurement[ g, InfraWorldline @@ pair, "Length" ] },
    AllTrue[ members, m |-> InfraChainQ[ g, m ] && Length @ m - 1 == length ] && InfraWorldlineQ[ g, members ] ] ];

$lengthQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  InfraMeasurement[ g, InfraWorldline @@ pair, "Length" ] == $negatedDistance[ g, First @ pair, Last @ pair ] ];

$globalQ = g |-> With[ { height = Max @ UniversalTime @ g },
  InfraMeasurement[ g, InfraWorldline[ ], "Length" ] == height &&
    Sort @ RandomInfraWorldline[ g, All ] === Sort @ Select[ $sourceSinkPaths @ g, Length @ # - 1 == height & ] ];

$observerQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  Sort @ RandomInfraObserver[ g, InfraObserver @@ pair, All ] === Sort @ Select[ $paths[ g, First @ pair, Last @ pair ], path |-> $saturatedQ[ g, path ] ] ];

$observerContainsQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  With[ { observers = RandomInfraObserver[ g, InfraObserver @@ pair, All ] },
    SubsetQ[ observers, RandomInfraWorldline[ g, InfraWorldline @@ pair, All ] ] && InfraObserverQ[ g, observers ] &&
      InfraMeasurement[ g, InfraObserver @@ pair, "Cardinality" ] == Length @ observers ] ];

$observerLengthQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  InfraMeasurement[ g, InfraObserver @@ pair, "Length" ] ===
    Replace[ Union[ Length /@ RandomInfraObserver[ g, InfraObserver @@ pair, All ] - 1 ], { one_ } :> one ] ];

$inextendibleQ = g |-> Sort @ RandomInfraObserver[ g, All ] === Sort @ Select[ $sourceSinkPaths @ g, path |-> $saturatedQ[ g, path ] ];

$memberQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  With[ { worldlines = RandomInfraWorldline[ g, InfraWorldline @@ pair, All ] },
    AllTrue[ RandomInfraObserver[ g, InfraObserver @@ pair, All ],
      path |-> InfraMemberQ[ g, InfraWorldline @@ pair, path ] === MemberQ[ worldlines, path ] ] ] ];

VerificationTest[ $cardinalityQ[ $twoSource ], True, TestID -> "InfraWorldline-TwoSource-cardinality-counts-members" ]

VerificationTest[ $cardinalityQ[ $diamond ], True, TestID -> "InfraWorldline-Diamond-cardinality-counts-members" ]

VerificationTest[ $cardinalityQ[ $cylinder ], True, TestID -> "InfraWorldline-Cylinder-cardinality-counts-members" ]

VerificationTest[ $longestQ[ $diamond ], True, TestID -> "InfraWorldline-Diamond-members-are-longest-paths" ]

VerificationTest[ $longestQ[ $cylinder ], True, TestID -> "InfraWorldline-Cylinder-members-are-longest-paths" ]

VerificationTest[ $longestQ[ $shortcut ], True, TestID -> "InfraWorldline-Shortcut-members-are-longest-paths" ]

VerificationTest[ $membersQ[ $twoSource ], True, TestID -> "InfraWorldline-TwoSource-members-are-chains-of-length" ]

VerificationTest[ $membersQ[ $diamond ], True, TestID -> "InfraWorldline-Diamond-members-are-chains-of-length" ]

VerificationTest[ $membersQ[ $cylinder ], True, TestID -> "InfraWorldline-Cylinder-members-are-chains-of-length" ]

VerificationTest[ $lengthQ[ $diamond ], True, TestID -> "InfraWorldline-Diamond-length-is-negated-weighted-distance" ]

VerificationTest[ $lengthQ[ $cylinder ], True, TestID -> "InfraWorldline-Cylinder-length-is-negated-weighted-distance" ]

VerificationTest[ $lengthQ[ $shortcut ], True, TestID -> "InfraWorldline-Shortcut-length-is-negated-weighted-distance" ]

VerificationTest[
  InfraMeasurement[ $diamond, InfraWorldline[ { 0, 0 }, { 3, 3 } ], "Cardinality" ],
  Binomial[ 2 3, 3 ],
  TestID -> "InfraWorldline-Diamond-corner-to-corner-central-binomial"
]

VerificationTest[
  AllTrue[ $comparablePairs @ $diamond, pair |->
    InfraMeasurement[ $diamond, InfraWorldline @@ pair, "Cardinality" ] == Binomial[ Total[ Last @ pair - First @ pair ], First[ Last @ pair - First @ pair ] ] ],
  True,
  TestID -> "InfraWorldline-Diamond-cardinality-binomial"
]

VerificationTest[ $globalQ[ $twoSource ], True, TestID -> "InfraWorldline-TwoSource-global-longest-chains" ]

VerificationTest[ $globalQ[ $cylinder ], True, TestID -> "InfraWorldline-Cylinder-global-longest-chains" ]

VerificationTest[ $globalQ[ $shortcut ], True, TestID -> "InfraWorldline-Shortcut-global-longest-chains" ]

VerificationTest[ $observerQ[ $diamond ], True, TestID -> "InfraObserver-Diamond-members-are-saturated-paths" ]

VerificationTest[ $observerQ[ $shortcut ], True, TestID -> "InfraObserver-Shortcut-members-are-saturated-paths" ]

VerificationTest[ $observerContainsQ[ $diamond ], True, TestID -> "InfraObserver-Diamond-contains-worldlines" ]

VerificationTest[ $observerContainsQ[ $shortcut ], True, TestID -> "InfraObserver-Shortcut-contains-worldlines" ]

VerificationTest[ $observerLengthQ[ $shortcut ], True, TestID -> "InfraObserver-Shortcut-length-is-member-lengths" ]

VerificationTest[ InfraMeasurement[ $shortcut, InfraObserver[ 1, 4 ], "Length" ], { 2, 3 }, TestID -> "InfraObserver-Shortcut-two-proper-times" ]

VerificationTest[ $inextendibleQ[ $twoSource ], True, TestID -> "InfraObserver-TwoSource-inextendible-saturated-chains" ]

VerificationTest[ $inextendibleQ[ $cylinder ], True, TestID -> "InfraObserver-Cylinder-inextendible-saturated-chains" ]

VerificationTest[
  { InfraChainQ[ $shortcut, { 1, 3, 4 } ], InfraObserverQ[ $shortcut, { 1, 3, 4 } ],
    InfraChainQ[ $diamond, { { 0, 0 }, { 1, 1 } } ], InfraObserverQ[ $diamond, { { 0, 0 }, { 1, 1 } } ] },
  { True, False, True, False },
  TestID -> "InfraObserverQ-Shortcut-Diamond-rejects-unsaturated-chain"
]

VerificationTest[
  { InfraObserverQ[ $shortcut, { 1, 5, 4 } ], InfraWorldlineQ[ $shortcut, { 1, 5, 4 } ], InfraChainQ[ $twoSource, { 1, 2 } ], InfraChainQ[ $twoSource, { 3, 1 } ] },
  { True, False, False, False },
  TestID -> "InfraWorldlineQ-Shortcut-rejects-short-observer"
]

VerificationTest[ $memberQ[ $diamond ], True, TestID -> "InfraWorldline-Diamond-InfraMemberQ-agrees-with-sampler" ]

VerificationTest[ $memberQ[ $shortcut ], True, TestID -> "InfraWorldline-Shortcut-InfraMemberQ-agrees-with-sampler" ]

VerificationTest[
  With[ { all = RandomInfraWorldline[ $diamond, InfraWorldline[ { 0, 0 }, { 3, 3 } ], All ] },
    { Length @ ( SeedRandom[ 2 ]; RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 }, 7 ] ),
      Length @ DeleteDuplicates @ ( SeedRandom[ 2 ]; RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 }, 7 ] ),
      SubsetQ[ all, ( SeedRandom[ 2 ]; RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 }, 7 ] ) ],
      RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 }, 21 ],
      Length @ RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 }, UpTo[ 30 ] ],
      MemberQ[ all, ( SeedRandom[ 2 ]; RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 } ] ) ],
      RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 }, 3, "NextVertexFunction" -> Identity ] === Take[ Sort @ all, 3 ] } ],
  { 7, 7, True, { }, 20, True, True },
  TestID -> "RandomInfraWorldline-Diamond-count-contract"
]

VerificationTest[
  ( SeedRandom[ 1 ]; RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 }, 3 ] ) === ( SeedRandom[ 1 ]; RandomInfraWorldline[ $diamond, { 0, 0 }, { 3, 3 }, 3 ] ),
  True,
  TestID -> "RandomInfraWorldline-Diamond-reproducible"
]

VerificationTest[
  With[ { g = Graph[ { 1 -> 2, 1 -> 3, 2 -> 4, 3 -> 5, 3 -> 6, 4 -> 7, 5 -> 7, 6 -> 7 } ] },
    BlockRandom[ SeedRandom[ 3 ];
      Abs[ Count[ Table[ RandomInfraObserver[ g, 1, 7 ], 1500 ], { 1, 2, 4, 7 } ] / 1500. - 1 / 3 ] < 0.04 ] ],
  True,
  TestID -> "RandomInfraObserver-Branching-uniform-over-members"
]

VerificationTest[
  Values @ InfraMeasurement[ $lattice, InfraWorldline @@ $knots, { "Cardinality", "Length" } ],
  { Binomial[ 3, 1 ] Binomial[ 5, 2 ], 3 + 5 },
  TestID -> "InfraWorldline-Lattice-polyline-product-cardinality-and-summed-length"
]

VerificationTest[ $polylineQ[ $lattice, $knots ], True, TestID -> "InfraWorldline-Lattice-polyline-members-concatenate-leg-worldlines" ]

VerificationTest[
  $polylineQ[ $lattice, { { 0, 0 }, { 1, 1 }, { 2, 1 }, { 4, 4 } } ] && $polylineQ[ $cylinder, { { 0, 0 }, { 1, 1 }, { 1, 3 } } ] && $polylineQ[ $shortcut, { 1, 3, 4 } ],
  True,
  TestID -> "InfraWorldline-Lattice-Cylinder-Shortcut-polyline-members-concatenate-leg-worldlines"
]

VerificationTest[
  With[ { members = RandomInfraWorldline[ $lattice, InfraWorldline @@ $knots, All ] },
    AllTrue[ RandomInfraObserver[ $lattice, InfraObserver[ { 0, 0 }, { 4, 4 } ], All ],
      path |-> InfraMemberQ[ $lattice, InfraWorldline @@ $knots, path ] === MemberQ[ members, path ] ] ],
  True,
  TestID -> "InfraWorldline-Lattice-polyline-InfraMemberQ-agrees-with-sampler"
]

VerificationTest[
  With[ { bad = InfraWorldline[ { 0, 0 }, { 4, 4 }, { 2, 1 } ] },
    { RandomInfraWorldline[ $lattice, bad, All ], RandomInfraWorldline[ $lattice, bad ], InfraMeasurement[ $lattice, bad, "Cardinality" ] } ],
  { { }, { }, 0 },
  TestID -> "InfraWorldline-Lattice-non-monotone-knots-empty-family"
]

VerificationTest[
  With[ { members = RandomInfraWorldline[ $lattice, InfraWorldline[ { 1, 1 } ], All ] },
    { Length @ members, Union[ Last /@ members ], Union[ Length /@ members ] - 1, InfraMeasurement[ $lattice, InfraWorldline[ { 1, 1 } ], "Length" ] } ],
  { 20, { { 4, 4 } }, { 6 }, 6 },
  TestID -> "InfraWorldline-Lattice-from-event-twenty-longest-chains-to-the-top"
]

VerificationTest[
  $fromQ[ $lattice, { 1, 1 } ] && $fromQ[ $cylinder, { 0, 0 } ] && $fromQ[ $shortcut, 1 ] && $fromQ[ $twoSource, 1 ] &&
    $fromQ[ Graph[ { 1 -> 2, 2 -> 3, 1 -> 4, 4 -> 5, 1 -> 6 } ], 1 ],
  True,
  TestID -> "InfraWorldline-Lattice-Cylinder-Shortcut-TwoSource-Branching-from-event-longest-chains"
]

VerificationTest[
  { RandomInfraWorldline[ $twoSource, InfraWorldline[ 2 ], All ], RandomInfraWorldline[ $twoSource, InfraWorldline[ 5 ], All ] },
  { { { 2, 4, 5 } }, { { 5 } } },
  TestID -> "InfraWorldline-TwoSource-from-event-literal"
]

VerificationTest[
  With[ { members = RandomInfraWorldline[ $lattice, InfraWorldline[ { 1, 1 } ], All ] },
    AllTrue[ members, InfraMemberQ[ $lattice, InfraWorldline[ { 1, 1 } ], # ] & ] &&
      ! InfraMemberQ[ $lattice, InfraWorldline[ { 1, 1 } ], { { 1, 1 }, { 2, 1 }, { 3, 1 } } ] ],
  True,
  TestID -> "InfraWorldline-Lattice-from-event-InfraMemberQ-agrees-with-sampler"
]

EndTestSection[]
