BeginTestSection["InfraCausalFuture"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$fixtures = <| "TwoSource" -> $twoSource, "Diamond" -> $diamond, "Cylinder" -> $cylinder |>;

$tau = { g, v, e } |-> Max[ Length /@ FindPath[ g, v, e, Infinity, All ] ] - 1;

$upSetQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { cone = RandomInfraCausalFuture[ g, v ] },
    MemberQ[ cone, v ] && SubsetQ[ cone, Catenate[ VertexOutComponent[ g, { # }, 1 ] & /@ cone ] ] ] ];

$downSetQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { cone = RandomInfraCausalPast[ g, v ] },
    MemberQ[ cone, v ] && SubsetQ[ cone, Catenate[ VertexInComponent[ g, { # }, 1 ] & /@ cone ] ] ] ];

$futureCutQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { future = VertexOutComponent[ g, { v } ] },
    AllTrue[ Range[ 0, VertexCount @ g ], t |->
      Keys @ InfraMeasurement[ g, InfraCausalFuture[ v, t ], "VertexDensity" ] ===
        Sort @ Select[ future, e |-> $tau[ g, v, e ] <= t ] ] ] ];

$pastCutQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { past = VertexInComponent[ g, { v } ] },
    AllTrue[ Range[ 0, VertexCount @ g ], t |->
      Keys @ InfraMeasurement[ g, InfraCausalPast[ v, t ], "VertexDensity" ] ===
        Sort @ Select[ past, e |-> $tau[ g, e, v ] <= t ] ] ] ];

$subgraphQ = g |-> AllTrue[ VertexList @ g, v |->
  IsomorphicGraphQ[ InfraMeasurement[ g, InfraCausalFuture[ v ], "Subgraph" ], VertexOutComponentGraph[ g, { v } ] ] &&
    InfraMeasurement[ g, InfraCausalFuture[ v ], "CountingMeasure" ] == VertexCount @ VertexOutComponentGraph[ g, { v } ] ];

$singleMemberQ = g |-> AllTrue[ VertexList @ g, v |->
  RandomInfraCausalFuture[ g, InfraCausalFuture[ v ], All ] === { RandomInfraCausalFuture[ g, v ] } &&
    Length @ RandomInfraCausalFuture[ g, InfraCausalFuture[ v ], All ] == InfraMeasurement[ g, InfraCausalFuture[ v ], "Cardinality" ] &&
    RandomInfraCausalPast[ g, InfraCausalPast[ v ], All ] === { RandomInfraCausalPast[ g, v ] } ];

VerificationTest[ $upSetQ[ $twoSource ], True, TestID -> "InfraCausalFuture-TwoSource-up-set-containing-v" ]

VerificationTest[ $upSetQ[ $diamond ], True, TestID -> "InfraCausalFuture-Diamond-up-set-containing-v" ]

VerificationTest[ $upSetQ[ $cylinder ], True, TestID -> "InfraCausalFuture-Cylinder-up-set-containing-v" ]

VerificationTest[ $downSetQ[ $twoSource ], True, TestID -> "InfraCausalPast-TwoSource-down-set-containing-v" ]

VerificationTest[ $downSetQ[ $diamond ], True, TestID -> "InfraCausalPast-Diamond-down-set-containing-v" ]

VerificationTest[ $downSetQ[ $cylinder ], True, TestID -> "InfraCausalPast-Cylinder-down-set-containing-v" ]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |-> InfraCausalFutureQ[ g, RandomInfraCausalFuture[ g, v ] ] ] ],
  True,
  TestID -> "InfraCausalFutureQ-All-accepts-sampled-futures"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |-> InfraCausalPastQ[ g, RandomInfraCausalPast[ g, v ] ] ] ],
  True,
  TestID -> "InfraCausalPastQ-All-accepts-sampled-pasts"
]

VerificationTest[ InfraCausalFutureQ[ $twoSource, { 1, 2 } ], False, TestID -> "InfraCausalFutureQ-TwoSource-two-sources-rejected" ]

VerificationTest[ InfraCausalPastQ[ $twoSource, { 1, 2 } ], False, TestID -> "InfraCausalPastQ-TwoSource-two-sources-rejected" ]

VerificationTest[
  RandomInfraCausalFuture[ $twoSource, { 1, 2 } ] === Union[ VertexOutComponent[ $twoSource, { 1 } ], VertexOutComponent[ $twoSource, { 2 } ] ],
  True,
  TestID -> "InfraCausalFuture-TwoSource-set-anchor-is-union"
]

VerificationTest[ $futureCutQ[ $twoSource ], True, TestID -> "InfraCausalFuture-TwoSource-proper-time-cut" ]

VerificationTest[ $futureCutQ[ $diamond ], True, TestID -> "InfraCausalFuture-Diamond-proper-time-cut" ]

VerificationTest[ $futureCutQ[ $cylinder ], True, TestID -> "InfraCausalFuture-Cylinder-proper-time-cut" ]

VerificationTest[ $pastCutQ[ $diamond ], True, TestID -> "InfraCausalPast-Diamond-proper-time-cut" ]

VerificationTest[
  AllTrue[ VertexList @ $diamond, v |->
    AllTrue[ Range[ 0, 6 ], t |->
      AllTrue[ Keys @ InfraMeasurement[ $diamond, InfraCausalFuture[ v, t ], "VertexDensity" ],
        e |-> UniversalTime[ InfraMeasurement[ $diamond, InfraCausalFuture[ v ], "Subgraph" ] ][ e ] <= t ] ] ],
  True,
  TestID -> "InfraCausalFuture-Diamond-cut-universal-time-bounded"
]

VerificationTest[
  AllTrue[ Tuples[ { Range[ 0, 3 ], Range[ 0, 3 ] } ], v |-> Length @ RandomInfraCausalFuture[ $diamond, v ] == ( 4 - First @ v ) ( 4 - Last @ v ) ],
  True,
  TestID -> "InfraCausalFuture-Diamond-volume-is-rectangle"
]

VerificationTest[ $subgraphQ[ $twoSource ], True, TestID -> "InfraCausalFuture-TwoSource-subgraph-and-counting-measure" ]

VerificationTest[ $subgraphQ[ $diamond ], True, TestID -> "InfraCausalFuture-Diamond-subgraph-and-counting-measure" ]

VerificationTest[ $subgraphQ[ $cylinder ], True, TestID -> "InfraCausalFuture-Cylinder-subgraph-and-counting-measure" ]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |->
    InfraMemberQ[ g, InfraCausalFuture[ v ], Reverse @ RandomInfraCausalFuture[ g, v ] ] &&
      ! InfraMemberQ[ g, InfraCausalFuture[ v ], Most @ RandomInfraCausalFuture[ g, v ] ] ] ],
  True,
  TestID -> "InfraCausalFuture-All-member-is-the-support"
]

VerificationTest[ AllTrue[ $fixtures, $singleMemberQ ], True, TestID -> "RandomInfraCausalFuture-All-single-member" ]

VerificationTest[
  AllTrue[ VertexList @ $diamond, v |->
    With[ { reading = InfraMeasurement[ $diamond, InfraCausalFuture[ v ], All ] },
      reading[ "CountingMeasure" ] == Total @ reading[ "VertexDensity" ] &&
        Sort @ Keys @ reading[ "EdgeDensity" ] === Sort @ EdgeList @ reading[ "Subgraph" ] ] ],
  True,
  TestID -> "InfraCausalFuture-Diamond-readings-agree"
]

EndTestSection[]
