BeginTestSection["InfraObserver"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$shortcut = Graph[ { 1 -> 2, 2 -> 3, 3 -> 4, 1 -> 5, 5 -> 4, 1 -> 3 } ];

$comparablePairs = g |-> Select[ Tuples[ VertexList @ g, 2 ], pair |-> MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] ];

$paths = { g, p, q } |-> If[ p === q, { { p } }, FindPath[ g, p, q, Infinity, All ] ];

$saturatedQ = { g, path } |-> AllTrue[ Partition[ path, 2, 1 ], pair |-> FindPath[ g, First @ pair, Last @ pair, { 2, Infinity } ] === { } ];

$sourceSinkPaths = g |-> Catenate @ Catenate @ Outer[ $paths[ g, #1, #2 ] &,
  Pick[ VertexList @ g, VertexInDegree @ g, 0 ], Pick[ VertexList @ g, VertexOutDegree @ g, 0 ], 1 ];

$observerQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  Sort @ RandomInfraObserver[ g, InfraObserver @@ pair, All ] === Sort @ Select[ $paths[ g, First @ pair, Last @ pair ], path |-> $saturatedQ[ g, path ] ] ];

$observerContainsQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  With[ { observers = RandomInfraObserver[ g, InfraObserver @@ pair, All ] },
    SubsetQ[ observers, RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic @@ pair, All ] ] && InfraObserverQ[ g, observers ] &&
      InfraMeasurement[ g, InfraObserver @@ pair, "Cardinality" ] == Length @ observers ] ];

$observerLengthQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  InfraMeasurement[ g, InfraObserver @@ pair, "Length" ] ===
    Replace[ Union[ Length /@ RandomInfraObserver[ g, InfraObserver @@ pair, All ] - 1 ], { one_ } :> one ] ];

$inextendibleQ = g |-> Sort @ RandomInfraObserver[ g, All ] === Sort @ Select[ $sourceSinkPaths @ g, path |-> $saturatedQ[ g, path ] ];

VerificationTest[ $observerQ[ $diamond ], True, TestID -> "InfraObserver-Diamond-members-are-saturated-paths" ]

VerificationTest[ $observerQ[ $shortcut ], True, TestID -> "InfraObserver-Shortcut-members-are-saturated-paths" ]

VerificationTest[ $observerContainsQ[ $diamond ], True, TestID -> "InfraObserver-Diamond-contains-timelike-geodesics" ]

VerificationTest[ $observerContainsQ[ $shortcut ], True, TestID -> "InfraObserver-Shortcut-contains-timelike-geodesics" ]

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
  With[ { g = Graph[ { 1 -> 2, 1 -> 3, 2 -> 4, 3 -> 5, 3 -> 6, 4 -> 7, 5 -> 7, 6 -> 7 } ] },
    BlockRandom[ SeedRandom[ 3 ];
      Abs[ Count[ Table[ RandomInfraObserver[ g, 1, 7 ], 1500 ], { 1, 2, 4, 7 } ] / 1500. - 1 / 3 ] < 0.04 ] ],
  True,
  TestID -> "RandomInfraObserver-Branching-uniform-over-members"
]

EndTestSection[]
